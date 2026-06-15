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
package com.helger.schematron;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.Nonempty;
import com.helger.base.id.IHasID;
import com.helger.base.lang.EnumHelper;

/**
 * Pre-v10 enumeration of Schematron processing engines, used historically by
 * {@code SchematronValidationMojo} (Maven plugin) and the Ant {@code Schematron} task.
 * <p>
 * <b>Deprecated since v10.0.0.</b> Merged into {@link ESchematronEngine}, which is now the single
 * authoritative engine selector. Every value here has an equivalent on {@link ESchematronEngine}
 * &mdash; see {@link #toEngine()}. All string ids that this enum recognised remain accepted by
 * {@link ESchematronEngine#getFromIDOrNull(String)} as well, so user-facing configuration values
 * (e.g. {@code schematronProcessingEngine="schematron"}) continue to resolve.
 *
 * @author Philip Helger
 * @deprecated Use {@link ESchematronEngine} instead.
 */
@Deprecated (since = "10.0.0", forRemoval = true)
public enum ESchematronMode implements IHasID <String>
{
  /** Pure-Java XPath engine. Same as {@link #PURE}; preferred id since v10.0.0. */
  @Deprecated (since = "10.0.0", forRemoval = true)
  PURE_XPATH("pure-xpath", ESchematronEngine.PURE_XPATH),

  /** Pure-Java engine that generates an XSLT stylesheet in Java and runs it via Saxon s9api. */
  @Deprecated (since = "10.0.0", forRemoval = true)
  PURE_XSLT("pure-xslt", ESchematronEngine.PURE_XSLT),

  /** ISO Schematron, SCH version. */
  @Deprecated (since = "10.0.0", forRemoval = true)
  SCHEMATRON("schematron", ESchematronEngine.ISO_SCHEMATRON),

  /** SchXslt Schematron, SCH version. */
  @Deprecated (since = "10.0.0", forRemoval = true)
  SCHXSLT_XSLT2("schxslt-xslt2", ESchematronEngine.SCHXSLT1),

  /** Apply a pre-built XSLT stylesheet. */
  @Deprecated (since = "10.0.0", forRemoval = true)
  XSLT("xslt", ESchematronEngine.XSLT_PREBUILT);

  /** Pure-Java XPath engine (alias of {@link #PURE_XPATH}, kept for compatibility). */
  @Deprecated (forRemoval = true, since = "10.0.0")
  public static final ESchematronMode PURE = PURE_XPATH;

  private final String m_sID;
  private final ESchematronEngine m_eEngine;

  ESchematronMode (@NonNull @Nonempty final String sID, @NonNull final ESchematronEngine eEngine)
  {
    m_sID = sID;
    m_eEngine = eEngine;
  }

  @Deprecated (since = "10.0.0", forRemoval = true)
  @Override
  @NonNull
  @Nonempty
  public String getID ()
  {
    return m_sID;
  }

  /**
   * @return The {@link ESchematronEngine} value this mode corresponds to. Never <code>null</code>.
   * @since 10.0.0
   */
  @Deprecated (since = "10.0.0", forRemoval = true)
  @NonNull
  public ESchematronEngine toEngine ()
  {
    return m_eEngine;
  }

  /**
   * Resolve a mode by its string id. Accepts the documented id and the pre-v10 aliases
   * {@code "sch"} (alias for {@link #SCHEMATRON}) and {@code "pure"} (alias for
   * {@link #PURE_XPATH}).
   *
   * @param sID
   *        The id to resolve. May be <code>null</code>.
   * @return The matching mode or <code>null</code> if none.
   */
  @Deprecated (since = "10.0.0", forRemoval = true)
  @Nullable
  public static ESchematronMode getFromIDOrNull (@Nullable final String sID)
  {
    // Allowing "sch" as synonym for "schematron"
    if ("sch".equalsIgnoreCase (sID))
      return SCHEMATRON;

    // Old name of "pure-xpath"
    if ("pure".equalsIgnoreCase (sID))
      return PURE_XPATH;

    return EnumHelper.getFromIDCaseInsensitiveOrNull (ESchematronMode.class, sID);
  }
}
