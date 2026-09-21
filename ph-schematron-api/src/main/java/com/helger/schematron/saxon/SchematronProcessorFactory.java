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
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.function.Consumer;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.string.StringHelper;
import com.helger.collection.commons.CommonsHashSet;
import com.helger.collection.commons.ICommonsSet;

import net.sf.saxon.Configuration;
import net.sf.saxon.lib.ChainedResourceResolver;
import net.sf.saxon.lib.Feature;
import net.sf.saxon.s9api.Processor;

/**
 * Factory for the Saxon {@link Processor} objects used by the engines that talk to Saxon through the
 * s9api instead of through JAXP - the pure XPath engine (<code>ph-schematron-pure-xpath</code>) and
 * the pure XSLT engine (<code>ph-schematron-pure-xslt</code>).
 * <p>
 * It is the s9api counterpart of {@link SchematronTransformerFactory} and applies the same security
 * defaults that ph-commons applies to a JAXP {@link javax.xml.transform.TransformerFactory}:
 * </p>
 * <ul>
 * <li>External functions are disabled ({@link Feature#ALLOW_EXTERNAL_FUNCTIONS}). This is what Saxon
 * does for {@link javax.xml.XMLConstants#FEATURE_SECURE_PROCESSING}. Extension functions that are
 * registered programmatically (e.g. via
 * {@link Processor#registerExtensionFunction(net.sf.saxon.s9api.ExtensionFunction)}) are considered
 * trusted by Saxon and keep working.</li>
 * <li>XInclude processing is enabled or disabled according to
 * {@link SchematronTransformerFactory#isAllowXInclude()}, so that one switch covers all
 * engines.</li>
 * <li>A {@link SaxonSecureResourceResolver} is installed on the {@link Configuration}, so that
 * <code>doc()</code>, <code>document()</code>, <code>unparsed-text()</code>,
 * <code>collection()</code> and friends cannot dereference a remote URL.</li>
 * </ul>
 *
 * @author Philip Helger
 * @since 10.1.0
 */
@Immutable
public final class SchematronProcessorFactory
{
  /**
   * The default value, whether calls to external functions are allowed or not. They are disallowed
   * by default, because that is what secure processing means for Saxon.
   */
  public static final boolean DEFAULT_ALLOW_EXTERNAL_FUNCTIONS = false;

  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronProcessorFactory.class);

  private static final class SingletonHolder
  {
    static final Processor INSTANCE = createProcessor ();
  }

  private static final AtomicBoolean ALLOW_EXTERNAL_FUNCTIONS = new AtomicBoolean (DEFAULT_ALLOW_EXTERNAL_FUNCTIONS);
  private static final ICommonsSet <String> ALLOWED_REMOTE_SCHEMES = new CommonsHashSet <> ();
  private static Consumer <Processor> s_aProcessorCustomizer;

  private SchematronProcessorFactory ()
  {}

  /**
   * @return The shared, secured default {@link Processor}. It is created on first access, so all
   *         the settings of this class must be applied before that. Never <code>null</code>.
   *         <p>
   *         The engines use this instance unless a different {@link Processor} is configured
   *         explicitly, so that the compilation caches - whose keys deliberately do not contain the
   *         identity of the processor - only ever hold artefacts that were compiled with it.
   *         </p>
   */
  @NonNull
  public static Processor getDefault ()
  {
    return SingletonHolder.INSTANCE;
  }

  /**
   * @return <code>true</code> if calls to external functions are allowed in all newly created
   *         {@link Processor} objects, <code>false</code> if not. The default is
   *         {@link #DEFAULT_ALLOW_EXTERNAL_FUNCTIONS}.
   * @see #setAllowExternalFunctions(boolean)
   */
  public static boolean isAllowExternalFunctions ()
  {
    return ALLOW_EXTERNAL_FUNCTIONS.get ();
  }

  /**
   * Allow or disallow calls to external functions for all {@link Processor} objects created
   * afterwards. They are disallowed by default, as that is the Saxon interpretation of secure
   * processing. Disallowing them also disables <code>xsl:result-document</code>, the no namespace
   * variant of <code>system-property()</code> and <code>environment-variable()</code>.
   * <p>
   * Note: {@link Processor} objects as well as the compiled artefacts derived from them are cached
   * internally. Therefore this method must be called <b>before</b> the first Schematron file is
   * processed - a later change has no effect on the already created artefacts.
   * </p>
   *
   * @param bAllowExternalFunctions
   *        <code>true</code> to allow external functions, <code>false</code> to disallow them.
   * @see #isAllowExternalFunctions()
   */
  public static void setAllowExternalFunctions (final boolean bAllowExternalFunctions)
  {
    ALLOW_EXTERNAL_FUNCTIONS.set (bAllowExternalFunctions);
  }

  /**
   * @return A mutable copy of the remote URL schemes (all lower case, e.g. "http") that newly
   *         created {@link Processor} objects are allowed to dereference. Empty by default. Never
   *         <code>null</code>.
   * @see #setAllowedRemoteSchemes(String...)
   */
  @NonNull
  @ReturnsMutableCopy
  public static ICommonsSet <String> getAllAllowedRemoteSchemes ()
  {
    synchronized (ALLOWED_REMOTE_SCHEMES)
    {
      return ALLOWED_REMOTE_SCHEMES.getClone ();
    }
  }

  /**
   * Set the remote URL schemes that all {@link Processor} objects created afterwards are allowed to
   * dereference. By default no remote scheme is allowed, to prevent Server Side Request Forgery
   * (SSRF). Local resources are always resolved regardless of this setting.
   * <p>
   * Note: {@link Processor} objects as well as the compiled artefacts derived from them are cached
   * internally. Therefore this method must be called <b>before</b> the first Schematron file is
   * processed - a later change has no effect on the already created artefacts.
   * </p>
   *
   * @param aAllowedRemoteSchemes
   *        The remote schemes to allow (e.g. "http", "https"). May be <code>null</code> or empty to
   *        deny all remote schemes.
   * @see #getAllAllowedRemoteSchemes()
   */
  public static void setAllowedRemoteSchemes (@Nullable final String... aAllowedRemoteSchemes)
  {
    synchronized (ALLOWED_REMOTE_SCHEMES)
    {
      ALLOWED_REMOTE_SCHEMES.clear ();
      if (aAllowedRemoteSchemes != null)
        for (final String sScheme : aAllowedRemoteSchemes)
          if (StringHelper.isNotEmpty (sScheme))
            ALLOWED_REMOTE_SCHEMES.add (sScheme.toLowerCase (Locale.ROOT));
    }
  }

  /**
   * Set an optional {@link Consumer} that is called for every {@link Processor} created by this
   * class, after the security defaults were applied. This may e.g. be used to register extension
   * functions or to deliberately relax a security setting.
   *
   * @param a
   *        The consumer to invoke. May be <code>null</code>.
   */
  public static void setProcessorCustomizer (@Nullable final Consumer <Processor> a)
  {
    s_aProcessorCustomizer = a;
  }

  /**
   * @return The global {@link Processor} customizer. May be <code>null</code>.
   */
  @Nullable
  public static Consumer <Processor> getProcessorCustomizer ()
  {
    return s_aProcessorCustomizer;
  }

  /**
   * Apply the Schematron security defaults to the provided {@link Processor}, using the globally
   * configured allowed remote schemes.
   *
   * @param aProcessor
   *        The processor to secure. May not be <code>null</code>.
   * @see #makeProcessorSecure(Processor, String...)
   */
  public static void makeProcessorSecure (@NonNull final Processor aProcessor)
  {
    makeProcessorSecure (aProcessor, getAllAllowedRemoteSchemes ().toArray (String []::new));
  }

  /**
   * Apply the Schematron security defaults to the provided {@link Processor}.
   *
   * @param aProcessor
   *        The processor to secure. May not be <code>null</code>.
   * @param aAllowedRemoteSchemes
   *        The remote URL schemes that may be dereferenced (as in "http" or "https"). If none is
   *        provided, all remote resource access is denied.
   */
  public static void makeProcessorSecure (@NonNull final Processor aProcessor,
                                          @Nullable final String... aAllowedRemoteSchemes)
  {
    ValueEnforcer.notNull (aProcessor, "Processor");

    final boolean bAllowExternalFunctions = isAllowExternalFunctions ();
    final boolean bAllowXInclude = SchematronTransformerFactory.isAllowXInclude ();

    /*
     * This is what Saxon does for XMLConstants.FEATURE_SECURE_PROCESSING. It disables
     * "xsl:result-document", the no namespace variant of "system-property()" and
     * "environment-variable()", but not the programmatically registered extension functions, which
     * Saxon considers trusted.
     */
    aProcessor.setConfigurationProperty (Feature.ALLOW_EXTERNAL_FUNCTIONS,
                                         Boolean.valueOf (bAllowExternalFunctions));

    // Allow XInclude #86 - disabled by default for security reasons
    aProcessor.setConfigurationProperty (Feature.XINCLUDE, Boolean.valueOf (bAllowXInclude));

    /*
     * Deny the remote resource access of "doc()", "document()", "unparsed-text()", "collection()",
     * "json-doc()" and of the external entities of the documents that Saxon parses itself. The
     * resolver is chained in front of the existing one, so that the catalog based resolution of the
     * local resources keeps working.
     */
    final Configuration aConfig = aProcessor.getUnderlyingConfiguration ();
    final SaxonSecureResourceResolver aSecureResolver = new SaxonSecureResourceResolver ().setAllowedRemoteSchemes (aAllowedRemoteSchemes);
    aConfig.setResourceResolver (new ChainedResourceResolver (aSecureResolver, aConfig.getResourceResolver ()));

    if (LOGGER.isDebugEnabled ())
      LOGGER.debug ("Secured Saxon Processor " +
                    aProcessor +
                    " (external functions=" +
                    bAllowExternalFunctions +
                    "; XInclude=" +
                    bAllowXInclude +
                    "; allowed remote schemes=" +
                    aSecureResolver.getAllAllowedRemoteSchemes () +
                    ")");
  }

  /**
   * Create a new Saxon {@link Processor} for the non-licensed (Saxon-HE) edition with the standard
   * Schematron security defaults applied.
   *
   * @return A new {@link Processor} and never <code>null</code>.
   * @see #createProcessor(boolean)
   */
  @NonNull
  public static Processor createProcessor ()
  {
    return createProcessor (false);
  }

  /**
   * Create a new Saxon {@link Processor} with the standard Schematron security defaults applied.
   *
   * @param bLicensedEdition
   *        <code>true</code> to request a licensed Saxon edition (PE or EE), <code>false</code> for
   *        Saxon-HE.
   * @return A new {@link Processor} and never <code>null</code>.
   */
  @NonNull
  public static Processor createProcessor (final boolean bLicensedEdition)
  {
    final Processor aProcessor = new Processor (bLicensedEdition);
    makeProcessorSecure (aProcessor);

    // Call the customizer last, so that it can also relax a security setting
    if (s_aProcessorCustomizer != null)
      s_aProcessorCustomizer.accept (aProcessor);

    return aProcessor;
  }
}
