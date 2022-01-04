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

import java.util.Map;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.NotThreadSafe;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.Nonempty;
import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.CollectionHelper;
import com.helger.commons.collection.impl.CommonsArrayList;
import com.helger.commons.collection.impl.CommonsLinkedHashMap;
import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.collection.impl.ICommonsOrderedMap;
import com.helger.commons.string.StringHelper;
import com.helger.commons.string.ToStringGenerator;
import com.helger.schematron.CSchematron;
import com.helger.schematron.CSchematronXML;
import com.helger.schematron.pure.errorhandler.IPSErrorHandler;
import com.helger.xml.microdom.IMicroElement;
import com.helger.xml.microdom.MicroElement;

/**
 * A single Schematron p-element.<br>
 * A paragraph of natural language text containing maintainer and user
 * information about the parent element. The schema can nominate paragraphs that
 * should be rendered in a distinct way, keyed with the class attribute.<br>
 * An implementation is not required to make use of this element.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class PSP implements IPSElement, IPSOptionalElement, IPSHasForeignElements, IPSHasMixedContent, IPSHasID
{
  private String m_sID;
  private String m_sClass;
  private String m_sIcon;
  private final ICommonsList <Object> m_aContent = new CommonsArrayList <> ();
  private ICommonsOrderedMap <String, String> m_aForeignAttrs;

  public PSP ()
  {}

  public boolean isValid (@Nonnull final IPSErrorHandler aErrorHandler)
  {
    for (final Object aContent : m_aContent)
      if (aContent instanceof IPSElement)
        if (!((IPSElement) aContent).isValid (aErrorHandler))
          return false;
    return true;
  }

  public void validateCompletely (@Nonnull final IPSErrorHandler aErrorHandler)
  {
    for (final Object aContent : m_aContent)
      if (aContent instanceof IPSElement)
        ((IPSElement) aContent).validateCompletely (aErrorHandler);
  }

  public boolean isMinimal ()
  {
    return false;
  }

  public void addForeignElement (@Nonnull final IMicroElement aForeignElement)
  {
    ValueEnforcer.notNull (aForeignElement, "ForeignElement");
    if (aForeignElement.hasParent ())
      throw new IllegalArgumentException ("ForeignElement already has a parent!");
    m_aContent.add (aForeignElement);
  }

  public boolean hasForeignElements ()
  {
    return m_aContent.containsAny (IMicroElement.class::isInstance);
  }

  @Nonnull
  @ReturnsMutableCopy
  public ICommonsList <IMicroElement> getAllForeignElements ()
  {
    return m_aContent.getAllInstanceOf (IMicroElement.class);
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

  public void setID (@Nullable final String sID)
  {
    m_sID = sID;
  }

  @Nullable
  public String getID ()
  {
    return m_sID;
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

  public void setIcon (@Nullable final String sIcon)
  {
    m_sIcon = sIcon;
  }

  @Nullable
  public String getIcon ()
  {
    return m_sIcon;
  }

  public void addText (@Nonnull @Nonempty final String sText)
  {
    ValueEnforcer.notEmpty (sText, "Text");
    m_aContent.add (sText);
  }

  public boolean hasAnyText ()
  {
    return m_aContent.containsAny (String.class::isInstance);
  }

  @Nonnull
  @ReturnsMutableCopy
  public ICommonsList <String> getAllTexts ()
  {
    return m_aContent.getAllInstanceOf (String.class);
  }

  @Nullable
  public String getText ()
  {
    return StringHelper.getImploded (m_aContent);
  }

  public void addDir (@Nonnull final PSDir aDir)
  {
    ValueEnforcer.notNull (aDir, "Dir");
    m_aContent.add (aDir);
  }

  @Nonnull
  @ReturnsMutableCopy
  public ICommonsList <PSDir> getAllDirs ()
  {
    return m_aContent.getAllInstanceOf (PSDir.class);
  }

  public void addEmph (@Nonnull final PSEmph aEmph)
  {
    ValueEnforcer.notNull (aEmph, "Emph");
    m_aContent.add (aEmph);
  }

  @Nonnull
  @ReturnsMutableCopy
  public ICommonsList <PSEmph> getAllEmphs ()
  {
    return m_aContent.getAllInstanceOf (PSEmph.class);
  }

  public void addSpan (@Nonnull final PSSpan aSpan)
  {
    ValueEnforcer.notNull (aSpan, "Span");
    m_aContent.add (aSpan);
  }

  @Nonnull
  @ReturnsMutableCopy
  public ICommonsList <PSSpan> getAllSpans ()
  {
    return m_aContent.getAllInstanceOf (PSSpan.class);
  }

  /**
   * @return A list of {@link String}, {@link PSDir}, {@link PSEmph} and
   *         {@link PSSpan} elements.
   */
  @Nonnull
  @ReturnsMutableCopy
  public ICommonsList <Object> getAllContentElements ()
  {
    return m_aContent.getClone ();
  }

  @Nonnull
  public IMicroElement getAsMicroElement ()
  {
    final IMicroElement ret = new MicroElement (CSchematron.NAMESPACE_SCHEMATRON, CSchematronXML.ELEMENT_P);
    ret.setAttribute (CSchematronXML.ATTR_ID, m_sID);
    ret.setAttribute (CSchematronXML.ATTR_CLASS, m_sClass);
    ret.setAttribute (CSchematronXML.ATTR_ICON, m_sIcon);
    for (final Object aContent : m_aContent)
      if (aContent instanceof IMicroElement)
        ret.appendChild (((IMicroElement) aContent).getClone ());
      else
        if (aContent instanceof String)
          ret.appendText ((String) aContent);
        else
          ret.appendChild (((IPSElement) aContent).getAsMicroElement ());
    if (m_aForeignAttrs != null)
      for (final Map.Entry <String, String> aEntry : m_aForeignAttrs.entrySet ())
        ret.setAttribute (aEntry.getKey (), aEntry.getValue ());
    return ret;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).appendIfNotNull ("id", m_sID)
                                       .appendIfNotNull ("class", m_sClass)
                                       .appendIfNotNull ("icon", m_sIcon)
                                       .appendIf ("content", m_aContent, CollectionHelper::isNotEmpty)
                                       .appendIf ("foreignAttrs", m_aForeignAttrs, CollectionHelper::isNotEmpty)
                                       .getToString ();
  }
}
