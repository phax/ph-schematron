/*
 * Copyright (C) 2020-2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.supplementary;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.junit.Test;

import com.helger.base.state.EContinue;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.io.resource.ClassPathResource;
import com.helger.schematron.schxslt2.xslt.SchematronResourceSchXslt2;
import com.helger.schematron.svrl.AbstractSVRLMessage;
import com.helger.schematron.svrl.ISVRLContextVisitor;
import com.helger.schematron.svrl.SVRLContextVisitorWrapper;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.SVRLVisitor;
import com.helger.schematron.svrl.jaxb.Active;
import com.helger.schematron.svrl.jaxb.FailedAssert;
import com.helger.schematron.svrl.jaxb.FiredRule;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.schematron.svrl.jaxb.SkippedAssert;
import com.helger.schematron.svrl.jaxb.SuccessfulReport;
import com.helger.schematron.svrl.jaxb.SuppressedRule;

/**
 * Test that the SVRL extensions of SchXslt2 (rule, pattern and group IDs, <code>xml:lang</code>,
 * <code>schematronEdition</code>, <code>svrl:suppressed-rule</code> and
 * <code>svrl:skipped-assert</code>) can be read.
 *
 * @author Philip Helger
 */
public final class SchXslt2SVRLExtensionsTest
{
  private static final String SCH = "external/schxslt-svrl-extensions/schxslt-svrl-extensions.sch";
  private static final String SCH_LANG = "external/schxslt-svrl-extensions/schxslt2-svrl-extensions-lang.sch";
  private static final String XML = "external/schxslt-svrl-extensions/schxslt-svrl-extensions.xml";
  private static final String PARAM_SEVERITY_THRESHOLD = "{http://dmaus.name/ns/2023/schxslt}severity-threshold";

  private static final class RecordingVisitor implements ISVRLContextVisitor
  {
    private final ICommonsList <String> m_aEvents = new CommonsArrayList <> ();

    @Nullable
    private static String _getID (@Nullable final Active aActive)
    {
      return aActive == null ? null : aActive.getId ();
    }

    @Nullable
    private static String _getID (@Nullable final FiredRule aFiredRule)
    {
      return aFiredRule == null ? null : aFiredRule.getId ();
    }

    @Override
    public EContinue onFiredRule (@Nullable final Active aActive, @NonNull final FiredRule aFiredRule)
    {
      m_aEvents.add ("FiredRule:" + aFiredRule.getId () + "@" + _getID (aActive));
      return EContinue.CONTINUE;
    }

    @Override
    public EContinue onSuppressedRule (@Nullable final Active aActive, @NonNull final SuppressedRule aSuppressedRule)
    {
      m_aEvents.add ("SuppressedRule:" + aSuppressedRule.getId () + "@" + _getID (aActive));
      return EContinue.CONTINUE;
    }

    @Override
    public EContinue onFailedAssert (@Nullable final Active aActive,
                                     @Nullable final FiredRule aFiredRule,
                                     @NonNull final FailedAssert aFailedAssert)
    {
      m_aEvents.add ("FailedAssert:" +
                     aFailedAssert.getId () +
                     "@" +
                     aFailedAssert.getPatternId () +
                     "/" +
                     aFailedAssert.getRuleId () +
                     "/" +
                     _getID (aFiredRule));
      return EContinue.CONTINUE;
    }

    @Override
    public EContinue onSuccessfulReport (@Nullable final Active aActive,
                                         @Nullable final FiredRule aFiredRule,
                                         @NonNull final SuccessfulReport aSuccessfulReport)
    {
      m_aEvents.add ("SuccessfulReport:" +
                     aSuccessfulReport.getId () +
                     "@" +
                     aSuccessfulReport.getPatternId () +
                     "/" +
                     aSuccessfulReport.getRuleId () +
                     "/" +
                     _getID (aFiredRule) +
                     (aSuccessfulReport.getLang () == null ? "" : "/" + aSuccessfulReport.getLang ()));
      return EContinue.CONTINUE;
    }

    @Override
    public EContinue onSkippedAssert (@Nullable final Active aActive,
                                      @Nullable final FiredRule aFiredRule,
                                      @NonNull final SkippedAssert aSkippedAssert)
    {
      m_aEvents.add ("SkippedAssert:" +
                     aSkippedAssert.getId () +
                     "@" +
                     aSkippedAssert.getPatternId () +
                     "/" +
                     aSkippedAssert.getRuleId () +
                     "/" +
                     _getID (aFiredRule) +
                     "/" +
                     aSkippedAssert.getSeverityThreshold ());
      return EContinue.CONTINUE;
    }
  }

  @NonNull
  private static ICommonsList <String> _visit (@NonNull final SchematronOutputType aSVRL)
  {
    final RecordingVisitor aVisitor = new RecordingVisitor ();
    SVRLVisitor.visit (aSVRL, new SVRLContextVisitorWrapper (aVisitor));
    return aVisitor.m_aEvents;
  }

  @Test
  public void testDefault () throws Exception
  {
    final SchematronResourceSchXslt2 aSCH = SchematronResourceSchXslt2.builderFromClassPath (SCH).build ();
    final SchematronOutputType aSVRL = aSCH.applySchematronValidationToSVRL (new ClassPathResource (XML));
    assertNotNull (aSVRL);
    assertEquals ("2025", aSVRL.getSchematronEdition ());

    assertEquals (new CommonsArrayList <> ("FiredRule:R1@P1",
                                           "FailedAssert:A1@P1/R1/R1",
                                           "SuccessfulReport:S1@P1/R1/R1",
                                           "FailedAssert:A2@P1/R1/R1",
                                           "SuppressedRule:R2@P1"),
                  _visit (aSVRL));

    final ICommonsList <AbstractSVRLMessage> aMsgs = SVRLHelper.getAllFailedAssertionsAndSuccessfulReports (aSVRL);
    assertEquals (3, aMsgs.size ());
    for (final AbstractSVRLMessage aMsg : aMsgs)
    {
      assertEquals ("R1", aMsg.getRuleID ());
      assertEquals ("P1", aMsg.getPatternID ());
      assertEquals (null, aMsg.getGroupID ());
    }
  }

  @Test
  public void testSeverityThreshold () throws Exception
  {
    final SchematronResourceSchXslt2 aSCH = SchematronResourceSchXslt2.builderFromClassPath (SCH)
                                                                      .parameter (PARAM_SEVERITY_THRESHOLD, "error")
                                                                      .build ();
    final SchematronOutputType aSVRL = aSCH.applySchematronValidationToSVRL (new ClassPathResource (XML));
    assertNotNull (aSVRL);

    assertEquals (new CommonsArrayList <> ("FiredRule:R1@P1",
                                           "FailedAssert:A1@P1/R1/R1",
                                           "SuccessfulReport:S1@P1/R1/R1",
                                           "SkippedAssert:A2@P1/R1/R1/error",
                                           "SuppressedRule:R2@P1"),
                  _visit (aSVRL));
    assertEquals (2, SVRLHelper.getAllFailedAssertionsAndSuccessfulReports (aSVRL).size ());
  }

  @Test
  public void testXmlLang () throws Exception
  {
    final SchematronResourceSchXslt2 aSCH = SchematronResourceSchXslt2.builderFromClassPath (SCH_LANG).build ();
    final SchematronOutputType aSVRL = aSCH.applySchematronValidationToSVRL (new ClassPathResource (XML));
    assertNotNull (aSVRL);

    // Only the report has a language different from the schema
    assertEquals (new CommonsArrayList <> ("FiredRule:null@null",
                                           "FailedAssert:A1@null/null/null",
                                           "SuccessfulReport:S1@null/null/null/de"),
                  _visit (aSVRL));
  }
}
