package com.helger.schematron.supplemantery;

import java.io.File;

import javax.annotation.Nullable;
import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;

import org.oclc.purl.dsdl.svrl.SchematronOutputType;
import org.w3c.dom.Document;

import com.helger.commons.io.resource.FileSystemResource;
import com.helger.schematron.ISchematronResource;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.xslt.SchematronResourceSCH;

public class Issue29Test
{
  @Nullable
  static SchematronOutputType validateXmlUsingSchematron (final Source pbsXml)
  {
    final String samplePathToXMLFile = "";
    final String samplePathToSchematronFIle = "";
    // ...
    final File anXMLFile = new File (samplePathToXMLFile);
    final File aSchematronFile = new File (samplePathToSchematronFIle);
    SchematronOutputType ob = new SchematronOutputType ();
    if (anXMLFile != null)
    {
      final ISchematronResource aResSCH = new SchematronResourceSCH (new FileSystemResource (aSchematronFile));
      if (!aResSCH.isValidSchematron ())
        throw new IllegalArgumentException ("Invalid Schematron!");
      try
      {
        final Document aDoc = aResSCH.applySchematronValidation (new StreamSource (anXMLFile));
        if (aDoc != null)
        {
          final SVRLMarshaller marshaller = new SVRLMarshaller ();
          marshaller.setClassLoader (SchematronOutputType.class.getClassLoader ());
          ob = marshaller.read (aDoc);
        }
      }
      catch (final Exception pE)
      {
        pE.printStackTrace ();
      }
    }
    return ob;
  }
}
