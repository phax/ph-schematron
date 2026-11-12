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
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.base.equals.EqualsHelper;
import com.helger.collection.commons.ICommonsList;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.testfiles.SchematronTestHelper;

/**
 * Test class for class {@link SchematronStreamabilityAnalyzer}.
 *
 * @author Philip Helger
 */
public final class SchematronStreamabilityAnalyzerTest
{
  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronStreamabilityAnalyzerTest.class);

  @NonNull
  private static RuleStreamability _getRule (@NonNull final SchematronStreamabilityReport aReport,
                                             @NonNull final String sRuleID)
  {
    for (final PatternStreamability aPattern : aReport.getAllPatterns ())
      for (final RuleStreamability aRule : aPattern.getAllRules ())
        if (sRuleID.equals (aRule.getID ()))
          return aRule;
    throw new IllegalArgumentException ("No rule with ID '" + sRuleID + "'");
  }

  @NonNull
  private static StreamabilityExpression _getExpression (@NonNull final RuleStreamability aRule,
                                                         @NonNull final EStreamabilityExpressionType eType,
                                                         @Nullable final String sLabel)
  {
    for (final StreamabilityExpression aExpression : aRule.getAllExpressions ())
      if (aExpression.getType () == eType && EqualsHelper.equals (sLabel, aExpression.getLabel ()))
        return aExpression;
    throw new IllegalArgumentException ("No " + eType + " with label '" + sLabel + "' in " + aRule.getAsText ());
  }

  private static void _assert (@NonNull final StreamabilityExpression aExpression,
                               @NonNull final EStreamabilityClass eExpectedClass,
                               @Nullable final String sExpectedReason)
  {
    assertEquals (aExpression.getAsText (), eExpectedClass, aExpression.getStreamabilityClass ());
    assertEquals (aExpression.getAsText (), sExpectedReason, aExpression.getReason ());
  }

  private static void _assert (@NonNull final RuleStreamability aRule,
                               @NonNull final EStreamabilityExpressionType eType,
                               @Nullable final String sLabel,
                               @NonNull final EStreamabilityClass eExpectedClass,
                               @Nullable final String sExpectedReason)
  {
    _assert (_getExpression (aRule, eType, sLabel), eExpectedClass, sExpectedReason);
  }

  @Test
  public void testAllValidSchematronFiles () throws Exception
  {
    for (final IReadableResource aRes : SchematronTestHelper.getAllValidSchematronFiles ())
    {
      final SchematronStreamabilityReport aReport = SchematronStreamabilityAnalyzer.analyze (aRes);
      assertNotNull (aReport);
      LOGGER.info (aRes.getPath () + ": " + aReport.getSummaryText ());
      // phoxtrot compiles every expression of the test files, and none uses an unsupported construct
      for (final String sFinding : aReport.getAllFindingTexts ())
      {
        assertFalse (sFinding, sFinding.contains ("static error"));
        assertFalse (sFinding, sFinding.startsWith (EStreamabilityExpressionType.UNSUPPORTED.getDisplayName ()));
      }
    }
  }

  @Test
  public void testGlobalLets () throws Exception
  {
    final SchematronStreamabilityReport aReport = SchematronStreamabilityAnalyzer.analyze (new ClassPathResource ("streamability/basic.sch"));
    assertEquals (EStreamabilityClass.NON_LOCAL, aReport.getStreamabilityClass ());

    final ICommonsList <StreamabilityExpression> aGlobals = aReport.getAllGlobalExpressions ();
    assertEquals (3, aGlobals.size ());
    // A literal and a value of another document need no pass over the instance
    _assert (aGlobals.get (0), EStreamabilityClass.MOTIONLESS, null);
    _assert (aGlobals.get (1), EStreamabilityClass.MOTIONLESS, null);
    _assert (aGlobals.get (2),
             EStreamabilityClass.NON_LOCAL,
             "computed from the instance in a first pass: root /");
  }

  @Test
  public void testRules () throws Exception
  {
    final SchematronStreamabilityReport aReport = SchematronStreamabilityAnalyzer.analyze (new ClassPathResource ("streamability/basic.sch"));

    final RuleStreamability aLine = _getRule (aReport, "line");
    assertEquals (EStreamabilityClass.NON_LOCAL, aLine.getStreamabilityClass ());
    _assert (aLine, EStreamabilityExpressionType.RULE_CONTEXT, null, EStreamabilityClass.MOTIONLESS, null);
    _assert (aLine, EStreamabilityExpressionType.ASSERT, "attr", EStreamabilityClass.MOTIONLESS, null);
    _assert (aLine,
             EStreamabilityExpressionType.ASSERT,
             "two-children",
             EStreamabilityClass.BURST,
             "expression operator or");
    _assert (aLine, EStreamabilityExpressionType.REPORT, "global-path", EStreamabilityClass.NON_LOCAL, "axis step //");
    _assert (aLine,
             EStreamabilityExpressionType.ASSERT,
             "constant-let",
             EStreamabilityClass.BURST,
             "axis step child::cbc:Amount");
    _assert (aLine,
             EStreamabilityExpressionType.ASSERT,
             "other-document",
             EStreamabilityClass.BURST,
             "axis step child::cbc:Code");
    _assert (aLine, EStreamabilityExpressionType.ASSERT, "ancestor", EStreamabilityClass.MOTIONLESS, null);
    _assert (aLine,
             EStreamabilityExpressionType.ASSERT,
             "parent-child",
             EStreamabilityClass.NON_LOCAL,
             "axis step parent::node()");
    // The document element is an ancestor of every context
    _assert (aLine, EStreamabilityExpressionType.ASSERT, "document-element", EStreamabilityClass.MOTIONLESS, null);
    // The value of a let from the first pass can be used, navigating from it cannot
    _assert (aLine,
             EStreamabilityExpressionType.ASSERT,
             "first-pass-let",
             EStreamabilityClass.BURST,
             "axis step child::cbc:ID");
    _assert (aLine,
             EStreamabilityExpressionType.ASSERT,
             "first-pass-let-path",
             EStreamabilityClass.NON_LOCAL,
             "variable $invoiceID");

    // Rule lets are analysed where they are used
    final RuleStreamability aParty = _getRule (aReport, "party");
    _assert (aParty,
             EStreamabilityExpressionType.RULE_LET,
             "name",
             EStreamabilityClass.BURST,
             "axis step child::cbc:Name");
    _assert (aParty, EStreamabilityExpressionType.RULE_LET, "len", EStreamabilityClass.BURST, "via sch:let $name");
    _assert (aParty,
             EStreamabilityExpressionType.ASSERT,
             "rule-let",
             EStreamabilityClass.BURST,
             "via sch:let $name, $len");
    _assert (aParty, EStreamabilityExpressionType.VALUE_OF, "rule-let", EStreamabilityClass.BURST, "via sch:let $name");
    // A test that uses no let is not affected by them
    _assert (aParty, EStreamabilityExpressionType.ASSERT, "diagnostic", EStreamabilityClass.MOTIONLESS, null);
    _assert (aParty, EStreamabilityExpressionType.VALUE_OF, "d1", EStreamabilityClass.NON_LOCAL, "axis step //");
    _assert (aParty, EStreamabilityExpressionType.NAME, "name", EStreamabilityClass.MOTIONLESS, null);

    // Computing a let of the parent is motionless, navigating from it is not
    final RuleStreamability aParentLet = _getRule (aReport, "parent-let");
    _assert (aParentLet, EStreamabilityExpressionType.RULE_LET, "p", EStreamabilityClass.MOTIONLESS, null);
    _assert (aParentLet,
             EStreamabilityExpressionType.ASSERT,
             "parent-let-test",
             EStreamabilityClass.NON_LOCAL,
             "axis step parent::node()");

    final RuleStreamability aTax = _getRule (aReport, "tax");
    _assert (aTax, EStreamabilityExpressionType.ASSERT, "value-of", EStreamabilityClass.MOTIONLESS, null);
    _assert (aTax,
             EStreamabilityExpressionType.VALUE_OF,
             "value-of",
             EStreamabilityClass.NON_LOCAL,
             "axis step preceding-sibling::cac:TaxTotal");
    _assert (aTax,
             EStreamabilityExpressionType.ASSERT,
             "unknown-function",
             EStreamabilityClass.NON_LOCAL,
             "function u:check#1");
    _assert (aTax,
             EStreamabilityExpressionType.ASSERT,
             "declared-function",
             EStreamabilityClass.BURST,
             "axis step child::cbc:Amount");
    _assert (aTax, EStreamabilityExpressionType.ASSERT, "key", EStreamabilityClass.NON_LOCAL, "function key#2");
    final StreamabilityExpression aStaticError = _getExpression (aTax,
                                                                 EStreamabilityExpressionType.ASSERT,
                                                                 "static-error");
    assertEquals (EStreamabilityClass.NON_LOCAL, aStaticError.getStreamabilityClass ());
    assertTrue (aStaticError.getReason (), aStaticError.getReason ().startsWith ("static error XPST0003"));

    // A pattern with a predicate that reads the subtree is matched on the buffered subtree
    final RuleStreamability aPredicate = _getRule (aReport, "predicate");
    _assert (aPredicate,
             EStreamabilityExpressionType.RULE_CONTEXT,
             null,
             EStreamabilityClass.BURST,
             "axis step child::cbc:Q");
    _assert (aPredicate, EStreamabilityExpressionType.ASSERT, "in-predicate-rule", EStreamabilityClass.MOTIONLESS, null);
  }

  @Test
  public void testAbstractPattern () throws Exception
  {
    final SchematronStreamabilityReport aReport = SchematronStreamabilityAnalyzer.analyze (new ClassPathResource ("streamability/basic.sch"));
    final PatternStreamability aPattern = aReport.getAllPatterns ().findFirst (x -> "required-name".equals (x.getID ()));
    assertNotNull (aPattern);
    assertEquals (EStreamabilityClass.BURST, aPattern.getStreamabilityClass ());
    final RuleStreamability aRule = aPattern.getAllRules ().getFirstOrNull ();
    assertNotNull (aRule);
    // The parameters are replaced
    assertEquals ("cac:Item", aRule.getContext ());
    _assert (aRule, EStreamabilityExpressionType.ASSERT, null, EStreamabilityClass.BURST, "axis step child::cbc:Name");
  }

  @Test
  public void testUnsupported () throws Exception
  {
    final SchematronStreamabilityReport aReport = SchematronStreamabilityAnalyzer.analyze (new ClassPathResource ("streamability/unsupported.sch"));
    // Every rule alone is motionless, the unsupported constructs make the schema non-local
    assertEquals (2, aReport.getRuleCount (EStreamabilityClass.MOTIONLESS));
    assertEquals (EStreamabilityClass.NON_LOCAL, aReport.getStreamabilityClass ());

    final ICommonsList <StreamabilityExpression> aGlobals = aReport.getAllGlobalExpressions ();
    assertEquals (4, aGlobals.size ());
    assertEquals (EStreamabilityExpressionType.UNSUPPORTED, aGlobals.get (0).getType ());
    _assert (aGlobals.get (0), EStreamabilityClass.NON_LOCAL, "sch:group is not analysed");
    _assert (aGlobals.get (1), EStreamabilityClass.NON_LOCAL, "pattern/@documents is not analysed");
    _assert (aGlobals.get (2), EStreamabilityClass.NON_LOCAL, "rule/@visit-each is not analysed");
    assertEquals (EStreamabilityExpressionType.GLOBAL_LET, aGlobals.get (3).getType ());
    assertNull (aGlobals.get (3).getExpression ());
    _assert (aGlobals.get (3), EStreamabilityClass.NON_LOCAL, "sch:let with element content is not analysed");
  }
}
