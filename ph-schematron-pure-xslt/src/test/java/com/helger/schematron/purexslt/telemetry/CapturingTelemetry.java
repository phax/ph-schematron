/*
 * Copyright (C) 2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.purexslt.telemetry;

import java.util.concurrent.atomic.AtomicLong;
import java.util.function.LongSupplier;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.concurrent.ThreadSafe;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.CommonsHashMap;
import com.helger.collection.commons.CommonsLinkedHashMap;
import com.helger.collection.commons.ICommonsList;
import com.helger.collection.commons.ICommonsMap;
import com.helger.collection.commons.ICommonsOrderedMap;
import com.helger.telemetry.ETelemetrySpanKind;
import com.helger.telemetry.ITelemetryCounter;
import com.helger.telemetry.ITelemetryGauge;
import com.helger.telemetry.ITelemetryHistogram;
import com.helger.telemetry.ITelemetryMeterSPI;
import com.helger.telemetry.ITelemetrySpan;
import com.helger.telemetry.ITelemetryTracerSPI;
import com.helger.telemetry.ITelemetryUpDownCounter;
import com.helger.telemetry.TelemetryAttributes;

/**
 * In-memory capturing tracer + meter for ph-telemetry, intended for unit tests. Install via
 * {@code Telemetry.install (capt)} and {@code TelemetryMetrics.install (capt)} in a JUnit
 * {@link org.junit.Before} method, run the unit under test, and inspect via {@link #getSpans()},
 * {@link #getCounterValue(String)} and {@link #getHistogramValues(String)}. Restore the default
 * SPIs in an {@link org.junit.After} method by passing {@code null} to each install call.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
@ThreadSafe
public final class CapturingTelemetry implements ITelemetryTracerSPI, ITelemetryMeterSPI
{
  /**
   * Snapshot of one captured span. Implements {@link ITelemetrySpan} so the
   * {@link ITelemetryTracerSPI#startSpan(String, ETelemetrySpanKind)} contract is satisfied. Tests
   * inspect the recorded data through the accessor methods.
   *
   * @author Philip Helger
   * @since 10.0.0
   */
  public static final class CapturedSpan implements ITelemetrySpan
  {
    private final String m_sName;
    private final ETelemetrySpanKind m_eKind;
    private final ICommonsOrderedMap <String, Object> m_aAttributes = new CommonsLinkedHashMap <> ();
    private boolean m_bClosed;
    private boolean m_bStatusOk;
    private boolean m_bStatusError;
    private String m_sStatusMessage;
    private Throwable m_aRecordedException;

    /**
     * @param sName
     *        The span name. Never <code>null</code>.
     * @param eKind
     *        The span kind. Never <code>null</code>.
     */
    public CapturedSpan (@NonNull final String sName, @NonNull final ETelemetrySpanKind eKind)
    {
      m_sName = sName;
      m_eKind = eKind;
    }

    /**
     * @return The span name as passed to
     *         {@link ITelemetryTracerSPI#startSpan(String, ETelemetrySpanKind)}. Never
     *         <code>null</code>.
     */
    @NonNull
    public String getName ()
    {
      return m_sName;
    }

    /**
     * @return The span kind. Never <code>null</code>.
     */
    @NonNull
    public ETelemetrySpanKind getKind ()
    {
      return m_eKind;
    }

    /**
     * @return The attributes recorded on the span via the {@code setAttribute(...)} overloads, in
     *         insertion order. The returned map is live &mdash; callers must not mutate it.
     */
    @NonNull
    public ICommonsOrderedMap <String, Object> getAttributes ()
    {
      return m_aAttributes;
    }

    /**
     * @return <code>true</code> if {@link #close()} was called on this span.
     */
    public boolean isClosed ()
    {
      return m_bClosed;
    }

    /**
     * @return <code>true</code> if {@link #setStatusOk()} was called.
     */
    public boolean isStatusOk ()
    {
      return m_bStatusOk;
    }

    /**
     * @return <code>true</code> if {@link #setStatusError(String)} was called.
     */
    public boolean isStatusError ()
    {
      return m_bStatusError;
    }

    /**
     * @return The error message passed to {@link #setStatusError(String)}. May be <code>null</code>.
     */
    @Nullable
    public String getStatusMessage ()
    {
      return m_sStatusMessage;
    }

    /**
     * @return The exception passed to {@link #recordException(Throwable)}. May be <code>null</code>.
     */
    @Nullable
    public Throwable getRecordedException ()
    {
      return m_aRecordedException;
    }

    @Override
    @NonNull
    public ITelemetrySpan setAttribute (@NonNull final String sKey, @Nullable final String sValue)
    {
      m_aAttributes.put (sKey, sValue);
      return this;
    }

    @Override
    @NonNull
    public ITelemetrySpan setAttribute (@NonNull final String sKey, final boolean bValue)
    {
      m_aAttributes.put (sKey, Boolean.valueOf (bValue));
      return this;
    }

    @Override
    @NonNull
    public ITelemetrySpan setAttribute (@NonNull final String sKey, final long nValue)
    {
      m_aAttributes.put (sKey, Long.valueOf (nValue));
      return this;
    }

    @Override
    @NonNull
    public ITelemetrySpan setAttribute (@NonNull final String sKey, final double dValue)
    {
      m_aAttributes.put (sKey, Double.valueOf (dValue));
      return this;
    }

    @Override
    @NonNull
    public ITelemetrySpan recordException (@NonNull final Throwable aException)
    {
      m_aRecordedException = aException;
      return this;
    }

    @Override
    @NonNull
    public ITelemetrySpan addEvent (@NonNull final String sName, @NonNull final TelemetryAttributes aAttributes)
    {
      return this;
    }

    @Override
    @NonNull
    public ITelemetrySpan setStatusOk ()
    {
      m_bStatusOk = true;
      return this;
    }

    @Override
    @NonNull
    public ITelemetrySpan setStatusError (@Nullable final String sMessage)
    {
      m_bStatusError = true;
      m_sStatusMessage = sMessage;
      return this;
    }

    @Override
    public void close ()
    {
      m_bClosed = true;
    }
  }

  private final ICommonsList <CapturedSpan> m_aSpans = new CommonsArrayList <> ();
  private final ICommonsMap <String, AtomicLong> m_aCounters = new CommonsHashMap <> ();
  private final ICommonsMap <String, ICommonsList <Double>> m_aHistograms = new CommonsHashMap <> ();

  // === ITelemetryTracerSPI ===

  @Override
  @NonNull
  public ITelemetrySpan startSpan (@NonNull final String sName, @NonNull final ETelemetrySpanKind eKind)
  {
    final CapturedSpan aSpan = new CapturedSpan (sName, eKind);
    synchronized (m_aSpans)
    {
      m_aSpans.add (aSpan);
    }
    return aSpan;
  }

  // === ITelemetryMeterSPI ===

  @Override
  @NonNull
  public ITelemetryCounter createCounter (@NonNull final String sName,
                                          @Nullable final String sDescription,
                                          @Nullable final String sUnit)
  {
    final AtomicLong aAgg;
    synchronized (m_aCounters)
    {
      aAgg = m_aCounters.computeIfAbsent (sName, x -> new AtomicLong ());
    }
    return (nValue, aAttrs) -> aAgg.addAndGet (nValue);
  }

  @Override
  @NonNull
  public ITelemetryUpDownCounter createUpDownCounter (@NonNull final String sName,
                                                      @Nullable final String sDescription,
                                                      @Nullable final String sUnit)
  {
    final AtomicLong aAgg;
    synchronized (m_aCounters)
    {
      aAgg = m_aCounters.computeIfAbsent (sName, x -> new AtomicLong ());
    }
    return (nValue, aAttrs) -> aAgg.addAndGet (nValue);
  }

  @Override
  @NonNull
  public ITelemetryHistogram createHistogram (@NonNull final String sName,
                                              @Nullable final String sDescription,
                                              @Nullable final String sUnit)
  {
    final ICommonsList <Double> aValues;
    synchronized (m_aHistograms)
    {
      aValues = m_aHistograms.computeIfAbsent (sName, x -> new CommonsArrayList <> ());
    }
    return (dValue, aAttrs) -> {
      synchronized (aValues)
      {
        aValues.add (Double.valueOf (dValue));
      }
    };
  }

  @Override
  @NonNull
  public ITelemetryGauge createGauge (@NonNull final String sName,
                                      @Nullable final String sDescription,
                                      @Nullable final String sUnit,
                                      @NonNull final LongSupplier aSupplier)
  {
    return () -> { /* nothing to record - the gauge is poll-based and no backend polls in tests */ };
  }

  // === Inspection helpers ===

  /**
   * @return A defensive copy of every captured span in start order. Never <code>null</code>; may be
   *         empty.
   */
  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <CapturedSpan> getSpans ()
  {
    synchronized (m_aSpans)
    {
      return m_aSpans.getClone ();
    }
  }

  /**
   * Count the spans whose name equals the given value.
   *
   * @param sName
   *        The span name to match. Never <code>null</code>.
   * @return The number of captured spans whose {@link CapturedSpan#getName()} is {@code sName}.
   */
  public long countSpansNamed (@NonNull final String sName)
  {
    synchronized (m_aSpans)
    {
      return m_aSpans.stream ().filter (x -> sName.equals (x.getName ())).count ();
    }
  }

  /**
   * @param sName
   *        The counter name. Never <code>null</code>.
   * @return The current aggregated value of the counter with this name, or {@code 0} if no counter
   *         was ever recorded under this name.
   */
  public long getCounterValue (@NonNull final String sName)
  {
    final AtomicLong aAgg;
    synchronized (m_aCounters)
    {
      aAgg = m_aCounters.get (sName);
    }
    return aAgg == null ? 0L : aAgg.get ();
  }

  /**
   * @param sName
   *        The histogram name. Never <code>null</code>.
   * @return A defensive copy of every value recorded against this histogram, in record order. Empty
   *         if no histogram was ever recorded under this name.
   */
  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <Double> getHistogramValues (@NonNull final String sName)
  {
    final ICommonsList <Double> aValues;
    synchronized (m_aHistograms)
    {
      aValues = m_aHistograms.get (sName);
    }
    if (aValues == null)
      return new CommonsArrayList <> ();
    synchronized (aValues)
    {
      return aValues.getClone ();
    }
  }

  /**
   * Clear all captured spans, counters and histograms. Convenient between sub-tests in the same
   * JUnit class.
   */
  public void reset ()
  {
    synchronized (m_aSpans)
    {
      m_aSpans.clear ();
    }
    synchronized (m_aCounters)
    {
      m_aCounters.clear ();
    }
    synchronized (m_aHistograms)
    {
      m_aHistograms.clear ();
    }
  }
}
