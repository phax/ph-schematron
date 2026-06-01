/*
 * Copyright (C) 2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.purexslt.xslt;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.StringWriter;
import java.nio.charset.StandardCharsets;

import org.junit.Test;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import com.helger.base.state.ESuccess;
import com.helger.io.resource.FileSystemResource;

/**
 * Tests for {@link SchematronToXsltConverter}: same generated stylesheet must come out across all
 * output sinks ({@link Document}, String, {@link java.io.OutputStream}, {@link java.io.Writer},
 * {@link File}).
 *
 * @author Philip Helger
 */
public final class SchematronToXsltConverterTest
{
  private static final File SCH = new File ("src/test/resources/external/issues/github137/schematron.sch");

  @Test
  public void testAsDocument () throws Exception
  {
    final Document aDoc = SchematronToXsltConverter.fromResource (new FileSystemResource (SCH)).getAsDocument ();
    assertNotNull (aDoc);
    final Element aRoot = aDoc.getDocumentElement ();
    assertNotNull (aRoot);
    assertEquals (XsltStylesheetGenerator.XSLT_NS, aRoot.getNamespaceURI ());
    assertEquals ("stylesheet", aRoot.getLocalName ());
    assertEquals (EXsltVersion.DEFAULT.getVersion (), aRoot.getAttribute ("version"));
    // At least one <xsl:template> for the rule context
    final NodeList aTemplates = aRoot.getElementsByTagNameNS (XsltStylesheetGenerator.XSLT_NS, "template");
    assertTrue ("expected at least one xsl:template", aTemplates.getLength () > 0);
  }

  @Test
  public void testAsStringContainsKeyMarkers () throws Exception
  {
    final String s = SchematronToXsltConverter.fromResource (new FileSystemResource (SCH)).getAsString ();
    assertTrue ("expected xsl:stylesheet root, got:\n" + s, s.contains ("<xsl:stylesheet"));
    assertTrue ("expected version=\"3.0\", got:\n" + s, s.contains ("version=\"3.0\""));
    // The github137 schema's rule context "tag1" must appear as a template match
    assertTrue ("expected template match='tag1' for the rule context, got:\n" + s,
                s.contains ("match=\"tag1\""));
  }

  @Test
  public void testOutputStreamMatchesStringForm () throws Exception
  {
    final String sExpected = SchematronToXsltConverter.fromResource (new FileSystemResource (SCH)).getAsString ();
    final ByteArrayOutputStream aOS = new ByteArrayOutputStream ();
    final ESuccess ret = SchematronToXsltConverter.fromResource (new FileSystemResource (SCH)).writeTo (aOS);
    assertEquals (ESuccess.SUCCESS, ret);
    assertEquals (sExpected, aOS.toString (StandardCharsets.UTF_8));
  }

  @Test
  public void testWriterMatchesStringForm () throws Exception
  {
    final String sExpected = SchematronToXsltConverter.fromResource (new FileSystemResource (SCH)).getAsString ();
    final StringWriter aSW = new StringWriter ();
    final ESuccess ret = SchematronToXsltConverter.fromResource (new FileSystemResource (SCH)).writeTo (aSW);
    assertEquals (ESuccess.SUCCESS, ret);
    assertEquals (sExpected, aSW.toString ());
  }

  @Test
  public void testXslt2VersionAttribute () throws Exception
  {
    final String s = SchematronToXsltConverter.fromResource (new FileSystemResource (SCH))
                                               .setXsltVersion (EXsltVersion.XSLT_2_0)
                                               .getAsString ();
    assertTrue ("expected version=\"2.0\", got:\n" + s, s.contains ("version=\"2.0\""));
  }

  @Test
  public void testPreprocessExpandsAbstractPatterns () throws Exception
  {
    final File aAbstractSch = new File ("src/test/resources/external/abstract-pattern/schematron.sch");
    final String sWith = SchematronToXsltConverter.fromResource (new FileSystemResource (aAbstractSch))
                                                   .setPreprocess (true)
                                                   .getAsString ();
    final String sWithout = SchematronToXsltConverter.fromResource (new FileSystemResource (aAbstractSch))
                                                      .setPreprocess (false)
                                                      .getAsString ();
    // With preprocessing the abstract pattern expands to 2 concrete patterns -> bookIsbn + authorName
    // contexts (book + author) are present as xsl:template @match. Without preprocessing the
    // abstract pattern is skipped (logged WARN by the generator), so neither template appears.
    assertTrue ("preprocess=true should expand to author rule context, got:\n" + sWith,
                sWith.contains ("match=\"author\""));
    assertTrue ("preprocess=false should NOT expand the abstract pattern, found author template in:\n" + sWithout,
                !sWithout.contains ("match=\"author\""));
  }
}
