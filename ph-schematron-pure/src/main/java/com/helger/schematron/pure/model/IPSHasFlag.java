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
package com.helger.schematron.pure.model;

import javax.annotation.Nullable;

/**
 * Base interface for a objects having flags
 * 
 * @author Philip Helger
 */
public interface IPSHasFlag
{
  /**
   * The name of a Boolean flag variable. A flag is implicitly declared by an
   * assertion or rule having a flag attribute with that name. The value of a
   * flag becomes true when an assertion with that flag fails or a rule with
   * that flag fires.<br>
   * The purpose of flags is to convey state or severity information to a
   * subsequent process.<br>
   * An implementation is not required to make use of this attribute.
   * 
   * @return The flag value
   */
  @Nullable
  String getFlag ();
}
