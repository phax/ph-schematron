/**
 * Copyright (C) 2014-2021 Philip Helger (www.helger.com)
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
package com.helger.schematron.pure.model;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertSame;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

/**
 * Test class for class {@link PSPattern}.
 *
 * @author Philip Helger
 */
public final class PSPatternTest
{
  @Test
  public void testBasic ()
  {
    final PSPattern aPattern = new PSPattern ();
    assertNull (aPattern.getTitle ());
    assertEquals (0, aPattern.getAllContentElements ().size ());

    final PSTitle aTitle = new PSTitle ();
    aTitle.addText ("xyz");
    aPattern.setTitle (aTitle);
    assertSame (aTitle, aPattern.getTitle ());

    assertEquals (0, aPattern.getAllContentElements ().size ());

    final PSLet aLet = PSLet.create ("n", "v");
    aPattern.addLet (aLet);
    assertEquals (1, aPattern.getAllContentElements ().size ());
    assertTrue (aPattern.getAllContentElements ().contains (aLet));
  }
}
