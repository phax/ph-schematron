/*
 * Copyright (C) 2015-2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.purexslt;

import javax.xml.transform.dom.DOMSource;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.state.EValidity;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.ISchematronValidator;
import com.helger.schematron.SchematronException;
import com.helger.schematron.api.telemetry.SchematronTraceListener;
import com.helger.schematron.purexslt.SchematronPureXsltConfig.Builder;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.FailedAssert;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.xml.XMLFactory;
import com.helger.xml.serialize.write.EXMLSerializeIndent;
import com.helger.xml.serialize.write.XMLWriter;
import com.helger.xml.serialize.write.XMLWriterSettings;

import net.sf.saxon.lib.ResourceResolverWrappingURIResolver;
import net.sf.saxon.s9api.DOMDestination;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.XsltExecutable;

/**
 * Builder-driven validator entry point for the pure-Java Saxon-native Schematron engine.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
@NotThreadSafe
public final class SchematronPureXslt implements ISchematronValidator
{
  private final SchematronPureXsltConfig m_aConfig;
  private final XsltExecutable m_aExecutable;

  private SchematronPureXslt (@NonNull final SchematronPureXsltConfig aConfig,
                              @NonNull final XsltExecutable aExecutable)
  {
    m_aConfig = aConfig;
    m_aExecutable = aExecutable;
  }

  /**
   * @return The configuration this instance was created from. Never <code>null</code>.
   */
  @NonNull
  public SchematronPureXsltConfig getConfig ()
  {
    return m_aConfig;
  }

  /**
   * @return The compiled Saxon XSLT executable. Never <code>null</code>.
   */
  @NonNull
  public XsltExecutable getCompiledXslt ()
  {
    return m_aExecutable;
  }

  /**
   * @return Always <code>true</code> for this engine, because a non-<code>null</code>
   *         {@link XsltExecutable} is a precondition of construction.
   */
  public boolean isValidSchematron ()
  {
    return true;
  }

  /**
   * Apply Schematron validation to the given XML node, returning the SVRL output object.
   *
   * @param aXMLNode
   *        The XML node to validate. May not be <code>null</code>.
   * @param sBaseURI
   *        Optional base URI used as the source system ID.
   * @return The parsed SVRL output. Never <code>null</code>.
   * @throws SaxonApiException
   *         If the Saxon transformation fails.
   */
  @NonNull
  public SchematronOutputType applyToSVRL (@NonNull final Node aXMLNode, @Nullable final String sBaseURI)
                                                                                                          throws SaxonApiException
  {
    ValueEnforcer.notNull (aXMLNode, "XMLNode");

    final Document aResultDoc = XMLFactory.newDocument ();
    final DOMDestination aDestination = new DOMDestination (aResultDoc);
    final var aTransformer = m_aExecutable.load30 ();
    if (m_aConfig.getURIResolver () != null)
      aTransformer.setResourceResolver (new ResourceResolverWrappingURIResolver (m_aConfig.getURIResolver ()));
    if (m_aConfig.getErrorListener () != null)
      aTransformer.setErrorListener (m_aConfig.getErrorListener ());
    if (m_aConfig.getTelemetry () != null)
      aTransformer.setTraceListener (new SchematronTraceListener (m_aConfig.getTelemetry ()));
    if (sBaseURI != null)
      aTransformer.setGlobalContextItem (m_aConfig.getProcessor ().newDocumentBuilder ().wrap (aXMLNode));
    aTransformer.applyTemplates (new DOMSource (aXMLNode, sBaseURI), aDestination);

    final SchematronOutputType aSVRL = new SVRLMarshaller ().setUseSchema (false).read (aResultDoc);
    if (aSVRL == null)
      throw new IllegalStateException ("Saxon transformation did not produce a parseable SVRL document:\n" +
                                       XMLWriter.getNodeAsString (aResultDoc,
                                                                  new XMLWriterSettings ().setIndent (EXMLSerializeIndent.INDENT_AND_ALIGN)));
    return aSVRL;
  }

  /**
   * Apply Schematron validation and reduce the SVRL output to a {@link EValidity} verdict. Returns
   * {@link EValidity#INVALID} if any failed-assert element is present.
   *
   * @param aXMLNode
   *        The XML node to validate. May not be <code>null</code>.
   * @param sBaseURI
   *        Optional base URI used as the source system ID.
   * @return The validity verdict. Never <code>null</code>.
   * @throws SaxonApiException
   *         If the Saxon transformation fails.
   */
  @NonNull
  public EValidity getValidity (@NonNull final Node aXMLNode, @Nullable final String sBaseURI) throws SaxonApiException
  {
    final SchematronOutputType aSVRL = applyToSVRL (aXMLNode, sBaseURI);
    for (final Object aObj : aSVRL.getActivePatternAndFiredRuleAndFailedAssert ())
      if (aObj instanceof FailedAssert)
        return EValidity.INVALID;
    return EValidity.VALID;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("Config", m_aConfig)
                                       .append ("Executable", m_aExecutable)
                                       .getToString ();
  }

  // === Compilation entry points ===

  /**
   * Compile the given config via the {@link SchematronPureXsltCache#shared() shared cache}.
   *
   * @param aConfig
   *        The configuration to compile. May not be <code>null</code>.
   * @return A new {@link SchematronPureXslt} instance wrapping the compiled executable. Never
   *         <code>null</code>.
   * @throws SchematronException
   *         on compilation error.
   */
  @NonNull
  public static SchematronPureXslt compileCached (@NonNull final SchematronPureXsltConfig aConfig) throws SchematronException
  {
    return compileCached (aConfig, SchematronPureXsltCache.shared ());
  }

  /**
   * Compile the given config via the supplied cache instance.
   *
   * @param aConfig
   *        The configuration to compile. May not be <code>null</code>.
   * @param aCache
   *        The cache instance to use. May not be <code>null</code>.
   * @return A new {@link SchematronPureXslt} instance wrapping the compiled executable. Never
   *         <code>null</code>.
   * @throws SchematronException
   *         on compilation error.
   */
  @NonNull
  public static SchematronPureXslt compileCached (@NonNull final SchematronPureXsltConfig aConfig,
                                                  @NonNull final SchematronPureXsltCache aCache) throws SchematronException
  {
    ValueEnforcer.notNull (aConfig, "Config");
    ValueEnforcer.notNull (aCache, "Cache");
    final XsltExecutable aExe = aCache.getOrCompile (aConfig);
    if (aExe == null)
      throw new SchematronException ("Failed to compile pure-XSLT for " + aConfig.getResource ());
    return new SchematronPureXslt (aConfig, aExe);
  }

  /**
   * Compile the given config without using any cache.
   *
   * @param aConfig
   *        The configuration to compile. May not be <code>null</code>.
   * @return A new {@link SchematronPureXslt} instance wrapping the freshly compiled executable.
   *         Never <code>null</code>.
   * @throws SchematronException
   *         on compilation error.
   */
  @NonNull
  public static SchematronPureXslt compileUncached (@NonNull final SchematronPureXsltConfig aConfig) throws SchematronException
  {
    ValueEnforcer.notNull (aConfig, "Config");
    final XsltExecutable aExe = aConfig.compile ();
    if (aExe == null)
      throw new SchematronException ("Failed to compile pure-XSLT for " + aConfig.getResource ());
    return new SchematronPureXslt (aConfig, aExe);
  }

  /**
   * Shortcut to {@link SchematronPureXsltConfig#builder(IReadableResource)}.
   *
   * @param aResource
   *        The Schematron resource to validate against. May not be <code>null</code>.
   * @return A new {@link Builder} pre-configured with the given resource. Never <code>null</code>.
   */
  @NonNull
  public static Builder builder (@NonNull final IReadableResource aResource)
  {
    return SchematronPureXsltConfig.builder (aResource);
  }
}
