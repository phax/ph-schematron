/**
 * Copyright (C) 2014-2016 Philip Helger (www.helger.com)
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
package com.helger.maven.schematron;

import java.util.Locale;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import com.helger.commons.annotation.Nonempty;
import com.helger.commons.string.StringHelper;

public enum EProcessingMode
{
  PURE,
  SCHEMATRON,
  XSLT;

  @Nonnull
  @Nonempty
  public String getID ()
  {
    return name ().toLowerCase (Locale.US);
  }

  @Nullable
  public static EProcessingMode getFromIDOrNull (@Nullable final String sID)
  {
    if (StringHelper.hasText (sID))
      for (final EProcessingMode e : values ())
        if (e.getID ().equals (sID))
          return e;
    return null;
  }
}
