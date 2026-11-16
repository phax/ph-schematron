/*
 * Copyright (C) 2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.enginefactory;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertSame;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

import com.helger.collection.commons.CommonsHashMap;
import com.helger.collection.commons.ICommonsMap;
import com.helger.collection.commons.ICommonsOrderedMap;
import com.helger.schematron.ESchematronEngine;

/**
 * Test class for class {@link SchematronEngineSettings}.
 *
 * @author Philip Helger
 */
public final class SchematronEngineSettingsTest
{
  @Test
  public void testDefaults ()
  {
    final SchematronEngineSettings aSettings = new SchematronEngineSettings ();
    assertSame (ESchematronEngine.ISO_SCHEMATRON, aSettings.getEngine ());
    assertNull (aSettings.getXsltProcessor ());
    assertNull (aSettings.getPhase ());
    assertNull (aSettings.getLanguageCode ());
    assertTrue (aSettings.getAllParameters ().isEmpty ());
    assertFalse (aSettings.isForceCacheResult ());
    assertFalse (aSettings.isLenient ());
    assertNull (aSettings.getURIResolver ());
    assertNull (aSettings.getEntityResolver ());
  }

  @Test
  public void testParameters ()
  {
    final SchematronEngineSettings aSettings = new SchematronEngineSettings ();
    final ICommonsMap <String, String> aInput = new CommonsHashMap <> ();
    aInput.put ("allow-foreign", "true");
    aSettings.setParameters (aInput);
    final ICommonsOrderedMap <String, String> aParams = aSettings.getAllParameters ();
    assertEquals (1, aParams.size ());
    assertEquals ("true", aParams.get ("allow-foreign"));

    // A copy is returned
    aParams.put ("other", "x");
    assertEquals (1, aSettings.getAllParameters ().size ());

    // null removes all
    aSettings.setParameters (null);
    assertTrue (aSettings.getAllParameters ().isEmpty ());
  }
}
