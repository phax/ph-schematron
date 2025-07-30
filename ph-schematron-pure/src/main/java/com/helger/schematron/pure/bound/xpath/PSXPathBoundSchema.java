/*
 * Copyright (C) 2014-2025 Philip Helger (www.helger.com)
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

import java.util.function.Function;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.NotThreadSafe;
import javax.xml.namespace.QName;
import javax.xml.transform.SourceLocator;
import javax.xml.xpath.XPathFactoryConfigurationException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Node;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.collection.impl.CommonsArrayList;
import com.helger.commons.collection.impl.CommonsHashMap;
import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.collection.impl.ICommonsMap;
import com.helger.commons.error.SingleError;
import com.helger.commons.error.level.EErrorLevel;
import com.helger.commons.location.SimpleLocation;
import com.helger.commons.string.ToStringGenerator;
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
import com.helger.schematron.pure.xpath.XPathLetVariableResolver;
import com.helger.xml.XMLHelper;

import net.sf.saxon.Configuration;
import net.sf.saxon.dom.DOMNodeWrapper;
import net.sf.saxon.dom.DocumentWrapper;
import net.sf.saxon.lib.ErrorReporter;
import net.sf.saxon.lib.ExtensionFunctionDefinition;
import net.sf.saxon.om.NamespaceUri;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.XPathCompiler;
import net.sf.saxon.s9api.XPathExecutable;
import net.sf.saxon.s9api.XPathSelector;
import net.sf.saxon.s9api.XdmItem;
import net.sf.saxon.s9api.XdmNode;
import net.sf.saxon.s9api.XdmValue;
import net.sf.saxon.sxpath.IndependentContext;

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
  private final Processor m_aS9Processor;

  // Status vars
  private XPathCompiler m_aXPathCompiler;
  private PSXPathVariables m_aSchemaVariables;
  private ICommonsList <PSXPathBoundPattern> m_aBoundPatterns;

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
   *        A custom error listener to be used. May be <code>null</code> in which case a
   *        {@link com.helger.schematron.pure.errorhandler.LoggingPSErrorHandler} is used
   *        internally.
   * @param aCustomValidationHandler
   *        The custom PS validation handler. May be <code>null</code>.
   * @param aXPathConfig
   *        XPath Config to use. If none was provided, <code>null</code> is used.
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

    // Home Edition
    m_aS9Processor = new Processor (false);

    // Wrap the PSErrorHandler to a Saxon ErrorReporter
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
    m_aS9Processor.getUnderlyingConfiguration ().setErrorReporterFactory (aErrReporterFactory);

    // Add the XPath functions now
    if (m_aXPathConfig.getAllEFDs () != null)
      for (final ExtensionFunctionDefinition aEFD : m_aXPathConfig.getAllEFDs ())
        m_aS9Processor.getUnderlyingConfiguration ().registerExtensionFunction (aEFD);
  }

  @Nullable
  private ICommonsList <PSXPathBoundElement> _createBoundElements (@Nonnull final IPSHasMixedContent aMixedContent)
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
            final XPathExecutable aXPathExpression = m_aXPathCompiler.compile (sPath);
            ret.add (new PSXPathBoundElement (aName, sPath, aXPathExpression));
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
        if (aContentElement instanceof PSValueOf)
        {
          final PSValueOf aValueOf = (PSValueOf) aContentElement;

          final String sSelect = aValueOf.getSelect ();
          try
          {
            final XPathExecutable aXPathExpression = m_aXPathCompiler.compile (sSelect);
            ret.add (new PSXPathBoundElement (aValueOf, sSelect, aXPathExpression));
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
  private ICommonsMap <String, PSXPathBoundDiagnostic> _createBoundDiagnostics ()
  {
    final ICommonsMap <String, PSXPathBoundDiagnostic> ret = new CommonsHashMap <> ();
    boolean bHasAnyError = false;

    final PSSchema aSchema = getOriginalSchema ();
    if (aSchema.hasDiagnostics ())
    {
      // For all contained diagnostic elements
      for (final PSDiagnostic aDiagnostic : aSchema.getDiagnostics ().getAllDiagnostics ())
      {
        final ICommonsList <PSXPathBoundElement> aBoundElements = _createBoundElements (aDiagnostic);
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
   * @param aBoundDiagnostics
   *        A map from DiagnosticID to its mapped counterpart. May not be <code>null</code>.
   * @return <code>null</code> if an XPath error is contained
   */
  @Nullable
  private ICommonsList <PSXPathBoundPattern> _createBoundPatterns (@Nonnull final ICommonsMap <String, PSXPathBoundDiagnostic> aBoundDiagnostics)
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
            final XPathExecutable aXPathExpression = m_aXPathCompiler.compile (sLetValue);
            m_aXPathCompiler.declareVariable (new net.sf.saxon.s9api.QName (sLetName));
            if (aPatternVariables.add (sLetName, aXPathExpression).isUnchanged ())
              error (aPattern, "Duplicate <let> with name '" + sLetName + "' in <pattern>");

            // Already defined on a higher level?
            if (m_aSchemaVariables.contains (sLetName))
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
              final XPathExecutable aXPathExpression = m_aXPathCompiler.compile (sLetValue);
              m_aXPathCompiler.declareVariable (new net.sf.saxon.s9api.QName (sLetName));
              if (aRuleVariables.add (sLetName, aXPathExpression).isUnchanged ())
                error (aRule, "Duplicate <let> with name '" + sLetName + "' in <rule>");

              // Already defined on a higher level?
              if (m_aSchemaVariables.contains (sLetName) || aPatternVariables.contains (sLetName))
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
            final XPathExecutable aTestExpr = m_aXPathCompiler.compile (sTest);
            final ICommonsList <PSXPathBoundElement> aBoundElements = _createBoundElements (aAssertReport);
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
          final XPathExecutable aRuleContext = m_aXPathCompiler.compile (sRuleContext);
          aBoundRule = new PSXPathBoundRule (aRule, sRuleContext, aRuleContext, aBoundAssertReports, aRuleVariables);
          aBoundRules.add (aBoundRule);
        }
        catch (final SaxonApiException ex)
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

  @Nonnull
  private XPathCompiler _createXPathCompiler ()
  {
    // Get an XPathCompiler from the processor
    final XPathCompiler aS9XPathCompiler = m_aS9Processor.newXPathCompiler ();

    final IndependentContext aIC = (IndependentContext) aS9XPathCompiler.getUnderlyingStaticContext ();

    // add all namespaces to the context
    for (final var aEntry : getNamespaceContext ().getPrefixToNamespaceURIMap ().entrySet ())
      aIC.declareNamespace (aEntry.getKey (), NamespaceUri.of (aEntry.getValue ()));

    // TODO add variables here
    m_aXPathVariableResolver.toString ();

    return aS9XPathCompiler;
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

    m_aXPathCompiler = _createXPathCompiler ();

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
          final XPathExecutable aXPathExpression = m_aXPathCompiler.compile (sLetValue);
          m_aXPathCompiler.declareVariable (new net.sf.saxon.s9api.QName (sLetName));
          if (m_aSchemaVariables.add (sLetName, aXPathExpression).isUnchanged ())
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
          final XPathExecutable aXPpathExpression = m_aXPathCompiler.compile (sLetValue);
          m_aXPathCompiler.declareVariable (new net.sf.saxon.s9api.QName (sLetName));
          if (m_aSchemaVariables.add (sLetName, aXPpathExpression).isUnchanged ())
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
    final ICommonsMap <String, PSXPathBoundDiagnostic> aBoundDiagnostics = _createBoundDiagnostics ();
    if (aBoundDiagnostics == null)
      throw new SchematronBindException ("Failed to precompile the diagnostics of the supplied schema. Check the " +
                                         (isDefaultErrorHandler () ? "log output" : "error listener") +
                                         " for XPath errors!");

    // Perform the pre-compilation of all XPath expressions in the patterns,
    // rules, asserts/reports and the content elements
    m_aBoundPatterns = _createBoundPatterns (aBoundDiagnostics);
    if (m_aBoundPatterns == null)
      throw new SchematronBindException ("Failed to precompile the supplied schema.");
    return this;
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

  private void _evaluateVariables (@Nonnull final PSXPathVariables aVariables,
                                   @Nonnull final XdmNode aContextNode,
                                   @Nonnull final IPSElement aContextElement)
  {
    for (final var aEntry : aVariables.getAll ().entrySet ())
    {
      final String sVariableName = aEntry.getKey ();
      final XPathExecutable aXPathExpression = aEntry.getValue ();

      XdmValue aEvalResult;
      try
      {
        final XPathSelector aXS = aXPathExpression.load ();
        aXS.setContextItem (aContextNode);
        aEvalResult = aXS.evaluate ();
      }
      catch (final SaxonApiException ex)
      {
        aEvalResult = null;
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

  public void validate (@Nonnull final Node aNode,
                        @Nullable final String sBaseURI,
                        @Nonnull final IPSValidationHandler aValidationHandler) throws SchematronValidationException
  {
    ValueEnforcer.notNull (aNode, "Node");
    ValueEnforcer.notNull (aValidationHandler, "ValidationHandler");

    if (m_aBoundPatterns == null)
      throw new IllegalStateException ("bind was never called!");

    // Validate non-parallelized
    final PSSchema aSchema = getOriginalSchema ();
    final PSPhase aPhase = getPhase ();

    final DocumentWrapper aDocWrapper = new DocumentWrapper (XMLHelper.getOwnerDocument (aNode),
                                                             sBaseURI,
                                                             m_aXPathCompiler.getUnderlyingStaticContext ()
                                                                             .getConfiguration ());
    final DOMNodeWrapper aNodeWrapper = aDocWrapper.wrap (aNode);
    final XdmNode aXdmNode = new XdmNode (aNodeWrapper);

    // Call the "start" callback method
    aValidationHandler.onStart (aSchema, aPhase, sBaseURI);

    // Evaluate schema-global variables
    _evaluateVariables (m_aSchemaVariables, aXdmNode, aSchema);

    // For all bound patterns
    for (final PSXPathBoundPattern aBoundPattern : m_aBoundPatterns)
    {
      final PSPattern aPattern = aBoundPattern.getPattern ();
      aValidationHandler.onPattern (aPattern);

      // Evaluate pattern variables
      _evaluateVariables (aBoundPattern.getVariables (), aXdmNode, aPattern);

      // For all bound rules
      for (final PSXPathBoundRule aBoundRule : aBoundPattern.getAllBoundRules ())
      {
        final PSRule aRule = aBoundRule.getRule ();

        // Find all nodes matching the rules
        final XdmValue aRuleContextNodes;
        try
        {
          final XPathSelector aXS = aBoundRule.getBoundRuleContext ().load ();
          aXS.setContextItem (aXdmNode);
          aRuleContextNodes = aXS.evaluate ();
        }
        catch (final SaxonApiException ex)
        {
          // Handle the cause, because it is usually a wrapper only
          error (aRule,
                 "Failed to evaluate XPath expression to a nodeset: '" + aBoundRule.getRuleContext () + "'",
                 ex.getCause () != null ? ex.getCause () : ex);
          continue;
        }

        aValidationHandler.onRuleStart (aRule, aRuleContextNodes);

        // Check each node, if it matches the assert/report
        final int nRuleMatchingNodes = aRuleContextNodes.size ();
        int nMatchedNode = 0;
        for (final XdmItem aRuleMatchingItem : aRuleContextNodes)
        {
          if (aRuleMatchingItem instanceof XdmNode)
          {
            final XdmNode aRuleMatchingNode = (XdmNode) aRuleMatchingItem;

            // XSLT does "fired-rule" for each node
            aValidationHandler.onFiredRule (aRule, aBoundRule.getRuleContext (), nMatchedNode, nRuleMatchingNodes);

            // Evaluate variables declared in the rule with the context of the
            // matching node
            _evaluateVariables (aBoundRule.getVariables (), aRuleMatchingNode, aRule);

            // For all contained assert and report elements
            for (final PSXPathBoundAssertReport aBoundAssertReport : aBoundRule.getAllBoundAssertReports ())
            {
              final PSAssertReport aAssertReport = aBoundAssertReport.getAssertReport ();
              final boolean bIsAssert = aAssertReport.isAssert ();
              final XPathExecutable aTestExpression = aBoundAssertReport.getBoundTestExpression ();

              try
              {
                final boolean bTestResult = aTestExpression.load ().effectiveBooleanValue ();
                if (bIsAssert)
                {
                  // It's an assert
                  if (!bTestResult)
                  {
                    // Assert failed
                    if (aValidationHandler.onFailedAssert (aBoundRule.getRule (),
                                                           aAssertReport,
                                                           aBoundAssertReport.getTestExpression (),
                                                           aRuleMatchingNode,
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
                                                               aRuleMatchingNode,
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
                                                         aRuleMatchingNode,
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
                                                             aRuleMatchingNode,
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
          else
          {
            warn (aRule,
                  "The resulting item is not a XdmNode but a '" +
                         aRuleMatchingItem.getClass ().getName () +
                         "' - skipping");
          }
          nMatchedNode++;
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
