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

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.string.StringHelper;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.schematron.CSchematron;
import com.helger.schematron.CSchematronXML;
import com.helger.schematron.pure.errorhandler.IPSErrorHandler;
import com.helger.xml.microdom.IMicroElement;
import com.helger.xml.microdom.MicroElement;

import jakarta.annotation.Nonnull;
import jakarta.annotation.Nullable;

/**
 * A single Schematron let-element.<br>
 * If the let element is the child of a rule element, the variable is calculated
 * and scoped to the current rule and context. Otherwise, the variable is
 * calculated with the context of the instance document root.<br>
 * The required name attribute is the name of the variable. The required value
 * attribute is an expression evaluated in the current context.<br>
 * It is an error to reference a variable that has not been defined in the
 * current schema, phase, pattern, or rule, if the query language binding allows
 * this to be determined reliably. It is an error for a variable to be multiply
 * defined in the current schema, phase, pattern and rule.<br>
 * The variable is substituted into assertion tests and other expressions in the
 * same rule before the test or expression is evaluated. The query language
 * binding specifies which lexical conventions are used to detect references to
 * variables.<br>
 * An implementation may provide a facility to override the values of top-level
 * variables specified by let elements under the schema element. For example, an
 * implementation may allow top-level variables to be supplied on the command
 * line. The values provided are strings or data objects, not expressions.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class PSLet implements IPSClonableElement <PSLet>
{
  private String m_sName;
  private String m_sValue;

  public PSLet ()
  {}

  public boolean isValid (@Nonnull final IPSErrorHandler aErrorHandler)
  {
    if (StringHelper.isEmpty (m_sName))
    {
      aErrorHandler.error (this, "<let> has no 'name'");
      return false;
    }
    if (StringHelper.isEmpty (m_sValue))
    {
      aErrorHandler.error (this, "<let> has no 'value'");
      return false;
    }
    return true;
  }

  public void validateCompletely (@Nonnull final IPSErrorHandler aErrorHandler)
  {
    if (StringHelper.isEmpty (m_sName))
      aErrorHandler.error (this, "<let> has no 'name'");
    if (StringHelper.isEmpty (m_sValue))
      aErrorHandler.error (this, "<let> has no 'value'");
  }

  public boolean isMinimal ()
  {
    return true;
  }

  /**
   * @param sName
   *        The name of the variable. May be <code>null</code>.
   */
  public void setName (@Nullable final String sName)
  {
    m_sName = sName;
  }

  /**
   * @return The name of the variable. May be <code>null</code>.
   */
  @Nullable
  public String getName ()
  {
    return m_sName;
  }

  /**
   * @param sValue
   *        The value of the variable. May be <code>null</code>.
   */
  public void setValue (@Nullable final String sValue)
  {
    m_sValue = sValue;
  }

  /**
   * @return The value of the variable. May be <code>null</code>.
   */
  @Nullable
  public String getValue ()
  {
    return m_sValue;
  }

  @Nonnull
  public IMicroElement getAsMicroElement ()
  {
    final IMicroElement ret = new MicroElement (CSchematron.NAMESPACE_SCHEMATRON, CSchematronXML.ELEMENT_LET);
    ret.setAttribute (CSchematronXML.ATTR_NAME, m_sName);
    ret.setAttribute (CSchematronXML.ATTR_VALUE, m_sValue);
    return ret;
  }

  @Nonnull
  public PSLet getClone ()
  {
    final PSLet ret = new PSLet ();
    ret.setName (m_sName);
    ret.setValue (m_sValue);
    return ret;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).appendIfNotNull ("name", m_sName).appendIfNotNull ("value", m_sValue).getToString ();
  }

  @Nonnull
  @ReturnsMutableCopy
  public static PSLet create (@Nullable final String sName, @Nullable final String sValue)
  {
    final PSLet ret = new PSLet ();
    ret.setName (sName);
    ret.setValue (sValue);
    return ret;
  }
}
