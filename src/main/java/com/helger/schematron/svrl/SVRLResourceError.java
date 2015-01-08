/**
 * Copyright (C) 2014-2015 Philip Helger (www.helger.com)
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

import java.util.Locale;

import javax.annotation.Nonnull;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.error.EErrorLevel;
import com.helger.commons.error.IResourceLocation;
import com.helger.commons.error.ResourceError;
import com.helger.commons.hash.HashCodeGenerator;
import com.helger.commons.string.StringHelper;
import com.helger.commons.string.ToStringGenerator;

/**
 * Special SVRL resource error that contains the Schematron &quot;test&quot; as
 * well.
 *
 * @author Philip Helger
 */
public class SVRLResourceError extends ResourceError
{
  private final String m_sTest;

  /**
   * Constructor.
   *
   * @param aLocation
   *        Location where the error occurred. May not be <code>null</code>.
   * @param eErrorLevel
   *        The error level. May not be <code>null</code>.
   * @param sErrorText
   *        The error text. May not be <code>null</code>.
   * @param sTest
   *        The SVRL test that triggered this error. May not be
   *        <code>null</code>.
   */
  public SVRLResourceError (@Nonnull final IResourceLocation aLocation,
                            @Nonnull final EErrorLevel eErrorLevel,
                            @Nonnull final String sErrorText,
                            @Nonnull final String sTest)
  {
    super (aLocation, eErrorLevel, sErrorText, null);
    ValueEnforcer.notNull (sTest, "Test");
    m_sTest = sTest;
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
    String ret = "[" + getErrorLevel ().getID () + "]";
    final String sLocation = getLocation ().getAsString ();
    if (StringHelper.hasText (sLocation))
      ret += ' ' + sLocation;
    ret += "; Test=" + m_sTest;
    ret += "; Message=" + getDisplayText (aContentLocale);
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
    return ToStringGenerator.getDerived (super.toString ()).append ("test", m_sTest).toString ();
  }
}
