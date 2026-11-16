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

import static org.junit.Assert.assertTrue;

import java.nio.charset.StandardCharsets;

import org.junit.Test;

import com.helger.schematron.ISchematronResource;
import com.helger.schematron.sch.SchematronResourceSCH;

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
    final String sSCH = """
        <schema xmlns="http://purl.oclc.org/dsdl/schematron">
          <ns prefix="m" uri="http://www.ociweb.com/movies"/>
          <pattern name="all">
            <rule context="m:actor">
              <report test="@role=preceding-sibling::m:actor/@role"
                  diagnostics="duplicateActorRole">
                Duplicate role!
              </report>
            </rule>
          </pattern>
          <diagnostics>
            <diagnostic id="duplicateActorRole">
              More than one actor plays the role<value-of select="@role"/>.
              A duplicate is named<value-of select="@name"/>.
            </diagnostic>
          </diagnostics>
        </schema>""";
    final ISchematronResource isr = SchematronResourceSCH.builderFromString (sSCH, StandardCharsets.UTF_8).build ();
    assertTrue (isr.isValidSchematron ());
  }
}
