/*
 * Copyright (C) 2015-2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.purexslt.xslt;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.Nonempty;
import com.helger.base.id.IHasID;
import com.helger.base.lang.EnumHelper;

/**
 * The XSLT language version that {@link PureXsltStylesheetGenerator} sets on the
 * {@code xsl:stylesheet/@version} attribute of the generated stylesheet. Saxon-HE 12 supports both
 * XSLT&nbsp;2.0 and 3.0; the default is XSLT&nbsp;3.0, which gives access to {@code fn:path()}
 * (used to populate the SVRL {@code location} attribute) and other 3.0-only constructs.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
public enum EPureXsltVersion implements IHasID <String>
{
  XSLT_2_0 ("2.0"),
  XSLT_3_0 ("3.0");

  /**
   * The default version used when nothing is configured explicitly.
   */
  public static final EPureXsltVersion DEFAULT = XSLT_3_0;

  private final String m_sVersion;

  EPureXsltVersion (@NonNull @Nonempty final String sVersion)
  {
    m_sVersion = sVersion;
  }

  /**
   * @return The version string written to {@code xsl:stylesheet/@version}. Neither
   *         <code>null</code> nor empty.
   */
  @NonNull
  @Nonempty
  public String getID ()
  {
    return m_sVersion;
  }

  /**
   * @return Alias for {@link #getID()}. Neither <code>null</code> nor empty.
   */
  @NonNull
  @Nonempty
  public String getVersion ()
  {
    return m_sVersion;
  }

  /**
   * Resolve an {@link EPureXsltVersion} from its version string (e.g. <code>"3.0"</code>).
   *
   * @param sVersion
   *        The version string to resolve. May be <code>null</code>.
   * @return The matching {@link EPureXsltVersion} or <code>null</code> if none matches.
   */
  @Nullable
  public static EPureXsltVersion getFromIDOrNull (@Nullable final String sVersion)
  {
    return EnumHelper.getFromIDOrNull (EPureXsltVersion.class, sVersion);
  }
}
