/*
 * Copyright (C) 2015-2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.exchange;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.junit.Test;

import com.helger.annotation.Nonempty;
import com.helger.collection.commons.CommonsHashMap;
import com.helger.collection.commons.ICommonsList;
import com.helger.collection.commons.ICommonsMap;
import com.helger.io.file.FilenameHelper;
import com.helger.io.resource.IReadableResource;
import com.helger.io.resource.inmemory.ReadableResourceByteArray;
import com.helger.schematron.errorhandler.CollectingPSErrorHandler;
import com.helger.schematron.model.PSLet;
import com.helger.schematron.model.PSP;
import com.helger.schematron.model.PSSchema;
import com.helger.schematron.model.PSValueOf;
import com.helger.schematron.resolve.ISchematronIncludeResolver;
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
   * Per ISO 19757-3 §5.4.4, if a {@code <let>} has no {@code value} attribute its expression comes
   * from the element content. This is the positive case for that path (see GitHub issue #189) — a
   * plain XPath expression inside the body.
   *
   * @throws Exception
   *         in case of error
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

  @Test
  public void testReadValueOfInP () throws Exception
  {
    // Not permitted by ISO Schematron, but evaluated by the ISO Schematron XSLT
    final String sSchema = "<?xml version='1.0' encoding='UTF-8'?>\n" +
                           "<iso:schema xmlns:iso='http://purl.oclc.org/dsdl/schematron'>\n" +
                           "  <iso:p>Type '<iso:value-of select='$type'/>'</iso:p>\n" +
                           "  <iso:let name='type' value='name(/*)'/>\n" +
                           "  <iso:pattern>\n" +
                           "    <iso:rule context='/root'>\n" +
                           "      <iso:assert test='item'>at least one item</iso:assert>\n" +
                           "    </iso:rule>\n" +
                           "  </iso:pattern>\n" +
                           "</iso:schema>";

    final CollectingPSErrorHandler aErrorHandler = new CollectingPSErrorHandler ();
    final PSReader aReader = new PSReader (new ReadableResourceByteArray (sSchema.getBytes (StandardCharsets.UTF_8)),
                                           aErrorHandler,
                                           null);
    final PSSchema aSchema = aReader.readSchema ();
    assertNotNull (aSchema);
    // One warning, no error
    assertEquals (aErrorHandler.getErrorList ().toString (), 1, aErrorHandler.getErrorList ().size ());
    assertFalse (aErrorHandler.getErrorList ().containsAtLeastOneError ());

    final PSP aP = aSchema.getAllStartPs ().get (0);
    final ICommonsList <Object> aContent = aP.getAllContentElements ();
    assertEquals (3, aContent.size ());
    assertEquals ("Type '", aContent.get (0));
    assertEquals ("$type", ((PSValueOf) aContent.get (1)).getSelect ());
    assertEquals ("'", aContent.get (2));

    // Written back as it was read
    assertTrue (MicroWriter.getNodeAsString (aP.getAsMicroElement ()).contains ("<value-of select=\"$type\""));
  }

  @NonNull
  private static ReadableResourceByteArray _createInMemoryResource (@NonNull final String sPath,
                                                                    @NonNull final String sContent)
  {
    final ReadableResourceByteArray ret = new ReadableResourceByteArray (sPath,
                                                                         sContent.getBytes (StandardCharsets.UTF_8));
    ret.setPath (sPath);
    return ret;
  }

  /**
   * In-memory resources have no URL, so relative includes in sub directories can only be resolved
   * with the resource that contains the include.
   *
   * @throws Exception
   *         on error
   */
  @Test
  public void testIncludeResolverWithBaseResource () throws Exception
  {
    final ICommonsMap <String, String> aFiles = new CommonsHashMap <> ();
    aFiles.put ("/main.sch",
                "<schema xmlns='http://purl.oclc.org/dsdl/schematron'>\n" +
                             "  <include href='rules/pattern.sch'/>\n" +
                             "</schema>");
    aFiles.put ("/rules/pattern.sch",
                "<pattern xmlns='http://purl.oclc.org/dsdl/schematron' id='p1'>\n" +
                                      "  <include href='rule.sch'/>\n" +
                                      "</pattern>");
    aFiles.put ("/rules/rule.sch",
                "<rule xmlns='http://purl.oclc.org/dsdl/schematron' context='/root'>\n" +
                                   "  <assert test='item'>at least one item</assert>\n" +
                                   "</rule>");

    final ISchematronIncludeResolver aResolver = new ISchematronIncludeResolver ()
    {
      @NonNull
      public IReadableResource getResolvedSchematronResource (@NonNull @Nonempty final String sHref) throws IOException
      {
        throw new IOException ("Base resource is required to resolve '" + sHref + "'");
      }

      @Override
      @NonNull
      public IReadableResource getResolvedSchematronResource (@NonNull @Nonempty final String sHref,
                                                              @Nullable final IReadableResource aBaseResource) throws IOException
      {
        assertNotNull (aBaseResource);
        final String sPath = FilenameHelper.getCleanPath (FilenameHelper.getPath (aBaseResource.getPath ()) + sHref);
        final String sContent = aFiles.get (sPath);
        if (sContent == null)
          throw new IOException ("Failed to resolve '" + sPath + "'");
        return _createInMemoryResource (sPath, sContent);
      }
    };

    final CollectingPSErrorHandler aErrorHandler = new CollectingPSErrorHandler ();
    final PSReader aReader = new PSReader (_createInMemoryResource ("/main.sch", aFiles.get ("/main.sch")),
                                           aErrorHandler,
                                           null).setSchematronIncludeResolver (aResolver);
    final PSSchema aSchema = aReader.readSchema ();
    assertNotNull (aSchema);
    assertTrue (aErrorHandler.getErrorList ().toString (), aErrorHandler.isEmpty ());
    assertEquals (1, aSchema.getPatternCount ());
    assertEquals ("p1", aSchema.getAllPatterns ().get (0).getID ());
    assertEquals (1, aSchema.getAllPatterns ().get (0).getRuleCount ());
    assertEquals ("/root", aSchema.getAllPatterns ().get (0).getAllRules ().get (0).getContext ());
  }
}
