/*
 * Copyright (C) 2017-2025 Philip Helger (www.helger.com)
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

import org.jspecify.annotations.NonNull;

import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.collection.commons.CommonsLinkedHashSet;
import com.helger.collection.commons.ICommonsIterable;
import com.helger.collection.commons.ICommonsOrderedSet;

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

  public DirectoryData (@NonNull final File aBaseDir)
  {
    ValueEnforcer.notNull (aBaseDir, "BaseDir");
    m_aBaseDir = aBaseDir;
  }

  @NonNull
  public File getBaseDir ()
  {
    return m_aBaseDir;
  }

  public void addDir (final String sDir)
  {
    m_aDirs.add (sDir);
  }

  @NonNull
  public ICommonsIterable <String> getDirs ()
  {
    return m_aDirs;
  }

  public void addFile (final String sFile)
  {
    m_aFiles.add (sFile);
  }

  @NonNull
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
