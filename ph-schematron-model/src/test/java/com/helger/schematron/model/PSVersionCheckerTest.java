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
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import org.jspecify.annotations.NonNull;
import org.junit.Test;

import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.diagnostics.error.IError;
import com.helger.schematron.ESchematronVersion;
import com.helger.schematron.errorhandler.IPSErrorHandler;

/**
 * Test class for {@link PSVersionChecker}, focused on verifying that warnings are emitted when a
 * pre-2025 schema uses 2025-only features.
 *
 * @author Philip Helger
 */
public final class PSVersionCheckerTest
{
  /**
   * Capture-everything error handler so the tests can assert exactly which warnings were emitted.
   */
  private static final class CollectingErrorHandler implements IPSErrorHandler
  {
    private final ICommonsList <IError> m_aErrors = new CommonsArrayList <> ();

    public void handleError (@NonNull final IError aError)
    {
      m_aErrors.add (aError);
    }

    @NonNull
    public ICommonsList <IError> getAllErrors ()
    {
      return m_aErrors.getClone ();
    }

    public boolean hasWarningContaining (@NonNull final String sNeedle)
    {
      for (final IError aError : m_aErrors)
      {
        final String sText = aError.getErrorText ((java.util.Locale) null);
        if (sText != null && sText.contains (sNeedle))
          return true;
      }
      return false;
    }
  }

  @NonNull
  private static PSSchema _newSchemaWithRule (@NonNull final PSRule aRule)
  {
    final PSSchema aSchema = new PSSchema ();
    final PSPattern aPattern = new PSPattern ();
    aPattern.addRule (aRule);
    aSchema.addPattern (aPattern);
    return aSchema;
  }

  @NonNull
  private static PSRule _newConcreteRule ()
  {
    final PSRule aRule = new PSRule ();
    aRule.setContext ("/");
    final PSAssertReport aAssert = PSAssertReport.assertion ();
    aAssert.setTest ("true()");
    aRule.addAssertReport (aAssert);
    return aRule;
  }

  @Test
  public void testNoEditionAndSingleFlagDoesNotWarn ()
  {
    final PSRule aRule = _newConcreteRule ();
    aRule.addFlag ("warning");

    final PSSchema aSchema = _newSchemaWithRule (aRule);

    final CollectingErrorHandler aHandler = new CollectingErrorHandler ();
    PSVersionChecker.checkSchematronVersionCompliance (aSchema, aHandler);

    assertFalse ("Single-token flag should not trigger any warning",
                 aHandler.hasWarningContaining ("multi-token 'flag'"));
  }

  @Test
  public void testPre2025MultiFlagOnRuleWarns ()
  {
    final PSRule aRule = _newConcreteRule ();
    aRule.addFlag ("warning");
    aRule.addFlag ("critical");

    final PSSchema aSchema = _newSchemaWithRule (aRule);
    aSchema.setSchematronEdition (ESchematronVersion.SCHEMATRON_2020);

    final CollectingErrorHandler aHandler = new CollectingErrorHandler ();
    PSVersionChecker.checkSchematronVersionCompliance (aSchema, aHandler);

    assertTrue ("2020 schema with multi-token rule flag should warn",
                aHandler.hasWarningContaining ("multi-token 'flag' attribute on <rule>"));
  }

  @Test
  public void testMissingEditionMultiFlagOnRuleWarns ()
  {
    final PSRule aRule = _newConcreteRule ();
    aRule.addFlag ("warning");
    aRule.addFlag ("critical");

    final PSSchema aSchema = _newSchemaWithRule (aRule);
    // no schematronEdition declared

    final CollectingErrorHandler aHandler = new CollectingErrorHandler ();
    PSVersionChecker.checkSchematronVersionCompliance (aSchema, aHandler);

    assertTrue ("Schema without schematronEdition + multi-token rule flag should warn",
                aHandler.hasWarningContaining ("multi-token 'flag' attribute on <rule>"));
  }

  @Test
  public void test2025MultiFlagOnRuleDoesNotWarn ()
  {
    final PSRule aRule = _newConcreteRule ();
    aRule.addFlag ("warning");
    aRule.addFlag ("critical");

    final PSSchema aSchema = _newSchemaWithRule (aRule);
    aSchema.setSchematronEdition (ESchematronVersion.SCHEMATRON_2025);

    final CollectingErrorHandler aHandler = new CollectingErrorHandler ();
    PSVersionChecker.checkSchematronVersionCompliance (aSchema, aHandler);

    assertFalse ("2025 schema with multi-token rule flag should not warn",
                 aHandler.hasWarningContaining ("multi-token 'flag'"));
  }

  @Test
  public void testPre2025MultiFlagOnAssertWarns ()
  {
    final PSAssertReport aAssert = PSAssertReport.assertion ();
    aAssert.setTest ("true()");
    aAssert.addFlag ("warning");
    aAssert.addFlag ("critical");
    final PSRule aRule = new PSRule ();
    aRule.setContext ("/");
    aRule.addAssertReport (aAssert);

    final PSSchema aSchema = _newSchemaWithRule (aRule);
    aSchema.setSchematronEdition (ESchematronVersion.SCHEMATRON_2016);

    final CollectingErrorHandler aHandler = new CollectingErrorHandler ();
    PSVersionChecker.checkSchematronVersionCompliance (aSchema, aHandler);

    assertTrue ("2016 schema with multi-token assert flag should warn",
                aHandler.hasWarningContaining ("multi-token 'flag' attribute on <assert>"));
  }

  @Test
  public void testPre2025MultiFlagOnReportWarns ()
  {
    final PSAssertReport aReport = PSAssertReport.report ();
    aReport.setTest ("true()");
    aReport.addFlag ("warning");
    aReport.addFlag ("critical");
    final PSRule aRule = new PSRule ();
    aRule.setContext ("/");
    aRule.addAssertReport (aReport);

    final PSSchema aSchema = _newSchemaWithRule (aRule);
    aSchema.setSchematronEdition (ESchematronVersion.SCHEMATRON_2006);

    final CollectingErrorHandler aHandler = new CollectingErrorHandler ();
    PSVersionChecker.checkSchematronVersionCompliance (aSchema, aHandler);

    assertTrue ("2006 schema with multi-token report flag should warn",
                aHandler.hasWarningContaining ("multi-token 'flag' attribute on <report>"));
  }

  @Test
  public void testSetFlagWithWhitespaceSplitsIntoTokens ()
  {
    final PSRule aRule = new PSRule ();
    aRule.setFlag ("warning critical fatal");

    assertEquals (3, aRule.getAllFlags ().size ());
    assertEquals ("warning critical fatal", aRule.getFlag ());
  }

  @Test
  public void testSetFlagNullAndEmptyClearsList ()
  {
    final PSRule aRule = new PSRule ();
    aRule.addFlag ("warning");
    assertEquals (1, aRule.getAllFlags ().size ());

    aRule.setFlag (null);
    assertEquals (0, aRule.getAllFlags ().size ());

    aRule.setFlag ("warning");
    aRule.setFlag ("   ");
    assertEquals (0, aRule.getAllFlags ().size ());
  }

  @Test
  public void testPre2025GroupWarns ()
  {
    final PSGroup aGroup = new PSGroup ();
    final PSRule aRule = _newConcreteRule ();
    aGroup.addRule (aRule);

    final PSSchema aSchema = new PSSchema ();
    aSchema.addGroup (aGroup);
    aSchema.setSchematronEdition (ESchematronVersion.SCHEMATRON_2020);

    final CollectingErrorHandler aHandler = new CollectingErrorHandler ();
    PSVersionChecker.checkSchematronVersionCompliance (aSchema, aHandler);

    assertTrue ("Pre-2025 schema using a <group> should warn",
                aHandler.hasWarningContaining ("<group> element"));
  }

  @Test
  public void testPre2025LetAsWarns ()
  {
    final PSLet aLet = PSLet.create ("n", "1");
    aLet.setAs ("xs:integer");
    final PSRule aRule = _newConcreteRule ();
    aRule.addLet (aLet);

    final PSSchema aSchema = _newSchemaWithRule (aRule);
    aSchema.setSchematronEdition (ESchematronVersion.SCHEMATRON_2020);

    final CollectingErrorHandler aHandler = new CollectingErrorHandler ();
    PSVersionChecker.checkSchematronVersionCompliance (aSchema, aHandler);

    assertTrue ("Pre-2025 schema using let/@as should warn",
                aHandler.hasWarningContaining ("'as' attribute on <let>"));
  }
}
