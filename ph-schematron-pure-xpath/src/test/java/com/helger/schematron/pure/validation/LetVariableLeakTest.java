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
package com.helger.schematron.pure.validation;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import java.nio.charset.StandardCharsets;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.junit.Test;
import org.w3c.dom.Node;

import com.helger.base.state.EContinue;
import com.helger.schematron.model.PSAssertReport;
import com.helger.schematron.model.PSRule;
import com.helger.schematron.pure.SchematronResourcePureXPath;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.xml.serialize.read.DOMReader;

/**
 * Regression test for the 9.2.0 security review: <code>&lt;let&gt;</code> variable thread-local
 * bindings must not leak between two consecutive {@code validate(...)} calls on the same thread,
 * even when the first call aborts via an {@link IPSValidationHandler} returning
 * {@link EContinue#BREAK} or throwing.
 *
 * @author Philip Helger
 */
public final class LetVariableLeakTest
{
  /** Schematron with a global &lt;let&gt; that is evaluated up-front for every call. */
  private static final String SCHEMA = "<?xml version='1.0' encoding='UTF-8'?>\n" +
                                       "<iso:schema xmlns:iso='http://purl.oclc.org/dsdl/schematron'>\n" +
                                       "  <iso:let name='totalItems' value='count(/root/item)'/>\n" +
                                       "  <iso:pattern>\n" +
                                       "    <iso:rule context='/root'>\n" +
                                       "      <iso:assert test='$totalItems &gt;= 0'>sanity</iso:assert>\n" +
                                       "      <iso:report test='true()'>tripped: <iso:value-of select='$totalItems'/></iso:report>\n" +
                                       "    </iso:rule>\n" +
                                       "  </iso:pattern>\n" +
                                       "</iso:schema>";

  private static byte [] _createXmlItems (final int nItems)
  {
    final StringBuilder sb = new StringBuilder ("<root>");
    sb.append ("<item/>".repeat (nItems));
    sb.append ("</root>");
    return sb.toString ().getBytes (StandardCharsets.UTF_8);
  }

  /*
   * Drive two validations through the same {@link SchematronResourcePureXPath} on the same thread.
   * The first call BREAKs immediately on the first report (leaving the schema-global {@code
   * $totalItems} still bound on the thread). The second call MUST see its own freshly-evaluated
   * value, not the first run's leftover binding.
   */
  @Test
  public void testLetBindingDoesNotLeakAfterBreak () throws Exception
  {
    // Run #1: 5 items, handler returns BREAK on the first report.
    final IPSValidationHandler aBreakingHandler = new IPSValidationHandler ()
    {
      @Override
      @NonNull
      public EContinue onSuccessfulReport (@NonNull final PSRule aRule,
                                           @NonNull final PSAssertReport aAR,
                                           @NonNull final String sTest,
                                           @NonNull final Node aNode,
                                           final int nIdx,
                                           @Nullable final Object aCtx,
                                           @Nullable final Exception aEx)
      {
        return EContinue.BREAK;
      }
    };
    final SchematronResourcePureXPath aSCH = SchematronResourcePureXPath.builderFromString (SCHEMA)
                                                                        .customValidationHandler (aBreakingHandler)
                                                                        .build ();

    final SchematronOutputType aSvrl1 = aSCH.applySchematronValidationToSVRL (DOMReader.readXMLDOM (_createXmlItems (5)),
                                                                              null);
    assertNotNull (aSvrl1);
    assertEquals ("tripped: 5", SVRLHelper.getAllSuccessfulReports (aSvrl1).get (0).getText ());

    // Run #2: 2 items, no break. The cached bound schema is reused, so its XPathLetVariableResolver
    // is the SAME instance, with the SAME ThreadLocal. If run #1 leaked $totalItems=5 onto this
    // thread, the report text below would still read "tripped: 5".
    final SchematronResourcePureXPath aSCH2 = SchematronResourcePureXPath.builderFromString (SCHEMA).build ();
    final SchematronOutputType aSvrl2 = aSCH2.applySchematronValidationToSVRL (DOMReader.readXMLDOM (_createXmlItems (2)),
                                                                               null);
    assertNotNull (aSvrl2);
    assertEquals ("Stale <let> binding leaked from the previous BREAKing validation",
                  "tripped: 2",
                  SVRLHelper.getAllSuccessfulReports (aSvrl2).get (0).getText ());
  }
}
