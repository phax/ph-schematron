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

import java.util.function.Predicate;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.Nonempty;
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
import com.helger.schematron.CSchematron;
import com.helger.schematron.CSchematronXML;
import com.helger.schematron.errorhandler.IPSErrorHandler;
import com.helger.xml.CXMLRegEx;
import com.helger.xml.microdom.IMicroElement;
import com.helger.xml.microdom.MicroElement;

/**
 * Shared base class for the two &quot;rule-set-or-pattern&quot; element kinds defined by the
 * ISO/IEC 19757-3:2025 RELAX NG schema: {@link PSPattern} and {@link PSGroup}. The v4 RNC merges
 * their content models into a single production:
 *
 * <pre>
 * pattern  = element pattern { rule-set-or-pattern }
 * rule-set = element group   { rule-set-or-pattern }
 * </pre>
 *
 * - differing only in their element name and in the rule semantics applied at validation time
 * (if-then-else for <code>pattern</code> vs. try-every-rule for <code>group</code>). This class
 * holds the common state and serialisation logic; the subclass contributes only the element name
 * via {@link #getElementName()}.
 *
 * @author Philip Helger
 * @since 10.0.0 (Schematron 2025)
 */
@NotThreadSafe
public abstract class AbstractPSPatternLike implements
                                            IPSElement,
                                            IPSHasID,
                                            IPSHasForeignElements,
                                            IPSHasIncludes,
                                            IPSHasLets,
                                            IPSHasRichGroup
{
  private boolean m_bAbstract = false;
  private String m_sID;
  private String m_sIsA;
  private String m_sRole;
  private String m_sDocuments;
  private PSRichGroup m_aRich;
  private final ICommonsList <Object> m_aContent = new CommonsArrayList <> ();
  private ICommonsOrderedMap <String, String> m_aForeignAttrs;

  protected AbstractPSPatternLike ()
  {}

  /**
   * @return The local XML element name used when serialising this object. Subclasses return either
   *         {@link CSchematronXML#ELEMENT_PATTERN} or {@link CSchematronXML#ELEMENT_GROUP}.
   */
  @NonNull
  @Nonempty
  protected abstract String getElementName ();

  public boolean isValid (@NonNull final IPSErrorHandler aErrorHandler)
  {
    // Abstract pattern/group must have an ID
    if (m_bAbstract && StringHelper.isEmpty (m_sID))
    {
      aErrorHandler.error (this, "abstract <" + getElementName () + "> does not have an 'id'");
      return false;
    }
    // is-a pattern: forbids <rule> and <let> per v4 RNC is-a branch
    if (StringHelper.isNotEmpty (m_sIsA))
    {
      for (final Object aContent : m_aContent)
      {
        if (aContent instanceof PSRule)
        {
          aErrorHandler.error (this, "<" + getElementName () + "> with 'is-a' may not contain <rule>s");
          return false;
        }
        if (aContent instanceof PSLet)
        {
          aErrorHandler.error (this, "<" + getElementName () + "> with 'is-a' may not contain <let>s");
          return false;
        }
      }
    }
    else
    {
      // Concrete (non-abstract, non-is-a) branch: forbids <param>. Abstract branch allows <param>
      // and <let> (both newly permitted in 2025); pre-2025 schemas using this combination are
      // flagged via PSVersionChecker, not as a hard error here.
      if (!m_bAbstract)
        for (final Object aContent : m_aContent)
          if (aContent instanceof PSParam)
          {
            aErrorHandler.error (this, "concrete <" + getElementName () + "> may not contain <param>s");
            return false;
          }
    }

    for (final Object aContent : m_aContent)
      if (aContent instanceof final IPSElement aElement)
        if (!aElement.isValid (aErrorHandler))
          return false;
    return true;
  }

  public void validateCompletely (@NonNull final IPSErrorHandler aErrorHandler)
  {
    if (m_bAbstract && StringHelper.isEmpty (m_sID))
      aErrorHandler.error (this, "abstract <" + getElementName () + "> does not have an 'id'");
    if (StringHelper.isNotEmpty (m_sID))
      if (!CXMLRegEx.PATTERN_NCNAME.matcher (m_sID).matches ())
        aErrorHandler.error (this, "The <" + getElementName () + "> attribute 'id' is not a valid XML NCName");

    if (StringHelper.isNotEmpty (m_sIsA))
    {
      for (final Object aContent : m_aContent)
      {
        if (aContent instanceof PSRule)
          aErrorHandler.error (this, "<" + getElementName () + "> with 'is-a' may not contain <rule>s");
        if (aContent instanceof PSLet)
          aErrorHandler.error (this, "<" + getElementName () + "> with 'is-a' may not contain <let>s");
      }
    }
    else
    {
      if (!m_bAbstract)
        for (final Object aContent : m_aContent)
          if (aContent instanceof PSParam)
            aErrorHandler.error (this, "concrete <" + getElementName () + "> may not contain <param>s");
    }

    for (final Object aContent : m_aContent)
      if (aContent instanceof final IPSElement aElement)
        aElement.validateCompletely (aErrorHandler);
  }

  public boolean isMinimal ()
  {
    if (m_bAbstract)
      return false;

    if (StringHelper.isNotEmpty (m_sIsA))
      return false;

    for (final Object aContent : m_aContent)
      if (aContent instanceof final IPSElement aElement)
        if (!aElement.isMinimal ())
          return false;
    return true;
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

  public boolean isAbstract ()
  {
    return m_bAbstract;
  }

  public void setAbstract (final boolean bAbstract)
  {
    m_bAbstract = bAbstract;
  }

  @Nullable
  public String getID ()
  {
    return m_sID;
  }

  public void setID (@Nullable final String sID)
  {
    m_sID = sID;
  }

  @Nullable
  public String getIsA ()
  {
    return m_sIsA;
  }

  public void setIsA (@Nullable final String sIsA)
  {
    m_sIsA = sIsA;
  }

  /**
   * Set the optional <code>role</code> attribute. In the ISO/IEC 19757-3:2025 RNC this attribute
   * appears directly on <code>pattern</code> and <code>group</code> (previously it was reachable
   * via the <code>linkable</code> group). When the value is a variable reference, it is dynamically
   * evaluated per v4 &sect;5.5.14.
   *
   * @param sRole
   *        The new value. May be <code>null</code>.
   * @since 10.0.0
   */
  public void setRole (@Nullable final String sRole)
  {
    m_sRole = sRole;
  }

  /**
   * @return The value of the <code>role</code> attribute, or <code>null</code> if not set.
   * @since 10.0.0
   */
  @Nullable
  public String getRole ()
  {
    return m_sRole;
  }

  /**
   * Set the optional <code>documents</code> attribute introduced in ISO/IEC 19757-3:2016. When
   * present, the rule contexts of this pattern/group are evaluated against the subordinate
   * documents whose IRIs are returned by the path expression (evaluated in the context of the
   * original instance document root).
   *
   * @param sDocuments
   *        The path expression returning one or more IRIs. May be <code>null</code>.
   * @since 10.0.0 (Schematron 2016)
   */
  public void setDocuments (@Nullable final String sDocuments)
  {
    m_sDocuments = sDocuments;
  }

  /**
   * @return The value of the <code>documents</code> attribute, or <code>null</code> if not set.
   * @since 10.0.0 (Schematron 2016)
   */
  @Nullable
  public String getDocuments ()
  {
    return m_sDocuments;
  }

  @Nullable
  public PSRichGroup getRich ()
  {
    return m_aRich;
  }

  public void setRich (@Nullable final PSRichGroup aRich)
  {
    m_aRich = aRich;
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

  public void addInclude (@NonNull final PSInclude aInclude)
  {
    ValueEnforcer.notNull (aInclude, "Include");
    m_aContent.add (aInclude);
  }

  @Nullable
  public PSTitle getTitle ()
  {
    return m_aContent.findFirstMapped (PSTitle.class::isInstance, PSTitle.class::cast);
  }

  public boolean hasTitle ()
  {
    return m_aContent.containsAny (PSTitle.class::isInstance);
  }

  public void setTitle (@Nullable final PSTitle aTitle)
  {
    m_aContent.removeIf (PSTitle.class::isInstance);

    if (aTitle != null)
    {
      int nLastInclude = -1;
      int nIndex = 0;
      for (final Object aContent : m_aContent)
      {
        if (aContent instanceof PSInclude)
          nLastInclude = nIndex;
        nIndex++;
      }

      if (nLastInclude < 0)
        m_aContent.add (0, aTitle);
      else
        m_aContent.add (nLastInclude + 1, aTitle);
    }
  }

  @Nullable
  public PSRule getRuleOfID (@Nullable final String sID)
  {
    if (StringHelper.isNotEmpty (sID))
      for (final Object aContent : m_aContent)
        if (aContent instanceof final PSRule aRule)
        {
          if (sID.equals (aRule.getID ()))
            return aRule;
        }
    return null;
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <PSRule> getAllRules ()
  {
    return m_aContent.getAllInstanceOf (PSRule.class);
  }

  public boolean containsRule (@Nullable final PSRule aRule)
  {
    return aRule != null && m_aContent.containsAny (x -> x instanceof PSRule && x.equals (aRule));
  }

  @Nonnegative
  public int getRuleCount ()
  {
    return m_aContent.getCount (PSRule.class::isInstance);
  }

  public void addRule (@NonNull final PSRule aRule)
  {
    ValueEnforcer.notNull (aRule, "Rule");
    m_aContent.add (aRule);
  }

  public void removeRule (@NonNull final Predicate <? super PSRule> aRuleFilter)
  {
    ValueEnforcer.notNull (aRuleFilter, "RuleFilter");
    m_aContent.removeIf (x -> x instanceof final PSRule aRule && aRuleFilter.test (aRule));
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <PSParam> getAllParams ()
  {
    return m_aContent.getAllInstanceOf (PSParam.class);
  }

  public boolean hasAnyParam ()
  {
    return m_aContent.containsAny (PSParam.class::isInstance);
  }

  public void addParam (@NonNull final PSParam aParam)
  {
    ValueEnforcer.notNull (aParam, "Param");
    m_aContent.add (aParam);
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <PSP> getAllPs ()
  {
    return m_aContent.getAllInstanceOf (PSP.class);
  }

  public void addP (@NonNull final PSP aP)
  {
    ValueEnforcer.notNull (aP, "P");
    m_aContent.add (aP);
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

  public void addLet (@NonNull final PSLet aLet)
  {
    ValueEnforcer.notNull (aLet, "Let");
    m_aContent.add (aLet);
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsOrderedMap <String, String> getAllLetsAsMap ()
  {
    final ICommonsOrderedMap <String, String> ret = new CommonsLinkedHashMap <> ();
    for (final Object aContent : m_aContent)
      if (aContent instanceof final PSLet aLet)
        ret.put (aLet.getName (), aLet.getValue ());
    return ret;
  }

  /**
   * @return A list consisting of {@link PSP}, {@link PSLet}, {@link PSRule} and {@link PSParam}
   *         parameters
   */
  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <IPSElement> getAllContentElements ()
  {
    return m_aContent.getAllMapped (x -> x instanceof IPSElement &&
                                         !(x instanceof PSInclude) &&
                                         !(x instanceof PSTitle), IPSElement.class::cast);
  }

  @NonNull
  public IMicroElement getAsMicroElement ()
  {
    final IMicroElement ret = new MicroElement (CSchematron.NAMESPACE_SCHEMATRON, getElementName ());
    if (m_bAbstract)
      ret.setAttribute (CSchematronXML.ATTR_ABSTRACT, "true");
    ret.setAttribute (CSchematronXML.ATTR_ID, m_sID);
    ret.setAttribute (CSchematronXML.ATTR_IS_A, m_sIsA);
    if (StringHelper.isNotEmpty (m_sDocuments))
      ret.setAttribute (CSchematronXML.ATTR_DOCUMENTS, m_sDocuments);
    if (StringHelper.isNotEmpty (m_sRole))
      ret.setAttribute (CSchematronXML.ATTR_ROLE, m_sRole);
    if (m_aRich != null)
      m_aRich.fillMicroElement (ret);
    for (final Object aContent : m_aContent)
      if (aContent instanceof IMicroElement)
        ret.addChild (((IMicroElement) aContent).getClone ());
      else
        ret.addChild (((IPSElement) aContent).getAsMicroElement ());
    if (m_aForeignAttrs != null)
      for (final var aEntry : m_aForeignAttrs.entrySet ())
        ret.setAttribute (aEntry.getKey (), aEntry.getValue ());
    return ret;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("Abstract", m_bAbstract)
                                       .appendIfNotNull ("ID", m_sID)
                                       .appendIfNotNull ("Is-a", m_sIsA)
                                       .appendIfNotNull ("Documents", m_sDocuments)
                                       .appendIfNotNull ("Role", m_sRole)
                                       .appendIfNotNull ("Rich", m_aRich)
                                       .appendIf ("Content", m_aContent, CollectionHelper::isNotEmpty)
                                       .appendIf ("ForeignAttrs", m_aForeignAttrs, CollectionHelper::isNotEmpty)
                                       .getToString ();
  }
}
