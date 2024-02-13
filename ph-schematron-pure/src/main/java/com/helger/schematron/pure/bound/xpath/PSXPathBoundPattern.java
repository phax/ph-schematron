/*
 * Copyright (C) 2014-2024 Philip Helger (www.helger.com)
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

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.string.ToStringGenerator;
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

  public PSXPathBoundPattern (@Nonnull final PSPattern aPattern,
                              @Nonnull final ICommonsList <PSXPathBoundRule> aBoundRules,
                              @Nonnull final PSXPathVariables aVariables)
  {
    ValueEnforcer.notNull (aPattern, "Pattern");
    ValueEnforcer.notNull (aBoundRules, "BoundRules");
    ValueEnforcer.notNull (aVariables, "Variables");
    m_aPattern = aPattern;
    m_aBoundRules = aBoundRules;
    m_aVariables = aVariables;
  }

  @Nonnull
  public PSPattern getPattern ()
  {
    return m_aPattern;
  }

  @Nonnull
  @ReturnsMutableCopy
  public ICommonsList <PSXPathBoundRule> getAllBoundRules ()
  {
    return m_aBoundRules.getClone ();
  }

  @Nonnull
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
