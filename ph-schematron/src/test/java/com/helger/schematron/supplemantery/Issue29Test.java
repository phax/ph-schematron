/**
 * Copyright (C) 2014-2016 Philip Helger (www.helger.com)
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
package com.helger.schematron.supplemantery;

import java.io.File;

import javax.annotation.Nullable;
import javax.xml.transform.stream.StreamSource;

import org.oclc.purl.dsdl.svrl.SchematronOutputType;
import org.w3c.dom.Document;

import com.helger.commons.io.resource.FileSystemResource;
import com.helger.schematron.ISchematronResource;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.xslt.SchematronResourceSCH;

/**
 * Test code for issue #29
 *
 * @author Philip Helger
 */
public final class Issue29Test
{
  @Nullable
  static SchematronOutputType validateXmlUsingSchematron ()
  {
    final String samplePathToXMLFile = "";
    final String samplePathToSchematronFIle = "";
    // ...
    final File anXMLFile = new File (samplePathToXMLFile);
    final File aSchematronFile = new File (samplePathToSchematronFIle);
    SchematronOutputType ob = new SchematronOutputType ();
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
    return ob;
  }
}
