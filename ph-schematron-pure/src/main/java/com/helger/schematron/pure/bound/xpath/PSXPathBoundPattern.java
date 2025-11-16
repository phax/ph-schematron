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
package com.helger.schematron.pure.bound.xpath;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.collection.commons.ICommonsList;
import com.helger.schematron.pure.binding.xpath.PSXPathVariables;
import com.helger.schematron.pure.model.PSPattern;

/**
 * This class represents a single XPath-bound pattern-element.
 *
 * @author Philip Helger
 */
@Immutable
public class PSXPathBoundPattern
{
  private final PSPattern m_aPattern;
  private final ICommonsList <PSXPathBoundRule> m_aBoundRules;
  private final PSXPathVariables m_aVariables;

  public PSXPathBoundPattern (@NonNull final PSPattern aPattern,
                              @NonNull final ICommonsList <PSXPathBoundRule> aBoundRules,
                              @NonNull final PSXPathVariables aVariables)
  {
    ValueEnforcer.notNull (aPattern, "Pattern");
    ValueEnforcer.notNull (aBoundRules, "BoundRules");
    ValueEnforcer.notNull (aVariables, "Variables");
    m_aPattern = aPattern;
    m_aBoundRules = aBoundRules;
    m_aVariables = aVariables;
  }

  @NonNull
  public PSPattern getPattern ()
  {
    return m_aPattern;
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <PSXPathBoundRule> getAllBoundRules ()
  {
    return m_aBoundRules.getClone ();
  }

  @NonNull
  public final PSXPathVariables getVariables ()
  {
    return m_aVariables;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("Pattern", m_aPattern)
                                       .append ("BoundRules", m_aBoundRules)
                                       .append ("Variables", m_aVariables)
                                       .getToString ();
  }
}
