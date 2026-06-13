/*
 * Copyright (C) 2020-2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.schxslt2.xslt;

import java.util.Locale;
import java.util.Map;
import java.util.function.Consumer;

import javax.xml.transform.ErrorListener;
import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.URIResolver;
import javax.xml.transform.dom.DOMResult;
import javax.xml.transform.stream.StreamSource;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.timing.StopWatch;
import com.helger.collection.commons.ICommonsOrderedMap;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.SchematronDebug;
import com.helger.schematron.SchematronInterruptedException;
import com.helger.schematron.api.xslt.ISchematronXSLTBasedProvider;
import com.helger.schematron.saxon.SchematronTransformerFactory;
import com.helger.xml.XMLFactory;
import com.helger.xml.transform.LoggingTransformErrorListener;
import com.helger.xml.transform.TransformSourceFactory;
import com.helger.xml.transform.XMLTransformerFactory;

/**
 * The XSLT preprocessor used to convert a Schematron XML document (SCH) into an XSLT document. This
 * implementation uses JAXP with Saxon to be used as the respective parser/compiler.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class SchematronProviderXSLTFromSchXslt2 implements ISchematronXSLTBasedProvider
{
  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronProviderXSLTFromSchXslt2.class);

  /**
   * The class path to the XSLT to be applied.
   */
  public static final String TRANSPILE_PATH = "/content/transpile.xsl";

  private static Templates s_aTemplate;

  private final SchematronSchXslt2Config m_aConfig;
  private Document m_aSchematronXSLTDoc;
  private Templates m_aSchematronXSLTTemplates;

  /**
   * Ensure that all XSLT templates for converting Schematron to XSLT are cached. That may be called
   * on application startup, otherwise it is done lazily on demand.
   */
  public static void cacheXSLTTemplate ()
  {
    final TransformerFactory aTF = SchematronTransformerFactory.getDefault ();
    final ClassLoader aCL = SchematronProviderXSLTFromSchXslt2.class.getClassLoader ();

    // prepare all steps
    if (s_aTemplate == null)
    {
      // Step 1
      SchematronDebug.getDebugLogger ().info ("Creating SchXslt2 template");
      s_aTemplate = XMLTransformerFactory.newTemplates (aTF, new ClassPathResource (TRANSPILE_PATH, aCL));
      if (s_aTemplate == null)
        throw new IllegalStateException ("Failed to compile '" + TRANSPILE_PATH + "'");
      SchematronDebug.getDebugLogger ().info ("Finished creating SchXslt2 template");

      if (Thread.interrupted ())
        throw new SchematronInterruptedException ("after creating SchXslt2 template");
    }
  }

  /**
   * Apply error-listener + URI-resolver from the config to the transpile {@link Transformer}, copy
   * across all configured XSLT parameters, and inject the Schematron <code>phase</code> and
   * <code>langCode</code> parameters.
   */
  private static void _applyConfigToTransformer (@NonNull final SchematronSchXslt2Config aConfig,
                                                 @NonNull final Transformer aTransformer)
  {
    final ErrorListener aErrorListener = aConfig.getErrorListener ();
    aTransformer.setErrorListener (aErrorListener != null ? aErrorListener : new LoggingTransformErrorListener (Locale.US));

    final URIResolver aURIResolver = aConfig.getURIResolver ();
    if (aURIResolver != null)
      aTransformer.setURIResolver (aURIResolver);

    final ICommonsOrderedMap <String, Object> aParameters = aConfig.getParameters ();
    for (final Map.Entry <String, Object> aEntry : aParameters.entrySet ())
      aTransformer.setParameter (aEntry.getKey (), aEntry.getValue ());

    // Set the Schematron parameters last so they cannot be overwritten by a custom parameter.
    final String sPhase = aConfig.getPhase ();
    if (sPhase != null)
      aTransformer.setParameter ("phase", sPhase);
    final String sLanguageCode = aConfig.getLanguageCode ();
    if (sLanguageCode != null)
      aTransformer.setParameter ("langCode", sLanguageCode);
  }

  @NonNull
  public static Document createSchematronXSLT (@NonNull final SchematronSchXslt2Config aConfig) throws TransformerException
  {
    ValueEnforcer.notNull (aConfig, "Config");

    if (Thread.interrupted ())
      throw new SchematronInterruptedException ("before XSLT starts");

    cacheXSLTTemplate ();

    final IReadableResource aSchematronResource = aConfig.getResource ();

    final StreamSource aSrc1;
    final Document aResult1Doc = XMLFactory.newDocument ();
    {
      final StopWatch aSW = StopWatch.createdStarted ();
      final DOMResult aResult1 = new DOMResult (aResult1Doc);
      final Transformer aTransformer = s_aTemplate.newTransformer ();
      _applyConfigToTransformer (aConfig, aTransformer);
      aSrc1 = TransformSourceFactory.create (aSchematronResource);

      SchematronDebug.getDebugLogger ().info ( () -> "Now applying SchXslt2 XSLT on " + aSchematronResource);
      aTransformer.transform (aSrc1, aResult1);
      aSW.stop ();
      SchematronDebug.getDebugLogger ()
                     .info ( () -> "Finished applying SchXslt2 XSLT on " +
                                   aSchematronResource +
                                   " after " +
                                   aSW.getMillis () +
                                   "ms");

      if (Thread.interrupted ())
        throw new SchematronInterruptedException ("After applying SchXslt2 XSLT on XML");
    }

    return aResult1Doc;
  }

  /**
   * Constructor.
   *
   * @param aConfig
   *        The compilation config. May not be <code>null</code>.
   * @throws SchematronInterruptedException
   *         If Schematron compilation was interrupted
   */
  public SchematronProviderXSLTFromSchXslt2 (@NonNull final SchematronSchXslt2Config aConfig)
  {
    ValueEnforcer.notNull (aConfig, "Config");
    m_aConfig = aConfig;
  }

  /**
   * This call does the main Schematron to XSLT conversion. This method may only be called once per
   * instance.
   */
  public void convertSchematronToXSLT ()
  {
    if (m_aSchematronXSLTDoc != null)
      throw new IllegalStateException ("The conversion from Schematron to XSLT already happened");

    final IReadableResource aSchematronResource = m_aConfig.getResource ();
    try
    {
      // Save the underlying XSLT document....
      // Note: Saxon 6.5.5 does not allow to clone the document node!!!!
      m_aSchematronXSLTDoc = createSchematronXSLT (m_aConfig);

      // compile XSLT
      // When telemetry is enabled, the final stylesheet must be compiled with Saxon tracing
      // so that per-template events fire at execution time.
      final TransformerFactory aTF = m_aConfig.isTracingEnabled () ? SchematronTransformerFactory.createTransformerFactory (m_aConfig.getErrorListener (),
                                                                                                                            m_aConfig.getURIResolver (),
                                                                                                                            true)
                                                                   : SchematronTransformerFactory.getDefault ();
      // Apply error listener + URI resolver to the final-compile factory
      final ErrorListener aErrorListener = m_aConfig.getErrorListener ();
      aTF.setErrorListener (aErrorListener != null ? aErrorListener : new LoggingTransformErrorListener (Locale.US));
      final URIResolver aURIResolver = m_aConfig.getURIResolver ();
      if (aURIResolver != null)
        aTF.setURIResolver (aURIResolver);
      // Hand the factory to the caller-supplied customizer last so it can register Saxon
      // extension functions (or any other tweak) just before the validation stylesheet compiles.
      final Consumer <TransformerFactory> aTFCustomizer = m_aConfig.getTransformerFactoryCustomizer ();
      if (aTFCustomizer != null)
        aTFCustomizer.accept (aTF);
      m_aSchematronXSLTTemplates = XMLTransformerFactory.newTemplates (aTF,
                                                                       TransformSourceFactory.create (m_aSchematronXSLTDoc));

      if (LOGGER.isDebugEnabled ())
        LOGGER.debug ("Finished creating XSLT Template on " + aSchematronResource);
    }
    catch (final SchematronInterruptedException ex)
    {
      throw ex;
    }
    catch (final Exception ex)
    {
      LOGGER.error ("SchXslt2 preprocessor error", ex);
    }

    if (Thread.interrupted ())
      throw new SchematronInterruptedException ("after SchXslt2 XSLT template was created");
  }

  @NonNull
  public IReadableResource getSchematronResource ()
  {
    return m_aConfig.getResource ();
  }

  public boolean isValidSchematron ()
  {
    return m_aSchematronXSLTTemplates != null;
  }

  @Nullable
  public Document getXSLTDocument ()
  {
    return m_aSchematronXSLTDoc;
  }

  @Nullable
  public Transformer getXSLTTransformer () throws TransformerConfigurationException
  {
    return m_aSchematronXSLTTemplates == null ? null : m_aSchematronXSLTTemplates.newTransformer ();
  }
}
