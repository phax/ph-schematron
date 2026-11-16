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

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.collection.commons.ICommonsList;
import com.helger.schematron.SchematronDebug;
import com.helger.schematron.sch.SchematronResourceSCH;
import com.helger.schematron.svrl.AbstractSVRLMessage;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.xml.transform.StringStreamSource;

public final class Issue146Test
{
  private static final Logger LOGGER = LoggerFactory.getLogger (Issue146Test.class);

  @Test
  public void testBasic () throws Exception
  {
    final String schematron = """
        <?xml version='1.0' encoding='UTF-8'?>
        <sch:schema xmlns:sch='http://purl.oclc.org/dsdl/schematron'
          queryBinding='xslt2' schemaVersion='ISO19757-3'>  <sch:title>Schematron 1</sch:title>

          <sch:pattern abstract='true' id='LimitNoOfWords'>
            <sch:rule context='$parentElement'>
              <sch:let name='words' value='string-length(.)'/>
              <sch:assert test='$words &gt; $maxWords'>
                You have <sch:value-of select='$words'/> word(s).
              </sch:assert>
              <sch:assert test='$words &lt; $minWords'>
                You have <sch:value-of select='$words'/> word(s).
              </sch:assert>
            </sch:rule>
          </sch:pattern>
          <sch:pattern is-a='LimitNoOfWords' id='x1'>
            <sch:param name='parentElement' value='title'/>
            <sch:param name='minWords' value='1'/>
            <sch:param name='maxWords' value='8'/>
          </sch:pattern>
        </sch:schema>""";

    if (false)
      SchematronDebug.setDebugMode (true);

    final SchematronResourceSCH aResSCH = SchematronResourceSCH.builderFromString (schematron, StandardCharsets.UTF_8)
                                                               .build ();
    final boolean ans = aResSCH.isValidSchematron ();
    assertTrue (ans);

    final String xmlFile = """
        <?xml version='1.0' encoding='UTF-8'?>
        <topic id='id168TG0I0RYF'>
          <title>Hi Legal done</title>
          <shortdesc>Content is provided for demonstration purposes only. <ph audience='Administrator'>Administrators and operators must read the manual before operating a new vehicle. </ph> <ph audience='EndUser'>Any user must read the manual before operating a new vehicle. </ph> <ph product='ProductA'>Your luxuriously appointed way to travel to the stars awaits you! </ph> <ph product='ProductB'>Your well appointed spaceship awaits you! </ph></shortdesc>
          <prolog>
          </prolog>
          <body>
            <p></p>
            <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua</p>
          </body>
        </topic>""";
    final SchematronOutputType svrl = aResSCH.applySchematronValidationToSVRL (new StringStreamSource (xmlFile));
    assertNotNull (svrl);

    if (false)
      LOGGER.info (new SVRLMarshaller ().setFormattedOutput (true).getAsString (svrl));

    final ICommonsList <AbstractSVRLMessage> errs = SVRLHelper.getAllFailedAssertionsAndSuccessfulReports (svrl);
    assertEquals (1, errs.size ());
  }

  @Test
  public void selectText () throws Exception
  {
    final String schematron = """
        <?xml version="1.0" encoding="UTF-8"?>
        <sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
           <sch:title>Schematron Stefan</sch:title>
           <sch:pattern id="quotation-marks-en">
              <sch:rule context="//*[@xml:lang = 'en-US']">
                 <sch:assert role="info" subject="text()" test="not(matches(., '«|»|„'))">Please use the correct typographic quotes for the English language (“” and ‘’).</sch:assert>
                 <sch:assert role="info" subject="text()" test="matches(., '«|»|„')">Please use the correct typographic quotes for the English language (“” and ‘’).</sch:assert>
              </sch:rule>
           </sch:pattern>
        </sch:schema>""";

    if (false)
      SchematronDebug.setDebugMode (true);

    final SchematronResourceSCH aResSCH = SchematronResourceSCH.builderFromString (schematron, StandardCharsets.UTF_8)
                                                               .build ();
    final boolean ans = aResSCH.isValidSchematron ();
    assertTrue (ans);

    final String xmlFile = """
        <?xml version="1.0" encoding="UTF-8"?>
        <topic id="GUID-84fa6d91-8506-4d06-9595-ebabc6f8b46f-enHYPHENUS" xml:lang="en-US">
          <title>Sample</title>
          <shortdesc>This short description is too short. Or too long? The recommendation is, that the short description should have around twenty words.</shortdesc>
          <body>
            <p>This text is using the &quot;straight quotes&quot; which should be reported.</p>
            <p>This text is using the «straight quotes» which should be reported.</p>
            <p>This paragraph contains the word Content.</p>
          </body>
        </topic>""";
    final SchematronOutputType svrl = aResSCH.applySchematronValidationToSVRL (new StringStreamSource (xmlFile));
    assertNotNull (svrl);

    if (false)
      LOGGER.info (new SVRLMarshaller ().setFormattedOutput (true).getAsString (svrl));

    final ICommonsList <AbstractSVRLMessage> errs = SVRLHelper.getAllFailedAssertionsAndSuccessfulReports (svrl);
    assertEquals (1, errs.size ());
  }
}
