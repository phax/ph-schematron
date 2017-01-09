/**
 * Copyright (C) 2014-2017 Philip Helger (www.helger.com)
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
package com.helger.schematron;

import java.io.IOException;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.Immutable;
import javax.xml.transform.Source;
import javax.xml.transform.dom.DOMSource;

import org.oclc.purl.dsdl.svrl.SchematronOutputType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Node;
import org.xml.sax.InputSource;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.PresentForCodeCoverage;
import com.helger.commons.error.list.ErrorList;
import com.helger.commons.error.list.IErrorList;
import com.helger.commons.hierarchy.visit.ChildrenProviderHierarchyVisitor;
import com.helger.commons.hierarchy.visit.DefaultHierarchyVisitorCallback;
import com.helger.commons.hierarchy.visit.EHierarchyVisitorReturn;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.state.ESuccess;
import com.helger.commons.wrapper.Wrapper;
import com.helger.schematron.pure.errorhandler.IPSErrorHandler;
import com.helger.schematron.pure.errorhandler.LoggingPSErrorHandler;
import com.helger.schematron.resolve.DefaultSchematronIncludeResolver;
import com.helger.schematron.svrl.SVRLFailedAssert;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.SVRLResourceError;
import com.helger.xml.microdom.IMicroDocument;
import com.helger.xml.microdom.IMicroElement;
import com.helger.xml.microdom.IMicroNode;
import com.helger.xml.microdom.serialize.MicroReader;
import com.helger.xml.sax.InputSourceFactory;
import com.helger.xml.serialize.read.ISAXReaderSettings;

import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;

/**
 * This is a helper class that provides a way to easily apply an Schematron
 * resource on an XML resource.
 *
 * @author Philip Helger
 */
@Immutable
public final class SchematronHelper
{
  private static final Logger s_aLogger = LoggerFactory.getLogger (SchematronHelper.class);

  @PresentForCodeCoverage
  private static final SchematronHelper s_aInstance = new SchematronHelper ();

  private SchematronHelper ()
  {}

  /**
   * Apply the passed schematron on the passed XML resource using a custom error
   * handler.
   *
   * @param aSchematron
   *        The Schematron resource. May not be <code>null</code>.
   * @param aXML
   *        The XML resource. May not be <code>null</code>.
   * @return <code>null</code> if either the Schematron or the XML could not be
   *         read.
   * @throws IllegalStateException
   *         if the processing throws an unexpected exception.
   */
  @Nullable
  public static SchematronOutputType applySchematron (@Nonnull final ISchematronResource aSchematron,
                                                      @Nonnull final IReadableResource aXML)
  {
    ValueEnforcer.notNull (aSchematron, "SchematronResource");
    ValueEnforcer.notNull (aXML, "XMLSource");

    try
    {
      // Apply Schematron on XML
      return aSchematron.applySchematronValidationToSVRL (aXML);
    }
    catch (final Exception ex)
    {
      throw new IllegalArgumentException ("Failed to apply Schematron " +
                                          aSchematron.getID () +
                                          " onto XML resource " +
                                          aXML.getResourceID (),
                                          ex);
    }
  }

  /**
   * Apply the passed schematron on the passed XML resource.
   *
   * @param aSchematron
   *        The Schematron resource. May not be <code>null</code>.
   * @param aXML
   *        The XML resource. May not be <code>null</code>.
   * @return <code>null</code> if either the Schematron or the XML could not be
   *         read.
   * @throws IllegalStateException
   *         if the processing throws an unexpected exception.
   */
  @Nullable
  public static SchematronOutputType applySchematron (@Nonnull final ISchematronResource aSchematron,
                                                      @Nonnull final Source aXML)
  {
    ValueEnforcer.notNull (aSchematron, "SchematronResource");
    ValueEnforcer.notNull (aXML, "XMLSource");

    try
    {
      // Apply Schematron on XML.
      return aSchematron.applySchematronValidationToSVRL (aXML);
    }
    catch (final Exception ex)
    {
      throw new IllegalArgumentException ("Failed to apply Schematron " +
                                          aSchematron.getID () +
                                          " onto XML source " +
                                          aXML,
                                          ex);
    }
  }

  /**
   * Apply the passed schematron on the passed XML node.
   *
   * @param aSchematron
   *        The Schematron resource. May not be <code>null</code>.
   * @param aNode
   *        The XML node. May not be <code>null</code>.
   * @return <code>null</code> if either the Schematron or the XML could not be
   *         read.
   * @throws IllegalStateException
   *         if the processing throws an unexpected exception.
   */
  @Nullable
  public static SchematronOutputType applySchematron (@Nonnull final ISchematronResource aSchematron,
                                                      @Nonnull final Node aNode)
  {
    ValueEnforcer.notNull (aSchematron, "SchematronResource");
    ValueEnforcer.notNull (aNode, "Node");

    return applySchematron (aSchematron, new DOMSource (aNode));
  }

  /**
   * Convert a {@link SchematronOutputType} to an {@link IErrorList}.
   *
   * @param aSchematronOutput
   *        The result of Schematron validation
   * @param sResourceName
   *        The name of the resource that was validated (may be a file path
   *        etc.)
   * @return List non-<code>null</code> error list of {@link SVRLResourceError}
   *         objects.
   */
  @Nonnull
  public static IErrorList convertToErrorList (@Nonnull final SchematronOutputType aSchematronOutput,
                                               @Nullable final String sResourceName)
  {
    ValueEnforcer.notNull (aSchematronOutput, "SchematronOutput");

    final ErrorList ret = new ErrorList ();
    for (final SVRLFailedAssert aFailedAssert : SVRLHelper.getAllFailedAssertions (aSchematronOutput))
      ret.add (aFailedAssert.getAsResourceError (sResourceName));
    return ret;
  }

  @SuppressFBWarnings ("RCN_REDUNDANT_NULLCHECK_OF_NONNULL_VALUE")
  @Nonnull
  private static ESuccess _recursiveResolveAllSchematronIncludes (@Nonnull final IMicroElement eRoot,
                                                                  @Nonnull final IReadableResource aResource,
                                                                  @Nullable final ISAXReaderSettings aSettings,
                                                                  @Nonnull final IPSErrorHandler aErrorHandler)
  {
    if (eRoot != null)
    {
      final DefaultSchematronIncludeResolver aIncludeResolver = new DefaultSchematronIncludeResolver (aResource);

      for (final IMicroElement aElement : eRoot.getAllChildElementsRecursive ())
        if (CSchematron.NAMESPACE_SCHEMATRON.equals (aElement.getNamespaceURI ()) &&
            aElement.getLocalName ().equals (CSchematronXML.ELEMENT_INCLUDE))
        {
          String sHref = aElement.getAttributeValue (CSchematronXML.ATTR_HREF);
          try
          {
            final int nHashIndex = sHref.indexOf ('#');
            String sAnchor = null;
            if (nHashIndex >= 0)
            {
              sAnchor = sHref.substring (nHashIndex + 1);
              sHref = sHref.substring (0, nHashIndex);
            }

            final IReadableResource aIncludeRes = aIncludeResolver.getResolvedSchematronResource (sHref);
            if (aIncludeRes == null)
            {
              aErrorHandler.error (aResource, null, "Failed to resolve include '" + sHref + "'", null);
              return ESuccess.FAILURE;
            }

            if (s_aLogger.isDebugEnabled ())
              s_aLogger.debug ("Resolved '" +
                               sHref +
                               "' relative to '" +
                               aIncludeResolver.getBaseHref () +
                               "' as '" +
                               aIncludeRes.getPath () +
                               "'");

            // Read XML to be included
            final IMicroDocument aIncludedDoc = MicroReader.readMicroXML (aIncludeRes, aSettings);
            if (aIncludedDoc == null)
            {
              aErrorHandler.error (aResource, null, "Failed to parse include " + aIncludeRes, null);
              return ESuccess.FAILURE;
            }

            IMicroElement aIncludedContent;
            if (sAnchor == null)
            {
              // no anchor present - include the whole document

              // Return the document element
              aIncludedContent = aIncludedDoc.getDocumentElement ();
            }
            else
            {
              final String sFinalAnchor = sAnchor;
              final Wrapper <IMicroElement> aMatch = new Wrapper<> ();
              // Also include the root element in the search
              ChildrenProviderHierarchyVisitor.visitFrom (aIncludedDoc.getDocumentElement (),
                                                          new DefaultHierarchyVisitorCallback <IMicroNode> ()
                                                          {
                                                            @Override
                                                            public EHierarchyVisitorReturn onItemBeforeChildren (final IMicroNode aItem)
                                                            {
                                                              if (aItem.isElement ())
                                                              {
                                                                final IMicroElement aCurElement = (IMicroElement) aItem;
                                                                final String sID = aCurElement.getAttributeValue ("id");
                                                                if (sFinalAnchor.equals (sID))
                                                                  aMatch.set (aCurElement);
                                                              }
                                                              return EHierarchyVisitorReturn.CONTINUE;
                                                            }
                                                          },
                                                          true);
              aIncludedContent = aMatch.get ();
              if (aIncludedContent == null)
              {
                aErrorHandler.warn (aResource,
                                    null,
                                    "Failed to resolve an element with the ID '" +
                                          sAnchor +
                                          "' in " +
                                          aIncludeRes +
                                          "! Therefore including the whole document!");
                aIncludedContent = aIncludedDoc.getDocumentElement ();
              }
            }

            // Important to detach from parent!
            aIncludedContent.detachFromParent ();

            // Check for correct namespace URI of included content
            if (!CSchematron.NAMESPACE_SCHEMATRON.equals (aIncludedContent.getNamespaceURI ()))
            {
              aErrorHandler.error (aResource,
                                   null,
                                   "The included resource " +
                                         aIncludeRes +
                                         " contains the wrong XML namespace URI '" +
                                         aIncludedContent.getNamespaceURI () +
                                         "' but was expected to have '" +
                                         CSchematron.NAMESPACE_SCHEMATRON +
                                         "'",
                                   null);
              return ESuccess.FAILURE;
            }

            // Check that not a whole Schema but only a part is included
            if (CSchematronXML.ELEMENT_SCHEMA.equals (aIncludedContent.getLocalName ()))
            {
              aErrorHandler.warn (aResource,
                                  null,
                                  "The included resource " +
                                        aIncludeRes +
                                        " seems to be a complete schema. To includes parts of a schema the respective element must be the root element of the included resource.");
            }

            // Recursive resolve includes
            if (_recursiveResolveAllSchematronIncludes (aIncludedContent,
                                                        aIncludeRes,
                                                        aSettings,
                                                        aErrorHandler).isFailure ())
              return ESuccess.FAILURE;

            // Now replace "include" element with content in MicroDOM
            aElement.getParent ().replaceChild (aElement, aIncludedContent);
          }
          catch (final IOException ex)
          {
            aErrorHandler.error (aResource, null, "Failed to read include '" + sHref + "'", ex);
            return ESuccess.FAILURE;
          }
        }
    }
    return ESuccess.SUCCESS;
  }

  /**
   * Resolve all Schematron includes of the passed resource.
   *
   * @param aResource
   *        The Schematron resource to read. May not be <code>null</code>.
   * @return <code>null</code> if the passed resource could not be read as XML
   *         document
   */
  @Nullable
  public static IMicroDocument getWithResolvedSchematronIncludes (@Nonnull final IReadableResource aResource)
  {
    return getWithResolvedSchematronIncludes (aResource, (ISAXReaderSettings) null, new LoggingPSErrorHandler ());
  }

  /**
   * Resolve all Schematron includes of the passed resource.
   *
   * @param aResource
   *        The Schematron resource to read. May not be <code>null</code>.
   * @param aSettings
   *        The SAX reader settings to be used. May be <code>null</code> to use
   *        the default settings.
   * @return <code>null</code> if the passed resource could not be read as XML
   *         document
   */
  @Nullable
  @Deprecated
  public static IMicroDocument getWithResolvedSchematronIncludes (@Nonnull final IReadableResource aResource,
                                                                  @Nullable final ISAXReaderSettings aSettings)
  {
    return getWithResolvedSchematronIncludes (aResource, aSettings, new LoggingPSErrorHandler ());
  }

  /**
   * Resolve all Schematron includes of the passed resource.
   *
   * @param aResource
   *        The Schematron resource to read. May not be <code>null</code>.
   * @param aSettings
   *        The SAX reader settings to be used. May be <code>null</code> to use
   *        the default settings.
   * @param aErrorHandler
   *        The error handler to be used. May not be <code>null</code>.
   * @return <code>null</code> if the passed resource could not be read as XML
   *         document
   */
  @Nullable
  public static IMicroDocument getWithResolvedSchematronIncludes (@Nonnull final IReadableResource aResource,
                                                                  @Nullable final ISAXReaderSettings aSettings,
                                                                  @Nonnull final IPSErrorHandler aErrorHandler)
  {
    final InputSource aIS = InputSourceFactory.create (aResource);
    final IMicroDocument aDoc = MicroReader.readMicroXML (aIS, aSettings);
    if (aDoc != null)
    {
      // Resolve all Schematron includes
      if (_recursiveResolveAllSchematronIncludes (aDoc.getDocumentElement (),
                                                  aResource,
                                                  aSettings,
                                                  aErrorHandler).isFailure ())
      {
        // Error resolving includes
        return null;
      }
    }
    return aDoc;
  }
}
