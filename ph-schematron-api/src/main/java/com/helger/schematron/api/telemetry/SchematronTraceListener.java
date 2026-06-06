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

import java.util.Map;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.timing.StopWatch;
import com.helger.collection.stack.NonBlockingStack;

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
 * templates (match templates and named templates) &mdash; other traceables (functions,
 * instructions, &hellip;) are ignored.
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
  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronTraceListener.class);

  private final ISchematronTemplateTelemetry m_aTelemetry;
  private final NonBlockingStack <SchematronTemplateInfo> m_aInfoStack = new NonBlockingStack <> ();
  private final NonBlockingStack <StopWatch> m_aTimerStack = new NonBlockingStack <> ();

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
  private static String _describe (@Nullable final Traceable aTraceable)
  {
    if (aTraceable == null)
      return "null";

    final StringBuilder aSB = new StringBuilder ();
    aSB.append (aTraceable.getClass ().getSimpleName ());

    final StructuredQName aName = aTraceable.getObjectName ();
    if (aName != null)
      aSB.append (" name='").append (aName.getClarkName ()).append ("'");

    if (aTraceable instanceof final TemplateRule aRule)
    {
      final var aPattern = aRule.getMatchPattern ();
      if (aPattern != null)
        aSB.append (" match='").append (aPattern.toShortString ()).append ("'");
      final var aMode = aRule.getMode ();
      if (aMode != null && aMode.getModeName () != null)
        aSB.append (" mode='").append (aMode.getModeName ().getClarkName ()).append ("'");
    }
    else
      if (aTraceable instanceof final NamedTemplate aNamed)
      {
        final StructuredQName aTemplateName = aNamed.getTemplateName ();
        if (aTemplateName != null)
          aSB.append (" templateName='").append (aTemplateName.getClarkName ()).append ("'");
      }

    final Location aLocation = aTraceable.getLocation ();
    if (aLocation != null)
    {
      final String sSystemID = aLocation.getSystemId ();
      if (sSystemID != null)
        aSB.append (" systemID=").append (sSystemID);
      aSB.append (" line=").append (aLocation.getLineNumber ());
    }
    return aSB.toString ();
  }

  @NonNull
  private static SchematronTemplateInfo _toInfo (@NonNull final Traceable aTraceable)
  {
    final StructuredQName aName = aTraceable.getObjectName ();
    final String sName = aName == null ? null : aName.getClarkName ();

    String sMatchPattern = null;
    String sMode = null;
    if (aTraceable instanceof final TemplateRule aRule)
    {
      final var aPattern = aRule.getMatchPattern ();
      if (aPattern != null)
        sMatchPattern = aPattern.toShortString ();
      final var aMode = aRule.getMode ();
      if (aMode != null && aMode.getModeName () != null)
        sMode = aMode.getModeName ().getClarkName ();
    }

    final Location aLocation = aTraceable.getLocation ();
    final String sSystemID = aLocation == null ? null : aLocation.getSystemId ();
    final int nLineNumber = aLocation == null ? -1 : aLocation.getLineNumber ();

    return new SchematronTemplateInfo (sName, sMatchPattern, sMode, sSystemID, nLineNumber);
  }

  @Override
  public void open (final Controller aController)
  {
    if (LOGGER.isDebugEnabled ())
      LOGGER.debug ("Saxon transform open; controller=" + aController);
    m_aTelemetry.onTransformStart ();
  }

  @Override
  public void enter (final Traceable aInstruction, final Map <String, Object> aProperties, final XPathContext aContext)
  {
    if (!_isTemplate (aInstruction))
    {
      if (LOGGER.isTraceEnabled ())
        LOGGER.trace ("Saxon enter (skipped, not a template): " + _describe (aInstruction));
      return;
    }

    final SchematronTemplateInfo aInfo = _toInfo (aInstruction);
    if (LOGGER.isTraceEnabled ())
      LOGGER.trace ("Saxon enter (depth " +
                    m_aInfoStack.size () +
                    "): " +
                    _describe (aInstruction) +
                    "; properties=" +
                    aProperties);
    m_aInfoStack.push (aInfo);
    m_aTimerStack.push (StopWatch.createdStarted ());
    m_aTelemetry.onTemplateEnter (aInfo);
  }

  @Override
  public void leave (final Traceable aInstruction)
  {
    if (!_isTemplate (aInstruction))
    {
      if (LOGGER.isTraceEnabled ())
        LOGGER.trace ("Saxon leave (skipped, not a template): " + _describe (aInstruction));
      return;
    }

    if (m_aInfoStack.isEmpty () || m_aTimerStack.isEmpty ())
    {
      // Unbalanced (e.g. dynamic error inside enter without matching leave); ignore.
      if (LOGGER.isDebugEnabled ())
        LOGGER.debug ("Saxon leave (unbalanced, info stack empty): " + _describe (aInstruction));
      return;
    }

    final SchematronTemplateInfo aInfo = m_aInfoStack.pop ();
    final StopWatch aTimer = m_aTimerStack.pop ();
    aTimer.stop ();

    if (LOGGER.isDebugEnabled ())
      LOGGER.debug ("Saxon leave (depth " +
                    m_aInfoStack.size () +
                    "): " +
                    _describe (aInstruction) +
                    "; durationMillis=" +
                    aTimer.getMillis ());
    m_aTelemetry.onTemplateLeave (aInfo, aTimer.getNanos ());
  }

  @Override
  public void close ()
  {
    if (LOGGER.isDebugEnabled ())
      LOGGER.debug ("Saxon transform close");
    m_aTelemetry.onTransformEnd ();
  }
}
