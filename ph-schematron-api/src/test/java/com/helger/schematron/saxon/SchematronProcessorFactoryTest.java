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
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertSame;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import org.junit.Test;

import net.sf.saxon.lib.Feature;
import net.sf.saxon.lib.ResourceRequest;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.trans.XPathException;

/**
 * Test class for class {@link SchematronProcessorFactory}.
 *
 * @author Philip Helger
 */
public final class SchematronProcessorFactoryTest
{
  @Test
  public void testSecureDefaults ()
  {
    assertFalse (SchematronProcessorFactory.DEFAULT_ALLOW_EXTERNAL_FUNCTIONS);
    assertFalse (SchematronProcessorFactory.isAllowExternalFunctions ());
    assertTrue (SchematronProcessorFactory.getAllAllowedRemoteSchemes ().isEmpty ());

    final Processor aProcessor = SchematronProcessorFactory.createProcessor ();
    assertNotNull (aProcessor);
    // This is what Saxon does for FEATURE_SECURE_PROCESSING
    assertEquals (Boolean.FALSE, aProcessor.getConfigurationProperty (Feature.ALLOW_EXTERNAL_FUNCTIONS));
    // XInclude follows the same switch as the XSLT based engines
    assertEquals (Boolean.valueOf (SchematronTransformerFactory.isAllowXInclude ()),
                  aProcessor.getConfigurationProperty (Feature.XINCLUDE));
  }

  @Test
  public void testSharedDefaultIsSecuredAndStable ()
  {
    final Processor aDefault = SchematronProcessorFactory.getDefault ();
    assertNotNull (aDefault);
    // The engines compare against this identity to decide whether a config may be cached
    assertSame (aDefault, SchematronProcessorFactory.getDefault ());
    assertEquals (Boolean.FALSE, aDefault.getConfigurationProperty (Feature.ALLOW_EXTERNAL_FUNCTIONS));
  }

  @Test
  public void testRemoteResourceAccessIsDenied ()
  {
    final Processor aProcessor = SchematronProcessorFactory.createProcessor ();

    final ResourceRequest aBlocked = new ResourceRequest ();
    aBlocked.uri = "http://example.org/x.xml";
    try
    {
      aProcessor.getUnderlyingConfiguration ().getResourceResolver ().resolve (aBlocked);
      fail ("The Configuration must not resolve a remote URI");
    }
    catch (final XPathException ex)
    {
      // Expected
    }
  }

  @Test
  public void testLocalResourceAccessIsNotAffected () throws XPathException
  {
    final Processor aProcessor = SchematronProcessorFactory.createProcessor ();

    final ResourceRequest aRequest = new ResourceRequest ();
    // A file that surely does not exist - the point is that the resolution is attempted at all
    aRequest.uri = "file:/this-file-does-not-exist-" + System.nanoTime () + ".xml";
    // The chained default resolver answers "not found" with null instead of throwing
    assertNull (aProcessor.getUnderlyingConfiguration ().getResourceResolver ().resolve (aRequest));
  }

  @Test
  public void testExternalFunctionsCanBeEnabled ()
  {
    try
    {
      SchematronProcessorFactory.setAllowExternalFunctions (true);
      assertTrue (SchematronProcessorFactory.isAllowExternalFunctions ());

      final Processor aProcessor = SchematronProcessorFactory.createProcessor ();
      assertEquals (Boolean.TRUE, aProcessor.getConfigurationProperty (Feature.ALLOW_EXTERNAL_FUNCTIONS));
    }
    finally
    {
      SchematronProcessorFactory.setAllowExternalFunctions (SchematronProcessorFactory.DEFAULT_ALLOW_EXTERNAL_FUNCTIONS);
    }
    assertFalse (SchematronProcessorFactory.isAllowExternalFunctions ());
  }

  @Test
  public void testAllowedRemoteSchemesCanBeSet ()
  {
    try
    {
      SchematronProcessorFactory.setAllowedRemoteSchemes ("http");
      assertTrue (SchematronProcessorFactory.getAllAllowedRemoteSchemes ().contains ("http"));

      final Processor aProcessor = SchematronProcessorFactory.createProcessor ();
      final ResourceRequest aRequest = new ResourceRequest ();
      aRequest.uri = "https://example.org/x.xml";
      try
      {
        aProcessor.getUnderlyingConfiguration ().getResourceResolver ().resolve (aRequest);
        fail ("'https' was not allowed");
      }
      catch (final XPathException ex)
      {
        // Expected - only "http" was allowed
      }
    }
    finally
    {
      SchematronProcessorFactory.setAllowedRemoteSchemes ((String []) null);
    }
    assertTrue (SchematronProcessorFactory.getAllAllowedRemoteSchemes ().isEmpty ());
  }

  @Test
  public void testProcessorCustomizerIsInvokedLast ()
  {
    try
    {
      SchematronProcessorFactory.setProcessorCustomizer (p -> p.setConfigurationProperty (Feature.ALLOW_EXTERNAL_FUNCTIONS,
                                                                                          Boolean.TRUE));
      assertNotNull (SchematronProcessorFactory.getProcessorCustomizer ());

      final Processor aProcessor = SchematronProcessorFactory.createProcessor ();
      // The customizer runs after the security defaults, so it wins
      assertEquals (Boolean.TRUE, aProcessor.getConfigurationProperty (Feature.ALLOW_EXTERNAL_FUNCTIONS));
    }
    finally
    {
      SchematronProcessorFactory.setProcessorCustomizer (null);
    }
    assertNull (SchematronProcessorFactory.getProcessorCustomizer ());
  }
}
