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

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.string.StringHelper;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.schematron.CSchematron;
import com.helger.schematron.CSchematronXML;
import com.helger.schematron.errorhandler.IPSErrorHandler;
import com.helger.xml.microdom.IMicroElement;
import com.helger.xml.microdom.MicroElement;

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
  private String m_sAs;
  private ICommonsList <IMicroElement> m_aBodyElements;

  public PSLet ()
  {}

  public boolean isValid (@NonNull final IPSErrorHandler aErrorHandler)
  {
    if (StringHelper.isEmpty (m_sName))
    {
      aErrorHandler.error (this, "<let> has no 'name'");
      return false;
    }
    if (StringHelper.isEmpty (m_sValue) && !hasBodyElements ())
    {
      aErrorHandler.error (this, "<let> has no 'value' and no body content");
      return false;
    }
    return true;
  }

  public void validateCompletely (@NonNull final IPSErrorHandler aErrorHandler)
  {
    if (StringHelper.isEmpty (m_sName))
      aErrorHandler.error (this, "<let> has no 'name'");
    if (StringHelper.isEmpty (m_sValue) && !hasBodyElements ())
      aErrorHandler.error (this, "<let> has no 'value' and no body content");
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

  /**
   * Set the optional <code>as</code> attribute introduced in
   * ISO/IEC 19757-3:2025. The attribute declares the datatype of the variable
   * and is interpreted by the active query language binding (e.g. an XSLT2
   * sequence type for the <code>xslt2</code> binding).
   *
   * @param sAs
   *        The new value. May be <code>null</code>.
   * @since 10.0.0 (Schematron 2025)
   */
  public void setAs (@Nullable final String sAs)
  {
    m_sAs = sAs;
  }

  /**
   * @return The value of the <code>as</code> attribute, or <code>null</code> if
   *         not set.
   * @since 10.0.0 (Schematron 2025)
   */
  @Nullable
  public String getAs ()
  {
    return m_sAs;
  }

  /**
   * Add a foreign body element to this {@code <let>}. Body elements model XSLT-style sequence
   * constructors carried in the element content (e.g. {@code <xsl:choose>...</xsl:choose>}). They
   * are only preserved when {@link com.helger.schematron.exchange.PSReader#setPreserveLetBodyElements(boolean)}
   * is enabled; downstream engines that understand XSLT (such as {@code SchematronResourcePureXslt})
   * emit them as the body of the generated {@code <xsl:variable>}.
   *
   * @param aBodyElement
   *        The body element. May not be <code>null</code>.
   * @since 10.0.0
   */
  public void addBodyElement (@NonNull final IMicroElement aBodyElement)
  {
    ValueEnforcer.notNull (aBodyElement, "BodyElement");
    if (m_aBodyElements == null)
      m_aBodyElements = new CommonsArrayList <> ();
    m_aBodyElements.add (aBodyElement);
  }

  /**
   * @return A defensive copy of the body elements declared inside this {@code <let>}. Never
   *         <code>null</code> but may be empty.
   * @since 10.0.0
   */
  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <IMicroElement> getAllBodyElements ()
  {
    return m_aBodyElements == null ? new CommonsArrayList <> () : m_aBodyElements.getClone ();
  }

  /**
   * @return <code>true</code> if this let has at least one body element.
   * @since 10.0.0
   */
  public boolean hasBodyElements ()
  {
    return m_aBodyElements != null && m_aBodyElements.isNotEmpty ();
  }

  @NonNull
  public IMicroElement getAsMicroElement ()
  {
    final IMicroElement ret = new MicroElement (CSchematron.NAMESPACE_SCHEMATRON, CSchematronXML.ELEMENT_LET);
    ret.setAttribute (CSchematronXML.ATTR_NAME, m_sName);
    if (StringHelper.isNotEmpty (m_sAs))
      ret.setAttribute (CSchematronXML.ATTR_AS, m_sAs);
    if (StringHelper.isNotEmpty (m_sValue))
      ret.setAttribute (CSchematronXML.ATTR_VALUE, m_sValue);
    if (m_aBodyElements != null)
      for (final IMicroElement aBody : m_aBodyElements)
        ret.addChild (aBody.getClone ());
    return ret;
  }

  @NonNull
  public PSLet getClone ()
  {
    final PSLet ret = new PSLet ();
    ret.setName (m_sName);
    ret.setValue (m_sValue);
    ret.setAs (m_sAs);
    if (m_aBodyElements != null)
      for (final IMicroElement aBody : m_aBodyElements)
        ret.addBodyElement (aBody.getClone ());
    return ret;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).appendIfNotNull ("Name", m_sName)
                                       .appendIfNotNull ("As", m_sAs)
                                       .appendIfNotNull ("Value", m_sValue)
                                       .getToString ();
  }

  @NonNull
  @ReturnsMutableCopy
  public static PSLet create (@Nullable final String sName, @Nullable final String sValue)
  {
    final PSLet ret = new PSLet ();
    ret.setName (sName);
    ret.setValue (sValue);
    return ret;
  }
}
