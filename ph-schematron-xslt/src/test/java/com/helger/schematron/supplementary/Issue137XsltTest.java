/*
 * Copyright (C) 2014-2023 Philip Helger (www.helger.com)
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
package com.helger.schematron.supplementary;

import static org.junit.Assert.assertNotNull;

import java.io.File;

import javax.annotation.Nonnull;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;

import org.junit.Ignore;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.commons.io.resource.FileSystemResource;
import com.helger.schematron.SchematronDebug;
import com.helger.schematron.saxon.SchematronTransformerFactory;
import com.helger.schematron.sch.SchematronResourceSCH;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.schematron.xslt.SchematronProviderXSLTPrebuild;
import com.helger.xml.serialize.write.XMLWriter;
import com.helger.xml.transform.DefaultTransformURIResolver;
import com.helger.xml.transform.StringStreamSource;
import com.helger.xml.transform.TransformSourceFactory;

public final class Issue137XsltTest
{
  private static final Logger LOGGER = LoggerFactory.getLogger (Issue137XsltTest.class);

  public static void validateAndProduceSVRL (@Nonnull final File aSchematron, final File aXML) throws Exception
  {
    if (false)
      SchematronDebug.setDebugMode (true);

    final SchematronResourceSCH aSCH = SchematronResourceSCH.fromFile (aSchematron);
    if (false)
      LOGGER.info (XMLWriter.getNodeAsString (aSCH.getXSLTProvider ().getXSLTDocument ()));

    // Perform validation
    final SchematronOutputType aSVRL = aSCH.applySchematronValidationToSVRL (new FileSystemResource (aXML));
    assertNotNull (aSVRL);
    if (true)
      LOGGER.info (new SVRLMarshaller ().getAsString (aSVRL));
  }

  @Test
  public void testIssue () throws Exception
  {
    validateAndProduceSVRL (new File ("src/test/resources/issues/github137/schematron.sch"),
                            new File ("src/test/resources/issues/github137/test.xml"));
  }

  @Ignore
  @Test
  public void testWithManualXslt () throws Exception
  {
    final String sXslt = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\r\n" +
                         "<stylesheet xmlns=\"http://www.w3.org/1999/XSL/Transform\" version=\"2.0\">\r\n" +
                         "<!--Implementers: please note that overriding process-prolog or process-root is \r\n" +
                         "    the preferred method for meta-stylesheets to use where possible. -->\r\n" +
                         "\r\n" +
                         "<param name=\"archiveDirParameter\" />\r\n" +
                         "  <param name=\"archiveNameParameter\" />\r\n" +
                         "  <param name=\"fileNameParameter\" />\r\n" +
                         "  <param name=\"fileDirParameter\" />\r\n" +
                         "  <variable name=\"document-uri\">\r\n" +
                         "    <value-of select=\"document-uri(/)\" />\r\n" +
                         "  </variable>\r\n" +
                         "\r\n" +
                         "<!--PHASES-->\r\n" +
                         "\r\n" +
                         "\r\n" +
                         "<!--PROLOG-->\r\n" +
                         "<output indent=\"yes\" method=\"xml\" omit-xml-declaration=\"no\" standalone=\"yes\" />\r\n" +
                         "\r\n" +
                         "<!--XSD TYPES FOR XSLT2-->\r\n" +
                         "\r\n" +
                         "\r\n" +
                         "<!--KEYS AND FUNCTIONS-->\r\n" +
                         "\r\n" +
                         "\r\n" +
                         "<!--DEFAULT RULES-->\r\n" +
                         "\r\n" +
                         "\r\n" +
                         "<!--MODE: SCHEMATRON-SELECT-FULL-PATH-->\r\n" +
                         "<!--This mode can be used to generate an ugly though full XPath for locators-->\r\n" +
                         "<template match=\"*\" mode=\"schematron-select-full-path\">\r\n" +
                         "    <apply-templates mode=\"schematron-get-full-path\" select=\".\" />\r\n" +
                         "  </template>\r\n" +
                         "\r\n" +
                         "<!--MODE: SCHEMATRON-FULL-PATH-->\r\n" +
                         "<!--This mode can be used to generate an ugly though full XPath for locators-->\r\n" +
                         "<template match=\"*\" mode=\"schematron-get-full-path\">\r\n" +
                         "    <apply-templates mode=\"schematron-get-full-path\" select=\"parent::*\" />\r\n" +
                         "    <text>/</text>\r\n" +
                         "    <choose>\r\n" +
                         "      <when test=\"namespace-uri()=''\">\r\n" +
                         "        <value-of select=\"name()\" />\r\n" +
                         "      </when>\r\n" +
                         "      <otherwise>\r\n" +
                         "        <text>*:</text>\r\n" +
                         "        <value-of select=\"local-name()\" />\r\n" +
                         "        <text>[namespace-uri()='</text>\r\n" +
                         "        <value-of select=\"namespace-uri()\" />\r\n" +
                         "        <text>']</text>\r\n" +
                         "      </otherwise>\r\n" +
                         "    </choose>\r\n" +
                         "    <variable name=\"preceding\" select=\"count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])\" />\r\n" +
                         "    <text>[</text>\r\n" +
                         "    <value-of select=\"1+ $preceding\" />\r\n" +
                         "    <text>]</text>\r\n" +
                         "  </template>\r\n" +
                         "  <template match=\"@*\" mode=\"schematron-get-full-path\">\r\n" +
                         "    <apply-templates mode=\"schematron-get-full-path\" select=\"parent::*\" />\r\n" +
                         "    <text>/</text>\r\n" +
                         "    <choose>\r\n" +
                         "      <when test=\"namespace-uri()=''\">@<value-of select=\"name()\" />\r\n" +
                         "</when>\r\n" +
                         "      <otherwise>\r\n" +
                         "        <text>@*[local-name()='</text>\r\n" +
                         "        <value-of select=\"local-name()\" />\r\n" +
                         "        <text>' and namespace-uri()='</text>\r\n" +
                         "        <value-of select=\"namespace-uri()\" />\r\n" +
                         "        <text>']</text>\r\n" +
                         "      </otherwise>\r\n" +
                         "    </choose>\r\n" +
                         "  </template>\r\n" +
                         "\r\n" +
                         "<!--MODE: SCHEMATRON-FULL-PATH-2-->\r\n" +
                         "<!--This mode can be used to generate prefixed XPath for humans-->\r\n" +
                         "<template match=\"node() | @*\" mode=\"schematron-get-full-path-2\">\r\n" +
                         "    <for-each select=\"ancestor-or-self::*\">\r\n" +
                         "      <text>/</text>\r\n" +
                         "      <value-of select=\"name(.)\" />\r\n" +
                         "      <if test=\"preceding-sibling::*[name(.)=name(current())]\">\r\n" +
                         "        <text>[</text>\r\n" +
                         "        <value-of select=\"count(preceding-sibling::*[name(.)=name(current())])+1\" />\r\n" +
                         "        <text>]</text>\r\n" +
                         "      </if>\r\n" +
                         "    </for-each>\r\n" +
                         "    <if test=\"not(self::*)\">\r\n" +
                         "      <text />/@<value-of select=\"name(.)\" />\r\n" +
                         "    </if>\r\n" +
                         "  </template>\r\n" +
                         "<!--MODE: SCHEMATRON-FULL-PATH-3-->\r\n" +
                         "<!--This mode can be used to generate prefixed XPath for humans \r\n" +
                         "  (Top-level element has index)-->\r\n" +
                         "\r\n" +
                         "<template match=\"node() | @*\" mode=\"schematron-get-full-path-3\">\r\n" +
                         "    <for-each select=\"ancestor-or-self::*\">\r\n" +
                         "      <text>/</text>\r\n" +
                         "      <value-of select=\"name(.)\" />\r\n" +
                         "      <if test=\"parent::*\">\r\n" +
                         "        <text>[</text>\r\n" +
                         "        <value-of select=\"count(preceding-sibling::*[name(.)=name(current())])+1\" />\r\n" +
                         "        <text>]</text>\r\n" +
                         "      </if>\r\n" +
                         "    </for-each>\r\n" +
                         "    <if test=\"not(self::*)\">\r\n" +
                         "      <text />/@<value-of select=\"name(.)\" />\r\n" +
                         "    </if>\r\n" +
                         "  </template>\r\n" +
                         "\r\n" +
                         "<!--MODE: GENERATE-ID-FROM-PATH -->\r\n" +
                         "<template match=\"/\" mode=\"generate-id-from-path\" />\r\n" +
                         "  <template match=\"text()\" mode=\"generate-id-from-path\">\r\n" +
                         "    <apply-templates mode=\"generate-id-from-path\" select=\"parent::*\" />\r\n" +
                         "    <value-of select=\"concat('.text-', 1+count(preceding-sibling::text()), '-')\" />\r\n" +
                         "  </template>\r\n" +
                         "  <template match=\"comment()\" mode=\"generate-id-from-path\">\r\n" +
                         "    <apply-templates mode=\"generate-id-from-path\" select=\"parent::*\" />\r\n" +
                         "    <value-of select=\"concat('.comment-', 1+count(preceding-sibling::comment()), '-')\" />\r\n" +
                         "  </template>\r\n" +
                         "  <template match=\"processing-instruction()\" mode=\"generate-id-from-path\">\r\n" +
                         "    <apply-templates mode=\"generate-id-from-path\" select=\"parent::*\" />\r\n" +
                         "    <value-of select=\"concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')\" />\r\n" +
                         "  </template>\r\n" +
                         "  <template match=\"@*\" mode=\"generate-id-from-path\">\r\n" +
                         "    <apply-templates mode=\"generate-id-from-path\" select=\"parent::*\" />\r\n" +
                         "    <value-of select=\"concat('.@', name())\" />\r\n" +
                         "  </template>\r\n" +
                         "  <template match=\"*\" mode=\"generate-id-from-path\" priority=\"-0.5\">\r\n" +
                         "    <apply-templates mode=\"generate-id-from-path\" select=\"parent::*\" />\r\n" +
                         "    <text>.</text>\r\n" +
                         "    <value-of select=\"concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')\" />\r\n" +
                         "  </template>\r\n" +
                         "\r\n" +
                         "<!--MODE: GENERATE-ID-2 -->\r\n" +
                         "<template match=\"/\" mode=\"generate-id-2\">U</template>\r\n" +
                         "  <template match=\"*\" mode=\"generate-id-2\" priority=\"2\">\r\n" +
                         "    <text>U</text>\r\n" +
                         "    <number count=\"*\" level=\"multiple\" />\r\n" +
                         "  </template>\r\n" +
                         "  <template match=\"node()\" mode=\"generate-id-2\">\r\n" +
                         "    <text>U.</text>\r\n" +
                         "    <number count=\"*\" level=\"multiple\" />\r\n" +
                         "    <text>n</text>\r\n" +
                         "    <number count=\"node()\" />\r\n" +
                         "  </template>\r\n" +
                         "  <template match=\"@*\" mode=\"generate-id-2\">\r\n" +
                         "    <text>U.</text>\r\n" +
                         "    <number count=\"*\" level=\"multiple\" />\r\n" +
                         "    <text>_</text>\r\n" +
                         "    <value-of select=\"string-length(local-name(.))\" />\r\n" +
                         "    <text>_</text>\r\n" +
                         "    <value-of select=\"translate(name(),':','.')\" />\r\n" +
                         "  </template>\r\n" +
                         "  <!--Strip characters-->  <template match=\"text()\" priority=\"-1\" />\r\n" +
                         "  <!--SCHEMA SETUP-->\r\n" +
                         "  <template match=\"/\">\r\n" +
                         "    <ns0:schematron-output xmlns:ns0=\"http://purl.oclc.org/dsdl/svrl\" schemaVersion=\"\" title=\"\">\r\n" +
                         "      <comment>\r\n" +
                         "        <value-of select=\"$archiveDirParameter\" />   \r\n" +
                         "     <value-of select=\"$archiveNameParameter\" />  \r\n" +
                         "     <value-of select=\"$fileNameParameter\" />  \r\n" +
                         "     <value-of select=\"$fileDirParameter\" />\r\n" +
                         "      </comment>\r\n" +
                         "      <ns0:ns-prefix-in-attribute-values prefix=\"xsi\" uri=\"http://www.w3.org/2001/XMLSchema-instance\" />\r\n" +
                         "      <ns0:active-pattern>\r\n" +
                         "        <attribute name=\"document\">\r\n" +
                         "          <value-of select=\"document-uri(/)\" />\r\n" +
                         "        </attribute>\r\n" +
                         "        <apply-templates />\r\n" +
                         "      </ns0:active-pattern>\r\n" +
                         "      <apply-templates mode=\"M1\" select=\"/\" />\r\n" +
                         "    </ns0:schematron-output>\r\n" +
                         "  </template>\r\n" +
                         "  <!--SCHEMATRON PATTERNS-->\r\n" +
                         "  <!--PATTERN -->\r\n" +
                         "  <!--RULE -->\r\n" +
                         "  <template match=\"tag1\" mode=\"M1\" priority=\"1000\">\r\n" +
                         "    <ns0:fired-rule xmlns:ns0=\"http://purl.oclc.org/dsdl/svrl\" context=\"tag1\" />\r\n" +
                         "    <!--ASSERT -->\r\n" +
                         "    <choose>\r\n" +
                         "      <when test=\"matches(tag2,'^[0-9]{4}$')\" />\r\n" +
                         "      <otherwise>\r\n" +
                         // With "{" and "}" it does not work
                         "        <ns0:failed-assert xmlns:ns0=\"http://purl.oclc.org/dsdl/svrl\" test=\"matches(tag2,'^[0-9]{{4}}$')\">\r\n" +
                         "          <attribute name=\"location\">\r\n" +
                         "            <apply-templates mode=\"schematron-select-full-path\" select=\".\" />\r\n" +
                         "          </attribute>\r\n" +
                         "          <ns0:text>Invalid value</ns0:text>\r\n" +
                         "        </ns0:failed-assert>\r\n" +
                         "      </otherwise>\r\n" +
                         "    </choose>\r\n" +
                         "    <apply-templates mode=\"M1\" select=\"*|comment()|processing-instruction()\" />\r\n" +
                         "  </template>\r\n" +
                         "  <template match=\"text()\" mode=\"M1\" priority=\"-1\" />\r\n" +
                         "  <template match=\"@*|node()\" mode=\"M1\" priority=\"-2\">\r\n" +
                         "    <apply-templates mode=\"M1\" select=\"*|comment()|processing-instruction()\" />\r\n" +
                         "  </template>\r\n" +
                         "</stylesheet>";
    final TransformerFactory aTF = SchematronTransformerFactory.createTransformerFactorySaxonFirst (SchematronProviderXSLTPrebuild.class.getClassLoader (),
                                                                                                    null,
                                                                                                    new DefaultTransformURIResolver (null));
    final Transformer t = aTF.newTransformer (new StringStreamSource (sXslt));
    t.transform (TransformSourceFactory.create (new File ("src/test/resources/issues/github137/test.xml")),
                 new StreamResult (System.out));
  }

  @Test
  @Ignore ("Doesn't work because of unquoted braces")
  public void testWithManualXsltMinimum () throws Exception
  {
    final String sXslt = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n" +
                         "<stylesheet xmlns=\"http://www.w3.org/1999/XSL/Transform\" version=\"2.0\">\r\n" +
                         "  <output indent=\"yes\" method=\"xml\" omit-xml-declaration=\"no\" standalone=\"no\"/>\r\n" +
                         "  <template match=\"/\">\r\n" +
                         "    <ns0:schematron-output xmlns:ns0=\"http://purl.oclc.org/dsdl/svrl\">\r\n" +
                         "      <apply-templates mode=\"M1\" select=\"/\" />\r\n" +
                         "    </ns0:schematron-output>\r\n" +
                         "  </template>" +
                         "  <template match=\"tag1\" mode=\"M1\" priority=\"1000\">\r\n" +
                         "    <ns0:fired-rule xmlns:ns0=\"http://purl.oclc.org/dsdl/svrl\" context=\"tag1\"/>\r\n" +
                         "    <choose>\r\n" +
                         "      <when test=\"matches(tag2,'^[0-9]{4}$')\"/>\r\n" +
                         "      <otherwise>\r\n" +
                         "        <ns0:failed-assert xmlns:ns0=\"http://purl.oclc.org/dsdl/svrl\" test=\"value-with-open-bracket: {\">\r\n" +
                         "          <ns0:text>Invalid test value</ns0:text>\r\n" +
                         "        </ns0:failed-assert>\r\n" +
                         "        <ns0:failed-assert xmlns:ns0=\"http://purl.oclc.org/dsdl/svrl\" test=\"value-with-closing-bracket: }\">\r\n" +
                         "          <ns0:text>Invalid test value</ns0:text>\r\n" +
                         "        </ns0:failed-assert>\r\n" +
                         "      </otherwise>\r\n" +
                         "    </choose>\r\n" +
                         "    <apply-templates mode=\"M1\" select=\"*|comment()|processing-instruction()\"/>\r\n" +
                         "  </template>\r\n" +
                         "  <template match=\"text()\" mode=\"M1\" priority=\"-1\"/>\r\n" +
                         "  <template match=\"@*|node()\" mode=\"M1\" priority=\"-2\">\r\n" +
                         "    <apply-templates mode=\"M1\" select=\"*|comment()|processing-instruction()\"/>\r\n" +
                         "  </template>\r\n" +
                         "</stylesheet>";
    final TransformerFactory aTF = SchematronTransformerFactory.createTransformerFactorySaxonFirst (SchematronProviderXSLTPrebuild.class.getClassLoader (),
                                                                                                    null,
                                                                                                    new DefaultTransformURIResolver (null));
    final Transformer t = aTF.newTransformer (new StringStreamSource (sXslt));
    t.transform (TransformSourceFactory.create (new File ("src/test/resources/issues/github137/test.xml")),
                 new StreamResult (System.out));
  }
}
