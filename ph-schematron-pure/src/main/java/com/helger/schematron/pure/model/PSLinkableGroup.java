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
package com.helger.schematron.pure.model;

import java.io.Serializable;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.NotThreadSafe;

import com.helger.commons.lang.ICloneable;
import com.helger.commons.string.ToStringGenerator;
import com.helger.schematron.CSchematronXML;
import com.helger.xml.microdom.IMicroElement;

/**
 * A single "linkable" group
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class PSLinkableGroup implements ICloneable <PSLinkableGroup>, Serializable
{
  private String m_sRole;
  private String m_sSubject;

  public PSLinkableGroup ()
  {}

  public void setRole (@Nullable final String sRole)
  {
    m_sRole = sRole;
  }

  /**
   * A name describing the function of the assertion or context node in the
   * pattern. If the assertion has a subject attribute, then the role labels the
   * arc between the context node and any nodes which match the path expression
   * given by the subject attribute.<br>
   * An implementation is not required to make use of this attribute.
   *
   * @return The role value
   */
  @Nullable
  public String getRole ()
  {
    return m_sRole;
  }

  public void setSubject (@Nullable final String sSubject)
  {
    m_sSubject = sSubject;
  }

  /**
   * A path allowing more precise specification of nodes. The path expression is
   * evaluated in the context of the context node of the current rule. If no
   * subject attribute is specified, the current subject node may be used.<br>
   * NOTE: The subject attribute is required because the rule context may have
   * been selected for reasons of convenience or performance, in association
   * with the particular assertion tests. In such cases, the rule context may
   * not be useful to identify the subject, and the nodes located by the subject
   * attribute may be more useful. Similarly, it may not be possible to
   * determine from an assertion test which nodes the assertion test has tested.
   * In such a case, the nodes located by the subject attribute may be more
   * useful.<br>
   * An implementation is not required to make use of this element.
   *
   * @return The subject value
   */
  @Nullable
  public String getSubject ()
  {
    return m_sSubject;
  }

  public static boolean isLinkableAttribute (@Nullable final String sAttrName)
  {
    return CSchematronXML.ATTR_ROLE.equals (sAttrName) || CSchematronXML.ATTR_SUBJECT.equals (sAttrName);
  }

  public void fillMicroElement (@Nonnull final IMicroElement aElement)
  {
    aElement.setAttribute (CSchematronXML.ATTR_ROLE, m_sRole);
    aElement.setAttribute (CSchematronXML.ATTR_SUBJECT, m_sSubject);
  }

  @Nonnull
  public PSLinkableGroup getClone ()
  {
    final PSLinkableGroup ret = new PSLinkableGroup ();
    ret.setRole (m_sRole);
    ret.setSubject (m_sSubject);
    return ret;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).appendIfNotNull ("role", m_sRole).appendIfNotNull ("subject", m_sSubject).getToString ();
  }
}
