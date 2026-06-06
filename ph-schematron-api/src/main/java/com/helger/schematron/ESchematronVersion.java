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
import com.helger.annotation.misc.Since;
import com.helger.base.id.IHasID;
import com.helger.base.lang.EnumHelper;

/**
 * This enum defines the different Schematron versions to be able to handle different output
 * requirements.
 * <p>
 * Mapping to the ISO/IEC 19757-3 editions:
 * <ul>
 * <li>{@link #SCHEMATRON_2006} &mdash; first edition (v1)</li>
 * <li>{@link #SCHEMATRON_2016} &mdash; second edition (v2)</li>
 * <li>{@link #SCHEMATRON_2020} &mdash; third edition (v3)</li>
 * <li>{@link #SCHEMATRON_2025} &mdash; fourth edition (v4) &mdash; the
 * <code>schematronEdition</code> attribute on <code>schema</code> uses the year value
 * <code>2025</code></li>
 * </ul>
 *
 * @author Philip Helger
 * @since 7.1.1
 */
public enum ESchematronVersion implements IHasID <String>
{
  SCHEMATRON_2006 ("sch2006", "2006"),
  SCHEMATRON_2016 ("sch2016", "2016"),
  SCHEMATRON_2020 ("sch2020", "2020"),
  @Since ("10.0.0")
  SCHEMATRON_2025("sch2025", "2025");

  public static final ESchematronVersion LATEST = SCHEMATRON_2025;

  private final String m_sID;
  private final String m_sEditionYear;

  ESchematronVersion (@NonNull @Nonempty final String sID, @NonNull @Nonempty final String sEditionYear)
  {
    m_sID = sID;
    m_sEditionYear = sEditionYear;
  }

  @NonNull
  @Nonempty
  public String getID ()
  {
    return m_sID;
  }

  /**
   * @return The edition year as it appears in the <code>schematronEdition</code> attribute (e.g.
   *         <code>"2025"</code>). Never <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  @Nonempty
  public String getEditionYear ()
  {
    return m_sEditionYear;
  }

  public boolean isOlderThan (@NonNull final ESchematronVersion eOther)
  {
    return ordinal () < eOther.ordinal ();
  }

  @Nullable
  public static ESchematronVersion getFromIDOrNull (@Nullable final String sID)
  {
    return EnumHelper.getFromIDCaseInsensitiveOrNull (ESchematronVersion.class, sID);
  }

  /**
   * Look up a Schematron version by the value of the <code>schematronEdition</code> attribute on a
   * <code>schema</code> element. Matching is case-sensitive against the four-digit year strings
   * (e.g. <code>"2025"</code>).
   *
   * @param sEditionYear
   *        The attribute value to look up. May be <code>null</code>.
   * @return The matching {@link ESchematronVersion} or <code>null</code> if no version corresponds
   *         to the supplied year.
   * @since 10.0.0
   */
  @Nullable
  public static ESchematronVersion getFromEditionYearOrNull (@Nullable final String sEditionYear)
  {
    if (sEditionYear != null)
      for (final ESchematronVersion e : values ())
        if (e.m_sEditionYear.equals (sEditionYear))
          return e;
    return null;
  }
}
