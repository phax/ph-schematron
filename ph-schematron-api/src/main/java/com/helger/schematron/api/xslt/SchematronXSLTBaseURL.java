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
package com.helger.schematron.api.xslt;

import java.net.URL;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.io.file.FileHelper;
import com.helger.io.resource.FileSystemResource;
import com.helger.io.resource.IReadableResource;

/**
 * Compute the base URL that should be used as resolution base for an XSLT-based Schematron
 * resource. Extracted from {@code AbstractSchematronXSLTBasedResource} so both the legacy
 * inheritance-based API and the new builder-based API can share a single implementation.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
public final class SchematronXSLTBaseURL
{
  private SchematronXSLTBaseURL ()
  {}

  /**
   * Resolve a base URL string for the given Schematron resource.
   *
   * @param aResource
   *        The resource. May not be <code>null</code>.
   * @return The base URL as string or <code>null</code> if no usable URL could be derived.
   */
  @Nullable
  public static String findBaseURL (@NonNull final IReadableResource aResource)
  {
    if (aResource instanceof final FileSystemResource aFSR)
    {
      // Use parent file as resolution base
      return FileHelper.getAsURLString (aFSR.getAsFile ().getParentFile ());
    }
    final URL aBaseURL = aResource.getAsURL ();
    return aBaseURL != null ? aBaseURL.toExternalForm () : null;
  }
}
