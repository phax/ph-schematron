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
import com.helger.schematron.schxslt.xslt2.SchematronResourceSchXslt_XSLT2;
import com.helger.schematron.svrl.ISVRLContextVisitor;
import com.helger.schematron.svrl.SVRLContextVisitorWrapper;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.SVRLVisitor;
import com.helger.schematron.svrl.jaxb.Active;
import com.helger.schematron.svrl.jaxb.ActivePattern;
import com.helger.schematron.svrl.jaxb.DiagnosticReference;
import com.helger.schematron.svrl.jaxb.Dir;
import com.helger.schematron.svrl.jaxb.Emph;
import com.helger.schematron.svrl.jaxb.FailedAssert;
import com.helger.schematron.svrl.jaxb.FiredRule;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.schematron.svrl.jaxb.Span;
import com.helger.schematron.svrl.jaxb.SuccessfulReport;
import com.helger.schematron.svrl.jaxb.SuppressedRule;
import com.helger.schematron.svrl.jaxb.Text;

/**
 * Test that the SVRL extensions of SchXslt can be read: <code>svrl:suppressed-rule</code> and the
 * attributes SchXslt copies from the Schematron (<code>see</code>, <code>icon</code>,
 * <code>fpi</code>, <code>xml:*</code> and more).
 *
 * @author Philip Helger
 */
public final class SchXsltSVRLExtensionsTest
{
  private static final String SCH = "external/schxslt-svrl-extensions/schxslt-svrl-extensions.sch";
  private static final String SCH_RICH = "external/schxslt-svrl-extensions/schxslt-svrl-rich.sch";
  private static final String XML = "external/schxslt-svrl-extensions/schxslt-svrl-extensions.xml";

  private static final class RecordingVisitor implements ISVRLContextVisitor
  {
    private final ICommonsList <String> m_aEvents = new CommonsArrayList <> ();

    @Nullable
    private static String _getID (@Nullable final FiredRule aFiredRule)
    {
      return aFiredRule == null ? null : aFiredRule.getId ();
    }

    @Override
    public EContinue onFiredRule (@Nullable final Active aActive, @NonNull final FiredRule aFiredRule)
    {
      m_aEvents.add ("FiredRule:" + aFiredRule.getId ());
      return EContinue.CONTINUE;
    }

    @Override
    public EContinue onSuppressedRule (@Nullable final Active aActive, @NonNull final SuppressedRule aSuppressedRule)
    {
      m_aEvents.add ("SuppressedRule:" + aSuppressedRule.getId ());
      return EContinue.CONTINUE;
    }

    @Override
    public EContinue onFailedAssert (@Nullable final Active aActive,
                                     @Nullable final FiredRule aFiredRule,
                                     @NonNull final FailedAssert aFailedAssert)
    {
      m_aEvents.add ("FailedAssert:" + aFailedAssert.getId () + "@" + _getID (aFiredRule));
      return EContinue.CONTINUE;
    }

    @Override
    public EContinue onSuccessfulReport (@Nullable final Active aActive,
                                         @Nullable final FiredRule aFiredRule,
                                         @NonNull final SuccessfulReport aSuccessfulReport)
    {
      m_aEvents.add ("SuccessfulReport:" + aSuccessfulReport.getId () + "@" + _getID (aFiredRule));
      return EContinue.CONTINUE;
    }
  }

  @Test
  public void testSuppressedRule () throws Exception
  {
    final SchematronResourceSchXslt_XSLT2 aSCH = SchematronResourceSchXslt_XSLT2.builderFromClassPath (SCH).build ();
    final SchematronOutputType aSVRL = aSCH.applySchematronValidationToSVRL (new ClassPathResource (XML));
    assertNotNull (aSVRL);

    final RecordingVisitor aVisitor = new RecordingVisitor ();
    SVRLVisitor.visit (aSVRL, new SVRLContextVisitorWrapper (aVisitor));
    assertEquals (new CommonsArrayList <> ("FiredRule:R1",
                                           "FailedAssert:A1@R1",
                                           "SuccessfulReport:S1@R1",
                                           "FailedAssert:A2@R1",
                                           "SuppressedRule:R2"),
                  aVisitor.m_aEvents);
    assertEquals (3, SVRLHelper.getAllFailedAssertionsAndSuccessfulReports (aSVRL).size ());
  }

  @Test
  public void testRichAttributes () throws Exception
  {
    final SchematronResourceSchXslt_XSLT2 aSCH = SchematronResourceSchXslt_XSLT2.builderFromClassPath (SCH_RICH).build ();
    final SchematronOutputType aSVRL = aSCH.applySchematronValidationToSVRL (new ClassPathResource (XML));
    assertNotNull (aSVRL);
    assertEquals ("en", aSVRL.getLang ());
    assertEquals ("default", aSVRL.getSpace ());

    // The paragraph of the schema
    final Text aP = aSVRL.getTextAtIndex (0);
    assertEquals ("p1", aP.getId ());
    assertEquals ("intro", aP.getClazz ());
    assertEquals ("intro.png", aP.getIcon ());
    final Emph aEmph = (Emph) aP.getContent ().get (1);
    assertEquals ("en", aEmph.getLang ());

    final ActivePattern aPattern = (ActivePattern) aSVRL.getActivePatternOrActiveGroupAndFiredRuleAtIndex (0);
    assertEquals ("en", aPattern.getLang ());

    final FiredRule aRule = (FiredRule) aSVRL.getActivePatternOrActiveGroupAndFiredRuleAtIndex (1);
    assertEquals ("rule.html", aRule.getSee ());
    assertEquals ("rule.png", aRule.getIcon ());
    assertEquals ("rule-fpi", aRule.getFpi ());
    assertEquals ("en", aRule.getLang ());

    final FailedAssert aFA = (FailedAssert) aSVRL.getActivePatternOrActiveGroupAndFiredRuleAtIndex (2);
    assertEquals ("assert.html", aFA.getSee ());
    assertEquals ("assert.png", aFA.getIcon ());
    assertEquals ("assert-fpi", aFA.getFpi ());
    assertEquals ("en", aFA.getLang ());
    final DiagnosticReference aDiag = aFA.getDiagnosticReferenceAtIndex (0);
    assertEquals ("en", aDiag.getLang ());
    assertEquals ("preserve", aDiag.getSpace ());
    assertEquals ("D1", aDiag.getText ().getId ());
    assertEquals ("diagRole", aDiag.getText ().getRole ());
    assertEquals ("en", aFA.getPropertyReferenceAtIndex (0).getLang ());
    final Dir aDir = (Dir) aFA.getText ().getContent ().get (1);
    assertEquals ("ltr", aDir.getValue ());
    assertEquals ("en", aDir.getLang ());

    final SuccessfulReport aSR = (SuccessfulReport) aSVRL.getActivePatternOrActiveGroupAndFiredRuleAtIndex (3);
    assertEquals ("report.html", aSR.getSee ());
    assertEquals ("de", aSR.getLang ());
    final Span aSpan = (Span) aSR.getText ().getContent ().get (1);
    assertEquals ("de", aSpan.getLang ());

    assertEquals (2, SVRLHelper.getAllFailedAssertionsAndSuccessfulReports (aSVRL).size ());
  }
}
