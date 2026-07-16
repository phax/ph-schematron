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
 * A single Schematron <code>property</code> element introduced in ISO/IEC 19757-3:2016.<br>
 * Declares arbitrary named metadata that can be attached to an assertion or report via the
 * <code>properties</code> IDREFS attribute. Per v2 5.5.10 the element carries a required
 * <code>id</code> attribute, optional <code>role</code> and <code>scheme</code> attributes, and
 * mixed content consisting of text plus the same set of inline elements permitted in an
 * assertion/report message (<code>name</code>, <code>value-of</code>, <code>emph</code>,
 * <code>dir</code>, <code>span</code> and foreign).
 *
 * @author Philip Helger
 * @since 10.0.0 (Schematron 2016)
 */
@NotThreadSafe
public class PSProperty implements IPSElement, IPSHasID, IPSHasForeignElements, IPSHasMixedContent
{
  private String m_sID;
  private String m_sRole;
  private String m_sScheme;
  private final ICommonsList <Object> m_aContent = new CommonsArrayList <> ();
  private ICommonsOrderedMap <String, String> m_aForeignAttrs;

  public PSProperty ()
  {}

  public boolean isValid (@NonNull final IPSErrorHandler aErrorHandler)
  {
    if (StringHelper.isEmpty (m_sID))
    {
      aErrorHandler.error (this, "<property> has no 'id'");
      return false;
    }
    for (final Object aContent : m_aContent)
      if (aContent instanceof IPSElement)
        if (!((IPSElement) aContent).isValid (aErrorHandler))
          return false;
    return true;
  }

  public void validateCompletely (@NonNull final IPSErrorHandler aErrorHandler)
  {
    if (StringHelper.isEmpty (m_sID))
      aErrorHandler.error (this, "<property> has no 'id'");
    for (final Object aContent : m_aContent)
      if (aContent instanceof IPSElement)
        ((IPSElement) aContent).validateCompletely (aErrorHandler);
  }

  public boolean isMinimal ()
  {
    return false;
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

  public void setRole (@Nullable final String sRole)
  {
    m_sRole = sRole;
  }

  @Nullable
  public String getRole ()
  {
    return m_sRole;
  }

  public void setScheme (@Nullable final String sScheme)
  {
    m_sScheme = sScheme;
  }

  @Nullable
  public String getScheme ()
  {
    return m_sScheme;
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

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <String> getAllTexts ()
  {
    return m_aContent.getAllInstanceOf (String.class);
  }

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

  public void addEmph (@NonNull final PSEmph aEmph)
  {
    ValueEnforcer.notNull (aEmph, "Emph");
    m_aContent.add (aEmph);
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <PSEmph> getAllEmphs ()
  {
    return m_aContent.getAllInstanceOf (PSEmph.class);
  }

  public void addDir (@NonNull final PSDir aDir)
  {
    ValueEnforcer.notNull (aDir, "Dir");
    m_aContent.add (aDir);
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <PSDir> getAllDirs ()
  {
    return m_aContent.getAllInstanceOf (PSDir.class);
  }

  public void addSpan (@NonNull final PSSpan aSpan)
  {
    ValueEnforcer.notNull (aSpan, "Span");
    m_aContent.add (aSpan);
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <PSSpan> getAllSpans ()
  {
    return m_aContent.getAllInstanceOf (PSSpan.class);
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <Object> getAllContentElements ()
  {
    return m_aContent.getClone ();
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

  public void addForeignElement (@NonNull final IMicroElement aForeignElement)
  {
    ValueEnforcer.notNull (aForeignElement, "ForeignElement");
    if (aForeignElement.hasParent ())
      throw new IllegalArgumentException ("ForeignElement already has a parent!");
    m_aContent.add (aForeignElement);
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

  public void addForeignAttribute (@NonNull final String sAttrName, @NonNull final String sAttrValue)
  {
    ValueEnforcer.notNull (sAttrName, "AttrName");
    ValueEnforcer.notNull (sAttrValue, "AttrValue");
    if (m_aForeignAttrs == null)
      m_aForeignAttrs = new CommonsLinkedHashMap <> ();
    m_aForeignAttrs.put (sAttrName, sAttrValue);
  }

  @NonNull
  public IMicroElement getAsMicroElement ()
  {
    final IMicroElement ret = new MicroElement (CSchematron.NAMESPACE_SCHEMATRON, CSchematronXML.ELEMENT_PROPERTY);
    ret.setAttribute (CSchematronXML.ATTR_ID, m_sID);
    if (StringHelper.isNotEmpty (m_sRole))
      ret.setAttribute (CSchematronXML.ATTR_ROLE, m_sRole);
    if (StringHelper.isNotEmpty (m_sScheme))
      ret.setAttribute (CSchematronXML.ATTR_SCHEME, m_sScheme);
    for (final Object aContent : m_aContent)
      if (aContent instanceof IMicroElement)
        ret.addChild (((IMicroElement) aContent).getClone ());
      else
        if (aContent instanceof String)
          ret.addText ((String) aContent);
        else
          ret.addChild (((IPSElement) aContent).getAsMicroElement ());
    if (m_aForeignAttrs != null)
      for (final Map.Entry <String, String> aEntry : m_aForeignAttrs.entrySet ())
        ret.setAttribute (aEntry.getKey (), aEntry.getValue ());
    return ret;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).appendIfNotNull ("ID", m_sID)
                                       .appendIfNotNull ("Role", m_sRole)
                                       .appendIfNotNull ("Scheme", m_sScheme)
                                       .appendIf ("Content", m_aContent, CollectionHelper::isNotEmpty)
                                       .appendIf ("ForeignAttrs", m_aForeignAttrs, CollectionHelper::isNotEmpty)
                                       .getToString ();
  }
}
