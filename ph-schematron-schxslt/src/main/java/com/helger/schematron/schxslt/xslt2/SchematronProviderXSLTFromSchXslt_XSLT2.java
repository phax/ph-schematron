/**
 * Copyright (C) 2020-2021 Philip Helger (www.helger.com)
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

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.NotThreadSafe;
import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMResult;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.io.file.FilenameHelper;
import com.helger.commons.io.file.SimpleFileIO;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.schematron.SchematronDebug;
import com.helger.schematron.api.xslt.ISchematronXSLTBasedProvider;
import com.helger.schematron.saxon.SchematronTransformerFactory;
import com.helger.xml.serialize.write.XMLWriter;
import com.helger.xml.serialize.write.XMLWriterSettings;
import com.helger.xml.transform.TransformSourceFactory;
import com.helger.xml.transform.XMLTransformerFactory;

/**
 * The XSLT preprocessor used to convert a Schematron XML document into an XSLT
 * document. This implementation uses JAXP with Saxon to be used as the
 * respective parser.
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

  private static volatile Templates s_aStep1;
  private static volatile Templates s_aStep2;
  private static volatile Templates s_aStep3;

  private final IReadableResource m_aSchematronResource;
  private Document m_aSchematronXSLTDoc;
  private Templates m_aSchematronXSLTTemplates;

  public static void cacheXSLTTemplates ()
  {
    // prepare all steps
    if (s_aStep1 == null)
    {
      final TransformerFactory aTF = SchematronTransformerFactory.getDefaultSaxonFirst ();

      // Step 1
      if (LOGGER.isDebugEnabled ())
        LOGGER.debug ("Creating SchXslt step 1 template");
      s_aStep1 = XMLTransformerFactory.newTemplates (aTF,
                                                     new ClassPathResource (XSLT2_STEP1,
                                                                            SchematronProviderXSLTFromSchXslt_XSLT2.class.getClassLoader ()));
      if (s_aStep1 == null)
        throw new IllegalStateException ("Failed to compile '" + XSLT2_STEP1 + "'");

      // Step 2
      if (LOGGER.isDebugEnabled ())
        LOGGER.debug ("Creating SchXslt step 2 template");
      s_aStep2 = XMLTransformerFactory.newTemplates (aTF,
                                                     new ClassPathResource (XSLT2_STEP2,
                                                                            SchematronProviderXSLTFromSchXslt_XSLT2.class.getClassLoader ()));
      if (s_aStep2 == null)
        throw new IllegalStateException ("Failed to compile '" + XSLT2_STEP2 + "'");

      // Step 3
      if (LOGGER.isDebugEnabled ())
        LOGGER.debug ("Creating SchXslt step 3 template");
      s_aStep3 = XMLTransformerFactory.newTemplates (aTF,
                                                     new ClassPathResource (XSLT2_STEP3,
                                                                            SchematronProviderXSLTFromSchXslt_XSLT2.class.getClassLoader ()));
      if (s_aStep3 == null)
        throw new IllegalStateException ("Failed to compile '" + XSLT2_STEP3 + "'");
    }
  }

  /**
   * Constructor
   *
   * @param aSchematronResource
   *        SCH resource
   * @param aTransformerCustomizer
   *        The customizer for XSLT {@link Transformer} objects. May not be
   *        <code>null</code>.
   */
  public SchematronProviderXSLTFromSchXslt_XSLT2 (@Nonnull final IReadableResource aSchematronResource,
                                                  @Nonnull final TransformerCustomizerSchXslt_XSLT2 aTransformerCustomizer)
  {
    m_aSchematronResource = ValueEnforcer.notNull (aSchematronResource, "SchematronResource");
    ValueEnforcer.notNull (aTransformerCustomizer, "TransformerCustomizer");

    try
    {
      cacheXSLTTemplates ();

      // perform step 1 (Schematron -> ResultStep1)
      final DOMResult aResult1 = new DOMResult ();
      final Transformer aTransformer1 = s_aStep1.newTransformer ();
      aTransformerCustomizer.customize (EStepSchXslt_XSLT2.SCH2XSLT_1, aTransformer1);
      final StreamSource aSrc1 = TransformSourceFactory.create (aSchematronResource);
      aTransformer1.transform (aSrc1, aResult1);

      if (LOGGER.isDebugEnabled ())
        LOGGER.debug ("Finished applying SchXslt step 1 on " + aSchematronResource);

      // perform step 2 (ResultStep1 -> ResultStep2)
      final DOMResult aResult2 = new DOMResult ();
      final Transformer aTransformer2 = s_aStep2.newTransformer ();
      aTransformerCustomizer.customize (EStepSchXslt_XSLT2.SCH2XSLT_2, aTransformer2);
      final DOMSource aSrc2 = TransformSourceFactory.create (aResult1.getNode ());
      // SystemId is required for "base-uri(.)" to work
      if (aSrc2.getSystemId () == null)
        aSrc2.setSystemId (aSrc1.getSystemId ());
      aTransformer2.transform (aSrc2, aResult2);

      if (LOGGER.isDebugEnabled ())
        LOGGER.debug ("Finished applying SchXslt step 2 on " + aSchematronResource);

      if (SchematronDebug.isSaveIntermediateXSLTFiles ())
      {
        final String sXML = XMLWriter.getNodeAsString (aResult2.getNode ());
        final File aIntermediateFile = new File (SchematronDebug.getIntermediateMinifiedSCHFolder (),
                                                 FilenameHelper.getWithoutPath (aSchematronResource.getPath ()) +
                                                                                                      ".min-xslt.sch");
        if (SimpleFileIO.writeFile (aIntermediateFile, sXML, XMLWriterSettings.DEFAULT_XML_CHARSET_OBJ).isSuccess ())
          LOGGER.info ("Successfully wrote intermediate XSLT file '" + aIntermediateFile.getAbsolutePath () + "'");
        else
          LOGGER.error ("Failed to wrote intermediate XSLT file '" + aIntermediateFile.getAbsolutePath () + "'");
      }

      // perform step 3 (ResultStep2 -> ResultStep3XSL)
      final DOMResult aResult3 = new DOMResult ();
      final Transformer aTransformer3 = s_aStep3.newTransformer ();
      aTransformerCustomizer.customize (EStepSchXslt_XSLT2.SCH2XSLT_3, aTransformer3);
      final DOMSource aSrc3 = TransformSourceFactory.create (aResult2.getNode ());
      // SystemId is required for "base-uri(.)" to work
      if (aSrc3.getSystemId () == null)
        aSrc3.setSystemId (aSrc1.getSystemId ());
      aTransformer3.transform (aSrc3, aResult3);

      if (LOGGER.isDebugEnabled ())
        LOGGER.debug ("Finished applying SchXslt step 3 on " + aSchematronResource);

      // Save the underlying XSLT document....
      // Note: Saxon 6.5.5 does not allow to clone the document node!!!!
      m_aSchematronXSLTDoc = (Document) aResult3.getNode ();

      if (SchematronDebug.isSaveIntermediateXSLTFiles ())
      {
        final String sXML = XMLWriter.getNodeAsString (m_aSchematronXSLTDoc);
        final File aIntermediateFile = new File (SchematronDebug.getIntermediateFinalXSLTFolder (),
                                                 FilenameHelper.getWithoutPath (aSchematronResource.getPath ()) +
                                                                                                    ".xslt");
        if (SimpleFileIO.writeFile (aIntermediateFile, sXML, XMLWriterSettings.DEFAULT_XML_CHARSET_OBJ).isSuccess ())
          LOGGER.info ("Successfully wrote intermediate XSLT file '" + aIntermediateFile.getAbsolutePath () + "'");
        else
          LOGGER.error ("Failed to wrote intermediate XSLT file '" + aIntermediateFile.getAbsolutePath () + "'");
      }

      // compile result of step 3
      final TransformerFactory aTF = SchematronTransformerFactory.getDefaultSaxonFirst ();
      aTransformerCustomizer.customize (aTF);
      m_aSchematronXSLTTemplates = XMLTransformerFactory.newTemplates (aTF,
                                                                       TransformSourceFactory.create (m_aSchematronXSLTDoc));
    }
    catch (final Exception ex)
    {
      LOGGER.error ("SchXslt preprocessor error", ex);
    }
  }

  @Nonnull
  public IReadableResource getSchematronResource ()
  {
    return m_aSchematronResource;
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
