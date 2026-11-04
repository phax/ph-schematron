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
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertSame;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.junit.Test;

import com.helger.base.state.EContinue;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.schematron.svrl.jaxb.Active;
import com.helger.schematron.svrl.jaxb.ActiveGroup;
import com.helger.schematron.svrl.jaxb.ActivePattern;
import com.helger.schematron.svrl.jaxb.FailedAssert;
import com.helger.schematron.svrl.jaxb.FiredRule;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.schematron.svrl.jaxb.SuccessfulReport;

/**
 * Test class for class {@link SVRLContextVisitorWrapper}.
 *
 * @author Philip Helger
 */
public final class SVRLContextVisitorWrapperTest
{
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
    public EContinue onActivePattern (@NonNull final ActivePattern aActivePattern)
    {
      m_aEvents.add ("ActivePattern:" + aActivePattern.getId ());
      return EContinue.CONTINUE;
    }

    @Override
    public EContinue onActiveGroup (@NonNull final ActiveGroup aActiveGroup)
    {
      m_aEvents.add ("ActiveGroup:" + aActiveGroup.getId ());
      return EContinue.CONTINUE;
    }

    @Override
    public EContinue onFiredRule (@Nullable final Active aActive, @NonNull final FiredRule aFiredRule)
    {
      m_aEvents.add ("FiredRule:" + aFiredRule.getId () + "@" + _getID (aActive));
      return EContinue.CONTINUE;
    }

    @Override
    public EContinue onFailedAssert (@Nullable final Active aActive,
                                     @Nullable final FiredRule aFiredRule,
                                     @NonNull final FailedAssert aFailedAssert)
    {
      m_aEvents.add ("FailedAssert:" + aFailedAssert.getId () + "@" + _getID (aActive) + "/" + _getID (aFiredRule));
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
                     _getID (aActive) +
                     "/" +
                     _getID (aFiredRule));
      return EContinue.CONTINUE;
    }
  }

  @NonNull
  private static SchematronOutputType _createSVRL ()
  {
    final SchematronOutputType ret = new SchematronOutputType ();
    final ICommonsList <Object> aItems = new CommonsArrayList <> ();

    // Failed assert before any active pattern
    final FailedAssert aFA0 = new FailedAssert ();
    aFA0.setId ("fa0");
    aItems.add (aFA0);

    final ActivePattern aActivePattern = new ActivePattern ();
    aActivePattern.setId ("pat1");
    aItems.add (aActivePattern);
    final FiredRule aRule1 = new FiredRule ();
    aRule1.setId ("r1");
    aItems.add (aRule1);
    final FailedAssert aFA1 = new FailedAssert ();
    aFA1.setId ("fa1");
    aItems.add (aFA1);

    // A new active group resets the fired rule
    final ActiveGroup aActiveGroup = new ActiveGroup ();
    aActiveGroup.setId ("grp1");
    aItems.add (aActiveGroup);
    final FailedAssert aFA2 = new FailedAssert ();
    aFA2.setId ("fa2");
    aItems.add (aFA2);
    final FiredRule aRule2 = new FiredRule ();
    aRule2.setId ("r2");
    aItems.add (aRule2);
    final SuccessfulReport aSR1 = new SuccessfulReport ();
    aSR1.setId ("sr1");
    aItems.add (aSR1);

    ret.getActivePatternOrActiveGroupAndFiredRule ().addAll (aItems);
    return ret;
  }

  @Test
  public void testContext ()
  {
    final RecordingVisitor aVisitor = new RecordingVisitor ();
    assertEquals (EContinue.CONTINUE, SVRLVisitor.visit (_createSVRL (), aVisitor));
    assertEquals (new CommonsArrayList <> ("FailedAssert:fa0@null/null",
                                           "ActivePattern:pat1",
                                           "FiredRule:r1@pat1",
                                           "FailedAssert:fa1@pat1/r1",
                                           "ActiveGroup:grp1",
                                           "FailedAssert:fa2@grp1/null",
                                           "FiredRule:r2@grp1",
                                           "SuccessfulReport:sr1@grp1/r2"), aVisitor.m_aEvents);
  }

  @Test
  public void testReuse ()
  {
    final RecordingVisitor aVisitor = new RecordingVisitor ();
    final SVRLContextVisitorWrapper aWrapper = new SVRLContextVisitorWrapper (aVisitor);
    assertSame (aVisitor, aWrapper.getWrappedVisitor ());

    SVRLVisitor.visit (_createSVRL (), aWrapper);
    assertEquals ("grp1", aWrapper.getCurrentActive ().getId ());
    assertEquals ("r2", aWrapper.getCurrentFiredRule ().getId ());

    // The context of the previous document must not leak into the next one
    aVisitor.m_aEvents.clear ();
    SVRLVisitor.visit (_createSVRL (), aWrapper);
    assertEquals ("FailedAssert:fa0@null/null", aVisitor.m_aEvents.getFirstOrNull ());
  }

  @Test
  public void testBreak ()
  {
    final ICommonsList <String> aEvents = new CommonsArrayList <> ();
    final EContinue eResult = SVRLVisitor.visit (_createSVRL (), new ISVRLContextVisitor ()
    {
      @Override
      public EContinue onFailedAssert (@Nullable final Active aActive,
                                       @Nullable final FiredRule aFiredRule,
                                       @NonNull final FailedAssert aFailedAssert)
      {
        aEvents.add (aFailedAssert.getId ());
        return "fa1".equals (aFailedAssert.getId ()) ? EContinue.BREAK : EContinue.CONTINUE;
      }
    });
    assertEquals (EContinue.BREAK, eResult);
    assertEquals (new CommonsArrayList <> ("fa0", "fa1"), aEvents);
  }

  @Test
  public void testEmpty ()
  {
    final SVRLContextVisitorWrapper aWrapper = new SVRLContextVisitorWrapper (new ISVRLContextVisitor ()
    {});
    assertEquals (EContinue.CONTINUE, SVRLVisitor.visit (new SchematronOutputType (), aWrapper));
    assertNull (aWrapper.getCurrentActive ());
    assertNull (aWrapper.getCurrentFiredRule ());
  }
}
