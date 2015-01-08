/**
 * Copyright (C) 2014-2015 Philip Helger (www.helger.com)
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
import java.util.Map;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.Immutable;
import javax.xml.xpath.XPathExpression;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.collections.ContainerHelper;
import com.helger.commons.string.ToStringGenerator;
import com.helger.schematron.pure.model.PSAssertReport;

/**
 * This class represents a single XPath-bound assert- or report-element.
 *
 * @author Philip Helger
 */
@Immutable
public class PSXPathBoundAssertReport
{
  private final PSAssertReport m_aAssertReport;
  private final String m_sTestExpression;
  private final XPathExpression m_aBoundTestExpression;
  private final List <PSXPathBoundElement> m_aBoundContent;
  private final Map <String, PSXPathBoundDiagnostic> m_aBoundDiagnostics;

  public PSXPathBoundAssertReport (@Nonnull final PSAssertReport aAssertReport,
                                   @Nonnull final String sTestExpression,
                                   @Nonnull final XPathExpression aBoundTestExpression,
                                   @Nonnull final List <PSXPathBoundElement> aBoundContent,
                                   @Nonnull final Map <String, PSXPathBoundDiagnostic> aBoundDiagnostics)
  {
    ValueEnforcer.notNull (aAssertReport, "AssertReport");
    ValueEnforcer.notNull (sTestExpression, "TestExpression");
    ValueEnforcer.notNull (aBoundTestExpression, "BoundTestExpression");
    ValueEnforcer.notNull (aBoundContent, "BoundContent");
    ValueEnforcer.notNull (aBoundDiagnostics, "BoundDiagnostics");
    m_aAssertReport = aAssertReport;
    m_sTestExpression = sTestExpression;
    m_aBoundTestExpression = aBoundTestExpression;
    m_aBoundContent = aBoundContent;
    m_aBoundDiagnostics = aBoundDiagnostics;
  }

  /**
   * @return The original assert/report element. Never <code>null</code>.
   */
  @Nonnull
  public PSAssertReport getAssertReport ()
  {
    return m_aAssertReport;
  }

  /**
   * @return The source XPath expression that was compiled. Never
   *         <code>null</code>.
   */
  @Nonnull
  public String getTestExpression ()
  {
    return m_sTestExpression;
  }

  /**
   * @return The pre-compiled XPath expression. Never <code>null</code>.
   */
  @Nonnull
  public XPathExpression getBoundTestExpression ()
  {
    return m_aBoundTestExpression;
  }

  /**
   * @return All contained bound elements. It has the same amount of elements as
   *         the source assert/report.
   */
  @Nonnull
  public List <PSXPathBoundElement> getAllBoundContentElements ()
  {
    return ContainerHelper.newList (m_aBoundContent);
  }

  /**
   * Get the bound diagnostic matching the passed ID
   *
   * @param sID
   *        The ID to be resolved. May be <code>null</code>.
   * @return <code>null</code> if the passed ID could not be resolved.
   */
  @Nullable
  public PSXPathBoundDiagnostic getBoundDiagnosticOfID (@Nullable final String sID)
  {
    return m_aBoundDiagnostics.get (sID);
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("assertReport", m_aAssertReport)
                                       .append ("testExpression", m_sTestExpression)
                                       .append ("boundTestExpression", m_aBoundTestExpression)
                                       .append ("boundContent", m_aBoundContent)
                                       .append ("boundDiagnostics", m_aBoundDiagnostics)
                                       .toString ();
  }
}
