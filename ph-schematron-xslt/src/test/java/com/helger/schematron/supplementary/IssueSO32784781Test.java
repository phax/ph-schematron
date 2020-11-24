/**
 * Copyright (C) 2014-2020 Philip Helger (www.helger.com)
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

import static org.junit.Assert.assertTrue;

import java.nio.charset.StandardCharsets;

import org.junit.Test;

import com.helger.commons.io.resource.inmemory.ReadableResourceString;
import com.helger.schematron.ISchematronResource;
import com.helger.schematron.xslt.SchematronResourceSCH;

/**
 * Test for StackOverflow
 * http://stackoverflow.com/questions/32784781/ph-schematron-namespace-prefix-error-after-compiling-schematron-to-xslt-using-p
 *
 * @author Philip Helger
 */
public final class IssueSO32784781Test
{
  @Test
  public void testBasic ()
  {
    final String sSCH = "<schema xmlns=\"http://purl.oclc.org/dsdl/schematron\">\r\n" +
                        "  <ns prefix=\"m\" uri=\"http://www.ociweb.com/movies\"/>\r\n" +
                        "  <pattern name=\"all\">\r\n" +
                        "    <rule context=\"m:actor\">\r\n" +
                        "      <report test=\"@role=preceding-sibling::m:actor/@role\"\r\n" +
                        "          diagnostics=\"duplicateActorRole\">\r\n" +
                        "        Duplicate role!\r\n" +
                        "      </report>\r\n" +
                        "    </rule>\r\n" +
                        "  </pattern>\r\n" +
                        "  <diagnostics>\r\n" +
                        "    <diagnostic id=\"duplicateActorRole\">\r\n" +
                        "      More than one actor plays the role<value-of select=\"@role\"/>.\r\n" +
                        "      A duplicate is named<value-of select=\"@name\"/>.\r\n" +
                        "    </diagnostic>\r\n" +
                        "  </diagnostics>\r\n" +
                        "</schema>";
    final ISchematronResource isr = new SchematronResourceSCH (new ReadableResourceString (sSCH, StandardCharsets.UTF_8));
    assertTrue (isr.isValidSchematron ());
  }
}
