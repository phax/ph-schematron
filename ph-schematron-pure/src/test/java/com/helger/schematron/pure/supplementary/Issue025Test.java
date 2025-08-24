/*
 * Copyright (C) 2014-2025 Philip Helger (www.helger.com)
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
package com.helger.schematron.pure.supplementary;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.pure.SchematronResourcePure;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;

public final class Issue025Test
{
  @Test
  public void testIssue25Valid () throws Exception
  {
    final IReadableResource aSCH = new ClassPathResource ("external/test-sch/xfront/example05/check-classifications.sch");
    final IReadableResource aXML = new ClassPathResource ("external/test-sch/xfront/example05/valid-document.xml");

    final SchematronOutputType aSOT = new SchematronResourcePure (aSCH).applySchematronValidationToSVRL (aXML);
    assertNotNull (aSOT);
    assertTrue (SVRLHelper.getAllFailedAssertions (aSOT).isEmpty ());
  }

  @Test
  public void testIssue25Invalid () throws Exception
  {
    final IReadableResource aSCH = new ClassPathResource ("external/test-sch/xfront/example05/check-classifications.sch");
    final IReadableResource aXML = new ClassPathResource ("external/test-sch/xfront/example05/invalid-document.xml");

    final SchematronOutputType aSOT = new SchematronResourcePure (aSCH).applySchematronValidationToSVRL (aXML);
    assertNotNull (aSOT);
    assertTrue (SVRLHelper.getAllFailedAssertions (aSOT).isNotEmpty ());
  }
}
