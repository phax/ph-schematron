/**
 * Copyright (C) 2014 phloc systems (www.phloc.com)
 * Copyright (C) 2014 Philip Helger (www.helger.com)
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

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Nonnegative;
import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.NotThreadSafe;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotations.ReturnsMutableCopy;
import com.helger.commons.collections.ContainerHelper;
import com.helger.commons.io.IReadableResource;
import com.helger.commons.log.InMemoryLogger;
import com.helger.commons.microdom.IMicroElement;
import com.helger.commons.microdom.impl.MicroElement;
import com.helger.commons.string.StringHelper;
import com.helger.commons.string.ToStringGenerator;
import com.helger.commons.xml.namespace.MapBasedNamespaceContext;
import com.helger.schematron.CSchematron;
import com.helger.schematron.CSchematronXML;

/**
 * A single Schematron schema-element.<br>
 * The top-level element of a Schematron schema.<br>
 * The optional schemaVersion attribute gives the version of the schema. Its
 * allowed values are not defined by this part of ISO/IEC 19757 and its use is
 * implementation-dependent.<br>
 * The optional queryBinding attribute provides the short name of the query
 * language binding in use. If this attribute is specified, it is an error if it
 * has a value that the current implementation does not support.<br>
 * The defaultPhase attribute may be used to indicate the phase to use in the
 * absence of explicit user-supplied information.<br>
 * The title and p elements allow rich documentation.<br>
 * The icon, see and fpi attributes allow rich interfaces and documentation.<br>
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class PSSchema implements IPSElement, IPSHasID, IPSHasForeignElements, IPSHasIncludes, IPSHasLets, IPSHasRichGroup
{
  private final IReadableResource m_aResource;
  private String m_sID;
  private PSRichGroup m_aRich;
  private String m_sSchemaVersion;
  private String m_sDefaultPhase;
  private String m_sQueryBinding;
  private PSTitle m_aTitle;
  private final List <PSInclude> m_aIncludes = new ArrayList <PSInclude> ();
  private final List <PSNS> m_aNSs = new ArrayList <PSNS> ();
  private final List <PSP> m_aStartPs = new ArrayList <PSP> ();
  private final List <PSLet> m_aLets = new ArrayList <PSLet> ();
  private final List <PSPhase> m_aPhases = new ArrayList <PSPhase> ();
  private final List <PSPattern> m_aPatterns = new ArrayList <PSPattern> ();
  private final List <PSP> m_aEndPs = new ArrayList <PSP> ();
  private PSDiagnostics m_aDiagnostics;
  private Map <String, String> m_aForeignAttrs;
  private List <IMicroElement> m_aForeignElements;

  /**
   * Default constructor for a new schema that was not read from a file.
   */
  public PSSchema ()
  {
    this (null);
  }

  /**
   * Constructor for reading a schema from a file.
   *
   * @param aResource
   *        The resource to be used. May be <code>null</code> indicating that
   *        this is a newly created schema.
   */
  public PSSchema (@Nullable final IReadableResource aResource)
  {
    m_aResource = aResource;
  }

  /**
   * @return The resource from which the schema was read. May be
   *         <code>null</code> if the schema is newly created.
   */
  @Nullable
  public IReadableResource getResource ()
  {
    return m_aResource;
  }

  /**
   * Check if this schema is valid, meaning checking if all required fields are
   * set, and all mandatory constraints are fulfilled.
   *
   * @return <code>true</code> if the schema is valid, <code>false</code> if
   *         not.
   */
  public boolean isValid ()
  {
    return isValid (new InMemoryLogger ());
  }

  public boolean isValid (@Nonnull final InMemoryLogger aLogger)
  {
    if (m_aPatterns.isEmpty ())
    {
      aLogger.error ("<schema> has no <pattern>s");
      return false;
    }
    if (m_aTitle != null && !m_aTitle.isValid (aLogger))
      return false;
    for (final PSInclude aInclude : m_aIncludes)
      if (!aInclude.isValid (aLogger))
        return false;
    for (final PSNS aNS : m_aNSs)
      if (!aNS.isValid (aLogger))
        return false;
    for (final PSP aP : m_aStartPs)
      if (!aP.isValid (aLogger))
        return false;
    for (final PSLet aLet : m_aLets)
      if (!aLet.isValid (aLogger))
        return false;
    for (final PSPhase aPhase : m_aPhases)
      if (!aPhase.isValid (aLogger))
        return false;
    for (final PSPattern aPattern : m_aPatterns)
      if (!aPattern.isValid (aLogger))
        return false;
    for (final PSP aP : m_aEndPs)
      if (!aP.isValid (aLogger))
        return false;
    if (m_aDiagnostics != null && !m_aDiagnostics.isValid (aLogger))
      return false;
    return true;
  }

  /**
   * Check if this schema is already pre-processed or not. A schema is
   * considered pre-processed if:
   * <ul>
   * <li>no includes are contained recursively and</li>
   * <li>no abstract patterns are contained and</li>
   * <li>no abstract rules are contained.</li>
   * </ul>
   *
   * @return <code>true</code> if it is pre-processed, <code>false</code> if
   *         not.
   */
  public boolean isPreprocessed ()
  {
    if (hasAnyInclude ())
      return false;

    for (final PSPhase aPhase : m_aPhases)
      if (aPhase.hasAnyInclude ())
        return false;

    for (final PSPattern aPattern : m_aPatterns)
    {
      if (aPattern.isAbstract () || aPattern.hasAnyInclude () || aPattern.hasAnyParam ())
        return false;
      for (final PSRule aRule : aPattern.getAllRules ())
      {
        if (aRule.isAbstract () || aRule.hasAnyInclude () || aRule.hasAnyExtends ())
          return false;
      }
    }

    if (m_aDiagnostics != null && m_aDiagnostics.hasAnyInclude ())
      return false;
    return true;
  }

  public boolean isMinimal ()
  {
    if (m_aTitle != null && !m_aTitle.isMinimal ())
      return false;
    for (final PSInclude aInclude : m_aIncludes)
      if (!aInclude.isMinimal ())
        return false;
    for (final PSNS aNS : m_aNSs)
      if (!aNS.isMinimal ())
        return false;
    for (final PSP aP : m_aStartPs)
      if (!aP.isMinimal ())
        return false;
    for (final PSLet aLet : m_aLets)
      if (!aLet.isMinimal ())
        return false;
    for (final PSPhase aPhase : m_aPhases)
      if (!aPhase.isMinimal ())
        return false;
    for (final PSPattern aPattern : m_aPatterns)
      if (!aPattern.isMinimal ())
        return false;
    for (final PSP aP : m_aEndPs)
      if (!aP.isMinimal ())
        return false;
    if (m_aDiagnostics != null && !m_aDiagnostics.isMinimal ())
      return false;
    return true;
  }

  public void addForeignElement (@Nonnull final IMicroElement aForeignElement)
  {
    ValueEnforcer.notNull (aForeignElement, "ForeignElement");
    if (aForeignElement.hasParent ())
      throw new IllegalArgumentException ("ForeignElement already has a parent!");
    if (m_aForeignElements == null)
      m_aForeignElements = new ArrayList <IMicroElement> ();
    m_aForeignElements.add (aForeignElement);
  }

  public void addForeignElements (@Nonnull final List <IMicroElement> aForeignElements)
  {
    ValueEnforcer.notNull (aForeignElements, "ForeignElements");
    for (final IMicroElement aForeignElement : aForeignElements)
      addForeignElement (aForeignElement);
  }

  public boolean hasForeignElements ()
  {
    return m_aForeignElements != null && !m_aForeignElements.isEmpty ();
  }

  @Nonnull
  @ReturnsMutableCopy
  public List <IMicroElement> getAllForeignElements ()
  {
    return ContainerHelper.newList (m_aForeignElements);
  }

  public void addForeignAttribute (@Nonnull final String sAttrName, @Nonnull final String sAttrValue)
  {
    ValueEnforcer.notNull (sAttrName, "AttrName");
    ValueEnforcer.notNull (sAttrValue, "AttrValue");
    if (m_aForeignAttrs == null)
      m_aForeignAttrs = new LinkedHashMap <String, String> ();
    m_aForeignAttrs.put (sAttrName, sAttrValue);
  }

  public void addForeignAttributes (@Nonnull final Map <String, String> aForeignAttrs)
  {
    ValueEnforcer.notNull (aForeignAttrs, "ForeignAttrs");
    for (final Map.Entry <String, String> aEntry : aForeignAttrs.entrySet ())
      addForeignAttribute (aEntry.getKey (), aEntry.getValue ());
  }

  public boolean hasForeignAttributes ()
  {
    return m_aForeignAttrs != null && !m_aForeignAttrs.isEmpty ();
  }

  @Nonnull
  @ReturnsMutableCopy
  public Map <String, String> getAllForeignAttributes ()
  {
    return ContainerHelper.newOrderedMap (m_aForeignAttrs);
  }

  public void setID (@Nullable final String sID)
  {
    m_sID = sID;
  }

  public boolean hasID ()
  {
    return m_sID != null;
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

  public boolean hasRich ()
  {
    return m_aRich != null;
  }

  @Nullable
  public PSRichGroup getRich ()
  {
    return m_aRich;
  }

  @Nullable
  public PSRichGroup getRichClone ()
  {
    return m_aRich == null ? null : m_aRich.getClone ();
  }

  public void setQueryBinding (@Nullable final String sQueryBinding)
  {
    if (sQueryBinding != null && sQueryBinding.length () == 0)
      throw new IllegalArgumentException ("queryBinding may not be empty!");
    m_sQueryBinding = sQueryBinding;
  }

  @Nullable
  public String getQueryBinding ()
  {
    return m_sQueryBinding;
  }

  public void setSchemaVersion (@Nullable final String sSchemaVersion)
  {
    if (sSchemaVersion != null && sSchemaVersion.length () == 0)
      throw new IllegalArgumentException ("schemaVersion may not be empty!");
    m_sSchemaVersion = sSchemaVersion;
  }

  @Nullable
  public String getSchemaVersion ()
  {
    return m_sSchemaVersion;
  }

  public void setDefaultPhase (@Nullable final String sDefaultPhase)
  {
    m_sDefaultPhase = sDefaultPhase;
  }

  @Nullable
  public String getDefaultPhase ()
  {
    return m_sDefaultPhase;
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

  public void addInclude (@Nonnull final PSInclude aInclude)
  {
    ValueEnforcer.notNull (aInclude, "Include");
    m_aIncludes.add (aInclude);
  }

  public boolean hasAnyInclude ()
  {
    return !m_aIncludes.isEmpty ();
  }

  @Nonnull
  @ReturnsMutableCopy
  public List <PSInclude> getAllIncludes ()
  {
    return ContainerHelper.newList (m_aIncludes);
  }

  public void addNS (@Nonnull final PSNS aNS)
  {
    ValueEnforcer.notNull (aNS, "NS");
    m_aNSs.add (aNS);
  }

  public boolean hasAnyNS ()
  {
    return !m_aNSs.isEmpty ();
  }

  @Nonnull
  @ReturnsMutableCopy
  public List <PSNS> getAllNSs ()
  {
    return ContainerHelper.newList (m_aNSs);
  }

  /**
   * @return All contained namespaces as a single namespace context
   */
  @Nonnull
  @ReturnsMutableCopy
  public MapBasedNamespaceContext getAsNamespaceContext ()
  {
    final MapBasedNamespaceContext ret = new MapBasedNamespaceContext ();
    for (final PSNS aNS : m_aNSs)
      ret.addMapping (aNS.getPrefix (), aNS.getUri ());
    return ret;
  }

  public void addStartP (@Nonnull final PSP aP)
  {
    ValueEnforcer.notNull (aP, "P");
    m_aStartPs.add (aP);
  }

  @Nonnull
  @ReturnsMutableCopy
  public List <PSP> getAllStartPs ()
  {
    return ContainerHelper.newList (m_aStartPs);
  }

  public void addLet (@Nonnull final PSLet aLet)
  {
    ValueEnforcer.notNull (aLet, "Let");
    m_aLets.add (aLet);
  }

  public boolean hasAnyLet ()
  {
    return !m_aLets.isEmpty ();
  }

  @Nonnull
  @ReturnsMutableCopy
  public List <PSLet> getAllLets ()
  {
    return ContainerHelper.newList (m_aLets);
  }

  @Nonnull
  @ReturnsMutableCopy
  public Map <String, String> getAllLetsAsMap ()
  {
    final Map <String, String> ret = new LinkedHashMap <String, String> ();
    for (final PSLet aLet : m_aLets)
      ret.put (aLet.getName (), aLet.getValue ());
    return ret;
  }

  public void addPhase (@Nonnull final PSPhase aPhase)
  {
    ValueEnforcer.notNull (aPhase, "Phase");
    m_aPhases.add (aPhase);
  }

  @Nonnull
  @ReturnsMutableCopy
  public List <PSPhase> getAllPhases ()
  {
    return ContainerHelper.newList (m_aPhases);
  }

  /**
   * @return A list with all phase IDs. Only phases having a valid ID are
   *         considered.
   */
  @Nonnull
  @ReturnsMutableCopy
  public List <String> getAllPhaseIDs ()
  {
    final List <String> ret = new ArrayList <String> ();
    for (final PSPhase aPhase : m_aPhases)
      if (aPhase.hasID ())
        ret.add (aPhase.getID ());
    return ret;
  }

  @Nullable
  public PSPhase getPhaseOfID (@Nullable final String sID)
  {
    if (StringHelper.hasText (sID))
      for (final PSPhase aPhase : m_aPhases)
        if (sID.equals (aPhase.getID ()))
          return aPhase;
    return null;
  }

  public void addPattern (@Nonnull final PSPattern aPattern)
  {
    ValueEnforcer.notNull (aPattern, "Pattern");
    m_aPatterns.add (aPattern);
  }

  public boolean hasPatterns ()
  {
    return !m_aPatterns.isEmpty ();
  }

  public boolean hasNoPatterns ()
  {
    return m_aPatterns.isEmpty ();
  }

  @Nonnull
  @ReturnsMutableCopy
  public List <PSPattern> getAllPatterns ()
  {
    return ContainerHelper.newList (m_aPatterns);
  }

  @Nonnegative
  public int getPatternCount ()
  {
    return m_aPatterns.size ();
  }

  @Nullable
  public PSPattern getPatternOfID (@Nullable final String sID)
  {
    if (StringHelper.hasText (sID))
      for (final PSPattern aPattern : m_aPatterns)
        if (sID.equals (aPattern.getID ()))
          return aPattern;
    return null;
  }

  public void addEndP (@Nonnull final PSP aP)
  {
    ValueEnforcer.notNull (aP, "P");
    m_aEndPs.add (aP);
  }

  @Nonnull
  @ReturnsMutableCopy
  public List <PSP> getAllEndPs ()
  {
    return ContainerHelper.newList (m_aEndPs);
  }

  public void setDiagnostics (@Nullable final PSDiagnostics aDiagnostics)
  {
    m_aDiagnostics = aDiagnostics;
  }

  public boolean hasDiagnostics ()
  {
    return m_aDiagnostics != null;
  }

  @Nullable
  public PSDiagnostics getDiagnostics ()
  {
    return m_aDiagnostics;
  }

  @Nonnull
  public IMicroElement getAsMicroElement ()
  {
    final IMicroElement ret = new MicroElement (CSchematron.NAMESPACE_SCHEMATRON, CSchematronXML.ELEMENT_SCHEMA);
    ret.setAttribute (CSchematronXML.ATTR_ID, m_sID);
    if (m_aRich != null)
      m_aRich.fillMicroElement (ret);
    ret.setAttribute (CSchematronXML.ATTR_SCHEMA_VERSION, m_sSchemaVersion);
    ret.setAttribute (CSchematronXML.ATTR_DEFAULT_PHASE, m_sDefaultPhase);
    ret.setAttribute (CSchematronXML.ATTR_QUERY_BINDING, m_sQueryBinding);
    if (m_aForeignElements != null)
      for (final IMicroElement aForeignElement : m_aForeignElements)
        ret.appendChild (aForeignElement.getClone ());
    for (final PSInclude aInclude : m_aIncludes)
      ret.appendChild (aInclude.getAsMicroElement ());
    if (m_aTitle != null)
      ret.appendChild (m_aTitle.getAsMicroElement ());
    for (final PSNS aNS : m_aNSs)
      ret.appendChild (aNS.getAsMicroElement ());
    for (final PSP aP : m_aStartPs)
      ret.appendChild (aP.getAsMicroElement ());
    for (final PSLet aLet : m_aLets)
      ret.appendChild (aLet.getAsMicroElement ());
    for (final PSPhase aPhase : m_aPhases)
      ret.appendChild (aPhase.getAsMicroElement ());
    for (final PSPattern aPattern : m_aPatterns)
      ret.appendChild (aPattern.getAsMicroElement ());
    for (final PSP aP : m_aEndPs)
      ret.appendChild (aP.getAsMicroElement ());
    if (m_aDiagnostics != null)
      ret.appendChild (m_aDiagnostics.getAsMicroElement ());
    if (m_aForeignAttrs != null)
      for (final Map.Entry <String, String> aEntry : m_aForeignAttrs.entrySet ())
        ret.setAttribute (aEntry.getKey (), aEntry.getValue ());
    return ret;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).appendIfNotNull ("resource", m_aResource)
                                       .appendIfNotNull ("id", m_sID)
                                       .appendIfNotNull ("rich", m_aRich)
                                       .appendIfNotNull ("schemaVersion", m_sSchemaVersion)
                                       .appendIfNotNull ("defaultPhase", m_sDefaultPhase)
                                       .appendIfNotNull ("queryBinding", m_sQueryBinding)
                                       .appendIfNotNull ("title", m_aTitle)
                                       .append ("includes", m_aIncludes)
                                       .append ("nss", m_aNSs)
                                       .append ("startps", m_aStartPs)
                                       .append ("lets", m_aLets)
                                       .append ("phases", m_aPhases)
                                       .append ("patterns", m_aPatterns)
                                       .append ("endps", m_aEndPs)
                                       .appendIfNotNull ("diagnostics", m_aDiagnostics)
                                       .appendIfNotNull ("foreignAttrs", m_aForeignAttrs)
                                       .appendIfNotNull ("foreignElements", m_aForeignElements)
                                       .toString ();
  }
}
