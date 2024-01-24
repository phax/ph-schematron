/*
 * Copyright (C) 2014-2024 Philip Helger (www.helger.com)
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

import java.nio.charset.StandardCharsets;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.schematron.sch.SchematronResourceSCH;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.xml.transform.StringStreamSource;

public final class Issue149Test
{
  private static final Logger LOGGER = LoggerFactory.getLogger (Issue149Test.class);

  @Test
  public void testBasic () throws Exception
  {
    final String xml = "<xml id='1'/>";

    final String sch = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
                       "<schema xmlns=\"http://purl.oclc.org/dsdl/schematron\" queryBinding=\"xslt2\">\n" +
                       "  <pattern>\n" +
                       "    <rule context=\"xml\"><assert test=\"exists(@id)\">No id</assert></rule>\n" +
                       "  </pattern>\n" +
                       "</schema>\n";

    final SchematronResourceSCH schResource = SchematronResourceSCH.fromString (sch, StandardCharsets.UTF_8);
    final SchematronOutputType schematronOutputType = schResource.applySchematronValidationToSVRL (new StringStreamSource (xml));

    final SVRLMarshaller svrlMarshaller = new SVRLMarshaller ();
    LOGGER.info (svrlMarshaller.getAsString (schematronOutputType));
  }
}
