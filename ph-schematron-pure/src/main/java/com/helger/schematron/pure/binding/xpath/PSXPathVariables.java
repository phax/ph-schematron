/*
 * Copyright (C) 2014-2023 Philip Helger (www.helger.com)
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

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.NotThreadSafe;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.Nonempty;
import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.impl.CommonsTreeMap;
import com.helger.commons.collection.impl.ICommonsNavigableMap;
import com.helger.commons.compare.IComparator;
import com.helger.commons.state.EChange;
import com.helger.commons.string.StringHelper;
import com.helger.commons.string.ToStringGenerator;

/**
 * This class manages all variables present in Schematron &lt;let&gt; elements.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class PSXPathVariables implements IPSXPathVariables
{
  @Nonnull
  @ReturnsMutableCopy
  private static ICommonsNavigableMap <String, String> _createMap ()
  {
    // Longest must be first
    return new CommonsTreeMap <> (IComparator.getComparatorStringLongestFirst ());
  }

  private final ICommonsNavigableMap <String, String> m_aMap;

  public PSXPathVariables ()
  {
    m_aMap = _createMap ();
  }

  public PSXPathVariables (@Nonnull final IPSXPathVariables aOther)
  {
    m_aMap = aOther.getAll ();
  }

  /**
   * Add a new variable.
   *
   * @param aEntry
   *        The entry to be added - key is the variable name and value is the
   *        variable value. May not be <code>null</code>.
   * @return {@link EChange#UNCHANGED} if a variable with the same name is
   *         already present. Never <code>null</code>.
   */
  @Nonnull
  public EChange add (@Nonnull final Map.Entry <String, String> aEntry)
  {
    return add (aEntry.getKey (), aEntry.getValue ());
  }

  /**
   * Add a new variable.
   *
   * @param sName
   *        The name of the variable. May neither be <code>null</code> nor
   *        empty.
   * @param sValue
   *        The value of the variable. May neither be <code>null</code> nor
   *        empty.
   * @return {@link EChange#UNCHANGED} if a variable with the same name is
   *         already present. Never <code>null</code>.
   */
  @Nonnull
  public EChange add (@Nonnull @Nonempty final String sName, @Nonnull @Nonempty final String sValue)
  {
    ValueEnforcer.notEmpty (sName, "Name");
    ValueEnforcer.notEmpty (sValue, "Value");

    // Prepend the "$" prefix to the variable name
    final String sRealName = PSXPathQueryBinding.PARAM_VARIABLE_PREFIX + sName;
    if (m_aMap.containsKey (sRealName))
      return EChange.UNCHANGED;

    // Apply all existing variables to this variable value!
    // This ensures that all variables used in variables are resolved correctly
    // as long as the order of declaration is correct.
    // Additionally this means that the order of the variables in this class is
    // irrelevant
    final String sRealValue = getAppliedReplacement (sValue);
    m_aMap.put (sRealName, sRealValue);
    return EChange.CHANGED;
  }

  @Nullable
  public String getAppliedReplacement (@Nullable final String sText)
  {
    return PSXPathQueryBinding.getWithParamTextsReplacedStatic (sText, m_aMap);
  }

  /**
   * Remove the variable with the specified name
   *
   * @param sVarName
   *        The name of the variable to be removed. May be <code>null</code>.
   * @return {@link EChange#CHANGED} if the variable was removed successfully.
   *         Never <code>null</code>.
   */
  @Nonnull
  public EChange remove (@Nullable final String sVarName)
  {
    if (StringHelper.hasText (sVarName))
      if (m_aMap.remove (PSXPathQueryBinding.PARAM_VARIABLE_PREFIX + sVarName) == null)
        return EChange.CHANGED;
    return EChange.UNCHANGED;
  }

  /**
   * Remove all variables with the specified names
   *
   * @param aVars
   *        A list of variable names to be removed. May be <code>null</code>.
   * @return {@link EChange#CHANGED} if at least one variable was removed
   *         successfully. Never <code>null</code>.
   */
  @Nonnull
  public EChange removeAll (@Nullable final Iterable <String> aVars)
  {
    EChange eChange = EChange.UNCHANGED;
    if (aVars != null)
      for (final String sName : aVars)
        eChange = eChange.or (remove (sName));
    return eChange;
  }

  @Nonnull
  @ReturnsMutableCopy
  public ICommonsNavigableMap <String, String> getAll ()
  {
    return m_aMap.getClone ();
  }

  public boolean contains (@Nullable final String sName)
  {
    if (StringHelper.hasNoText (sName))
      return false;
    return m_aMap.containsKey (sName);
  }

  @Nullable
  public String get (@Nullable final String sName)
  {
    if (StringHelper.hasNoText (sName))
      return null;
    return m_aMap.get (sName);
  }

  @Nonnull
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
