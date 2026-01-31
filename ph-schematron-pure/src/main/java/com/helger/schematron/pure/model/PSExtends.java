/*
 * Copyright (C) 2014-2026 Philip Helger (www.helger.com)
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

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.string.StringHelper;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.collection.CollectionHelper;
import com.helger.collection.commons.CommonsLinkedHashMap;
import com.helger.collection.commons.ICommonsOrderedMap;
import com.helger.schematron.CSchematron;
import com.helger.schematron.CSchematronXML;
import com.helger.schematron.pure.errorhandler.IPSErrorHandler;
import com.helger.xml.microdom.IMicroElement;
import com.helger.xml.microdom.MicroElement;

/**
 * A single Schematron extends-element.<br>
 * Abstract rules are named lists of assertions without a context expression.
 * The required rule attribute references an abstract rule. The current rule
 * uses all the assertions from the abstract rule it extends.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class PSExtends implements IPSElement, IPSHasForeignAttributes
{
  private String m_sRule;
  private ICommonsOrderedMap <String, String> m_aForeignAttrs;

  public PSExtends ()
  {}

  public boolean isValid (@NonNull final IPSErrorHandler aErrorHandler)
  {
    if (StringHelper.isEmpty (m_sRule))
    {
      aErrorHandler.error (this, "<extends> has no 'rule'");
      return false;
    }
    return true;
  }

  public void validateCompletely (@NonNull final IPSErrorHandler aErrorHandler)
  {
    if (StringHelper.isEmpty (m_sRule))
      aErrorHandler.error (this, "<extends> has no 'rule'");
  }

  public boolean isMinimal ()
  {
    return false;
  }

  public void addForeignAttribute (@NonNull final String sAttrName, @NonNull final String sAttrValue)
  {
    ValueEnforcer.notNull (sAttrName, "AttrName");
    ValueEnforcer.notNull (sAttrValue, "AttrValue");
    if (m_aForeignAttrs == null)
      m_aForeignAttrs = new CommonsLinkedHashMap <> ();
    m_aForeignAttrs.put (sAttrName, sAttrValue);
  }

  public boolean hasForeignAttributes ()
  {
    return m_aForeignAttrs != null && m_aForeignAttrs.isNotEmpty ();
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsOrderedMap <String, String> getAllForeignAttributes ()
  {
    return new CommonsLinkedHashMap <> (m_aForeignAttrs);
  }

  public void setRule (@Nullable final String sRule)
  {
    m_sRule = sRule;
  }

  /**
   * @return Reference to a {@link PSRule} element
   */
  @Nullable
  public String getRule ()
  {
    return m_sRule;
  }

  @NonNull
  public IMicroElement getAsMicroElement ()
  {
    final IMicroElement ret = new MicroElement (CSchematron.NAMESPACE_SCHEMATRON, CSchematronXML.ELEMENT_EXTENDS);
    ret.setAttribute (CSchematronXML.ATTR_RULE, m_sRule);
    if (m_aForeignAttrs != null)
      for (final Map.Entry <String, String> aEntry : m_aForeignAttrs.entrySet ())
        ret.setAttribute (aEntry.getKey (), aEntry.getValue ());
    return ret;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).appendIfNotNull ("rule", m_sRule)
                                       .appendIf ("foreignAttrs", m_aForeignAttrs, CollectionHelper::isNotEmpty)
                                       .getToString ();
  }
}
