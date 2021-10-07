/*
 * Copyright (C) 2014-2021 Philip Helger (www.helger.com)
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

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.NotThreadSafe;

import com.helger.commons.string.StringHelper;
import com.helger.commons.string.ToStringGenerator;
import com.helger.schematron.CSchematron;
import com.helger.schematron.CSchematronXML;
import com.helger.schematron.pure.errorhandler.IPSErrorHandler;
import com.helger.xml.microdom.IMicroElement;
import com.helger.xml.microdom.MicroElement;

/**
 * A single Schematron include-element.<br>
 * The required href attribute references an external well-formed XML document
 * whose document element is a Schematron element of a type which is allowed by
 * the grammar for Schematron at the current position in the schema. The
 * external document is inserted in place of the include element.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class PSInclude implements IPSElement
{
  private String m_sHref;

  public PSInclude ()
  {}

  public boolean isValid (@Nonnull final IPSErrorHandler aErrorHandler)
  {
    if (StringHelper.hasNoText (m_sHref))
    {
      aErrorHandler.error (this, "<include> has no 'href'");
      return false;
    }
    return true;
  }

  public void validateCompletely (@Nonnull final IPSErrorHandler aErrorHandler)
  {
    if (StringHelper.hasNoText (m_sHref))
      aErrorHandler.error (this, "<include> has no 'href'");
  }

  public boolean isMinimal ()
  {
    return false;
  }

  /**
   * @param sHref
   *        The path to the object to include. May be <code>null</code>.
   */
  public void setHref (@Nullable final String sHref)
  {
    m_sHref = sHref;
  }

  /**
   * @return The path to the object to include. May be <code>null</code>.
   */
  @Nullable
  public String getHref ()
  {
    return m_sHref;
  }

  @Nonnull
  public IMicroElement getAsMicroElement ()
  {
    final IMicroElement ret = new MicroElement (CSchematron.NAMESPACE_SCHEMATRON, CSchematronXML.ELEMENT_INCLUDE);
    ret.setAttribute (CSchematronXML.ATTR_HREF, m_sHref);
    return ret;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).appendIfNotNull ("href", m_sHref).getToString ();
  }
}
