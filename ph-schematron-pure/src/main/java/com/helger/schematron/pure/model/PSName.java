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

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
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
 * A single Schematron name-element.<br>
 * Provides the names of nodes from the instance document to allow clearer
 * assertions and diagnostics. The optional path attribute is an expression
 * evaluated in the current context that returns a string that is the name of a
 * node. In the latter case, the name of the node is used.<br>
 * An implementation which does not report natural-language assertions is not
 * required to make use of this element.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class PSName implements IPSClonableElement <PSName>, IPSHasForeignAttributes
{
  private String m_sPath;
  private ICommonsOrderedMap <String, String> m_aForeignAttrs;

  public PSName ()
  {}

  public boolean isValid (@NonNull final IPSErrorHandler aErrorHandler)
  {
    return true;
  }

  public void validateCompletely (@NonNull final IPSErrorHandler aErrorHandler)
  {
    // Nothing to do
  }

  public boolean isMinimal ()
  {
    return true;
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsOrderedMap <String, String> getAllForeignAttributes ()
  {
    return new CommonsLinkedHashMap <> (m_aForeignAttrs);
  }

  public boolean hasForeignAttributes ()
  {
    return m_aForeignAttrs != null && m_aForeignAttrs.isNotEmpty ();
  }

  public void addForeignAttribute (@NonNull final String sAttrName, @NonNull final String sAttrValue)
  {
    ValueEnforcer.notNull (sAttrName, "AttrName");
    ValueEnforcer.notNull (sAttrValue, "AttrValue");
    if (m_aForeignAttrs == null)
      m_aForeignAttrs = new CommonsLinkedHashMap <> ();
    m_aForeignAttrs.put (sAttrName, sAttrValue);
  }

  /**
   * @return The optional path to use.
   */
  @Nullable
  public String getPath ()
  {
    return m_sPath;
  }

  /**
   * @return <code>true</code> if a path is specified, <code>false</code>
   *         otherwise.
   */
  public boolean hasPath ()
  {
    return m_sPath != null;
  }

  /**
   * @param sPath
   *        The path to use. May be <code>null</code>.
   */
  public void setPath (@Nullable final String sPath)
  {
    m_sPath = sPath;
  }

  @NonNull
  public IMicroElement getAsMicroElement ()
  {
    final IMicroElement ret = new MicroElement (CSchematron.NAMESPACE_SCHEMATRON, CSchematronXML.ELEMENT_NAME);
    ret.setAttribute (CSchematronXML.ATTR_PATH, m_sPath);
    if (m_aForeignAttrs != null)
      for (final Map.Entry <String, String> aEntry : m_aForeignAttrs.entrySet ())
        ret.setAttribute (aEntry.getKey (), aEntry.getValue ());
    return ret;
  }

  @NonNull
  public PSName getClone ()
  {
    final PSName ret = new PSName ();
    ret.setPath (m_sPath);
    if (hasForeignAttributes ())
      ret.addForeignAttributes (m_aForeignAttrs);
    return ret;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).appendIfNotNull ("path", m_sPath)
                                       .appendIf ("foreignAttrs", m_aForeignAttrs, CollectionHelper::isNotEmpty)
                                       .getToString ();
  }

  /**
   * Factory method to create a new {@link PSName} with a certain "path" value
   *
   * @param sPath
   *        The "path" value to be used. May be <code>null</code>.
   * @return Never <code>null</code>.
   * @since 6.2.3
   */
  @NonNull
  public static PSName ofPath (@Nullable final String sPath)
  {
    final PSName ret = new PSName ();
    ret.setPath (sPath);
    return ret;
  }
}
