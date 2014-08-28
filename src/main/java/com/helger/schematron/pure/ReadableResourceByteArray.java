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
import com.helger.commons.collections.ArrayHelper;
import com.helger.commons.io.streams.NonBlockingByteArrayInputStream;

//TODO move to ph-commons
class ReadableResourceByteArray extends AbstractMemoryReadableResource
{
  private final byte [] m_aSchematron;

  public ReadableResourceByteArray (@Nonnull final byte [] aSchematron)
  {
    // Create a copy to avoid outside modifications
    m_aSchematron = ArrayHelper.getCopy (ValueEnforcer.notNull (aSchematron, "Schematron"));
  }

  @Nonnull
  public String getResourceID ()
  {
    return "byte[]";
  }

  @Nullable
  public InputStream getInputStream ()
  {
    return new NonBlockingByteArrayInputStream (m_aSchematron);
  }
}
