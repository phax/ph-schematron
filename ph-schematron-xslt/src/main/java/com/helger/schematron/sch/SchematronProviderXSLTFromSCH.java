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
package com.helger.schematron.sch;

import java.io.File;

import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMResult;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.string.StringHelper;
import com.helger.base.timing.StopWatch;
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
import com.helger.xml.transform.TransformSourceFactory;
import com.helger.xml.transform.XMLTransformerFactory;

import jakarta.annotation.Nonnull;
import jakarta.annotation.Nullable;

/**
 * The XSLT preprocessor used to convert a Schematron XML document into an XSLT document. This
 * implementation uses JAXP with Saxon to be used as the respective parser.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class SchematronProviderXSLTFromSCH implements ISchematronXSLTBasedProvider
{
  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronProviderXSLTFromSCH.class);

  /**
   * The classpath directory where the Schematron 2 XSLT files reside.
   */
  public static final String SCHEMATRON_DIRECTORY_XSLT2 = "external/schematron/20100710-xslt2/";

  /**
   * The class path to first XSLT to be applied.
   */
  public static final String XSLT2_STEP1 = SCHEMATRON_DIRECTORY_XSLT2 + "iso_dsdl_include.xsl";

  /**
   * The class path to second XSLT to be applied.
   */
  public static final String XSLT2_STEP2 = SCHEMATRON_DIRECTORY_XSLT2 + "iso_abstract_expand.xsl";

  /**
   * The class path to third and last XSLT to be applied.
   */
  public static final String XSLT2_STEP3 = SCHEMATRON_DIRECTORY_XSLT2 + "iso_svrl_for_xslt2.xsl";

  private static Templates s_aStep1;
  private static Templates s_aStep2;
  private static Templates s_aStep3;

  private final IReadableResource m_aSchematronResource;
  private final TransformerCustomizerSCH m_aTransformerCustomizer;
  private Document m_aSchematronXSLTDoc;
  private Templates m_aSchematronXSLTTemplates;

  /**
   * Ensure that all XSLT templates for converting Schematron to XSLT are cached. That may be called
   * on application startup, otherwise it is done lazily on demand.
   */
  public static void cacheXSLTTemplates ()
  {
    final TransformerFactory aTF = SchematronTransformerFactory.getDefaultSaxonFirst ();
    final ClassLoader aCL = SchematronProviderXSLTFromSCH.class.getClassLoader ();

    // prepare all steps
    if (s_aStep1 == null)
    {
      // Step 1
      SchematronDebug.getDebugLogger ().info ("Creating XSLT step 1 template");
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
      SchematronDebug.getDebugLogger ().info ("Creating XSLT step 2 template");
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
      SchematronDebug.getDebugLogger ().info ("Creating XSLT step 3 template");
      s_aStep3 = XMLTransformerFactory.newTemplates (aTF, new ClassPathResource (XSLT2_STEP3, aCL));
      if (s_aStep3 == null)
        throw new IllegalStateException ("Failed to compile '" + XSLT2_STEP3 + "'");
      SchematronDebug.getDebugLogger ().info ("Finished creating XSLT step 3 template");

      if (Thread.interrupted ())
        throw new SchematronInterruptedException ("after cached XSLT step 3");
    }
  }

  @Nonnull
  public static Document createSchematronXSLT (@Nonnull final IReadableResource aSchematronResource,
                                               @Nonnull final TransformerCustomizerSCH aTransformerCustomizer) throws TransformerException
  {
    if (Thread.interrupted ())
      throw new SchematronInterruptedException ("before XSLT starts");

    // On the first call, initializes the templates
    cacheXSLTTemplates ();

    // perform step 1 (Schematron -> ResultStep1)
    final StreamSource aSrc1;
    final Document aResult1Doc = XMLFactory.newDocument ();
    {
      final StopWatch aSW = StopWatch.createdStarted ();
      final DOMResult aResult1 = new DOMResult (aResult1Doc);
      final Transformer aTransformer1 = s_aStep1.newTransformer ();
      aTransformerCustomizer.customize (EStepSCH.SCH2XSLT_1, aTransformer1);
      aSrc1 = TransformSourceFactory.create (aSchematronResource);

      SchematronDebug.getDebugLogger ().info ( () -> "Now applying XSLT step 1 on " + aSchematronResource);
      aTransformer1.transform (aSrc1, aResult1);
      aSW.stop ();
      SchematronDebug.getDebugLogger ()
                     .info ( () -> "Finished applying XSLT step 1 on " +
                                   aSchematronResource +
                                   " after " +
                                   aSW.getMillis () +
                                   "ms");

      if (Thread.interrupted ())
        throw new SchematronInterruptedException ("after XSLT step 1");
    }

    // perform step 2 (ResultStep1 -> ResultStep2)
    final Document aResult2Doc = XMLFactory.newDocument ();
    {
      final StopWatch aSW = StopWatch.createdStarted ();
      final DOMResult aResult2 = new DOMResult (aResult2Doc);
      final Transformer aTransformer2 = s_aStep2.newTransformer ();
      aTransformerCustomizer.customize (EStepSCH.SCH2XSLT_2, aTransformer2);
      final DOMSource aSrc2 = TransformSourceFactory.create (aResult1Doc);
      // SystemId is required for "base-uri(.)" to work
      if (aSrc2.getSystemId () == null)
        aSrc2.setSystemId (aSrc1.getSystemId ());

      SchematronDebug.getDebugLogger ().info ( () -> "Now applying XSLT step 2 on " + aSchematronResource);
      aTransformer2.transform (aSrc2, aResult2);
      aSW.stop ();
      SchematronDebug.getDebugLogger ()
                     .info ( () -> "Finished applying XSLT step 2 on " +
                                   aSchematronResource +
                                   " after " +
                                   aSW.getMillis () +
                                   "ms");

      if (SchematronDebug.isSaveIntermediateXSLTFiles ())
      {
        final String sXML = XMLWriter.getNodeAsString (aResult2Doc);
        String sBasename = FilenameHelper.getWithoutPath (aSchematronResource.getPath ());
        if (StringHelper.isEmpty (sBasename))
          sBasename = "in-memory";
        final File aIntermediateFile = new File (SchematronDebug.getIntermediateMinifiedSCHFolder (),
                                                 sBasename + ".min-xslt.sch");

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

    // perform step 3 (ResultStep2 -> ResultStep3XSL)
    final Document aResult3Doc = XMLFactory.newDocument ();
    {
      final StopWatch aSW = StopWatch.createdStarted ();
      final DOMResult aResult3 = new DOMResult (aResult3Doc);
      final Transformer aTransformer3 = s_aStep3.newTransformer ();
      aTransformerCustomizer.customize (EStepSCH.SCH2XSLT_3, aTransformer3);
      final DOMSource aSrc3 = TransformSourceFactory.create (aResult2Doc);
      // SystemId is required for "base-uri(.)" to work
      if (aSrc3.getSystemId () == null)
        aSrc3.setSystemId (aSrc1.getSystemId ());

      SchematronDebug.getDebugLogger ().info ( () -> "Now applying XSLT step 3 on " + aSchematronResource);
      aTransformer3.transform (aSrc3, aResult3);
      aSW.stop ();
      SchematronDebug.getDebugLogger ()
                     .info ( () -> "Finished applying XSLT step 3 on " +
                                   aSchematronResource +
                                   " after " +
                                   aSW.getMillis () +
                                   "ms");

      if (SchematronDebug.isSaveIntermediateXSLTFiles ())
      {
        final String sXML = XMLWriter.getNodeAsString (aResult3Doc);
        String sBasename = FilenameHelper.getWithoutPath (aSchematronResource.getPath ());
        if (StringHelper.isEmpty (sBasename))
          sBasename = "in-memory";
        final File aIntermediateFile = new File (SchematronDebug.getIntermediateFinalXSLTFolder (),
                                                 sBasename + ".xslt");

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
   * @param aSchematronResource
   *        SCH resource. May not be <code>null</code>.
   * @param aTransformerCustomizer
   *        The customizer for XSLT {@link Transformer} objects. May not be <code>null</code>.
   * @throws SchematronInterruptedException
   *         if Schematron validation was interrupted
   */
  protected SchematronProviderXSLTFromSCH (@Nonnull final IReadableResource aSchematronResource,
                                           @Nonnull final TransformerCustomizerSCH aTransformerCustomizer)
  {
    ValueEnforcer.notNull (aSchematronResource, "SchematronResource");
    ValueEnforcer.notNull (aTransformerCustomizer, "TransformerCustomizer");

    m_aSchematronResource = aSchematronResource;
    m_aTransformerCustomizer = aTransformerCustomizer;
  }

  /**
   * This call does the main Schematron to XSLT conversion. This method may only be called once per
   * instance.
   */
  public void convertSchematronToXSLT ()
  {
    if (m_aSchematronXSLTDoc != null)
      throw new IllegalStateException ("The conversion from Schematron to XSLT already happened");

    try
    {
      // Save the underlying XSLT document....
      // Note: Saxon 6.5.5 does not allow to clone the document node!!!!
      m_aSchematronXSLTDoc = createSchematronXSLT (m_aSchematronResource, m_aTransformerCustomizer);

      // compile result of step 3
      final TransformerFactory aTF = SchematronTransformerFactory.getDefaultSaxonFirst ();
      m_aTransformerCustomizer.customize (aTF);
      m_aSchematronXSLTTemplates = XMLTransformerFactory.newTemplates (aTF,
                                                                       TransformSourceFactory.create (m_aSchematronXSLTDoc));

      if (LOGGER.isDebugEnabled ())
        LOGGER.debug ("Finished creating XSLT Template on " + m_aSchematronResource);
    }
    catch (final SchematronInterruptedException ex)
    {
      throw ex;
    }
    catch (final Exception ex)
    {
      LOGGER.error ("Schematron preprocessor error", ex);
    }

    if (Thread.interrupted ())
      throw new SchematronInterruptedException ("after XSLT template was created");
  }

  @Nonnull
  public final IReadableResource getSchematronResource ()
  {
    return m_aSchematronResource;
  }

  public boolean isValidSchematron ()
  {
    return m_aSchematronXSLTTemplates != null;
  }

  @Nullable
  public final Document getXSLTDocument ()
  {
    return m_aSchematronXSLTDoc;
  }

  @Nullable
  public Transformer getXSLTTransformer () throws TransformerConfigurationException
  {
    return m_aSchematronXSLTTemplates == null ? null : m_aSchematronXSLTTemplates.newTransformer ();
  }
}
