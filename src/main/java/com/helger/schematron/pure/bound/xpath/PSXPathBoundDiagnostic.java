/**
 * Copyright (C) 2014 phloc systems (www.phloc.com)
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
package com.helger.schematron.pure.bound.xpath;

import java.util.List;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.collections.ContainerHelper;
import com.helger.commons.string.ToStringGenerator;
import com.helger.schematron.pure.model.PSDiagnostic;

/**
 * This class represents a single XPath-bound diagnostic-element.
 *
 * @author Philip Helger
 */
@Immutable
public class PSXPathBoundDiagnostic
{
  private final PSDiagnostic m_aDiagnostic;
  private final List <PSXPathBoundElement> m_aBoundContent;

  public PSXPathBoundDiagnostic (@Nonnull final PSDiagnostic aDiagnostic,
                                 @Nonnull final List <PSXPathBoundElement> aBoundContent)
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
  public List <PSXPathBoundElement> getAllBoundContentElements ()
  {
    return ContainerHelper.newList (m_aBoundContent);
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("diagnostic", m_aDiagnostic)
                                       .append ("boundContent", m_aBoundContent)
                                       .toString ();
  }
}
