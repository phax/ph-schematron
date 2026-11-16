/*
 * Copyright (C) 2014-2026 Philip Helger (www.helger.com)
 * philip[at]helger[dot]com
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *         http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.helger.schematron.streamability;

import java.util.BitSet;
import java.util.List;
import java.util.Locale;
import java.util.regex.Pattern;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.string.StringHelper;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.CommonsHashMap;
import com.helger.collection.commons.ICommonsList;
import com.helger.collection.commons.ICommonsMap;
import com.helger.io.resource.IReadableResource;
import com.helger.phoxtrot.xdm.XdmQName;
import com.helger.phoxtrot.xpath.EStreamContextMode;
import com.helger.phoxtrot.xpath.EStreamabilityVerdict;
import com.helger.phoxtrot.xpath.XPathException;
import com.helger.phoxtrot.xpath.XPathStreamabilityAnalyzer;
import com.helger.phoxtrot.xpath.XPathStreamabilityBinding;
import com.helger.phoxtrot.xpath.XPathStreamabilityReason;
import com.helger.phoxtrot.xpath.XPathStreamabilityResult;
import com.helger.phoxtrot.xpath.ast.SeqType;
import com.helger.phoxtrot.xpath.context.StaticContext;
import com.helger.phoxtrot.xpath.fn.FunctionLibrary;
import com.helger.phoxtrot.xpath.stream.EStreamFunctionCategory;
import com.helger.schematron.CSchematron;
import com.helger.schematron.exchange.PSReader;
import com.helger.schematron.exchange.SchematronReadException;
import com.helger.schematron.model.AbstractPSPatternLike;
import com.helger.schematron.model.PSAssertReport;
import com.helger.schematron.model.PSDiagnostic;
import com.helger.schematron.model.PSDiagnostics;
import com.helger.schematron.model.PSGroup;
import com.helger.schematron.model.PSLet;
import com.helger.schematron.model.PSNS;
import com.helger.schematron.model.PSName;
import com.helger.schematron.model.PSParam;
import com.helger.schematron.model.PSPattern;
import com.helger.schematron.model.PSPhase;
import com.helger.schematron.model.PSRule;
import com.helger.schematron.model.PSRules;
import com.helger.schematron.model.PSSchema;
import com.helger.schematron.model.PSValueOf;
import com.helger.schematron.preprocess.PSPreprocessor;
import com.helger.schematron.preprocess.SchematronPreprocessException;
import com.helger.xml.microdom.IMicroElement;

/**
 * Tells per rule whether a Schematron can be validated while streaming the instance document, with the burst
 * streamability analysis of phoxtrot (<code>XPathStreamabilityAnalyzer</code> in
 * {@link EStreamContextMode#BURST}). The analysis is a property of the schema, not of an engine or an XSLT processor,
 * so the report holds for every engine.
 * <ul>
 * <li>The schema is preprocessed first (includes, abstract patterns and rules, <code>extends</code>).</li>
 * <li>A rule context is an XSLT pattern: {@link EStreamabilityClass#MOTIONLESS} if it can be matched on the streamed
 * node alone, {@link EStreamabilityClass#BURST} if a predicate reads only the subtree of the node, else
 * {@link EStreamabilityClass#NON_LOCAL}.</li>
 * <li>The tests of assertions and reports, the <code>sch:value-of</code> and <code>sch:name</code> of their messages
 * and of the diagnostics they reference, and the rule's <code>sch:let</code>s are analysed with the rule context as
 * context, as the host evaluates them (effective boolean value of a test, atomised value of a
 * <code>sch:value-of</code>). The <code>sch:let</code>s of the rule an expression uses are bound around it as XPath
 * <code>let</code> clauses would be, so their values are analysed where they are used; each value is compiled once per
 * rule.</li>
 * <li>The <code>sch:let</code>s of the schema, the phases and the patterns are computed once with the document node as
 * context: one that reads the instance needs a first pass and is {@link EStreamabilityClass#NON_LOCAL}; a rule may
 * compare its value, but navigating from its nodes is non-local. One that does not read the instance (a literal, a
 * value of another document) is {@link EStreamabilityClass#MOTIONLESS}.</li>
 * <li><code>xsl:function</code> elements of the schema are only known by their <code>streamability</code> attribute;
 * a call of a function without it, of an extension function, and <code>key ()</code> or <code>id ()</code> over the
 * instance are {@link EStreamabilityClass#NON_LOCAL}.</li>
 * <li>Constructs the analysis does not cover (<code>sch:group</code>, <code>pattern/@documents</code>,
 * <code>rule/@visit-each</code>, a <code>sch:let</code> with element content) and expressions with a static error are
 * {@link EStreamabilityClass#NON_LOCAL}: the analysis fails closed.</li>
 * </ul>
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@Immutable
public final class SchematronStreamabilityAnalyzer
{
  /**
   * The error code of a call of an unknown function (XSLT 3.0 section 3.9.1), so that calls of extension functions and
   * <code>xsl:function</code>s compile; the analysis then treats them as not streamable.
   */
  private static final String UNKNOWN_FUNCTION_ERROR_CODE = "XTDE1425";

  /** The reason phoxtrot gives when the <code>let</code> clauses as a whole decide the verdict */
  private static final String REASON_LET_EXPRESSION = "expression let";

  private SchematronStreamabilityAnalyzer ()
  {}

  @NonNull
  private static EStreamabilityClass _getClass (@NonNull final EStreamabilityVerdict eVerdict)
  {
    return switch (eVerdict)
    {
      case MOTIONLESS -> EStreamabilityClass.MOTIONLESS;
      case CONSUMING, BURST -> EStreamabilityClass.BURST;
      case FREE_RANGING -> EStreamabilityClass.NON_LOCAL;
    };
  }

  @Nullable
  private static String _getReasonText (@NonNull final XPathStreamabilityResult aResult)
  {
    final XPathStreamabilityReason aReason = aResult.getReason ();
    if (aReason == null)
      return null;
    return aReason.construct ().name ().toLowerCase (Locale.ROOT).replace ('_', ' ') + " " + aReason.name ();
  }

  /**
   * @return The QName of a variable or function name as written in the schema, with the prefix resolved through the
   *         <code>sch:ns</code> declarations. An unknown prefix gives a name without namespace.
   */
  @NonNull
  private static XdmQName _getQName (@NonNull final String sName, @NonNull final StaticContext aSC)
  {
    final int nColon = sName.indexOf (':');
    if (nColon > 0)
    {
      final String sNamespaceUri = aSC.getNamespaceUri (sName.substring (0, nColon));
      if (sNamespaceUri != null)
        return new XdmQName (sNamespaceUri, sName.substring (nColon + 1));
    }
    return new XdmQName (sName);
  }

  @NonNull
  private static StreamabilityExpression _analyzeExpression (@NonNull final EStreamabilityExpressionType eType,
                                                             @Nullable final String sLabel,
                                                             @NonNull final String sExpression,
                                                             @NonNull final String sAnalysedExpression,
                                                             @NonNull final XPathStreamabilityAnalyzer aAnalyzer,
                                                             @NonNull final StaticContext aSC)
  {
    try
    {
      final XPathStreamabilityResult aResult = aAnalyzer.analyze (sAnalysedExpression, aSC);
      final EStreamabilityClass eClass = _getClass (aResult.getVerdict ());
      return new StreamabilityExpression (eType,
                                          sLabel,
                                          sExpression,
                                          eClass,
                                          eClass == EStreamabilityClass.MOTIONLESS ? null : _getReasonText (aResult));
    }
    catch (final XPathException ex)
    {
      return new StreamabilityExpression (eType,
                                          sLabel,
                                          sExpression,
                                          EStreamabilityClass.NON_LOCAL,
                                          "static error " + ex.getMessage ());
    }
  }

  @NonNull
  private static StreamabilityExpression _analyzeRuleContext (@NonNull final String sContext,
                                                              @NonNull final XPathStreamabilityAnalyzer aAnalyzer,
                                                              @NonNull final StaticContext aSC)
  {
    try
    {
      final XPathStreamabilityResult aResult = aAnalyzer.analyzePattern (sContext, aSC);
      final EStreamabilityClass eClass = _getClass (aResult.getVerdict ());
      return new StreamabilityExpression (EStreamabilityExpressionType.RULE_CONTEXT,
                                          null,
                                          sContext,
                                          eClass,
                                          eClass == EStreamabilityClass.MOTIONLESS ? null : _getReasonText (aResult));
    }
    catch (final XPathException ex)
    {
      return new StreamabilityExpression (EStreamabilityExpressionType.RULE_CONTEXT,
                                          null,
                                          sContext,
                                          EStreamabilityClass.NON_LOCAL,
                                          "static error " + ex.getMessage ());
    }
  }

  /**
   * @return The pattern that finds a reference to the variable in an expression. A match in a string literal also
   *         counts, which can only make the analysis more conservative.
   */
  @NonNull
  private static Pattern _getVariableReferencePattern (@NonNull final String sName)
  {
    return Pattern.compile ("\\$\\s*" + Pattern.quote (sName) + "(?![\\w.\\-:])", Pattern.UNICODE_CHARACTER_CLASS);
  }

  /**
   * The settings of a schema that every static context and every analyser of it gets. phoxtrot puts all variables
   * bound on an analyser around every expression it analyses, used or not, so an expression that uses
   * <code>sch:let</code>s of its rule gets an analyser of its own with only these.
   */
  private static final class SchemaSettings
  {
    private record FunctionDeclaration (@NonNull XdmQName name,
                                        @NonNull EStreamFunctionCategory category,
                                        @NonNull ICommonsList <SeqType> paramTypes)
    {}

    private final FunctionLibrary m_aFunctionLibrary = FunctionLibrary.createDefaultWithXsltSignatures ();
    private final ICommonsList <PSNS> m_aNSs;
    private final ICommonsList <XdmQName> m_aVariables = new CommonsArrayList <> ();
    private final ICommonsList <FunctionDeclaration> m_aFunctions = new CommonsArrayList <> ();
    private final ICommonsList <XdmQName> m_aExternalNodeVariables = new CommonsArrayList <> ();

    SchemaSettings (@NonNull final ICommonsList <PSNS> aNSs)
    {
      m_aNSs = aNSs;
    }

    void addVariable (@NonNull final XdmQName aName)
    {
      m_aVariables.add (aName);
    }

    void addFunction (@NonNull final XdmQName aName,
                      @NonNull final EStreamFunctionCategory eCategory,
                      @NonNull final ICommonsList <SeqType> aParamTypes)
    {
      m_aFunctions.add (new FunctionDeclaration (aName, eCategory, aParamTypes));
    }

    void addExternalNodeVariable (@NonNull final XdmQName aName)
    {
      m_aExternalNodeVariables.add (aName);
    }

    /**
     * @return A new static context with the namespaces and the variables added so far.
     */
    @NonNull
    StaticContext createStaticContext ()
    {
      final StaticContext ret = new StaticContext ().setFunctionLibrary (m_aFunctionLibrary)
                                                    .setUnknownFunctionErrorCode (UNKNOWN_FUNCTION_ERROR_CODE);
      for (final PSNS aNS : m_aNSs)
        ret.declareNamespace (aNS.getPrefix (), aNS.getUri ());
      for (final XdmQName aName : m_aVariables)
        ret.declareVariable (aName);
      return ret;
    }

    /**
     * @return A new analyser in burst mode with the functions and the external node variables added so far.
     */
    @NonNull
    XPathStreamabilityAnalyzer createAnalyzer ()
    {
      final XPathStreamabilityAnalyzer ret = new XPathStreamabilityAnalyzer ().setContextMode (EStreamContextMode.BURST);
      for (final FunctionDeclaration aFunction : m_aFunctions)
        ret.addFunction (aFunction.name (), aFunction.category (), aFunction.paramTypes ());
      for (final XdmQName aName : m_aExternalNodeVariables)
        ret.addExternalNodeVariable (aName);
      return ret;
    }
  }

  /**
   * The <code>sch:let</code>s of a rule, with the reference pattern of each, the transitive closure of the
   * <code>sch:let</code>s each one uses and the compiled value of each, so that all are computed only once per rule.
   */
  private static final class RuleLets
  {
    private final List <PSLet> m_aLets;
    private final Pattern [] m_aPatterns;
    /** For each let the indices of itself and of the earlier lets its value uses, directly or indirectly */
    private final BitSet [] m_aClosures;
    private final XdmQName [] m_aNames;
    /** The compiled value of each let; <code>null</code> for element content or a static error */
    private final XPathStreamabilityBinding [] m_aBindings;
    /** The static error of the value of each let, if any */
    private final String [] m_aBindingErrors;

    RuleLets (@NonNull final List <PSLet> aLets, @NonNull final StaticContext aSC)
    {
      m_aLets = aLets;
      final int nCount = aLets.size ();
      m_aPatterns = new Pattern [nCount];
      m_aClosures = new BitSet [nCount];
      m_aNames = new XdmQName [nCount];
      m_aBindings = new XPathStreamabilityBinding [nCount];
      m_aBindingErrors = new String [nCount];
      for (int i = 0; i < nCount; ++i)
      {
        final PSLet aLet = aLets.get (i);
        m_aPatterns[i] = _getVariableReferencePattern (aLet.getName ());
        final BitSet aClosure = new BitSet (nCount);
        aClosure.set (i);
        final String sValue = aLet.getValue ();
        if (sValue != null)
          for (int j = 0; j < i; ++j)
            if (m_aPatterns[j].matcher (sValue).find ())
              aClosure.or (m_aClosures[j]);
        m_aClosures[i] = aClosure;
        m_aNames[i] = _getQName (aLet.getName (), aSC);
      }
    }

    /**
     * Compile the value of a <code>sch:let</code> and declare its variable in the static context, so that the
     * <code>sch:let</code>s after it and the expressions of the rule may use it.
     */
    void bind (final int nIndex,
               @NonNull final XPathStreamabilityAnalyzer aAnalyzer,
               @NonNull final StaticContext aSC)
    {
      final String sValue = m_aLets.get (nIndex).getValue ();
      if (sValue != null)
        try
        {
          m_aBindings[nIndex] = aAnalyzer.analyzeBinding (sValue, aSC);
        }
        catch (final XPathException ex)
        {
          m_aBindingErrors[nIndex] = ex.getMessage ();
        }
      aSC.declareVariable (m_aNames[nIndex]);
    }

    /**
     * @return The indices of the <code>sch:let</code>s among the first <code>nCount</code> ones that the expression
     *         uses, directly or through another of them.
     */
    @NonNull
    BitSet getUsedLets (final int nCount, @NonNull final String sExpression)
    {
      final BitSet ret = new BitSet (nCount);
      for (int i = nCount - 1; i >= 0; --i)
        if (!ret.get (i) && m_aPatterns[i].matcher (sExpression).find ())
          ret.or (m_aClosures[i]);
      return ret;
    }
  }

  /**
   * Analyse an expression of a rule with the <code>sch:let</code>s of the rule it uses bound around it, as
   * <code>let</code> clauses would.
   *
   * @param sWrapperStart
   *        The start of the function call the host evaluates the expression with, e.g. <code>boolean(</code>.
   * @param aRuleAnalyzer
   *        The analyser of the rule, without bound variables.
   */
  @NonNull
  private static StreamabilityExpression _analyzeRuleExpression (@NonNull final EStreamabilityExpressionType eType,
                                                                 @Nullable final String sLabel,
                                                                 @NonNull final String sExpression,
                                                                 @NonNull final String sWrapperStart,
                                                                 @NonNull final RuleLets aRuleLets,
                                                                 final int nLetCount,
                                                                 @NonNull final SchemaSettings aSettings,
                                                                 @NonNull final XPathStreamabilityAnalyzer aRuleAnalyzer,
                                                                 @NonNull final StaticContext aSC)
  {
    final String sAnalysedExpression = sWrapperStart + "(" + sExpression + "))";
    final BitSet aUsedLets = aRuleLets.getUsedLets (nLetCount, sExpression);
    if (aUsedLets.isEmpty ())
      return _analyzeExpression (eType, sLabel, sExpression, sAnalysedExpression, aRuleAnalyzer, aSC);

    final XPathStreamabilityAnalyzer aAnalyzer = aSettings.createAnalyzer ();
    final StringBuilder aSB = new StringBuilder ("via sch:let");
    boolean bFirst = true;
    for (int i = aUsedLets.nextSetBit (0); i >= 0; i = aUsedLets.nextSetBit (i + 1))
    {
      final String sName = aRuleLets.m_aLets.get (i).getName ();
      if (aRuleLets.m_aBindingErrors[i] != null)
        return new StreamabilityExpression (eType,
                                            sLabel,
                                            sExpression,
                                            EStreamabilityClass.NON_LOCAL,
                                            "static error in sch:let $" + sName + ": " + aRuleLets.m_aBindingErrors[i]);
      // A let with element content stays a grounded variable
      if (aRuleLets.m_aBindings[i] != null)
        aAnalyzer.addBoundVariable (aRuleLets.m_aNames[i], aRuleLets.m_aBindings[i]);
      aSB.append (bFirst ? " $" : ", $").append (sName);
      bFirst = false;
    }

    final StreamabilityExpression ret = _analyzeExpression (eType,
                                                            sLabel,
                                                            sExpression,
                                                            sAnalysedExpression,
                                                            aAnalyzer,
                                                            aSC);
    if (!REASON_LET_EXPRESSION.equals (ret.getReason ()))
      return ret;

    // The let clauses as a whole decide: name them instead
    return new StreamabilityExpression (eType, sLabel, sExpression, ret.getStreamabilityClass (), aSB.toString ());
  }

  private static void _addUnsupportedRules (@NonNull final List <PSRule> aRules,
                                            @NonNull final ICommonsList <StreamabilityExpression> aTarget)
  {
    for (final PSRule aRule : aRules)
      if (StringHelper.isNotEmpty (aRule.getVisitEach ()))
        aTarget.add (new StreamabilityExpression (EStreamabilityExpressionType.UNSUPPORTED,
                                                  aRule.getID (),
                                                  aRule.getVisitEach (),
                                                  EStreamabilityClass.NON_LOCAL,
                                                  "rule/@visit-each is not analysed"));
  }

  private static void _addUnsupportedPatternLike (@NonNull final AbstractPSPatternLike aPatternLike,
                                                  @NonNull final ICommonsList <StreamabilityExpression> aTarget)
  {
    if (StringHelper.isNotEmpty (aPatternLike.getDocuments ()))
      aTarget.add (new StreamabilityExpression (EStreamabilityExpressionType.UNSUPPORTED,
                                                aPatternLike.getID (),
                                                aPatternLike.getDocuments (),
                                                EStreamabilityClass.NON_LOCAL,
                                                "pattern/@documents is not analysed"));
    _addUnsupportedRules (aPatternLike.getAllRules (), aTarget);
  }

  /**
   * Add the constructs of the original schema that the preprocessor drops or that the analysis does not cover.
   */
  private static void _addUnsupported (@NonNull final PSSchema aSchema,
                                       @NonNull final ICommonsList <StreamabilityExpression> aTarget)
  {
    for (final PSGroup aGroup : aSchema.getAllGroups ())
    {
      aTarget.add (new StreamabilityExpression (EStreamabilityExpressionType.UNSUPPORTED,
                                                aGroup.getID (),
                                                null,
                                                EStreamabilityClass.NON_LOCAL,
                                                "sch:group is not analysed"));
      _addUnsupportedPatternLike (aGroup, aTarget);
    }
    for (final PSPattern aPattern : aSchema.getAllPatterns ())
      _addUnsupportedPatternLike (aPattern, aTarget);
    for (final PSRules aRules : aSchema.getAllAbstractRulesContainers ())
      _addUnsupportedRules (aRules.getAllAbstractRules (), aTarget);
  }

  /**
   * @return The category of a <code>streamability</code> attribute value of <code>xsl:function</code>, or
   *         <code>null</code> for an unknown value.
   */
  @Nullable
  private static EStreamFunctionCategory _getFunctionCategory (@NonNull final String sValue)
  {
    for (final EStreamFunctionCategory e : EStreamFunctionCategory.values ())
      if (e.name ().toLowerCase (Locale.ROOT).replace ('_', '-').equals (sValue))
        return e;
    return null;
  }

  /**
   * Declare the <code>xsl:function</code>s of the schema that have a <code>streamability</code> attribute. The others
   * stay unknown, which the analysis treats as not streamable.
   */
  private static void _addFunctions (@NonNull final PSSchema aSchema,
                                     @NonNull final SchemaSettings aSettings,
                                     @NonNull final StaticContext aSC)
  {
    for (final IMicroElement eForeign : aSchema.getAllForeignElements ())
      if (CSchematron.NAMESPACE_URI_XSL.equals (eForeign.getNamespaceURI ()) && "function".equals (eForeign.getLocalName ()))
      {
        final String sName = eForeign.getAttributeValue ("name");
        final String sStreamability = eForeign.getAttributeValue ("streamability");
        if (StringHelper.isNotEmpty (sName) && StringHelper.isNotEmpty (sStreamability))
        {
          final EStreamFunctionCategory eCategory = _getFunctionCategory (sStreamability);
          if (eCategory != null)
          {
            // The parameter types are not parsed: an absent type is item()*
            final ICommonsList <SeqType> aParamTypes = new CommonsArrayList <> ();
            for (int i = eForeign.getAllChildElements (CSchematron.NAMESPACE_URI_XSL, "param").size (); i > 0; --i)
              aParamTypes.add (null);
            aSettings.addFunction (_getQName (sName, aSC), eCategory, aParamTypes);
          }
        }
      }
  }

  @NonNull
  private static StreamabilityExpression _analyzeGlobalLet (@NonNull final PSLet aLet,
                                                            @NonNull final SchemaSettings aSettings,
                                                            @NonNull final XPathStreamabilityAnalyzer aAnalyzer,
                                                            @NonNull final StaticContext aSC)
  {
    if (aLet.getValue () == null)
      return new StreamabilityExpression (EStreamabilityExpressionType.GLOBAL_LET,
                                          aLet.getName (),
                                          null,
                                          EStreamabilityClass.NON_LOCAL,
                                          "sch:let with element content is not analysed");

    // Atomised, so that a let holding the document node or other nodes of the instance counts as reading them
    final StreamabilityExpression aExpr = _analyzeExpression (EStreamabilityExpressionType.GLOBAL_LET,
                                                              aLet.getName (),
                                                              aLet.getValue (),
                                                              "data((" + aLet.getValue () + "))",
                                                              aAnalyzer,
                                                              aSC);
    if (aExpr.getStreamabilityClass () == EStreamabilityClass.MOTIONLESS)
      return aExpr;

    // Computed from the instance: the rules may compare its value, but not navigate from its nodes
    final XdmQName aName = _getQName (aLet.getName (), aSC);
    aAnalyzer.addExternalNodeVariable (aName);
    aSettings.addExternalNodeVariable (aName);
    return new StreamabilityExpression (EStreamabilityExpressionType.GLOBAL_LET,
                                        aLet.getName (),
                                        aLet.getValue (),
                                        EStreamabilityClass.NON_LOCAL,
                                        "computed from the instance in a first pass" +
                                                                        (aExpr.getReason () == null ? ""
                                                                                                    : ": " +
                                                                                                      aExpr.getReason ()));
  }

  /**
   * @return A map from diagnostic ID to diagnostic, or <code>null</code> if the schema has no diagnostics container.
   *         For duplicate IDs the first diagnostic wins, like in {@link PSDiagnostics#getDiagnosticOfID(String)}.
   */
  @Nullable
  private static ICommonsMap <String, PSDiagnostic> _getDiagnosticsByID (@Nullable final PSDiagnostics aDiagnostics)
  {
    if (aDiagnostics == null)
      return null;

    final ICommonsMap <String, PSDiagnostic> ret = new CommonsHashMap <> ();
    for (final PSDiagnostic aDiag : aDiagnostics.getAllDiagnostics ())
      if (StringHelper.isNotEmpty (aDiag.getID ()) && !ret.containsKey (aDiag.getID ()))
        ret.put (aDiag.getID (), aDiag);
    return ret;
  }

  @NonNull
  private static RuleStreamability _analyzeRule (@NonNull final PSRule aRule,
                                                 @Nullable final ICommonsMap <String, PSDiagnostic> aDiagnostics,
                                                 @NonNull final SchemaSettings aSettings)
  {
    // The sch:lets of the rule are declared in its own static context
    final StaticContext aSC = aSettings.createStaticContext ();
    final XPathStreamabilityAnalyzer aAnalyzer = aSettings.createAnalyzer ();
    final ICommonsList <StreamabilityExpression> aExpressions = new CommonsArrayList <> ();
    aExpressions.add (_analyzeRuleContext (aRule.getContext (), aAnalyzer, aSC));

    final ICommonsList <PSLet> aLets = aRule.getAllLets ();
    final int nLetCount = aLets.size ();
    final RuleLets aRuleLets = new RuleLets (aLets, aSC);
    for (int i = 0; i < nLetCount; ++i)
    {
      final PSLet aLet = aLets.get (i);
      if (aLet.getValue () == null)
        aExpressions.add (new StreamabilityExpression (EStreamabilityExpressionType.RULE_LET,
                                                       aLet.getName (),
                                                       null,
                                                       EStreamabilityClass.NON_LOCAL,
                                                       "sch:let with element content is not analysed"));
      else
      {
        // The cost of computing the value; navigating from it is part of the expressions that use it
        aExpressions.add (_analyzeRuleExpression (EStreamabilityExpressionType.RULE_LET,
                                                  aLet.getName (),
                                                  aLet.getValue (),
                                                  "count(",
                                                  aRuleLets,
                                                  i,
                                                  aSettings,
                                                  aAnalyzer,
                                                  aSC));
      }
      aRuleLets.bind (i, aAnalyzer, aSC);
    }

    for (final PSAssertReport aAssertReport : aRule.getAllAssertReports ())
    {
      final String sLabel = aAssertReport.getID ();
      if (aAssertReport.getTest () != null)
        aExpressions.add (_analyzeRuleExpression (aAssertReport.isAssert () ? EStreamabilityExpressionType.ASSERT
                                                                            : EStreamabilityExpressionType.REPORT,
                                                  sLabel,
                                                  aAssertReport.getTest (),
                                                  "boolean(",
                                                  aRuleLets,
                                                  nLetCount,
                                                  aSettings,
                                                  aAnalyzer,
                                                  aSC));
      for (final PSValueOf aValueOf : aAssertReport.getAllValueOfs ())
        aExpressions.add (_analyzeRuleExpression (EStreamabilityExpressionType.VALUE_OF,
                                                  sLabel,
                                                  aValueOf.getSelect (),
                                                  "data(",
                                                  aRuleLets,
                                                  nLetCount,
                                                  aSettings,
                                                  aAnalyzer,
                                                  aSC));
      for (final PSName aName : aAssertReport.getAllNames ())
        if (aName.hasPath ())
          aExpressions.add (_analyzeRuleExpression (EStreamabilityExpressionType.NAME,
                                                    sLabel,
                                                    aName.getPath (),
                                                    "name(",
                                                    aRuleLets,
                                                    nLetCount,
                                                    aSettings,
                                                    aAnalyzer,
                                                    aSC));
      if (aDiagnostics != null)
        for (final String sDiagnosticID : aAssertReport.getAllDiagnostics ())
        {
          final PSDiagnostic aDiagnostic = StringHelper.isNotEmpty (sDiagnosticID) ? aDiagnostics.get (sDiagnosticID)
                                                                                    : null;
          if (aDiagnostic != null)
            for (final PSValueOf aValueOf : aDiagnostic.getAllValueOfs ())
              aExpressions.add (_analyzeRuleExpression (EStreamabilityExpressionType.VALUE_OF,
                                                        sDiagnosticID,
                                                        aValueOf.getSelect (),
                                                        "data(",
                                                        aRuleLets,
                                                        nLetCount,
                                                        aSettings,
                                                        aAnalyzer,
                                                        aSC));
        }
    }
    return new RuleStreamability (aRule.getID (), aRule.getContext (), aExpressions);
  }

  /**
   * Analyse a Schematron.
   *
   * @param aSchema
   *        The schema as read, before or after preprocessing. May not be <code>null</code>.
   * @return The report. Never <code>null</code>.
   * @throws SchematronPreprocessException
   *         if the schema cannot be preprocessed
   */
  @NonNull
  public static SchematronStreamabilityReport analyze (@NonNull final PSSchema aSchema) throws SchematronPreprocessException
  {
    ValueEnforcer.notNull (aSchema, "Schema");

    final ICommonsList <StreamabilityExpression> aGlobalExpressions = new CommonsArrayList <> ();
    _addUnsupported (aSchema, aGlobalExpressions);

    final PSSchema aPreprocessed = PSPreprocessor.createPreprocessorWithoutInformationLoss (StreamabilityQueryBindingTransform.INSTANCE)
                                                 .getAsPreprocessedSchema (aSchema);

    final SchemaSettings aSettings = new SchemaSettings (aPreprocessed.getAllNSs ());
    final StaticContext aSC = aSettings.createStaticContext ();

    // All global names, and the rule lets with element content, which are not bound
    final ICommonsList <PSLet> aGlobalLets = new CommonsArrayList <> (aPreprocessed.getAllLets ());
    for (final PSPhase aPhase : aPreprocessed.getAllPhases ())
      aGlobalLets.addAll (aPhase.getAllLets ());
    for (final PSPattern aPattern : aPreprocessed.getAllPatterns ())
      aGlobalLets.addAll (aPattern.getAllLets ());
    final ICommonsList <String> aVariableNames = new CommonsArrayList <> ();
    for (final PSLet aLet : aGlobalLets)
      aVariableNames.add (aLet.getName ());
    for (final PSParam aParam : aPreprocessed.getAllParams ())
      aVariableNames.add (aParam.getName ());
    for (final PSPattern aPattern : aPreprocessed.getAllPatterns ())
      for (final PSRule aRule : aPattern.getAllRules ())
        for (final PSLet aLet : aRule.getAllLets ())
          if (aLet.getValue () == null)
            aVariableNames.add (aLet.getName ());
    for (final String sName : aVariableNames)
    {
      final XdmQName aName = _getQName (sName, aSC);
      aSC.declareVariable (aName);
      aSettings.addVariable (aName);
    }

    _addFunctions (aPreprocessed, aSettings, aSC);
    final XPathStreamabilityAnalyzer aAnalyzer = aSettings.createAnalyzer ();

    for (final PSLet aLet : aGlobalLets)
      aGlobalExpressions.add (_analyzeGlobalLet (aLet, aSettings, aAnalyzer, aSC));

    final ICommonsMap <String, PSDiagnostic> aDiagnostics = _getDiagnosticsByID (aPreprocessed.getDiagnostics ());
    final ICommonsList <PatternStreamability> aPatterns = new CommonsArrayList <> ();
    for (final PSPattern aPattern : aPreprocessed.getAllPatterns ())
    {
      final ICommonsList <RuleStreamability> aRules = new CommonsArrayList <> ();
      for (final PSRule aRule : aPattern.getAllRules ())
        aRules.add (_analyzeRule (aRule, aDiagnostics, aSettings));
      aPatterns.add (new PatternStreamability (aPattern.getID (), aRules));
    }
    return new SchematronStreamabilityReport (aGlobalExpressions, aPatterns);
  }

  /**
   * Read and analyse a Schematron.
   *
   * @param aResource
   *        The Schematron to read. May not be <code>null</code>.
   * @return The report. Never <code>null</code>.
   * @throws SchematronReadException
   *         if the schema cannot be read
   * @throws SchematronPreprocessException
   *         if the schema cannot be preprocessed
   */
  @NonNull
  public static SchematronStreamabilityReport analyze (@NonNull final IReadableResource aResource) throws SchematronReadException,
                                                                                                    SchematronPreprocessException
  {
    ValueEnforcer.notNull (aResource, "Resource");
    return analyze (new PSReader (aResource).readSchema ());
  }
}
