package com.helger.schematron.ant;

import java.io.File;

import javax.annotation.Nonnull;

import com.helger.commons.collection.ext.CommonsLinkedHashSet;
import com.helger.commons.collection.ext.ICommonsOrderedSet;
import com.helger.commons.string.ToStringGenerator;

/**
 * Stores resolved ResourceCollection data.
 * 
 * @author Philip Helger
 */
final class DirectoryData
{
  final File m_aBaseDir;
  final ICommonsOrderedSet <String> m_aDirs = new CommonsLinkedHashSet <> ();
  final ICommonsOrderedSet <String> m_aFiles = new CommonsLinkedHashSet <> ();

  public DirectoryData (@Nonnull final File aBaseDir)
  {
    m_aBaseDir = aBaseDir;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (null).append ("BaseDir", m_aBaseDir)
                                       .append ("Dirs", m_aDirs)
                                       .append ("Files", m_aFiles)
                                       .getToString ();
  }
}
