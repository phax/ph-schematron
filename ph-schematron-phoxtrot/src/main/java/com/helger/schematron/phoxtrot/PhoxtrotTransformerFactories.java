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

import java.util.Locale;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicLong;
import java.util.concurrent.atomic.AtomicReference;

import javax.xml.transform.ErrorListener;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.URIResolver;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.annotation.concurrent.ThreadSafe;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.phoxtrot.xpath.EThreading;
import com.helger.phoxtrot.xslt.XsltTransformRequest;
import com.helger.phoxtrot.xslt.jaxp.PhoxtrotTransformerFactory;
import com.helger.xml.XMLFactory;
import com.helger.xml.transform.DefaultTransformURIResolver;
import com.helger.xml.transform.LoggingTransformErrorListener;

/**
 * Creates the phoxtrot {@link TransformerFactory} instances for Schematron, configured like the
 * Saxon ones: secure processing (see {@link XMLFactory#defaultCustomizeTransformerFactory(TransformerFactory)}),
 * plus the phoxtrot specific step limit, depth limit and threading.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@ThreadSafe
public final class PhoxtrotTransformerFactories
{
  /** By default there is no step limit, as with Saxon */
  public static final long DEFAULT_MAX_STEPS = XsltTransformRequest.UNLIMITED_STEPS;
  /**
   * By default there is no nesting depth limit of templates and functions, as with Saxon: only the
   * stack of the thread limits it (a stack overflow fails with XPDY0130)
   */
  public static final int DEFAULT_MAX_DEPTH = XsltTransformRequest.UNLIMITED_DEPTH;
  /** By default the transformations run on the phoxtrot thread pool with a large stack */
  public static final EThreading DEFAULT_THREADING = EThreading.THREAD_POOL;

  private static final Logger LOGGER = LoggerFactory.getLogger (PhoxtrotTransformerFactories.class);

  private static final AtomicLong MAX_STEPS = new AtomicLong (DEFAULT_MAX_STEPS);
  private static final AtomicInteger MAX_DEPTH = new AtomicInteger (DEFAULT_MAX_DEPTH);
  private static final AtomicReference <EThreading> THREADING = new AtomicReference <> (DEFAULT_THREADING);

  private static final class SingletonHolder
  {
    static final TransformerFactory INSTANCE = createTransformerFactory (new LoggingTransformErrorListener (Locale.US),
                                                                         new DefaultTransformURIResolver ());
  }

  private PhoxtrotTransformerFactories ()
  {}

  /**
   * @return The shared default factory. It is created on the first call with the settings valid at
   *         that time. Never <code>null</code>.
   */
  @NonNull
  public static TransformerFactory getDefault ()
  {
    return SingletonHolder.INSTANCE;
  }

  /**
   * @return The step limit of transformations of new factories.
   *         {@link XsltTransformRequest#UNLIMITED_STEPS} for no limit. Default is
   *         {@link #DEFAULT_MAX_STEPS}.
   */
  public static long getMaxSteps ()
  {
    return MAX_STEPS.get ();
  }

  /**
   * Set the step limit of transformations of new factories. A transformation that exceeds it fails
   * with the error XPDY0130. Changing it does not affect factories that were already created,
   * including the default factory if it was already used.
   *
   * @param nMaxSteps
   *        The maximum number of steps. Must be &gt; 0. {@link XsltTransformRequest#UNLIMITED_STEPS}
   *        for no limit.
   */
  public static void setMaxSteps (final long nMaxSteps)
  {
    ValueEnforcer.isGT0 (nMaxSteps, "MaxSteps");
    MAX_STEPS.set (nMaxSteps);
  }

  /**
   * @return The nesting depth limit of templates and functions of transformations of new factories.
   *         {@link XsltTransformRequest#UNLIMITED_DEPTH} for no limit. Default is
   *         {@link #DEFAULT_MAX_DEPTH}.
   */
  public static int getMaxDepth ()
  {
    return MAX_DEPTH.get ();
  }

  /**
   * Set the nesting depth limit of templates and functions of transformations of new factories. A
   * transformation that exceeds it fails with the error XPDY0130. Changing it does not affect
   * factories that were already created, including the default factory if it was already used.
   *
   * @param nMaxDepth
   *        The maximum nesting depth. Must be &gt; 0. {@link XsltTransformRequest#UNLIMITED_DEPTH}
   *        for no limit other than the stack of the thread.
   */
  public static void setMaxDepth (final int nMaxDepth)
  {
    ValueEnforcer.isGT0 (nMaxDepth, "MaxDepth");
    MAX_DEPTH.set (nMaxDepth);
  }

  /**
   * @return The thread on which compilations and transformations of new factories run. Never
   *         <code>null</code>. Default is {@link #DEFAULT_THREADING}.
   */
  @NonNull
  public static EThreading getThreading ()
  {
    return THREADING.get ();
  }

  /**
   * Set the thread on which compilations and transformations of new factories run. Changing it does
   * not affect factories that were already created, including the default factory if it was already
   * used. Note: {@link EThreading#CALLING_THREAD} uses the stack of the caller, which may be too
   * small for deeply recursive stylesheets.
   *
   * @param eThreading
   *        The threading to use. May not be <code>null</code>.
   */
  public static void setThreading (@NonNull final EThreading eThreading)
  {
    ValueEnforcer.notNull (eThreading, "Threading");
    THREADING.set (eThreading);
  }

  /**
   * Create a new phoxtrot {@link TransformerFactory} with secure processing, the step limit of
   * {@link #getMaxSteps()}, the depth limit of {@link #getMaxDepth()} and the threading of
   * {@link #getThreading()}.
   *
   * @return A new factory. Never <code>null</code>.
   */
  @NonNull
  public static TransformerFactory createTransformerFactory ()
  {
    final TransformerFactory aFactory = new PhoxtrotTransformerFactory ();
    XMLFactory.defaultCustomizeTransformerFactory (aFactory);
    aFactory.setAttribute (PhoxtrotTransformerFactory.ATTR_MAX_STEPS, Long.valueOf (getMaxSteps ()));
    aFactory.setAttribute (PhoxtrotTransformerFactory.ATTR_MAX_DEPTH, Integer.valueOf (getMaxDepth ()));
    aFactory.setAttribute (PhoxtrotTransformerFactory.ATTR_THREADING, getThreading ());

    if (LOGGER.isDebugEnabled ())
      LOGGER.debug ("Created TransformerFactory is " + aFactory);
    return aFactory;
  }

  /**
   * Create a new phoxtrot {@link TransformerFactory} like {@link #createTransformerFactory()} with
   * the provided error listener and URI resolver.
   *
   * @param aErrorListener
   *        The error listener to set. May be <code>null</code>.
   * @param aURIResolver
   *        The URI resolver to set. May be <code>null</code>.
   * @return A new factory. Never <code>null</code>.
   */
  @NonNull
  public static TransformerFactory createTransformerFactory (@Nullable final ErrorListener aErrorListener,
                                                             @Nullable final URIResolver aURIResolver)
  {
    final TransformerFactory aFactory = createTransformerFactory ();
    if (aErrorListener != null)
      aFactory.setErrorListener (aErrorListener);
    if (aURIResolver != null)
      aFactory.setURIResolver (aURIResolver);
    return aFactory;
  }
}
