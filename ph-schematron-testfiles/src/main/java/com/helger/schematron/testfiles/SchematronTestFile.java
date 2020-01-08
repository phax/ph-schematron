/**
 * Copyright (C) 2014-2020 Philip Helger (www.helger.com)
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
package com.helger.schematron.testfiles;

import javax.annotation.Nonnull;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.Nonempty;
import com.helger.commons.hashcode.HashCodeGenerator;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.string.ToStringGenerator;

/**
 * Represents a single Schematron test file
 *
 * @author Philip Helger
 */
public class SchematronTestFile
{
  private final String m_sParentDirBaseName;
  private final IReadableResource m_aRes;
  // For easier usage only:
  private final String m_sFileBaseName;

  public SchematronTestFile (@Nonnull @Nonempty final String sParentDirBaseName,
                             @Nonnull final IReadableResource aRes,
                             @Nonnull @Nonempty final String sFileBaseName)
  {
    ValueEnforcer.notEmpty (sParentDirBaseName, "ParentDirBaseName");
    ValueEnforcer.notNull (aRes, "Resource");
    ValueEnforcer.notEmpty (sFileBaseName, "FileBaseName");

    m_sParentDirBaseName = sParentDirBaseName;
    m_aRes = aRes;
    m_sFileBaseName = sFileBaseName;
  }

  @Nonnull
  @Nonempty
  public String getParentDirBaseName ()
  {
    return m_sParentDirBaseName;
  }

  @Nonnull
  public IReadableResource getResource ()
  {
    return m_aRes;
  }

  @Nonnull
  @Nonempty
  public String getFileBaseName ()
  {
    return m_sFileBaseName;
  }

  @Override
  public boolean equals (final Object o)
  {
    if (o == this)
      return true;
    if (o == null || !getClass ().equals (o.getClass ()))
      return false;
    final SchematronTestFile rhs = (SchematronTestFile) o;
    return m_sParentDirBaseName.equals (rhs.m_sParentDirBaseName) && m_aRes.equals (rhs.m_aRes);
  }

  @Override
  public int hashCode ()
  {
    return new HashCodeGenerator (this).append (m_sParentDirBaseName).append (m_aRes).getHashCode ();
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("parentDirBaseName", m_sParentDirBaseName)
                                       .append ("res", m_aRes)
                                       .append ("fileBaseName", m_sFileBaseName)
                                       .getToString ();
  }
}
