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
import com.helger.schematron.errorhandler.IPSErrorHandler;
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
  private String m_sHref;
  private ICommonsOrderedMap <String, String> m_aForeignAttrs;

  public PSExtends ()
  {}

  public boolean isValid (@NonNull final IPSErrorHandler aErrorHandler)
  {
    if (StringHelper.isEmpty (m_sRule) && StringHelper.isEmpty (m_sHref))
    {
      aErrorHandler.error (this, "<extends> has neither 'rule' nor 'href'");
      return false;
    }
    if (StringHelper.isNotEmpty (m_sRule) && StringHelper.isNotEmpty (m_sHref))
    {
      aErrorHandler.error (this, "<extends> has both 'rule' and 'href' (the v2+ RNC permits only one of them)");
      return false;
    }
    return true;
  }

  public void validateCompletely (@NonNull final IPSErrorHandler aErrorHandler)
  {
    if (StringHelper.isEmpty (m_sRule) && StringHelper.isEmpty (m_sHref))
      aErrorHandler.error (this, "<extends> has neither 'rule' nor 'href'");
    if (StringHelper.isNotEmpty (m_sRule) && StringHelper.isNotEmpty (m_sHref))
      aErrorHandler.error (this, "<extends> has both 'rule' and 'href' (the v2+ RNC permits only one of them)");
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

  /**
   * Set the optional <code>href</code> attribute introduced in ISO/IEC 19757-3:2016 as an
   * alternative to <code>rule</code>: when present the referenced fragment is spliced in place
   * of the <code>&lt;extends&gt;</code> element. The 2025 edition further relaxes the target so
   * the referenced rule need not be abstract.
   *
   * @param sHref
   *        The IRI reference. May be <code>null</code>.
   * @since 10.0.0 (Schematron 2016)
   */
  public void setHref (@Nullable final String sHref)
  {
    m_sHref = sHref;
  }

  /**
   * @return The value of the <code>href</code> attribute, or <code>null</code> if not set.
   * @since 10.0.0 (Schematron 2016)
   */
  @Nullable
  public String getHref ()
  {
    return m_sHref;
  }

  @NonNull
  public IMicroElement getAsMicroElement ()
  {
    final IMicroElement ret = new MicroElement (CSchematron.NAMESPACE_SCHEMATRON, CSchematronXML.ELEMENT_EXTENDS);
    if (StringHelper.isNotEmpty (m_sRule))
      ret.setAttribute (CSchematronXML.ATTR_RULE, m_sRule);
    if (StringHelper.isNotEmpty (m_sHref))
      ret.setAttribute (CSchematronXML.ATTR_HREF, m_sHref);
    if (m_aForeignAttrs != null)
      for (final Map.Entry <String, String> aEntry : m_aForeignAttrs.entrySet ())
        ret.setAttribute (aEntry.getKey (), aEntry.getValue ());
    return ret;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).appendIfNotNull ("Rule", m_sRule)
                                       .appendIfNotNull ("Href", m_sHref)
                                       .appendIf ("ForeignAttrs", m_aForeignAttrs, CollectionHelper::isNotEmpty)
                                       .getToString ();
  }
}
