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

import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.collection.commons.ICommonsList;
import com.helger.schematron.pure.model.PSDiagnostic;

import jakarta.annotation.Nonnull;

/**
 * This class represents a single XPath-bound diagnostic-element.
 *
 * @author Philip Helger
 */
@Immutable
public class PSXPathBoundDiagnostic
{
  private final PSDiagnostic m_aDiagnostic;
  private final ICommonsList <PSXPathBoundElement> m_aBoundContent;

  public PSXPathBoundDiagnostic (@Nonnull final PSDiagnostic aDiagnostic,
                                 @Nonnull final ICommonsList <PSXPathBoundElement> aBoundContent)
  {
    ValueEnforcer.notNull (aDiagnostic, "Diagnostic");
    ValueEnforcer.notNull (aBoundContent, "BoundContent");
    m_aDiagnostic = aDiagnostic;
    m_aBoundContent = aBoundContent;
  }

  @Nonnull
  public PSDiagnostic getDiagnostic ()
  {
    return m_aDiagnostic;
  }

  @Nonnull
  @ReturnsMutableCopy
  public ICommonsList <PSXPathBoundElement> getAllBoundContentElements ()
  {
    return m_aBoundContent.getClone ();
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("Diagnostic", m_aDiagnostic)
                                       .append ("BoundContent", m_aBoundContent)
                                       .getToString ();
  }
}
