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
package com.helger.schematron;

import java.io.IOException;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.xml.sax.InputSource;

import com.helger.annotation.Nonempty;
import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.PresentForCodeCoverage;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.location.SimpleLocation;
import com.helger.base.state.ESuccess;
import com.helger.base.string.StringImplode;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.CommonsHashMap;
import com.helger.collection.commons.CommonsLinkedHashSet;
import com.helger.collection.commons.ICommonsList;
import com.helger.collection.commons.ICommonsMap;
import com.helger.collection.commons.ICommonsOrderedSet;
import com.helger.collection.hierarchy.visit.ChildrenProviderHierarchyVisitor;
import com.helger.collection.hierarchy.visit.DefaultHierarchyVisitorCallback;
import com.helger.collection.hierarchy.visit.EHierarchyVisitorReturn;
import com.helger.diagnostics.error.SingleError;
import com.helger.diagnostics.error.list.ErrorList;
import com.helger.diagnostics.error.list.IErrorList;
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.resolve.DefaultSchematronIncludeResolver;
import com.helger.schematron.resolve.ISchematronIncludeResolver;
import com.helger.schematron.svrl.SVRLFailedAssert;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.SVRLResourceError;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.xml.microdom.IMicroDocument;
import com.helger.xml.microdom.IMicroElement;
import com.helger.xml.microdom.IMicroNode;
import com.helger.xml.microdom.serialize.MicroReader;
import com.helger.xml.sax.InputSourceFactory;
import com.helger.xml.serialize.read.ISAXReaderSettings;

/**
 * This is a helper class that provides a way to easily apply an Schematron resource on an XML
 * resource.
 *
 * @author Philip Helger
 */
@Immutable
public final class SchematronHelper
{
  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronHelper.class);

  @PresentForCodeCoverage
  private static final SchematronHelper INSTANCE = new SchematronHelper ();

  private SchematronHelper ()
  {}

  /**
   * Check if the passed namespace URI is deprecated.
   *
   * @param sNamespaceURI
   *        The namespace URI to check. May be <code>null</code>.
   * @return <code>true</code> if the passed namespace URI is a deprecated Schematron namespace URI,
   *         <code>false</code> if not.
   * @since 5.4.1
   */
  public static boolean isDeprecatedSchematronNS (@Nullable final String sNamespaceURI)
  {
    if (CSchematron.DEPRECATED_NAMESPACE_SCHEMATRON.equals (sNamespaceURI))
      return true;
    // null or whatever
    return false;
  }

  /**
   * Check if the passed namespace URI is supported.
   *
   * @param sNamespaceURI
   *        The namespace URI to check. May be <code>null</code>.
   * @param bLenient
   *        <code>true</code> to support old namespace URIs, <code>false</code> if not.
   * @return <code>true</code> if the passed namespace URI is a valid Schematron namespace URI,
   *         <code>false</code> if not.
   * @since 5.4.1
   */
  public static boolean isValidSchematronNS (@Nullable final String sNamespaceURI, final boolean bLenient)
  {
    if (CSchematron.NAMESPACE_SCHEMATRON.equals (sNamespaceURI))
      return true;
    if (bLenient && isDeprecatedSchematronNS (sNamespaceURI))
      return true;
    // null or whatever
    return false;
  }

  /**
   * Get a list of all supported namespaces.
   *
   * @param bLenient
   *        <code>true</code> to support old namespace URIs, <code>false</code> if not.
   * @return The non-<code>null</code> and non-empty list of all supported schematron namespace
   *         URIs.
   * @since 5.4.1
   */
  @NonNull
  @Nonempty
  @ReturnsMutableCopy
  public static ICommonsList <String> getAllValidSchematronNS (final boolean bLenient)
  {
    final ICommonsList <String> ret = new CommonsArrayList <> (2);
    ret.add (CSchematron.NAMESPACE_SCHEMATRON);
    if (bLenient)
      ret.add (CSchematron.DEPRECATED_NAMESPACE_SCHEMATRON);
    return ret;
  }

  /**
   * Convert a {@link SchematronOutputType} to an {@link IErrorList}.
   *
   * @param aSchematronOutput
   *        The result of Schematron validation
   * @param sResourceName
   *        The name of the resource that was validated (may be a file path etc.)
   * @return List non-<code>null</code> error list of {@link SVRLResourceError} objects.
   */
  @NonNull
  public static IErrorList convertToErrorList (@NonNull final SchematronOutputType aSchematronOutput,
                                               @Nullable final String sResourceName)
  {
    ValueEnforcer.notNull (aSchematronOutput, "SchematronOutput");

    final ErrorList ret = new ErrorList ();
    for (final SVRLFailedAssert aFailedAssert : SVRLHelper.getAllFailedAssertions (aSchematronOutput))
      ret.add (aFailedAssert.getAsResourceError (sResourceName));
    return ret;
  }

  /**
   * An included document as read. It is never modified; the included content is always a clone, so that the document
   * can be used for every include of the same resource. The elements by ID are only collected on first use.
   */
  private static final class IncludedDocument
  {
    private final IMicroDocument m_aDoc;
    private ICommonsMap <String, IMicroElement> m_aElementsByID;

    IncludedDocument (@NonNull final IMicroDocument aDoc)
    {
      m_aDoc = aDoc;
    }

    @NonNull
    IMicroElement getDocumentElement ()
    {
      return m_aDoc.getDocumentElement ();
    }

    /**
     * @return The first element in document order (including the document element) with the passed value of the
     *         <code>id</code> attribute, or <code>null</code> if there is none.
     */
    @Nullable
    IMicroElement getElementOfID (@NonNull final String sID)
    {
      if (m_aElementsByID == null)
      {
        final ICommonsMap <String, IMicroElement> aElementsByID = new CommonsHashMap <> ();
        ChildrenProviderHierarchyVisitor.visitFrom (m_aDoc.getDocumentElement (),
                                                    new DefaultHierarchyVisitorCallback <IMicroNode> ()
                                                    {
                                                      @Override
                                                      public EHierarchyVisitorReturn onItemBeforeChildren (@NonNull final IMicroNode aItem)
                                                      {
                                                        if (aItem instanceof final IMicroElement aCurElement)
                                                        {
                                                          final String sCurID = aCurElement.getAttributeValue ("id");
                                                          if (sCurID != null)
                                                            aElementsByID.putIfAbsent (sCurID, aCurElement);
                                                        }
                                                        return EHierarchyVisitorReturn.CONTINUE;
                                                      }
                                                    },
                                                    true);
        m_aElementsByID = aElementsByID;
      }
      return m_aElementsByID.get (sID);
    }
  }

  /**
   * An include on the current include path: the resource and the optional anchor.
   */
  private record IncludeTarget (@NonNull IReadableResource resource, @Nullable String anchor)
  {
    @NonNull
    String getDisplayName ()
    {
      return resource.getPath () + (anchor == null ? "" : "#" + anchor);
    }
  }

  @NonNull
  private static ESuccess _recursiveResolveAllSchematronIncludes (@Nullable final IMicroElement eRoot,
                                                                  @NonNull final IReadableResource aResource,
                                                                  @Nullable final ISAXReaderSettings aSettings,
                                                                  @NonNull final ISchematronErrorHandler aErrorHandler,
                                                                  @Nullable final ISchematronIncludeResolver aCustomIncludeResolver,
                                                                  final boolean bLenient,
                                                                  @NonNull final ICommonsMap <IReadableResource, IncludedDocument> aIncludedDocs,
                                                                  @NonNull final ICommonsOrderedSet <IncludeTarget> aIncludePath)
  {
    if (eRoot != null)
    {
      final DefaultSchematronIncludeResolver aIncludeResolver = new DefaultSchematronIncludeResolver (aResource);
      if (aCustomIncludeResolver != null)
        aIncludeResolver.setCustomSchematronIncludeResolver (aCustomIncludeResolver);

      for (final IMicroElement aElement : eRoot.getAllChildElementsRecursive ())
        if (isValidSchematronNS (aElement.getNamespaceURI (), bLenient) &&
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
              aErrorHandler.handleError (SingleError.builderError ()
                                                    .errorLocation (new SimpleLocation (aResource.getPath ()))
                                                    .errorText ("Failed to resolve include '" + sHref + "'")
                                                    .build ());
              return ESuccess.FAILURE;
            }

            if (LOGGER.isDebugEnabled ())
              LOGGER.debug ("Resolved '" +
                            sHref +
                            "' relative to '" +
                            aIncludeResolver.getBaseHref () +
                            "' as '" +
                            aIncludeRes.getPath () +
                            "'");

            final IncludeTarget aIncludeTarget = new IncludeTarget (aIncludeRes, sAnchor);
            if (aIncludePath.contains (aIncludeTarget))
            {
              aErrorHandler.handleError (SingleError.builderError ()
                                                    .errorLocation (new SimpleLocation (aResource.getPath ()))
                                                    .errorText ("Cyclic include of '" +
                                                                aIncludeTarget.getDisplayName () +
                                                                "' via " +
                                                                StringImplode.imploder ()
                                                                             .source (aIncludePath,
                                                                                      x -> "'" + x.getDisplayName () + "'")
                                                                             .separator (" -> ")
                                                                             .build ())
                                                    .build ());
              return ESuccess.FAILURE;
            }

            // Read XML to be included, each resource only once
            IncludedDocument aIncludedDoc = aIncludedDocs.get (aIncludeRes);
            if (aIncludedDoc == null)
            {
              final IMicroDocument aReadDoc = MicroReader.readMicroXML (aIncludeRes, aSettings);
              if (aReadDoc == null)
              {
                aErrorHandler.handleError (SingleError.builderError ()
                                                      .errorLocation (new SimpleLocation (aResource.getPath ()))
                                                      .errorText ("Failed to parse include " + aIncludeRes)
                                                      .build ());
                return ESuccess.FAILURE;
              }
              aIncludedDoc = new IncludedDocument (aReadDoc);
              aIncludedDocs.put (aIncludeRes, aIncludedDoc);
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
              aIncludedContent = aIncludedDoc.getElementOfID (sAnchor);
              if (aIncludedContent == null)
              {
                aErrorHandler.handleError (SingleError.builderWarn ()
                                                      .errorLocation (new SimpleLocation (aResource.getPath ()))
                                                      .errorText ("Failed to resolve an element with the ID '" +
                                                                  sAnchor +
                                                                  "' in " +
                                                                  aIncludeRes +
                                                                  "! Therefore including the whole document!")
                                                      .build ());
                aIncludedContent = aIncludedDoc.getDocumentElement ();
              }
            }

            // Clone, because the read document is used for all includes of the resource
            aIncludedContent = aIncludedContent.getClone ();

            // It is okay to include sthg else
            if (false)
            {
              // Check for correct namespace URI of included content
              if (!isValidSchematronNS (aIncludedContent.getNamespaceURI (), bLenient))
              {
                aErrorHandler.handleError (SingleError.builderError ()
                                                      .errorLocation (new SimpleLocation (aResource.getPath ()))
                                                      .errorText ("The included resource " +
                                                                  aIncludeRes +
                                                                  " contains the wrong XML namespace URI '" +
                                                                  aIncludedContent.getNamespaceURI () +
                                                                  "' but was expected to have: " +
                                                                  StringImplode.imploder ()
                                                                               .source (getAllValidSchematronNS (bLenient),
                                                                                        x -> "'" + x + "'")
                                                                               .separator (", ")
                                                                               .build ())
                                                      .build ());
                return ESuccess.FAILURE;
              }
            }

            // Check that not a whole Schema but only a part is included
            if (isValidSchematronNS (aIncludedContent.getNamespaceURI (), bLenient) &&
                CSchematronXML.ELEMENT_SCHEMA.equals (aIncludedContent.getLocalName ()))
            {
              aErrorHandler.handleError (SingleError.builderWarn ()
                                                    .errorLocation (new SimpleLocation (aResource.getPath ()))
                                                    .errorText ("The included resource " +
                                                                aIncludeRes +
                                                                " seems to be a complete schema. To includes parts of a schema the respective element must be the root element of the included resource.")
                                                    .build ());
            }

            // Recursive resolve includes
            aIncludePath.add (aIncludeTarget);
            final ESuccess eSuccess = _recursiveResolveAllSchematronIncludes (aIncludedContent,
                                                                              aIncludeRes,
                                                                              aSettings,
                                                                              aErrorHandler,
                                                                              aCustomIncludeResolver,
                                                                              bLenient,
                                                                              aIncludedDocs,
                                                                              aIncludePath);
            aIncludePath.remove (aIncludeTarget);
            if (eSuccess.isFailure ())
              return ESuccess.FAILURE;

            // Now replace "include" element with content in MicroDOM
            aElement.getParent ().replaceChild (aElement, aIncludedContent);
          }
          catch (final IOException ex)
          {
            aErrorHandler.handleError (SingleError.builderError ()
                                                  .errorLocation (new SimpleLocation (aResource.getPath ()))
                                                  .errorText ("Failed to read include '" + sHref + "'")
                                                  .linkedException (ex)
                                                  .build ());
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
   * @param aErrorHandler
   *        The error handler to be used. May not be <code>null</code>.
   * @return <code>null</code> if the passed resource could not be read as XML document
   */
  @Nullable
  public static IMicroDocument getWithResolvedSchematronIncludes (@NonNull final IReadableResource aResource,
                                                                  @NonNull final ISchematronErrorHandler aErrorHandler)
  {
    return getWithResolvedSchematronIncludes (aResource,
                                              null,
                                              aErrorHandler,
                                              (ISchematronIncludeResolver) null,
                                              CSchematron.DEFAULT_ALLOW_DEPRECATED_NAMESPACES);
  }

  /**
   * Resolve all Schematron includes of the passed resource.
   *
   * @param aResource
   *        The Schematron resource to read. May not be <code>null</code>.
   * @param aSettings
   *        The SAX reader settings to be used. May be <code>null</code> to use the default
   *        settings.
   * @param aErrorHandler
   *        The error handler to be used. May not be <code>null</code>.
   * @return <code>null</code> if the passed resource could not be read as XML document
   */
  @Nullable
  public static IMicroDocument getWithResolvedSchematronIncludes (@NonNull final IReadableResource aResource,
                                                                  @Nullable final ISAXReaderSettings aSettings,
                                                                  @NonNull final ISchematronErrorHandler aErrorHandler)
  {
    return getWithResolvedSchematronIncludes (aResource,
                                              aSettings,
                                              aErrorHandler,
                                              (ISchematronIncludeResolver) null,
                                              CSchematron.DEFAULT_ALLOW_DEPRECATED_NAMESPACES);
  }

  /**
   * Resolve all Schematron includes of the passed resource.
   *
   * @param aResource
   *        The Schematron resource to read. May not be <code>null</code>.
   * @param aSettings
   *        The SAX reader settings to be used. May be <code>null</code> to use the default
   *        settings.
   * @param aErrorHandler
   *        The error handler to be used. May not be <code>null</code>.
   * @param bLenient
   *        <code>true</code> if 'old' Schematron NS is tolerated.
   * @return <code>null</code> if the passed resource could not be read as XML document
   * @since 5.4.1
   */
  @Nullable
  public static IMicroDocument getWithResolvedSchematronIncludes (@NonNull final IReadableResource aResource,
                                                                  @Nullable final ISAXReaderSettings aSettings,
                                                                  @NonNull final ISchematronErrorHandler aErrorHandler,
                                                                  final boolean bLenient)
  {
    return getWithResolvedSchematronIncludes (aResource,
                                              aSettings,
                                              aErrorHandler,
                                              (ISchematronIncludeResolver) null,
                                              bLenient);
  }

  /**
   * Resolve all Schematron includes of the passed resource.
   *
   * @param aResource
   *        The Schematron resource to read. May not be <code>null</code>.
   * @param aSettings
   *        The SAX reader settings to be used. May be <code>null</code> to use the default
   *        settings.
   * @param aErrorHandler
   *        The error handler to be used. May not be <code>null</code>.
   * @param aCustomIncludeResolver
   *        A custom include resolver. May be <code>null</code>.
   * @param bLenient
   *        <code>true</code> if 'old' Schematron NS is tolerated.
   * @return <code>null</code> if the passed resource could not be read as XML document
   * @since 8.0.5
   */
  @Nullable
  public static IMicroDocument getWithResolvedSchematronIncludes (@NonNull final IReadableResource aResource,
                                                                  @Nullable final ISAXReaderSettings aSettings,
                                                                  @NonNull final ISchematronErrorHandler aErrorHandler,
                                                                  @Nullable final ISchematronIncludeResolver aCustomIncludeResolver,
                                                                  final boolean bLenient)
  {
    final InputSource aIS = InputSourceFactory.create (aResource);
    final IMicroDocument aDoc = MicroReader.readMicroXML (aIS, aSettings);
    if (aDoc != null)
    {
      // Resolve all Schematron includes
      final ICommonsOrderedSet <IncludeTarget> aIncludePath = new CommonsLinkedHashSet <> ();
      aIncludePath.add (new IncludeTarget (aResource, null));
      if (_recursiveResolveAllSchematronIncludes (aDoc.getDocumentElement (),
                                                  aResource,
                                                  aSettings,
                                                  aErrorHandler,
                                                  aCustomIncludeResolver,
                                                  bLenient,
                                                  new CommonsHashMap <> (),
                                                  aIncludePath).isFailure ())
      {
        // Error resolving includes
        return null;
      }
    }
    return aDoc;
  }
}
