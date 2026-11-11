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
package com.helger.schematron.phoxtrot;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertSame;
import static org.junit.Assert.fail;

import java.util.Locale;

import javax.xml.transform.TransformerFactory;

import org.junit.Test;

import com.helger.phoxtrot.xpath.EThreading;
import com.helger.phoxtrot.xslt.XsltTransformRequest;
import com.helger.phoxtrot.xslt.jaxp.PhoxtrotTransformerFactory;
import com.helger.xml.transform.LoggingTransformErrorListener;

/**
 * Test class for class {@link PhoxtrotTransformerFactories}.
 *
 * @author Philip Helger
 */
public final class PhoxtrotTransformerFactoriesTest
{
  @Test
  public void testDefaults ()
  {
    assertEquals (XsltTransformRequest.UNLIMITED_STEPS, PhoxtrotTransformerFactories.DEFAULT_MAX_STEPS);
    assertEquals (XsltTransformRequest.UNLIMITED_DEPTH, PhoxtrotTransformerFactories.DEFAULT_MAX_DEPTH);
    assertEquals (EThreading.THREAD_POOL, PhoxtrotTransformerFactories.DEFAULT_THREADING);
    assertEquals (PhoxtrotTransformerFactories.DEFAULT_MAX_DEPTH, PhoxtrotTransformerFactories.getMaxDepth ());
    assertEquals (PhoxtrotTransformerFactories.DEFAULT_MAX_STEPS, PhoxtrotTransformerFactories.getMaxSteps ());
    assertSame (PhoxtrotTransformerFactories.DEFAULT_THREADING, PhoxtrotTransformerFactories.getThreading ());
    assertSame (PhoxtrotTransformerFactories.getDefault (), PhoxtrotTransformerFactories.getDefault ());
  }

  @Test
  public void testSettingsApplyToNewFactories ()
  {
    try
    {
      PhoxtrotTransformerFactories.setMaxSteps (1000);
      PhoxtrotTransformerFactories.setMaxDepth (500);
      PhoxtrotTransformerFactories.setThreading (EThreading.CALLING_THREAD);
      final TransformerFactory aTF = PhoxtrotTransformerFactories.createTransformerFactory ();
      assertEquals (Long.valueOf (1000), aTF.getAttribute (PhoxtrotTransformerFactory.ATTR_MAX_STEPS));
      assertEquals (Integer.valueOf (500), aTF.getAttribute (PhoxtrotTransformerFactory.ATTR_MAX_DEPTH));
      assertSame (EThreading.CALLING_THREAD, aTF.getAttribute (PhoxtrotTransformerFactory.ATTR_THREADING));
    }
    finally
    {
      PhoxtrotTransformerFactories.setMaxSteps (PhoxtrotTransformerFactories.DEFAULT_MAX_STEPS);
      PhoxtrotTransformerFactories.setMaxDepth (PhoxtrotTransformerFactories.DEFAULT_MAX_DEPTH);
      PhoxtrotTransformerFactories.setThreading (PhoxtrotTransformerFactories.DEFAULT_THREADING);
    }
  }

  @Test
  public void testErrorListener ()
  {
    final LoggingTransformErrorListener aEL = new LoggingTransformErrorListener (Locale.US);
    final TransformerFactory aTF = PhoxtrotTransformerFactories.createTransformerFactory (aEL, null);
    assertSame (aEL, aTF.getErrorListener ());
  }

  @Test
  public void testInvalidSettings ()
  {
    try
    {
      PhoxtrotTransformerFactories.setMaxSteps (0);
      fail ();
    }
    catch (final IllegalArgumentException ex)
    {
      // expected
    }
    try
    {
      PhoxtrotTransformerFactories.setMaxDepth (0);
      fail ();
    }
    catch (final IllegalArgumentException ex)
    {
      // expected
    }
    try
    {
      PhoxtrotTransformerFactories.setThreading (null);
      fail ();
    }
    catch (final NullPointerException ex)
    {
      // expected
    }
  }
}
