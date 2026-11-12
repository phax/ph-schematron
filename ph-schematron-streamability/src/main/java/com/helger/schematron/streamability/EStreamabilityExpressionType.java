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
package com.helger.schematron.streamability;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.Nonempty;
import com.helger.base.name.IHasDisplayName;

/**
 * The kind of a Schematron expression in a {@link SchematronStreamabilityReport}.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
public enum EStreamabilityExpressionType implements IHasDisplayName
{
  /**
   * A <code>sch:let</code> of the schema, a phase or a pattern: computed once, with the document node as context.
   */
  GLOBAL_LET ("sch:let"),
  /** The <code>context</code> of a <code>sch:rule</code> (an XSLT pattern). */
  RULE_CONTEXT ("rule context"),
  /** A <code>sch:let</code> of a rule. */
  RULE_LET ("sch:let"),
  /** The <code>test</code> of a <code>sch:assert</code>. */
  ASSERT ("sch:assert"),
  /** The <code>test</code> of a <code>sch:report</code>. */
  REPORT ("sch:report"),
  /**
   * The <code>select</code> of a <code>sch:value-of</code> in an assertion, a report or a diagnostic they reference.
   */
  VALUE_OF ("sch:value-of"),
  /** The <code>path</code> of a <code>sch:name</code> in an assertion or a report. */
  NAME ("sch:name"),
  /** A construct of the schema the analysis does not cover; it is always {@link EStreamabilityClass#NON_LOCAL}. */
  UNSUPPORTED ("unsupported");

  private final String m_sDisplayName;

  EStreamabilityExpressionType (@NonNull @Nonempty final String sDisplayName)
  {
    m_sDisplayName = sDisplayName;
  }

  @NonNull
  @Nonempty
  public String getDisplayName ()
  {
    return m_sDisplayName;
  }
}
