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
package com.helger.schematron.sch;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

import com.helger.base.string.StringHelper;
import com.helger.collection.commons.ICommonsList;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.inmemory.ReadableResourceString;
import com.helger.schematron.svrl.SVRLFailedAssert;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;

/**
 * Test class for class {@link SchematronProviderXSLTFromSCH}.
 *
 * @author Philip Helger
 */
public final class SchematronProviderXSLTFromSCHTest
{
  @Test
  public void testAbstractPatternParameters () throws Exception
  {
    final SchematronResourceSCH aSCH = SchematronResourceSCH.builder (new ClassPathResource ("external/test-sch/abstract-pattern-params.sch"))
                                                            .useCache (false)
                                                            .build ();
    assertTrue (aSCH.isValidSchematron ());

    final SchematronOutputType aSVRL = aSCH.applySchematronValidationToSVRL (new ClassPathResource ("external/test-xml/abstract-pattern-params.xml"));
    assertNotNull (aSVRL);

    // Parameters are expanded in @context, @test and in the text - also multiple times in one text
    final ICommonsList <SVRLFailedAssert> aFailedAsserts = SVRLHelper.getAllFailedAssertions (aSVRL);
    assertEquals (2, aFailedAsserts.size ());
    assertEquals ("number(.) le 100", aFailedAsserts.get (0).getTest ());
    assertEquals ("price in order must not exceed 100 (price)", aFailedAsserts.get (0).getText ());
    assertEquals ("number(.) le 5", aFailedAsserts.get (1).getTest ());
    assertEquals ("qty in order must not exceed 5 (qty)", aFailedAsserts.get (1).getText ());
  }

  @Test
  public void testAbstractPatternWithManyParameters () throws Exception
  {
    // Took about 2 minutes with Saxon before the parameter lookup of iso_abstract_expand.xsl was
    // changed to a key
    final int nParams = 2000;
    final StringBuilder aSB = new StringBuilder ();
    aSB.append ("<sch:schema xmlns:sch='http://purl.oclc.org/dsdl/schematron' queryBinding='xslt2'>")
       .append ("<sch:pattern abstract='true' id='abs'>");
    for (int i = 1; i <= 200; ++i)
      aSB.append ("<sch:rule context='$p")
         .append (StringHelper.getLeadingZero (nParams, 4))
         .append ("'><sch:assert test='$p")
         .append (StringHelper.getLeadingZero (i, 4))
         .append (" = 1'>$p0001 $p")
         .append (StringHelper.getLeadingZero (nParams, 4))
         .append ("</sch:assert></sch:rule>");
    aSB.append ("</sch:pattern><sch:pattern is-a='abs' id='real'>");
    for (int i = 1; i < nParams; ++i)
      aSB.append ("<sch:param name='p")
         .append (StringHelper.getLeadingZero (i, 4))
         .append ("' value='v")
         .append (StringHelper.getLeadingZero (i, 4))
         .append ("'/>");
    aSB.append ("<sch:param name='p")
       .append (StringHelper.getLeadingZero (nParams, 4))
       .append ("' value='root'/></sch:pattern></sch:schema>");

    final SchematronResourceSCH aSCH = SchematronResourceSCH.builder (ReadableResourceString.utf8 (aSB.toString ()))
                                                            .useCache (false)
                                                            .build ();
    assertTrue (aSCH.isValidSchematron ());

    final SchematronOutputType aSVRL = aSCH.applySchematronValidationToSVRL (ReadableResourceString.utf8 ("<root/>"));
    assertNotNull (aSVRL);

    // Only the first rule of a pattern fires on a node
    final ICommonsList <SVRLFailedAssert> aFailedAsserts = SVRLHelper.getAllFailedAssertions (aSVRL);
    assertEquals (1, aFailedAsserts.size ());
    assertEquals ("v0001 = 1", aFailedAsserts.get (0).getTest ());
    assertEquals ("v0001 root", aFailedAsserts.get (0).getText ());
  }
}
