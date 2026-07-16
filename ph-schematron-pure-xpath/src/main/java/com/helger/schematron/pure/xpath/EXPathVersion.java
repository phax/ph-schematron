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
package com.helger.schematron.pure.xpath;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.Nonempty;
import com.helger.base.id.IHasID;
import com.helger.base.lang.EnumHelper;

import net.sf.saxon.s9api.XPathCompiler;

/**
 * The XPath language version that the Saxon {@link XPathCompiler} is asked to apply. The string
 * value matches what {@link XPathCompiler#setLanguageVersion(String)} expects.
 *
 * @author Philip Helger
 * @since 9.2.0
 */
public enum EXPathVersion implements IHasID <String>
{
  XPATH_1_0 ("1.0"),
  XPATH_2_0 ("2.0"),
  XPATH_3_0 ("3.0"),
  XPATH_3_1 ("3.1"),
  XPATH_4_0 ("4.0");

  /**
   * The default version used when nothing is configured explicitly.
   */
  public static final EXPathVersion DEFAULT = XPATH_3_1;

  private final String m_sVersion;

  EXPathVersion (@NonNull @Nonempty final String sVersion)
  {
    m_sVersion = sVersion;
  }

  /**
   * @return The version string passed to {@link XPathCompiler#setLanguageVersion(String)}. Neither
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
   * Resolve an {@link EXPathVersion} from its version string (e.g. <code>"3.1"</code>).
   *
   * @param sVersion
   *        The version string to resolve. May be <code>null</code>.
   * @return The matching {@link EXPathVersion} or <code>null</code> if none matches.
   */
  @Nullable
  public static EXPathVersion getFromIDOrNull (@Nullable final String sVersion)
  {
    return EnumHelper.getFromIDOrNull (EXPathVersion.class, sVersion);
  }
}
