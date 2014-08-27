/**
 * Copyright (C) 2014 phloc systems (www.phloc.com)
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

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.NotThreadSafe;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotations.Nonempty;
import com.helger.commons.annotations.ReturnsMutableCopy;
import com.helger.commons.collections.ContainerHelper;
import com.helger.commons.log.InMemoryLogger;
import com.helger.commons.microdom.IMicroElement;
import com.helger.commons.microdom.impl.MicroElement;
import com.helger.commons.string.StringHelper;
import com.helger.commons.string.ToStringGenerator;
import com.helger.schematron.CSchematron;
import com.helger.schematron.CSchematronXML;

/**
 * A single Schematron span-element.<br>
 * A portion of some paragraph that should be rendered in a distinct way, keyed
 * with the class attribute.<br>
 * An implementation is not required to make use of this element.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class PSSpan implements IPSClonableElement <PSSpan>, IPSOptionalElement, IPSHasForeignElements, IPSHasTexts
{
  private String m_sClass;
  private final List <String> m_aContent = new ArrayList <String> ();
  private Map <String, String> m_aForeignAttrs;
  private List <IMicroElement> m_aForeignElements;

  public PSSpan ()
  {}

  public boolean isValid (@Nonnull final InMemoryLogger aLogger)
  {
    if (StringHelper.hasNoText (m_sClass))
    {
      aLogger.error ("<span> has no 'class'");
      return false;
    }
    if (m_aContent.isEmpty ())
    {
      aLogger.error ("<span> has no content");
      return false;
    }
    return true;
  }

  public boolean isMinimal ()
  {
    return true;
  }

  public void addForeignElement (@Nonnull final IMicroElement aForeignElement)
  {
    ValueEnforcer.notNull (aForeignElement, "ForeignElement");
    if (aForeignElement.hasParent ())
      throw new IllegalArgumentException ("ForeignElement already has a parent!");
    if (m_aForeignElements == null)
      m_aForeignElements = new ArrayList <IMicroElement> ();
    m_aForeignElements.add (aForeignElement);
  }

  public void addForeignElements (@Nonnull final List <IMicroElement> aForeignElements)
  {
    ValueEnforcer.notNull (aForeignElements, "ForeignElements");
    for (final IMicroElement aForeignElement : aForeignElements)
      addForeignElement (aForeignElement);
  }

  public boolean hasForeignElements ()
  {
    return m_aForeignElements != null && !m_aForeignElements.isEmpty ();
  }

  @Nonnull
  @ReturnsMutableCopy
  public List <IMicroElement> getAllForeignElements ()
  {
    return ContainerHelper.newList (m_aForeignElements);
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

  public void setClazz (@Nullable final String sClass)
  {
    m_sClass = sClass;
  }

  @Nullable
  public String getClazz ()
  {
    return m_sClass;
  }

  public void addText (@Nonnull @Nonempty final String sText)
  {
    ValueEnforcer.notEmpty (sText, "Text");
    m_aContent.add (sText);
  }

  public boolean hasAnyText ()
  {
    return !m_aContent.isEmpty ();
  }

  @Nonnull
  @ReturnsMutableCopy
  public List <String> getAllTexts ()
  {
    return ContainerHelper.newList (m_aContent);
  }

  @Nullable
  public String getAsText ()
  {
    return StringHelper.getImploded (m_aContent);
  }

  @Nonnull
  public IMicroElement getAsMicroElement ()
  {
    final IMicroElement ret = new MicroElement (CSchematron.NAMESPACE_SCHEMATRON, CSchematronXML.ELEMENT_SPAN);
    ret.setAttribute (CSchematronXML.ATTR_CLASS, m_sClass);
    if (m_aForeignElements != null)
      for (final IMicroElement aForeignElement : m_aForeignElements)
        ret.appendChild (aForeignElement.getClone ());
    for (final String sContent : m_aContent)
      ret.appendText (sContent);
    if (m_aForeignAttrs != null)
      for (final Map.Entry <String, String> aEntry : m_aForeignAttrs.entrySet ())
        ret.setAttribute (aEntry.getKey (), aEntry.getValue ());
    return ret;
  }

  @Nonnull
  public PSSpan getClone ()
  {
    final PSSpan ret = new PSSpan ();
    ret.setClazz (m_sClass);
    for (final String sContent : m_aContent)
      ret.addText (sContent);
    if (hasForeignElements ())
      ret.addForeignElements (m_aForeignElements);
    if (hasForeignAttributes ())
      ret.addForeignAttributes (m_aForeignAttrs);
    return ret;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).appendIfNotNull ("class", m_sClass)
                                       .append ("content", m_aContent)
                                       .appendIfNotNull ("foreignAttrs", m_aForeignAttrs)
                                       .appendIfNotNull ("foreignElements", m_aForeignElements)
                                       .toString ();
  }
}
