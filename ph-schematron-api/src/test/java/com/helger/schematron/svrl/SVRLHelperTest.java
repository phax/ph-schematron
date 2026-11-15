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
package com.helger.schematron.svrl;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;

import org.junit.Test;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.helger.schematron.svrl.jaxb.Dir;
import com.helger.schematron.svrl.jaxb.Emph;
import com.helger.schematron.svrl.jaxb.FailedAssert;
import com.helger.schematron.svrl.jaxb.Span;
import com.helger.schematron.svrl.jaxb.Text;
import com.helger.xml.XMLFactory;

/**
 * Test class for class {@link SVRLHelper}.
 *
 * @author Philip Helger
 */
public final class SVRLHelperTest
{
  @Test
  public void testGetAsString ()
  {
    assertNull (SVRLHelper.getAsString (null));
    assertEquals ("", SVRLHelper.getAsString (new Text ()));

    final Text aText = new Text ();
    aText.getContent ().add ("Plain text");
    assertEquals ("Plain text", SVRLHelper.getAsString (aText));
  }

  @Test
  public void testGetAsStringRichText ()
  {
    final Dir aDir = new Dir ();
    aDir.setDir ("rtl");
    aDir.setContent ("dir");
    final Emph aEmph = new Emph ();
    aEmph.setContent ("emph");
    final Span aSpan = new Span ();
    aSpan.setClazz ("hl");
    aSpan.setContent ("span");
    // Empty elements
    final Emph aEmptyEmph = new Emph ();

    final Document aDoc = XMLFactory.newDocument ();
    final Element aForeign = aDoc.createElementNS ("urn:foreign", "f:x");
    aForeign.appendChild (aDoc.createTextNode ("foreign"));

    final Text aText = new Text ();
    aText.getContent ().add ("a ");
    aText.getContent ().add (aDir);
    aText.getContent ().add (" b ");
    aText.getContent ().add (aEmph);
    aText.getContent ().add (" c ");
    aText.getContent ().add (aSpan);
    aText.getContent ().add (aEmptyEmph);
    aText.getContent ().add (" d ");
    aText.getContent ().add (aForeign);
    aText.getContent ().add (".");
    assertEquals ("a dir b emph c span d foreign.", SVRLHelper.getAsString (aText));

    // The text of failed asserts and successful reports uses the same method
    final FailedAssert aFA = new FailedAssert ();
    aFA.setTest ("x");
    aFA.setLocation ("/a");
    aFA.setText (aText);
    assertEquals ("a dir b emph c span d foreign.", new SVRLFailedAssert (aFA).getText ());
  }
}
