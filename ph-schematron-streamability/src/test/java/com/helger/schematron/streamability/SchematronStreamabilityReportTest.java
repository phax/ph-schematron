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
package com.helger.schematron.streamability;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;

/**
 * Test class for class {@link SchematronStreamabilityReport}, {@link PatternStreamability}, {@link RuleStreamability}
 * and {@link StreamabilityExpression}.
 *
 * @author Philip Helger
 */
public final class SchematronStreamabilityReportTest
{
  @Test
  public void testBasic ()
  {
    final StreamabilityExpression aContext = new StreamabilityExpression (EStreamabilityExpressionType.RULE_CONTEXT,
                                                                          null,
                                                                          "cac:Line",
                                                                          EStreamabilityClass.MOTIONLESS,
                                                                          null);
    assertEquals ("rule context 'cac:Line': motionless", aContext.getAsText ());
    final StreamabilityExpression aAssert = new StreamabilityExpression (EStreamabilityExpressionType.ASSERT,
                                                                         "A1",
                                                                         "cbc:A or cbc:B",
                                                                         EStreamabilityClass.BURST,
                                                                         "expression operator or");
    assertEquals ("sch:assert [A1] 'cbc:A or cbc:B': burst (expression operator or)", aAssert.getAsText ());
    assertEquals ("sch:report 'cbc:A or cbc:B': non-local",
                  new StreamabilityExpression (EStreamabilityExpressionType.REPORT,
                                               null,
                                               "\n  cbc:A  or\n\tcbc:B ",
                                               EStreamabilityClass.NON_LOCAL,
                                               null).getAsText ());
    final StreamabilityExpression aUnsupported = new StreamabilityExpression (EStreamabilityExpressionType.UNSUPPORTED,
                                                                              "g1",
                                                                              null,
                                                                              EStreamabilityClass.NON_LOCAL,
                                                                              "sch:group is not analysed");
    assertEquals ("unsupported [g1]: non-local (sch:group is not analysed)", aUnsupported.getAsText ());

    final RuleStreamability aRule1 = new RuleStreamability ("R1", "cac:Line", new CommonsArrayList <> (aContext, aAssert));
    assertEquals (EStreamabilityClass.BURST, aRule1.getStreamabilityClass ());
    assertEquals ("rule [R1] 'cac:Line'", aRule1.getAsText ());
    final RuleStreamability aRule2 = new RuleStreamability (null, "cac:Line", new CommonsArrayList <> (aContext));
    assertEquals (EStreamabilityClass.MOTIONLESS, aRule2.getStreamabilityClass ());
    assertEquals ("rule 'cac:Line'", aRule2.getAsText ());

    final PatternStreamability aPattern = new PatternStreamability ("P1", new CommonsArrayList <> (aRule1, aRule2));
    assertEquals (EStreamabilityClass.BURST, aPattern.getStreamabilityClass ());
    assertEquals ("pattern [P1]", aPattern.getAsText ());
    assertEquals (EStreamabilityClass.MOTIONLESS,
                  new PatternStreamability (null, new CommonsArrayList <> ()).getStreamabilityClass ());

    final SchematronStreamabilityReport aReport = new SchematronStreamabilityReport (new CommonsArrayList <> (aUnsupported),
                                                                                     new CommonsArrayList <> (aPattern));
    assertEquals (EStreamabilityClass.NON_LOCAL, aReport.getStreamabilityClass ());
    assertEquals (2, aReport.getRuleCount ());
    assertEquals (1, aReport.getRuleCount (EStreamabilityClass.MOTIONLESS));
    assertEquals (1, aReport.getRuleCount (EStreamabilityClass.BURST));
    assertEquals (0, aReport.getRuleCount (EStreamabilityClass.NON_LOCAL));
    assertEquals ("non-local: 1 pattern, 2 rules (1 motionless, 1 burst, 0 non-local), 1 global expression",
                  aReport.getSummaryText ());

    final ICommonsList <String> aFindings = aReport.getAllFindingTexts ();
    assertEquals (2, aFindings.size ());
    assertEquals ("unsupported [g1]: non-local (sch:group is not analysed)", aFindings.get (0));
    assertEquals ("pattern [P1], rule [R1] 'cac:Line': sch:assert [A1] 'cbc:A or cbc:B': burst (expression operator or)",
                  aFindings.get (1));
  }
}
