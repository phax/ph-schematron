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
package com.helger.schematron.pure.validation.xpath;

import java.util.List;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Attr;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.location.SimpleLocation;
import com.helger.base.state.EContinue;
import com.helger.base.string.StringHelper;
import com.helger.collection.CollectionHelper;
import com.helger.collection.commons.CommonsHashMap;
import com.helger.collection.commons.ICommonsMap;
import com.helger.diagnostics.error.SingleError;
import com.helger.schematron.errorhandler.IPSErrorHandler;
import com.helger.schematron.model.IPSElement;
import com.helger.schematron.model.PSAssertReport;
import com.helger.schematron.model.PSDiagnostics;
import com.helger.schematron.model.PSDir;
import com.helger.schematron.model.PSEmph;
import com.helger.schematron.model.PSName;
import com.helger.schematron.model.PSPattern;
import com.helger.schematron.model.PSPhase;
import com.helger.schematron.model.PSRule;
import com.helger.schematron.model.PSSchema;
import com.helger.schematron.model.PSSpan;
import com.helger.schematron.model.PSTitle;
import com.helger.schematron.model.PSValueOf;
import com.helger.schematron.pure.bound.xpath.PSXPathBoundAssertReport;
import com.helger.schematron.pure.bound.xpath.PSXPathBoundDiagnostic;
import com.helger.schematron.pure.bound.xpath.PSXPathBoundElement;
import com.helger.schematron.pure.validation.IPSValidationHandler;
import com.helger.schematron.pure.validation.SchematronValidationException;
import com.helger.schematron.pure.xpath.XPathEvaluationContext;
import com.helger.schematron.pure.xpath.XPathEvaluationHelper;
import com.helger.schematron.svrl.jaxb.ActivePattern;
import com.helger.schematron.svrl.jaxb.DiagnosticReference;
import com.helger.schematron.svrl.jaxb.FailedAssert;
import com.helger.schematron.svrl.jaxb.FiredRule;
import com.helger.schematron.svrl.jaxb.NsPrefixInAttributeValues;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.schematron.svrl.jaxb.SuccessfulReport;
import com.helger.schematron.svrl.jaxb.Text;
import com.helger.xml.XMLHelper;
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
  /**
   * The number of child elements with the same name, used to create the location paths.
   */
  private static final class SiblingNameCount
  {
    private int m_nTotal;
    private int m_nHandled;
  }

  private static final Logger LOGGER = LoggerFactory.getLogger (PSXPathValidationHandlerSVRL.class);

  private final IPSErrorHandler m_aErrorHandler;
  private final MapBasedNamespaceContext m_aSchemaNSContext;
  // The location path of all element nodes that were already used, per validation
  private final ICommonsMap <Node, String> m_aElementPaths = new CommonsHashMap <> ();
  private SchematronOutputType m_aSchematronOutput;
  private PSSchema m_aSchema;
  private MapBasedNamespaceContext m_aNSContext;

  /**
   * Constructor
   *
   * @param aErrorHandler
   *        The error handler to be used. May not be <code>null</code>.
   */
  public PSXPathValidationHandlerSVRL (@NonNull final IPSErrorHandler aErrorHandler)
  {
    this (aErrorHandler, null);
  }

  /**
   * Constructor
   *
   * @param aErrorHandler
   *        The error handler to be used. May not be <code>null</code>.
   * @param aSchemaNSContext
   *        The namespace context of the schema to be validated, as created by
   *        {@link PSSchema#getAsNamespaceContext()}. It is only read. May be <code>null</code> in
   *        which case it is created from the schema for every validation.
   * @since 11.0.0
   */
  public PSXPathValidationHandlerSVRL (@NonNull final IPSErrorHandler aErrorHandler,
                                       @Nullable final MapBasedNamespaceContext aSchemaNSContext)
  {
    ValueEnforcer.notNull (aErrorHandler, "ErrorHandler");
    m_aErrorHandler = aErrorHandler;
    m_aSchemaNSContext = aSchemaNSContext;
  }

  @NonNull
  public final IPSErrorHandler getErrorHandler ()
  {
    return m_aErrorHandler;
  }

  private void _onWarn (@NonNull final IPSElement aSourceElement, @NonNull final String sMsg)
  {
    if (m_aSchema == null)
      throw new IllegalStateException ("No schema is present!");

    getErrorHandler ().handleError (SingleError.builderWarn ()
                                               .errorLocation (new SimpleLocation (m_aSchema.getResource ().getPath ()))
                                               .errorFieldName (IPSErrorHandler.getErrorFieldName (aSourceElement))
                                               .errorText (sMsg)
                                               .build ());
  }

  private void _onError (@NonNull final IPSElement aSourceElement,
                         @NonNull final String sMsg,
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
      if (aContent instanceof final String s)
        aSB.append (s);
      else
        if (aContent instanceof final PSDir aDir)
          aSB.append (aDir.getAsText ());
        else
          throw new SchematronValidationException ("Unsupported title content element: " + aContent);
    }
    return aSB.toString ();
  }

  @Override
  public void onStart (@NonNull final PSSchema aSchema,
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
    m_aNSContext = m_aSchemaNSContext != null ? m_aSchemaNSContext : aSchema.getAsNamespaceContext ();
    m_aElementPaths.clear ();

    for (final var aEntry : m_aNSContext.getPrefixToNamespaceURIMap ().entrySet ())
    {
      final NsPrefixInAttributeValues aNsPrefix = new NsPrefixInAttributeValues ();
      aNsPrefix.setPrefix (aEntry.getKey ());
      aNsPrefix.setUri (aEntry.getValue ());
      aSchematronOutput.addNsPrefixInAttributeValues (aNsPrefix);
    }
  }

  @Override
  public void onPattern (@NonNull final PSPattern aPattern) throws SchematronValidationException
  {
    final ActivePattern aRetPattern = new ActivePattern ();
    // TODO documents
    aRetPattern.setId (aPattern.getID ());
    if (aPattern.hasTitle ())
      aRetPattern.setName (_getTitleAsString (aPattern.getTitle ()));
    // TODO role
    m_aSchematronOutput.addActivePatternOrActiveGroupAndFiredRule (aRetPattern);
  }

  @Override
  public void onFiredRule (@NonNull final PSRule aRule,
                           @NonNull final String sContext,
                           @NonNull final int nNodeIndex,
                           @NonNull final int nNodeCount)
  {
    final FiredRule aRetRule = new FiredRule ();
    aRetRule.setContext (sContext);
    // Flag may not be empty
    if (StringHelper.isNotEmpty (aRule.getFlag ()))
      aRetRule.addFlag (aRule.getFlag ());
    aRetRule.setId (aRule.getID ());
    if (aRule.hasLinkable ())
      aRetRule.setRole (aRule.getLinkable ().getRole ());
    m_aSchematronOutput.addActivePatternOrActiveGroupAndFiredRule (aRetRule);
  }

  @Nullable
  private static String _evaluateAsString (@NonNull final PSXPathBoundElement aBoundElement,
                                           @NonNull final Node aSourceNode) throws SaxonApiException
  {
    final XPathEvaluationContext aCtx = XPathEvaluationContext.current ();
    if (aCtx == null)
      return null;

    final XdmNode aCtxXdm = aCtx.wrap (aSourceNode);
    return XPathEvaluationHelper.getAsString (aCtx.evaluate (aBoundElement.getBoundExpression (), aCtxXdm), " ");
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
  @NonNull
  private Text _getErrorText (@NonNull final List <PSXPathBoundElement> aBoundContentElements,
                              @NonNull final Node aSourceNode,
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
        if (aContent instanceof final String s)
          aSB.append (s);
        else
          if (aContent instanceof final PSName aName)
          {
            if (aName.hasPath ())
            {
              // XPath present
              try
              {
                final String sValue = _evaluateAsString (aBoundElement, aSourceNode);
                if (sValue != null)
                  aSB.append (sValue);
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
              aSB.append (aSourceNode.getNodeName ());
            }
          }
          else
            if (aContent instanceof final PSValueOf aValueOf)
            {
              try
              {
                final String sValue = _evaluateAsString (aBoundElement, aSourceNode);
                if (sValue != null)
                  aSB.append (sValue);
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
              if (aContent instanceof final PSEmph aEmph)
                aSB.append (aEmph.getAsText ());
              else
                if (aContent instanceof final PSDir aDir)
                  aSB.append (aDir.getAsText ());
                else
                  if (aContent instanceof final PSSpan aSpan)
                    aSB.append (aSpan.getAsText ());
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
                                            @NonNull final List <? super DiagnosticReference> aDstList,
                                            @NonNull final PSXPathBoundAssertReport aBoundAssertReport,
                                            @NonNull final Node aRuleMatchingNode) throws SchematronValidationException
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
            aDR.setText (_getErrorText (aDiagnostic.getAllBoundContentElements (), aRuleMatchingNode, null, null));
            aDstList.add (aDR);
          }
        }
      }
      else
        _onWarn (m_aSchema, "Failed to resolve diagnostic because schema has no diagnostics");
    }
  }

  /**
   * @param aNode
   *        An element or attribute node. May not be <code>null</code>.
   * @return The name of the node inside a location path, with the namespace prefix of the schema
   *         (if any). The same as {@link XMLHelper#pathToNodeBuilder()} creates.
   */
  @NonNull
  private String _getNameInPath (@NonNull final Node aNode)
  {
    final String sNamespaceURI = aNode.getNamespaceURI ();
    if (StringHelper.isEmpty (sNamespaceURI))
      return aNode.getNodeName ();

    final String sPrefix = m_aNSContext.getPrefix (sNamespaceURI);
    return StringHelper.isNotEmpty (sPrefix) ? sPrefix + ":" + aNode.getLocalName () : aNode.getLocalName ();
  }

  /**
   * @param aElement
   *        The element to check. May not be <code>null</code>.
   * @return The key of all elements that have the same name, as compared by
   *         {@link XMLHelper#hasSameElementName(Element, Element)}.
   */
  @NonNull
  private static String _getSiblingNameKey (@NonNull final Element aElement)
  {
    final String sNamespaceURI = aElement.getNamespaceURI ();
    if (StringHelper.isNotEmpty (sNamespaceURI))
      return "{" + sNamespaceURI + "}" + aElement.getLocalName ();
    // A tag name never starts with a curly brace
    return aElement.getTagName ();
  }

  /**
   * Remember the location path of all child elements of the provided parent element. The index of
   * an element is only part of its path if there are other child elements with the same name. Each
   * parent is handled only once per validation, so that many failures in a long list of sibling
   * elements do not count the siblings again and again.
   *
   * @param aParent
   *        The parent element. May not be <code>null</code>.
   * @param sParentPath
   *        The location path of the parent element. May not be <code>null</code>.
   */
  private void _addAllChildElementPaths (@NonNull final Element aParent, @NonNull final String sParentPath)
  {
    final ICommonsMap <String, SiblingNameCount> aCountPerName = new CommonsHashMap <> ();
    for (Node aChild = aParent.getFirstChild (); aChild != null; aChild = aChild.getNextSibling ())
      if (aChild.getNodeType () == Node.ELEMENT_NODE)
        aCountPerName.computeIfAbsent (_getSiblingNameKey ((Element) aChild), k -> new SiblingNameCount ()).m_nTotal++;

    for (Node aChild = aParent.getFirstChild (); aChild != null; aChild = aChild.getNextSibling ())
      if (aChild.getNodeType () == Node.ELEMENT_NODE)
      {
        final SiblingNameCount aCount = aCountPerName.get (_getSiblingNameKey ((Element) aChild));
        aCount.m_nHandled++;
        String sPath = sParentPath + "/" + _getNameInPath (aChild);
        if (aCount.m_nTotal > 1)
          sPath += "[" + aCount.m_nHandled + "]";
        m_aElementPaths.put (aChild, sPath);
      }
  }

  /**
   * Get the location path of an element, using the paths remembered before. The result is identical
   * to the one {@link #_getPathToNodeUncached(Node)} creates.
   *
   * @param aElement
   *        The element to get the path for. May not be <code>null</code>.
   * @return <code>null</code> if the element or one of its ancestors is not part of a document.
   */
  @Nullable
  private String _getElementPathRecursive (@NonNull final Element aElement)
  {
    String ret = m_aElementPaths.get (aElement);
    if (ret == null)
    {
      final Node aParent = aElement.getParentNode ();
      if (aParent == null)
        return null;

      final short nParentType = aParent.getNodeType ();
      if (nParentType == Node.DOCUMENT_NODE)
      {
        // The root element never has an index
        ret = "/" + _getNameInPath (aElement);
        m_aElementPaths.put (aElement, ret);
      }
      else
        if (nParentType == Node.ELEMENT_NODE)
        {
          final String sParentPath = _getElementPathRecursive ((Element) aParent);
          if (sParentPath == null)
            return null;
          _addAllChildElementPaths ((Element) aParent, sParentPath);
          ret = m_aElementPaths.get (aElement);
        }
    }
    return ret;
  }

  @NonNull
  private String _getPathToNodeUncached (@NonNull final Node aNode)
  {
    return XMLHelper.pathToNodeBuilder ()
                    .node (aNode)
                    .separator ("/")
                    .excludeDocumentNode ()
                    .oneBasedIndex ()
                    .forceUseIndex (false)
                    .trailingSeparator (false)
                    .compareIncludingNamespaceURI (true)
                    .namespaceContext (m_aNSContext)
                    .build ();
  }

  @NonNull
  private String _getPathToNode (@NonNull final Node aNode)
  {
    String ret = null;
    final short nNodeType = aNode.getNodeType ();
    if (nNodeType == Node.ELEMENT_NODE)
      ret = _getElementPathRecursive ((Element) aNode);
    else
      if (nNodeType == Node.ATTRIBUTE_NODE)
      {
        final Element aOwner = ((Attr) aNode).getOwnerElement ();
        if (aOwner != null)
        {
          final String sOwnerPath = _getElementPathRecursive (aOwner);
          if (sOwnerPath != null)
            ret = sOwnerPath + "/@" + _getNameInPath (aNode);
        }
      }
    if (ret == null)
    {
      // Any other node, or a node that is not part of a document
      ret = _getPathToNodeUncached (aNode);
    }

    if (LOGGER.isTraceEnabled ())
      LOGGER.trace ("Converted Node to path '" + ret + "'");
    return ret;
  }

  @NonNull
  private String _getLocation (@NonNull final PSRule aOwningRule,
                               @NonNull final PSAssertReport aAssertReport,
                               @NonNull final Node aRuleMatchingNode)
  {
    String sLocation = null;
    if (aAssertReport.hasLinkable ())
      sLocation = aAssertReport.getLinkable ().getSubject ();
    if (StringHelper.isEmpty (sLocation))
    {
      if (aOwningRule.hasLinkable ())
        sLocation = aOwningRule.getLinkable ().getSubject ();
      if (StringHelper.isEmpty (sLocation))
        sLocation = _getPathToNode (aRuleMatchingNode);
    }
    return sLocation;
  }

  @Override
  @NonNull
  public EContinue onFailedAssert (@NonNull final PSRule aOwningRule,
                                   @NonNull final PSAssertReport aAssertReport,
                                   @NonNull final String sTestExpression,
                                   @NonNull final Node aRuleMatchingNode,
                                   final int nNodeIndex,
                                   @Nullable final Object aContext,
                                   @Nullable final Exception aEvaluationException) throws SchematronValidationException
  {
    if (!(aContext instanceof final PSXPathBoundAssertReport aBoundAssertReport))
      throw new SchematronValidationException ("The passed context must be a PSXPathBoundAssertReport object but is a " +
                                               aContext);

    final FailedAssert aFailedAssert = new FailedAssert ();
    // Flag may not be empty
    if (StringHelper.isNotEmpty (aAssertReport.getFlag ()))
      aFailedAssert.addFlag (aAssertReport.getFlag ());
    aFailedAssert.setId (aAssertReport.getID ());
    aFailedAssert.setLocation (_getLocation (aOwningRule, aAssertReport, aRuleMatchingNode));
    if (aAssertReport.hasLinkable ())
      aFailedAssert.setRole (aAssertReport.getLinkable ().getRole ());
    aFailedAssert.setTest (sTestExpression);
    aFailedAssert.setText (_getErrorText (aBoundAssertReport.getAllBoundContentElements (),
                                          aRuleMatchingNode,
                                          aEvaluationException,
                                          sTestExpression));
    _handleDiagnosticReferences (aAssertReport.getAllDiagnostics (),
                                 aFailedAssert.getDiagnosticReference (),
                                 aBoundAssertReport,
                                 aRuleMatchingNode);
    m_aSchematronOutput.addActivePatternOrActiveGroupAndFiredRule (aFailedAssert);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onSuccessfulReport (@NonNull final PSRule aOwningRule,
                                       @NonNull final PSAssertReport aAssertReport,
                                       @NonNull final String sTestExpression,
                                       @NonNull final Node aRuleMatchingNode,
                                       final int nNodeIndex,
                                       @Nullable final Object aContext,
                                       @Nullable final Exception aEvaluationException) throws SchematronValidationException
  {
    if (!(aContext instanceof final PSXPathBoundAssertReport aBoundAssertReport))
      throw new SchematronValidationException ("The passed context must be a PSXPathBoundAssertReport object but is a " +
                                               aContext);

    final SuccessfulReport aSuccessfulReport = new SuccessfulReport ();
    // Flag may not be empty
    if (StringHelper.isNotEmpty (aAssertReport.getFlag ()))
      aSuccessfulReport.addFlag (aAssertReport.getFlag ());
    aSuccessfulReport.setId (aAssertReport.getID ());
    aSuccessfulReport.setLocation (_getLocation (aOwningRule, aAssertReport, aRuleMatchingNode));
    if (aAssertReport.hasLinkable ())
      aSuccessfulReport.setRole (aAssertReport.getLinkable ().getRole ());
    aSuccessfulReport.setTest (sTestExpression);
    aSuccessfulReport.setText (_getErrorText (aBoundAssertReport.getAllBoundContentElements (),
                                              aRuleMatchingNode,
                                              aEvaluationException,
                                              sTestExpression));
    _handleDiagnosticReferences (aAssertReport.getAllDiagnostics (),
                                 aSuccessfulReport.getDiagnosticReference (),
                                 aBoundAssertReport,
                                 aRuleMatchingNode);
    m_aSchematronOutput.addActivePatternOrActiveGroupAndFiredRule (aSuccessfulReport);
    return EContinue.CONTINUE;
  }

  @Nullable
  public SchematronOutputType getSVRL ()
  {
    return m_aSchematronOutput;
  }
}
