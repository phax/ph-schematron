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
 * A single Schematron diagnostic-element.<br>
 * A natural-language message giving more specific details concerning a failed assertion, such as
 * found versus expected values and repair hints.<br>
 * NOTE: Diagnostics in multiple languages may be supported by using a different diagnostic element
 * for each language, with the appropriate xml:lang language attribute, and referencing all the
 * unique identifiers of the diagnostic elements in the diagnostics attribute of the assertion.
 * Annex G gives a simple example of a multi-lingual schema.<br>
 * An implementation is not required to make use of this element.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class PSDiagnostic implements
                          IPSClonableElement <PSDiagnostic>,
                          IPSOptionalElement,
                          IPSHasID,
                          IPSHasForeignElements,
                          IPSHasMixedContent,
                          IPSHasRichGroup
{
  private String m_sID;
  private PSRichGroup m_aRich;
  private final ICommonsList <Object> m_aContent = new CommonsArrayList <> ();
  private ICommonsOrderedMap <String, String> m_aForeignAttrs;

  public PSDiagnostic ()
  {}

  public boolean isValid (@NonNull final IPSErrorHandler aErrorHandler)
  {
    for (final Object aContent : m_aContent)
      if (aContent instanceof IPSElement)
        if (!((IPSElement) aContent).isValid (aErrorHandler))
          return false;
    if (StringHelper.isEmpty (m_sID))
    {
      aErrorHandler.error (this, "<diagnostic> has no 'id'");
      return false;
    }
    return true;
  }

  public void validateCompletely (@NonNull final IPSErrorHandler aErrorHandler)
  {
    for (final Object aContent : m_aContent)
      if (aContent instanceof IPSElement)
        ((IPSElement) aContent).validateCompletely (aErrorHandler);
    if (StringHelper.isEmpty (m_sID))
      aErrorHandler.error (this, "<diagnostic> has no 'id'");
  }

  public boolean isMinimal ()
  {
    return false;
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

  public void setID (@Nullable final String sID)
  {
    m_sID = sID;
  }

  @Nullable
  public String getID ()
  {
    return m_sID;
  }

  public void setRich (@Nullable final PSRichGroup aRich)
  {
    m_aRich = aRich;
  }

  @Nullable
  public PSRichGroup getRich ()
  {
    return m_aRich;
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

  /**
   * @return A list of {@link String}, {@link PSValueOf}, {@link PSEmph}, {@link PSDir} and
   *         {@link PSSpan} elements.
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
    final IMicroElement ret = new MicroElement (CSchematron.NAMESPACE_SCHEMATRON, CSchematronXML.ELEMENT_DIAGNOSTIC);
    ret.setAttribute (CSchematronXML.ATTR_ID, m_sID);
    if (m_aRich != null)
      m_aRich.fillMicroElement (ret);
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
  public PSDiagnostic getClone ()
  {
    final PSDiagnostic ret = new PSDiagnostic ();
    ret.setID (m_sID);
    ret.setRich (getRichClone ());
    for (final Object aContent : m_aContent)
    {
      if (aContent instanceof IMicroElement)
        ret.addForeignElement (((IMicroElement) aContent).getClone ());
      else
        if (aContent instanceof String)
          ret.addText ((String) aContent);
        else
          if (aContent instanceof PSValueOf)
            ret.addValueOf (((PSValueOf) aContent).getClone ());
          else
            if (aContent instanceof PSEmph)
              ret.addEmph (((PSEmph) aContent).getClone ());
            else
              if (aContent instanceof PSDir)
                ret.addDir (((PSDir) aContent).getClone ());
              else
                if (aContent instanceof PSSpan)
                  ret.addSpan (((PSSpan) aContent).getClone ());
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
    return new ToStringGenerator (this).appendIfNotNull ("id", m_sID)
                                       .appendIfNotNull ("rich", m_aRich)
                                       .appendIf ("content", m_aContent, CollectionHelper::isNotEmpty)
                                       .appendIf ("foreignAttrs", m_aForeignAttrs, CollectionHelper::isNotEmpty)
                                       .getToString ();
  }
}
