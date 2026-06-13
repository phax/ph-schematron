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
package com.helger.schematron.schxslt.xslt2;

import java.io.File;
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
import javax.xml.transform.dom.DOMSource;
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
import com.helger.io.file.FilenameHelper;
import com.helger.io.file.SimpleFileIO;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.SchematronDebug;
import com.helger.schematron.SchematronInterruptedException;
import com.helger.schematron.api.xslt.ISchematronXSLTBasedProvider;
import com.helger.schematron.saxon.SchematronTransformerFactory;
import com.helger.xml.XMLFactory;
import com.helger.xml.serialize.write.XMLWriter;
import com.helger.xml.serialize.write.XMLWriterSettings;
import com.helger.xml.transform.LoggingTransformErrorListener;
import com.helger.xml.transform.TransformSourceFactory;
import com.helger.xml.transform.XMLTransformerFactory;

/**
 * The XSLT preprocessor used to convert a Schematron XML document (SCH) into an
 * XSLT document. This implementation uses JAXP with Saxon to be used as the
 * respective parser/compiler.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class SchematronProviderXSLTFromSchXslt_XSLT2 implements ISchematronXSLTBasedProvider
{
  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronProviderXSLTFromSchXslt_XSLT2.class);

  /**
   * The classpath directory where the Schematron 2 XSLT files reside.
   */
  public static final String SCHEMATRON_DIRECTORY_XSLT2 = "/xslt/2.0/";

  /**
   * The class path to first XSLT to be applied.
   */
  public static final String XSLT2_STEP1 = SCHEMATRON_DIRECTORY_XSLT2 + "include.xsl";

  /**
   * The class path to second XSLT to be applied.
   */
  public static final String XSLT2_STEP2 = SCHEMATRON_DIRECTORY_XSLT2 + "expand.xsl";

  /**
   * The class path to third and last XSLT to be applied.
   */
  public static final String XSLT2_STEP3 = SCHEMATRON_DIRECTORY_XSLT2 + "compile-for-svrl.xsl";

  private static Templates s_aStep1;
  private static Templates s_aStep2;
  private static Templates s_aStep3;

  private final SchematronSchXslt_XSLT2Config m_aConfig;
  private Document m_aSchematronXSLTDoc;
  private Templates m_aSchematronXSLTTemplates;

  /**
   * Ensure that all XSLT templates for converting Schematron to XSLT are
   * cached. That may be called on application startup, otherwise it is done
   * lazily on demand.
   */
  public static void cacheXSLTTemplates ()
  {
    final TransformerFactory aTF = SchematronTransformerFactory.getDefault ();
    final ClassLoader aCL = SchematronProviderXSLTFromSchXslt_XSLT2.class.getClassLoader ();

    // prepare all steps
    if (s_aStep1 == null)
    {
      // Step 1
      SchematronDebug.getDebugLogger ().info ("Creating SchXslt step 1 template");
      s_aStep1 = XMLTransformerFactory.newTemplates (aTF, new ClassPathResource (XSLT2_STEP1, aCL));
      if (s_aStep1 == null)
        throw new IllegalStateException ("Failed to compile '" + XSLT2_STEP1 + "'");
      SchematronDebug.getDebugLogger ().info ("Finished creating XSLT step 1 template");

      if (Thread.interrupted ())
        throw new SchematronInterruptedException ("after cached XSLT step 1");
    }

    if (s_aStep2 == null)
    {
      // Step 2
      SchematronDebug.getDebugLogger ().info ("Creating SchXslt step 2 template");
      s_aStep2 = XMLTransformerFactory.newTemplates (aTF, new ClassPathResource (XSLT2_STEP2, aCL));
      if (s_aStep2 == null)
        throw new IllegalStateException ("Failed to compile '" + XSLT2_STEP2 + "'");
      SchematronDebug.getDebugLogger ().info ("Finished creating XSLT step 2 template");

      if (Thread.interrupted ())
        throw new SchematronInterruptedException ("after cached XSLT step 2");
    }

    if (s_aStep3 == null)
    {
      // Step 3
      SchematronDebug.getDebugLogger ().info ("Creating SchXslt step 3 template");
      s_aStep3 = XMLTransformerFactory.newTemplates (aTF, new ClassPathResource (XSLT2_STEP3, aCL));
      if (s_aStep3 == null)
        throw new IllegalStateException ("Failed to compile '" + XSLT2_STEP3 + "'");
      SchematronDebug.getDebugLogger ().info ("Finished creating XSLT step 3 template");

      if (Thread.interrupted ())
        throw new SchematronInterruptedException ("after cached XSLT step 3");
    }
  }

  /**
   * Apply error-listener + URI-resolver from the config to a per-step XSLT {@link Transformer}, copy
   * across all configured XSLT parameters, and (on the final SCH&rarr;XSLT step) inject the
   * Schematron <code>phase</code> and <code>langCode</code> parameters.
   */
  private static void _applyConfigToTransformer (@NonNull final SchematronSchXslt_XSLT2Config aConfig,
                                                 final boolean bFinalStep,
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

    if (bFinalStep)
    {
      // On the last step, set the Schematron parameters as the last action so they cannot be
      // overwritten by a custom parameter.
      final String sPhase = aConfig.getPhase ();
      if (sPhase != null)
        aTransformer.setParameter ("phase", sPhase);
      final String sLanguageCode = aConfig.getLanguageCode ();
      if (sLanguageCode != null)
        aTransformer.setParameter ("langCode", sLanguageCode);
    }
  }

  @NonNull
  public static Document createSchematronXSLT (@NonNull final SchematronSchXslt_XSLT2Config aConfig) throws TransformerException
  {
    ValueEnforcer.notNull (aConfig, "Config");

    if (Thread.interrupted ())
      throw new SchematronInterruptedException ("before XSLT starts");

    cacheXSLTTemplates ();

    final IReadableResource aSchematronResource = aConfig.getResource ();

    // perform step 1 (Schematron -> ResultStep1; "include")
    final StreamSource aSrc1;
    final Document aResult1Doc = XMLFactory.newDocument ();
    {
      final StopWatch aSW = StopWatch.createdStarted ();
      final DOMResult aResult1 = new DOMResult (aResult1Doc);
      final Transformer aTransformer1 = s_aStep1.newTransformer ();
      _applyConfigToTransformer (aConfig, false, aTransformer1);
      aSrc1 = TransformSourceFactory.create (aSchematronResource);

      SchematronDebug.getDebugLogger ().info ( () -> "Now applying XSLT step 1 on " + aSchematronResource);
      aTransformer1.transform (aSrc1, aResult1);
      aSW.stop ();
      SchematronDebug.getDebugLogger ()
                     .info ( () -> "Finished applying SchXslt step 1 on " +
                                   aSchematronResource +
                                   " after " +
                                   aSW.getMillis () +
                                   "ms");

      if (Thread.interrupted ())
        throw new SchematronInterruptedException ("after XSLT step 1");
    }

    // perform step 2 (ResultStep1 -> ResultStep2, "expand")
    final Document aResult2Doc = XMLFactory.newDocument ();
    {
      final StopWatch aSW = StopWatch.createdStarted ();
      final DOMResult aResult2 = new DOMResult (aResult2Doc);
      final Transformer aTransformer2 = s_aStep2.newTransformer ();
      _applyConfigToTransformer (aConfig, false, aTransformer2);
      final DOMSource aSrc2 = TransformSourceFactory.create (aResult1Doc);
      // SystemId is required for "base-uri(.)" to work
      if (aSrc2.getSystemId () == null)
        aSrc2.setSystemId (aSrc1.getSystemId ());

      SchematronDebug.getDebugLogger ().info ( () -> "Now applying XSLT step 2 on " + aSchematronResource);
      aTransformer2.transform (aSrc2, aResult2);
      aSW.stop ();
      SchematronDebug.getDebugLogger ()
                     .info ( () -> "Finished applying SchXslt step 2 on " +
                                   aSchematronResource +
                                   " after " +
                                   aSW.getMillis () +
                                   "ms");

      if (SchematronDebug.isSaveIntermediateXSLTFiles ())
      {
        final String sXML = XMLWriter.getNodeAsString (aResult2Doc);
        final File aIntermediateFile = new File (SchematronDebug.getIntermediateMinifiedSCHFolder (),
                                                 FilenameHelper.getWithoutPath (aSchematronResource.getPath ()) +
                                                                                                      ".min-xslt.sch");

        SchematronDebug.getDebugLogger ()
                       .info ( () -> "Storing intermediate XSLT file to '" +
                                     aIntermediateFile.getAbsolutePath () +
                                     "'");

        if (SimpleFileIO.writeFile (aIntermediateFile, sXML, XMLWriterSettings.DEFAULT_XML_CHARSET_OBJ).isSuccess ())
          LOGGER.info ("Successfully wrote intermediate XSLT file '" + aIntermediateFile.getAbsolutePath () + "'");
        else
          LOGGER.error ("Failed to wrote intermediate XSLT file '" + aIntermediateFile.getAbsolutePath () + "'");
      }

      if (Thread.interrupted ())
        throw new SchematronInterruptedException ("after XSLT step 2");
    }

    // perform step 3 (ResultStep2 -> ResultStep3XSL; "compile-for-svrl")
    final Document aResult3Doc = XMLFactory.newDocument ();
    {
      final StopWatch aSW = StopWatch.createdStarted ();
      final DOMResult aResult3 = new DOMResult (aResult3Doc);
      final Transformer aTransformer3 = s_aStep3.newTransformer ();
      _applyConfigToTransformer (aConfig, true, aTransformer3);
      final DOMSource aSrc3 = TransformSourceFactory.create (aResult2Doc);
      // SystemId is required for "base-uri(.)" to work
      if (aSrc3.getSystemId () == null)
        aSrc3.setSystemId (aSrc1.getSystemId ());

      SchematronDebug.getDebugLogger ().info ( () -> "Now applying XSLT step 3 on " + aSchematronResource);
      aTransformer3.transform (aSrc3, aResult3);
      aSW.stop ();
      SchematronDebug.getDebugLogger ()
                     .info ( () -> "Finished applying SchXslt step 3 on " +
                                   aSchematronResource +
                                   " after " +
                                   aSW.getMillis () +
                                   "ms");

      if (SchematronDebug.isSaveIntermediateXSLTFiles ())
      {
        final String sXML = XMLWriter.getNodeAsString (aResult3Doc);
        final File aIntermediateFile = new File (SchematronDebug.getIntermediateFinalXSLTFolder (),
                                                 FilenameHelper.getWithoutPath (aSchematronResource.getPath ()) +
                                                                                                    ".xslt");

        SchematronDebug.getDebugLogger ()
                       .info ( () -> "Storing intermediate XSLT file to '" +
                                     aIntermediateFile.getAbsolutePath () +
                                     "'");

        if (SimpleFileIO.writeFile (aIntermediateFile, sXML, XMLWriterSettings.DEFAULT_XML_CHARSET_OBJ).isSuccess ())
          LOGGER.info ("Successfully wrote intermediate XSLT file '" + aIntermediateFile.getAbsolutePath () + "'");
        else
          LOGGER.error ("Failed to wrote intermediate XSLT file '" + aIntermediateFile.getAbsolutePath () + "'");
      }

      if (Thread.interrupted ())
        throw new SchematronInterruptedException ("after XSLT step 3");
    }

    return aResult3Doc;
  }

  /**
   * Constructor.
   *
   * @param aConfig
   *        The compilation config. May not be <code>null</code>.
   * @throws SchematronInterruptedException
   *         If Schematron compilation was interrupted
   */
  public SchematronProviderXSLTFromSchXslt_XSLT2 (@NonNull final SchematronSchXslt_XSLT2Config aConfig)
  {
    ValueEnforcer.notNull (aConfig, "Config");
    m_aConfig = aConfig;
  }

  /**
   * This call does the main Schematron to XSLT conversion. This method may only
   * be called once per instance.
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

      // compile result of step 3
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
      LOGGER.error ("SchXslt preprocessor error", ex);
    }

    if (Thread.interrupted ())
      throw new SchematronInterruptedException ("after XSLT template was created");
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
