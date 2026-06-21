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

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

/**
 * Callback interface for per-template telemetry of XSLT-based Schematron validation. When set on an
 * XSLT-based engine configuration, the engine will compile the stylesheet with Saxon tracing
 * enabled (separate cache entry) and emit one {@link #onTemplateEnter(SchematronTemplateInfo)} /
 * {@link #onTemplateLeave(SchematronTemplateInfo, long)} pair per executed XSLT template.
 * <p>
 * Enabling telemetry forces Saxon's {@code FeatureKeys.COMPILE_WITH_TRACING}, which disables
 * several optimisations and typically costs 1.5&times;&ndash;3&times; wall-clock per transform.
 * Trace-enabled providers are cached under a separate key &mdash; the first call with telemetry
 * triggers a fresh compilation.
 * <p>
 * All methods have empty default implementations so consumers can override only what they need.
 * Implementations must be thread-safe if shared across concurrent transforms.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
public interface ISchematronTemplateTelemetry
{
  /**
   * Called once at the start of a transform, before any template events.
   */
  default void onTransformStart ()
  {}

  /**
   * Called when Saxon enters an XSLT template (either a match template or a named template).
   *
   * @param aInfo
   *        Static information about the template. Never <code>null</code>.
   */
  default void onTemplateEnter (@NonNull final SchematronTemplateInfo aInfo)
  {}

  /**
   * Called when Saxon leaves an XSLT template. Paired with a preceding call to
   * {@link #onTemplateEnter(SchematronTemplateInfo)} for the same template; the {@code aInfo}
   * value may or may not be the same instance.
   *
   * @param aInfo
   *        Static information about the template. Never <code>null</code>.
   * @param nDurationNanos
   *        The wall-clock duration of the template execution in nanoseconds. This is an
   *        <em>inclusive</em> measurement &mdash; it covers the time spent in nested template
   *        calls as well. To derive per-frame self time (e.g. for a flamegraph), the consumer
   *        must subtract the inclusive durations of all directly nested {@code onTemplateLeave}
   *        events that occurred before this one for the same enter/leave pair.
   */
  default void onTemplateLeave (@NonNull final SchematronTemplateInfo aInfo, final long nDurationNanos)
  {}

  /**
   * Called once at the end of a transform, after the last template event. Invoked even when the
   * transform throws.
   */
  default void onTransformEnd ()
  {}

  /**
   * Compose this telemetry with another - all callbacks fire on this one first, then the passed one.
   *
   * @param rhs
   *        The telemetry to invoke after this one. May be <code>null</code>.
   * @return A composed telemetry, or this when {@code rhs} is <code>null</code>. Never
   *         <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  default ISchematronTemplateTelemetry and (@Nullable final ISchematronTemplateTelemetry rhs)
  {
    return and (this, rhs);
  }

  /**
   * Compose two telemetry callbacks. All methods of {@code lhs} fire before {@code rhs}.
   *
   * @param lhs
   *        The first telemetry. May be <code>null</code>.
   * @param rhs
   *        The second telemetry. May be <code>null</code>.
   * @return The composed telemetry, or whichever of the two is non-<code>null</code>, or
   *         <code>null</code> when both are <code>null</code>.
   * @since 10.0.0
   */
  @Nullable
  static ISchematronTemplateTelemetry and (@Nullable final ISchematronTemplateTelemetry lhs,
                                           @Nullable final ISchematronTemplateTelemetry rhs)
  {
    if (lhs == null)
      return rhs;
    if (rhs == null)
      return lhs;

    return new ISchematronTemplateTelemetry ()
    {
      @Override
      public void onTransformStart ()
      {
        lhs.onTransformStart ();
        rhs.onTransformStart ();
      }

      @Override
      public void onTemplateEnter (@NonNull final SchematronTemplateInfo aInfo)
      {
        lhs.onTemplateEnter (aInfo);
        rhs.onTemplateEnter (aInfo);
      }

      @Override
      public void onTemplateLeave (@NonNull final SchematronTemplateInfo aInfo, final long nDurationNanos)
      {
        lhs.onTemplateLeave (aInfo, nDurationNanos);
        rhs.onTemplateLeave (aInfo, nDurationNanos);
      }

      @Override
      public void onTransformEnd ()
      {
        lhs.onTransformEnd ();
        rhs.onTransformEnd ();
      }
    };
  }
}
