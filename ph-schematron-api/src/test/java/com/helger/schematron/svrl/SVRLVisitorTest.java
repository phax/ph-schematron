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

import org.jspecify.annotations.NonNull;
import org.junit.Test;
import org.w3c.dom.Element;

import com.helger.base.lang.clazz.ClassHelper;
import com.helger.base.state.EContinue;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.schematron.svrl.jaxb.ActiveGroup;
import com.helger.schematron.svrl.jaxb.ActivePattern;
import com.helger.schematron.svrl.jaxb.DiagnosticReference;
import com.helger.schematron.svrl.jaxb.Dir;
import com.helger.schematron.svrl.jaxb.Emph;
import com.helger.schematron.svrl.jaxb.Error;
import com.helger.schematron.svrl.jaxb.FailedAssert;
import com.helger.schematron.svrl.jaxb.FiredRule;
import com.helger.schematron.svrl.jaxb.NsPrefixInAttributeValues;
import com.helger.schematron.svrl.jaxb.PropertyReference;
import com.helger.schematron.svrl.jaxb.RichText;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.schematron.svrl.jaxb.Span;
import com.helger.schematron.svrl.jaxb.SuccessfulReport;
import com.helger.schematron.svrl.jaxb.Text;
import com.helger.xml.XMLFactory;

/**
 * Test class for class {@link SVRLVisitor}.
 *
 * @author Philip Helger
 */
public final class SVRLVisitorTest
{
  private static final class RecordingVisitor implements ISVRLVoidVisitor
  {
    private final ICommonsList <String> m_aEvents = new CommonsArrayList <> ();

    @Override
    public void onSchematronOutputStart (@NonNull final SchematronOutputType aSchematronOutput)
    {
      m_aEvents.add ("SchematronOutputStart");
    }

    @Override
    public void onSchematronOutputEnd (@NonNull final SchematronOutputType aSchematronOutput)
    {
      m_aEvents.add ("SchematronOutputEnd");
    }

    @Override
    public void onErrorStart (@NonNull final Error aError)
    {
      m_aEvents.add ("ErrorStart");
    }

    @Override
    public void onErrorEnd (@NonNull final Error aError)
    {
      m_aEvents.add ("ErrorEnd");
    }

    @Override
    public void onTextStart (@NonNull final Text aText)
    {
      m_aEvents.add ("TextStart");
    }

    @Override
    public void onTextEnd (@NonNull final Text aText)
    {
      m_aEvents.add ("TextEnd");
    }

    @Override
    public void onActivePatternStart (@NonNull final ActivePattern aActivePattern)
    {
      m_aEvents.add ("ActivePatternStart");
    }

    @Override
    public void onActivePatternEnd (@NonNull final ActivePattern aActivePattern)
    {
      m_aEvents.add ("ActivePatternEnd");
    }

    @Override
    public void onActiveGroupStart (@NonNull final ActiveGroup aActiveGroup)
    {
      m_aEvents.add ("ActiveGroupStart");
    }

    @Override
    public void onActiveGroupEnd (@NonNull final ActiveGroup aActiveGroup)
    {
      m_aEvents.add ("ActiveGroupEnd");
    }

    @Override
    public void onFailedAssertStart (@NonNull final FailedAssert aFailedAssert)
    {
      m_aEvents.add ("FailedAssertStart");
    }

    @Override
    public void onFailedAssertEnd (@NonNull final FailedAssert aFailedAssert)
    {
      m_aEvents.add ("FailedAssertEnd");
    }

    @Override
    public void onSuccessfulReportStart (@NonNull final SuccessfulReport aSuccessfulReport)
    {
      m_aEvents.add ("SuccessfulReportStart");
    }

    @Override
    public void onSuccessfulReportEnd (@NonNull final SuccessfulReport aSuccessfulReport)
    {
      m_aEvents.add ("SuccessfulReportEnd");
    }

    @Override
    public void onDiagnosticReferenceStart (@NonNull final DiagnosticReference aDiagnosticReference)
    {
      m_aEvents.add ("DiagnosticReferenceStart");
    }

    @Override
    public void onDiagnosticReferenceEnd (@NonNull final DiagnosticReference aDiagnosticReference)
    {
      m_aEvents.add ("DiagnosticReferenceEnd");
    }

    @Override
    public void onPropertyReferenceStart (@NonNull final PropertyReference aPropertyReference)
    {
      m_aEvents.add ("PropertyReferenceStart");
    }

    @Override
    public void onPropertyReferenceEnd (@NonNull final PropertyReference aPropertyReference)
    {
      m_aEvents.add ("PropertyReferenceEnd");
    }

    @Override
    public void onAnyElement (@NonNull final SchematronOutputType aParent, @NonNull final Object aAnyElement)
    {
      m_aEvents.add ("AnyElement@" + ClassHelper.getClassLocalName (aParent));
    }

    @Override
    public void onNsPrefixInAttributeValues (@NonNull final SchematronOutputType aParent,
                                             @NonNull final NsPrefixInAttributeValues aNsPrefixInAttributeValues)
    {
      m_aEvents.add ("NsPrefixInAttributeValues@" + ClassHelper.getClassLocalName (aParent));
    }

    @Override
    public void onFiredRule (@NonNull final SchematronOutputType aParent, @NonNull final FiredRule aFiredRule)
    {
      m_aEvents.add ("FiredRule@" + ClassHelper.getClassLocalName (aParent));
    }

    @Override
    public void onDir (@NonNull final RichText aParent, @NonNull final Dir aDir)
    {
      m_aEvents.add ("Dir@" + ClassHelper.getClassLocalName (aParent));
    }

    @Override
    public void onEmph (@NonNull final RichText aParent, @NonNull final Emph aEmph)
    {
      m_aEvents.add ("Emph@" + ClassHelper.getClassLocalName (aParent));
    }

    @Override
    public void onSpan (@NonNull final RichText aParent, @NonNull final Span aSpan)
    {
      m_aEvents.add ("Span@" + ClassHelper.getClassLocalName (aParent));
    }

    @Override
    public void onTextContent (@NonNull final RichText aParent, @NonNull final String sText)
    {
      m_aEvents.add ("TextContent@" + ClassHelper.getClassLocalName (aParent));
    }

    @Override
    public void onForeignElement (@NonNull final RichText aParent, @NonNull final Element aForeignElement)
    {
      m_aEvents.add ("ForeignElement@" + ClassHelper.getClassLocalName (aParent));
    }

  }

  @NonNull
  private static Text _createText (@NonNull final Object... aContent)
  {
    final Text ret = new Text ();
    for (final Object aItem : aContent)
      ret.getContent ().add (aItem);
    return ret;
  }

  @NonNull
  private static SchematronOutputType _createSVRL ()
  {
    final SchematronOutputType ret = new SchematronOutputType ();
    ret.setTitle ("T");
    ret.setAny (XMLFactory.newDocument ().createElementNS ("urn:foo", "foo:metadata"));

    final Emph aEmph = new Emph ();
    aEmph.setContent ("text");
    ret.getText ().add (_createText ("Schema ", aEmph));

    final NsPrefixInAttributeValues aNsPrefix = new NsPrefixInAttributeValues ();
    aNsPrefix.setPrefix ("x");
    aNsPrefix.setUri ("urn:x");
    ret.getNsPrefixInAttributeValues ().add (aNsPrefix);

    final ActivePattern aActivePattern = new ActivePattern ();
    aActivePattern.setId ("pat1");
    ret.getActivePatternOrActiveGroupAndFiredRule ().add (aActivePattern);

    final FiredRule aFiredRule = new FiredRule ();
    aFiredRule.setContext ("/root");
    ret.getActivePatternOrActiveGroupAndFiredRule ().add (aFiredRule);

    final FailedAssert aFailedAssert = new FailedAssert ();
    aFailedAssert.setTest ("false()");
    aFailedAssert.setLocation ("/root");
    final DiagnosticReference aDiagnosticReference = new DiagnosticReference ();
    aDiagnosticReference.setDiagnostic ("d1");
    aDiagnosticReference.setText (_createText ("Diagnostic"));
    aFailedAssert.getDiagnosticReference ().add (aDiagnosticReference);
    final PropertyReference aPropertyReference = new PropertyReference ();
    aPropertyReference.setProperty ("p1");
    aPropertyReference.setText (_createText ("Property"));
    aFailedAssert.getPropertyReference ().add (aPropertyReference);
    final Dir aDir = new Dir ();
    aDir.setContent ("d");
    final Span aSpan = new Span ();
    aSpan.setClazz ("c");
    aSpan.setContent ("s");
    final Element aForeignElement = XMLFactory.newDocument ().createElementNS ("urn:foo", "foo:ext");
    aFailedAssert.setText (_createText ("Failed ", aDir, aSpan, aForeignElement));
    ret.getActivePatternOrActiveGroupAndFiredRule ().add (aFailedAssert);

    final SuccessfulReport aSuccessfulReport = new SuccessfulReport ();
    aSuccessfulReport.setTest ("true()");
    aSuccessfulReport.setLocation ("/root");
    aSuccessfulReport.setText (_createText ("Report"));
    ret.getActivePatternOrActiveGroupAndFiredRule ().add (aSuccessfulReport);

    final ActiveGroup aActiveGroup = new ActiveGroup ();
    aActiveGroup.setId ("grp1");
    final Error aError = new Error ();
    aError.setLocation ("/root");
    aError.getContent ().add ("Error");
    aActiveGroup.getError ().add (aError);
    ret.getActivePatternOrActiveGroupAndFiredRule ().add (aActiveGroup);
    return ret;
  }

  @Test
  public void testAllElements ()
  {
    final RecordingVisitor aVisitor = new RecordingVisitor ();
    SVRLVisitor.visit (_createSVRL (), aVisitor);
    assertEquals (new CommonsArrayList <> ("SchematronOutputStart",
                                           "AnyElement@SchematronOutputType",
                                           "TextStart",
                                           "TextContent@Text",
                                           "Emph@Text",
                                           "TextEnd",
                                           "NsPrefixInAttributeValues@SchematronOutputType",
                                           "ActivePatternStart",
                                           "ActivePatternEnd",
                                           "FiredRule@SchematronOutputType",
                                           "FailedAssertStart",
                                           "DiagnosticReferenceStart",
                                           "TextStart",
                                           "TextContent@Text",
                                           "TextEnd",
                                           "DiagnosticReferenceEnd",
                                           "PropertyReferenceStart",
                                           "TextStart",
                                           "TextContent@Text",
                                           "TextEnd",
                                           "PropertyReferenceEnd",
                                           "TextStart",
                                           "TextContent@Text",
                                           "Dir@Text",
                                           "Span@Text",
                                           "ForeignElement@Text",
                                           "TextEnd",
                                           "FailedAssertEnd",
                                           "SuccessfulReportStart",
                                           "TextStart",
                                           "TextContent@Text",
                                           "TextEnd",
                                           "SuccessfulReportEnd",
                                           "ActiveGroupStart",
                                           "ErrorStart",
                                           "TextContent@Error",
                                           "ErrorEnd",
                                           "ActiveGroupEnd",
                                           "SchematronOutputEnd"), aVisitor.m_aEvents);
  }

  @Test
  public void testBreak ()
  {
    final ICommonsList <String> aEvents = new CommonsArrayList <> ();
    final EContinue eResult = SVRLVisitor.visit (_createSVRL (), new ISVRLVisitor ()
    {
      @Override
      public EContinue onFiredRule (@NonNull final SchematronOutputType aParent, @NonNull final FiredRule aFiredRule)
      {
        aEvents.add ("FiredRule");
        return EContinue.CONTINUE;
      }

      @Override
      public EContinue onFailedAssertStart (@NonNull final FailedAssert aFailedAssert)
      {
        aEvents.add ("FailedAssertStart");
        return EContinue.BREAK;
      }

      @Override
      public EContinue onFailedAssertEnd (@NonNull final FailedAssert aFailedAssert)
      {
        aEvents.add ("FailedAssertEnd");
        return EContinue.CONTINUE;
      }

      @Override
      public EContinue onSchematronOutputEnd (@NonNull final SchematronOutputType aSchematronOutput)
      {
        aEvents.add ("SchematronOutputEnd");
        return EContinue.CONTINUE;
      }
    });
    assertEquals (EContinue.BREAK, eResult);
    // No callback after the break
    assertEquals (new CommonsArrayList <> ("FiredRule", "FailedAssertStart"), aEvents);
  }
}
