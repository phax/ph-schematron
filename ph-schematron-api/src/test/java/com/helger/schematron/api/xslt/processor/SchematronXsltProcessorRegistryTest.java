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
package com.helger.schematron.api.xslt.processor;

import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import org.junit.Test;

/**
 * Test class for class {@link SchematronXsltProcessorRegistry} without any XSLT processor on the
 * class path.
 *
 * @author Philip Helger
 */
public final class SchematronXsltProcessorRegistryTest
{
  @Test
  public void testNoProcessor ()
  {
    assertTrue (SchematronXsltProcessorRegistry.getAllProcessors ().isEmpty ());
    assertNull (SchematronXsltProcessorRegistry.getProcessorOfID (null));
    assertNull (SchematronXsltProcessorRegistry.getProcessorOfID (""));
    assertNull (SchematronXsltProcessorRegistry.getProcessorOfID ("saxon"));

    try
    {
      SchematronXsltProcessorRegistry.getDefaultProcessor ();
      fail ();
    }
    catch (final IllegalStateException ex)
    {
      // The error message must tell the user what to add
      assertTrue (ex.getMessage ().contains ("ph-schematron-saxon"));
      assertTrue (ex.getMessage ().contains ("ph-schematron-phoxtrot"));
    }
  }
}
