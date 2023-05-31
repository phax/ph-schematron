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
package com.helger.schematron.pure.bound.xpath;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.Immutable;
import javax.xml.xpath.XPathExpression;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.collection.impl.ICommonsMap;
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
  private final ICommonsList <PSXPathBoundElement> m_aBoundContent;
  private final ICommonsMap <String, PSXPathBoundDiagnostic> m_aBoundDiagnostics;

  public PSXPathBoundAssertReport (@Nonnull final PSAssertReport aAssertReport,
                                   @Nonnull final String sTestExpression,
                                   @Nonnull final XPathExpression aBoundTestExpression,
                                   @Nonnull final ICommonsList <PSXPathBoundElement> aBoundContent,
                                   @Nonnull final ICommonsMap <String, PSXPathBoundDiagnostic> aBoundDiagnostics)
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
  public final PSAssertReport getAssertReport ()
  {
    return m_aAssertReport;
  }

  /**
   * @return The source XPath expression that was compiled. Never
   *         <code>null</code>.
   */
  @Nonnull
  public final String getTestExpression ()
  {
    return m_sTestExpression;
  }

  /**
   * @return The pre-compiled XPath expression. Never <code>null</code>.
   */
  @Nonnull
  public final XPathExpression getBoundTestExpression ()
  {
    return m_aBoundTestExpression;
  }

  /**
   * @return All contained bound elements. It has the same amount of elements as
   *         the source assert/report.
   */
  @Nonnull
  @ReturnsMutableCopy
  public final ICommonsList <PSXPathBoundElement> getAllBoundContentElements ()
  {
    return m_aBoundContent.getClone ();
  }

  /**
   * Get the bound diagnostic matching the passed ID
   *
   * @param sID
   *        The ID to be resolved. May be <code>null</code>.
   * @return <code>null</code> if the passed ID could not be resolved.
   */
  @Nullable
  public final PSXPathBoundDiagnostic getBoundDiagnosticOfID (@Nullable final String sID)
  {
    return m_aBoundDiagnostics.get (sID);
  }

  /**
   * Get all bound diagnostics
   *
   * @return A copy of all bound diagnostics. Never <code>null</code> but maybe
   *         empty.
   */
  @Nullable
  public final ICommonsMap <String, PSXPathBoundDiagnostic> getAllBoundDiagnostics ()
  {
    return m_aBoundDiagnostics.getClone ();
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("AssertReport", m_aAssertReport)
                                       .append ("TestExpression", m_sTestExpression)
                                       .append ("BoundTestExpression", m_aBoundTestExpression)
                                       .append ("BoundContent", m_aBoundContent)
                                       .append ("BoundDiagnostics", m_aBoundDiagnostics)
                                       .getToString ();
  }
}
