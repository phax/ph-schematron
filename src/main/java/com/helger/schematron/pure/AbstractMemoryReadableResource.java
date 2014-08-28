/**
 * Copyright (C) 2014 phloc systems (www.phloc.com)
 * Copyright (C) 2014 Philip Helger (www.helger.com)
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
package com.helger.schematron.pure;

import java.io.File;
import java.io.Reader;
import java.net.URL;
import java.nio.charset.Charset;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import com.helger.commons.annotations.UnsupportedOperation;
import com.helger.commons.io.IReadableResource;
import com.helger.commons.io.streams.StreamUtils;

// TODO move to ph-commons
abstract class AbstractMemoryReadableResource implements IReadableResource
{
  public AbstractMemoryReadableResource ()
  {}

  @Nonnull
  public String getPath ()
  {
    return "";
  }

  @Nullable
  public URL getAsURL ()
  {
    return null;
  }

  @Nullable
  public File getAsFile ()
  {
    return null;
  }

  public boolean exists ()
  {
    return true;
  }

  @Nullable
  public Reader getReader (@Nonnull final Charset aCharset)
  {
    return StreamUtils.createReader (getInputStream (), aCharset);
  }

  @Nullable
  @Deprecated
  public Reader getReader (@Nonnull final String sCharset)
  {
    return StreamUtils.createReader (getInputStream (), sCharset);
  }

  @Nonnull
  @UnsupportedOperation
  public IReadableResource getReadableCloneForPath (@Nonnull final String sPath)
  {
    throw new UnsupportedOperationException ();
  }
}