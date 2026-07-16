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
import com.helger.base.string.StringHelper;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.collection.CollectionHelper;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.schematron.CSchematron;
import com.helger.schematron.CSchematronXML;
import com.helger.schematron.errorhandler.IPSErrorHandler;
import com.helger.xml.microdom.IMicroElement;
import com.helger.xml.microdom.MicroElement;

/**
 * A single Schematron <code>rules</code> element introduced in ISO/IEC 19757-3:2025.<br>
 * It is a container for one or more abstract {@link PSRule} elements ({@code rule[@abstract='true']})
 * that may be invoked - via {@link PSExtends} - from rules in any pattern in the same
 * schema or library. The pre-2025 model required abstract rules to live inside the pattern they
 * were extended from; the 2025 edition lifts that restriction by allowing this container at the
 * top level of <code>schema</code> and <code>library</code>.
 *
 * @author Philip Helger
 * @since 10.0.0 (Schematron 2025)
 */
@NotThreadSafe
public class PSRules implements IPSElement, IPSHasID, IPSHasRichGroup
{
  private String m_sID;
  private PSRichGroup m_aRich;
  private PSTitle m_aTitle;
  private final ICommonsList <PSP> m_aPs = new CommonsArrayList <> ();
  private final ICommonsList <PSRule> m_aAbstractRules = new CommonsArrayList <> ();

  public PSRules ()
  {}

  public boolean isValid (@NonNull final IPSErrorHandler aErrorHandler)
  {
    if (m_aAbstractRules.isEmpty ())
    {
      aErrorHandler.error (this, "<rules> has no abstract <rule>s");
      return false;
    }
    for (final PSRule aRule : m_aAbstractRules)
    {
      if (!aRule.isAbstract ())
      {
        aErrorHandler.error (this, "<rules> may only contain abstract <rule>s");
        return false;
      }
      if (!aRule.isValid (aErrorHandler))
        return false;
    }
    if (m_aTitle != null && !m_aTitle.isValid (aErrorHandler))
      return false;
    for (final PSP aP : m_aPs)
      if (!aP.isValid (aErrorHandler))
        return false;
    return true;
  }

  public void validateCompletely (@NonNull final IPSErrorHandler aErrorHandler)
  {
    if (m_aAbstractRules.isEmpty ())
      aErrorHandler.error (this, "<rules> has no abstract <rule>s");
    for (final PSRule aRule : m_aAbstractRules)
    {
      if (!aRule.isAbstract ())
        aErrorHandler.error (this, "<rules> may only contain abstract <rule>s");
      aRule.validateCompletely (aErrorHandler);
    }
    if (m_aTitle != null)
      m_aTitle.validateCompletely (aErrorHandler);
    for (final PSP aP : m_aPs)
      aP.validateCompletely (aErrorHandler);
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

  public void addP (@NonNull final PSP aP)
  {
    ValueEnforcer.notNull (aP, "P");
    m_aPs.add (aP);
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <PSP> getAllPs ()
  {
    return m_aPs.getClone ();
  }

  public void addAbstractRule (@NonNull final PSRule aRule)
  {
    ValueEnforcer.notNull (aRule, "Rule");
    m_aAbstractRules.add (aRule);
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <PSRule> getAllAbstractRules ()
  {
    return m_aAbstractRules.getClone ();
  }

  @Nullable
  public PSRule getAbstractRuleOfID (@Nullable final String sID)
  {
    if (StringHelper.isNotEmpty (sID))
      for (final PSRule aRule : m_aAbstractRules)
        if (sID.equals (aRule.getID ()))
          return aRule;
    return null;
  }

  @NonNull
  public IMicroElement getAsMicroElement ()
  {
    final IMicroElement ret = new MicroElement (CSchematron.NAMESPACE_SCHEMATRON, CSchematronXML.ELEMENT_RULES);
    ret.setAttribute (CSchematronXML.ATTR_ID, m_sID);
    if (m_aRich != null)
      m_aRich.fillMicroElement (ret);
    if (m_aTitle != null)
      ret.addChild (m_aTitle.getAsMicroElement ());
    for (final PSP aP : m_aPs)
      ret.addChild (aP.getAsMicroElement ());
    for (final PSRule aRule : m_aAbstractRules)
      ret.addChild (aRule.getAsMicroElement ());
    return ret;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).appendIfNotNull ("ID", m_sID)
                                       .appendIfNotNull ("Rich", m_aRich)
                                       .appendIfNotNull ("Title", m_aTitle)
                                       .appendIf ("Ps", m_aPs, CollectionHelper::isNotEmpty)
                                       .appendIf ("AbstractRules", m_aAbstractRules, CollectionHelper::isNotEmpty)
                                       .getToString ();
  }
}
