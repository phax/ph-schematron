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
package com.helger.schematron.pure.exchange;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.io.File;
import java.nio.charset.StandardCharsets;

import javax.xml.XMLConstants;

import org.junit.Test;

import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.io.resource.inmemory.ReadableResourceString;
import com.helger.schematron.CSchematron;
import com.helger.schematron.pure.errorhandler.CollectingPSErrorHandler;
import com.helger.schematron.pure.model.PSSchema;
import com.helger.schematron.testfiles.SchematronTestHelper;
import com.helger.xml.namespace.MapBasedNamespaceContext;
import com.helger.xml.serialize.write.XMLWriterSettings;

/**
 * Test class for class {@link PSSchema} and {@link PSReader} and
 * {@link PSWriter}.
 *
 * @author Philip Helger
 */
public final class PSWriterTest
{
  @Test
  public void testReadAll () throws Exception
  {
    final PSWriter aWriter = new PSWriter ();

    for (final IReadableResource aRes : SchematronTestHelper.getAllValidSchematronFiles ())
    {
      // Parse the schema
      final PSSchema aSchema1 = new PSReader (aRes).readSchema ();
      assertNotNull (aSchema1);
      final CollectingPSErrorHandler aLogger = new CollectingPSErrorHandler ();
      assertTrue (aRes.getPath (), aSchema1.isValid (aLogger));
      assertTrue (aLogger.isEmpty ());

      // Convert back to XML
      final String sXML1 = aWriter.getXMLStringNotNull (aSchema1);

      // Re-read the created XML and re-create it
      final PSSchema aSchema2 = new PSReader (new ReadableResourceString (sXML1, StandardCharsets.UTF_8)).readSchema ();
      final String sXML2 = aWriter.getXMLStringNotNull (aSchema2);

      // Originally created XML and re-created-written XML must match
      assertEquals (sXML1, sXML2);
    }
  }

  @Test
  public void testWriteWithNamespacePrefix () throws SchematronReadException
  {
    final IReadableResource aRes = SchematronTestHelper.getAllValidSchematronFiles ().getFirst ();
    // Read existing Schematron
    final PSSchema aSchema = new PSReader (aRes).readSchema ();

    // Create the XML namespace context
    final MapBasedNamespaceContext aNSCtx = PSWriterSettings.createNamespaceMapping (aSchema);
    aNSCtx.removeMapping (XMLConstants.DEFAULT_NS_PREFIX);
    aNSCtx.addMapping ("sch", CSchematron.NAMESPACE_SCHEMATRON);

    // Create the PSWriter settings
    final PSWriterSettings aPSWS = new PSWriterSettings ();
    aPSWS.setXMLWriterSettings (new XMLWriterSettings ().setNamespaceContext (aNSCtx).setPutNamespaceContextPrefixesInRoot (true));

    // Write the Schematron
    new PSWriter (aPSWS).writeToFile (aSchema, new File ("target/test-with-nsprefix.xml"));
  }
}
