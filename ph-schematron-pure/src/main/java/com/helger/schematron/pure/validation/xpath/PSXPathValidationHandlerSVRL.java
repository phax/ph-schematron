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
package com.helger.schematron.pure.validation.xpath;

import java.util.List;
import java.util.Map;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.NotThreadSafe;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.collection.CollectionHelper;
import com.helger.commons.error.SingleError;
import com.helger.commons.location.SimpleLocation;
import com.helger.commons.state.EContinue;
import com.helger.commons.string.StringHelper;
import com.helger.schematron.pure.bound.xpath.PSXPathBoundAssertReport;
import com.helger.schematron.pure.bound.xpath.PSXPathBoundDiagnostic;
import com.helger.schematron.pure.bound.xpath.PSXPathBoundElement;
import com.helger.schematron.pure.errorhandler.IPSErrorHandler;
import com.helger.schematron.pure.model.IPSElement;
import com.helger.schematron.pure.model.PSAssertReport;
import com.helger.schematron.pure.model.PSDiagnostics;
import com.helger.schematron.pure.model.PSDir;
import com.helger.schematron.pure.model.PSEmph;
import com.helger.schematron.pure.model.PSName;
import com.helger.schematron.pure.model.PSPattern;
import com.helger.schematron.pure.model.PSPhase;
import com.helger.schematron.pure.model.PSRichGroup;
import com.helger.schematron.pure.model.PSRule;
import com.helger.schematron.pure.model.PSSchema;
import com.helger.schematron.pure.model.PSSpan;
import com.helger.schematron.pure.model.PSTitle;
import com.helger.schematron.pure.model.PSValueOf;
import com.helger.schematron.pure.validation.IPSValidationHandler;
import com.helger.schematron.pure.validation.SchematronValidationException;
import com.helger.schematron.svrl.jaxb.ActivePattern;
import com.helger.schematron.svrl.jaxb.DiagnosticReference;
import com.helger.schematron.svrl.jaxb.FailedAssert;
import com.helger.schematron.svrl.jaxb.FiredRule;
import com.helger.schematron.svrl.jaxb.NsPrefixInAttributeValues;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.schematron.svrl.jaxb.SuccessfulReport;
import com.helger.schematron.svrl.jaxb.Text;
import com.helger.xml.namespace.MapBasedNamespaceContext;

import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.XdmNode;

/**
 * A special validation handler that creates an SVRL document. This class only works for the XPath
 * binding, as the special {@link PSXPathBoundAssertReport} class is referenced!<br>
 * See https://schematron.com/document/3464.html for the proposed default mapping from SCH to SVRL
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class PSXPathValidationHandlerSVRL implements IPSValidationHandler
{
  private static final Logger LOGGER = LoggerFactory.getLogger (PSXPathValidationHandlerSVRL.class);

  private final IPSErrorHandler m_aErrorHandler;
  private SchematronOutputType m_aSchematronOutput;
  private PSSchema m_aSchema;
  private MapBasedNamespaceContext m_aNSContext;
  private String m_sBaseURI;

  /**
   * Constructor
   *
   * @param aErrorHandler
   *        The error handler to be used. May not be <code>null</code>.
   */
  public PSXPathValidationHandlerSVRL (@Nonnull final IPSErrorHandler aErrorHandler)
  {
    ValueEnforcer.notNull (aErrorHandler, "ErrorHandler");
    m_aErrorHandler = aErrorHandler;
  }

  @Nonnull
  public final IPSErrorHandler getErrorHandler ()
  {
    return m_aErrorHandler;
  }

  private void _onWarn (@Nonnull final IPSElement aSourceElement, @Nonnull final String sMsg)
  {
    if (m_aSchema == null)
      throw new IllegalStateException ("No schema is present!");

    getErrorHandler ().handleError (SingleError.builderWarn ()
                                               .errorLocation (new SimpleLocation (m_aSchema.getResource ().getPath ()))
                                               .errorFieldName (IPSErrorHandler.getErrorFieldName (aSourceElement))
                                               .errorText (sMsg)
                                               .build ());
  }

  private void _onError (@Nonnull final IPSElement aSourceElement,
                         @Nonnull final String sMsg,
                         @Nullable final Throwable t)
  {
    if (m_aSchema == null)
      throw new IllegalStateException ("No schema is present!");

    getErrorHandler ().handleError (SingleError.builderError ()
                                               .errorLocation (new SimpleLocation (m_aSchema.getResource ().getPath ()))
                                               .errorFieldName (IPSErrorHandler.getErrorFieldName (aSourceElement))
                                               .errorText (sMsg)
                                               .linkedException (t)
                                               .build ());
  }

  @Nullable
  private static String _getTitleAsString (@Nullable final PSTitle aTitle) throws SchematronValidationException
  {
    if (aTitle == null)
      return null;

    final StringBuilder aSB = new StringBuilder ();
    for (final Object aContent : aTitle.getAllContentElements ())
    {
      if (aContent instanceof String)
        aSB.append ((String) aContent);
      else
        if (aContent instanceof PSDir)
          aSB.append (((PSDir) aContent).getAsText ());
        else
          throw new SchematronValidationException ("Unsupported title content element: " + aContent);
    }
    return aSB.toString ();
  }

  @Override
  public void onStart (@Nonnull final PSSchema aSchema,
                       @Nullable final PSPhase aActivePhase,
                       @Nullable final String sBaseURI) throws SchematronValidationException
  {
    final SchematronOutputType aSchematronOutput = new SchematronOutputType ();
    if (aActivePhase != null)
      aSchematronOutput.setPhase (aActivePhase.getID ());
    aSchematronOutput.setSchemaVersion (aSchema.getSchemaVersion ());
    aSchematronOutput.setTitle (_getTitleAsString (aSchema.getTitle ()));

    // Add namespace prefixes
    m_aSchematronOutput = aSchematronOutput;
    m_aSchema = aSchema;
    m_aNSContext = aSchema.getAsNamespaceContext ();
    m_sBaseURI = sBaseURI;

    for (final Map.Entry <String, String> aEntry : m_aNSContext.getPrefixToNamespaceURIMap ().entrySet ())
    {
      final NsPrefixInAttributeValues aNsPrefix = new NsPrefixInAttributeValues ();
      aNsPrefix.setPrefix (aEntry.getKey ());
      aNsPrefix.setUri (aEntry.getValue ());
      aSchematronOutput.getNsPrefixInAttributeValues ().add (aNsPrefix);
    }
  }

  @Override
  public void onPattern (@Nonnull final PSPattern aPattern) throws SchematronValidationException
  {
    final ActivePattern aRetPattern = new ActivePattern ();
    // TODO documents
    aRetPattern.setId (aPattern.getID ());
    if (aPattern.hasTitle ())
      aRetPattern.setName (_getTitleAsString (aPattern.getTitle ()));
    // TODO role
    m_aSchematronOutput.addActivePatternAndFiredRuleAndFailedAssert (aRetPattern);
  }

  @Override
  public void onFiredRule (@Nonnull final PSRule aRule,
                           @Nonnull final String sContext,
                           @Nonnull final int nNodeIndex,
                           @Nonnull final int nNodeCount)
  {
    final FiredRule aRetRule = new FiredRule ();
    aRetRule.setContext (sContext);
    aRetRule.setFlag (aRule.getFlag ());
    aRetRule.setId (aRule.getID ());
    if (aRule.hasLinkable ())
      aRetRule.setRole (aRule.getLinkable ().getRole ());
    final PSRichGroup aRich = aRule.getRich ();
    if (aRich != null)
    {
      aRetRule.setLang (aRich.getXmlLang ());
      if (aRich.hasXmlSpace ())
        aRetRule.setSpace (aRich.getXmlSpace ().getID ());
      aRetRule.setIcon (aRich.getIcon ());
      aRetRule.setSee (aRich.getSee ());
      aRetRule.setFpi (aRich.getFPI ());
    }
    m_aSchematronOutput.addActivePatternAndFiredRuleAndFailedAssert (aRetRule);
  }

  /**
   * Get the error text from an assert or report element.
   *
   * @param aBoundContentElements
   *        The list of bound elements to be evaluated.
   * @param aSourceNode
   *        The XML node of the document currently validated.
   * @param aEvaluationException
   *        An optional exception that may occur while evaluating the test expression. May be
   *        <code>null</code>.
   * @param sTestExpression
   *        The test expression that was evaluated. May be <code>null</code>.
   * @return A non-<code>null</code> String
   * @throws SchematronValidationException
   *         In case evaluating an XPath expression fails.
   */
  @Nonnull
  private Text _getErrorText (@Nonnull final List <PSXPathBoundElement> aBoundContentElements,
                              @Nonnull final XdmNode aSourceNode,
                              @Nullable final Exception aEvaluationException,
                              @Nullable final String sTestExpression) throws SchematronValidationException
  {
    final StringBuilder aSB = new StringBuilder ();
    if (aEvaluationException != null)
    {
      aSB.append ("Failed to evaluate XPath expression to a boolean.\nTest: '" +
                  sTestExpression +
                  "'\nError: " +
                  (aEvaluationException.getCause () != null ? aEvaluationException.getCause () : aEvaluationException)
                                                                                                                      .getMessage ());
    }
    else
    {
      for (final PSXPathBoundElement aBoundElement : aBoundContentElements)
      {
        final Object aContent = aBoundElement.getElement ();
        if (aContent instanceof String)
          aSB.append ((String) aContent);
        else
          if (aContent instanceof PSName)
          {
            final PSName aName = (PSName) aContent;
            if (aName.hasPath ())
            {
              // XPath present
              try
              {
                aSB.append (aBoundElement.getBoundExpression ().load ().evaluateSingle ().toString ());
              }
              catch (final SaxonApiException ex)
              {
                _onError (aName,
                          "Failed to evaluate XPath expression to a string: '" + aBoundElement.getExpression () + "'",
                          ex.getCause () != null ? ex.getCause () : ex);
                // Append the path so that something is present in the output
                aSB.append (aName.getPath ());
              }
            }
            else
            {
              // No XPath present
              // TODO fix node name
              // aSB.append (aSourceNode.getNodeName ());
            }
          }
          else
            if (aContent instanceof PSValueOf)
            {
              final PSValueOf aValueOf = (PSValueOf) aContent;
              try
              {
                aSB.append (aBoundElement.getBoundExpression ().load ().evaluateSingle ().toString ());
              }
              catch (final SaxonApiException ex)
              {
                _onError (aValueOf,
                          "Failed to evaluate XPath expression to a string: '" + aBoundElement.getExpression () + "'",
                          ex);
                // Append the path so that something is present in the output
                aSB.append (aValueOf.getSelect ());
              }
            }
            else
              if (aContent instanceof PSEmph)
                aSB.append (((PSEmph) aContent).getAsText ());
              else
                if (aContent instanceof PSDir)
                  aSB.append (((PSDir) aContent).getAsText ());
                else
                  if (aContent instanceof PSSpan)
                    aSB.append (((PSSpan) aContent).getAsText ());
                  else
                    throw new SchematronValidationException ("Unsupported assert/report content element: " + aContent);
      }
    }

    final Text ret = new Text ();
    ret.addContent (aSB.toString ());
    return ret;
  }

  /**
   * Handle the diagnostic references of a single assert/report element
   *
   * @param aSrcDiagnostics
   *        The list of diagnostic reference IDs in the source assert/report element. May be
   *        <code>null</code> if no diagnostic references are present
   * @param aDstList
   *        The diagnostic reference list of the SchematronOutput to be filled. May not be
   *        <code>null</code>.
   * @param aBoundAssertReport
   *        The bound assert report element. Never <code>null</code>.
   * @param aRuleMatchingNode
   *        The XML node of the XML document currently validated. Never <code>null</code>.
   * @throws SchematronValidationException
   */
  private void _handleDiagnosticReferences (@Nullable final List <String> aSrcDiagnostics,
                                            @Nonnull final List <? super DiagnosticReference> aDstList,
                                            @Nonnull final PSXPathBoundAssertReport aBoundAssertReport,
                                            @Nonnull final XdmNode aRuleMatchingNode) throws SchematronValidationException
  {
    if (CollectionHelper.isNotEmpty (aSrcDiagnostics))
    {
      if (m_aSchema.hasDiagnostics ())
      {
        final PSDiagnostics aDiagnostics = m_aSchema.getDiagnostics ();
        for (final String sDiagnosticID : aSrcDiagnostics)
        {
          final PSXPathBoundDiagnostic aDiagnostic = aBoundAssertReport.getBoundDiagnosticOfID (sDiagnosticID);
          if (aDiagnostic == null)
            _onWarn (aDiagnostics, "Failed to resolve diagnostics with ID '" + sDiagnosticID + "'");
          else
          {
            // Create the SVRL diagnostic-reference element
            final DiagnosticReference aDR = new DiagnosticReference ();
            aDR.setDiagnostic (sDiagnosticID);
            final PSRichGroup aRich = aDiagnostic.getDiagnostic ().getRich ();
            if (aRich != null)
            {
              aDR.setLang (aRich.getXmlLang ());
              if (aRich.hasXmlSpace ())
                aDR.setSpace (aRich.getXmlSpace ().getID ());
              aDR.setIcon (aRich.getIcon ());
              aDR.setSee (aRich.getSee ());
              aDR.setFpi (aRich.getFPI ());
            }
            aDR.getContent ()
               .add (_getErrorText (aDiagnostic.getAllBoundContentElements (), aRuleMatchingNode, null, null));
            aDstList.add (aDR);
          }
        }
      }
      else
        _onWarn (m_aSchema, "Failed to resolve diagnostic because schema has no diagnostics");
    }
  }

  @Nonnull
  private String _getPathToNode (@Nonnull final XdmNode aNode)
  {
    // TODO resolve path
    return aNode.getStringValue ();
    /*
     * final String ret = XMLHelper.pathToNodeBuilder () .node (aNode) .separator ("/")
     * .excludeDocumentNode () .oneBasedIndex () .forceUseIndex (false) .trailingSeparator (false)
     * .compareIncludingNamespaceURI (true) .namespaceContext (m_aNSContext) .build (); if
     * (LOGGER.isTraceEnabled ()) LOGGER.trace ("Converted Node to path '" + ret + "'"); return ret;
     */
  }

  @Nonnull
  private String _getLocation (@Nonnull final PSRule aOwningRule,
                               @Nonnull final PSAssertReport aAssertReport,
                               @Nonnull final XdmNode aRuleMatchingNode)
  {
    String sLocation = null;
    if (aAssertReport.hasLinkable ())
      sLocation = aAssertReport.getLinkable ().getSubject ();
    if (StringHelper.hasNoText (sLocation))
    {
      if (aOwningRule.hasLinkable ())
        sLocation = aOwningRule.getLinkable ().getSubject ();
      if (StringHelper.hasNoText (sLocation))
        sLocation = true ? _getPathToNode (aRuleMatchingNode) : aOwningRule.getContext ();
    }
    return sLocation;
  }

  @Override
  @Nonnull
  public EContinue onFailedAssert (@Nonnull final PSRule aOwningRule,
                                   @Nonnull final PSAssertReport aAssertReport,
                                   @Nonnull final String sTestExpression,
                                   @Nonnull final XdmNode aRuleMatchingNode,
                                   final int nNodeIndex,
                                   @Nullable final Object aContext,
                                   @Nullable final Exception aEvaluationException) throws SchematronValidationException
  {
    if (!(aContext instanceof PSXPathBoundAssertReport))
      throw new SchematronValidationException ("The passed context must be a PSXPathBoundAssertReport object but is a " +
                                               aContext);
    final PSXPathBoundAssertReport aBoundAssertReport = (PSXPathBoundAssertReport) aContext;

    final FailedAssert aFailedAssert = new FailedAssert ();
    aFailedAssert.setFlag (aAssertReport.getFlag ());
    aFailedAssert.setId (aAssertReport.getID ());
    aFailedAssert.setLocation (_getLocation (aOwningRule, aAssertReport, aRuleMatchingNode));
    if (aAssertReport.hasLinkable ())
      aFailedAssert.setRole (aAssertReport.getLinkable ().getRole ());
    aFailedAssert.setTest (sTestExpression);
    aFailedAssert.addDiagnosticReferenceOrPropertyReferenceOrText (_getErrorText (aBoundAssertReport.getAllBoundContentElements (),
                                                                                  aRuleMatchingNode,
                                                                                  aEvaluationException,
                                                                                  sTestExpression));
    _handleDiagnosticReferences (aAssertReport.getAllDiagnostics (),
                                 aFailedAssert.getDiagnosticReferenceOrPropertyReferenceOrText (),
                                 aBoundAssertReport,
                                 aRuleMatchingNode);
    m_aSchematronOutput.addActivePatternAndFiredRuleAndFailedAssert (aFailedAssert);
    return EContinue.CONTINUE;
  }

  @Override
  @Nonnull
  public EContinue onSuccessfulReport (@Nonnull final PSRule aOwningRule,
                                       @Nonnull final PSAssertReport aAssertReport,
                                       @Nonnull final String sTestExpression,
                                       @Nonnull final XdmNode aRuleMatchingNode,
                                       final int nNodeIndex,
                                       @Nullable final Object aContext,
                                       @Nullable final Exception aEvaluationException) throws SchematronValidationException
  {
    if (!(aContext instanceof PSXPathBoundAssertReport))
      throw new SchematronValidationException ("The passed context must be a PSXPathBoundAssertReport object but is a " +
                                               aContext);
    final PSXPathBoundAssertReport aBoundAssertReport = (PSXPathBoundAssertReport) aContext;

    final SuccessfulReport aSuccessfulReport = new SuccessfulReport ();
    aSuccessfulReport.setFlag (aAssertReport.getFlag ());
    aSuccessfulReport.setId (aAssertReport.getID ());
    aSuccessfulReport.setLocation (_getLocation (aOwningRule, aAssertReport, aRuleMatchingNode));
    if (aAssertReport.hasLinkable ())
      aSuccessfulReport.setRole (aAssertReport.getLinkable ().getRole ());
    aSuccessfulReport.setTest (sTestExpression);
    aSuccessfulReport.addDiagnosticReferenceOrPropertyReferenceOrText (_getErrorText (aBoundAssertReport.getAllBoundContentElements (),
                                                                                      aRuleMatchingNode,
                                                                                      aEvaluationException,
                                                                                      sTestExpression));
    _handleDiagnosticReferences (aAssertReport.getAllDiagnostics (),
                                 aSuccessfulReport.getDiagnosticReferenceOrPropertyReferenceOrText (),
                                 aBoundAssertReport,
                                 aRuleMatchingNode);
    m_aSchematronOutput.addActivePatternAndFiredRuleAndFailedAssert (aSuccessfulReport);
    return EContinue.CONTINUE;
  }

  @Nullable
  public SchematronOutputType getSVRL ()
  {
    return m_aSchematronOutput;
  }
}
