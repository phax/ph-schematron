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

import java.io.File;
import java.io.StringReader;
import java.nio.charset.StandardCharsets;

import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamSource;

import org.jspecify.annotations.NonNull;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.io.resource.FileSystemResource;
import com.helger.io.resource.inmemory.ReadableResourceString;
import com.helger.schematron.exchange.PSReader;
import com.helger.schematron.model.PSSchema;
import com.helger.schematron.saxon.SaxonLocationFunctions;
import com.helger.schematron.saxon.SchematronProcessorFactory;
import com.helger.schematron.svrl.CSVRL;
import com.helger.xml.XMLFactory;
import com.helger.xml.serialize.write.XMLWriter;
import com.helger.xml.serialize.write.XMLWriterSettings;

import net.sf.saxon.s9api.DOMDestination;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.XdmNode;
import net.sf.saxon.s9api.XsltExecutable;

public final class PureXsltStylesheetGeneratorTest
{
  private static final Logger LOGGER = LoggerFactory.getLogger (PureXsltStylesheetGeneratorTest.class);

  /**
   * Same named siblings in no namespace, in the default namespace and with two prefixes for the same
   * namespace, attributes with and without namespace, text, comments and processing instructions.
   */
  private static final String XML = "<?xml version='1.0' encoding='UTF-8'?>" +
                                    "<root xmlns:a='urn:a' xmlns:b='urn:a' xmlns:c='urn:c'>" +
                                    "<item id='1'>t1<!--c1--><?pi x?>t2</item>" +
                                    "<a:item a:id='2'/>" +
                                    "<item xmlns='urn:a'/>" +
                                    "<b:item/>" +
                                    "<item/>" +
                                    "<c:item c:id='3' id='4'>t3<?pi y?><?other z?><!--c2--><item/><item/></c:item>" +
                                    "<other/>" +
                                    "<item><a:item/><b:item/><item/></item>" +
                                    "</root>";

  private static final String SCH = "<?xml version='1.0' encoding='UTF-8'?>" +
                                    "<schema xmlns='http://purl.oclc.org/dsdl/schematron' queryBinding='xslt2'>" +
                                    "<ns prefix='a' uri='urn:a'/>" +
                                    "<ns prefix='c' uri='urn:c'/>" +
                                    "<pattern>" +
                                    "<rule context='*'><report test='true()'>element</report></rule>" +
                                    "</pattern>" +
                                    "<pattern>" +
                                    "<rule context='@*'><report test='true()'>attribute</report></rule>" +
                                    "</pattern>" +
                                    "</schema>";

  @Test
  public void testDumpGeneratedXsltForGithub137 () throws Exception
  {
    final FileSystemResource aRes = new FileSystemResource (new File ("src/test/resources/external/issues/github137/schematron.sch"));
    final PSSchema aSchema = new PSReader (aRes).readSchema ();
    assertNotNull (aSchema);
    final Document aDoc = PureXsltStylesheetGenerator.generate (aSchema);
    assertNotNull (aDoc);
    LOGGER.info ("Generated XSLT for github137:\n" +
                 XMLWriter.getNodeAsString (aDoc, new XMLWriterSettings ().setUseExistingNamespaceDeclarations (true)));
  }

  @Test
  public void testDumpGeneratedXsltForXslFunction () throws Exception
  {
    final FileSystemResource aRes = new FileSystemResource (new File ("src/test/resources/external/xsl-function/schematron.sch"));
    final PSSchema aSchema = new PSReader (aRes).readSchema ();
    assertNotNull (aSchema);
    final Document aDoc = PureXsltStylesheetGenerator.generate (aSchema);
    assertNotNull (aDoc);
    LOGGER.info ("Generated XSLT for xsl-function:\n" +
                 XMLWriter.getNodeAsString (aDoc, new XMLWriterSettings ().setUseExistingNamespaceDeclarations (true)));
  }

  @NonNull
  private static PSSchema _readGithub137 () throws Exception
  {
    final FileSystemResource aRes = new FileSystemResource (new File ("src/test/resources/external/issues/github137/schematron.sch"));
    final PSSchema aSchema = new PSReader (aRes).readSchema ();
    assertNotNull (aSchema);
    return aSchema;
  }

  @NonNull
  private static String _firstLocationAvt (@NonNull final Document aDoc)
  {
    // Find the single <svrl:failed-assert> and read its @location attribute value
    final NodeList aList = aDoc.getElementsByTagNameNS (CSVRL.SVRL_NAMESPACE_URI, "failed-assert");
    assertTrue ("Expected at least one svrl:failed-assert", aList.getLength () > 0);
    return ((Element) aList.item (0)).getAttribute ("location");
  }

  @Test
  public void testGenerateXslt30UsesFnPath () throws Exception
  {
    final Document aDoc = PureXsltStylesheetGenerator.generate (_readGithub137 (), null, EPureXsltVersion.XSLT_3_0);
    assertNotNull (aDoc);

    final Element aStylesheet = aDoc.getDocumentElement ();
    assertEquals ("3.0", aStylesheet.getAttribute ("version"));

    // XSLT 3.0 uses the built-in fn:path() and must NOT emit the phsch:path helper function
    assertEquals (0, aDoc.getElementsByTagNameNS (PureXsltStylesheetGenerator.XSLT_NS, "function").getLength ());
    assertEquals ("{path(.)}", _firstLocationAvt (aDoc));
  }

  @Test
  public void testGenerateXslt20EmitsPathHelper () throws Exception
  {
    final Document aDoc = PureXsltStylesheetGenerator.generate (_readGithub137 (), null, EPureXsltVersion.XSLT_2_0);
    assertNotNull (aDoc);
    LOGGER.info ("Generated XSLT 2.0 for github137:\n" +
                 XMLWriter.getNodeAsString (aDoc, new XMLWriterSettings ().setUseExistingNamespaceDeclarations (true)));

    final Element aStylesheet = aDoc.getDocumentElement ();
    assertEquals ("2.0", aStylesheet.getAttribute ("version"));

    // XSLT 2.0 lacks fn:path() -> exactly one phsch:path helper function must be emitted
    final NodeList aFuncs = aDoc.getElementsByTagNameNS (PureXsltStylesheetGenerator.XSLT_NS, "function");
    assertEquals (1, aFuncs.getLength ());
    assertEquals (PureXsltStylesheetGenerator.PATH_FUNC_PREFIX + ":path",
                  ((Element) aFuncs.item (0)).getAttribute ("name"));

    // and the location attribute must call it
    assertEquals ("{" + PureXsltStylesheetGenerator.PATH_FUNC_PREFIX + ":path(.)}", _firstLocationAvt (aDoc));
  }

  @Test
  public void testGenerateXslt10EmitsPathModeTemplates () throws Exception
  {
    final Document aDoc = PureXsltStylesheetGenerator.generate (_readGithub137 (), null, EPureXsltVersion.XSLT_1_0);
    assertNotNull (aDoc);
    LOGGER.info ("Generated XSLT 1.0 for github137:\n" +
                 XMLWriter.getNodeAsString (aDoc, new XMLWriterSettings ().setUseExistingNamespaceDeclarations (true)));

    final Element aStylesheet = aDoc.getDocumentElement ();
    assertEquals ("1.0", aStylesheet.getAttribute ("version"));

    // XSLT 1.0 has no xsl:function
    assertEquals (0, aDoc.getElementsByTagNameNS (PureXsltStylesheetGenerator.XSLT_NS, "function").getLength ());

    // Two recursive phsch-path mode templates (element + attribute) must be emitted
    int nPathModeTemplates = 0;
    final NodeList aTemplates = aDoc.getElementsByTagNameNS (PureXsltStylesheetGenerator.XSLT_NS, "template");
    for (int i = 0; i < aTemplates.getLength (); ++i)
      if (PureXsltStylesheetGenerator.PATH_MODE.equals (((Element) aTemplates.item (i)).getAttribute ("mode")))
        nPathModeTemplates++;
    assertEquals (2, nPathModeTemplates);

    // The failed-assert must NOT carry a literal @location AVT; it is computed via <xsl:attribute>
    final NodeList aFA = aDoc.getElementsByTagNameNS (CSVRL.SVRL_NAMESPACE_URI, "failed-assert");
    assertTrue (aFA.getLength () > 0);
    final Element aFailedAssert = (Element) aFA.item (0);
    assertEquals ("", aFailedAssert.getAttribute ("location"));

    // ... namely an <xsl:attribute name="location"> child that applies the phsch-path mode
    boolean bFoundLocationAttr = false;
    final NodeList aAttrs = aFailedAssert.getElementsByTagNameNS (PureXsltStylesheetGenerator.XSLT_NS, "attribute");
    for (int i = 0; i < aAttrs.getLength (); ++i)
    {
      final Element aAttr = (Element) aAttrs.item (i);
      if ("location".equals (aAttr.getAttribute ("name")))
      {
        bFoundLocationAttr = true;
        final NodeList aApply = aAttr.getElementsByTagNameNS (PureXsltStylesheetGenerator.XSLT_NS, "apply-templates");
        assertEquals (1, aApply.getLength ());
        assertEquals (PureXsltStylesheetGenerator.PATH_MODE, ((Element) aApply.item (0)).getAttribute ("mode"));
      }
    }
    assertTrue ("expected an <xsl:attribute name='location'> in the failed-assert", bFoundLocationAttr);
  }

  @NonNull
  private static ICommonsList <String> _getLocations (@NonNull final PSSchema aSchema,
                                                       @NonNull final EPureXsltVersion eVersion,
                                                       final boolean bNativeLocation) throws Exception
  {
    final Processor aProcessor = SchematronProcessorFactory.getDefault ();
    SaxonLocationFunctions.registerIfMissing (aProcessor);

    final Document aXslt = PureXsltStylesheetGenerator.generate (aSchema, null, eVersion, bNativeLocation);
    final XsltExecutable aExecutable = aProcessor.newXsltCompiler ().compile (new DOMSource (aXslt));
    final XdmNode aInput = aProcessor.newDocumentBuilder ().build (new StreamSource (new StringReader (XML)));
    final Document aSVRL = XMLFactory.newDocument ();
    aExecutable.load30 ().applyTemplates (aInput, new DOMDestination (aSVRL));

    final ICommonsList <String> ret = new CommonsArrayList <> ();
    final NodeList aReports = aSVRL.getElementsByTagNameNS (CSVRL.SVRL_NAMESPACE_URI, "successful-report");
    for (int i = 0; i < aReports.getLength (); ++i)
      ret.add (((Element) aReports.item (i)).getAttribute ("location"));
    return ret;
  }

  @Test
  public void testNativeLocationEqualsPortable () throws Exception
  {
    final PSSchema aSchema = new PSReader (new ReadableResourceString (SCH, StandardCharsets.UTF_8)).readSchema ();
    for (final EPureXsltVersion eVersion : EPureXsltVersion.values ())
    {
      final ICommonsList <String> aPortable = _getLocations (aSchema, eVersion, false);
      final ICommonsList <String> aNative = _getLocations (aSchema, eVersion, true);
      // 14 elements and 4 attributes
      assertEquals (eVersion.getID (), 18, aPortable.size ());
      assertEquals (eVersion.getID (), aPortable, aNative);
    }
  }
}
