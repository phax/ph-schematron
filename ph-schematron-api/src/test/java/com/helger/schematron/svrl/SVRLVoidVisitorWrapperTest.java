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
package com.helger.schematron.svrl;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertSame;

import org.jspecify.annotations.NonNull;
import org.junit.Test;

import com.helger.base.state.EContinue;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.schematron.svrl.jaxb.FiredRule;
import com.helger.schematron.svrl.jaxb.RichText;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.schematron.svrl.jaxb.SkippedAssert;
import com.helger.schematron.svrl.jaxb.SkippedReport;
import com.helger.schematron.svrl.jaxb.SuccessfulReport;
import com.helger.schematron.svrl.jaxb.SuppressedRule;
import com.helger.schematron.svrl.jaxb.Text;

/**
 * Test class for class {@link SVRLVoidVisitorWrapper}.
 *
 * @author Philip Helger
 */
public final class SVRLVoidVisitorWrapperTest
{
  @Test
  public void testBasic ()
  {
    final SchematronOutputType aSVRL = new SchematronOutputType ();
    final FiredRule aFiredRule = new FiredRule ();
    aFiredRule.setContext ("/root");
    aSVRL.getActivePatternOrActiveGroupAndFiredRule ().add (aFiredRule);
    final SuccessfulReport aSuccessfulReport = new SuccessfulReport ();
    aSuccessfulReport.setTest ("true()");
    aSuccessfulReport.setLocation ("/root");
    final Text aText = new Text ();
    aText.getContent ().add ("Report");
    aSuccessfulReport.setText (aText);
    aSVRL.getActivePatternOrActiveGroupAndFiredRule ().add (aSuccessfulReport);

    final ICommonsList <String> aEvents = new CommonsArrayList <> ();
    final ISVRLVoidVisitor aVoidVisitor = new ISVRLVoidVisitor ()
    {
      @Override
      public void onFiredRule (@NonNull final SchematronOutputType aParent, @NonNull final FiredRule aRule)
      {
        aEvents.add ("FiredRule");
      }

      @Override
      public void onTextContent (@NonNull final RichText aParent, @NonNull final String sText)
      {
        aEvents.add (sText);
      }
    };
    final SVRLVoidVisitorWrapper aWrapper = new SVRLVoidVisitorWrapper (aVoidVisitor);
    assertSame (aVoidVisitor, aWrapper.getWrappedVisitor ());

    // The wrapper never stops the walk
    assertEquals (EContinue.CONTINUE, SVRLVisitor.visit (aSVRL, aWrapper));
    assertEquals (new CommonsArrayList <> ("FiredRule", "Report"), aEvents);
  }

  @Test
  public void testSchXsltExtensions ()
  {
    final SchematronOutputType aSVRL = new SchematronOutputType ();
    final SuppressedRule aSuppressedRule = new SuppressedRule ();
    aSuppressedRule.setId ("r1");
    aSVRL.getActivePatternOrActiveGroupAndFiredRule ().add (aSuppressedRule);
    final SkippedAssert aSkippedAssert = new SkippedAssert ();
    aSkippedAssert.setId ("sa1");
    aSVRL.getActivePatternOrActiveGroupAndFiredRule ().add (aSkippedAssert);
    final SkippedReport aSkippedReport = new SkippedReport ();
    aSkippedReport.setId ("sr1");
    aSVRL.getActivePatternOrActiveGroupAndFiredRule ().add (aSkippedReport);

    final ICommonsList <String> aEvents = new CommonsArrayList <> ();
    final ISVRLVoidVisitor aVoidVisitor = new ISVRLVoidVisitor ()
    {
      @Override
      public void onSuppressedRule (@NonNull final SchematronOutputType aParent, @NonNull final SuppressedRule aRule)
      {
        aEvents.add ("SuppressedRule:" + aRule.getId ());
      }

      @Override
      public void onSkippedAssert (@NonNull final SchematronOutputType aParent, @NonNull final SkippedAssert aAssert)
      {
        aEvents.add ("SkippedAssert:" + aAssert.getId ());
      }

      @Override
      public void onSkippedReport (@NonNull final SchematronOutputType aParent, @NonNull final SkippedReport aReport)
      {
        aEvents.add ("SkippedReport:" + aReport.getId ());
      }
    };
    assertEquals (EContinue.CONTINUE, SVRLVisitor.visit (aSVRL, new SVRLVoidVisitorWrapper (aVoidVisitor)));
    assertEquals (new CommonsArrayList <> ("SuppressedRule:r1", "SkippedAssert:sa1", "SkippedReport:sr1"), aEvents);

    // The default methods ignore the extensions
    assertEquals (EContinue.CONTINUE, SVRLVisitor.visit (aSVRL, new SVRLVoidVisitorWrapper (new ISVRLVoidVisitor ()
    {})));
  }
}
