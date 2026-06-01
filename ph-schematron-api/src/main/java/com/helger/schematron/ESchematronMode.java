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
 * What ways do we have to create SVRL from Schematron rules?
 *
 * @author Philip Helger
 */
public enum ESchematronMode implements IHasID <String>
{
  /** Pure-Java XPath engine. Same as {@link #PURE}; preferred id since v10.0.0. */
  PURE_XPATH ("pure-xpath"),

  /** Pure-Java engine that generates an XSLT stylesheet in Java and runs it via Saxon s9api. */
  PURE_XSLT ("pure-xslt"),

  /** ISO Schematron, SCH version */
  SCHEMATRON ("schematron"),

  /** SchXslt Schematron, SCH version */
  SCHXSLT_XSLT2 ("schxslt-xslt2"),

  /** XSLT version */
  XSLT ("xslt");

  /** Pure-Java XPath engine (alias of {@link #PURE_XPATH}, kept for compatibility) */
  @Deprecated (forRemoval = true, since = "10.0.0")
  public static final ESchematronMode PURE = PURE_XPATH;

  private final String m_sID;

  ESchematronMode (@NonNull @Nonempty final String sID)
  {
    m_sID = sID;
  }

  @NonNull
  @Nonempty
  public String getID ()
  {
    return m_sID;
  }

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
