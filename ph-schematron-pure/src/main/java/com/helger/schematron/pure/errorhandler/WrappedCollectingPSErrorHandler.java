/*
 * Copyright (C) 2014-2025 Philip Helger (www.helger.com)
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

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.diagnostics.error.list.ErrorList;

/**
 * An implementation if {@link IPSErrorHandler} that collects all error messages
 * in a provided error list.
 *
 * @author Philip Helger
 * @since 4.2.1
 */
public class WrappedCollectingPSErrorHandler extends AbstractCollectingPSErrorHandler
{
  public WrappedCollectingPSErrorHandler (@NonNull final ErrorList aErrorList)
  {
    super (aErrorList, null);
  }

  public WrappedCollectingPSErrorHandler (@NonNull final ErrorList aErrorList, @Nullable final IPSErrorHandler aNestedErrorHandler)
  {
    super (aErrorList, aNestedErrorHandler);
  }
}
