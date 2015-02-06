/**
 * Copyright (C) 2014-2015 Philip Helger (www.helger.com)
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

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotations.PresentForCodeCoverage;
import com.helger.commons.error.IResourceErrorGroup;
import com.helger.commons.error.ResourceErrorGroup;
import com.helger.commons.hierarchy.DefaultHierarchyWalkerCallback;
import com.helger.commons.io.IReadableResource;
import com.helger.commons.microdom.IMicroDocument;
import com.helger.commons.microdom.IMicroElement;
import com.helger.commons.microdom.IMicroNode;
import com.helger.commons.microdom.serialize.MicroReader;
import com.helger.commons.microdom.utils.MicroWalker;
import com.helger.commons.mutable.Wrapper;
import com.helger.commons.xml.serialize.ISAXReaderSettings;
import com.helger.schematron.resolve.DefaultSchematronIncludeResolver;
import com.helger.schematron.svrl.SVRLFailedAssert;
import com.helger.schematron.svrl.SVRLResourceError;
import com.helger.schematron.svrl.SVRLUtils;

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
                                          aXML.getResourceID (), ex);
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
                                          aXML, ex);
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
   * Convert a {@link SchematronOutputType} to an {@link IResourceErrorGroup}.
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
  public static IResourceErrorGroup convertToResourceErrorGroup (@Nonnull final SchematronOutputType aSchematronOutput,
                                                                 @Nullable final String sResourceName)
  {
    ValueEnforcer.notNull (aSchematronOutput, "SchematronOutput");

    final ResourceErrorGroup ret = new ResourceErrorGroup ();
    for (final SVRLFailedAssert aFailedAssert : SVRLUtils.getAllFailedAssertions (aSchematronOutput))
      ret.addResourceError (aFailedAssert.getAsResourceError (sResourceName));
    return ret;
  }

  @SuppressFBWarnings ("RCN_REDUNDANT_NULLCHECK_OF_NONNULL_VALUE")
  private static void _recursiveResolveAllSchematronIncludes (@Nonnull final IMicroElement eRoot,
                                                              @Nonnull final IReadableResource aResource,
                                                              @Nullable final ISAXReaderSettings aSettings)
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
              throw new IllegalStateException ("Failed to resolve include '" + sHref + "'");

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
              throw new IllegalStateException ("Failed to parse include " + aIncludeRes);

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
              final Wrapper <IMicroElement> aMatch = new Wrapper <IMicroElement> ();
              MicroWalker.walkNode (aIncludedDoc.getDocumentElement (),
                                    new DefaultHierarchyWalkerCallback <IMicroNode> ()
                                    {
                                      @Override
                                      public void onItemBeforeChildren (final IMicroNode aItem)
                                      {
                                        if (aItem.isElement ())
                                        {
                                          final IMicroElement aCurElement = (IMicroElement) aItem;
                                          final String sID = aCurElement.getAttributeValue ("id");
                                          if (sFinalAnchor.equals (sID))
                                            aMatch.set (aCurElement);
                                        }
                                      }
                                    });
              aIncludedContent = aMatch.get ();
              if (aIncludedContent == null)
              {
                s_aLogger.error ("Failed to resolve an element with the ID '" +
                                 sAnchor +
                                 "' in " +
                                 aIncludeRes +
                                 "! Therefore including the whole document!");
                aIncludedContent = aIncludedDoc.getDocumentElement ();
              }
            }

            // Important to detach from parent!
            aIncludedContent.detachFromParent ();

            // Recursive resolve includes
            _recursiveResolveAllSchematronIncludes (aIncludedContent, aIncludeRes, aSettings);

            // Now replace "include" element with content in MicroDOM
            aElement.getParent ().replaceChild (aElement, aIncludedContent);
          }
          catch (final IOException ex)
          {
            throw new IllegalStateException ("Failed to read include '" + sHref + "'", ex);
          }
        }
    }
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
    return getWithResolvedSchematronIncludes (aResource, (ISAXReaderSettings) null);
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
  public static IMicroDocument getWithResolvedSchematronIncludes (@Nonnull final IReadableResource aResource,
                                                                  @Nullable final ISAXReaderSettings aSettings)
  {
    final IMicroDocument aDoc = MicroReader.readMicroXML (aResource, aSettings);
    if (aDoc != null)
    {
      // Resolve all Schematron includes
      _recursiveResolveAllSchematronIncludes (aDoc.getDocumentElement (), aResource, aSettings);
    }
    return aDoc;
  }
}
