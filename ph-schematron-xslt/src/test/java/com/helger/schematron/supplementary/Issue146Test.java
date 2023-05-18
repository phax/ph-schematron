package com.helger.schematron.supplementary;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.nio.charset.StandardCharsets;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.commons.collection.impl.ICommonsList;
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
    final String schematron = "<?xml version='1.0' encoding='UTF-8'?>\n" +
                              "<sch:schema xmlns:sch='http://purl.oclc.org/dsdl/schematron'\n" +
                              "  queryBinding='xslt2' schemaVersion='ISO19757-3'>" +
                              "  <sch:title>Schematron 1</sch:title>\n\n" +
                              "  <sch:pattern abstract='true' id='LimitNoOfWords'>\n" +
                              "    <sch:rule context='$parentElement'>\n" +
                              "      <sch:let name='words' value='string-length(.)'/>\n" +
                              "      <sch:assert test='$words &gt; $maxWords'>\n" +
                              "        You have <sch:value-of select='$words'/> word(s).\n" +
                              "      </sch:assert>\n" +
                              "      <sch:assert test='$words &lt; $minWords'>\n" +
                              "        You have <sch:value-of select='$words'/> word(s).\n" +
                              "      </sch:assert>\n" +
                              "    </sch:rule>\n" +
                              "  </sch:pattern>\n" +
                              "  <sch:pattern is-a='LimitNoOfWords' id='x1'>\n" +
                              "    <sch:param name='parentElement' value='title'/>\n" +
                              "    <sch:param name='minWords' value='1'/>\n" +
                              "    <sch:param name='maxWords' value='8'/>\n" +
                              "  </sch:pattern>\n" +
                              "</sch:schema>";

    if (false)
      SchematronDebug.setDebugMode (true);

    final SchematronResourceSCH aResSCH = SchematronResourceSCH.fromString (schematron, StandardCharsets.UTF_8);
    final boolean ans = aResSCH.isValidSchematron ();
    assertTrue (ans);

    final String xmlFile = "<?xml version='1.0' encoding='UTF-8'?>\n" +
                           "<topic id='id168TG0I0RYF'>\n" +
                           "  <title>Hi Legal done</title>\n" +
                           "  <shortdesc>Content is provided for demonstration purposes only. <ph audience='Administrator'>Administrators and operators must read the manual before operating a new vehicle. </ph> <ph audience='EndUser'>Any user must read the manual before operating a new vehicle. </ph> <ph product='ProductA'>Your luxuriously appointed way to travel to the stars awaits you! </ph> <ph product='ProductB'>Your well appointed spaceship awaits you! </ph></shortdesc>\n" +
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
}
