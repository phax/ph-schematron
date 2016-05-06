package com.helger.schematron.supplemantery;

import java.io.File;
import java.util.List;

import javax.annotation.Nonnull;
import javax.xml.transform.stream.StreamSource;

import org.junit.Test;
import org.oclc.purl.dsdl.svrl.DiagnosticReference;
import org.oclc.purl.dsdl.svrl.SchematronOutputType;
import org.w3c.dom.Document;

import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.FileSystemResource;
import com.helger.commons.microdom.serialize.MicroWriter;
import com.helger.commons.xml.serialize.read.DOMReader;
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
import com.helger.schematron.svrl.SVRLFailedAssert;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.SVRLSuccessfulReport;
import com.helger.schematron.xslt.SchematronResourceSCH;

public final class Issue16Test
{
  public static final class SchematronUtil
  {
    public static boolean validateXMLViaXSLTSchematron (@Nonnull final File aSchematronFile,
                                                        @Nonnull final File aXMLFile) throws Exception
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

    public static boolean validateXMLViaPureSchematron (@Nonnull final File aSchematronFile,
                                                        @Nonnull final File aXMLFile) throws Exception
    {
      final ISchematronResource aResPure = SchematronResourcePure.fromFile (aSchematronFile);
      if (!aResPure.isValidSchematron ())
        throw new IllegalArgumentException ("Invalid Schematron!");
      return aResPure.getSchematronValidity (new StreamSource (aXMLFile)).isValid ();
    }

    public static boolean validateXMLViaPureSchematron2 (@Nonnull final File aSchematronFile,
                                                         @Nonnull final File aXMLFile) throws Exception
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
      final IPSBoundSchema aBoundSchema = aQueryBinding.bind (aPreprocessedSchema, null, null, null, null);
      // Read the XML file
      final Document aXMLNode = DOMReader.readXMLDOM (aXMLFile);
      if (aXMLNode == null)
        return false;
      // Perform the validation
      return aBoundSchema.validatePartially (aXMLNode).isValid ();
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

  @Test
  public void testIssue16 () throws Exception
  {
    final File schematronFile = new ClassPathResource ("issues/github16/sample_schematron.sch").getAsFile ();
    final File xmlFile = new ClassPathResource ("issues/github16/test.xml").getAsFile ();
    final SchematronOutputType outputType = SchematronUtil.validateXMLViaXSLTSchematronFull (schematronFile, xmlFile);
    if (outputType == null)
      throw new Exception ("SchematronOutputType null");

    final List <SVRLSuccessfulReport> succeededList = SVRLHelper.getAllSuccessfulReports (outputType);
    for (final SVRLSuccessfulReport succeededReport : succeededList)
    {
      System.out.println (succeededReport.getTest ());
    }

    int i = 1;
    final List <SVRLFailedAssert> failedList = SVRLHelper.getAllFailedAssertions (outputType);
    for (final SVRLFailedAssert failedAssert : failedList)
    {
      System.out.println (i++ + ". Location:" + failedAssert.getLocation ());
      System.out.println ("Test: " + failedAssert.getTest ());
      System.out.println ("Text: " + failedAssert.getText ());

      final List <DiagnosticReference> diagnisticReferences = failedAssert.getDiagnisticReferences ();
      for (final DiagnosticReference diagnisticRef : diagnisticReferences)
      {
        System.out.println ("Diag ref: " + diagnisticRef.getDiagnostic ());
        System.out.println ("Diag text: " + diagnisticRef.getText ());
      }
    }

    if (failedList.isEmpty ())
    {
      System.out.println ("PASS");
    }
    else
    {
      System.out.println ("FAIL");
    }
  }
}
