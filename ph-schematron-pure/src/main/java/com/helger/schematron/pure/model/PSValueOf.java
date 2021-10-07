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

import java.util.Map;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.NotThreadSafe;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.CollectionHelper;
import com.helger.commons.collection.impl.CommonsLinkedHashMap;
import com.helger.commons.collection.impl.ICommonsOrderedMap;
import com.helger.commons.string.StringHelper;
import com.helger.commons.string.ToStringGenerator;
import com.helger.schematron.CSchematron;
import com.helger.schematron.CSchematronXML;
import com.helger.schematron.pure.errorhandler.IPSErrorHandler;
import com.helger.xml.microdom.IMicroElement;
import com.helger.xml.microdom.MicroElement;

/**
 * A single Schematron value-of-element.<br>
 * Finds or calculates values from the instance document to allow clearer
 * assertions and diagnostics. The required select attribute is an expression
 * evaluated in the current context that returns a string.<br>
 * Variable references in the select attribute are resolved in the scope of the
 * current schema, phase, pattern and rule.<br>
 * An implementation which does not report natural-language assertions is not
 * required to make use of this element.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class PSValueOf implements IPSClonableElement <PSValueOf>, IPSHasForeignAttributes
{
  private String m_sSelect;
  private ICommonsOrderedMap <String, String> m_aForeignAttrs;

  public PSValueOf ()
  {}

  public boolean isValid (@Nonnull final IPSErrorHandler aErrorHandler)
  {
    if (StringHelper.hasNoText (m_sSelect))
    {
      aErrorHandler.error (this, "<value-of> has no 'select'");
      return false;
    }
    return true;
  }

  public void validateCompletely (@Nonnull final IPSErrorHandler aErrorHandler)
  {
    if (StringHelper.hasNoText (m_sSelect))
      aErrorHandler.error (this, "<value-of> has no 'select'");
  }

  public boolean isMinimal ()
  {
    return true;
  }

  @Nonnull
  @ReturnsMutableCopy
  public ICommonsOrderedMap <String, String> getAllForeignAttributes ()
  {
    return new CommonsLinkedHashMap <> (m_aForeignAttrs);
  }

  public boolean hasForeignAttributes ()
  {
    return m_aForeignAttrs != null && m_aForeignAttrs.isNotEmpty ();
  }

  public void addForeignAttribute (@Nonnull final String sAttrName, @Nonnull final String sAttrValue)
  {
    ValueEnforcer.notNull (sAttrName, "AttrName");
    ValueEnforcer.notNull (sAttrValue, "AttrValue");
    if (m_aForeignAttrs == null)
      m_aForeignAttrs = new CommonsLinkedHashMap <> ();
    m_aForeignAttrs.put (sAttrName, sAttrValue);
  }

  /**
   * @return The select expression string. May be <code>null</code>.
   */
  @Nullable
  public String getSelect ()
  {
    return m_sSelect;
  }

  /**
   * Set the expression to retrieve the value of
   *
   * @param sSelect
   *        The select expression string. May be <code>null</code>.
   */
  public void setSelect (@Nullable final String sSelect)
  {
    m_sSelect = sSelect;
  }

  @Nonnull
  public IMicroElement getAsMicroElement ()
  {
    final IMicroElement ret = new MicroElement (CSchematron.NAMESPACE_SCHEMATRON, CSchematronXML.ELEMENT_VALUE_OF);
    ret.setAttribute (CSchematronXML.ATTR_SELECT, m_sSelect);
    if (m_aForeignAttrs != null)
      for (final Map.Entry <String, String> aEntry : m_aForeignAttrs.entrySet ())
        ret.setAttribute (aEntry.getKey (), aEntry.getValue ());
    return ret;
  }

  @Nonnull
  public PSValueOf getClone ()
  {
    final PSValueOf ret = new PSValueOf ();
    ret.setSelect (m_sSelect);
    if (hasForeignAttributes ())
      ret.addForeignAttributes (m_aForeignAttrs);
    return ret;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).appendIfNotNull ("select", m_sSelect)
                                       .appendIf ("foreignAttrs", m_aForeignAttrs, CollectionHelper::isNotEmpty)
                                       .getToString ();
  }

  /**
   * Factory method to create a new {@link PSValueOf} with a certain "select"
   * value
   *
   * @param sSelect
   *        The "select" value to be used. May be <code>null</code>.
   * @return Never <code>null</code>.
   * @since 6.2.3
   */
  @Nonnull
  public static PSValueOf ofSelect (@Nullable final String sSelect)
  {
    final PSValueOf ret = new PSValueOf ();
    ret.setSelect (sSelect);
    return ret;
  }
}
