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
package com.helger.schematron.model;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.nio.charset.StandardCharsets;

import org.jspecify.annotations.NonNull;
import org.junit.Test;

import com.helger.base.lang.clazz.ClassHelper;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.io.resource.inmemory.ReadableResourceByteArray;
import com.helger.schematron.exchange.PSReader;

/**
 * Test class for class {@link PSForeignElementVisitor}.
 *
 * @author Philip Helger
 */
public final class PSForeignElementVisitorTest
{
  private static final String SCHEMA = "<?xml version='1.0' encoding='UTF-8'?>\n" +
                                       "<iso:schema xmlns:iso='http://purl.oclc.org/dsdl/schematron'\n" +
                                       "            xmlns:xsl='http://www.w3.org/1999/XSL/Transform'\n" +
                                       "            xmlns:foo='urn:foo'>\n" +
                                       "  <iso:title>Title <iso:dir><foo:ext/></iso:dir></iso:title>\n" +
                                       "  <xsl:function name='local'/>\n" +
                                       "  <iso:p>Intro <foo:ext/></iso:p>\n" +
                                       "  <iso:phase id='ph1'>\n" +
                                       "    <foo:ext/>\n" +
                                       "    <iso:active pattern='pat1'><foo:ext/></iso:active>\n" +
                                       "  </iso:phase>\n" +
                                       "  <iso:pattern id='pat1'>\n" +
                                       "    <foo:ext/>\n" +
                                       "    <iso:rule context='/root'>\n" +
                                       "      <xsl:variable name='v' select='1'/>\n" +
                                       "      <iso:assert test='true()' diagnostics='d1'>Text <foo:ext/> and <iso:emph>emphasized <foo:ext/></iso:emph></iso:assert>\n" +
                                       "    </iso:rule>\n" +
                                       "  </iso:pattern>\n" +
                                       "  <iso:diagnostics>\n" +
                                       "    <foo:ext/>\n" +
                                       "    <iso:diagnostic id='d1'>Diagnostic <foo:ext/></iso:diagnostic>\n" +
                                       "  </iso:diagnostics>\n" +
                                       "</iso:schema>";

  /**
   * @param sSchema
   *        The Schematron to be read. May not be <code>null</code>.
   * @return A list of "OwnerClassName:ForeignElementName" entries, in the order they were visited.
   * @throws Exception
   *         in case of error
   */
  @NonNull
  private static ICommonsList <String> _getAllForeignElements (@NonNull final String sSchema) throws Exception
  {
    final PSReader aReader = new PSReader (new ReadableResourceByteArray (sSchema.getBytes (StandardCharsets.UTF_8)));
    final PSSchema aRealSchema = aReader.readSchema ();
    assertNotNull (aRealSchema);

    final ICommonsList <String> ret = new CommonsArrayList <> ();
    PSForeignElementVisitor.forEachForeignElement (aRealSchema,
                                                   (aOwner, aForeignElement) -> ret.add (ClassHelper.getClassLocalName (aOwner) +
                                                                                         ":" +
                                                                                         aForeignElement.getTagName ()));
    return ret;
  }

  @Test
  public void testAllForeignElements () throws Exception
  {
    final ICommonsList <String> aAll = _getAllForeignElements (SCHEMA);

    // Every level that may contain foreign elements must be present
    assertEquals (new CommonsArrayList <> ("PSSchema:function",
                                           "PSDir:ext",
                                           "PSP:ext",
                                           "PSPhase:ext",
                                           "PSActive:ext",
                                           "PSPattern:ext",
                                           "PSRule:variable",
                                           "PSAssertReport:ext",
                                           "PSEmph:ext",
                                           "PSDiagnostics:ext",
                                           "PSDiagnostic:ext"),
                  aAll);
  }

  @Test
  public void testNoForeignElements () throws Exception
  {
    final String sSchema = "<?xml version='1.0' encoding='UTF-8'?>\n" +
                           "<iso:schema xmlns:iso='http://purl.oclc.org/dsdl/schematron'>\n" +
                           "  <iso:pattern>\n" +
                           "    <iso:rule context='/root'>\n" +
                           "      <iso:assert test='true()'>Text</iso:assert>\n" +
                           "    </iso:rule>\n" +
                           "  </iso:pattern>\n" +
                           "</iso:schema>";
    assertTrue (_getAllForeignElements (sSchema).isEmpty ());
  }
}
