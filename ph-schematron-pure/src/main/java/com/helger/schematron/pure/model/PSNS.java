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
 * A single Schematron ns-element.<br>
 * Specification of a namespace prefix and URI. The required prefix attribute is
 * an XML name with no colon character. The required uri attribute is a
 * namespace URI.<br>
 * NOTE: Because the characters allowed as names may change in versions of XML
 * subsequent to W3C XML 1.0, the ISO/IEC 19757-2 (RELAX NG Compact Syntax)
 * schema for Schematron does not constrain the prefix to particular characters.
 * <br>
 * In an ISO Schematron schema, namespace prefixes in context expressions,
 * assertion tests and other query expressions should use the namespace bindings
 * provided by this element. Namespace prefixes should not use the namespace
 * bindings in scope for element and attribute names.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class PSNS implements IPSClonableElement <PSNS>, IPSHasForeignAttributes
{
  private String m_sUri;
  private String m_sPrefix;
  private ICommonsOrderedMap <String, String> m_aForeignAttrs;

  public PSNS ()
  {}

  public boolean isValid (@Nonnull final IPSErrorHandler aErrorHandler)
  {
    if (StringHelper.hasNoText (m_sUri))
    {
      aErrorHandler.error (this, "<ns> has no 'uri'");
      return false;
    }
    if (StringHelper.hasNoText (m_sPrefix))
    {
      aErrorHandler.error (this, "<ns> has no 'prefix'");
      return false;
    }
    return true;
  }

  public void validateCompletely (@Nonnull final IPSErrorHandler aErrorHandler)
  {
    if (StringHelper.hasNoText (m_sUri))
      aErrorHandler.error (this, "<ns> has no 'uri'");
    if (StringHelper.hasNoText (m_sPrefix))
      aErrorHandler.error (this, "<ns> has no 'prefix'");
  }

  public boolean isMinimal ()
  {
    return true;
  }

  public void addForeignAttribute (@Nonnull final String sAttrName, @Nonnull final String sAttrValue)
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

  @Nonnull
  @ReturnsMutableCopy
  public ICommonsOrderedMap <String, String> getAllForeignAttributes ()
  {
    return new CommonsLinkedHashMap <> (m_aForeignAttrs);
  }

  /**
   * @return The namespace URI. May be <code>null</code>.
   */
  @Nullable
  public String getUri ()
  {
    return m_sUri;
  }

  /**
   * @param sUri
   *        The namespace URI. May be <code>null</code>.
   */
  public void setUri (@Nullable final String sUri)
  {
    m_sUri = sUri;
  }

  /**
   * @return The namespace prefix. May be <code>null</code>.
   */
  @Nullable
  public String getPrefix ()
  {
    return m_sPrefix;
  }

  /**
   * @param sPrefix
   *        The namespace prefix to use. May be <code>null</code>.
   */
  public void setPrefix (@Nullable final String sPrefix)
  {
    m_sPrefix = sPrefix;
  }

  @Nonnull
  public IMicroElement getAsMicroElement ()
  {
    final IMicroElement ret = new MicroElement (CSchematron.NAMESPACE_SCHEMATRON, CSchematronXML.ELEMENT_NS);
    ret.setAttribute (CSchematronXML.ATTR_PREFIX, m_sPrefix);
    ret.setAttribute (CSchematronXML.ATTR_URI, m_sUri);
    if (m_aForeignAttrs != null)
      for (final Map.Entry <String, String> aEntry : m_aForeignAttrs.entrySet ())
        ret.setAttribute (aEntry.getKey (), aEntry.getValue ());
    return ret;
  }

  @Nonnull
  public PSNS getClone ()
  {
    final PSNS ret = new PSNS ();
    ret.setUri (m_sUri);
    ret.setPrefix (m_sPrefix);
    if (hasForeignAttributes ())
      ret.addForeignAttributes (m_aForeignAttrs);
    return ret;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).appendIfNotNull ("uri", m_sUri)
                                       .appendIfNotNull ("prefix", m_sPrefix)
                                       .appendIf ("foreignAttrs", m_aForeignAttrs, CollectionHelper::isNotEmpty)
                                       .getToString ();
  }

  /**
   * Factory method to create a new {@link PSNS} with certain "prefix" and "uri"
   * values
   *
   * @param sPrefix
   *        The namespace prefix to use. May be <code>null</code>.
   * @param sUri
   *        The namespace URI. May be <code>null</code>.
   * @return Never <code>null</code>.
   * @since 6.2.3
   */
  @Nonnull
  public static PSNS ofPrefixAndUri (@Nullable final String sPrefix, @Nullable final String sUri)
  {
    final PSNS ret = new PSNS ();
    ret.setPrefix (sPrefix);
    ret.setUri (sUri);
    return ret;
  }
}
