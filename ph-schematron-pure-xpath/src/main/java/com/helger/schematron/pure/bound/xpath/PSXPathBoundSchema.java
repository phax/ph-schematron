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
package com.helger.schematron.pure.bound.xpath;

import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathVariableResolver;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.helger.annotation.CheckForSigned;
import com.helger.annotation.Nonnegative;
import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.string.StringHelper;
import com.helger.base.timing.StopWatch;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.CommonsHashMap;
import com.helger.collection.commons.ICommonsList;
import com.helger.collection.commons.ICommonsMap;
import com.helger.schematron.SchematronDebug;
import com.helger.schematron.errorhandler.IPSErrorHandler;
import com.helger.schematron.model.IPSElement;
import com.helger.schematron.model.IPSHasMixedContent;
import com.helger.schematron.model.PSAssertReport;
import com.helger.schematron.model.PSDiagnostic;
import com.helger.schematron.model.PSName;
import com.helger.schematron.model.PSPattern;
import com.helger.schematron.model.PSPhase;
import com.helger.schematron.model.PSRule;
import com.helger.schematron.model.PSSchema;
import com.helger.schematron.model.PSValueOf;
import com.helger.schematron.pure.binding.IPSQueryBinding;
import com.helger.schematron.pure.binding.SchematronBindException;
import com.helger.schematron.pure.binding.xpath.PSXPathVariables;
import com.helger.schematron.pure.bound.AbstractPSBoundSchema;
import com.helger.schematron.pure.validation.IPSValidationHandler;
import com.helger.schematron.pure.validation.SchematronValidationException;
import com.helger.schematron.pure.xpath.IXPathConfig;
import com.helger.schematron.pure.xpath.XPathConfigBuilder;
import com.helger.schematron.pure.xpath.XPathEvaluationContext;
import com.helger.schematron.pure.xpath.XPathEvaluationHelper;
import com.helger.schematron.pure.xpath.XPathLetVariableResolver;
import com.helger.xml.XMLHelper;
import com.helger.xml.namespace.MapBasedNamespaceContext;

import net.sf.saxon.dom.DOMNodeWrapper;
import net.sf.saxon.dom.DocumentWrapper;
import net.sf.saxon.dom.NodeOverNodeInfo;
import net.sf.saxon.om.NodeInfo;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.XPathCompiler;
import net.sf.saxon.s9api.XPathExecutable;
import net.sf.saxon.s9api.XdmItem;
import net.sf.saxon.s9api.XdmNode;
import net.sf.saxon.s9api.XdmValue;

/**
 * The default XPath binding for the pure Schematron implementation, based on the Saxon s9api.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class PSXPathBoundSchema extends AbstractPSBoundSchema
{
  private static final class MyNodeList implements NodeList
  {
    private final @NonNull ICommonsList <Node> m_aNodes;

    private MyNodeList (@NonNull final ICommonsList <Node> aNodes)
    {
      m_aNodes = aNodes;
    }

    public @Nullable Node item (final @CheckForSigned int nIndex)
    {
      if (nIndex < 0 || nIndex >= m_aNodes.size ())
        return null;
      return m_aNodes.get (nIndex);
    }

    public @Nonnegative int getLength ()
    {
      return m_aNodes.size ();
    }
  }

  private static final Logger LOGGER = LoggerFactory.getLogger (PSXPathBoundSchema.class);

  private final IXPathConfig m_aXPathConfig;
  private final XPathLetVariableResolver m_aLetVars;

  // Status vars
  private ICommonsList <PSXPathBoundPattern> m_aBoundPatterns;
  private PSXPathVariables m_aSchemaVariables;

  /**
   * Compile an XPath expression string to an {@link XPathExpressionException} object. If expression
   * contains any variables, the {@link XPathVariableResolver} will be used to resolve them within
   * this method!
   *
   * @param aXPathContext
   *        Context to use. May not be <code>null</code>.
   * @param sXPathExpression
   *        The expression to be compiled. May not be <code>null</code>.
   * @return The precompiled {@link XPathExecutable}
   * @throws SaxonApiException
   *         If expression cannot be compiled.
   */
  @NonNull
  private static XPathExecutable _compileXPath (@NonNull final XPathCompiler aCompiler,
                                                @NonNull final String sXPathExpression) throws SaxonApiException
  {
    return aCompiler.compile (sXPathExpression);
  }

  @Nullable
  private ICommonsList <PSXPathBoundElement> _createBoundElements (@NonNull final IPSHasMixedContent aMixedContent,
                                                                   @NonNull final XPathCompiler aCompiler)
  {
    final ICommonsList <PSXPathBoundElement> ret = new CommonsArrayList <> ();
    boolean bHasAnyError = false;

    for (final Object aContentElement : aMixedContent.getAllContentElements ())
    {
      if (aContentElement instanceof final PSName aName)
      {
        if (aName.hasPath ())
        {
          final String sPath = aName.getPath ();
          try
          {
            final XPathExecutable aBound = _compileXPath (aCompiler, sPath);
            ret.add (new PSXPathBoundElement (aName, sPath, aBound));
          }
          catch (final SaxonApiException ex)
          {
            error (aName, "Failed to compile XPath expression in <name>: '" + sPath + "'", ex);
            bHasAnyError = true;
          }
        }
        else
        {
          // No XPath required
          ret.add (new PSXPathBoundElement (aName));
        }
      }
      else
        if (aContentElement instanceof final PSValueOf aValueOf)
        {
          final String sSelect = aValueOf.getSelect ();
          try
          {
            final XPathExecutable aBound = _compileXPath (aCompiler, sSelect);
            ret.add (new PSXPathBoundElement (aValueOf, sSelect, aBound));
          }
          catch (final SaxonApiException ex)
          {
            error (aValueOf, "Failed to compile XPath expression in <value-of>: '" + sSelect + "'", ex);
            bHasAnyError = true;
          }
        }
        else
        {
          // No XPath compilation necessary
          if (aContentElement instanceof String)
            ret.add (new PSXPathBoundElement ((String) aContentElement));
          else
            ret.add (new PSXPathBoundElement ((IPSElement) aContentElement));
        }
    }

    if (bHasAnyError)
      return null;

    return ret;
  }

  @Nullable
  private ICommonsMap <String, PSXPathBoundDiagnostic> _createBoundDiagnostics (@NonNull final XPathCompiler aCompiler)
  {
    final ICommonsMap <String, PSXPathBoundDiagnostic> ret = new CommonsHashMap <> ();
    boolean bHasAnyError = false;

    final PSSchema aSchema = getOriginalSchema ();
    if (aSchema.hasDiagnostics ())
    {
      // For all contained diagnostic elements
      for (final PSDiagnostic aDiagnostic : aSchema.getDiagnostics ().getAllDiagnostics ())
      {
        final ICommonsList <PSXPathBoundElement> aBoundElements = _createBoundElements (aDiagnostic, aCompiler);
        if (aBoundElements == null)
        {
          // error already emitted
          bHasAnyError = true;
        }
        else
        {
          final PSXPathBoundDiagnostic aBoundDiagnostic = new PSXPathBoundDiagnostic (aDiagnostic, aBoundElements);
          if (ret.put (aDiagnostic.getID (), aBoundDiagnostic) != null)
          {
            error (aDiagnostic, "A diagnostic element with ID '" + aDiagnostic.getID () + "' was overwritten!");
            bHasAnyError = true;
          }
        }
      }
    }

    if (bHasAnyError)
      return null;

    return ret;
  }

  /**
   * Pre-compile all patterns incl. their content
   *
   * @param aCompiler
   *        XPath compiler to use. May not be <code>null</code>.
   * @param aBoundDiagnostics
   *        A map from DiagnosticID to its mapped counterpart. May not be <code>null</code>.
   * @param aSchemaVariables
   *        The schema-global Schematron-let variables. May not be <code>null</code>.
   * @return <code>null</code> if an XPath error is contained
   */
  @Nullable
  private ICommonsList <PSXPathBoundPattern> _createBoundPatterns (@NonNull final XPathCompiler aCompiler,
                                                                   @NonNull final ICommonsMap <String, PSXPathBoundDiagnostic> aBoundDiagnostics,
                                                                   @NonNull final PSXPathVariables aSchemaVariables)
  {
    final ICommonsList <PSXPathBoundPattern> ret = new CommonsArrayList <> ();
    boolean bHasAnyError = false;

    // For all relevant patterns
    for (final PSPattern aPattern : getAllRelevantPatterns ())
    {
      // Handle pattern specific variables
      final PSXPathVariables aPatternVariables = new PSXPathVariables ();
      if (aPattern.hasAnyLet ())
      {
        // The pattern has special variables, so we need to store them in the
        // bound pattern
        for (final var aEntry : aPattern.getAllLetsAsMap ().entrySet ())
        {
          final String sLetName = aEntry.getKey ();
          final String sLetValue = aEntry.getValue ();
          try
          {
            final XPathExecutable aBound = _compileXPath (aCompiler, sLetValue);
            aPatternVariables.add (sLetName, aBound);

            // Already defined on a higher level?
            if (aSchemaVariables.contains (sLetName))
              error (aPattern, "Duplicate <let> with name '" + sLetName + "' in <pattern>");
          }
          catch (final SaxonApiException ex)
          {
            error (aPattern,
                   "Failed to compile XPath expression '" + sLetValue + "' in <let> with name '" + sLetName + "'",
                   ex);
          }
        }
      }

      // For all rules of the current pattern
      final ICommonsList <PSXPathBoundRule> aBoundRules = new CommonsArrayList <> ();
      for (final PSRule aRule : aPattern.getAllRules ())
      {
        // Handle rule specific variables
        final PSXPathVariables aRuleVariables = new PSXPathVariables ();
        if (aRule.hasAnyLet ())
        {
          // The rule has special variables, so we to store them in the bound
          // rule
          for (final var aEntry : aRule.getAllLetsAsMap ().entrySet ())
          {
            final String sLetName = aEntry.getKey ();
            final String sLetValue = aEntry.getValue ();
            try
            {
              final XPathExecutable aBound = _compileXPath (aCompiler, sLetValue);
              aRuleVariables.add (sLetName, aBound);

              // Already defined on a higher level?
              if (aSchemaVariables.contains (sLetName) || aPatternVariables.contains (sLetName))
                error (aRule, "Duplicate <let> with name '" + sLetName + "' in <rule>");
            }
            catch (final SaxonApiException ex)
            {
              error (aPattern,
                     "Failed to compile XPath expression '" + sLetValue + "' in <let> with name '" + sLetName + "'",
                     ex);
            }
          }
        }

        // For all contained assert and reports within the current rule
        final ICommonsList <PSXPathBoundAssertReport> aBoundAssertReports = new CommonsArrayList <> ();
        for (final PSAssertReport aAssertReport : aRule.getAllAssertReports ())
        {
          final String sTest = aAssertReport.getTest ();
          try
          {
            final XPathExecutable aTestExpr = _compileXPath (aCompiler, sTest);
            final ICommonsList <PSXPathBoundElement> aBoundElements = _createBoundElements (aAssertReport, aCompiler);
            if (aBoundElements == null)
            {
              // Error already emitted
              bHasAnyError = true;
            }
            else
            {
              final PSXPathBoundAssertReport aBoundAssertReport = new PSXPathBoundAssertReport (aAssertReport,
                                                                                                sTest,
                                                                                                aTestExpr,
                                                                                                aBoundElements,
                                                                                                aBoundDiagnostics);
              aBoundAssertReports.add (aBoundAssertReport);
            }
          }
          catch (final Exception ex)
          {
            error (aAssertReport,
                   "Failed to compile XPath expression in <" +
                                  (aAssertReport.isAssert () ? "assert" : "report") +
                                  ">: '" +
                                  sTest +
                                  "' with the following variables: " +
                                  aRuleVariables.getAll (),
                   ex);
            bHasAnyError = true;
          }
        }

        // Evaluate base node set for this rule
        final String sRuleContext = getValidationContext (aRule.getContext ());
        try
        {
          final XPathExecutable aRuleCtxExec = _compileXPath (aCompiler, sRuleContext);
          aBoundRules.add (new PSXPathBoundRule (aRule,
                                                 sRuleContext,
                                                 aRuleCtxExec,
                                                 aBoundAssertReports,
                                                 aRuleVariables));
        }
        catch (final SaxonApiException ex)
        {
          error (aRule, "Failed to compile XPath expression in <rule>: '" + sRuleContext + "'", ex);
          bHasAnyError = true;
        }
      }

      // Create the bound pattern
      ret.add (new PSXPathBoundPattern (aPattern, aBoundRules, aPatternVariables));
    }

    if (bHasAnyError)
      return null;

    return ret;
  }

  /**
   * Create a new bound schema. All the XPath pre-compilation happens inside this constructor, so
   * that the {@link #validate(Node, String, IPSValidationHandler)} method can be called many times
   * without compiling the XPath statements again and again.
   *
   * @param aQueryBinding
   *        The query binding to be used. May not be <code>null</code>.
   * @param aOrigSchema
   *        The original schema that should be bound. May not be <code>null</code>.
   * @param sPhase
   *        The selected phase. May be <code>null</code> indicating that the default phase of the
   *        schema should be used (if present) or all patterns should be evaluated if no default
   *        phase is present.
   * @param aCustomErrorListener
   *        A custom error listener to be used. May be <code>null</code>.
   * @param aCustomValidationHandler
   *        The custom PS validation handler. May be <code>null</code>.
   * @param aXPathConfig
   *        The XPath configuration to be used. May be <code>null</code>.
   * @throws SchematronBindException
   *         In case XPath expressions are incorrect and pre-compilation fails
   */
  public PSXPathBoundSchema (@NonNull final IPSQueryBinding aQueryBinding,
                             @NonNull final PSSchema aOrigSchema,
                             @Nullable final String sPhase,
                             @Nullable final IPSErrorHandler aCustomErrorListener,
                             @Nullable final IPSValidationHandler aCustomValidationHandler,
                             @Nullable final IXPathConfig aXPathConfig) throws SchematronBindException
  {
    super (aQueryBinding, aOrigSchema, sPhase, aCustomErrorListener, aCustomValidationHandler);

    // Create a default if none is present
    m_aXPathConfig = aXPathConfig != null ? aXPathConfig : new XPathConfigBuilder ().build ();
    // Create our own variable resolver
    m_aLetVars = new XPathLetVariableResolver (m_aXPathConfig.getAllExternalVariables ());
  }

  @NonNull
  private XPathCompiler _createXPathCompiler ()
  {
    final XPathCompiler aCompiler = m_aXPathConfig.getProcessor ().newXPathCompiler ();
    aCompiler.setLanguageVersion (m_aXPathConfig.getXPathVersion ().getVersion ());
    aCompiler.setAllowUndeclaredVariables (true);

    final MapBasedNamespaceContext aNamespaceContext = getNamespaceContext ();
    final String sDefaultNS = aNamespaceContext.getDefaultNamespaceURI ();
    if (StringHelper.isNotEmpty (sDefaultNS))
      aCompiler.declareNamespace ("", sDefaultNS);

    for (final var aEntry : aNamespaceContext.getPrefixToNamespaceURIMap ().entrySet ())
      aCompiler.declareNamespace (aEntry.getKey (), aEntry.getValue ());

    return aCompiler;
  }

  @NonNull
  public PSXPathBoundSchema bind () throws SchematronBindException
  {
    if (LOGGER.isDebugEnabled ())
      LOGGER.debug ("Binding pure Schematron");

    if (m_aBoundPatterns != null)
      throw new IllegalStateException ("bind must only be called once!");

    final PSSchema aSchema = getOriginalSchema ();
    final PSPhase aPhase = getPhase ();

    final XPathCompiler aCompiler = _createXPathCompiler ();

    // Get all "global" variables that are defined in the schema
    m_aSchemaVariables = new PSXPathVariables ();
    if (aSchema.hasAnyLet ())
    {
      // Add all global variables
      for (final var aEntry : aSchema.getAllLetsAsMap ().entrySet ())
      {
        final String sLetName = aEntry.getKey ();
        final String sLetValue = aEntry.getValue ();
        try
        {
          final XPathExecutable aBound = _compileXPath (aCompiler, sLetValue);
          if (m_aSchemaVariables.add (sLetName, aBound).isUnchanged ())
            error (aSchema, "Duplicate <let> with name '" + sLetName + "' in global <schema>");
        }
        catch (final SaxonApiException ex)
        {
          error (aSchema,
                 "Failed to compile XPath expression '" + sLetValue + "' in <let> with name '" + sLetName + "'",
                 ex);
        }
      }
    }

    if (aPhase != null)
    {
      // Get all variables that are defined in the specified phase,
      // and add them to the global variables
      for (final var aEntry : aPhase.getAllLetsAsMap ().entrySet ())
      {
        final String sLetName = aEntry.getKey ();
        final String sLetValue = aEntry.getValue ();
        try
        {
          final XPathExecutable aBound = _compileXPath (aCompiler, sLetValue);
          if (m_aSchemaVariables.add (sLetName, aBound).isUnchanged ())
            error (aSchema,
                   "Duplicate <let> with name '" + sLetName + "' in <phase> with name '" + getPhaseID () + "'");
        }
        catch (final SaxonApiException ex)
        {
          error (aSchema,
                 "Failed to compile XPath expression '" + sLetValue + "' in <let> with name '" + sLetName + "'",
                 ex);
        }
      }
    }

    // Pre-compile all diagnostics first
    final ICommonsMap <String, PSXPathBoundDiagnostic> aBoundDiagnostics = _createBoundDiagnostics (aCompiler);
    if (aBoundDiagnostics == null)
      throw new SchematronBindException ("Failed to precompile the diagnostics of the supplied schema. Check the " +
                                         (isDefaultErrorHandler () ? "log output" : "error listener") +
                                         " for XPath errors!");

    // Perform the pre-compilation of all XPath expressions in the patterns,
    // rules, asserts/reports and the content elements
    m_aBoundPatterns = _createBoundPatterns (aCompiler, aBoundDiagnostics, m_aSchemaVariables);
    if (m_aBoundPatterns == null)
      throw new SchematronBindException ("Failed to precompile the supplied schema.");
    return this;
  }

  /**
   * @return The underlying {@link IXPathConfig}. Never <code>null</code>.
   * @since 8.0.0
   */
  @NonNull
  public final IXPathConfig getXPathConfig ()
  {
    return m_aXPathConfig;
  }

  @NonNull
  public String getValidationContext (@NonNull final String sRuleContext)
  {
    // Do we already have an absolute XPath?
    if (sRuleContext.startsWith ("/"))
      return sRuleContext;

    // Create an absolute XPath expression!
    return "//" + sRuleContext;
  }

  // Status vars for evaluation
  private int m_nVarForNodeLists = 0;
  private int m_nVarForString = 0;
  private int m_nVarForBoolean = 0;
  private int m_nVarForNode = 0;

  private void _evaluateVariables (@NonNull final PSXPathVariables aVariables,
                                   @NonNull final XdmItem aContext,
                                   @NonNull final IPSElement aContextElement)
  {
    for (final var aEntry : aVariables.getAll ().entrySet ())
    {
      final String sVariableName = aEntry.getKey ();
      final XPathExecutable aXPathExecutable = aEntry.getValue ();

      try
      {
        final XdmValue aResult = XPathEvaluationHelper.evaluate (aXPathExecutable,
                                                                 aContext,
                                                                 m_aLetVars.getCurrentVariables ());

        // Debug histogram of result kinds.
        final int nSize = aResult.size ();
        if (nSize == 0)
          m_nVarForBoolean++;
        else
          if (nSize > 1)
            m_nVarForNodeLists++;
          else
          {
            final XdmItem aSingle = aResult.itemAt (0);
            if (aSingle.isNode ())
              m_nVarForNode++;
            else
              m_nVarForString++;
          }

        // Variables from <let> are stored without namespace
        m_aLetVars.setVariableValue (new QName (sVariableName), aResult);
      }
      catch (final SaxonApiException ex)
      {
        error (aContextElement, "Failed to evaluate XPath expression for variable '" + sVariableName + "'", ex);
      }
    }
  }

  private void _removeAllVariables (@NonNull final PSXPathVariables aVariables)
  {
    for (final String sVarName : aVariables.getAllNames ())
      m_aLetVars.removeVariable (new QName (sVarName));
  }

  @Nullable
  private static Node _xdmToDomNode (@NonNull final XdmNode aXdmNode)
  {
    // For Saxon DOM trees the wrapped DOM node is exposed as the "external node"
    final Object aExternal = aXdmNode.getExternalNode ();
    if (aExternal instanceof final Node aNode)
      return aNode;

    final Object aUnderlying = aXdmNode.getUnderlyingNode ();

    // DOM wrappers: unwrap to the original DOM node
    if (aUnderlying instanceof final DOMNodeWrapper aDNW)
      return aDNW.getUnderlyingNode ();

    // TinyTree (or any other non-DOM NodeInfo): present it as a DOM facade
    if (aUnderlying instanceof final NodeInfo aNodeInfo)
      return NodeOverNodeInfo.wrap (aNodeInfo);

    return null;
  }

  private void _validateSerial (@NonNull final XdmNode aDocXdm,
                                @Nullable final String sBaseURI,
                                @NonNull final IPSValidationHandler aValidationHandler) throws SchematronValidationException
  {
    final PSSchema aSchema = getOriginalSchema ();
    final PSPhase aPhase = getPhase ();

    // Call the "start" callback method
    aValidationHandler.onStart (aSchema, aPhase, sBaseURI);

    // Read the timing gates once - skip all StopWatch work when nobody is interested
    final boolean bMeasureTiming = aValidationHandler.isMeasureTiming ();
    final boolean bMeasureAssertionTiming = aValidationHandler.isMeasureAssertionTiming ();

    // Evaluate schema-global variables
    _evaluateVariables (m_aSchemaVariables, aDocXdm, aSchema);

    // For all bound patterns
    for (final PSXPathBoundPattern aBoundPattern : m_aBoundPatterns)
    {
      final PSPattern aPattern = aBoundPattern.getPattern ();
      aValidationHandler.onPattern (aPattern);

      // Evaluate pattern variables
      _evaluateVariables (aBoundPattern.getVariables (), aDocXdm, aPattern);

      // For all bound rules
      for (final PSXPathBoundRule aBoundRule : aBoundPattern.getAllBoundRules ())
      {
        final PSRule aRule = aBoundRule.getRule ();

        // Times the whole rule (context selection + all assert/report evaluations)
        final StopWatch aRuleSW = bMeasureTiming ? StopWatch.createdStarted () : null;

        // Find all nodes matching the rules
        final ICommonsList <XdmNode> aRuleContextXdmNodes;
        final StopWatch aContextSW = bMeasureTiming ? StopWatch.createdStarted () : null;
        try
        {
          aRuleContextXdmNodes = XPathEvaluationHelper.evaluateAsXdmNodes (aBoundRule.getBoundRuleContext (),
                                                                           aDocXdm,
                                                                           m_aLetVars.getCurrentVariables ());
        }
        catch (final SaxonApiException ex)
        {
          // Handle the cause, because it is usually a wrapper only
          error (aRule,
                 "Failed to evaluate XPath expression to a nodeset: '" + aBoundRule.getRuleContext () + "'",
                 ex.getCause () != null ? ex.getCause () : ex);
          continue;
        }

        if (aContextSW != null)
        {
          aContextSW.stop ();
          aValidationHandler.onContextEvaluated (aRule, aContextSW.getNanos (), aRuleContextXdmNodes.size ());
        }

        final ICommonsList <Node> aRuleContextDomNodes = new CommonsArrayList <> (aRuleContextXdmNodes.size ());
        for (final XdmNode aMatch : aRuleContextXdmNodes)
        {
          final Node aDomNode = _xdmToDomNode (aMatch);
          if (aDomNode != null)
            aRuleContextDomNodes.add (aDomNode);
        }

        aValidationHandler.onRuleStart (aRule, new MyNodeList (aRuleContextDomNodes));

        // Check each node, if it matches the assert/report
        final int nRuleMatchingNodes = aRuleContextXdmNodes.size ();
        for (int nMatchedNode = 0; nMatchedNode < nRuleMatchingNodes; ++nMatchedNode)
        {
          // XSLT does "fired-rule" for each node
          aValidationHandler.onFiredRule (aRule, aBoundRule.getRuleContext (), nMatchedNode, nRuleMatchingNodes);

          final XdmNode aMatchedXdm = aRuleContextXdmNodes.get (nMatchedNode);
          final Node aMatchedDom = nMatchedNode < aRuleContextDomNodes.size () ? aRuleContextDomNodes.get (nMatchedNode)
                                                                               : _xdmToDomNode (aMatchedXdm);

          // Evaluate variables declared in the rule with the context of the
          // matching node
          _evaluateVariables (aBoundRule.getVariables (), aMatchedXdm, aRule);

          // For all contained assert and report elements
          for (final PSXPathBoundAssertReport aBoundAssertReport : aBoundRule.getAllBoundAssertReports ())
          {
            final PSAssertReport aAssertReport = aBoundAssertReport.getAssertReport ();
            final boolean bIsAssert = aAssertReport.isAssert ();
            final XPathExecutable aTestExecutable = aBoundAssertReport.getBoundTestExpression ();

            try
            {
              final StopWatch aTestSW = bMeasureAssertionTiming ? StopWatch.createdStarted () : null;
              final boolean bTestResult = XPathEvaluationHelper.evaluateAsBoolean (aTestExecutable,
                                                                                   aMatchedXdm,
                                                                                   m_aLetVars.getCurrentVariables ());
              if (aTestSW != null)
              {
                aTestSW.stop ();
                aValidationHandler.onTestEvaluated (aRule,
                                                    aAssertReport,
                                                    aBoundAssertReport.getTestExpression (),
                                                    aTestSW.getNanos (),
                                                    bTestResult);
              }
              if (bIsAssert)
              {
                // It's an assert
                if (!bTestResult)
                {
                  // Assert failed
                  if (aValidationHandler.onFailedAssert (aBoundRule.getRule (),
                                                         aAssertReport,
                                                         aBoundAssertReport.getTestExpression (),
                                                         aMatchedDom,
                                                         nMatchedNode,
                                                         aBoundAssertReport,
                                                         null).isBreak ())
                  {
                    return;
                  }
                }
              }
              else
              {
                // It's a report
                if (bTestResult)
                {
                  // Successful report
                  if (aValidationHandler.onSuccessfulReport (aBoundRule.getRule (),
                                                             aAssertReport,
                                                             aBoundAssertReport.getTestExpression (),
                                                             aMatchedDom,
                                                             nMatchedNode,
                                                             aBoundAssertReport,
                                                             null).isBreak ())
                  {
                    return;
                  }
                }
              }
            }
            catch (final SaxonApiException ex)
            {
              // As the exception will be emitted as a failed assert, no need to
              // additionally log it here
              if (false)
                error (aRule,
                       "Failed to evaluate XPath expression to a boolean: '" +
                              aBoundAssertReport.getTestExpression () +
                              "'",
                       ex.getCause () != null ? ex.getCause () : ex);

              if (bIsAssert)
              {
                // Assert failed
                if (aValidationHandler.onFailedAssert (aBoundRule.getRule (),
                                                       aAssertReport,
                                                       aBoundAssertReport.getTestExpression (),
                                                       aMatchedDom,
                                                       nMatchedNode,
                                                       aBoundAssertReport,
                                                       ex).isBreak ())
                {
                  return;
                }
              }
              else
              {
                // Successful report
                if (aValidationHandler.onSuccessfulReport (aBoundRule.getRule (),
                                                           aAssertReport,
                                                           aBoundAssertReport.getTestExpression (),
                                                           aMatchedDom,
                                                           nMatchedNode,
                                                           aBoundAssertReport,
                                                           ex).isBreak ())
                {
                  return;
                }
              }
            }
          }
        }

        // Variables declared in the rule are going out of scope
        _removeAllVariables (aBoundRule.getVariables ());

        if (aRuleSW != null)
        {
          aRuleSW.stop ();
          aValidationHandler.onRuleEvaluated (aRule, aRuleSW.getNanos ());
        }
      }

      // Variables declared in the pattern are going out of scope
      _removeAllVariables (aBoundPattern.getVariables ());
    }

    // Variables declared in the schema are going out of scope
    _removeAllVariables (m_aSchemaVariables);

    // Call the "end" callback method
    aValidationHandler.onEnd (aSchema, aPhase);

    if (m_nVarForNodeLists > 0 || m_nVarForString > 0 || m_nVarForNode > 0 || m_nVarForBoolean > 0)
    {
      SchematronDebug.getDebugLogger ()
                     .info (() -> "Variables result types: NodeList=" +
                                  m_nVarForNodeLists +
                                  "; String=" +
                                  m_nVarForString +
                                  "; Node=" +
                                  m_nVarForNode +
                                  "; Boolean/Empty=" +
                                  m_nVarForBoolean);
    }
  }

  public void validate (@NonNull final Node aNode,
                        @Nullable final String sBaseURI,
                        @NonNull final IPSValidationHandler aValidationHandler) throws SchematronValidationException
  {
    ValueEnforcer.notNull (aNode, "Node");
    ValueEnforcer.notNull (aValidationHandler, "ValidationHandler");

    if (m_aBoundPatterns == null)
      throw new IllegalStateException ("bind was never called!");

    final Processor aProcessor = m_aXPathConfig.getProcessor ();

    final XdmNode aContextXdm;
    final DocumentWrapper aDocWrapper;
    if (aNode instanceof final NodeOverNodeInfo aSaxonFacade)
    {
      // Fast path: the input is already a Saxon-backed tree (e.g. TinyTree built via the
      // Saxon DocumentBuilder) wrapped behind a DOM facade. Use the underlying NodeInfo
      // directly and skip the DocumentWrapper, which would otherwise force every XPath
      // step through the slower DOM bridge.
      aContextXdm = (XdmNode) XdmValue.wrap (aSaxonFacade.getUnderlyingNodeInfo ());
      aDocWrapper = null;
    }
    else
    {
      // DOM path: the input is a real org.w3c.dom Node. Wrap the owning document once and
      // reuse it for every per-call evaluation.
      final Document aOwnerDoc = XMLHelper.getOwnerDocument (aNode);
      aDocWrapper = new DocumentWrapper (aOwnerDoc,
                                         sBaseURI != null ? sBaseURI : "",
                                         aProcessor.getUnderlyingConfiguration ());
      aContextXdm = (XdmNode) XdmValue.wrap (aDocWrapper.wrap (aNode));
    }

    final XPathEvaluationContext aEvalContext = new XPathEvaluationContext (aProcessor,
                                                                            aDocWrapper,
                                                                            m_aLetVars,
                                                                            sBaseURI);

    try
    {
      XPathEvaluationContext.set (aEvalContext);
      _validateSerial (aContextXdm, sBaseURI, aValidationHandler);
    }
    finally
    {
      // ALWAYS drop the per-thread state, regardless of how _validateSerial exited:
      // - normal completion: the scoped _removeAllVariables calls inside _validateSerial already
      // removed every <let> binding, so this is a no-op;
      // - IPSValidationHandler returns BREAK mid-loop: the in-flight pattern/rule/schema let
      // variables are still bound on this thread - clear them so the next request on this
      // thread-pool worker does not see stale bindings;
      // - RuntimeException out of a handler callback: same as above.
      m_aLetVars.clearAllForCurrentThread ();
      XPathEvaluationContext.clear ();
    }
  }

  @Override
  public String toString ()
  {
    return ToStringGenerator.getDerived (super.toString ())
                            .append ("XPathConfig", m_aXPathConfig)
                            .append ("LetVars", m_aLetVars)
                            .append ("BoundPatterns", m_aBoundPatterns)
                            .append ("SchemaVariables", m_aSchemaVariables)
                            .getToString ();
  }
}
