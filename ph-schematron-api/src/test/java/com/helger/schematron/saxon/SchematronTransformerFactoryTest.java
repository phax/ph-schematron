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
package com.helger.schematron.saxon;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import javax.xml.transform.TransformerFactory;

import org.junit.Test;

import net.sf.saxon.lib.FeatureKeys;

/**
 * Test class for class {@link SchematronTransformerFactory}.
 *
 * @author Philip Helger
 */
public final class SchematronTransformerFactoryTest
{
  @Test
  public void testXIncludeDisabledByDefault ()
  {
    assertFalse (SchematronTransformerFactory.DEFAULT_ALLOW_XINCLUDE);
    assertFalse (SchematronTransformerFactory.isAllowXInclude ());

    final TransformerFactory aFactory = SchematronTransformerFactory.createTransformerFactory (false);
    assertNotNull (aFactory);
    assertEquals (Boolean.FALSE, aFactory.getAttribute (FeatureKeys.XINCLUDE));
    // Line numbering is always enabled (#52)
    assertEquals (Boolean.TRUE, aFactory.getAttribute (FeatureKeys.LINE_NUMBERING));
  }

  @Test
  public void testXIncludeCanBeEnabled ()
  {
    try
    {
      SchematronTransformerFactory.setAllowXInclude (true);
      assertTrue (SchematronTransformerFactory.isAllowXInclude ());

      final TransformerFactory aFactory = SchematronTransformerFactory.createTransformerFactory (null, null);
      assertNotNull (aFactory);
      assertEquals (Boolean.TRUE, aFactory.getAttribute (FeatureKeys.XINCLUDE));
    }
    finally
    {
      SchematronTransformerFactory.setAllowXInclude (SchematronTransformerFactory.DEFAULT_ALLOW_XINCLUDE);
    }
    assertFalse (SchematronTransformerFactory.isAllowXInclude ());
  }
}
