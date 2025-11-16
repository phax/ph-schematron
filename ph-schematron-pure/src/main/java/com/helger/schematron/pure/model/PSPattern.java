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
import java.util.function.Predicate;

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
import com.helger.schematron.CSchematron;
import com.helger.schematron.CSchematronXML;
import com.helger.schematron.pure.errorhandler.IPSErrorHandler;
import com.helger.xml.CXMLRegEx;
import com.helger.xml.microdom.IMicroElement;
import com.helger.xml.microdom.MicroElement;

/**
 * A single Schematron pattern-element.<br>
 * A structure, simple or complex. A set of rules giving constraints that are in some way related.
 * The id attribute provides a unique name for the pattern and is required for abstract
 * patterns.<br>
 * The title and p elements allow rich documentation.<br>
 * The icon, see and fpi attributes allow rich interfaces and documentation.<br>
 * When a pattern element has the attribute abstract with a value true, then the pattern defines an
 * abstract pattern. An abstract pattern shall not have a is-a attribute and shall have an id
 * attribute.<br>
 * Abstract patterns allow a common definition mechanism for structures which use different names
 * and paths, but which are at heart the same. For example, there are different table markup
 * languages, but they all can be in large part represented as an abstract pattern where a table
 * contains rows and rows contain entries, as defined in the following example using the default
 * query language binding:<br>
 *
 * <pre>
 *     &lt;sch:pattern abstract="true" id="table"&gt;
 *         &lt;sch:rule context="$table"&gt;
 *             &lt;sch:assert test="$row"&gt;
 *             The element &lt;sch:name/&gt; is a table. Tables contain rows.
 *             &lt;/sch:assert&gt;
 *         &lt;/sch:rule&gt;
 *         &lt;sch:rule context="$row"&gt;
 *             &lt;sch:assert test="$entry"&gt;
 *             The element &lt;sch:name/&gt; is a table row. Rows contain entries.
 *             &lt;/sch:assert&gt;
 *         &lt;/sch:rule&gt;
 *     &lt;/sch:pattern&gt;
 * </pre>
 *
 * When a pattern element has the attribute is-a with a value specifying the name of an abstract
 * pattern, then the pattern is an instance of an abstract pattern. Such a pattern shall not contain
 * any rule elements, but shall have param elements for all parameters used in the abstract
 * pattern.<br>
 * The following example uses the abstract pattern for tables given above to create three patterns
 * for tables with different names or structures.<br>
 *
 * <pre>
 *     &lt;sch:pattern is-a="table" id="HTML_Table"&gt;
 *         &lt;sch:param name="table" value="table"/&gt;
 *         &lt;sch:param name="row"   value="tr"/&gt;
 *         &lt;sch:param name="entry" value="td|th"/&gt;
 *     &lt;/sch:pattern&gt;
 *     &lt;sch:pattern is-a="table" id="CALS_Table"&gt;
 *         &lt;sch:param name="table" value="table"/&gt;
 *         &lt;sch:param name="row"   value=".//row"/&gt;
 *         &lt;sch:param name="entry" value="cell"/&gt;
 *     &lt;/sch:pattern&gt;
 *     &lt;sch:pattern is-a="table" id="calendar"&gt;
 *         &lt;sch:param name="table" value="calendar/year"/&gt;
 *         &lt;sch:param name="row"   value="week"/&gt;
 *         &lt;sch:param name="entry" value="day"/&gt;
 *     &lt;/sch:pattern&gt;
 * </pre>
 *
 * When creating an instance of an abstract pattern, the parameter values supplied by the param
 * element replace the parameter references used in the abstract patterns. The examples above use
 * the default query language binding in which the character $ is used as the delimiter for
 * parameter references. <br>
 * Thus, given the abstract patterns defined earlier in this clause, the patterns defined above are
 * equivalent to the following, with the id elements shown expanded:<br>
 *
 * <pre>
 *     &lt;sch:pattern id="HTML_table"&gt;
 *         &lt;sch:rule context="table"&gt;
 *             &lt;sch:assert test="tr"&gt;
 *             The element table is a table. Tables containing rows.
 *             &lt;/sch:assert&gt;
 *         &lt;/sch:rule&gt;
 *         &lt;sch:rule context="tr"&gt;
 *             &lt;sch:assert test="td|th"&gt;
 *             The element tr is a table row. Rows contain entries.
 *             &lt;/sch:assert&gt;
 *         &lt;/sch:rule&gt;
 *     &lt;/sch:pattern&gt;
 *     &lt;sch:pattern id="CALS_table"&gt;
 *         &lt;sch:rule context="table"&gt;
 *             &lt;sch:assert test=".//row"&gt;
 *             The element table is a table. Tables containing rows.
 *             &lt;/sch:assert&gt;
 *         &lt;/sch:rule&gt;
 *         &lt;sch:rule context=".//row"&gt;
 *             &lt;sch:assert test="cell"&gt;
 *             The element row is a table row. Rows contain entries.
 *             &lt;/sch:assert&gt;
 *         &lt;/sch:rule&gt;
 *     &lt;/sch:pattern&gt;
 *     &lt;sch:pattern id="calendar"&gt;
 *         &lt;sch:rule context="calendar/year"&gt;
 *             &lt;sch:assert test="week"&gt;
 *             The element year is a table. Tables containing rows.
 *             &lt;/sch:assert&gt;
 *         &lt;/sch:rule&gt;
 *         &lt;sch:rule context="week"&gt;
 *             &lt;sch:assert test="day"&gt;
 *             The element week is a table row. Rows contain entries.
 *             &lt;/sch:assert&gt;
 *         &lt;/sch:rule&gt;
 *     &lt;/sch:pattern&gt;
 * </pre>
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class PSPattern implements
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
  private PSRichGroup m_aRich;
  private final ICommonsList <Object> m_aContent = new CommonsArrayList <> ();
  private ICommonsOrderedMap <String, String> m_aForeignAttrs;

  public PSPattern ()
  {}

  public boolean isValid (@NonNull final IPSErrorHandler aErrorHandler)
  {
    // If abstract, an ID must be present
    if (m_bAbstract && StringHelper.isEmpty (m_sID))
    {
      aErrorHandler.error (this, "abstract <pattern> does not have an 'id'");
      return false;
    }
    // is-a may not be present for abstract rules
    if (m_bAbstract && StringHelper.isNotEmpty (m_sIsA))
    {
      aErrorHandler.error (this, "abstract <pattern> may not have an 'is-a'");
      return false;
    }
    if (StringHelper.isEmpty (m_sIsA))
    {
      // param only if is-a is set
      for (final Object aContent : m_aContent)
        if (aContent instanceof PSParam)
        {
          aErrorHandler.error (this, "<pattern> without 'is-a' may not contain <param>s");
          return false;
        }
    }
    else
    {
      // rule and let only if is-a is not set
      for (final Object aContent : m_aContent)
      {
        if (aContent instanceof PSRule)
        {
          aErrorHandler.error (this, "<pattern> with 'is-a' may not contain <rule>s");
          return false;
        }
        if (aContent instanceof PSLet)
        {
          aErrorHandler.error (this, "<pattern> with 'is-a' may not contain <let>s");
          return false;
        }
      }
    }

    for (final Object aContent : m_aContent)
      if (aContent instanceof IPSElement)
        if (!((IPSElement) aContent).isValid (aErrorHandler))
          return false;
    return true;
  }

  public void validateCompletely (@NonNull final IPSErrorHandler aErrorHandler)
  {
    // If abstract, an ID must be present
    if (m_bAbstract && StringHelper.isEmpty (m_sID))
      aErrorHandler.error (this, "abstract <pattern> does not have an 'id'");
    // ID needs to be an NCName
    if (StringHelper.isNotEmpty (m_sID))
      if (!CXMLRegEx.PATTERN_NCNAME.matcher (m_sID).matches ())
        aErrorHandler.error (this, "The <pattern> attribute 'id' is not a valid XML NCName");

    // is-a may not be present for abstract rules
    if (m_bAbstract && StringHelper.isNotEmpty (m_sIsA))
      aErrorHandler.error (this, "abstract <pattern> may not have an 'is-a'");
    if (StringHelper.isEmpty (m_sIsA))
    {
      // param only if is-a is set
      for (final Object aContent : m_aContent)
        if (aContent instanceof PSParam)
          aErrorHandler.error (this, "<pattern> without 'is-a' may not contain <param>s");
    }
    else
    {
      // rule and let only if is-a is not set
      for (final Object aContent : m_aContent)
      {
        if (aContent instanceof PSRule)
          aErrorHandler.error (this, "<pattern> with 'is-a' may not contain <rule>s");
        if (aContent instanceof PSLet)
          aErrorHandler.error (this, "<pattern> with 'is-a' may not contain <let>s");
      }
    }

    for (final Object aContent : m_aContent)
      if (aContent instanceof IPSElement)
        ((IPSElement) aContent).validateCompletely (aErrorHandler);
  }

  public boolean isMinimal ()
  {
    if (m_bAbstract)
      return false;
    if (StringHelper.isNotEmpty (m_sIsA))
      return false;
    for (final Object aContent : m_aContent)
      if (aContent instanceof IPSElement)
        if (!((IPSElement) aContent).isMinimal ())
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
    // Remove existing
    m_aContent.removeIf (PSTitle.class::isInstance);

    if (aTitle != null)
    {
      // Add new title after last include (if any)
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
        if (aContent instanceof PSRule)
        {
          final PSRule aRule = (PSRule) aContent;
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
    m_aContent.removeIf (x -> x instanceof PSRule && aRuleFilter.test ((PSRule) x));
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
      if (aContent instanceof PSLet)
      {
        final PSLet aLet = (PSLet) aContent;
        ret.put (aLet.getName (), aLet.getValue ());
      }
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
    // Remove includes and title
    return m_aContent.getAllMapped (x -> x instanceof IPSElement &&
                                         !(x instanceof PSInclude) &&
                                         !(x instanceof PSTitle), IPSElement.class::cast);
  }

  @NonNull
  public IMicroElement getAsMicroElement ()
  {
    final IMicroElement ret = new MicroElement (CSchematron.NAMESPACE_SCHEMATRON, CSchematronXML.ELEMENT_PATTERN);
    if (m_bAbstract)
      ret.setAttribute (CSchematronXML.ATTR_ABSTRACT, "true");
    ret.setAttribute (CSchematronXML.ATTR_ID, m_sID);
    ret.setAttribute (CSchematronXML.ATTR_IS_A, m_sIsA);
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
    return new ToStringGenerator (this).append ("abstract", m_bAbstract)
                                       .appendIfNotNull ("id", m_sID)
                                       .appendIfNotNull ("is-a", m_sIsA)
                                       .appendIfNotNull ("rich", m_aRich)
                                       .appendIf ("content", m_aContent, CollectionHelper::isNotEmpty)
                                       .appendIf ("foreignAttrs", m_aForeignAttrs, CollectionHelper::isNotEmpty)
                                       .getToString ();
  }
}
