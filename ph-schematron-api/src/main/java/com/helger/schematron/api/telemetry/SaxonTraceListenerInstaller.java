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
package com.helger.schematron.api.telemetry;

import javax.xml.transform.Transformer;

import org.jspecify.annotations.NonNull;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.state.EChange;

import net.sf.saxon.jaxp.TransformerImpl;
import net.sf.saxon.lib.TraceListener;

/**
 * Helper that installs a Saxon {@link TraceListener} on a JAXP {@link Transformer} by unwrapping to
 * the underlying Saxon controller. Used by the XSLT-based engines to wire telemetry into a freshly
 * obtained transformer just before invocation.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
@Immutable
public final class SaxonTraceListenerInstaller
{
  private static final Logger LOGGER = LoggerFactory.getLogger (SaxonTraceListenerInstaller.class);

  private SaxonTraceListenerInstaller ()
  {}

  /**
   * Attach the given {@link TraceListener} to the underlying Saxon controller of the JAXP
   * transformer. If the transformer is not Saxon-based (e.g. a foreign engine somehow ended up in
   * use), a warning is logged and the call has no effect.
   *
   * @param aTransformer
   *        The JAXP transformer to install on. May not be <code>null</code>.
   * @param aListener
   *        The trace listener to install. May not be <code>null</code>.
   * @return {@link EChange#CHANGED} if the listener was installed, {@link EChange#UNCHANGED}
   *         otherwise.
   */
  @NonNull
  public static EChange install (@NonNull final Transformer aTransformer, @NonNull final TraceListener aListener)
  {
    ValueEnforcer.notNull (aTransformer, "Transformer");
    ValueEnforcer.notNull (aListener, "Listener");

    if (!(aTransformer instanceof final TransformerImpl aSaxonTransformer))
    {
      LOGGER.warn ("Cannot install Saxon TraceListener: transformer is not a Saxon TransformerImpl (was " +
                   aTransformer.getClass ().getName () +
                   "); template telemetry will not be emitted.");
      return EChange.UNCHANGED;
    }

    aSaxonTransformer.getUnderlyingController ().setTraceListener (aListener);
    return EChange.CHANGED;
  }
}
