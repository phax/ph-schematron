/*
 * Copyright (C) 2014-2022 Philip Helger (www.helger.com)
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
package com.helger.schematron.svrl;

import java.time.LocalDateTime;
import java.util.Locale;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.error.SingleError;
import com.helger.commons.error.level.IErrorLevel;
import com.helger.commons.error.text.IHasErrorText;
import com.helger.commons.hashcode.HashCodeGenerator;
import com.helger.commons.location.ILocation;
import com.helger.commons.string.ToStringGenerator;

/**
 * Special SVRL resource error that contains the Schematron &quot;test&quot; as
 * well.
 *
 * @author Philip Helger
 */
public class SVRLResourceError extends SingleError
{
  private final String m_sTest;

  /**
   * Constructor.
   *
   * @param aErrorDT
   *        Error date time
   * @param aErrorLevel
   *        The error level. May not be <code>null</code>.
   * @param sErrorID
   *        Error ID. May be <code>null</code>.
   * @param sErrorFieldName
   *        Error field name. May be <code>null</code>.
   * @param aErrorLocation
   *        Location where the error occurred. May be <code>null</code>.
   * @param aErrorText
   *        The error text. May be <code>null</code>.
   * @param aLinkedException
   *        An exception that caused the error. May be <code>null</code>.
   * @param sTest
   *        The SVRL test that triggered this error. May not be
   *        <code>null</code>.
   */
  public SVRLResourceError (@Nullable final LocalDateTime aErrorDT,
                            @Nonnull final IErrorLevel aErrorLevel,
                            @Nullable final String sErrorID,
                            @Nullable final String sErrorFieldName,
                            @Nullable final ILocation aErrorLocation,
                            @Nullable final IHasErrorText aErrorText,
                            @Nullable final Throwable aLinkedException,
                            @Nonnull final String sTest)
  {
    super (aErrorDT, aErrorLevel, sErrorID, sErrorFieldName, aErrorLocation, aErrorText, aLinkedException);
    m_sTest = ValueEnforcer.notNull (sTest, "Test");
  }

  /**
   * @return The SVRL test that triggered this error.
   */
  @Nonnull
  public String getTest ()
  {
    return m_sTest;
  }

  @Override
  public String getAsString (@Nonnull final Locale aContentLocale)
  {
    String ret = super.getAsString (aContentLocale);
    ret += " Test=" + m_sTest;
    return ret;
  }

  @Override
  public boolean equals (final Object o)
  {
    if (o == this)
      return true;
    if (!super.equals (o))
      return false;
    final SVRLResourceError rhs = (SVRLResourceError) o;
    return m_sTest.equals (rhs.m_sTest);
  }

  @Override
  public int hashCode ()
  {
    return HashCodeGenerator.getDerived (super.hashCode ()).append (m_sTest).getHashCode ();
  }

  @Override
  public String toString ()
  {
    return ToStringGenerator.getDerived (super.toString ()).append ("Test", m_sTest).getToString ();
  }

  public static class SVRLErrorBuilder extends SingleError.AbstractBuilder <SVRLResourceError, SVRLErrorBuilder>
  {
    private String m_sTest;

    public SVRLErrorBuilder (@Nonnull final String sTest)
    {
      test (sTest);
    }

    @Nonnull
    public final SVRLErrorBuilder test (@Nonnull final String sTest)
    {
      m_sTest = ValueEnforcer.notNull (sTest, "Test");
      return this;
    }

    @Override
    public SVRLResourceError build ()
    {
      return new SVRLResourceError (m_aErrorDT,
                                    m_aErrorLevel,
                                    m_sErrorID,
                                    m_sErrorFieldName,
                                    m_aErrorLocation,
                                    m_aErrorText,
                                    m_aLinkedException,
                                    m_sTest);
    }
  }
}
