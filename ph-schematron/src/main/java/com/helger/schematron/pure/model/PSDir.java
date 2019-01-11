/**
 * Copyright (C) 2014-2019 Philip Helger (www.helger.com)
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
import com.helger.commons.id.IHasID;
import com.helger.commons.lang.EnumHelper;
import com.helger.commons.string.StringHelper;
import com.helger.commons.string.ToStringGenerator;
import com.helger.schematron.CSchematron;
import com.helger.schematron.CSchematronXML;
import com.helger.schematron.pure.errorhandler.IPSErrorHandler;
import com.helger.xml.microdom.IMicroElement;
import com.helger.xml.microdom.MicroElement;

/**
 * A single Schematron dir-element.<br>
 * A section of natural-language text with a direction specified by the value
 * attribute. The value ltr indicates left-to-right text; the value rtl
 * indicates right-to-left text.<br>
 * An implementation is not required to make use of this element.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class PSDir implements IPSClonableElement <PSDir>, IPSOptionalElement, IPSHasForeignElements, IPSHasTexts
{
  public static enum EDirValue implements IHasID <String>
  {
    LTR ("ltr"),
    RTL ("rtl");

    private final String m_sID;

    private EDirValue (@Nonnull @Nonempty final String sID)
    {
      m_sID = sID;
    }

    @Nonnull
    @Nonempty
    public String getID ()
    {
      return m_sID;
    }

    @Nullable
    public static EDirValue getFromIDOrNull (@Nullable final String sID)
    {
      return EnumHelper.getFromIDOrNull (EDirValue.class, sID);
    }
  }

  private EDirValue m_eValue;
  private final ICommonsList <String> m_aContent = new CommonsArrayList <> ();
  private ICommonsOrderedMap <String, String> m_aForeignAttrs;
  private ICommonsList <IMicroElement> m_aForeignElements;

  public PSDir ()
  {}

  public boolean isValid (@Nonnull final IPSErrorHandler aErrorHandler)
  {
    if (m_aContent.isEmpty ())
    {
      aErrorHandler.error (this, "<dir> has no content");
      return false;
    }
    return true;
  }

  public void validateCompletely (@Nonnull final IPSErrorHandler aErrorHandler)
  {
    if (m_aContent.isEmpty ())
      aErrorHandler.error (this, "<dir> has no content");
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
      m_aForeignElements = new CommonsArrayList <> ();
    m_aForeignElements.add (aForeignElement);
  }

  public boolean hasForeignElements ()
  {
    return m_aForeignElements != null && m_aForeignElements.isNotEmpty ();
  }

  @Nonnull
  @ReturnsMutableCopy
  public ICommonsList <IMicroElement> getAllForeignElements ()
  {
    return new CommonsArrayList <> (m_aForeignElements);
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

  public void setValue (@Nullable final EDirValue eValue)
  {
    m_eValue = eValue;
  }

  @Nullable
  public EDirValue getValue ()
  {
    return m_eValue;
  }

  public void addText (@Nonnull @Nonempty final String sText)
  {
    ValueEnforcer.notEmpty (sText, "Text");
    m_aContent.add (sText);
  }

  public boolean hasAnyText ()
  {
    return m_aContent.isNotEmpty ();
  }

  @Nonnull
  @ReturnsMutableCopy
  public ICommonsList <String> getAllTexts ()
  {
    return m_aContent.getClone ();
  }

  @Nullable
  public String getAsText ()
  {
    return StringHelper.getImploded (m_aContent);
  }

  @Nonnull
  public IMicroElement getAsMicroElement ()
  {
    final IMicroElement ret = new MicroElement (CSchematron.NAMESPACE_SCHEMATRON, CSchematronXML.ELEMENT_DIR);
    if (m_eValue != null)
      ret.setAttribute (CSchematronXML.ATTR_VALUE, m_eValue.getID ());
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
  public PSDir getClone ()
  {
    final PSDir ret = new PSDir ();
    ret.setValue (m_eValue);
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
    return new ToStringGenerator (this).appendIfNotNull ("value", m_eValue)
                                       .appendIf ("content", m_aContent, CollectionHelper::isNotEmpty)
                                       .appendIf ("foreignAttrs", m_aForeignAttrs, CollectionHelper::isNotEmpty)
                                       .appendIf ("foreignElements", m_aForeignElements, CollectionHelper::isNotEmpty)
                                       .getToString ();
  }
}
