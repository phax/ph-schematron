/*
 * Copyright (C) 2020-2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.schxslt.xslt2;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.annotation.concurrent.ThreadSafe;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.SchematronException;

/**
 * Legacy static facade for the SchXslt 1.x compilation cache. Since v10.0.0 this is a thin wrapper
 * around {@link SchematronSchXslt_XSLT2Cache#shared()}; prefer the new API
 * ({@link SchematronSchXslt_XSLT2Config}, {@link SchematronSchXslt_XSLT2Cache},
 * {@link SchematronSchXslt_XSLT2}).
 *
 * @author Philip Helger
 * @deprecated Use {@link SchematronSchXslt_XSLT2Cache#shared()} and the
 *             {@link SchematronSchXslt_XSLT2Config} builder instead.
 */
@Deprecated (since = "10.0.0", forRemoval = false)
@ThreadSafe
public final class SchematronResourceSchXslt_XSLT2Cache
{
  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronResourceSchXslt_XSLT2Cache.class);

  private SchematronResourceSchXslt_XSLT2Cache ()
  {}

  /**
   * @deprecated Use
   *             {@link SchematronSchXslt_XSLT2Cache#compileUncached(IReadableResource, TransformerCustomizerSchXslt_XSLT2)}
   *             instead.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @Nullable
  public static SchematronProviderXSLTFromSchXslt_XSLT2 createSchematronXSLTProvider (@NonNull final IReadableResource aSchematronResource,
                                                                                      @NonNull final TransformerCustomizerSchXslt_XSLT2 aTransformerCustomizer)
  {
    return SchematronSchXslt_XSLT2Cache.compileUncached (aSchematronResource, aTransformerCustomizer);
  }

  @Deprecated (since = "10.0.0", forRemoval = false)
  @Nullable
  public static SchematronProviderXSLTFromSchXslt_XSLT2 getSchematronXSLTProvider (@NonNull final IReadableResource aSchematronResource,
                                                                                   @NonNull final TransformerCustomizerSchXslt_XSLT2 aTransformerCustomizer)
  {
    ValueEnforcer.notNull (aSchematronResource, "SchematronResource");
    ValueEnforcer.notNull (aTransformerCustomizer, "TransformerCustomizer");

    if (!aSchematronResource.exists ())
    {
      LOGGER.warn ("Schematron resource " + aSchematronResource + " does not exist!");
      return null;
    }

    if (!aTransformerCustomizer.canCacheResult ())
      return createSchematronXSLTProvider (aSchematronResource, aTransformerCustomizer);

    final SchematronSchXslt_XSLT2Config aConfig = SchematronSchXslt_XSLT2Config.builder (aSchematronResource)
                                                                               .phase (aTransformerCustomizer.getPhase ())
                                                                               .languageCode (aTransformerCustomizer.getLanguageCode ())
                                                                               .errorListener (aTransformerCustomizer.getErrorListener ())
                                                                               .uriResolver (aTransformerCustomizer.getURIResolver ())
                                                                               .parameters (aTransformerCustomizer.getParameters ())
                                                                               .forceCacheResult (aTransformerCustomizer.isForceCacheResult ())
                                                                               .build ();
    try
    {
      return (SchematronProviderXSLTFromSchXslt_XSLT2) SchematronSchXslt_XSLT2Cache.shared ().getOrCompile (aConfig);
    }
    catch (final SchematronException ex)
    {
      throw new IllegalStateException ("Failed to compile Schematron", ex);
    }
  }

  @Deprecated (since = "10.0.0", forRemoval = false)
  public static void clearCache ()
  {
    SchematronSchXslt_XSLT2Cache.shared ().clear ();
  }
}
