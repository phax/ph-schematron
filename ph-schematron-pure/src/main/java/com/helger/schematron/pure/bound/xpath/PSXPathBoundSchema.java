/*
 * Copyright (C) 2014-2024 Philip Helger (www.helger.com)
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

import java.util.Map;
import java.util.function.Function;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.NotThreadSafe;
import javax.xml.namespace.QName;
import javax.xml.transform.SourceLocator;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactoryConfigurationException;
import javax.xml.xpath.XPathVariableResolver;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.collection.impl.CommonsArrayList;
import com.helger.commons.collection.impl.CommonsHashMap;
import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.collection.impl.ICommonsMap;
import com.helger.commons.error.SingleError;
import com.helger.commons.error.level.EErrorLevel;
import com.helger.commons.location.SimpleLocation;
import com.helger.commons.string.ToStringGenerator;
import com.helger.schematron.SchematronDebug;
import com.helger.schematron.pure.binding.IPSQueryBinding;
import com.helger.schematron.pure.binding.SchematronBindException;
import com.helger.schematron.pure.binding.xpath.PSXPathVariables;
import com.helger.schematron.pure.bound.AbstractPSBoundSchema;
import com.helger.schematron.pure.errorhandler.IPSErrorHandler;
import com.helger.schematron.pure.model.IPSElement;
import com.helger.schematron.pure.model.IPSHasMixedContent;
import com.helger.schematron.pure.model.PSAssertReport;
import com.helger.schematron.pure.model.PSDiagnostic;
import com.helger.schematron.pure.model.PSName;
import com.helger.schematron.pure.model.PSPattern;
import com.helger.schematron.pure.model.PSPhase;
import com.helger.schematron.pure.model.PSRule;
import com.helger.schematron.pure.model.PSSchema;
import com.helger.schematron.pure.model.PSValueOf;
import com.helger.schematron.pure.validation.IPSValidationHandler;
import com.helger.schematron.pure.validation.SchematronValidationException;
import com.helger.schematron.pure.xpath.IXPathConfig;
import com.helger.schematron.pure.xpath.XPathConfigBuilder;
import com.helger.schematron.pure.xpath.XPathEvaluationHelper;
import com.helger.schematron.pure.xpath.XPathLetVariableResolver;
import com.helger.schematron.saxon.SaxonNamespaceContext;
import com.helger.xml.namespace.MapBasedNamespaceContext;
import com.helger.xml.xpath.XPathHelper;

import net.sf.saxon.Configuration;
import net.sf.saxon.lib.ErrorReporter;
import net.sf.saxon.xpath.XPathEvaluator;

/**
 * The default XPath binding for the pure Schematron implementation.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class PSXPathBoundSchema extends AbstractPSBoundSchema
{
  private static final Logger LOGGER = LoggerFactory.getLogger (PSXPathBoundSchema.class);

  private final IXPathConfig m_aXPathConfig;
  private final XPathLetVariableResolver m_aXPathVariableResolver;

  // Status vars
  private ICommonsList <PSXPathBoundPattern> m_aBoundPatterns;
  private PSXPathVariables m_aSchemaVariables;

  /**
   * Compile an XPath expression string to an {@link XPathExpressionException}
   * object. If expression contains any variables, the
   * {@link XPathVariableResolver} will be used to resolve them within this
   * method!
   *
   * @param aXPathContext
   *        Context to use. May not be <code>null</code>.
   * @param sXPathExpression
   *        The expression to be compiled. May not be <code>null</code>.
   * @return The precompiled {@link XPathExpression}
   * @throws XPathExpressionException
   *         If expression cannot be compiled.
   */
  @Nullable
  private static XPathExpression _compileXPath (@Nonnull final XPath aXPathContext,
                                                @Nonnull final String sXPathExpression) throws XPathExpressionException
  {
    return aXPathContext.compile (sXPathExpression);
  }

  @Nullable
  private ICommonsList <PSXPathBoundElement> _createBoundElements (@Nonnull final IPSHasMixedContent aMixedContent,
                                                                   @Nonnull final XPath aXPathContext)
  {
    final ICommonsList <PSXPathBoundElement> ret = new CommonsArrayList <> ();
    boolean bHasAnyError = false;

    for (final Object aContentElement : aMixedContent.getAllContentElements ())
    {
      if (aContentElement instanceof PSName)
      {
        final PSName aName = (PSName) aContentElement;
        if (aName.hasPath ())
        {
          final String sPath = aName.getPath ();
          try
          {
            final XPathExpression aXpathExpression = _compileXPath (aXPathContext, sPath);
            ret.add (new PSXPathBoundElement (aName, sPath, aXpathExpression));
          }
          catch (final XPathExpressionException ex)
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
        if (aContentElement instanceof PSValueOf)
        {
          final PSValueOf aValueOf = (PSValueOf) aContentElement;

          final String sSelect = aValueOf.getSelect ();
          try
          {
            final XPathExpression aXPathExpression = _compileXPath (aXPathContext, sSelect);
            ret.add (new PSXPathBoundElement (aValueOf, sSelect, aXPathExpression));
          }
          catch (final XPathExpressionException ex)
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
  private ICommonsMap <String, PSXPathBoundDiagnostic> _createBoundDiagnostics (@Nonnull final XPath aXPathContext)
  {
    final ICommonsMap <String, PSXPathBoundDiagnostic> ret = new CommonsHashMap <> ();
    boolean bHasAnyError = false;

    final PSSchema aSchema = getOriginalSchema ();
    if (aSchema.hasDiagnostics ())
    {
      // For all contained diagnostic elements
      for (final PSDiagnostic aDiagnostic : aSchema.getDiagnostics ().getAllDiagnostics ())
      {
        final ICommonsList <PSXPathBoundElement> aBoundElements = _createBoundElements (aDiagnostic, aXPathContext);
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
   * @param aXPathContext
   *        Global XPath object to use. May not be <code>null</code>.
   * @param aBoundDiagnostics
   *        A map from DiagnosticID to its mapped counterpart. May not be
   *        <code>null</code>.
   * @param aSchemaVariables
   *        The schema-global Schematron-let variables. May not be
   *        <code>null</code>.
   * @return <code>null</code> if an XPath error is contained
   */
  @Nullable
  private ICommonsList <PSXPathBoundPattern> _createBoundPatterns (@Nonnull final XPath aXPathContext,
                                                                   @Nonnull final ICommonsMap <String, PSXPathBoundDiagnostic> aBoundDiagnostics,
                                                                   @Nonnull final PSXPathVariables aSchemaVariables)
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
        for (final Map.Entry <String, String> aEntry : aPattern.getAllLetsAsMap ().entrySet ())
        {
          final String sLetName = aEntry.getKey ();
          final String sLetValue = aEntry.getValue ();
          try
          {
            final XPathExpression aXPathExpression = _compileXPath (aXPathContext, sLetValue);
            aPatternVariables.add (sLetName, aXPathExpression);

            // Already defined on a higher level?
            if (aSchemaVariables.contains (sLetName))
              error (aPattern, "Duplicate <let> with name '" + sLetName + "' in <pattern>");
          }
          catch (final XPathExpressionException ex)
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
          for (final Map.Entry <String, String> aEntry : aRule.getAllLetsAsMap ().entrySet ())
          {
            final String sLetName = aEntry.getKey ();
            final String sLetValue = aEntry.getValue ();
            try
            {
              final XPathExpression aXPathExpression = _compileXPath (aXPathContext, sLetValue);
              aRuleVariables.add (sLetName, aXPathExpression);

              // Already defined on a higher level?
              if (aSchemaVariables.contains (sLetName) || aPatternVariables.contains (sLetName))
                error (aRule, "Duplicate <let> with name '" + sLetName + "' in <rule>");
            }
            catch (final XPathExpressionException ex)
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
            final XPathExpression aTestExpr = _compileXPath (aXPathContext, sTest);
            final ICommonsList <PSXPathBoundElement> aBoundElements = _createBoundElements (aAssertReport,
                                                                                            aXPathContext);
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
        PSXPathBoundRule aBoundRule = null;
        try
        {
          final XPathExpression aRuleContext = _compileXPath (aXPathContext, sRuleContext);
          aBoundRule = new PSXPathBoundRule (aRule, sRuleContext, aRuleContext, aBoundAssertReports, aRuleVariables);
          aBoundRules.add (aBoundRule);
        }
        catch (final XPathExpressionException ex)
        {
          error (aRule, "Failed to compile XPath expression in <rule>: '" + sRuleContext + "'", ex);
          bHasAnyError = true;
        }
      }

      // Create the bound pattern
      final PSXPathBoundPattern aBoundPattern = new PSXPathBoundPattern (aPattern, aBoundRules, aPatternVariables);
      ret.add (aBoundPattern);
    }

    if (bHasAnyError)
      return null;

    return ret;
  }

  /**
   * Create a new bound schema. All the XPath pre-compilation happens inside
   * this constructor, so that the
   * {@link #validate(Node, String, IPSValidationHandler)} method can be called
   * many times without compiling the XPath statements again and again.
   *
   * @param aQueryBinding
   *        The query binding to be used. May not be <code>null</code>.
   * @param aOrigSchema
   *        The original schema that should be bound. May not be
   *        <code>null</code>.
   * @param sPhase
   *        The selected phase. May be <code>null</code> indicating that the
   *        default phase of the schema should be used (if present) or all
   *        patterns should be evaluated if no default phase is present.
   * @param aCustomErrorListener
   *        A custom error listener to be used. May be <code>null</code> in
   *        which case a
   *        {@link com.helger.schematron.pure.errorhandler.LoggingPSErrorHandler}
   *        is used internally.
   * @param aCustomValidationHandler
   *        The custom PS validation handler. May be <code>null</code>.
   * @param aXPathConfig
   *        The XPath configuration to be used. May be <code>null</code>.
   * @throws SchematronBindException
   *         In case XPath expressions are incorrect and pre-compilation fails
   */
  public PSXPathBoundSchema (@Nonnull final IPSQueryBinding aQueryBinding,
                             @Nonnull final PSSchema aOrigSchema,
                             @Nullable final String sPhase,
                             @Nullable final IPSErrorHandler aCustomErrorListener,
                             @Nullable final IPSValidationHandler aCustomValidationHandler,
                             @Nullable final IXPathConfig aXPathConfig) throws SchematronBindException
  {
    super (aQueryBinding, aOrigSchema, sPhase, aCustomErrorListener, aCustomValidationHandler);

    // Create a default if none is present
    if (aXPathConfig != null)
      m_aXPathConfig = aXPathConfig;
    else
      try
      {
        m_aXPathConfig = new XPathConfigBuilder ().build ();
      }
      catch (final XPathFactoryConfigurationException ex)
      {
        throw new SchematronBindException ("Failed to create XPath configuration", ex);
      }
    // Create our own variable resolver
    m_aXPathVariableResolver = new XPathLetVariableResolver (m_aXPathConfig.getXPathVariableResolver ());
  }

  @Nonnull
  private XPath _createXPathContext ()
  {
    final MapBasedNamespaceContext aNamespaceContext = getNamespaceContext ();
    final XPath aXPathContext = XPathHelper.createNewXPath (m_aXPathConfig.getXPathFactory (),
                                                            m_aXPathVariableResolver,
                                                            m_aXPathConfig.getXPathFunctionResolver (),
                                                            aNamespaceContext);

    if ("net.sf.saxon.xpath.XPathEvaluator".equals (aXPathContext.getClass ().getName ()))
    {
      // Saxon implementation special handling
      final XPathEvaluator aSaxonXPath = (XPathEvaluator) aXPathContext;

      // Since 9.7.0-4 it must implement NamespaceResolver
      aSaxonXPath.setNamespaceContext (new SaxonNamespaceContext (aNamespaceContext));

      // Wrap the PSErrorHandler to a ErrorListener
      final Function <Configuration, ? extends ErrorReporter> aErrReporterFactory = cfg -> {
        final IPSErrorHandler aPSErrHdl = getErrorHandler ();
        return aSaxonError -> aPSErrHdl.handleError (SingleError.builder ()
                                                                .errorLevel (aSaxonError.isWarning () ? EErrorLevel.WARN
                                                                                                      : EErrorLevel.ERROR)
                                                                .errorID (aSaxonError.getErrorCode () != null
                                                                                                              ? aSaxonError.getErrorCode ()
                                                                                                                           .toString ()
                                                                                                              : null)
                                                                .errorLocation (SimpleLocation.create ((SourceLocator) aSaxonError.getLocation ()))
                                                                .errorText (aSaxonError.getMessage ())
                                                                .linkedException (aSaxonError.getCause ())
                                                                .build ());
      };
      aSaxonXPath.getConfiguration ().setErrorReporterFactory (aErrReporterFactory);
    }
    return aXPathContext;
  }

  @Nonnull
  public PSXPathBoundSchema bind () throws SchematronBindException
  {
    if (LOGGER.isDebugEnabled ())
      LOGGER.debug ("Binding pure Schematron");

    if (m_aBoundPatterns != null)
      throw new IllegalStateException ("bind must only be called once!");

    final PSSchema aSchema = getOriginalSchema ();
    final PSPhase aPhase = getPhase ();

    final XPath aXPathContext = _createXPathContext ();

    // Get all "global" variables that are defined in the schema
    m_aSchemaVariables = new PSXPathVariables ();
    if (aSchema.hasAnyLet ())
    {
      // Add all global variables
      for (final Map.Entry <String, String> aEntry : aSchema.getAllLetsAsMap ().entrySet ())
      {
        final String sLetName = aEntry.getKey ();
        final String sLetValue = aEntry.getValue ();
        try
        {
          final XPathExpression aXPathExpression = _compileXPath (aXPathContext, sLetValue);
          if (m_aSchemaVariables.add (sLetName, aXPathExpression).isUnchanged ())
            error (aSchema, "Duplicate <let> with name '" + sLetName + "' in global <schema>");
        }
        catch (final XPathExpressionException ex)
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
      for (final Map.Entry <String, String> aEntry : aPhase.getAllLetsAsMap ().entrySet ())
      {
        final String sLetName = aEntry.getKey ();
        final String sLetValue = aEntry.getValue ();
        try
        {
          final XPathExpression xpathExpression = _compileXPath (aXPathContext, sLetValue);
          if (m_aSchemaVariables.add (sLetName, xpathExpression).isUnchanged ())
            error (aSchema,
                   "Duplicate <let> with name '" + sLetName + "' in <phase> with name '" + getPhaseID () + "'");
        }
        catch (final XPathExpressionException ex)
        {
          error (aSchema,
                 "Failed to compile XPath expression '" + sLetValue + "' in <let> with name '" + sLetName + "'",
                 ex);
        }
      }
    }

    // Pre-compile all diagnostics first
    final ICommonsMap <String, PSXPathBoundDiagnostic> aBoundDiagnostics = _createBoundDiagnostics (aXPathContext);
    if (aBoundDiagnostics == null)
      throw new SchematronBindException ("Failed to precompile the diagnostics of the supplied schema. Check the " +
                                         (isDefaultErrorHandler () ? "log output" : "error listener") +
                                         " for XPath errors!");

    // Perform the pre-compilation of all XPath expressions in the patterns,
    // rules, asserts/reports and the content elements
    m_aBoundPatterns = _createBoundPatterns (aXPathContext, aBoundDiagnostics, m_aSchemaVariables);
    if (m_aBoundPatterns == null)
      throw new SchematronBindException ("Failed to precompile the supplied schema.");
    return this;
  }

  /**
   * @return The underlying {@link IXPathConfig}. Never <code>null</code>.
   * @since v8
   */
  @Nonnull
  public final IXPathConfig getXPathConfig ()
  {
    return m_aXPathConfig;
  }

  @Nonnull
  public String getValidationContext (@Nonnull final String sRuleContext)
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
  private int m_nVarForNumber = 0;
  private int m_nVarForNode = 0;

  private void _evaluateVariables (@Nonnull final PSXPathVariables aVariables,
                                   @Nonnull final Node aNode,
                                   @Nullable final String sBaseURI,
                                   @Nonnull final IPSElement aContextElement)
  {
    for (final Map.Entry <String, XPathExpression> aEntry : aVariables.getAll ().entrySet ())
    {
      final String sVariableName = aEntry.getKey ();
      final XPathExpression aXPathExpression = aEntry.getValue ();

      Object aEvalResult;

      // We don't know the type returned by the XPath expression, so we try
      // them one after another
      // Based on some common cases, the chances for "NodeList" results and
      // "String" results are highest, so they are tried first

      try
      {
        aEvalResult = XPathEvaluationHelper.evaluateAsNodeList (aXPathExpression, aNode, sBaseURI);
        m_nVarForNodeLists++;
      }
      catch (final XPathExpressionException ex)
      {
        // ignore
        aEvalResult = null;
      }

      if (aEvalResult == null)
        try
        {
          aEvalResult = XPathEvaluationHelper.evaluateAsString (aXPathExpression, aNode, sBaseURI);
          m_nVarForString++;
        }
        catch (final XPathExpressionException ex)
        {
          // ignore
        }

      if (aEvalResult == null)
        try
        {
          aEvalResult = XPathEvaluationHelper.evaluateAsBooleanObj (aXPathExpression, aNode, sBaseURI);
          m_nVarForBoolean++;
        }
        catch (final XPathExpressionException ex)
        {
          // ignore
        }

      if (aEvalResult == null)
        try
        {
          final Double aValue = XPathEvaluationHelper.evaluateAsNumber (aXPathExpression, aNode, sBaseURI);
          if (aValue != null && !aValue.isNaN ())
          {
            aEvalResult = aValue;
            m_nVarForNumber++;
          }
        }
        catch (final XPathExpressionException ex)
        {
          // ignore
        }

      if (aEvalResult == null)
        try
        {
          aEvalResult = XPathEvaluationHelper.evaluateAsNode (aXPathExpression, aNode, sBaseURI);
          m_nVarForNode++;
        }
        catch (final XPathExpressionException ex)
        {
          // ignore
        }

      if (aEvalResult == null)
      {
        error (aContextElement,
               "Failed to evaluate XPath expression '" + aXPathExpression + "' for variable '" + sVariableName + "'");
      }
      else
      {
        // Variable from <let> do not have any namespace
        m_aXPathVariableResolver.setVariableValue (new QName (sVariableName), aEvalResult);
      }
    }
  }

  private void _removeAllVariables (@Nonnull final PSXPathVariables aVariables)
  {
    for (final String sVarName : aVariables.getAllNames ())
      m_aXPathVariableResolver.removeVariable (new QName (sVarName));
  }

  private void _validateSerial (@Nonnull final Node aNode,
                                @Nullable final String sBaseURI,
                                @Nonnull final IPSValidationHandler aValidationHandler) throws SchematronValidationException
  {
    final PSSchema aSchema = getOriginalSchema ();
    final PSPhase aPhase = getPhase ();

    // Call the "start" callback method
    aValidationHandler.onStart (aSchema, aPhase, sBaseURI);

    // Evaluate schema-global variables
    _evaluateVariables (m_aSchemaVariables, aNode, sBaseURI, aSchema);

    // For all bound patterns
    for (final PSXPathBoundPattern aBoundPattern : m_aBoundPatterns)
    {
      final PSPattern aPattern = aBoundPattern.getPattern ();
      aValidationHandler.onPattern (aPattern);

      // Evaluate pattern variables
      _evaluateVariables (aBoundPattern.getVariables (), aNode, sBaseURI, aPattern);

      // For all bound rules
      for (final PSXPathBoundRule aBoundRule : aBoundPattern.getAllBoundRules ())
      {
        final PSRule aRule = aBoundRule.getRule ();

        // Find all nodes matching the rules
        final NodeList aRuleContextNodes;
        try
        {
          aRuleContextNodes = XPathEvaluationHelper.evaluateAsNodeList (aBoundRule.getBoundRuleContext (),
                                                                        aNode,
                                                                        sBaseURI);
        }
        catch (final XPathExpressionException ex)
        {
          // Handle the cause, because it is usually a wrapper only
          error (aRule,
                 "Failed to evaluate XPath expression to a nodeset: '" + aBoundRule.getRuleContext () + "'",
                 ex.getCause () != null ? ex.getCause () : ex);
          continue;
        }

        aValidationHandler.onRuleStart (aRule, aRuleContextNodes);

        // Check each node, if it matches the assert/report
        final int nRuleMatchingNodes = aRuleContextNodes.getLength ();
        for (int nMatchedNode = 0; nMatchedNode < nRuleMatchingNodes; ++nMatchedNode)
        {
          // XSLT does "fired-rule" for each node
          aValidationHandler.onFiredRule (aRule, aBoundRule.getRuleContext (), nMatchedNode, nRuleMatchingNodes);

          final Node aRuleMatchingNode = aRuleContextNodes.item (nMatchedNode);

          // Evaluate variables declared in the rule with the context of the
          // matching node
          _evaluateVariables (aBoundRule.getVariables (), aRuleMatchingNode, sBaseURI, aRule);

          // For all contained assert and report elements
          for (final PSXPathBoundAssertReport aBoundAssertReport : aBoundRule.getAllBoundAssertReports ())
          {
            final PSAssertReport aAssertReport = aBoundAssertReport.getAssertReport ();
            final boolean bIsAssert = aAssertReport.isAssert ();
            final XPathExpression aTestExpression = aBoundAssertReport.getBoundTestExpression ();

            try
            {
              final boolean bTestResult = XPathEvaluationHelper.evaluateAsBoolean (aTestExpression,
                                                                                   aRuleMatchingNode,
                                                                                   sBaseURI);
              if (bIsAssert)
              {
                // It's an assert
                if (!bTestResult)
                {
                  // Assert failed
                  if (aValidationHandler.onFailedAssert (aAssertReport,
                                                         aBoundAssertReport.getTestExpression (),
                                                         aRuleMatchingNode,
                                                         nMatchedNode,
                                                         aBoundAssertReport).isBreak ())
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
                  if (aValidationHandler.onSuccessfulReport (aAssertReport,
                                                             aBoundAssertReport.getTestExpression (),
                                                             aRuleMatchingNode,
                                                             nMatchedNode,
                                                             aBoundAssertReport).isBreak ())
                  {
                    return;
                  }
                }
              }
            }
            catch (final XPathExpressionException ex)
            {
              error (aRule,
                     "Failed to evaluate XPath expression to a boolean: '" +
                            aBoundAssertReport.getTestExpression () +
                            "'",
                     ex.getCause () != null ? ex.getCause () : ex);
            }
          }
        }

        // Variables declared in the rule are going out of scope
        _removeAllVariables (aBoundRule.getVariables ());
      }

      // Variables declared in the pattern are going out of scope
      _removeAllVariables (aBoundPattern.getVariables ());
    }

    // Variables declared in the schema are going out of scope
    _removeAllVariables (m_aSchemaVariables);

    // Call the "end" callback method
    aValidationHandler.onEnd (aSchema, aPhase);

    if (m_nVarForNodeLists > 0 ||
        m_nVarForString > 0 ||
        m_nVarForNode > 0 ||
        m_nVarForBoolean > 0 ||
        m_nVarForNumber > 0)
    {
      SchematronDebug.getDebugLogger ()
                     .info ( () -> "Variables result types: NodeList=" +
                                   m_nVarForNodeLists +
                                   "; String=" +
                                   m_nVarForString +
                                   "; Node=" +
                                   m_nVarForNode +
                                   "; Boolean=" +
                                   m_nVarForBoolean +
                                   "; Number=" +
                                   m_nVarForNumber);
    }
  }

  public void validate (@Nonnull final Node aNode,
                        @Nullable final String sBaseURI,
                        @Nonnull final IPSValidationHandler aValidationHandler) throws SchematronValidationException
  {
    ValueEnforcer.notNull (aNode, "Node");
    ValueEnforcer.notNull (aValidationHandler, "ValidationHandler");

    if (m_aBoundPatterns == null)
      throw new IllegalStateException ("bind was never called!");

    // Validate non-parallelized
    _validateSerial (aNode, sBaseURI, aValidationHandler);
  }

  @Override
  public String toString ()
  {
    return ToStringGenerator.getDerived (super.toString ())
                            .append ("BoundPatterns", m_aBoundPatterns)
                            .append ("SchemaVariables", m_aSchemaVariables)
                            .getToString ();
  }
}
