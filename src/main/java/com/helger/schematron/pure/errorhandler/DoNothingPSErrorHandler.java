/**
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
package com.helger.schematron.pure.errorhandler;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import com.helger.commons.error.EErrorLevel;
import com.helger.commons.io.IReadableResource;
import com.helger.schematron.pure.model.IPSElement;

/**
 * An implementation if {@link IPSErrorHandler} that does nothing and swallows
 * all output.
 *
 * @author Philip Helger
 */
public class DoNothingPSErrorHandler extends AbstractPSErrorHandler
{
  private static final DoNothingPSErrorHandler s_aInstance = new DoNothingPSErrorHandler ();

  public DoNothingPSErrorHandler ()
  {
    super ();
  }

  @Nonnull
  public static DoNothingPSErrorHandler getInstance ()
  {
    return s_aInstance;
  }

  @Override
  protected void handle (@Nullable final IReadableResource aRes,
                         @Nonnull final EErrorLevel eErrorLevel,
                         @Nonnull final IPSElement aSourceElement,
                         @Nonnull final String sMessage,
                         @Nullable final Throwable t)
  {}
}
