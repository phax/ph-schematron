/**
 * Copyright (C) 2014-2018 Philip Helger (www.helger.com)
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
package com.helger.schematron.xslt;

import java.io.File;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.NotThreadSafe;

import com.helger.commons.annotation.Nonempty;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.FileSystemResource;
import com.helger.commons.io.resource.IReadableResource;

/**
 * A Schematron resource that is based on an existing, pre-compiled XSLT script.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class SchematronResourceXSLT extends AbstractSchematronXSLTBasedResource <SchematronResourceXSLT>
{
  /**
   * Constructor
   *
   * @param aXSLTResource
   *        The XSLT resource. May not be <code>null</code>.
   */
  public SchematronResourceXSLT (@Nonnull final IReadableResource aXSLTResource)
  {
    super (aXSLTResource);
  }

  @Override
  @Nullable
  public ISchematronXSLTBasedProvider getXSLTProvider ()
  {
    if (isUseCache ())
      return SchematronResourceXSLTCache.getSchematronXSLTProvider (getResource (),
                                                                    getErrorListener (),
                                                                    getURIResolver ());

    // Always create a new one
    return SchematronResourceXSLTCache.createSchematronXSLTProvider (getResource (),
                                                                     getErrorListener (),
                                                                     getURIResolver ());
  }

  @Nonnull
  public static SchematronResourceXSLT fromClassPath (@Nonnull @Nonempty final String sXSLTPath)
  {
    return new SchematronResourceXSLT (new ClassPathResource (sXSLTPath));
  }

  @Nonnull
  public static SchematronResourceXSLT fromFile (@Nonnull @Nonempty final String sXSLTPath)
  {
    return new SchematronResourceXSLT (new FileSystemResource (sXSLTPath));
  }

  @Nonnull
  public static SchematronResourceXSLT fromFile (@Nonnull final File aXSLTFile)
  {
    return new SchematronResourceXSLT (new FileSystemResource (aXSLTFile));
  }
}
