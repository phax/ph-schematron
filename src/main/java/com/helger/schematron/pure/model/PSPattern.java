/**
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
import com.helger.commons.log.InMemoryLogger;
import com.helger.commons.microdom.IMicroElement;
import com.helger.commons.microdom.impl.MicroElement;
import com.helger.commons.string.StringHelper;
import com.helger.commons.string.ToStringGenerator;
import com.helger.schematron.CSchematron;
import com.helger.schematron.CSchematronXML;

/**
 * A single Schematron pattern-element.<br>
 * A structure, simple or complex. A set of rules giving constraints that are in
 * some way related. The id attribute provides a unique name for the pattern and
 * is required for abstract patterns.<br>
 * The title and p elements allow rich documentation.<br>
 * The icon, see and fpi attributes allow rich interfaces and documentation.<br>
 * When a pattern element has the attribute abstract with a value true, then the
 * pattern defines an abstract pattern. An abstract pattern shall not have a
 * is-a attribute and shall have an id attribute.<br>
 * Abstract patterns allow a common definition mechanism for structures which
 * use different names and paths, but which are at heart the same. For example,
 * there are different table markup languages, but they all can be in large part
 * represented as an abstract pattern where a table contains rows and rows
 * contain entries, as defined in the following example using the default query
 * language binding:<br>
 *
 * <pre>
 *     <sch:pattern abstract="true" id="table">
 *         <sch:rule context="$table">
 *             <sch:assert test="$row">
 *             The element <sch:name/> is a table. Tables contain rows.
 *             </sch:assert>
 *         </sch:rule>
 *         <sch:rule context="$row">
 *             <sch:assert test="$entry">
 *             The element <sch:name/> is a table row. Rows contain entries.
 *             </sch:assert>
 *         </sch:rule>
 *     </sch:pattern>
 * </pre>
 *
 * When a pattern element has the attribute is-a with a value specifying the
 * name of an abstract pattern, then the pattern is an instance of an abstract
 * pattern. Such a pattern shall not contain any rule elements, but shall have
 * param elements for all parameters used in the abstract pattern.<br>
 * The following example uses the abstract pattern for tables given above to
 * create three patterns for tables with different names or structures.<br>
 *
 * <pre>
 *     <sch:pattern is-a="table" id="HTML_Table">
 *         <sch:param name="table" value="table"/>
 *         <sch:param name="row"   value="tr"/>
 *         <sch:param name="entry" value="td|th"/>
 *     </sch:pattern>
 *     <sch:pattern is-a="table" id="CALS_Table">
 *         <sch:param name="table" value="table"/>
 *         <sch:param name="row"   value=".//row"/>
 *         <sch:param name="entry" value="cell"/>
 *     </sch:pattern>
 *     <sch:pattern is-a="table" id="calendar">
 *         <sch:param name="table" value="calendar/year"/>
 *         <sch:param name="row"   value="week"/>
 *         <sch:param name="entry" value="day"/>
 *     </sch:pattern>
 * </pre>
 *
 * When creating an instance of an abstract pattern, the parameter values
 * supplied by the param element replace the parameter references used in the
 * abstract patterns. The examples above use the default query language binding
 * in which the character $ is used as the delimiter for parameter references.<br>
 * Thus, given the abstract patterns defined earlier in this clause, the
 * patterns defined above are equivalent to the following, with the id elements
 * shown expanded:<br>
 *
 * <pre>
 *     <sch:pattern id="HTML_table">
 *         <sch:rule context="table">
 *             <sch:assert test="tr">
 *             The element table is a table. Tables containing rows.
 *             </sch:assert>
 *         </sch:rule>
 *         <sch:rule context="tr">
 *             <sch:assert test="td|th">
 *             The element tr is a table row. Rows contain entries.
 *             </sch:assert>
 *         </sch:rule>
 *     </sch:pattern>
 *     <sch:pattern id="CALS_table">
 *         <sch:rule context="table">
 *             <sch:assert test=".//row">
 *             The element table is a table. Tables containing rows.
 *             </sch:assert>
 *         </sch:rule>
 *         <sch:rule context=".//row">
 *             <sch:assert test="cell">
 *             The element row is a table row. Rows contain entries.
 *             </sch:assert>
 *         </sch:rule>
 *     </sch:pattern>
 *     <sch:pattern id="calendar">
 *         <sch:rule context="calendar/year">
 *             <sch:assert test="week">
 *             The element year is a table. Tables containing rows.
 *             </sch:assert>
 *         </sch:rule>
 *         <sch:rule context="week">
 *             <sch:assert test="day">
 *             The element week is a table row. Rows contain entries.
 *             </sch:assert>
 *         </sch:rule>
 *     </sch:pattern>
 * </pre>
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class PSPattern implements IPSElement, IPSHasID, IPSHasForeignElements, IPSHasIncludes, IPSHasLets, IPSHasRichGroup
{
  private boolean m_bAbstract = false;
  private String m_sID;
  private String m_sIsA;
  private PSRichGroup m_aRich;
  private final List <PSInclude> m_aIncludes = new ArrayList <PSInclude> ();
  private PSTitle m_aTitle;
  private final List <IPSElement> m_aContent = new ArrayList <IPSElement> ();
  private Map <String, String> m_aForeignAttrs;
  private List <IMicroElement> m_aForeignElements;

  public PSPattern ()
  {}

  public boolean isValid (@Nonnull final InMemoryLogger aLogger)
  {
    // If abstract, an ID must be present
    if (m_bAbstract && StringHelper.hasNoText (m_sID))
    {
      aLogger.error ("abstract <pattern> does not have an 'id'");
      return false;
    }
    // is-a may not be present for abstract rules
    if (m_bAbstract && StringHelper.hasText (m_sIsA))
    {
      aLogger.error ("abstract <pattern> may not have an 'is-a'");
      return false;
    }
    if (StringHelper.hasNoText (m_sIsA))
    {
      // param only if is-a is set
      for (final IPSElement aContent : m_aContent)
        if (aContent instanceof PSParam)
        {
          aLogger.error ("<pattern> without 'is-a' may not contain <param>s");
          return false;
        }
    }
    else
    {
      // rule and let only if is-a is not set
      for (final IPSElement aContent : m_aContent)
      {
        if (aContent instanceof PSRule)
        {
          aLogger.error ("<pattern> with 'is-a' may not contain <rule>s");
          return false;
        }
        if (aContent instanceof PSLet)
        {
          aLogger.error ("<pattern> with 'is-a' may not contain <let>s");
          return false;
        }
      }
    }

    for (final PSInclude aInclude : m_aIncludes)
      if (!aInclude.isValid (aLogger))
        return false;
    if (m_aTitle != null && !m_aTitle.isValid (aLogger))
      return false;
    for (final IPSElement aContent : m_aContent)
      if (!aContent.isValid (aLogger))
        return false;
    return true;
  }

  public boolean isMinimal ()
  {
    if (m_bAbstract)
      return false;
    if (StringHelper.hasText (m_sIsA))
      return false;
    for (final PSInclude aInclude : m_aIncludes)
      if (!aInclude.isMinimal ())
        return false;
    if (m_aTitle != null && !m_aTitle.isMinimal ())
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

  public void setAbstract (final boolean bAbstract)
  {
    m_bAbstract = bAbstract;
  }

  public boolean isAbstract ()
  {
    return m_bAbstract;
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

  public void setIsA (@Nullable final String sIsA)
  {
    m_sIsA = sIsA;
  }

  @Nullable
  public String getIsA ()
  {
    return m_sIsA;
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

  public void addRule (@Nonnull final PSRule aRule)
  {
    ValueEnforcer.notNull (aRule, "Rule");
    m_aContent.add (aRule);
  }

  @Nullable
  public PSRule getRuleOfID (@Nullable final String sID)
  {
    if (StringHelper.hasText (sID))
      for (final IPSElement aElement : m_aContent)
        if (aElement instanceof PSRule)
        {
          final PSRule aRule = (PSRule) aElement;
          if (sID.equals (aRule.getID ()))
            return aRule;
        }
    return null;
  }

  @Nonnull
  @ReturnsMutableCopy
  public List <PSRule> getAllRules ()
  {
    final List <PSRule> ret = new ArrayList <PSRule> ();
    for (final IPSElement aElement : m_aContent)
      if (aElement instanceof PSRule)
        ret.add ((PSRule) aElement);
    return ret;
  }

  @Nonnegative
  public int getRuleCount ()
  {
    int ret = 0;
    for (final IPSElement aElement : m_aContent)
      if (aElement instanceof PSRule)
        ret++;
    return ret;
  }

  public void addParam (@Nonnull final PSParam aParam)
  {
    ValueEnforcer.notNull (aParam, "Param");
    m_aContent.add (aParam);
  }

  @Nonnull
  @ReturnsMutableCopy
  public List <PSParam> getAllParams ()
  {
    final List <PSParam> ret = new ArrayList <PSParam> ();
    for (final IPSElement aElement : m_aContent)
      if (aElement instanceof PSParam)
        ret.add ((PSParam) aElement);
    return ret;
  }

  public boolean hasAnyParam ()
  {
    for (final IPSElement aElement : m_aContent)
      if (aElement instanceof PSParam)
        return true;
    return false;
  }

  public void addP (@Nonnull final PSP aP)
  {
    ValueEnforcer.notNull (aP, "P");
    m_aContent.add (aP);
  }

  @Nonnull
  @ReturnsMutableCopy
  public List <PSP> getAllPs ()
  {
    final List <PSP> ret = new ArrayList <PSP> ();
    for (final IPSElement aElement : m_aContent)
      if (aElement instanceof PSP)
        ret.add ((PSP) aElement);
    return ret;
  }

  public void addLet (@Nonnull final PSLet aLet)
  {
    ValueEnforcer.notNull (aLet, "Let");
    m_aContent.add (aLet);
  }

  public boolean hasAnyLet ()
  {
    for (final IPSElement aElement : m_aContent)
      if (aElement instanceof PSLet)
        return true;
    return false;
  }

  @Nonnull
  @ReturnsMutableCopy
  public List <PSLet> getAllLets ()
  {
    final List <PSLet> ret = new ArrayList <PSLet> ();
    for (final IPSElement aElement : m_aContent)
      if (aElement instanceof PSLet)
        ret.add ((PSLet) aElement);
    return ret;
  }

  @Nonnull
  @ReturnsMutableCopy
  public Map <String, String> getAllLetsAsMap ()
  {
    final Map <String, String> ret = new LinkedHashMap <String, String> ();
    for (final IPSElement aElement : m_aContent)
      if (aElement instanceof PSLet)
      {
        final PSLet aLet = (PSLet) aElement;
        ret.put (aLet.getName (), aLet.getValue ());
      }
    return ret;
  }

  /**
   * @return A list consisting of {@link PSP}, {@link PSLet}, {@link PSRule} and
   *         {@link PSParam} parameters
   */
  @Nonnull
  @ReturnsMutableCopy
  public List <IPSElement> getAllContentElements ()
  {
    return ContainerHelper.newList (m_aContent);
  }

  @Nonnull
  public IMicroElement getAsMicroElement ()
  {
    final IMicroElement ret = new MicroElement (CSchematron.NAMESPACE_SCHEMATRON, CSchematronXML.ELEMENT_PATTERN);
    if (m_bAbstract)
      ret.setAttribute (CSchematronXML.ATTR_ABSTRACT, "true");
    ret.setAttribute (CSchematronXML.ATTR_ID, m_sID);
    ret.setAttribute (CSchematronXML.ATTR_IS_A, m_sIsA);
    if (m_aRich != null)
      m_aRich.fillMicroElement (ret);
    if (m_aForeignElements != null)
      for (final IMicroElement aForeignElement : m_aForeignElements)
        ret.appendChild (aForeignElement.getClone ());
    for (final PSInclude aInclude : m_aIncludes)
      ret.appendChild (aInclude.getAsMicroElement ());
    if (m_aTitle != null)
      ret.appendChild (m_aTitle.getAsMicroElement ());
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
    return new ToStringGenerator (this).append ("abstract", m_bAbstract)
                                       .appendIfNotNull ("id", m_sID)
                                       .appendIfNotNull ("is-a", m_sIsA)
                                       .appendIfNotNull ("rich", m_aRich)
                                       .append ("includes", m_aIncludes)
                                       .appendIfNotNull ("title", m_aTitle)
                                       .append ("content", m_aContent)
                                       .appendIfNotNull ("foreignAttrs", m_aForeignAttrs)
                                       .appendIfNotNull ("foreignElements", m_aForeignElements)
                                       .toString ();
  }
}
