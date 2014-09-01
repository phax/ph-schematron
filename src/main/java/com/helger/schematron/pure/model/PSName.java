/**
 * Copyright (C) 2014 Philip Helger (www.helger.com)
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

import java.util.LinkedHashMap;
import java.util.Map;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.NotThreadSafe;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotations.ReturnsMutableCopy;
import com.helger.commons.collections.ContainerHelper;
import com.helger.commons.log.InMemoryLogger;
import com.helger.commons.microdom.IMicroElement;
import com.helger.commons.microdom.impl.MicroElement;
import com.helger.commons.string.ToStringGenerator;
import com.helger.schematron.CSchematron;
import com.helger.schematron.CSchematronXML;

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
  private Map <String, String> m_aForeignAttrs;

  public PSName ()
  {}

  public boolean isValid (@Nonnull final InMemoryLogger aLogger)
  {
    return true;
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
      m_aForeignAttrs = new LinkedHashMap <String, String> ();
    m_aForeignAttrs.put (sAttrName, sAttrValue);
  }

  public void addForeignAttributes (@Nonnull final Map <String, String> aForeignAttrs)
  {
    ValueEnforcer.notNull (aForeignAttrs, "ForeignAttrs");
    for (final Map.Entry <String, String> aEntry : aForeignAttrs.entrySet ())
      addForeignAttribute (aEntry.getKey (), aEntry.getValue ());
  }

  public boolean hasForeignAttributes ()
  {
    return m_aForeignAttrs != null && !m_aForeignAttrs.isEmpty ();
  }

  @Nonnull
  @ReturnsMutableCopy
  public Map <String, String> getAllForeignAttributes ()
  {
    return ContainerHelper.newOrderedMap (m_aForeignAttrs);
  }

  /**
   * @param sPath
   *        The path to use. May be <code>null</code>.
   */
  public void setPath (@Nullable final String sPath)
  {
    m_sPath = sPath;
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
   * @return The optional path to use.
   */
  @Nullable
  public String getPath ()
  {
    return m_sPath;
  }

  @Nonnull
  public IMicroElement getAsMicroElement ()
  {
    final IMicroElement ret = new MicroElement (CSchematron.NAMESPACE_SCHEMATRON, CSchematronXML.ELEMENT_NAME);
    ret.setAttribute (CSchematronXML.ATTR_PATH, m_sPath);
    if (m_aForeignAttrs != null)
      for (final Map.Entry <String, String> aEntry : m_aForeignAttrs.entrySet ())
        ret.setAttribute (aEntry.getKey (), aEntry.getValue ());
    return ret;
  }

  @Nonnull
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
                                       .appendIfNotNull ("foreignAttrs", m_aForeignAttrs)
                                       .toString ();
  }
}
