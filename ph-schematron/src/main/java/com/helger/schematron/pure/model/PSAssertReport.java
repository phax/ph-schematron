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
import com.helger.commons.annotation.Nonempty;
import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.CollectionHelper;
import com.helger.commons.collection.impl.CommonsArrayList;
import com.helger.commons.collection.impl.CommonsLinkedHashMap;
import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.collection.impl.ICommonsOrderedMap;
import com.helger.commons.regex.RegExHelper;
import com.helger.commons.string.StringHelper;
import com.helger.commons.string.ToStringGenerator;
import com.helger.schematron.CSchematron;
import com.helger.schematron.CSchematronXML;
import com.helger.schematron.pure.errorhandler.IPSErrorHandler;
import com.helger.xml.microdom.IMicroElement;
import com.helger.xml.microdom.MicroElement;

/**
 * A single Schematron assert- or report-element.<br>
 * An assertion made about the context nodes. The data content is a
 * natural-language assertion. The required test attribute is an assertion test
 * evaluated in the current context. If the test evaluates positive, the
 * assertion succeeds. The optional diagnostics attribute is a reference to
 * further diagnostic information.<br>
 * The natural-language assertion shall be a positive statement of a constraint.
 * NOTE: The natural-language assertion may contain information about actual
 * values in addition to expected values and may contain diagnostic information.
 * Users should note, however, that the diagnostic element is provided for such
 * information to encourage clear statement of the natural-language assertion.
 * <br>
 * The icon, see and fpi attributes allow rich interfaces and documentation.<br>
 * The flag attribute allows more detailed outcomes.<br>
 * The role and subject attributes allow explicit identification of some part of
 * a pattern.<br>
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class PSAssertReport implements
                            IPSElement,
                            IPSHasFlag,
                            IPSHasForeignElements,
                            IPSHasMixedContent,
                            IPSHasID,
                            IPSHasRichGroup,
                            IPSHasLinkableGroup
{
  private final boolean m_bIsAssert;
  private String m_sTest;
  private String m_sFlag;
  private String m_sID;
  private ICommonsList <String> m_aDiagnostics;
  private PSRichGroup m_aRich;
  private PSLinkableGroup m_aLinkable;
  private final ICommonsList <Object> m_aContent = new CommonsArrayList <> ();
  private ICommonsOrderedMap <String, String> m_aForeignAttrs;
  private ICommonsList <IMicroElement> m_aForeignElements;

  public PSAssertReport (final boolean bIsAssert)
  {
    m_bIsAssert = bIsAssert;
  }

  public boolean isValid (@Nonnull final IPSErrorHandler aErrorHandler)
  {
    for (final Object aContent : m_aContent)
      if (aContent instanceof IPSElement)
        if (!((IPSElement) aContent).isValid (aErrorHandler))
          return false;
    if (StringHelper.hasNoText (m_sTest))
    {
      aErrorHandler.error (this, (m_bIsAssert ? "<assert>" : "<report>") + " has no 'test'");
      return false;
    }
    return true;
  }

  public void validateCompletely (@Nonnull final IPSErrorHandler aErrorHandler)
  {
    for (final Object aContent : m_aContent)
      if (aContent instanceof IPSElement)
        ((IPSElement) aContent).validateCompletely (aErrorHandler);
    if (StringHelper.hasNoText (m_sTest))
      aErrorHandler.error (this, (m_bIsAssert ? "<assert>" : "<report>") + " has no 'test'");
  }

  public boolean isMinimal ()
  {
    if (!m_bIsAssert)
      return false;
    for (final Object aContent : m_aContent)
      if (aContent instanceof IPSElement)
        if (!((IPSElement) aContent).isMinimal ())
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

  public boolean isAssert ()
  {
    return m_bIsAssert;
  }

  public boolean isReport ()
  {
    return !m_bIsAssert;
  }

  public void setTest (@Nullable final String sTest)
  {
    m_sTest = sTest;
  }

  @Nullable
  public String getTest ()
  {
    return m_sTest;
  }

  public void setFlag (@Nullable final String sFlag)
  {
    m_sFlag = sFlag;
  }

  @Nullable
  public String getFlag ()
  {
    return m_sFlag;
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

  /**
   * Set the diagnostics, as an IDREFS value (multiple IDREF values separated by
   * spaces)
   *
   * @param sDiagnostics
   *        The value to be set. May be <code>null</code>.
   */
  public void setDiagnostics (@Nullable final String sDiagnostics)
  {
    if (StringHelper.hasText (sDiagnostics))
      setDiagnostics (RegExHelper.getSplitToList (sDiagnostics.trim (), "\\s+"));
    else
      m_aDiagnostics = null;
  }

  /**
   * Set the diagnostics, as an IDREFS value (multiple IDREF values separated by
   * spaces)
   *
   * @param aDiagnostics
   *        The value to be set. May be <code>null</code>.
   */
  public void setDiagnostics (@Nullable final ICommonsList <String> aDiagnostics)
  {
    m_aDiagnostics = aDiagnostics;
  }

  /**
   * @return List of references to {@link PSDiagnostic} elements.
   */
  @Nonnull
  @ReturnsMutableCopy
  public ICommonsList <String> getAllDiagnostics ()
  {
    // May be null
    return new CommonsArrayList <> (m_aDiagnostics);
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

  public void setLinkable (@Nullable final PSLinkableGroup aLinkable)
  {
    m_aLinkable = aLinkable;
  }

  @Nullable
  public PSLinkableGroup getLinkable ()
  {
    return m_aLinkable;
  }

  public void addText (@Nonnull @Nonempty final String sText)
  {
    ValueEnforcer.notEmpty (sText, "Text");
    m_aContent.add (sText);
  }

  public boolean hasAnyText ()
  {
    return m_aContent.containsAny (e -> e instanceof String);
  }

  @Nonnull
  @ReturnsMutableCopy
  public ICommonsList <String> getAllTexts ()
  {
    return m_aContent.getAllInstanceOf (String.class);
  }

  public void addName (@Nonnull final PSName aName)
  {
    ValueEnforcer.notNull (aName, "Name");
    m_aContent.add (aName);
  }

  @Nonnull
  @ReturnsMutableCopy
  public ICommonsList <PSName> getAllNames ()
  {
    return m_aContent.getAllInstanceOf (PSName.class);
  }

  public void addValueOf (@Nonnull final PSValueOf aValueOf)
  {
    ValueEnforcer.notNull (aValueOf, "ValueOf");
    m_aContent.add (aValueOf);
  }

  @Nonnull
  @ReturnsMutableCopy
  public ICommonsList <PSValueOf> getAllValueOfs ()
  {
    return m_aContent.getAllInstanceOf (PSValueOf.class);
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
   * @return A list of {@link String}, {@link PSName}, {@link PSValueOf},
   *         {@link PSEmph}, {@link PSDir} and {@link PSSpan} elements.
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
    final IMicroElement ret = new MicroElement (CSchematron.NAMESPACE_SCHEMATRON,
                                                m_bIsAssert ? CSchematronXML.ELEMENT_ASSERT
                                                            : CSchematronXML.ELEMENT_REPORT);
    ret.setAttribute (CSchematronXML.ATTR_ID, m_sID);
    ret.setAttribute (CSchematronXML.ATTR_FLAG, m_sFlag);
    ret.setAttribute (CSchematronXML.ATTR_TEST, m_sTest);
    if (CollectionHelper.isNotEmpty (m_aDiagnostics))
      ret.setAttribute (CSchematronXML.ATTR_DIAGNOSTICS, StringHelper.getImploded (' ', m_aDiagnostics));
    if (m_aRich != null)
      m_aRich.fillMicroElement (ret);
    if (m_aLinkable != null)
      m_aLinkable.fillMicroElement (ret);
    if (m_aForeignElements != null)
      for (final IMicroElement aForeignElement : m_aForeignElements)
        ret.appendChild (aForeignElement.getClone ());
    for (final Object aContent : m_aContent)
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
    return new ToStringGenerator (this).append ("isAssert", m_bIsAssert)
                                       .appendIfNotNull ("test", m_sTest)
                                       .appendIfNotNull ("flag", m_sFlag)
                                       .appendIfNotNull ("id", m_sID)
                                       .appendIfNotNull ("diagnostics", m_aDiagnostics)
                                       .appendIfNotNull ("rich", m_aRich)
                                       .appendIfNotNull ("linkable", m_aLinkable)
                                       .appendIf ("content", m_aContent, CollectionHelper::isNotEmpty)
                                       .appendIf ("foreignAttrs", m_aForeignAttrs, CollectionHelper::isNotEmpty)
                                       .appendIf ("foreignElements", m_aForeignElements, CollectionHelper::isNotEmpty)
                                       .getToString ();
  }
}
