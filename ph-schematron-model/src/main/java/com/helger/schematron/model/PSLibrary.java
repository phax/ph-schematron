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

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
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
 * A single Schematron <code>library</code> element introduced in ISO/IEC 19757-3:2025.<br>
 * A <code>library</code> is an allowed root element holding external declarations
 * (<code>param</code>, <code>let</code>, abstract <code>rules</code>, <code>pattern</code>s,
 * <code>group</code>s) intended to be pulled into a {@link PSSchema} via top-level
 * {@link PSExtends} or {@link PSInclude} references.
 * <p>
 * Per the v4 RELAX NG schema:
 *
 * <pre>
 * library =
 *     element library {
 *         attribute id { xsd:ID }?,
 *         rich,
 *         (foreign
 *         &amp; (inclusion | extends)*
 *         &amp; (title?, p*, param*, let*, abstract-rules*, (rule-set|pattern)*,
 *            p*, diagnostics?, properties?))
 *     }
 * </pre>
 *
 * @author Philip Helger
 * @since 10.0.0 (Schematron 2025)
 */
@NotThreadSafe
public class PSLibrary implements IPSElement, IPSHasID, IPSHasIncludes, IPSHasLets, IPSHasRichGroup
{
  private String m_sID;
  private PSRichGroup m_aRich;
  private PSTitle m_aTitle;
  private final ICommonsList <PSInclude> m_aIncludes = new CommonsArrayList <> ();
  private final ICommonsList <PSExtends> m_aExtends = new CommonsArrayList <> ();
  private final ICommonsList <PSP> m_aStartPs = new CommonsArrayList <> ();
  private final ICommonsList <PSParam> m_aParams = new CommonsArrayList <> ();
  private final ICommonsList <PSLet> m_aLets = new CommonsArrayList <> ();
  private final ICommonsList <PSRules> m_aAbstractRulesContainers = new CommonsArrayList <> ();
  private final ICommonsList <PSPattern> m_aPatterns = new CommonsArrayList <> ();
  private final ICommonsList <PSGroup> m_aGroups = new CommonsArrayList <> ();
  private final ICommonsList <PSP> m_aEndPs = new CommonsArrayList <> ();
  private PSDiagnostics m_aDiagnostics;

  public PSLibrary ()
  {}

  public boolean isValid (@NonNull final IPSErrorHandler aErrorHandler)
  {
    if (m_aTitle != null && !m_aTitle.isValid (aErrorHandler))
      return false;
    for (final PSInclude aInclude : m_aIncludes)
      if (!aInclude.isValid (aErrorHandler))
        return false;
    for (final PSExtends aExtends : m_aExtends)
      if (!aExtends.isValid (aErrorHandler))
        return false;
    for (final PSP aP : m_aStartPs)
      if (!aP.isValid (aErrorHandler))
        return false;
    for (final PSParam aParam : m_aParams)
      if (!aParam.isValid (aErrorHandler))
        return false;
    for (final PSLet aLet : m_aLets)
      if (!aLet.isValid (aErrorHandler))
        return false;
    for (final PSRules aRules : m_aAbstractRulesContainers)
      if (!aRules.isValid (aErrorHandler))
        return false;
    for (final PSPattern aPattern : m_aPatterns)
      if (!aPattern.isValid (aErrorHandler))
        return false;
    for (final PSGroup aGroup : m_aGroups)
      if (!aGroup.isValid (aErrorHandler))
        return false;
    for (final PSP aP : m_aEndPs)
      if (!aP.isValid (aErrorHandler))
        return false;
    if (m_aDiagnostics != null && !m_aDiagnostics.isValid (aErrorHandler))
      return false;
    return true;
  }

  public void validateCompletely (@NonNull final IPSErrorHandler aErrorHandler)
  {
    if (m_aTitle != null)
      m_aTitle.validateCompletely (aErrorHandler);
    for (final PSInclude aInclude : m_aIncludes)
      aInclude.validateCompletely (aErrorHandler);
    for (final PSExtends aExtends : m_aExtends)
      aExtends.validateCompletely (aErrorHandler);
    for (final PSP aP : m_aStartPs)
      aP.validateCompletely (aErrorHandler);
    for (final PSParam aParam : m_aParams)
      aParam.validateCompletely (aErrorHandler);
    for (final PSLet aLet : m_aLets)
      aLet.validateCompletely (aErrorHandler);
    for (final PSRules aRules : m_aAbstractRulesContainers)
      aRules.validateCompletely (aErrorHandler);
    for (final PSPattern aPattern : m_aPatterns)
      aPattern.validateCompletely (aErrorHandler);
    for (final PSGroup aGroup : m_aGroups)
      aGroup.validateCompletely (aErrorHandler);
    for (final PSP aP : m_aEndPs)
      aP.validateCompletely (aErrorHandler);
    if (m_aDiagnostics != null)
      m_aDiagnostics.validateCompletely (aErrorHandler);
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

  public void setRich (@Nullable final PSRichGroup aRich)
  {
    m_aRich = aRich;
  }

  @Nullable
  public PSRichGroup getRich ()
  {
    return m_aRich;
  }

  public void setTitle (@Nullable final PSTitle aTitle)
  {
    m_aTitle = aTitle;
  }

  @Nullable
  public PSTitle getTitle ()
  {
    return m_aTitle;
  }

  public boolean hasTitle ()
  {
    return m_aTitle != null;
  }

  public void addInclude (@NonNull final PSInclude aInclude)
  {
    ValueEnforcer.notNull (aInclude, "Include");
    m_aIncludes.add (aInclude);
  }

  public boolean hasAnyInclude ()
  {
    return m_aIncludes.isNotEmpty ();
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <PSInclude> getAllIncludes ()
  {
    return m_aIncludes.getClone ();
  }

  public void addExtends (@NonNull final PSExtends aExtends)
  {
    ValueEnforcer.notNull (aExtends, "Extends");
    m_aExtends.add (aExtends);
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <PSExtends> getAllExtends ()
  {
    return m_aExtends.getClone ();
  }

  public void addStartP (@NonNull final PSP aP)
  {
    ValueEnforcer.notNull (aP, "P");
    m_aStartPs.add (aP);
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <PSP> getAllStartPs ()
  {
    return m_aStartPs.getClone ();
  }

  public void addParam (@NonNull final PSParam aParam)
  {
    ValueEnforcer.notNull (aParam, "Param");
    m_aParams.add (aParam);
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <PSParam> getAllParams ()
  {
    return m_aParams.getClone ();
  }

  public void addLet (@NonNull final PSLet aLet)
  {
    ValueEnforcer.notNull (aLet, "Let");
    m_aLets.add (aLet);
  }

  public boolean hasAnyLet ()
  {
    return m_aLets.isNotEmpty ();
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <PSLet> getAllLets ()
  {
    return m_aLets.getClone ();
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsOrderedMap <String, String> getAllLetsAsMap ()
  {
    final ICommonsOrderedMap <String, String> ret = new CommonsLinkedHashMap <> ();
    for (final PSLet aLet : m_aLets)
      ret.put (aLet.getName (), aLet.getValue ());
    return ret;
  }

  public void addAbstractRulesContainer (@NonNull final PSRules aRules)
  {
    ValueEnforcer.notNull (aRules, "Rules");
    m_aAbstractRulesContainers.add (aRules);
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <PSRules> getAllAbstractRulesContainers ()
  {
    return m_aAbstractRulesContainers.getClone ();
  }

  public void addPattern (@NonNull final PSPattern aPattern)
  {
    ValueEnforcer.notNull (aPattern, "Pattern");
    m_aPatterns.add (aPattern);
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <PSPattern> getAllPatterns ()
  {
    return m_aPatterns.getClone ();
  }

  public void addGroup (@NonNull final PSGroup aGroup)
  {
    ValueEnforcer.notNull (aGroup, "Group");
    m_aGroups.add (aGroup);
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <PSGroup> getAllGroups ()
  {
    return m_aGroups.getClone ();
  }

  public void addEndP (@NonNull final PSP aP)
  {
    ValueEnforcer.notNull (aP, "P");
    m_aEndPs.add (aP);
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <PSP> getAllEndPs ()
  {
    return m_aEndPs.getClone ();
  }

  public void setDiagnostics (@Nullable final PSDiagnostics aDiagnostics)
  {
    m_aDiagnostics = aDiagnostics;
  }

  @Nullable
  public PSDiagnostics getDiagnostics ()
  {
    return m_aDiagnostics;
  }

  public boolean hasDiagnostics ()
  {
    return m_aDiagnostics != null;
  }

  @NonNull
  public IMicroElement getAsMicroElement ()
  {
    final IMicroElement ret = new MicroElement (CSchematron.NAMESPACE_SCHEMATRON, CSchematronXML.ELEMENT_LIBRARY);
    ret.setAttribute (CSchematronXML.ATTR_ID, m_sID);
    if (m_aRich != null)
      m_aRich.fillMicroElement (ret);
    for (final PSInclude aInclude : m_aIncludes)
      ret.addChild (aInclude.getAsMicroElement ());
    for (final PSExtends aExtends : m_aExtends)
      ret.addChild (aExtends.getAsMicroElement ());
    if (m_aTitle != null)
      ret.addChild (m_aTitle.getAsMicroElement ());
    for (final PSP aP : m_aStartPs)
      ret.addChild (aP.getAsMicroElement ());
    for (final PSParam aParam : m_aParams)
      ret.addChild (aParam.getAsMicroElement ());
    for (final PSLet aLet : m_aLets)
      ret.addChild (aLet.getAsMicroElement ());
    for (final PSRules aRules : m_aAbstractRulesContainers)
      ret.addChild (aRules.getAsMicroElement ());
    for (final PSPattern aPattern : m_aPatterns)
      ret.addChild (aPattern.getAsMicroElement ());
    for (final PSGroup aGroup : m_aGroups)
      ret.addChild (aGroup.getAsMicroElement ());
    for (final PSP aP : m_aEndPs)
      ret.addChild (aP.getAsMicroElement ());
    if (m_aDiagnostics != null)
      ret.addChild (m_aDiagnostics.getAsMicroElement ());
    return ret;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).appendIfNotNull ("ID", m_sID)
                                       .appendIfNotNull ("Rich", m_aRich)
                                       .appendIfNotNull ("Title", m_aTitle)
                                       .appendIf ("Includes", m_aIncludes, CollectionHelper::isNotEmpty)
                                       .appendIf ("Extends", m_aExtends, CollectionHelper::isNotEmpty)
                                       .appendIf ("StartPs", m_aStartPs, CollectionHelper::isNotEmpty)
                                       .appendIf ("Params", m_aParams, CollectionHelper::isNotEmpty)
                                       .appendIf ("Lets", m_aLets, CollectionHelper::isNotEmpty)
                                       .appendIf ("AbstractRulesContainers",
                                                  m_aAbstractRulesContainers,
                                                  CollectionHelper::isNotEmpty)
                                       .appendIf ("Patterns", m_aPatterns, CollectionHelper::isNotEmpty)
                                       .appendIf ("Groups", m_aGroups, CollectionHelper::isNotEmpty)
                                       .appendIf ("EndPs", m_aEndPs, CollectionHelper::isNotEmpty)
                                       .appendIfNotNull ("Diagnostics", m_aDiagnostics)
                                       .getToString ();
  }
}
