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

import java.util.Locale;

import javax.xml.transform.Source;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.string.StringHelper;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.collection.commons.CommonsHashSet;
import com.helger.collection.commons.ICommonsSet;
import com.helger.xml.XMLResourceSchemeHelper;

import net.sf.saxon.lib.ResourceRequest;
import net.sf.saxon.lib.ResourceResolver;
import net.sf.saxon.trans.XPathException;

/**
 * A Saxon {@link ResourceResolver} that denies the resolution of all remote URL schemes, to prevent
 * Server Side Request Forgery (SSRF) via the XPath and XSLT functions that dereference a URI -
 * <code>doc()</code>, <code>document()</code>, <code>unparsed-text()</code>,
 * <code>collection()</code>, <code>json-doc()</code>, <code>fn:transform()</code> and
 * <code>xsl:source-document</code> - as well as via an external entity of a document that Saxon
 * itself parses.
 * <p>
 * The set of remote URL schemes is the one of ph-commons'
 * {@link XMLResourceSchemeHelper#getAllRemoteNetworkSchemes()}, so this resolver blocks exactly
 * what {@link com.helger.xml.transform.DefaultTransformURIResolver} blocks for the XSLT based
 * engines. Local schemes (<code>file</code>, <code>jar</code>, OSGi <code>bundle</code>, ...) are
 * always allowed. Use {@link #setAllowedRemoteSchemes(String...)} to allow specific remote schemes
 * again.
 * </p>
 * <p>
 * A blocked URI results in an {@link XPathException}, and <b>not</b> in <code>null</code>: the
 * Saxon contract of {@link ResourceResolver#resolve(ResourceRequest)} is that <code>null</code>
 * means "not handled", in which case Saxon resolves the URI itself - which is exactly what must be
 * prevented. An allowed URI is answered with <code>null</code>, so that the next resolver of the
 * chain performs the actual resolution.
 * </p>
 *
 * @author Philip Helger
 * @since 10.1.0
 */
@NotThreadSafe
public class SaxonSecureResourceResolver implements ResourceResolver
{
  /** The URL scheme that nests another URL scheme in its scheme specific part */
  public static final String SCHEME_JAR = "jar";

  private static final Logger LOGGER = LoggerFactory.getLogger (SaxonSecureResourceResolver.class);
  private static final ICommonsSet <String> REMOTE_NETWORK_SCHEMES = XMLResourceSchemeHelper.getAllRemoteNetworkSchemes ();

  // Remote schemes that are explicitly allowed for resolution. Empty by default.
  private final ICommonsSet <String> m_aAllowedRemoteSchemes = new CommonsHashSet <> ();

  public SaxonSecureResourceResolver ()
  {}

  /**
   * @return A mutable copy of the set of remote URL schemes (all lower case, e.g. "http") that are
   *         allowed to be resolved. Empty by default, meaning that no remote resource may be
   *         resolved at all. Never <code>null</code>.
   */
  @NonNull
  @ReturnsMutableCopy
  public final ICommonsSet <String> getAllAllowedRemoteSchemes ()
  {
    return m_aAllowedRemoteSchemes.getClone ();
  }

  /**
   * Set the remote URL schemes that are allowed to be resolved. By default no remote scheme is
   * allowed. Local resources are always resolved regardless of this setting.
   *
   * @param aAllowedRemoteSchemes
   *        The remote schemes to allow (e.g. "http", "https"). May be <code>null</code> or empty to
   *        deny all remote schemes.
   * @return this for chaining
   */
  @NonNull
  public final SaxonSecureResourceResolver setAllowedRemoteSchemes (@Nullable final String... aAllowedRemoteSchemes)
  {
    m_aAllowedRemoteSchemes.clear ();
    if (aAllowedRemoteSchemes != null)
      for (final String sScheme : aAllowedRemoteSchemes)
        if (StringHelper.isNotEmpty (sScheme))
          m_aAllowedRemoteSchemes.add (sScheme.toLowerCase (Locale.ROOT));
    return this;
  }

  /**
   * Extract the lower cased URL scheme of the provided URI, without creating a
   * <code>java.net.URI</code> - Saxon also passes URIs that cannot be parsed by it.
   *
   * @param sURI
   *        The URI to check. May not be <code>null</code>.
   * @return <code>null</code> if the URI has no scheme at all (a relative URI).
   */
  @Nullable
  private static String _getSchemeLC (@NonNull final String sURI)
  {
    final int nIndex = sURI.indexOf (':');
    if (nIndex <= 0)
      return null;

    // A scheme starts with a letter and continues with letters, digits, '+', '-' and '.'
    for (int i = 0; i < nIndex; ++i)
    {
      final char c = sURI.charAt (i);
      final boolean bValid = c >= 'a' && c <= 'z' ||
                             c >= 'A' && c <= 'Z' ||
                             i > 0 && (c >= '0' && c <= '9' || c == '+' || c == '-' || c == '.');
      if (!bValid)
        return null;
    }
    return sURI.substring (0, nIndex).toLowerCase (Locale.ROOT);
  }

  /**
   * Check if the provided URI may be dereferenced.
   *
   * @param sURI
   *        The absolute URI to check. May be <code>null</code> or empty.
   * @return <code>true</code> if the URI may be resolved, <code>false</code> if its URL scheme is a
   *         remote one that is not explicitly allowed.
   */
  public final boolean isResourceAccessAllowed (@Nullable final String sURI)
  {
    if (StringHelper.isEmpty (sURI))
      return true;

    /*
     * "jar:<nested URI>!/<entry>" nests another URL scheme, so "jar:http://..." must be checked
     * against the nested scheme as well - otherwise the check could be bypassed with it.
     */
    String sRest = sURI;
    while (true)
    {
      final String sScheme = _getSchemeLC (sRest);
      if (sScheme == null)
      {
        // Relative URI - no remote access possible
        return true;
      }
      if (REMOTE_NETWORK_SCHEMES.contains (sScheme))
        return m_aAllowedRemoteSchemes.contains (sScheme);
      if (!SCHEME_JAR.equals (sScheme))
      {
        // Some other local scheme - always safe
        return true;
      }
      // Continue with the nested URI of the JAR URL
      sRest = sRest.substring (sScheme.length () + 1);
    }
  }

  public Source resolve (@NonNull final ResourceRequest aRequest) throws XPathException
  {
    final String sURI = aRequest.uri;
    if (!isResourceAccessAllowed (sURI))
    {
      LOGGER.warn ("Blocked Saxon resolution of resource '" +
                   sURI +
                   "' because its URL scheme is not in the list of allowed remote schemes " +
                   m_aAllowedRemoteSchemes);
      /*
       * Deliberately not "null": per the Saxon contract "null" means "not handled" and lets Saxon
       * resolve the URI itself, which would defeat the whole check.
       */
      throw new XPathException ("Access to the URI '" + sURI + "' was blocked for security reasons");
    }

    // Not our business - let the next resolver of the chain do the work
    return null;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("AllowedRemoteSchemes", m_aAllowedRemoteSchemes).getToString ();
  }
}
