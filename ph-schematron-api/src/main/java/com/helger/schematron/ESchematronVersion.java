/*
 * Copyright (C) 2014-2025 Philip Helger (www.helger.com)
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

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import com.helger.commons.annotation.Nonempty;
import com.helger.commons.id.IHasID;
import com.helger.commons.lang.EnumHelper;

/**
 * This enum defines the different Schematron versions to be able to handle
 * different output requirements.
 *
 * @author Philip Helger
 * @since 7.1.1
 */
public enum ESchematronVersion implements IHasID <String>
{
  SCHEMATRON_2006 ("sch2006"),
  SCHEMATRON_2016 ("sch2016"),
  SCHEMATRON_2020 ("sch2020");

  public static final ESchematronVersion LATEST = SCHEMATRON_2020;

  private final String m_sID;

  ESchematronVersion (@Nonnull @Nonempty final String sID)
  {
    m_sID = sID;
  }

  @Nonnull
  @Nonempty
  public String getID ()
  {
    return m_sID;
  }

  @Nullable
  public static ESchematronVersion getFromIDOrNull (@Nullable final String sID)
  {
    return EnumHelper.getFromIDCaseInsensitiveOrNull (ESchematronVersion.class, sID);
  }
}
