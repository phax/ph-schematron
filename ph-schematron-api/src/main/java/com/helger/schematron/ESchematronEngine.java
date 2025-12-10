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
  PURE ("pure", new CommonsHashSet <> (), false),
  ISO_SCHEMATRON ("iso-schematron", new CommonsHashSet <> ("iso", "isoschematron"), true),
  SCHXSLT1 ("schxslt", new CommonsHashSet <> ("schxslt1"), true),
  SCHXSLT2 ("schxslt2", new CommonsHashSet <> (), true);

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
