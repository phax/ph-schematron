/**
 * Copyright (C) 2014-2015 Philip Helger (www.helger.com)
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
package com.helger.schematron.pure.preprocess;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.io.File;

import org.junit.Test;

import com.helger.commons.io.file.FilenameHelper;
import com.helger.commons.io.file.SimpleFileIO;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.microdom.IMicroDocument;
import com.helger.commons.microdom.serialize.MicroWriter;
import com.helger.commons.xml.serialize.write.XMLWriterSettings;
import com.helger.schematron.SchematronException;
import com.helger.schematron.SchematronHelper;
import com.helger.schematron.pure.binding.xpath.PSXPathQueryBinding;
import com.helger.schematron.pure.errorhandler.CollectingPSErrorHandler;
import com.helger.schematron.pure.errorhandler.DoNothingPSErrorHandler;
import com.helger.schematron.pure.exchange.PSReader;
import com.helger.schematron.pure.model.PSSchema;
import com.helger.schematrontest.SchematronTestHelper;

/**
 * Test class for class {@link PSPreprocessor}.
 *
 * @author Philip Helger
 */
public final class PSPreprocessorTest
{
  @Test
  public void testBasic () throws Exception
  {
    final PSPreprocessor aPreprocessor = new PSPreprocessor (PSXPathQueryBinding.getInstance ());
    for (final IReadableResource aRes : SchematronTestHelper.getAllValidSchematronFiles ())
    {
      // Resolve all includes
      final IMicroDocument aDoc = SchematronHelper.getWithResolvedSchematronIncludes (aRes);
      assertNotNull (aDoc);

      // Read to domain object
      final PSReader aReader = new PSReader (aRes);
      final PSSchema aSchema = aReader.readSchemaFromXML (aDoc.getDocumentElement ());
      assertNotNull (aSchema);

      // Ensure the schema is valid
      final CollectingPSErrorHandler aErrHdl = new CollectingPSErrorHandler ();
      assertTrue (aRes.getPath (), aSchema.isValid (aErrHdl));
      assertTrue (aErrHdl.isEmpty ());

      // Convert to minified schema if not-yet minimal
      final PSSchema aPreprocessedSchema = aPreprocessor.getAsMinimalSchema (aSchema);
      assertNotNull (aPreprocessedSchema);

      if (false)
      {
        final String sXML = MicroWriter.getXMLString (aPreprocessedSchema.getAsMicroElement ());
        SimpleFileIO.writeFile (new File ("test-minified", FilenameHelper.getWithoutPath (aRes.getPath ()) +
                                                           ".min-pure.sch"),
                                sXML,
                                XMLWriterSettings.DEFAULT_XML_CHARSET_OBJ);
      }

      // Ensure it is still valid and minimal
      assertTrue (aRes.getPath (), aPreprocessedSchema.isValid (aErrHdl));
      assertTrue (aRes.getPath (), aPreprocessedSchema.isMinimal ());
    }
  }

  @Test
  public void testWithTitle () throws SchematronException
  {
    final PSPreprocessor aPreprocessor = new PSPreprocessor (PSXPathQueryBinding.getInstance ()).setKeepTitles (true)
                                                                                                .setKeepDiagnostics (true);
    final IReadableResource aRes = new ClassPathResource ("test-sch/example-3-5.sch");
    final IMicroDocument aDoc = SchematronHelper.getWithResolvedSchematronIncludes (aRes);
    final PSReader aReader = new PSReader (aRes);
    final PSSchema aSchema = aReader.readSchemaFromXML (aDoc.getDocumentElement ());
    final PSSchema aPreprocessedSchema = aPreprocessor.getAsPreprocessedSchema (aSchema);
    assertNotNull (aPreprocessedSchema);
    assertTrue (aPreprocessedSchema.isValid (DoNothingPSErrorHandler.getInstance ()));
    // Because titles are not in minimal mode
    assertFalse (aPreprocessedSchema.isMinimal ());
  }
}
