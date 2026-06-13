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
import com.helger.base.string.StringHelper;
import com.helger.collection.commons.CommonsHashSet;
import com.helger.collection.commons.ICommonsSet;

/**
 * Defines the Schematron engine to be used.
 *
 * @author Philip Helger
 * @since 9.1.1
 */
public enum ESchematronEngine implements IHasID <String>
{
  /** Pure-Java XPath-only engine; same as {@link #PURE}. */
  PURE_XPATH ("pure-xpath", new CommonsHashSet <> ("pure"), false),

  /**
   * Pure-Java engine that generates an XSLT 3.0 stylesheet in Java (no external ISO Schematron
   * stylesheet chain) and runs it through Saxon s9api. Suitable both as a validation engine and as
   * a {@code SCH -> XSLT} converter.
   */
  PURE_XSLT ("pure-xslt", new CommonsHashSet <> ("pure-saxon"), true),

  /**
   * ISO Schematron: SCH-to-XSLT preprocessing through the canonical ISO Schematron XSL stylesheet
   * chain. The {@code "schematron"} and {@code "sch"} aliases mirror the pre-v10
   * {@code ESchematronMode.SCHEMATRON} id.
   */
  ISO_SCHEMATRON ("iso-schematron", new CommonsHashSet <> ("iso", "isoschematron", "schematron", "sch"), true),

  /**
   * SchXslt v1 (XSLT 2). The {@code "schxslt-xslt2"} alias mirrors the pre-v10
   * {@code ESchematronMode.SCHXSLT_XSLT2} id.
   */
  SCHXSLT1 ("schxslt", new CommonsHashSet <> ("schxslt1", "schxslt-xslt2"), true),

  /** SchXslt v2 (XSLT 3). */
  SCHXSLT2 ("schxslt2", new CommonsHashSet <> (), true),

  /**
   * Apply a pre-built XSLT stylesheet directly to the XML instance (does not perform any
   * SCH-to-XSLT step). Used by {@code SchematronResourceXSLT}. {@link #isXSLTBased()} returns
   * {@code false} because this engine consumes ready-made XSLT rather than generating it - the flag
   * is consumed by {@code Schematron2XSLTMojo} which only accepts engines that can produce XSLT
   * from SCH.
   */
  XSLT_PREBUILT ("xslt", new CommonsHashSet <> (), false);

  /** Pure-Java XPath-only engine (alias of {@link #PURE_XPATH}; kept for compatibility) */
  @Deprecated (forRemoval = true, since = "10.0.0")
  public static final ESchematronEngine PURE = PURE_XPATH;

  private final @NonNull @Nonempty String m_sID;
  private final @NonNull ICommonsSet <String> m_aIDs;
  private final boolean m_bIsXSLTBased;

  ESchematronEngine (@NonNull @Nonempty final String sID,
                     @NonNull final ICommonsSet <String> aAlternativeIDs,
                     final boolean bIsXSLTBased)
  {
    m_sID = sID;

    m_aIDs = aAlternativeIDs;
    m_aIDs.add (sID);
    m_bIsXSLTBased = bIsXSLTBased;
  }

  @NonNull
  @Nonempty
  public String getID ()
  {
    return m_sID;
  }

  public boolean isXSLTBased ()
  {
    return m_bIsXSLTBased;
  }

  @Nullable
  public static ESchematronEngine getFromIDOrNull (@Nullable final String sID)
  {
    if (StringHelper.isNotEmpty (sID))
      for (final ESchematronEngine e : values ())
        if (e.m_aIDs.contains (sID))
          return e;
    return null;
  }
}
