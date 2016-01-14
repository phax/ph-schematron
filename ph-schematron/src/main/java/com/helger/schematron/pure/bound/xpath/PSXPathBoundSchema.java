/**
 * Copyright (C) 2014-2016 Philip Helger (www.helger.com)
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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.Immutable;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;
import javax.xml.xpath.XPathFunctionResolver;
import javax.xml.xpath.XPathVariableResolver;

import org.oclc.purl.dsdl.svrl.SchematronOutputType;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.lang.ClassLoaderHelper;
import com.helger.commons.string.ToStringGenerator;
import com.helger.commons.xml.xpath.XPathHelper;
import com.helger.schematron.pure.binding.IPSQueryBinding;
import com.helger.schematron.pure.binding.SchematronBindException;
import com.helger.schematron.pure.binding.xpath.IPSXPathVariables;
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
import com.helger.schematron.pure.validation.xpath.PSXPathValidationHandlerSVRL;
import com.helger.schematron.xslt.util.PSErrorListener;

import net.sf.saxon.lib.FeatureKeys;
import net.sf.saxon.xpath.XPathEvaluator;

/**
 * The default XPath binding for the pure Schematron implementation.
 *
 * @author Philip Helger
 */
@Immutable
public class PSXPathBoundSchema extends AbstractPSBoundSchema
{
  private final XPathVariableResolver m_aXPathVariableResolver;
  private final XPathFunctionResolver m_aXPathFunctionResolver;
  private final XPathFactory m_aXPathFactory;
  private List <PSXPathBoundPattern> m_aBoundPatterns;

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
    XPathExpression ret = null;
    try
    {
      ret = aXPathContext.compile (sXPathExpression);
    }
    catch (final XPathExpressionException ex)
    {
      // Do something with it
      throw ex;
    }
    return ret;
  }

  @Nullable
  private List <PSXPathBoundElement> _createBoundElements (@Nonnull final IPSHasMixedContent aMixedContent,
                                                           @Nonnull final XPath aXPathContext,
                                                           @Nonnull final IPSXPathVariables aVariables)
  {
    final List <PSXPathBoundElement> ret = new ArrayList <PSXPathBoundElement> ();
    boolean bHasAnyError = false;

    for (final Object aContentElement : aMixedContent.getAllContentElements ())
    {
      if (aContentElement instanceof PSName)
      {
        final PSName aName = (PSName) aContentElement;
        if (aName.hasPath ())
        {
          // Replace all variables
          final String sPath = aVariables.getAppliedReplacement (aName.getPath ());
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

          // Replace variables
          final String sSelect = aVariables.getAppliedReplacement (aValueOf.getSelect ());
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
  private Map <String, PSXPathBoundDiagnostic> _createBoundDiagnostics (@Nonnull final XPath aXPathContext,
                                                                        @Nonnull final IPSXPathVariables aGlobalVariables)
  {
    final Map <String, PSXPathBoundDiagnostic> ret = new HashMap <String, PSXPathBoundDiagnostic> ();
    boolean bHasAnyError = false;

    final PSSchema aSchema = getOriginalSchema ();
    if (aSchema.hasDiagnostics ())
    {
      // For all contained diagnostic elements
      for (final PSDiagnostic aDiagnostic : aSchema.getDiagnostics ().getAllDiagnostics ())
      {
        final List <PSXPathBoundElement> aBoundElements = _createBoundElements (aDiagnostic,
                                                                                aXPathContext,
                                                                                aGlobalVariables);
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
   * @param aXPathContext
   *        Global XPath object to use. May not be <code>null</code>.
   * @param aBoundDiagnostics
   *        A map from DiagnosticID to its mapped counterpart. May not be
   *        <code>null</code>.
   * @param aGlobalVariables
   *        The global Schematron-let variables. May not be <code>null</code>.
   * @return <code>null</code> if an XPath error is contained
   */
  @Nullable
  private List <PSXPathBoundPattern> _createBoundPatterns (@Nonnull final XPath aXPathContext,
                                                           @Nonnull final Map <String, PSXPathBoundDiagnostic> aBoundDiagnostics,
                                                           @Nonnull final IPSXPathVariables aGlobalVariables)
  {
    final List <PSXPathBoundPattern> ret = new ArrayList <PSXPathBoundPattern> ();
    boolean bHasAnyError = false;

    // For all relevant patterns
    for (final PSPattern aPattern : getAllRelevantPatterns ())
    {
      // Handle pattern specific variables
      final PSXPathVariables aPatternVariables = aGlobalVariables.getClone ();

      if (aPattern.hasAnyLet ())
      {
        // The pattern has special variables, so we need to extend the variable
        // map
        for (final Map.Entry <String, String> aEntry : aPattern.getAllLetsAsMap ().entrySet ())
          if (aPatternVariables.add (aEntry).isUnchanged ())
            error (aPattern, "Duplicate <let> with name '" + aEntry.getKey () + "' in <pattern>");
      }

      // For all rules of the current pattern
      final List <PSXPathBoundRule> aBoundRules = new ArrayList <PSXPathBoundRule> ();
      for (final PSRule aRule : aPattern.getAllRules ())
      {
        // Handle rule specific variables
        final PSXPathVariables aRuleVariables = aPatternVariables.getClone ();
        if (aRule.hasAnyLet ())
        {
          // The rule has special variables, so we need to extend the
          // variable map
          for (final Map.Entry <String, String> aEntry : aRule.getAllLetsAsMap ().entrySet ())
          {
            if (aRuleVariables.add (aEntry).isUnchanged ())
            {
              error (aRule, "Duplicate <let> with name '" + aEntry.getKey () + "' in <rule>");
            }
          }
        }

        // For all contained assert and reports within the current rule
        final List <PSXPathBoundAssertReport> aBoundAssertReports = new ArrayList <PSXPathBoundAssertReport> ();
        for (final PSAssertReport aAssertReport : aRule.getAllAssertReports ())
        {
          final String sTest = aRuleVariables.getAppliedReplacement (aAssertReport.getTest ());
          try
          {
            final XPathExpression aTestExpr = _compileXPath (aXPathContext, sTest);
            final List <PSXPathBoundElement> aBoundElements = _createBoundElements (aAssertReport,
                                                                                    aXPathContext,
                                                                                    aRuleVariables);
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
          catch (final Throwable t)
          {
            error (aAssertReport, "Failed to compile XPath expression in <" +
                                  (aAssertReport.isAssert () ? "assert" : "report") +
                                  ">: '" +
                                  sTest +
                                  "' with the following variables: " +
                                  aRuleVariables.getAll (), t);
            bHasAnyError = true;
          }
        }

        // Evaluate base node set for this rule
        final String sRuleContext = aGlobalVariables.getAppliedReplacement (getValidationContext (aRule.getContext ()));
        PSXPathBoundRule aBoundRule = null;
        try
        {
          final XPathExpression aRuleContext = _compileXPath (aXPathContext, sRuleContext);
          aBoundRule = new PSXPathBoundRule (aRule, sRuleContext, aRuleContext, aBoundAssertReports);
          aBoundRules.add (aBoundRule);
        }
        catch (final XPathExpressionException ex)
        {
          error (aRule, "Failed to compile XPath expression in <rule>: '" + sRuleContext + "'", ex);
          bHasAnyError = true;
        }
      }

      // Create the bound pattern
      final PSXPathBoundPattern aBoundPattern = new PSXPathBoundPattern (aPattern, aBoundRules);
      ret.add (aBoundPattern);
    }

    if (bHasAnyError)
      return null;

    return ret;
  }

  @Nonnull
  public static XPathFactory createXPathFactorySaxonFirst () throws SchematronBindException
  {
    // The XPath object used to compile the expressions
    XPathFactory aXPathFactory;
    try
    {
      // First try to use Saxon, using the context class loader
      aXPathFactory = XPathFactory.newInstance (XPathFactory.DEFAULT_OBJECT_MODEL_URI,
                                                "net.sf.saxon.xpath.XPathFactoryImpl",
                                                ClassLoaderHelper.getContextClassLoader ());
    }
    catch (final Exception ex)
    {
      // Seems like Saxon is not in the class path - fall back to default JAXP
      try
      {
        aXPathFactory = XPathFactory.newInstance (XPathFactory.DEFAULT_OBJECT_MODEL_URI);
      }
      catch (final Exception ex2)
      {
        throw new SchematronBindException ("Failed to create JAXP XPathFactory", ex2);
      }
    }
    return aXPathFactory;
  }

  /**
   * Create a new bound schema. All the XPath pre-compilation happens inside
   * this constructor, so that the {@link #validate(Node, IPSValidationHandler)}
   * method can be called many times without compiling the XPath statements
   * again and again.
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
   * @param aXPathVariableResolver
   *        Custom XPath variable resolver. May be <code>null</code>.
   * @param aXPathFunctionResolver
   *        Custom XPath function resolver. May be <code>null</code>.
   * @throws SchematronBindException
   *         In case XPath expressions are incorrect and pre-compilation fails
   */
  public PSXPathBoundSchema (@Nonnull final IPSQueryBinding aQueryBinding,
                             @Nonnull final PSSchema aOrigSchema,
                             @Nullable final String sPhase,
                             @Nullable final IPSErrorHandler aCustomErrorListener,
                             @Nullable final XPathVariableResolver aXPathVariableResolver,
                             @Nullable final XPathFunctionResolver aXPathFunctionResolver) throws SchematronBindException
  {
    super (aQueryBinding, aOrigSchema, sPhase, aCustomErrorListener);
    m_aXPathVariableResolver = aXPathVariableResolver;
    m_aXPathFunctionResolver = aXPathFunctionResolver;
    m_aXPathFactory = createXPathFactorySaxonFirst ();
  }

  @Nonnull
  private XPath _createXPathContext ()
  {
    final XPath aXPathContext = XPathHelper.createNewXPath (m_aXPathFactory,
                                                            m_aXPathVariableResolver,
                                                            m_aXPathFunctionResolver,
                                                            getNamespaceContext ());

    if (aXPathContext instanceof XPathEvaluator)
    {
      // Saxon implementation special handling
      final XPathEvaluator aSaxonXPath = (XPathEvaluator) aXPathContext;
      if (false)
      {
        // Enable this to debug Saxon function resolving
        aSaxonXPath.getConfiguration ().setBooleanProperty (FeatureKeys.TRACE_EXTERNAL_FUNCTIONS, true);
      }

      // Wrap the PSErrorHandler to a ErrorListener
      aSaxonXPath.getConfiguration ().setErrorListener (new PSErrorListener (getErrorHandler ()));
    }
    return aXPathContext;
  }

  @Nonnull
  public PSXPathBoundSchema bind () throws SchematronBindException
  {
    if (m_aBoundPatterns != null)
      throw new IllegalStateException ("bind must only be called once!");

    final PSSchema aSchema = getOriginalSchema ();
    final PSPhase aPhase = getPhase ();

    // Get all "global" variables that are defined in the schema
    final PSXPathVariables aGlobalVariables = new PSXPathVariables ();
    if (aSchema.hasAnyLet ())
      for (final Map.Entry <String, String> aEntry : aSchema.getAllLetsAsMap ().entrySet ())
        if (aGlobalVariables.add (aEntry).isUnchanged ())
          error (aSchema, "Duplicate <let> with name '" + aEntry.getKey () + "' in global <schema>");

    if (aPhase != null)
    {
      // Get all variables that are defined in the specified phase
      for (final Map.Entry <String, String> aEntry : aPhase.getAllLetsAsMap ().entrySet ())
        if (aGlobalVariables.add (aEntry).isUnchanged ())
          error (aSchema, "Duplicate <let> with name '" +
                          aEntry.getKey () +
                          "' in <phase> with name '" +
                          getPhaseID () +
                          "'");
    }

    final XPath aXPathContext = _createXPathContext ();

    // Pre-compile all diagnostics first
    final Map <String, PSXPathBoundDiagnostic> aBoundDiagnostics = _createBoundDiagnostics (aXPathContext,
                                                                                            aGlobalVariables);
    if (aBoundDiagnostics == null)
      throw new SchematronBindException ("Failed to precompile the diagnostics of the supplied schema. Check the " +
                                         (isDefaultErrorHandler () ? "log output" : "error listener") +
                                         " for XPath errors!");

    // Perform the pre-compilation of all XPath expressions in the patterns,
    // rules, asserts/reports and the content elements
    m_aBoundPatterns = _createBoundPatterns (aXPathContext, aBoundDiagnostics, aGlobalVariables);
    if (m_aBoundPatterns == null)
      throw new SchematronBindException ("Failed to precompile the supplied schema.");
    return this;
  }

  @Nullable
  public XPathVariableResolver getXPathVariableResolver ()
  {
    return m_aXPathVariableResolver;
  }

  @Nullable
  public XPathFunctionResolver getXPathFunctionResolver ()
  {
    return m_aXPathFunctionResolver;
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

  public void validate (@Nonnull final Node aNode, @Nonnull final IPSValidationHandler aValidationHandler) throws SchematronValidationException
  {
    ValueEnforcer.notNull (aNode, "Node");
    ValueEnforcer.notNull (aValidationHandler, "ValidationHandler");

    if (m_aBoundPatterns == null)
      throw new IllegalStateException ("bind was never called!");

    final PSSchema aSchema = getOriginalSchema ();
    final PSPhase aPhase = getPhase ();

    // Call the "start" callback method
    aValidationHandler.onStart (aSchema, aPhase);

    // For all bound patterns
    for (final PSXPathBoundPattern aBoundPattern : m_aBoundPatterns)
    {
      final PSPattern aPattern = aBoundPattern.getPattern ();
      aValidationHandler.onPattern (aPattern);

      // For all bound rules
      rules: for (final PSXPathBoundRule aBoundRule : aBoundPattern.getAllBoundRules ())
      {
        final PSRule aRule = aBoundRule.getRule ();

        // Find all nodes matching the rules
        NodeList aRuleMatchingNodes = null;
        try
        {
          aRuleMatchingNodes = (NodeList) aBoundRule.getBoundRuleExpression ().evaluate (aNode, XPathConstants.NODESET);
        }
        catch (final XPathExpressionException ex)
        {
          error (aRule,
                 "Failed to evaluate XPath expression to a nodeset: '" + aBoundRule.getRuleExpression () + "'",
                 ex);
          continue rules;
        }

        final int nRuleMatchingNodes = aRuleMatchingNodes.getLength ();
        if (nRuleMatchingNodes > 0)
        {
          // For all contained assert and report elements
          for (final PSXPathBoundAssertReport aBoundAssertReport : aBoundRule.getAllBoundAssertReports ())
          {
            // XSLT does "fired-rule" for each node
            aValidationHandler.onRule (aRule, aBoundRule.getRuleExpression ());

            final PSAssertReport aAssertReport = aBoundAssertReport.getAssertReport ();
            final boolean bIsAssert = aAssertReport.isAssert ();
            final XPathExpression aTestExpression = aBoundAssertReport.getBoundTestExpression ();

            // Check each node, if it matches the assert/report
            for (int i = 0; i < nRuleMatchingNodes; ++i)
            {
              final Node aRuleMatchingNode = aRuleMatchingNodes.item (i);
              try
              {
                final boolean bTestResult = ((Boolean) aTestExpression.evaluate (aRuleMatchingNode,
                                                                                 XPathConstants.BOOLEAN)).booleanValue ();
                if (bIsAssert)
                {
                  // It's an assert
                  if (!bTestResult)
                  {
                    // Assert failed
                    if (aValidationHandler.onFailedAssert (aAssertReport,
                                                           aBoundAssertReport.getTestExpression (),
                                                           aRuleMatchingNode,
                                                           i,
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
                                                               i,
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
                       ex);
              }
            }
          }

          if (false)
          {
            // The rule matched at least one node. In this case continue with
            // the next pattern
            break rules;
          }
        }
      }
    }

    // Call the "end" callback method
    aValidationHandler.onEnd (aSchema, aPhase);
  }

  @Nonnull
  public SchematronOutputType validateComplete (@Nonnull final Node aNode) throws SchematronValidationException
  {
    final PSXPathValidationHandlerSVRL aValidationHandler = new PSXPathValidationHandlerSVRL (getErrorHandler ());
    validate (aNode, aValidationHandler);
    return aValidationHandler.getSVRL ();
  }

  @Override
  public String toString ()
  {
    return ToStringGenerator.getDerived (super.toString ()).append ("boundPatterns", m_aBoundPatterns).toString ();
  }
}
