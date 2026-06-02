/*
 * Copyright (C) 2015-2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.purexslt.supplementary;

import static org.junit.Assert.assertNotNull;

import java.io.File;

import org.junit.Test;

import com.helger.io.resource.FileSystemResource;
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.purexslt.SchematronResourcePureXslt;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;

/**
 * Ported from {@code IssueXsltKeyTest} in {@code ph-schematron-xslt}. Verifies that an
 * {@code <xsl:key>} declared as a foreign child of the schema flows through to the generated
 * stylesheet and the {@code key()} function in an assert resolves against it - the canonical
 * Phase&nbsp;5 XSLT pass-through scenario.
 *
 * @author Philip Helger
 */
public final class IssueXsltKeyPureXsltTest
{
  @Test
  public void testIssueXsltKey () throws Exception
  {
    final IReadableResource aSch = new FileSystemResource (new File ("src/test/resources/external/issues/xslt-key/schematron.sch").getAbsoluteFile ());
    final IReadableResource aXML = new FileSystemResource (new File ("src/test/resources/external/issues/xslt-key/test.xml").getAbsoluteFile ());
    final SchematronOutputType aSVRL = new SchematronResourcePureXslt (aSch).applySchematronValidationToSVRL (aXML);
    assertNotNull ("Expected SVRL output (xsl:key passed through and key() resolved)", aSVRL);
  }
}
