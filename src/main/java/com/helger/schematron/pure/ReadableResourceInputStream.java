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

import java.io.InputStream;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import com.helger.commons.ValueEnforcer;

//TODO move to ph-commons
class ReadableResourceInputStream extends AbstractMemoryReadableResource
{
  private final InputStream m_aIS;

  public ReadableResourceInputStream (@Nonnull final InputStream aIS)
  {
    m_aIS = ValueEnforcer.notNull (aIS, "InputStream");
  }

  @Nonnull
  public String getResourceID ()
  {
    return "input-stream";
  }

  @Nullable
  public InputStream getInputStream ()
  {
    return m_aIS;
  }
}
