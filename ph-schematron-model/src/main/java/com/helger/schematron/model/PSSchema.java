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

import com.helger.annotation.Nonnegative;
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
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.CSchematron;
import com.helger.schematron.CSchematronXML;
import com.helger.schematron.ESchematronVersion;
import com.helger.schematron.errorhandler.IPSErrorHandler;
import com.helger.xml.microdom.IMicroElement;
import com.helger.xml.microdom.MicroElement;
import com.helger.xml.namespace.MapBasedNamespaceContext;

/**
 * A single Schematron schema-element.<br>
 * The top-level element of a Schematron schema.<br>
 * The optional schemaVersion attribute gives the version of the schema. Its allowed values are not
 * defined by this part of ISO/IEC 19757 and its use is implementation-dependent.<br>
 * The optional queryBinding attribute provides the short name of the query language binding in use.
 * If this attribute is specified, it is an error if it has a value that the current implementation
 * does not support.<br>
 * The defaultPhase attribute may be used to indicate the phase to use in the absence of explicit
 * user-supplied information.<br>
 * The title and p elements allow rich documentation.<br>
 * The icon, see and fpi attributes allow rich interfaces and documentation.<br>
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class PSSchema implements
                      IPSElement,
                      IPSHasID,
                      IPSHasForeignElements,
                      IPSHasIncludes,
                      IPSHasLets,
                      IPSHasRichGroup
{
  private final IReadableResource m_aResource;
  private String m_sID;
  private PSRichGroup m_aRich;
  private String m_sSchemaVersion;
  private ESchematronVersion m_eSchematronEdition;
  private String m_sDefaultPhase;
  private String m_sQueryBinding;
  private PSTitle m_aTitle;
  private final ICommonsList <PSInclude> m_aIncludes = new CommonsArrayList <> ();
  private final ICommonsList <PSExtends> m_aExtends = new CommonsArrayList <> ();
  private final ICommonsList <PSNS> m_aNSs = new CommonsArrayList <> ();
  private final ICommonsList <PSP> m_aStartPs = new CommonsArrayList <> ();
  private final ICommonsList <PSParam> m_aParams = new CommonsArrayList <> ();
  private final ICommonsList <PSLet> m_aLets = new CommonsArrayList <> ();
  private final ICommonsList <PSPhase> m_aPhases = new CommonsArrayList <> ();
  private final ICommonsList <PSRules> m_aAbstractRulesContainers = new CommonsArrayList <> ();
  private final ICommonsList <PSPattern> m_aPatterns = new CommonsArrayList <> ();
  private final ICommonsList <PSGroup> m_aGroups = new CommonsArrayList <> ();
  private final ICommonsList <PSP> m_aEndPs = new CommonsArrayList <> ();
  private PSDiagnostics m_aDiagnostics;
  private ICommonsOrderedMap <String, String> m_aForeignAttrs;
  private ICommonsList <IMicroElement> m_aForeignElements;

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
   *        The resource to be used. May be <code>null</code> indicating that this is a newly
   *        created schema.
   */
  public PSSchema (@Nullable final IReadableResource aResource)
  {
    m_aResource = aResource;
  }

  /**
   * @return The resource from which the schema was read. May be <code>null</code> if the schema is
   *         newly created.
   */
  @Nullable
  public IReadableResource getResource ()
  {
    return m_aResource;
  }

  public boolean isValid (@NonNull final IPSErrorHandler aErrorHandler)
  {
    // 2025: a schema may carry either patterns, groups, or both (the v4 RNC says
    // (rule-set|pattern)+) - require at least one combined.
    if (m_aPatterns.isEmpty () && m_aGroups.isEmpty ())
    {
      aErrorHandler.error (this, "<schema> has no <pattern>s or <group>s");
      return false;
    }
    if (m_aTitle != null && !m_aTitle.isValid (aErrorHandler))
      return false;
    for (final PSInclude aInclude : m_aIncludes)
      if (!aInclude.isValid (aErrorHandler))
        return false;
    for (final PSExtends aExtends : m_aExtends)
      if (!aExtends.isValid (aErrorHandler))
        return false;
    for (final PSNS aNS : m_aNSs)
      if (!aNS.isValid (aErrorHandler))
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
    for (final PSPhase aPhase : m_aPhases)
      if (!aPhase.isValid (aErrorHandler))
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
    if (m_aPatterns.isEmpty () && m_aGroups.isEmpty ())
      aErrorHandler.error (this, "<schema> has no <pattern>s or <group>s");
    if (m_aTitle != null)
      m_aTitle.validateCompletely (aErrorHandler);
    for (final PSInclude aInclude : m_aIncludes)
      aInclude.validateCompletely (aErrorHandler);
    for (final PSExtends aExtends : m_aExtends)
      aExtends.validateCompletely (aErrorHandler);
    for (final PSNS aNS : m_aNSs)
      aNS.validateCompletely (aErrorHandler);
    for (final PSP aP : m_aStartPs)
      aP.validateCompletely (aErrorHandler);
    for (final PSParam aParam : m_aParams)
      aParam.validateCompletely (aErrorHandler);
    for (final PSLet aLet : m_aLets)
      aLet.validateCompletely (aErrorHandler);
    for (final PSPhase aPhase : m_aPhases)
      aPhase.validateCompletely (aErrorHandler);
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

  /**
   * Check if this schema is already pre-processed or not. A schema is considered pre-processed if:
   * <ul>
   * <li>no includes are contained recursively and</li>
   * <li>no abstract patterns are contained and</li>
   * <li>no abstract rules are contained.</li>
   * </ul>
   *
   * @return <code>true</code> if it is pre-processed, <code>false</code> if not.
   */
  public boolean isPreprocessed ()
  {
    if (hasAnyInclude ())
      return false;

    // 2025: top-level extends and top-level abstract-rules containers require
    // resolution by the preprocessor and therefore mean "not preprocessed".
    if (m_aExtends.isNotEmpty ())
      return false;
    if (m_aAbstractRulesContainers.isNotEmpty ())
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

    for (final PSGroup aGroup : m_aGroups)
    {
      if (aGroup.isAbstract () || aGroup.hasAnyInclude () || aGroup.hasAnyParam ())
        return false;
      for (final PSRule aRule : aGroup.getAllRules ())
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
    for (final PSExtends aExtends : m_aExtends)
      if (!aExtends.isMinimal ())
        return false;
    for (final PSNS aNS : m_aNSs)
      if (!aNS.isMinimal ())
        return false;
    for (final PSP aP : m_aStartPs)
      if (!aP.isMinimal ())
        return false;
    for (final PSParam aParam : m_aParams)
      if (!aParam.isMinimal ())
        return false;
    for (final PSLet aLet : m_aLets)
      if (!aLet.isMinimal ())
        return false;
    for (final PSPhase aPhase : m_aPhases)
      if (!aPhase.isMinimal ())
        return false;
    for (final PSRules aRules : m_aAbstractRulesContainers)
      if (!aRules.isMinimal ())
        return false;
    for (final PSPattern aPattern : m_aPatterns)
      if (!aPattern.isMinimal ())
        return false;
    for (final PSGroup aGroup : m_aGroups)
      if (!aGroup.isMinimal ())
        return false;
    for (final PSP aP : m_aEndPs)
      if (!aP.isMinimal ())
        return false;
    if (m_aDiagnostics != null && !m_aDiagnostics.isMinimal ())
      return false;
    return true;
  }

  public void addForeignElement (@NonNull final IMicroElement aForeignElement)
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

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <IMicroElement> getAllForeignElements ()
  {
    return new CommonsArrayList <> (m_aForeignElements);
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

  /**
   * Set the Schematron edition this schema declares via the <code>schematronEdition</code>
   * attribute introduced in ISO/IEC 19757-3:2025.
   *
   * @param eSchematronEdition
   *        The edition to declare, or <code>null</code> to omit the attribute.
   */
  public void setSchematronEdition (@Nullable final ESchematronVersion eSchematronEdition)
  {
    m_eSchematronEdition = eSchematronEdition;
  }

  /**
   * @return The Schematron edition declared via the <code>schematronEdition</code> attribute on
   *         this schema, or <code>null</code> if the attribute is absent or held a value not
   *         understood by this implementation.
   */
  @Nullable
  public ESchematronVersion getSchematronEdition ()
  {
    return m_eSchematronEdition;
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

  /**
   * Add a top-level <code>extends</code> introduced in ISO/IEC 19757-3:2025. Pre-2025 schemas only
   * allow <code>extends</code> inside a <code>rule</code>.
   *
   * @param aExtends
   *        The element to add. May not be <code>null</code>.
   * @since 10.0.0 (Schematron 2025)
   */
  public void addExtends (@NonNull final PSExtends aExtends)
  {
    ValueEnforcer.notNull (aExtends, "Extends");
    m_aExtends.add (aExtends);
  }

  /**
   * @return <code>true</code> if at least one top-level <code>extends</code> is present.
   * @since 10.0.0 (Schematron 2025)
   */
  public boolean hasAnyExtends ()
  {
    return m_aExtends.isNotEmpty ();
  }

  /**
   * @return All top-level <code>extends</code> declared on this schema.
   * @since 10.0.0 (Schematron 2025)
   */
  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <PSExtends> getAllExtends ()
  {
    return m_aExtends.getClone ();
  }

  public void addNS (@NonNull final PSNS aNS)
  {
    ValueEnforcer.notNull (aNS, "NS");
    m_aNSs.add (aNS);
  }

  public boolean hasAnyNS ()
  {
    return m_aNSs.isNotEmpty ();
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <PSNS> getAllNSs ()
  {
    return m_aNSs.getClone ();
  }

  /**
   * @return All contained namespaces as a single namespace context
   */
  @NonNull
  @ReturnsMutableCopy
  public MapBasedNamespaceContext getAsNamespaceContext ()
  {
    final MapBasedNamespaceContext ret = new MapBasedNamespaceContext ();
    for (final PSNS aNS : m_aNSs)
      ret.addMapping (aNS.getPrefix (), aNS.getUri ());
    return ret;
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

  /**
   * Add a top-level <code>param</code> introduced in ISO/IEC 19757-3:2025. Pre-2025 schemas only
   * allow <code>param</code> inside a <code>pattern</code> that instantiates an abstract pattern
   * via <code>is-a</code>.
   *
   * @param aParam
   *        The element to add. May not be <code>null</code>.
   * @since 10.0.0 (Schematron 2025)
   */
  public void addParam (@NonNull final PSParam aParam)
  {
    ValueEnforcer.notNull (aParam, "Param");
    m_aParams.add (aParam);
  }

  /**
   * @return <code>true</code> if at least one top-level <code>param</code> is present.
   * @since 10.0.0 (Schematron 2025)
   */
  public boolean hasAnyParam ()
  {
    return m_aParams.isNotEmpty ();
  }

  /**
   * @return All top-level <code>param</code> declarations on this schema.
   * @since 10.0.0 (Schematron 2025)
   */
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

  public void addPhase (@NonNull final PSPhase aPhase)
  {
    ValueEnforcer.notNull (aPhase, "Phase");
    m_aPhases.add (aPhase);
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <PSPhase> getAllPhases ()
  {
    return m_aPhases.getClone ();
  }

  /**
   * @return A list with all phase IDs. Only phases having a valid ID are considered.
   */
  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <String> getAllPhaseIDs ()
  {
    return m_aPhases.getAllMapped (PSPhase::hasID, PSPhase::getID);
  }

  @Nullable
  public PSPhase getPhaseOfID (@Nullable final String sID)
  {
    if (StringHelper.isNotEmpty (sID))
      for (final PSPhase aPhase : m_aPhases)
        if (sID.equals (aPhase.getID ()))
          return aPhase;
    return null;
  }

  /**
   * Add an abstract-rules container introduced in ISO/IEC 19757-3:2025. The container wraps one or
   * more <code>rule[@abstract='true']</code> declarations that may be extended from rules in any
   * pattern in this schema.
   *
   * @param aRules
   *        The element to add. May not be <code>null</code>.
   * @since 10.0.0 (Schematron 2025)
   */
  public void addAbstractRulesContainer (@NonNull final PSRules aRules)
  {
    ValueEnforcer.notNull (aRules, "Rules");
    m_aAbstractRulesContainers.add (aRules);
  }

  /**
   * @return <code>true</code> if at least one abstract-rules container is present.
   * @since 10.0.0 (Schematron 2025)
   */
  public boolean hasAnyAbstractRulesContainer ()
  {
    return m_aAbstractRulesContainers.isNotEmpty ();
  }

  /**
   * @return All abstract-rules containers declared on this schema.
   * @since 10.0.0 (Schematron 2025)
   */
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

  public boolean hasPatterns ()
  {
    return m_aPatterns.isNotEmpty ();
  }

  public boolean hasNoPatterns ()
  {
    return m_aPatterns.isEmpty ();
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <PSPattern> getAllPatterns ()
  {
    return m_aPatterns.getClone ();
  }

  @Nonnegative
  public int getPatternCount ()
  {
    return m_aPatterns.size ();
  }

  @Nullable
  public PSPattern getPatternOfID (@Nullable final String sID)
  {
    if (StringHelper.isNotEmpty (sID))
      for (final PSPattern aPattern : m_aPatterns)
        if (sID.equals (aPattern.getID ()))
          return aPattern;
    return null;
  }

  /**
   * Add a top-level <code>group</code> element introduced in ISO/IEC 19757-3:2025. A group shares
   * the content model with <code>pattern</code> but uses &quot;try every rule&quot; semantics
   * instead of the if-then-else order applied to patterns.
   *
   * @param aGroup
   *        The element to add. May not be <code>null</code>.
   * @since 10.0.0 (Schematron 2025)
   */
  public void addGroup (@NonNull final PSGroup aGroup)
  {
    ValueEnforcer.notNull (aGroup, "Group");
    m_aGroups.add (aGroup);
  }

  /**
   * @return <code>true</code> if at least one <code>group</code> is declared.
   * @since 10.0.0 (Schematron 2025)
   */
  public boolean hasAnyGroup ()
  {
    return m_aGroups.isNotEmpty ();
  }

  /**
   * @return All <code>group</code> elements declared on this schema.
   * @since 10.0.0 (Schematron 2025)
   */
  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <PSGroup> getAllGroups ()
  {
    return m_aGroups.getClone ();
  }

  /**
   * @return The count of all <code>group</code> elements declared on this schema.
   * @since 10.0.0 (Schematron 2025)
   */
  @Nonnegative
  public int getGroupCount ()
  {
    return m_aGroups.size ();
  }

  /**
   * Search a <code>group</code> element with a specific ID.
   *
   * @param sID
   *        The ID to search. May be <code>null</code>.
   * @return The group with the provided ID or <code>null</code>.
   * @since 10.0.0 (Schematron 2025)
   */
  @Nullable
  public PSGroup getGroupOfID (@Nullable final String sID)
  {
    if (StringHelper.isNotEmpty (sID))
      for (final PSGroup aGroup : m_aGroups)
        if (sID.equals (aGroup.getID ()))
          return aGroup;
    return null;
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

  public boolean hasDiagnostics ()
  {
    return m_aDiagnostics != null;
  }

  @Nullable
  public PSDiagnostics getDiagnostics ()
  {
    return m_aDiagnostics;
  }

  @NonNull
  public IMicroElement getAsMicroElement ()
  {
    final IMicroElement ret = new MicroElement (CSchematron.NAMESPACE_SCHEMATRON, CSchematronXML.ELEMENT_SCHEMA);
    ret.setAttribute (CSchematronXML.ATTR_ID, m_sID);
    if (m_aRich != null)
      m_aRich.fillMicroElement (ret);
    ret.setAttribute (CSchematronXML.ATTR_SCHEMA_VERSION, m_sSchemaVersion);
    if (m_eSchematronEdition != null)
      ret.setAttribute (CSchematronXML.ATTR_SCHEMATRON_EDITION, m_eSchematronEdition.getEditionYear ());
    ret.setAttribute (CSchematronXML.ATTR_DEFAULT_PHASE, m_sDefaultPhase);
    ret.setAttribute (CSchematronXML.ATTR_QUERY_BINDING, m_sQueryBinding);
    if (m_aForeignElements != null)
      for (final IMicroElement aForeignElement : m_aForeignElements)
        ret.addChild (aForeignElement.getClone ());
    for (final PSInclude aInclude : m_aIncludes)
      ret.addChild (aInclude.getAsMicroElement ());
    for (final PSExtends aExtends : m_aExtends)
      ret.addChild (aExtends.getAsMicroElement ());
    if (m_aTitle != null)
      ret.addChild (m_aTitle.getAsMicroElement ());
    for (final PSNS aNS : m_aNSs)
      ret.addChild (aNS.getAsMicroElement ());
    for (final PSP aP : m_aStartPs)
      ret.addChild (aP.getAsMicroElement ());
    for (final PSParam aParam : m_aParams)
      ret.addChild (aParam.getAsMicroElement ());
    for (final PSLet aLet : m_aLets)
      ret.addChild (aLet.getAsMicroElement ());
    for (final PSPhase aPhase : m_aPhases)
      ret.addChild (aPhase.getAsMicroElement ());
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
    if (m_aForeignAttrs != null)
      for (final Map.Entry <String, String> aEntry : m_aForeignAttrs.entrySet ())
        ret.setAttribute (aEntry.getKey (), aEntry.getValue ());
    return ret;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).appendIfNotNull ("Resource", m_aResource)
                                       .appendIfNotNull ("ID", m_sID)
                                       .appendIfNotNull ("Rich", m_aRich)
                                       .appendIfNotNull ("SchemaVersion", m_sSchemaVersion)
                                       .appendIfNotNull ("SchematronEdition", m_eSchematronEdition)
                                       .appendIfNotNull ("DefaultPhase", m_sDefaultPhase)
                                       .appendIfNotNull ("QueryBinding", m_sQueryBinding)
                                       .appendIfNotNull ("Title", m_aTitle)
                                       .appendIf ("Includes", m_aIncludes, CollectionHelper::isNotEmpty)
                                       .appendIf ("Extends", m_aExtends, CollectionHelper::isNotEmpty)
                                       .appendIf ("NSs", m_aNSs, CollectionHelper::isNotEmpty)
                                       .appendIf ("StartPs", m_aStartPs, CollectionHelper::isNotEmpty)
                                       .appendIf ("Params", m_aParams, CollectionHelper::isNotEmpty)
                                       .appendIf ("Lets", m_aLets, CollectionHelper::isNotEmpty)
                                       .appendIf ("Phases", m_aPhases, CollectionHelper::isNotEmpty)
                                       .appendIf ("AbstractRulesContainers",
                                                  m_aAbstractRulesContainers,
                                                  CollectionHelper::isNotEmpty)
                                       .appendIf ("Patterns", m_aPatterns, CollectionHelper::isNotEmpty)
                                       .appendIf ("Groups", m_aGroups, CollectionHelper::isNotEmpty)
                                       .appendIf ("EndPs", m_aEndPs, CollectionHelper::isNotEmpty)
                                       .appendIfNotNull ("Diagnostics", m_aDiagnostics)
                                       .appendIf ("ForeignAttrs", m_aForeignAttrs, CollectionHelper::isNotEmpty)
                                       .appendIf ("ForeignElements", m_aForeignElements, CollectionHelper::isNotEmpty)
                                       .getToString ();
  }
}
