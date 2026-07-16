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

import com.helger.annotation.Nonempty;
import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.string.StringHelper;
import com.helger.base.string.StringImplode;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.collection.CollectionHelper;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.CommonsLinkedHashMap;
import com.helger.collection.commons.ICommonsList;
import com.helger.collection.commons.ICommonsOrderedMap;
import com.helger.schematron.CSchematron;
import com.helger.schematron.CSchematronXML;
import com.helger.schematron.errorhandler.IPSErrorHandler;
import com.helger.xml.microdom.IMicroElement;
import com.helger.xml.microdom.MicroElement;

/**
 * A single Schematron span-element.<br>
 * A portion of some paragraph that should be rendered in a distinct way, keyed with the class
 * attribute.<br>
 * An implementation is not required to make use of this element.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class PSSpan implements IPSClonableElement <PSSpan>, IPSOptionalElement, IPSHasForeignElements, IPSHasTexts
{
  private String m_sClass;
  private final ICommonsList <Object> m_aContent = new CommonsArrayList <> ();
  private ICommonsOrderedMap <String, String> m_aForeignAttrs;

  public PSSpan ()
  {}

  public boolean isValid (@NonNull final IPSErrorHandler aErrorHandler)
  {
    if (StringHelper.isEmpty (m_sClass))
    {
      aErrorHandler.error (this, "<span> has no 'class'");
      return false;
    }
    if (m_aContent.isEmpty ())
    {
      aErrorHandler.error (this, "<span> has no content");
      return false;
    }
    return true;
  }

  public void validateCompletely (@NonNull final IPSErrorHandler aErrorHandler)
  {
    if (StringHelper.isEmpty (m_sClass))
      aErrorHandler.error (this, "<span> has no 'class'");
    if (m_aContent.isEmpty ())
      aErrorHandler.error (this, "<span> has no content");
  }

  public boolean isMinimal ()
  {
    return true;
  }

  public void addForeignElement (@NonNull final IMicroElement aForeignElement)
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

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <IMicroElement> getAllForeignElements ()
  {
    return m_aContent.getAllInstanceOf (IMicroElement.class);
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

  public void setClazz (@Nullable final String sClass)
  {
    m_sClass = sClass;
  }

  @Nullable
  public String getClazz ()
  {
    return m_sClass;
  }

  public void addText (@NonNull @Nonempty final String sText)
  {
    ValueEnforcer.notEmpty (sText, "Text");
    m_aContent.add (sText);
  }

  public boolean hasAnyText ()
  {
    return m_aContent.containsAny (String.class::isInstance);
  }

  /**
   * @return The mixed content of this span element in source order. Elements are either
   *         {@link String} or {@link com.helger.xml.microdom.IMicroElement} (foreign).
   * @since 10.0.0
   */
  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <Object> getAllContentElements ()
  {
    return m_aContent.getClone ();
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <String> getAllTexts ()
  {
    return m_aContent.getAllInstanceOf (String.class);
  }

  @Nullable
  public String getAsText ()
  {
    final ICommonsList <String> aTexts = getAllTexts ();
    return aTexts.isEmpty () ? null : StringImplode.getImploded (aTexts);
  }

  /**
   * Append a {@link PSName} dynamic-content child. Permitted by the v4 RNC; pre-2025 schemas using
   * this combination are flagged through {@link PSVersionChecker}.
   *
   * @param aName
   *        The element to add. May not be <code>null</code>.
   * @since 10.0.0 (Schematron 2025)
   */
  public void addName (@NonNull final PSName aName)
  {
    ValueEnforcer.notNull (aName, "Name");
    m_aContent.add (aName);
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <PSName> getAllNames ()
  {
    return m_aContent.getAllInstanceOf (PSName.class);
  }

  /**
   * Append a {@link PSValueOf} dynamic-content child. Permitted by the v4 RNC; pre-2025 schemas
   * using this combination are flagged through {@link PSVersionChecker}.
   *
   * @param aValueOf
   *        The element to add. May not be <code>null</code>.
   * @since 10.0.0 (Schematron 2025)
   */
  public void addValueOf (@NonNull final PSValueOf aValueOf)
  {
    ValueEnforcer.notNull (aValueOf, "ValueOf");
    m_aContent.add (aValueOf);
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <PSValueOf> getAllValueOfs ()
  {
    return m_aContent.getAllInstanceOf (PSValueOf.class);
  }

  @NonNull
  public IMicroElement getAsMicroElement ()
  {
    final IMicroElement ret = new MicroElement (CSchematron.NAMESPACE_SCHEMATRON, CSchematronXML.ELEMENT_SPAN);
    ret.setAttribute (CSchematronXML.ATTR_CLASS, m_sClass);
    for (final Object aContent : m_aContent)
      if (aContent instanceof final IMicroElement x)
        ret.addChild (x.getClone ());
      else
        if (aContent instanceof final String x)
          ret.addText (x);
        else
          ret.addChild (((IPSElement) aContent).getAsMicroElement ());
    if (m_aForeignAttrs != null)
      for (final Map.Entry <String, String> aEntry : m_aForeignAttrs.entrySet ())
        ret.setAttribute (aEntry.getKey (), aEntry.getValue ());
    return ret;
  }

  @NonNull
  public PSSpan getClone ()
  {
    final PSSpan ret = new PSSpan ();
    ret.setClazz (m_sClass);
    for (final Object aContent : m_aContent)
    {
      if (aContent instanceof final IMicroElement x)
        ret.addForeignElement (x.getClone ());
      else
        if (aContent instanceof final String x)
          ret.addText (x);
        else
          if (aContent instanceof final PSName x)
            ret.addName (x);
          else
            if (aContent instanceof final PSValueOf x)
              ret.addValueOf (x);
            else
              throw new IllegalStateException ("Unexpected content element: " + aContent);
    }
    if (hasForeignAttributes ())
      ret.addForeignAttributes (m_aForeignAttrs);
    return ret;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).appendIfNotNull ("Class", m_sClass)
                                       .appendIf ("Content", m_aContent, CollectionHelper::isNotEmpty)
                                       .appendIf ("ForeignAttrs", m_aForeignAttrs, CollectionHelper::isNotEmpty)
                                       .getToString ();
  }
}
