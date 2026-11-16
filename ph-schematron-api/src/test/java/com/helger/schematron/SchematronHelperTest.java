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
package com.helger.schematron;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import java.util.Locale;

import org.junit.Test;

import com.helger.collection.commons.ICommonsList;
import com.helger.diagnostics.error.list.ErrorList;
import com.helger.io.resource.ClassPathResource;
import com.helger.xml.microdom.IMicroDocument;
import com.helger.xml.microdom.IMicroElement;

/**
 * Test class for class {@link SchematronHelper}.
 *
 * @author Philip Helger
 */
public final class SchematronHelperTest
{
  @Test
  public void testIncludeSameFileWithDifferentAnchors ()
  {
    final ErrorList aErrors = new ErrorList ();
    final IMicroDocument aDoc = SchematronHelper.getWithResolvedSchematronIncludes (new ClassPathResource ("external/include/anchors-main.sch"),
                                                                                    aErrors::add);
    assertNotNull (aDoc);
    assertTrue (aErrors.toString (), aErrors.isEmpty ());

    final ICommonsList <IMicroElement> aChildren = aDoc.getDocumentElement ().getAllChildElements ();
    assertEquals (3, aChildren.size ());
    final String [] aExpectedIDs = { "p1", "p2", "p1" };
    final String [] aExpectedContexts = { "a", "b", "a" };
    for (int i = 0; i < aChildren.size (); ++i)
    {
      final IMicroElement ePattern = aChildren.get (i);
      assertEquals (CSchematronXML.ELEMENT_PATTERN, ePattern.getLocalName ());
      assertEquals (aExpectedIDs[i], ePattern.getAttributeValue ("id"));
      assertEquals (aExpectedContexts[i], ePattern.getFirstChildElement ().getAttributeValue ("context"));
    }
    // Each include has its own copy of the included content
    assertTrue (aChildren.get (0) != aChildren.get (2));
  }

  @Test
  public void testCyclicInclude ()
  {
    final ErrorList aErrors = new ErrorList ();
    final IMicroDocument aDoc = SchematronHelper.getWithResolvedSchematronIncludes (new ClassPathResource ("external/include/cyclic-main.sch"),
                                                                                    aErrors::add);
    assertNull (aDoc);
    assertEquals (1, aErrors.size ());
    final String sErrorText = aErrors.getFirstOrNull ().getErrorText (Locale.ROOT);
    assertTrue (sErrorText, sErrorText.startsWith ("Cyclic include of '"));
    assertTrue (sErrorText, sErrorText.contains ("cyclic-pattern.sch"));
  }
}
