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
package com.helger.schematron.phoxtrot;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.phoxtrot.xdm.XdmQName;
import com.helger.phoxtrot.xslt.XsltTraceTemplate;
import com.helger.schematron.api.telemetry.ISchematronTemplateTelemetry;
import com.helger.schematron.api.telemetry.SchematronTemplateInfo;

/**
 * Test class for class {@link PhoxtrotTemplateTelemetry}.
 *
 * @author Philip Helger
 */
public final class PhoxtrotTemplateTelemetryTest
{
  @Test
  public void testMapping ()
  {
    final ICommonsList <SchematronTemplateInfo> aEntered = new CommonsArrayList <> ();
    final ICommonsList <SchematronTemplateInfo> aLeft = new CommonsArrayList <> ();
    final PhoxtrotTemplateTelemetry aListener = new PhoxtrotTemplateTelemetry (new ISchematronTemplateTelemetry ()
    {
      @Override
      public void onTemplateEnter (final SchematronTemplateInfo aInfo)
      {
        aEntered.add (aInfo);
      }

      @Override
      public void onTemplateLeave (final SchematronTemplateInfo aInfo, final long nDurationNanos)
      {
        assertTrue (nDurationNanos >= 0);
        aLeft.add (aInfo);
      }
    });

    final XsltTraceTemplate aRule = new XsltTraceTemplate ("cbc:ID",
                                                           new XdmQName ("urn:mode", "M7", "m"),
                                                           null,
                                                           0.5,
                                                           "file:/a.xslt",
                                                           12,
                                                           3);
    final XsltTraceTemplate aNamed = new XsltTraceTemplate (null, null, new XdmQName ("", "named", ""), 0, null, 0, 0);

    aListener.onTemplateRuleEnter (aRule, null);
    aListener.onNamedTemplateEnter (aNamed, null);
    aListener.onNamedTemplateLeave (aNamed, null);
    aListener.onTemplateRuleLeave (aRule, null);
    // An unbalanced leave is ignored
    aListener.onTemplateRuleLeave (aRule, null);

    assertEquals (2, aEntered.size ());
    assertEquals (2, aLeft.size ());

    final SchematronTemplateInfo aRuleInfo = aEntered.get (0);
    assertNull (aRuleInfo.getName ());
    assertEquals ("cbc:ID", aRuleInfo.getMatchPattern ());
    assertEquals ("{urn:mode}M7", aRuleInfo.getMode ());
    assertEquals ("file:/a.xslt", aRuleInfo.getSystemID ());
    assertEquals (12, aRuleInfo.getLineNumber ());

    final SchematronTemplateInfo aNamedInfo = aEntered.get (1);
    assertEquals ("named", aNamedInfo.getName ());
    assertNull (aNamedInfo.getMode ());
    // Unknown line
    assertEquals (-1, aNamedInfo.getLineNumber ());

    // Leave in reverse order
    assertEquals (aNamedInfo, aLeft.get (0));
    assertEquals (aRuleInfo, aLeft.get (1));
  }
}
