/*
 * Copyright (C) 2014-2026 Philip Helger (www.helger.com)
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

import java.nio.charset.StandardCharsets;

import org.junit.Test;

import com.helger.io.resource.IReadableResource;
import com.helger.io.resource.inmemory.ReadableResourceByteArray;
import com.helger.schematron.pure.errorhandler.CollectingPSErrorHandler;
import com.helger.schematron.pure.model.PSLet;
import com.helger.schematron.pure.model.PSSchema;
import com.helger.schematron.testfiles.SchematronTestHelper;
import com.helger.xml.microdom.IMicroElement;
import com.helger.xml.microdom.serialize.MicroWriter;

/**
 * Test class for class {@link PSSchema} and {@link PSReader}.
 *
 * @author Philip Helger
 */
public final class PSReaderTest
{
  @Test
  public void testReadAll () throws Exception
  {
    for (final IReadableResource aRes : SchematronTestHelper.getAllValidSchematronFiles ())
    {
      final PSReader aReader = new PSReader (aRes);

      // Parse the schema
      final PSSchema aSchema1 = aReader.readSchema ();
      assertNotNull (aSchema1);
      final CollectingPSErrorHandler aLogger = new CollectingPSErrorHandler ();
      assertTrue (aRes.getPath (), aSchema1.isValid (aLogger));
      assertTrue (aLogger.isEmpty ());

      // Convert back to XML
      final IMicroElement e1 = aSchema1.getAsMicroElement ();
      final String sXML1 = MicroWriter.getNodeAsString (e1);

      // Re-read the created XML and re-create it
      final PSSchema aSchema2 = aReader.readSchemaFromXML (e1);
      final IMicroElement e2 = aSchema2.getAsMicroElement ();
      final String sXML2 = MicroWriter.getNodeAsString (e2);

      // Originally created XML and re-created-written XML must match
      assertEquals (sXML1, sXML2);
    }
  }

  /**
   * Per ISO 19757-3 §5.4.4, if a {@code <let>} has no {@code value} attribute its expression
   * comes from the element content. This is the positive case for that path (see GitHub
   * issue #189) — a plain XPath expression inside the body.
   */
  @Test
  public void testReadLetWithBodyValue () throws Exception
  {
    final String sSchema = "<?xml version='1.0' encoding='UTF-8'?>\n" +
                           "<iso:schema xmlns:iso='http://purl.oclc.org/dsdl/schematron'>\n" +
                           "  <iso:pattern>\n" +
                           "    <iso:rule context='/root'>\n" +
                           "      <iso:let name='cnt'>count(item)</iso:let>\n" +
                           "      <iso:assert test='$cnt &gt; 0'>at least one item</iso:assert>\n" +
                           "    </iso:rule>\n" +
                           "  </iso:pattern>\n" +
                           "</iso:schema>";

    final PSReader aReader = new PSReader (new ReadableResourceByteArray (sSchema.getBytes (StandardCharsets.UTF_8)));
    final PSSchema aSchema = aReader.readSchema ();
    assertNotNull (aSchema);

    final CollectingPSErrorHandler aLogger = new CollectingPSErrorHandler ();
    assertTrue ("Schema should be valid; errors: " + aLogger.getErrorList (), aSchema.isValid (aLogger));

    // The <let> must have picked up the body text as its value
    final PSLet aLet = aSchema.getAllPatterns ().get (0).getAllRules ().get (0).getAllLets ().get (0);
    assertEquals ("cnt", aLet.getName ());
    assertEquals ("count(item)", aLet.getValue ());
  }
}
