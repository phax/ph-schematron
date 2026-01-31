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
package com.helger.schematron.supplementary;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.nio.charset.StandardCharsets;
import java.util.List;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.collection.commons.ICommonsList;
import com.helger.schematron.ISchematronResource;
import com.helger.schematron.sch.SchematronResourceSCH;
import com.helger.schematron.svrl.AbstractSVRLMessage;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.xml.transform.StringStreamSource;

public final class Issue144Test
{
  private static final Logger LOGGER = LoggerFactory.getLogger (Issue144Test.class);

  @Test
  public void testBasic () throws Exception
  {
    final String schematron = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
                              "<sch:schema xmlns:sch=\"http://purl.oclc.org/dsdl/schematron\" queryBinding=\"xslt2\">\n" +
                              "  <sch:title>Schematron 1</sch:title>\n" +
                              "  <sch:pattern>\n" +
                              "    <sch:rule context=\"title\"> \n" +
                              "      <sch:assert test=\"b\"> Bold must be there in <sch:name/> element</sch:assert> \n" +
                              "    </sch:rule>\n" +
                              "  </sch:pattern>\n" +
                              "</sch:schema>";

    final ISchematronResource aResSCH = SchematronResourceSCH.fromString (schematron, StandardCharsets.UTF_8);
    final boolean ans = aResSCH.isValidSchematron ();
    assertTrue (ans);

    final String xmlFile = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
                           "<topic id=\"id168TG0I0RYF\">\n" +
                           "  <title>Hi Legal done</title>\n" +
                           "  <shortdesc>Content is provided for demonstration purposes only. <ph audience=\"Administrator\">Administrators and operators must read the manual before operating a new vehicle. </ph> <ph audience=\"EndUser\">Any user must read the manual before operating a new vehicle. </ph> <ph product=\"ProductA\">Your luxuriously appointed way to travel to the stars awaits you! </ph> <ph product=\"ProductB\">Your well appointed spaceship awaits you! </ph></shortdesc>\n" +
                           "  <prolog>\n" +
                           "  </prolog>\n" +
                           "  <body>\n" +
                           "    <p></p>\n" +
                           "    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua</p>\n" +
                           "  </body>\n" +
                           "</topic>";
    final SchematronOutputType svrl = aResSCH.applySchematronValidationToSVRL (new StringStreamSource (xmlFile));
    assertNotNull (svrl);

    if (false)
      LOGGER.info (new SVRLMarshaller ().setFormattedOutput (true).getAsString (svrl));

    final ICommonsList <AbstractSVRLMessage> errs = SVRLHelper.getAllFailedAssertionsAndSuccessfulReports (svrl);
    assertEquals (1, errs.size ());
  }

  @Test
  public void test2 ()
  {
    final String schematron = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
                              "<sch:schema xmlns:sch=\"http://purl.oclc.org/dsdl/schematron\" queryBinding=\"xslt2\">\n" +
                              "  <sch:title>Schematron 1</sch:title>\n" +
                              "  <sch:pattern>\n" +
                              "    <sch:rule context=\"shortdesc\">\n" +
                              "        <sch:let name=\"characters\" value=\"string-length(.)\"/>\n" +
                              "        <sch:assert test=\"$characters &lt; 10\"> \n" +
                              "        You have characters. Short Description characters should be less than 10.       \n" +
                              "        </sch:assert>  \n" +
                              "    </sch:rule>\n" +
                              "  </sch:pattern>\n" +
                              "</sch:schema>";

    final ISchematronResource aResSCHCheck1 = SchematronResourceSCH.fromString (schematron, StandardCharsets.UTF_8);

    final boolean ans1 = aResSCHCheck1.isValidSchematron ();
    assertTrue (ans1);

    final String xmlFile = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
                           "<topic id=\"id168TG0I0RYF\">\n" +
                           "  <title><b>Hi Legal done</b></title>\n" +
                           "  <shortdesc>Content is provided for demonstration purposes only. <ph audience=\"Administrator\">Administrators and operators must read the manual before operating a new vehicle. </ph> <ph audience=\"EndUser\">Any user must read the manual before operating a new vehicle. </ph> <ph product=\"ProductA\">Your luxuriously appointed way to travel to the stars awaits you! </ph> <ph product=\"ProductB\">Your well appointed spaceship awaits you! </ph></shortdesc>\n" +
                           "  <prolog>\n" +
                           "  </prolog>\n" +
                           "  <body>\n" +
                           "    <p></p>\n" +
                           "    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua</p>\n" +
                           "  </body>\n" +
                           "</topic>";
    final SchematronOutputType svrl;
    try
    {
      svrl = aResSCHCheck1.applySchematronValidationToSVRL (new StringStreamSource (xmlFile));
    }
    catch (final Exception e)
    {
      throw new RuntimeException (e);
    }
    assertNotNull (svrl);
    final List <Object> failedAsserts = svrl.getActivePatternAndFiredRuleAndFailedAssert ();
    assertNotNull (failedAsserts);
  }
}
