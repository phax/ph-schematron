/*
 * Copyright (C) 2015-2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.model;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import java.nio.charset.StandardCharsets;

import org.jspecify.annotations.NonNull;
import org.junit.Test;

import com.helger.base.lang.clazz.ClassHelper;
import com.helger.base.state.EContinue;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.io.resource.inmemory.ReadableResourceByteArray;
import com.helger.schematron.exchange.PSReader;
import com.helger.xml.microdom.IMicroElement;

/**
 * Test class for class {@link PSVisitor}.
 *
 * @author Philip Helger
 */
public final class PSVisitorTest
{
  private static final String SCHEMA = "<?xml version='1.0' encoding='UTF-8'?>\n" +
                                       "<sch:schema xmlns:sch='http://purl.oclc.org/dsdl/schematron'\n" +
                                       "            xmlns:foo='urn:foo'\n" +
                                       "            schematronEdition='2025'>\n" +
                                       "  <sch:title>Title</sch:title>\n" +
                                       "  <sch:ns prefix='x' uri='urn:x'/>\n" +
                                       "  <sch:p>Intro <sch:dir value='ltr'>dir</sch:dir></sch:p>\n" +
                                       "  <sch:let name='g' value='1'/>\n" +
                                       "  <sch:phase id='ph1'>\n" +
                                       "    <sch:let name='l' value='2'/>\n" +
                                       "    <sch:active pattern='pat1'>Active</sch:active>\n" +
                                       "  </sch:phase>\n" +
                                       "  <sch:rules>\n" +
                                       "    <sch:rule abstract='true' id='abs2'>\n" +
                                       "      <sch:assert test='true()'>Rules</sch:assert>\n" +
                                       "    </sch:rule>\n" +
                                       "  </sch:rules>\n" +
                                       "  <sch:pattern id='pat1'>\n" +
                                       "    <foo:ext/>\n" +
                                       "    <sch:title>Pattern</sch:title>\n" +
                                       "    <sch:let name='p' value='3'/>\n" +
                                       "    <sch:rule abstract='true' id='abs'>\n" +
                                       "      <sch:report test='false()'>Report</sch:report>\n" +
                                       "    </sch:rule>\n" +
                                       "    <sch:rule context='/root'>\n" +
                                       "      <sch:let name='r' value='4'/>\n" +
                                       "      <sch:extends rule='abs'/>\n" +
                                       "      <sch:assert test='true()' diagnostics='d1' properties='pr1'>" +
                                       "Text <sch:name/> <sch:value-of select='.'/>" +
                                       "<sch:emph>e</sch:emph><sch:span class='c'>s</sch:span><foo:ext/>" +
                                       "</sch:assert>\n" +
                                       "    </sch:rule>\n" +
                                       "  </sch:pattern>\n" +
                                       "  <sch:group>\n" +
                                       "    <sch:rule context='/root'>\n" +
                                       "      <sch:assert test='true()'>Group</sch:assert>\n" +
                                       "    </sch:rule>\n" +
                                       "  </sch:group>\n" +
                                       "  <sch:diagnostics>\n" +
                                       "    <sch:diagnostic id='d1'>Diagnostic</sch:diagnostic>\n" +
                                       "  </sch:diagnostics>\n" +
                                       "  <sch:properties>\n" +
                                       "    <sch:property id='pr1'>Property</sch:property>\n" +
                                       "  </sch:properties>\n" +
                                       "</sch:schema>";

  private static final class RecordingVisitor implements IPSVoidVisitor
  {
    private final ICommonsList <String> m_aEvents = new CommonsArrayList <> ();

    @Override
    public void onSchemaStart (@NonNull final PSSchema aSchema)
    {
      m_aEvents.add ("SchemaStart");
    }

    @Override
    public void onSchemaEnd (@NonNull final PSSchema aSchema)
    {
      m_aEvents.add ("SchemaEnd");
    }

    @Override
    public void onInclude (@NonNull final IPSElement aParent, @NonNull final PSInclude aInclude)
    {
      m_aEvents.add ("Include@" + ClassHelper.getClassLocalName (aParent));
    }

    @Override
    public void onExtends (@NonNull final IPSElement aParent, @NonNull final PSExtends aExtends)
    {
      m_aEvents.add ("Extends@" + ClassHelper.getClassLocalName (aParent));
    }

    @Override
    public void onNs (@NonNull final IPSElement aParent, @NonNull final PSNS aNs)
    {
      m_aEvents.add ("Ns@" + ClassHelper.getClassLocalName (aParent));
    }

    @Override
    public void onParam (@NonNull final IPSElement aParent, @NonNull final PSParam aParam)
    {
      m_aEvents.add ("Param@" + ClassHelper.getClassLocalName (aParent));
    }

    @Override
    public void onLet (@NonNull final IPSElement aParent, @NonNull final PSLet aLet)
    {
      m_aEvents.add ("Let@" + ClassHelper.getClassLocalName (aParent));
    }

    @Override
    public void onTitleStart (@NonNull final PSTitle aTitle)
    {
      m_aEvents.add ("TitleStart");
    }

    @Override
    public void onTitleEnd (@NonNull final PSTitle aTitle)
    {
      m_aEvents.add ("TitleEnd");
    }

    @Override
    public void onPStart (@NonNull final PSP aP)
    {
      m_aEvents.add ("PStart");
    }

    @Override
    public void onPEnd (@NonNull final PSP aP)
    {
      m_aEvents.add ("PEnd");
    }

    @Override
    public void onPhaseStart (@NonNull final PSPhase aPhase)
    {
      m_aEvents.add ("PhaseStart");
    }

    @Override
    public void onPhaseEnd (@NonNull final PSPhase aPhase)
    {
      m_aEvents.add ("PhaseEnd");
    }

    @Override
    public void onActiveStart (@NonNull final PSActive aActive)
    {
      m_aEvents.add ("ActiveStart");
    }

    @Override
    public void onActiveEnd (@NonNull final PSActive aActive)
    {
      m_aEvents.add ("ActiveEnd");
    }

    @Override
    public void onRulesStart (@NonNull final PSRules aRules)
    {
      m_aEvents.add ("RulesStart");
    }

    @Override
    public void onRulesEnd (@NonNull final PSRules aRules)
    {
      m_aEvents.add ("RulesEnd");
    }

    @Override
    public void onPatternStart (@NonNull final PSPattern aPattern)
    {
      m_aEvents.add ("PatternStart");
    }

    @Override
    public void onPatternEnd (@NonNull final PSPattern aPattern)
    {
      m_aEvents.add ("PatternEnd");
    }

    @Override
    public void onGroupStart (@NonNull final PSGroup aGroup)
    {
      m_aEvents.add ("GroupStart");
    }

    @Override
    public void onGroupEnd (@NonNull final PSGroup aGroup)
    {
      m_aEvents.add ("GroupEnd");
    }

    @Override
    public void onRuleStart (@NonNull final PSRule aRule)
    {
      m_aEvents.add ("RuleStart");
    }

    @Override
    public void onRuleEnd (@NonNull final PSRule aRule)
    {
      m_aEvents.add ("RuleEnd");
    }

    @Override
    public void onAssertReportStart (@NonNull final PSAssertReport aAssertReport)
    {
      m_aEvents.add ("AssertReportStart");
    }

    @Override
    public void onAssertReportEnd (@NonNull final PSAssertReport aAssertReport)
    {
      m_aEvents.add ("AssertReportEnd");
    }

    @Override
    public void onDiagnosticsStart (@NonNull final PSDiagnostics aDiagnostics)
    {
      m_aEvents.add ("DiagnosticsStart");
    }

    @Override
    public void onDiagnosticsEnd (@NonNull final PSDiagnostics aDiagnostics)
    {
      m_aEvents.add ("DiagnosticsEnd");
    }

    @Override
    public void onDiagnosticStart (@NonNull final PSDiagnostic aDiagnostic)
    {
      m_aEvents.add ("DiagnosticStart");
    }

    @Override
    public void onDiagnosticEnd (@NonNull final PSDiagnostic aDiagnostic)
    {
      m_aEvents.add ("DiagnosticEnd");
    }

    @Override
    public void onPropertiesStart (@NonNull final PSProperties aProperties)
    {
      m_aEvents.add ("PropertiesStart");
    }

    @Override
    public void onPropertiesEnd (@NonNull final PSProperties aProperties)
    {
      m_aEvents.add ("PropertiesEnd");
    }

    @Override
    public void onPropertyStart (@NonNull final PSProperty aProperty)
    {
      m_aEvents.add ("PropertyStart");
    }

    @Override
    public void onPropertyEnd (@NonNull final PSProperty aProperty)
    {
      m_aEvents.add ("PropertyEnd");
    }

    @Override
    public void onDirStart (@NonNull final PSDir aDir)
    {
      m_aEvents.add ("DirStart");
    }

    @Override
    public void onDirEnd (@NonNull final PSDir aDir)
    {
      m_aEvents.add ("DirEnd");
    }

    @Override
    public void onEmphStart (@NonNull final PSEmph aEmph)
    {
      m_aEvents.add ("EmphStart");
    }

    @Override
    public void onEmphEnd (@NonNull final PSEmph aEmph)
    {
      m_aEvents.add ("EmphEnd");
    }

    @Override
    public void onSpanStart (@NonNull final PSSpan aSpan)
    {
      m_aEvents.add ("SpanStart");
    }

    @Override
    public void onSpanEnd (@NonNull final PSSpan aSpan)
    {
      m_aEvents.add ("SpanEnd");
    }

    @Override
    public void onName (@NonNull final IPSElement aParent, @NonNull final PSName aName)
    {
      m_aEvents.add ("Name@" + ClassHelper.getClassLocalName (aParent));
    }

    @Override
    public void onValueOf (@NonNull final IPSElement aParent, @NonNull final PSValueOf aValueOf)
    {
      m_aEvents.add ("ValueOf@" + ClassHelper.getClassLocalName (aParent));
    }

    @Override
    public void onTextContent (@NonNull final IPSElement aParent, @NonNull final String sText)
    {
      m_aEvents.add ("TextContent@" + ClassHelper.getClassLocalName (aParent));
    }

    @Override
    public void onForeignElement (@NonNull final IPSElement aParent, @NonNull final IMicroElement aForeignElement)
    {
      m_aEvents.add ("ForeignElement@" + ClassHelper.getClassLocalName (aParent));
    }

  }

  @NonNull
  private static PSSchema _readSchema () throws Exception
  {
    final PSReader aReader = new PSReader (new ReadableResourceByteArray (SCHEMA.getBytes (StandardCharsets.UTF_8)));
    final PSSchema aSchema = aReader.readSchema ();
    assertNotNull (aSchema);
    return aSchema;
  }

  @Test
  public void testAllElements () throws Exception
  {
    final RecordingVisitor aVisitor = new RecordingVisitor ();
    PSVisitor.visit (_readSchema (), aVisitor);
    assertEquals (new CommonsArrayList <> ("SchemaStart",
                                           "TitleStart",
                                           "TextContent@PSTitle",
                                           "TitleEnd",
                                           "Ns@PSSchema",
                                           "PStart",
                                           "TextContent@PSP",
                                           "DirStart",
                                           "TextContent@PSDir",
                                           "DirEnd",
                                           "PEnd",
                                           "Let@PSSchema",
                                           "PhaseStart",
                                           "Let@PSPhase",
                                           "ActiveStart",
                                           "TextContent@PSActive",
                                           "ActiveEnd",
                                           "PhaseEnd",
                                           "RulesStart",
                                           "RuleStart",
                                           "AssertReportStart",
                                           "TextContent@PSAssertReport",
                                           "AssertReportEnd",
                                           "RuleEnd",
                                           "RulesEnd",
                                           "PatternStart",
                                           "ForeignElement@PSPattern",
                                           "TitleStart",
                                           "TextContent@PSTitle",
                                           "TitleEnd",
                                           "Let@PSPattern",
                                           "RuleStart",
                                           "AssertReportStart",
                                           "TextContent@PSAssertReport",
                                           "AssertReportEnd",
                                           "RuleEnd",
                                           "RuleStart",
                                           "Let@PSRule",
                                           "Extends@PSRule",
                                           "AssertReportStart",
                                           "TextContent@PSAssertReport",
                                           "Name@PSAssertReport",
                                           "TextContent@PSAssertReport",
                                           "ValueOf@PSAssertReport",
                                           "EmphStart",
                                           "TextContent@PSEmph",
                                           "EmphEnd",
                                           "SpanStart",
                                           "TextContent@PSSpan",
                                           "SpanEnd",
                                           "ForeignElement@PSAssertReport",
                                           "AssertReportEnd",
                                           "RuleEnd",
                                           "PatternEnd",
                                           "GroupStart",
                                           "RuleStart",
                                           "AssertReportStart",
                                           "TextContent@PSAssertReport",
                                           "AssertReportEnd",
                                           "RuleEnd",
                                           "GroupEnd",
                                           "DiagnosticsStart",
                                           "DiagnosticStart",
                                           "TextContent@PSDiagnostic",
                                           "DiagnosticEnd",
                                           "DiagnosticsEnd",
                                           "PropertiesStart",
                                           "PropertyStart",
                                           "TextContent@PSProperty",
                                           "PropertyEnd",
                                           "PropertiesEnd",
                                           "SchemaEnd"), aVisitor.m_aEvents);
  }

  @Test
  public void testBreak () throws Exception
  {
    final ICommonsList <String> aEvents = new CommonsArrayList <> ();
    final EContinue eResult = PSVisitor.visit (_readSchema (), new IPSVisitor ()
    {
      @Override
      public EContinue onRuleStart (@NonNull final PSRule aRule)
      {
        aEvents.add ("RuleStart");
        return EContinue.BREAK;
      }

      @Override
      public EContinue onRuleEnd (@NonNull final PSRule aRule)
      {
        aEvents.add ("RuleEnd");
        return EContinue.CONTINUE;
      }

      @Override
      public EContinue onSchemaEnd (@NonNull final PSSchema aSchema)
      {
        aEvents.add ("SchemaEnd");
        return EContinue.CONTINUE;
      }
    });
    assertEquals (EContinue.BREAK, eResult);
    // Only the first rule was reported and no end callback was invoked
    assertEquals (new CommonsArrayList <> ("RuleStart"), aEvents);
  }
}
