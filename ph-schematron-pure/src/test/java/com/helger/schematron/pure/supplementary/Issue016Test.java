/*
 * Copyright (C) 2014-2021 Philip Helger (www.helger.com)
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
package com.helger.schematron.pure.supplementary;

import static org.junit.Assert.assertNotNull;

import java.io.File;
import java.util.List;

import javax.annotation.Nonnull;
import javax.xml.transform.stream.StreamSource;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;

import com.helger.commons.io.file.FileHelper;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.FileSystemResource;
import com.helger.schematron.ISchematronResource;
import com.helger.schematron.pure.SchematronResourcePure;
import com.helger.schematron.pure.binding.IPSQueryBinding;
import com.helger.schematron.pure.binding.PSQueryBindingRegistry;
import com.helger.schematron.pure.bound.IPSBoundSchema;
import com.helger.schematron.pure.errorhandler.DoNothingPSErrorHandler;
import com.helger.schematron.pure.exchange.PSReader;
import com.helger.schematron.pure.model.PSSchema;
import com.helger.schematron.pure.model.PSTitle;
import com.helger.schematron.pure.preprocess.PSPreprocessor;
import com.helger.schematron.sch.SchematronResourceSCH;
import com.helger.schematron.svrl.SVRLFailedAssert;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.SVRLSuccessfulReport;
import com.helger.schematron.svrl.jaxb.DiagnosticReference;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.xml.microdom.serialize.MicroWriter;
import com.helger.xml.serialize.read.DOMReader;

public final class Issue016Test
{
  public static final class SchematronUtil
  {
    public static boolean validateXMLViaXSLTSchematron (@Nonnull final File aSchematronFile, @Nonnull final File aXMLFile) throws Exception
    {
      final ISchematronResource aResSCH = SchematronResourceSCH.fromFile (aSchematronFile);
      if (!aResSCH.isValidSchematron ())
        throw new IllegalArgumentException ("Invalid Schematron!");
      return aResSCH.getSchematronValidity (new StreamSource (aXMLFile)).isValid ();
    }

    public static SchematronOutputType validateXMLViaXSLTSchematronFull (@Nonnull final File aSchematronFile,
                                                                         @Nonnull final File aXMLFile) throws Exception
    {
      final ISchematronResource aResSCH = SchematronResourceSCH.fromFile (aSchematronFile);
      if (!aResSCH.isValidSchematron ())
        throw new IllegalArgumentException ("Invalid Schematron!");
      return aResSCH.applySchematronValidationToSVRL (new StreamSource (aXMLFile));
    }

    public static boolean validateXMLViaPureSchematron (@Nonnull final File aSchematronFile, @Nonnull final File aXMLFile) throws Exception
    {
      final ISchematronResource aResPure = SchematronResourcePure.fromFile (aSchematronFile);
      if (!aResPure.isValidSchematron ())
        throw new IllegalArgumentException ("Invalid Schematron!");
      return aResPure.getSchematronValidity (new StreamSource (aXMLFile)).isValid ();
    }

    public static boolean validateXMLViaPureSchematron2 (@Nonnull final File aSchematronFile, @Nonnull final File aXMLFile) throws Exception
    {
      // Read the schematron from file
      final PSSchema aSchema = new PSReader (new FileSystemResource (aSchematronFile)).readSchema ();
      if (!aSchema.isValid (new DoNothingPSErrorHandler ()))
        throw new IllegalArgumentException ("Invalid Schematron!");
      // Resolve the query binding to use
      final IPSQueryBinding aQueryBinding = PSQueryBindingRegistry.getQueryBindingOfNameOrThrow (aSchema.getQueryBinding ());
      // Pre-process schema
      final PSPreprocessor aPreprocessor = new PSPreprocessor (aQueryBinding);
      aPreprocessor.setKeepTitles (true);
      final PSSchema aPreprocessedSchema = aPreprocessor.getAsPreprocessedSchema (aSchema);
      // Bind the pre-processed schema
      final IPSBoundSchema aBoundSchema = aQueryBinding.bind (aPreprocessedSchema);
      // Read the XML file
      final Document aXMLNode = DOMReader.readXMLDOM (aXMLFile);
      if (aXMLNode == null)
        return false;
      // Perform the validation
      return aBoundSchema.validatePartially (aXMLNode, FileHelper.getAsURLString (aXMLFile)).isValid ();
    }

    public static boolean readModifyAndWrite (@Nonnull final File aSchematronFile) throws Exception
    {
      final PSSchema aSchema = new PSReader (new FileSystemResource (aSchematronFile)).readSchema ();
      final PSTitle aTitle = new PSTitle ();
      aTitle.addText ("Created by ph-schematron");
      aSchema.setTitle (aTitle);
      return MicroWriter.writeToFile (aSchema.getAsMicroElement (), aSchematronFile).isSuccess ();
    }
  }

  private static final Logger LOGGER = LoggerFactory.getLogger (Issue016Test.class);

  @Test
  public void testIssue16 () throws Exception
  {
    final File schematronFile = new ClassPathResource ("issues/github16/sample_schematron.sch").getAsFile ();
    final File xmlFile = new ClassPathResource ("issues/github16/test.xml").getAsFile ();
    final SchematronOutputType outputType = SchematronUtil.validateXMLViaXSLTSchematronFull (schematronFile, xmlFile);
    assertNotNull (outputType);

    final List <SVRLSuccessfulReport> succeededList = SVRLHelper.getAllSuccessfulReports (outputType);
    for (final SVRLSuccessfulReport succeededReport : succeededList)
    {
      LOGGER.info ("Report Test: " + succeededReport.getTest ());
    }

    int i = 1;
    final List <SVRLFailedAssert> aFailedList = SVRLHelper.getAllFailedAssertions (outputType);
    for (final SVRLFailedAssert failedAssert : aFailedList)
    {
      LOGGER.info (i++ + ". Location:" + failedAssert.getLocation ());
      LOGGER.info ("Test: " + failedAssert.getTest ());
      LOGGER.info ("Text: " + failedAssert.getText ());

      final List <DiagnosticReference> diagnisticReferences = failedAssert.getDiagnisticReferences ();
      for (final DiagnosticReference diagnisticRef : diagnisticReferences)
      {
        LOGGER.info ("Diag ref: " + diagnisticRef.getDiagnostic ());
        LOGGER.info ("Diag text: " + diagnisticRef.getContentAtIndex (0));
      }
    }

    if (aFailedList.isEmpty ())
    {
      LOGGER.info ("PASS");
    }
    else
    {
      LOGGER.info ("FAIL");
    }
  }
}
