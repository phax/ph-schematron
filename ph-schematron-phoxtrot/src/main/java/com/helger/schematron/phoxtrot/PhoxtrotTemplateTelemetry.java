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

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.timing.StopWatch;
import com.helger.collection.stack.NonBlockingStack;
import com.helger.phoxtrot.xdm.IXdmItem;
import com.helger.phoxtrot.xdm.XdmQName;
import com.helger.phoxtrot.xslt.IXsltTraceListener;
import com.helger.phoxtrot.xslt.XsltTraceTemplate;
import com.helger.schematron.api.telemetry.ISchematronTemplateTelemetry;
import com.helger.schematron.api.telemetry.SchematronTemplateInfo;

/**
 * A phoxtrot {@link IXsltTraceListener} that forwards the template rules and named templates of a
 * transformation to an {@link ISchematronTemplateTelemetry}, with the duration from entering to
 * leaving a template. Stylesheet functions and instructions are not forwarded, as with the Saxon
 * trace listener. One instance is used for one transformation.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@NotThreadSafe
public final class PhoxtrotTemplateTelemetry implements IXsltTraceListener
{
  private final ISchematronTemplateTelemetry m_aTelemetry;
  private final NonBlockingStack <SchematronTemplateInfo> m_aInfoStack = new NonBlockingStack <> ();
  private final NonBlockingStack <StopWatch> m_aTimerStack = new NonBlockingStack <> ();

  /**
   * @param aTelemetry
   *        The telemetry callback to which template events are dispatched. May not be
   *        <code>null</code>.
   */
  public PhoxtrotTemplateTelemetry (@NonNull final ISchematronTemplateTelemetry aTelemetry)
  {
    ValueEnforcer.notNull (aTelemetry, "Telemetry");
    m_aTelemetry = aTelemetry;
  }

  /**
   * @return The name in Clark notation (<code>{uri}local</code>, or only the local name without
   *         namespace), as Saxon reports it.
   */
  @Nullable
  private static String _getClarkName (@Nullable final XdmQName aName)
  {
    if (aName == null)
      return null;
    if (aName.namespaceUri ().isEmpty ())
      return aName.localName ();
    return "{" + aName.namespaceUri () + "}" + aName.localName ();
  }

  @NonNull
  private static SchematronTemplateInfo _toInfo (@NonNull final XsltTraceTemplate aTemplate)
  {
    return new SchematronTemplateInfo (_getClarkName (aTemplate.name ()),
                                       aTemplate.matchPattern (),
                                       _getClarkName (aTemplate.mode ()),
                                       aTemplate.moduleUri (),
                                       aTemplate.line () > 0 ? aTemplate.line () : -1);
  }

  private void _enter (@NonNull final XsltTraceTemplate aTemplate)
  {
    final SchematronTemplateInfo aInfo = _toInfo (aTemplate);
    m_aInfoStack.push (aInfo);
    m_aTimerStack.push (StopWatch.createdStarted ());
    m_aTelemetry.onTemplateEnter (aInfo);
  }

  private void _leave ()
  {
    // phoxtrot calls enter and leave balanced, also when an error ends a template
    if (m_aInfoStack.isEmpty ())
      return;
    final SchematronTemplateInfo aInfo = m_aInfoStack.pop ();
    final StopWatch aTimer = m_aTimerStack.pop ();
    aTimer.stop ();
    m_aTelemetry.onTemplateLeave (aInfo, aTimer.getNanos ());
  }

  @Override
  public void onTransformStart ()
  {
    m_aTelemetry.onTransformStart ();
  }

  @Override
  public void onTransformEnd ()
  {
    m_aTelemetry.onTransformEnd ();
  }

  @Override
  public void onTemplateRuleEnter (@NonNull final XsltTraceTemplate aTemplate, @NonNull final IXdmItem aContextItem)
  {
    _enter (aTemplate);
  }

  @Override
  public void onTemplateRuleLeave (@NonNull final XsltTraceTemplate aTemplate, @NonNull final IXdmItem aContextItem)
  {
    _leave ();
  }

  @Override
  public void onNamedTemplateEnter (@NonNull final XsltTraceTemplate aTemplate, @Nullable final IXdmItem aContextItem)
  {
    _enter (aTemplate);
  }

  @Override
  public void onNamedTemplateLeave (@NonNull final XsltTraceTemplate aTemplate, @Nullable final IXdmItem aContextItem)
  {
    _leave ();
  }
}
