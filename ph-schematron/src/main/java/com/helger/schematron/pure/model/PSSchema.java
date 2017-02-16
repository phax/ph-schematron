/**
 * Copyright (C) 2014-2017 Philip Helger (www.helger.com)
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

import javax.annotation.Nonnegative;
import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.NotThreadSafe;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.CollectionHelper;
import com.helger.commons.collection.ext.CommonsArrayList;
import com.helger.commons.collection.ext.CommonsLinkedHashMap;
import com.helger.commons.collection.ext.ICommonsList;
import com.helger.commons.collection.ext.ICommonsOrderedMap;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.string.StringHelper;
import com.helger.commons.string.ToStringGenerator;
import com.helger.schematron.CSchematron;
import com.helger.schematron.CSchematronXML;
import com.helger.schematron.pure.errorhandler.IPSErrorHandler;
import com.helger.xml.microdom.IMicroElement;
import com.helger.xml.microdom.MicroElement;
import com.helger.xml.namespace.MapBasedNamespaceContext;

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
  private String m_sDefaultPhase;
  private String m_sQueryBinding;
  private PSTitle m_aTitle;
  private final ICommonsList <PSInclude> m_aIncludes = new CommonsArrayList <> ();
  private final ICommonsList <PSNS> m_aNSs = new CommonsArrayList <> ();
  private final ICommonsList <PSP> m_aStartPs = new CommonsArrayList <> ();
  private final ICommonsList <PSLet> m_aLets = new CommonsArrayList <> ();
  private final ICommonsList <PSPhase> m_aPhases = new CommonsArrayList <> ();
  private final ICommonsList <PSPattern> m_aPatterns = new CommonsArrayList <> ();
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

  public boolean isValid (@Nonnull final IPSErrorHandler aErrorHandler)
  {
    if (m_aPatterns.isEmpty ())
    {
      aErrorHandler.error (this, "<schema> has no <pattern>s");
      return false;
    }
    if (m_aTitle != null && !m_aTitle.isValid (aErrorHandler))
      return false;
    for (final PSInclude aInclude : m_aIncludes)
      if (!aInclude.isValid (aErrorHandler))
        return false;
    for (final PSNS aNS : m_aNSs)
      if (!aNS.isValid (aErrorHandler))
        return false;
    for (final PSP aP : m_aStartPs)
      if (!aP.isValid (aErrorHandler))
        return false;
    for (final PSLet aLet : m_aLets)
      if (!aLet.isValid (aErrorHandler))
        return false;
    for (final PSPhase aPhase : m_aPhases)
      if (!aPhase.isValid (aErrorHandler))
        return false;
    for (final PSPattern aPattern : m_aPatterns)
      if (!aPattern.isValid (aErrorHandler))
        return false;
    for (final PSP aP : m_aEndPs)
      if (!aP.isValid (aErrorHandler))
        return false;
    if (m_aDiagnostics != null && !m_aDiagnostics.isValid (aErrorHandler))
      return false;
    return true;
  }

  public void validateCompletely (@Nonnull final IPSErrorHandler aErrorHandler)
  {
    if (m_aPatterns.isEmpty ())
      aErrorHandler.error (this, "<schema> has no <pattern>s");
    if (m_aTitle != null)
      m_aTitle.validateCompletely (aErrorHandler);
    for (final PSInclude aInclude : m_aIncludes)
      aInclude.validateCompletely (aErrorHandler);
    for (final PSNS aNS : m_aNSs)
      aNS.validateCompletely (aErrorHandler);
    for (final PSP aP : m_aStartPs)
      aP.validateCompletely (aErrorHandler);
    for (final PSLet aLet : m_aLets)
      aLet.validateCompletely (aErrorHandler);
    for (final PSPhase aPhase : m_aPhases)
      aPhase.validateCompletely (aErrorHandler);
    for (final PSPattern aPattern : m_aPatterns)
      aPattern.validateCompletely (aErrorHandler);
    for (final PSP aP : m_aEndPs)
      aP.validateCompletely (aErrorHandler);
    if (m_aDiagnostics != null)
      m_aDiagnostics.validateCompletely (aErrorHandler);
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
    return m_aIncludes.isNotEmpty ();
  }

  @Nonnull
  @ReturnsMutableCopy
  public ICommonsList <PSInclude> getAllIncludes ()
  {
    return m_aIncludes.getClone ();
  }

  public void addNS (@Nonnull final PSNS aNS)
  {
    ValueEnforcer.notNull (aNS, "NS");
    m_aNSs.add (aNS);
  }

  public boolean hasAnyNS ()
  {
    return m_aNSs.isNotEmpty ();
  }

  @Nonnull
  @ReturnsMutableCopy
  public ICommonsList <PSNS> getAllNSs ()
  {
    return m_aNSs.getClone ();
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
  public ICommonsList <PSP> getAllStartPs ()
  {
    return m_aStartPs.getClone ();
  }

  public void addLet (@Nonnull final PSLet aLet)
  {
    ValueEnforcer.notNull (aLet, "Let");
    m_aLets.add (aLet);
  }

  public boolean hasAnyLet ()
  {
    return m_aLets.isNotEmpty ();
  }

  @Nonnull
  @ReturnsMutableCopy
  public ICommonsList <PSLet> getAllLets ()
  {
    return m_aLets.getClone ();
  }

  @Nonnull
  @ReturnsMutableCopy
  public ICommonsOrderedMap <String, String> getAllLetsAsMap ()
  {
    final ICommonsOrderedMap <String, String> ret = new CommonsLinkedHashMap <> ();
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
  public ICommonsList <PSPhase> getAllPhases ()
  {
    return m_aPhases.getClone ();
  }

  /**
   * @return A list with all phase IDs. Only phases having a valid ID are
   *         considered.
   */
  @Nonnull
  @ReturnsMutableCopy
  public ICommonsList <String> getAllPhaseIDs ()
  {
    return m_aPhases.getAllMapped (PSPhase::hasID, PSPhase::getID);
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
    return m_aPatterns.isNotEmpty ();
  }

  public boolean hasNoPatterns ()
  {
    return m_aPatterns.isEmpty ();
  }

  @Nonnull
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
                                       .appendIf ("includes", m_aIncludes, CollectionHelper::isNotEmpty)
                                       .appendIf ("nss", m_aNSs, CollectionHelper::isNotEmpty)
                                       .appendIf ("startps", m_aStartPs, CollectionHelper::isNotEmpty)
                                       .appendIf ("lets", m_aLets, CollectionHelper::isNotEmpty)
                                       .appendIf ("phases", m_aPhases, CollectionHelper::isNotEmpty)
                                       .appendIf ("patterns", m_aPatterns, CollectionHelper::isNotEmpty)
                                       .appendIf ("endps", m_aEndPs, CollectionHelper::isNotEmpty)
                                       .appendIfNotNull ("diagnostics", m_aDiagnostics)
                                       .appendIf ("foreignAttrs", m_aForeignAttrs, CollectionHelper::isNotEmpty)
                                       .appendIf ("foreignElements", m_aForeignElements, CollectionHelper::isNotEmpty)
                                       .getToString ();
  }
}
