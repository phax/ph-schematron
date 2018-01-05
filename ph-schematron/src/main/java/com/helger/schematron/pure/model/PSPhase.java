/**
 * Copyright (C) 2014-2018 Philip Helger (www.helger.com)
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
 * A single Schematron phase-element.<br>
 * A grouping of patterns, to name and declare variations in schemas, for
 * example, to support progressive validation. The required id attribute is the
 * name of the phase. The implementation determines which phase to use for
 * validating documents, for example by user command.<br>
 * Two names, #ALL and #DEFAULT, have special meanings. The name #ALL is
 * reserved and available for use by implementations to denote that all patterns
 * are active. The name #DEFAULT is reserved and available for use by
 * implementations to denote that the name given in the defaultPhase attribute
 * on the schema element should be used. If no defaultPhase is specified, then
 * all patterns are active.<br>
 * NOTE: The names #ALL and #DEFAULT shall not be used in a Schematron schema.
 * They are for use when invoking or configuring schema validation, for example
 * as a command-line parameter.<br>
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
  private final ICommonsList <PSInclude> m_aIncludes = new CommonsArrayList <> ();
  private final ICommonsList <IPSElement> m_aContent = new CommonsArrayList <> ();
  private ICommonsOrderedMap <String, String> m_aForeignAttrs;
  private ICommonsList <IMicroElement> m_aForeignElements;

  public PSPhase ()
  {}

  public boolean isValid (@Nonnull final IPSErrorHandler aErrorHandler)
  {
    for (final PSInclude aInclude : m_aIncludes)
      if (!aInclude.isValid (aErrorHandler))
        return false;
    for (final IPSElement aContent : m_aContent)
      if (!aContent.isValid (aErrorHandler))
        return false;
    if (StringHelper.hasNoText (m_sID))
    {
      aErrorHandler.error (this, "<phase> has no 'id'");
      return false;
    }
    return true;
  }

  public void validateCompletely (@Nonnull final IPSErrorHandler aErrorHandler)
  {
    for (final PSInclude aInclude : m_aIncludes)
      aInclude.validateCompletely (aErrorHandler);
    for (final IPSElement aContent : m_aContent)
      aContent.validateCompletely (aErrorHandler);
    if (StringHelper.hasNoText (m_sID))
      aErrorHandler.error (this, "<phase> has no 'id'");
  }

  public boolean isMinimal ()
  {
    for (final PSInclude aInclude : m_aIncludes)
      if (!aInclude.isMinimal ())
        return false;
    for (final IPSElement aContent : m_aContent)
      if (!aContent.isMinimal ())
        return false;
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

  public void addInclude (@Nonnull final PSInclude aInclude)
  {
    ValueEnforcer.notNull (aInclude, "Include");
    m_aIncludes.add (aInclude);
  }

  public boolean hasAnyInclude ()
  {
    return m_aIncludes.isNotEmpty ();
  }

  @Nonnull
  @ReturnsMutableCopy
  public ICommonsList <PSInclude> getAllIncludes ()
  {
    return m_aIncludes.getClone ();
  }

  public void addP (@Nonnull final PSP aP)
  {
    ValueEnforcer.notNull (aP, "P");
    m_aContent.add (aP);
  }

  @Nonnull
  @ReturnsMutableCopy
  public ICommonsList <PSP> getAllPs ()
  {
    return m_aContent.getAllInstanceOf (PSP.class);
  }

  public void addLet (@Nonnull final PSLet aLet)
  {
    ValueEnforcer.notNull (aLet, "Let");
    m_aContent.add (aLet);
  }

  public boolean hasAnyLet ()
  {
    return m_aContent.containsAny (e -> e instanceof PSLet);
  }

  @Nonnull
  @ReturnsMutableCopy
  public ICommonsList <PSLet> getAllLets ()
  {
    return m_aContent.getAllInstanceOf (PSLet.class);
  }

  @Nonnull
  @ReturnsMutableCopy
  public ICommonsOrderedMap <String, String> getAllLetsAsMap ()
  {
    final ICommonsOrderedMap <String, String> ret = new CommonsLinkedHashMap <> ();
    for (final IPSElement aElement : m_aContent)
      if (aElement instanceof PSLet)
      {
        final PSLet aLet = (PSLet) aElement;
        ret.put (aLet.getName (), aLet.getValue ());
      }
    return ret;
  }

  public void addActive (@Nonnull final PSActive aActive)
  {
    ValueEnforcer.notNull (aActive, "Active");
    m_aContent.add (aActive);
  }

  @Nonnull
  @ReturnsMutableCopy
  public ICommonsList <PSActive> getAllActives ()
  {
    return m_aContent.getAllInstanceOf (PSActive.class);
  }

  /**
   * @return A list of {@link PSActive}, {@link PSLet} and {@link PSP} elements.
   */
  @Nonnull
  @ReturnsMutableCopy
  public ICommonsList <IPSElement> getAllContentElements ()
  {
    return m_aContent.getClone ();
  }

  @Nonnull
  public IMicroElement getAsMicroElement ()
  {
    final IMicroElement ret = new MicroElement (CSchematron.NAMESPACE_SCHEMATRON, CSchematronXML.ELEMENT_PHASE);
    ret.setAttribute (CSchematronXML.ATTR_ID, m_sID);
    if (m_aRich != null)
      m_aRich.fillMicroElement (ret);
    if (m_aForeignElements != null)
      for (final IMicroElement aForeignElement : m_aForeignElements)
        ret.appendChild (aForeignElement.getClone ());
    for (final PSInclude aInclude : m_aIncludes)
      ret.appendChild (aInclude.getAsMicroElement ());
    for (final IPSElement aContent : m_aContent)
      ret.appendChild (aContent.getAsMicroElement ());
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
                                       .appendIf ("includes", m_aIncludes, CollectionHelper::isNotEmpty)
                                       .appendIf ("content", m_aContent, CollectionHelper::isNotEmpty)
                                       .appendIf ("foreignAttrs", m_aForeignAttrs, CollectionHelper::isNotEmpty)
                                       .appendIf ("foreignElements", m_aForeignElements, CollectionHelper::isNotEmpty)
                                       .getToString ();
  }
}
