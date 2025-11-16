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
 * A single Schematron phase-element.<br>
 * A grouping of patterns, to name and declare variations in schemas, for example, to support
 * progressive validation. The required id attribute is the name of the phase. The implementation
 * determines which phase to use for validating documents, for example by user command.<br>
 * Two names, #ALL and #DEFAULT, have special meanings. The name #ALL is reserved and available for
 * use by implementations to denote that all patterns are active. The name #DEFAULT is reserved and
 * available for use by implementations to denote that the name given in the defaultPhase attribute
 * on the schema element should be used. If no defaultPhase is specified, then all patterns are
 * active.<br>
 * NOTE: The names #ALL and #DEFAULT shall not be used in a Schematron schema. They are for use when
 * invoking or configuring schema validation, for example as a command-line parameter.<br>
 * The icon, see and fpi attributes allow rich interfaces and documentation.<br>
 * {@link PSPhase} elements are only referenced from {@link PSSchema} elements.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class PSPhase implements IPSElement, IPSHasForeignElements, IPSHasIncludes, IPSHasLets, IPSHasID, IPSHasRichGroup
{
  private String m_sID;
  private PSRichGroup m_aRich;
  private final ICommonsList <Object> m_aContent = new CommonsArrayList <> ();
  private ICommonsOrderedMap <String, String> m_aForeignAttrs;

  public PSPhase ()
  {}

  public boolean isValid (@NonNull final IPSErrorHandler aErrorHandler)
  {
    for (final Object aContent : m_aContent)
      if (aContent instanceof IPSElement)
        if (!((IPSElement) aContent).isValid (aErrorHandler))
          return false;
    if (StringHelper.isEmpty (m_sID))
    {
      aErrorHandler.error (this, "<phase> has no 'id'");
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
      aErrorHandler.error (this, "<phase> has no 'id'");
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

  public void addInclude (@NonNull final PSInclude aInclude)
  {
    ValueEnforcer.notNull (aInclude, "Include");
    m_aContent.add (aInclude);
  }

  public boolean hasAnyInclude ()
  {
    return m_aContent.containsAny (PSInclude.class::isInstance);
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <PSInclude> getAllIncludes ()
  {
    return m_aContent.getAllInstanceOf (PSInclude.class);
  }

  public void addP (@NonNull final PSP aP)
  {
    ValueEnforcer.notNull (aP, "P");
    m_aContent.add (aP);
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <PSP> getAllPs ()
  {
    return m_aContent.getAllInstanceOf (PSP.class);
  }

  public void addLet (@NonNull final PSLet aLet)
  {
    ValueEnforcer.notNull (aLet, "Let");
    m_aContent.add (aLet);
  }

  public boolean hasAnyLet ()
  {
    return m_aContent.containsAny (PSLet.class::isInstance);
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <PSLet> getAllLets ()
  {
    return m_aContent.getAllInstanceOf (PSLet.class);
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsOrderedMap <String, String> getAllLetsAsMap ()
  {
    final ICommonsOrderedMap <String, String> ret = new CommonsLinkedHashMap <> ();
    for (final Object aElement : m_aContent)
      if (aElement instanceof PSLet)
      {
        final PSLet aLet = (PSLet) aElement;
        ret.put (aLet.getName (), aLet.getValue ());
      }
    return ret;
  }

  public void addActive (@NonNull final PSActive aActive)
  {
    ValueEnforcer.notNull (aActive, "Active");
    m_aContent.add (aActive);
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <PSActive> getAllActives ()
  {
    return m_aContent.getAllInstanceOf (PSActive.class);
  }

  /**
   * @return A list of {@link PSActive}, {@link PSLet} and {@link PSP} elements.
   */
  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <IPSElement> getAllContentElements ()
  {
    // Remove includes
    return m_aContent.getAllMapped (x -> x instanceof IPSElement && !(x instanceof PSInclude), IPSElement.class::cast);
  }

  @NonNull
  public IMicroElement getAsMicroElement ()
  {
    final IMicroElement ret = new MicroElement (CSchematron.NAMESPACE_SCHEMATRON, CSchematronXML.ELEMENT_PHASE);
    ret.setAttribute (CSchematronXML.ATTR_ID, m_sID);
    if (m_aRich != null)
      m_aRich.fillMicroElement (ret);
    for (final Object aContent : m_aContent)
      if (aContent instanceof IMicroElement)
        ret.addChild (((IMicroElement) aContent).getClone ());
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
    return new ToStringGenerator (this).appendIfNotNull ("id", m_sID)
                                       .appendIfNotNull ("rich", m_aRich)
                                       .appendIf ("content", m_aContent, CollectionHelper::isNotEmpty)
                                       .appendIf ("foreignAttrs", m_aForeignAttrs, CollectionHelper::isNotEmpty)
                                       .getToString ();
  }
}
