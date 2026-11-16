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
package com.helger.schematron.cli;

import java.io.File;
import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.PathMatcher;
import java.util.List;
import java.util.stream.Stream;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;

/**
 * Collects the files of the command line arguments: a file is taken as is, a directory is searched
 * recursively for files matching include and exclude patterns.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@Immutable
public final class CliFileCollector
{
  /**
   * A collected file.
   *
   * @param file
   *        The file. Never <code>null</code>.
   * @param relativePath
   *        The path relative to the directory argument it was found in, with <code>/</code> as
   *        separator; the file name for a file argument. Never <code>null</code>.
   */
  public record CliInputFile (@NonNull File file, @NonNull String relativePath)
  {}

  private CliFileCollector ()
  {}

  /**
   * Check if a relative path matches a glob pattern. A pattern starting with <code>**&#47;</code>
   * also matches files directly in the directory, like in Ant and Maven.
   *
   * @param sRelativePath
   *        The relative path with <code>/</code> as separator. May not be <code>null</code>.
   * @param sGlob
   *        The glob pattern (<code>java.nio.file.FileSystem#getPathMatcher</code> syntax). May not
   *        be <code>null</code>.
   * @return <code>true</code> if it matches
   */
  public static boolean matches (@NonNull final String sRelativePath, @NonNull final String sGlob)
  {
    final Path aPath = Path.of (sRelativePath);
    final PathMatcher aMatcher = FileSystems.getDefault ().getPathMatcher ("glob:" + sGlob);
    if (aMatcher.matches (aPath))
      return true;
    return sGlob.startsWith ("**/") && FileSystems.getDefault ().getPathMatcher ("glob:" + sGlob.substring (3)).matches (aPath);
  }

  /**
   * @param sRelativePath
   *        The relative path to check. May not be <code>null</code>.
   * @param aGlobs
   *        The patterns to check. May be <code>null</code>.
   * @return <code>true</code> if at least one pattern matches
   */
  private static boolean _matchesAny (@NonNull final String sRelativePath, @Nullable final List <String> aGlobs)
  {
    if (aGlobs != null)
      for (final String sGlob : aGlobs)
        if (matches (sRelativePath, sGlob))
          return true;
    return false;
  }

  /**
   * Collect the files of the arguments.
   *
   * @param aInputs
   *        The file and directory arguments. May be <code>null</code>.
   * @param aIncludes
   *        The patterns a file in a directory must match (at least one). May not be
   *        <code>null</code>.
   * @param aExcludes
   *        The patterns a file in a directory must not match. May be <code>null</code>.
   * @return The files, directories in sorted order. Never <code>null</code>.
   * @throws IllegalArgumentException
   *         If an argument does not exist
   */
  @NonNull
  @ReturnsMutableCopy
  public static ICommonsList <CliInputFile> collect (@Nullable final List <File> aInputs,
                                                     @NonNull final List <String> aIncludes,
                                                     @Nullable final List <String> aExcludes)
  {
    final ICommonsList <CliInputFile> ret = new CommonsArrayList <> ();
    if (aInputs != null)
      for (final File aInput : aInputs)
      {
        if (aInput.isFile ())
          ret.add (new CliInputFile (aInput, aInput.getName ()));
        else
          if (aInput.isDirectory ())
          {
            final Path aBase = aInput.toPath ();
            try (final Stream <Path> aStream = Files.walk (aBase))
            {
              aStream.filter (Files::isRegularFile).sorted ().forEach (aPath -> {
                final String sRelativePath = aBase.relativize (aPath).toString ().replace (File.separatorChar, '/');
                if (_matchesAny (sRelativePath, aIncludes) && !_matchesAny (sRelativePath, aExcludes))
                  ret.add (new CliInputFile (aPath.toFile (), sRelativePath));
              });
            }
            catch (final IOException ex)
            {
              throw new UncheckedIOException ("Failed to read the directory '" + aInput.getPath () + "'", ex);
            }
          }
          else
            throw new IllegalArgumentException ("The file or directory '" + aInput.getPath () + "' does not exist");
      }
    return ret;
  }
}
