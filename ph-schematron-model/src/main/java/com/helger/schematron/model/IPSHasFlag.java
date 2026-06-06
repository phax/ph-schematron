/*
 * Copyright (C) 2015-2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.model;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.collection.commons.ICommonsList;

/**
 * Base interface for objects carrying one or more Schematron <code>flag</code>s.
 * <p>
 * In ISO/IEC 19757-3:2006/2016/2020 the <code>flag</code> attribute was a single token. The 2025
 * edition relaxes the RNC datatype to <code>list { token+ }</code> so a single
 * <code>@flag</code> attribute can carry whitespace-separated tokens that each act as an
 * independent Boolean flag variable.
 * <p>
 * For backwards compatibility {@link #getFlag()} / {@code setFlag(String)} keep the
 * &quot;flat&quot; string form: reading the joined whitespace-separated value, and parsing the
 * input by splitting on whitespace. The new {@link #getAllFlags()} / {@link #addFlag(String)}
 * methods expose the token list directly.
 *
 * @author Philip Helger
 */
public interface IPSHasFlag
{
  /**
   * The name of a Boolean flag variable. A flag is implicitly declared by an assertion or rule
   * having a flag attribute with that name. The value of a flag becomes true when an assertion
   * with that flag fails or a rule with that flag fires.<br>
   * The purpose of flags is to convey state or severity information to a subsequent process.<br>
   * An implementation is not required to make use of this attribute.
   * <p>
   * When more than one flag has been declared via {@link #addFlag(String)} or via a
   * whitespace-separated {@code setFlag(...)} call (ISO/IEC 19757-3:2025), the returned string
   * is the whitespace-joined concatenation of all configured tokens.
   *
   * @return The configured flag value, or <code>null</code> if no flag is set.
   */
  @Nullable
  String getFlag ();

  /**
   * Return all configured flag tokens. Empty when no flag has been declared.
   *
   * @return The configured flag tokens. Never <code>null</code>; modifications to the returned
   *         list do not affect the underlying model.
   * @since 10.0.0 (Schematron 2025)
   */
  @NonNull
  @ReturnsMutableCopy
  ICommonsList <String> getAllFlags ();

  /**
   * Append an additional flag token. ISO/IEC 19757-3:2025 permits more than one token on a single
   * <code>flag</code> attribute; in older editions only the first token is meaningful.
   *
   * @param sFlag
   *        The token to append. Must not be <code>null</code> and must not contain whitespace
   *        (use repeated calls to add multiple tokens).
   * @since 10.0.0 (Schematron 2025)
   */
  void addFlag (@NonNull String sFlag);
}
