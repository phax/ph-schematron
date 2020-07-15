/**
 * Copyright (C) 2017-2020 Philip Helger (www.helger.com)
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
package com.helger.schematron.ant;

import java.io.File;

import javax.annotation.Nonnull;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.collection.impl.CommonsLinkedHashSet;
import com.helger.commons.collection.impl.ICommonsIterable;
import com.helger.commons.collection.impl.ICommonsOrderedSet;
import com.helger.commons.string.ToStringGenerator;

/**
 * Stores resolved ResourceCollection data.
 *
 * @author Philip Helger
 */
final class DirectoryData
{
  private final File m_aBaseDir;
  private final ICommonsOrderedSet <String> m_aDirs = new CommonsLinkedHashSet <> ();
  private final ICommonsOrderedSet <String> m_aFiles = new CommonsLinkedHashSet <> ();

  public DirectoryData (@Nonnull final File aBaseDir)
  {
    ValueEnforcer.notNull (aBaseDir, "BaseDir");
    m_aBaseDir = aBaseDir;
  }

  @Nonnull
  public File getBaseDir ()
  {
    return m_aBaseDir;
  }

  public void addDir (final String sDir)
  {
    m_aDirs.add (sDir);
  }

  @Nonnull
  public ICommonsIterable <String> getDirs ()
  {
    return m_aDirs;
  }

  public void addFile (final String sFile)
  {
    m_aFiles.add (sFile);
  }

  @Nonnull
  public ICommonsIterable <String> getFiles ()
  {
    return m_aFiles;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (null).append ("BaseDir", m_aBaseDir).append ("Dirs", m_aDirs).append ("Files", m_aFiles).getToString ();
  }
}
