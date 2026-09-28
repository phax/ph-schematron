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

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import org.junit.Test;

import net.sf.saxon.lib.ResourceRequest;
import net.sf.saxon.trans.XPathException;

/**
 * Test class for class {@link SaxonSecureResourceResolver}.
 *
 * @author Philip Helger
 */
public final class SaxonSecureResourceResolverTest
{
  @Test
  public void testRemoteSchemesAreBlockedByDefault ()
  {
    final SaxonSecureResourceResolver aResolver = new SaxonSecureResourceResolver ();
    assertTrue (aResolver.getAllAllowedRemoteSchemes ().isEmpty ());

    assertFalse (aResolver.isResourceAccessAllowed ("http://example.org/x.xml"));
    assertFalse (aResolver.isResourceAccessAllowed ("https://example.org/x.xml"));
    assertFalse (aResolver.isResourceAccessAllowed ("ftp://example.org/x.xml"));
    assertFalse (aResolver.isResourceAccessAllowed ("ftps://example.org/x.xml"));
    // The scheme comparison is case insensitive
    assertFalse (aResolver.isResourceAccessAllowed ("HTTP://example.org/x.xml"));
  }

  @Test
  public void testLocalSchemesAreAllowed ()
  {
    final SaxonSecureResourceResolver aResolver = new SaxonSecureResourceResolver ();
    assertTrue (aResolver.isResourceAccessAllowed ("file:/tmp/x.xml"));
    assertTrue (aResolver.isResourceAccessAllowed ("jar:file:/tmp/x.jar!/y.xml"));
    assertTrue (aResolver.isResourceAccessAllowed ("bundle://5.0:0/x.xml"));
    // A relative URI cannot reach out at all
    assertTrue (aResolver.isResourceAccessAllowed ("x.xml"));
    assertTrue (aResolver.isResourceAccessAllowed ("../sub/x.xml"));
    assertTrue (aResolver.isResourceAccessAllowed (null));
    assertTrue (aResolver.isResourceAccessAllowed (""));
  }

  @Test
  public void testNestedJarSchemeIsNotABypass ()
  {
    final SaxonSecureResourceResolver aResolver = new SaxonSecureResourceResolver ();
    assertFalse (aResolver.isResourceAccessAllowed ("jar:http://example.org/x.jar!/y.xml"));
    assertFalse (aResolver.isResourceAccessAllowed ("jar:jar:https://example.org/x.jar!/y.xml"));
  }

  @Test
  public void testAllowedRemoteSchemes ()
  {
    final SaxonSecureResourceResolver aResolver = new SaxonSecureResourceResolver ();
    aResolver.setAllowedRemoteSchemes ("HTTP");
    assertTrue (aResolver.getAllAllowedRemoteSchemes ().contains ("http"));

    assertTrue (aResolver.isResourceAccessAllowed ("http://example.org/x.xml"));
    assertTrue (aResolver.isResourceAccessAllowed ("jar:http://example.org/x.jar!/y.xml"));
    assertFalse (aResolver.isResourceAccessAllowed ("https://example.org/x.xml"));

    // null resets to "nothing allowed"
    aResolver.setAllowedRemoteSchemes ((String []) null);
    assertTrue (aResolver.getAllAllowedRemoteSchemes ().isEmpty ());
    assertFalse (aResolver.isResourceAccessAllowed ("http://example.org/x.xml"));
  }

  @Test
  public void testResolveThrowsForBlockedAndDelegatesOtherwise () throws XPathException
  {
    final SaxonSecureResourceResolver aResolver = new SaxonSecureResourceResolver ();

    final ResourceRequest aBlocked = new ResourceRequest ();
    aBlocked.uri = "http://example.org/x.xml";
    try
    {
      aResolver.resolve (aBlocked);
      fail ("A blocked URI must not be resolved");
    }
    catch (final XPathException ex)
    {
      // Expected - "null" would let Saxon resolve the URI itself
    }

    final ResourceRequest aAllowed = new ResourceRequest ();
    aAllowed.uri = "file:/tmp/x.xml";
    // "null" means "not handled by me" - the next resolver of the chain takes over
    assertNull (aResolver.resolve (aAllowed));
  }
}
