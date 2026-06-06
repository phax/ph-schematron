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

import java.util.ArrayDeque;
import java.util.Deque;
import java.util.Map;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.timing.StopWatch;

import net.sf.saxon.Controller;
import net.sf.saxon.expr.XPathContext;
import net.sf.saxon.expr.instruct.NamedTemplate;
import net.sf.saxon.expr.instruct.TemplateRule;
import net.sf.saxon.lib.TraceListener;
import net.sf.saxon.om.StructuredQName;
import net.sf.saxon.s9api.Location;
import net.sf.saxon.trace.Traceable;

/**
 * Internal Saxon {@link TraceListener} that bridges per-template trace events to the abstract
 * {@link ISchematronTemplateTelemetry} callback. Filters Saxon's traceable constructs down to XSLT
 * templates (match templates and named templates) &mdash; other traceables (functions, instructions,
 * &hellip;) are ignored.
 * <p>
 * One instance is dedicated to a single transform: it carries a stack of {@link StopWatch} timers
 * to measure nested template execution. Do not share across concurrent transforms.
 * <p>
 * Trace events are only delivered when the stylesheet has been compiled with Saxon's
 * {@code FeatureKeys.COMPILE_WITH_TRACING} feature; the XSLT-based engines opt in to that when an
 * {@link ISchematronTemplateTelemetry} is set.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
@NotThreadSafe
public final class SchematronTraceListener implements TraceListener
{
  private final ISchematronTemplateTelemetry m_aTelemetry;
  private final Deque <SchematronTemplateInfo> m_aInfoStack = new ArrayDeque <> ();
  private final Deque <StopWatch> m_aTimerStack = new ArrayDeque <> ();

  /**
   * @param aTelemetry
   *        The telemetry callback to which template events are dispatched. May not be
   *        <code>null</code>.
   */
  public SchematronTraceListener (@NonNull final ISchematronTemplateTelemetry aTelemetry)
  {
    ValueEnforcer.notNull (aTelemetry, "Telemetry");
    m_aTelemetry = aTelemetry;
  }

  private static boolean _isTemplate (@Nullable final Traceable aTraceable)
  {
    return aTraceable instanceof TemplateRule || aTraceable instanceof NamedTemplate;
  }

  @NonNull
  private static SchematronTemplateInfo _toInfo (@NonNull final Traceable aTraceable)
  {
    final StructuredQName aName = aTraceable.getObjectName ();
    final String sName = aName == null ? null : aName.getClarkName ();

    String sMatchPattern = null;
    if (aTraceable instanceof final TemplateRule aRule)
    {
      final var aPattern = aRule.getMatchPattern ();
      if (aPattern != null)
        sMatchPattern = aPattern.toShortString ();
    }

    final Location aLocation = aTraceable.getLocation ();
    final String sSystemID = aLocation == null ? null : aLocation.getSystemId ();
    final int nLineNumber = aLocation == null ? -1 : aLocation.getLineNumber ();

    return new SchematronTemplateInfo (sName, sMatchPattern, sSystemID, nLineNumber);
  }

  @Override
  public void open (final Controller aController)
  {
    m_aTelemetry.onTransformStart ();
  }

  @Override
  public void enter (final Traceable aInstruction,
                     final Map <String, Object> aProperties,
                     final XPathContext aContext)
  {
    if (!_isTemplate (aInstruction))
      return;

    final SchematronTemplateInfo aInfo = _toInfo (aInstruction);
    m_aInfoStack.push (aInfo);
    m_aTimerStack.push (StopWatch.createdStarted ());
    m_aTelemetry.onTemplateEnter (aInfo);
  }

  @Override
  public void leave (final Traceable aInstruction)
  {
    if (!_isTemplate (aInstruction))
      return;
    if (m_aInfoStack.isEmpty () || m_aTimerStack.isEmpty ())
    {
      // Unbalanced (e.g. dynamic error inside enter without matching leave); ignore.
      return;
    }

    final SchematronTemplateInfo aInfo = m_aInfoStack.pop ();
    final StopWatch aTimer = m_aTimerStack.pop ();
    m_aTelemetry.onTemplateLeave (aInfo, aTimer.getNanos ());
  }

  @Override
  public void close ()
  {
    m_aTelemetry.onTransformEnd ();
  }
}
