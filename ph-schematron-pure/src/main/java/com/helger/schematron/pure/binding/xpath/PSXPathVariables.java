/*
 * Copyright (C) 2014-2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.pure.binding.xpath;

import java.util.Map;

import javax.xml.xpath.XPathExpression;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.Nonempty;
import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.state.EChange;
import com.helger.base.string.StringHelper;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.collection.commons.CommonsLinkedHashMap;
import com.helger.collection.commons.ICommonsOrderedMap;
import com.helger.collection.commons.ICommonsOrderedSet;

/**
 * This class manages all variables present in Schematron &lt;let&gt; elements.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class PSXPathVariables implements IPSXPathVariables
{
  @NonNull
  @ReturnsMutableCopy
  private static ICommonsOrderedMap <String, XPathExpression> _createMap ()
  {
    return new CommonsLinkedHashMap <> ();
  }

  private final ICommonsOrderedMap <String, XPathExpression> m_aMap;

  public PSXPathVariables ()
  {
    m_aMap = _createMap ();
  }

  public PSXPathVariables (@NonNull final IPSXPathVariables aOther)
  {
    m_aMap = aOther.getAll ();
  }

  /**
   * Add a new variable.
   *
   * @param aEntry
   *        The entry to be added - key is the variable name and value is the variable value. May
   *        not be <code>null</code>.
   * @return {@link EChange#UNCHANGED} if a variable with the same name is already present. Never
   *         <code>null</code>.
   */
  @NonNull
  public EChange add (final Map.@NonNull Entry <String, XPathExpression> aEntry)
  {
    return add (aEntry.getKey (), aEntry.getValue ());
  }

  /**
   * Add a new variable.
   *
   * @param sName
   *        The name of the variable. May neither be <code>null</code> nor empty.
   * @param sValue
   *        The value of the variable. May neither be <code>null</code> nor empty.
   * @return {@link EChange#UNCHANGED} if a variable with the same name is already present. Never
   *         <code>null</code>.
   */
  @NonNull
  public EChange add (@NonNull @Nonempty final String sName, @NonNull @Nonempty final XPathExpression sValue)
  {
    ValueEnforcer.notEmpty (sName, "Name");
    ValueEnforcer.notNull (sValue, "Value");

    if (m_aMap.containsKey (sName))
      return EChange.UNCHANGED;

    m_aMap.put (sName, sValue);
    return EChange.CHANGED;
  }

  /**
   * Remove the variable with the specified name
   *
   * @param sVarName
   *        The name of the variable to be removed. May be <code>null</code>.
   * @return {@link EChange#CHANGED} if the variable was removed successfully. Never
   *         <code>null</code>.
   */
  @NonNull
  public EChange remove (@Nullable final String sVarName)
  {
    if (StringHelper.isNotEmpty (sVarName))
      if (m_aMap.remove (PSXPathQueryBinding.PARAM_VARIABLE_PREFIX + sVarName) == null)
        return EChange.CHANGED;
    return EChange.UNCHANGED;
  }

  /**
   * Remove all variables with the specified names
   *
   * @param aVars
   *        A list of variable names to be removed. May be <code>null</code>.
   * @return {@link EChange#CHANGED} if at least one variable was removed successfully. Never
   *         <code>null</code>.
   */
  @NonNull
  public EChange removeAll (@Nullable final Iterable <String> aVars)
  {
    EChange eChange = EChange.UNCHANGED;
    if (aVars != null)
      for (final String sName : aVars)
        eChange = eChange.or (remove (sName));
    return eChange;
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsOrderedMap <String, XPathExpression> getAll ()
  {
    return m_aMap.getClone ();
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsOrderedSet <String> getAllNames ()
  {
    return m_aMap.copyOfKeySet ();
  }

  public boolean contains (@Nullable final String sName)
  {
    if (StringHelper.isEmpty (sName))
      return false;
    return m_aMap.containsKey (sName);
  }

  @Nullable
  public XPathExpression get (@Nullable final String sName)
  {
    if (StringHelper.isEmpty (sName))
      return null;
    return m_aMap.get (sName);
  }

  @NonNull
  @ReturnsMutableCopy
  public PSXPathVariables getClone ()
  {
    return new PSXPathVariables (this);
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("Map", m_aMap).getToString ();
  }
}
