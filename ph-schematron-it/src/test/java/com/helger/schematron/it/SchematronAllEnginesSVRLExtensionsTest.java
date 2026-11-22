/*
 * Copyright (C) 2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.it;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import org.jspecify.annotations.NonNull;
import org.junit.Test;

import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.CommonsTreeSet;
import com.helger.collection.commons.ICommonsList;
import com.helger.collection.commons.ICommonsSortedSet;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.ISchematronResource;
import com.helger.schematron.api.xslt.processor.ISchematronXsltProcessor;
import com.helger.schematron.phoxtrot.PhoxtrotXsltProcessor;
import com.helger.schematron.pure.SchematronResourcePureXPath;
import com.helger.schematron.purexslt.SchematronResourcePureXslt;
import com.helger.schematron.saxon.SaxonXsltProcessor;
import com.helger.schematron.sch.SchematronResourceSCH;
import com.helger.schematron.schxslt.xslt2.SchematronResourceSchXslt_XSLT2;
import com.helger.schematron.schxslt2.xslt.SchematronResourceSchXslt2;
import com.helger.schematron.svrl.AbstractSVRLMessage;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;

/**
 * Verifies that every engine on every XSLT processor can read the SVRL created for a Schematron
 * that triggers the SVRL extensions of SchXslt and SchXslt2 (rule and pattern IDs,
 * <code>schematronEdition</code>, suppressed rule), and that all engines report the same failed
 * asserts and successful reports.
 *
 * @author Philip Helger
 */
public final class SchematronAllEnginesSVRLExtensionsTest
{
  private static final ISchematronXsltProcessor SAXON = new SaxonXsltProcessor ();
  private static final ISchematronXsltProcessor PHOXTROT = new PhoxtrotXsltProcessor ();
  private static final IReadableResource SCH = new ClassPathResource ("external/schxslt-svrl-extensions/schxslt-svrl-extensions.sch");
  private static final IReadableResource SCH_RICH = new ClassPathResource ("external/schxslt-svrl-extensions/schxslt-svrl-rich.sch");
  private static final IReadableResource XML = new ClassPathResource ("external/schxslt-svrl-extensions/schxslt-svrl-extensions.xml");

  private static final class Engine
  {
    final String m_sDisplayName;
    final boolean m_bProvidesRuleAndPatternID;
    final ISchematronResource m_aResource;

    Engine (@NonNull final String sDisplayName,
            final boolean bProvidesRuleAndPatternID,
            @NonNull final ISchematronResource aResource)
    {
      m_sDisplayName = sDisplayName;
      m_bProvidesRuleAndPatternID = bProvidesRuleAndPatternID;
      m_aResource = aResource;
    }
  }

  @NonNull
  private static ICommonsList <Engine> _engines (@NonNull final IReadableResource aSCH)
  {
    final ICommonsList <Engine> ret = new CommonsArrayList <> ();
    ret.add (new Engine ("pure-xpath", false, SchematronResourcePureXPath.builder (aSCH).build ()));
    ret.add (new Engine ("pure-xslt", false, SchematronResourcePureXslt.builder (aSCH).build ()));
    ret.add (new Engine ("iso-schematron (saxon)",
                         false,
                         SchematronResourceSCH.builder (aSCH).xsltProcessor (SAXON).build ()));
    ret.add (new Engine ("iso-schematron (phoxtrot)",
                         false,
                         SchematronResourceSCH.builder (aSCH).xsltProcessor (PHOXTROT).build ()));
    ret.add (new Engine ("schxslt (saxon)",
                         false,
                         SchematronResourceSchXslt_XSLT2.builder (aSCH).xsltProcessor (SAXON).build ()));
    ret.add (new Engine ("schxslt (phoxtrot)",
                         false,
                         SchematronResourceSchXslt_XSLT2.builder (aSCH).xsltProcessor (PHOXTROT).build ()));
    ret.add (new Engine ("schxslt2 (saxon)",
                         true,
                         SchematronResourceSchXslt2.builder (aSCH).xsltProcessor (SAXON).build ()));
    ret.add (new Engine ("schxslt2 (phoxtrot)",
                         true,
                         SchematronResourceSchXslt2.builder (aSCH).xsltProcessor (PHOXTROT).build ()));
    return ret;
  }

  @Test
  public void testAllEngines () throws Exception
  {
    final ICommonsSortedSet <String> aExpectedIDs = new CommonsTreeSet <> ("A1", "A2", "S1");
    for (final Engine aEngine : _engines (SCH))
    {
      final SchematronOutputType aSVRL = aEngine.m_aResource.applySchematronValidationToSVRL (XML);
      assertNotNull ("Engine " + aEngine.m_sDisplayName + " produced no SVRL", aSVRL);

      final ICommonsList <AbstractSVRLMessage> aMsgs = SVRLHelper.getAllFailedAssertionsAndSuccessfulReports (aSVRL);
      assertEquals ("Engine " + aEngine.m_sDisplayName,
                    aExpectedIDs,
                    new CommonsTreeSet <> (aMsgs.getAllMapped (AbstractSVRLMessage::getID)));
      for (final AbstractSVRLMessage aMsg : aMsgs)
      {
        assertEquals ("Engine " + aEngine.m_sDisplayName,
                      aEngine.m_bProvidesRuleAndPatternID ? "R1" : null,
                      aMsg.getRuleID ());
        assertEquals ("Engine " + aEngine.m_sDisplayName,
                      aEngine.m_bProvidesRuleAndPatternID ? "P1" : null,
                      aMsg.getPatternID ());
      }
    }
  }

  @Test
  public void testAllEnginesRichAttributes () throws Exception
  {
    final ICommonsSortedSet <String> aExpectedIDs = new CommonsTreeSet <> ("A1", "S1");
    for (final Engine aEngine : _engines (SCH_RICH))
    {
      final SchematronOutputType aSVRL = aEngine.m_aResource.applySchematronValidationToSVRL (XML);
      assertNotNull ("Engine " + aEngine.m_sDisplayName + " produced no SVRL", aSVRL);

      final ICommonsList <AbstractSVRLMessage> aMsgs = SVRLHelper.getAllFailedAssertionsAndSuccessfulReports (aSVRL);
      assertEquals ("Engine " + aEngine.m_sDisplayName,
                    aExpectedIDs,
                    new CommonsTreeSet <> (aMsgs.getAllMapped (AbstractSVRLMessage::getID)));
    }
  }
}
