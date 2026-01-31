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
import com.helger.schematron.pure.errorhandler.IPSErrorHandler;
import com.helger.xml.microdom.IMicroElement;
import com.helger.xml.microdom.MicroElement;

/**
 * A single Schematron active-element.<br>
 * The required pattern attribute is a reference to a pattern that is active in the current
 * phase.<br>
 * {@link PSActive} elements are only references from {@link PSPhase} elements.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class PSActive implements IPSClonableElement <PSActive>, IPSHasForeignElements, IPSHasMixedContent
{
  private String m_sPattern;
  private final ICommonsList <Object> m_aContent = new CommonsArrayList <> ();
  private ICommonsOrderedMap <String, String> m_aForeignAttrs;

  public PSActive ()
  {}

  public boolean isValid (@NonNull final IPSErrorHandler aErrorHandler)
  {
    for (final Object aContent : m_aContent)
      if (aContent instanceof IPSElement)
        if (!((IPSElement) aContent).isValid (aErrorHandler))
          return false;
    if (StringHelper.isEmpty (m_sPattern))
    {
      aErrorHandler.error (this, "<active> has no 'pattern'");
      return false;
    }
    return true;
  }

  public void validateCompletely (@NonNull final IPSErrorHandler aErrorHandler)
  {
    for (final Object aContent : m_aContent)
      if (aContent instanceof IPSElement)
        ((IPSElement) aContent).validateCompletely (aErrorHandler);
    if (StringHelper.isEmpty (m_sPattern))
      aErrorHandler.error (this, "<active> has no 'pattern'");
  }

  public boolean isMinimal ()
  {
    for (final Object aContent : m_aContent)
      if (aContent instanceof IPSElement)
        if (!((IPSElement) aContent).isMinimal ())
          return false;
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

  /**
   * @param sPattern
   *        The ID of the pattern to set active.
   */
  public void setPattern (@Nullable final String sPattern)
  {
    m_sPattern = sPattern;
  }

  /**
   * @return ID of the {@link PSPattern} to be marked active. May be <code>null</code>.
   */
  @Nullable
  public String getPattern ()
  {
    return m_sPattern;
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

  /**
   * @return A list of {@link String}, {@link PSDir}, {@link PSEmph} and {@link PSSpan} elements.
   */
  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <Object> getAllContentElements ()
  {
    return m_aContent.getClone ();
  }

  @NonNull
  public IMicroElement getAsMicroElement ()
  {
    final IMicroElement ret = new MicroElement (CSchematron.NAMESPACE_SCHEMATRON, CSchematronXML.ELEMENT_ACTIVE);
    ret.setAttribute (CSchematronXML.ATTR_PATTERN, m_sPattern);
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

  @NonNull
  public PSActive getClone ()
  {
    final PSActive ret = new PSActive ();
    ret.setPattern (m_sPattern);
    for (final Object aContent : m_aContent)
    {
      if (aContent instanceof String)
        ret.addText ((String) aContent);
      else
        if (aContent instanceof PSDir)
          ret.addDir (((PSDir) aContent).getClone ());
        else
          if (aContent instanceof PSEmph)
            ret.addEmph (((PSEmph) aContent).getClone ());
          else
            if (aContent instanceof PSSpan)
              ret.addSpan (((PSSpan) aContent).getClone ());
            else
              if (aContent instanceof IMicroElement)
                ret.addForeignElement (((IMicroElement) aContent).getClone ());
    }
    if (hasForeignAttributes ())
      ret.addForeignAttributes (m_aForeignAttrs);
    return ret;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).appendIfNotNull ("pattern", m_sPattern)
                                       .appendIf ("content", m_aContent, CollectionHelper::isNotEmpty)
                                       .appendIf ("foreignAttrs", m_aForeignAttrs, CollectionHelper::isNotEmpty)
                                       .getToString ();
  }
}
