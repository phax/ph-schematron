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
package com.helger.schematron.resolve;

import java.io.IOException;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.Nonempty;
import com.helger.io.resource.IReadableResource;

/**
 * Generic include resolver
 * 
 * @author Philip Helger
 */
public interface ISchematronIncludeResolver
{
  /**
   * Resolve the content of the passed href to a resource
   * 
   * @param sHref
   *        The source href that needs to be resolved relative to some base href
   * @return The location of the included href
   * @throws IOException
   *         In case of a resolution error
   */
  @NonNull
  IReadableResource getResolvedSchematronResource (@NonNull @Nonempty String sHref) throws IOException;

  /**
   * Resolve the content of the passed href to a resource, relative to the resource that contains
   * the include. This is needed for resources that have no URL (e.g. in-memory resources), because
   * then the base href is not available. By default {@link #getResolvedSchematronResource(String)}
   * is called and the base resource is ignored.
   *
   * @param sHref
   *        The source href that needs to be resolved relative to the base resource. Neither
   *        <code>null</code> nor empty. An anchor (<code>#...</code>) was already removed.
   * @param aBaseResource
   *        The resource that contains the include. May be <code>null</code> if it is unknown.
   * @return The location of the included href
   * @throws IOException
   *         In case of a resolution error
   * @since 10.3.4
   */
  @NonNull
  default IReadableResource getResolvedSchematronResource (@NonNull @Nonempty final String sHref,
                                                           @Nullable final IReadableResource aBaseResource) throws IOException
  {
    return getResolvedSchematronResource (sHref);
  }
}
