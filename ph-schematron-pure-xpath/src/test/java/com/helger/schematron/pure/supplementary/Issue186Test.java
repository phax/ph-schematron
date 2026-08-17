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
package com.helger.schematron.pure.supplementary;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.diagnostics.error.IError;
import com.helger.diagnostics.error.level.EErrorLevel;
import com.helger.io.resource.FileSystemResource;
import com.helger.schematron.errorhandler.CollectingPSErrorHandler;
import com.helger.schematron.pure.SchematronResourcePureXPath;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;

/**
 * Test for GitHub issue 186: the pure engine silently ignored all foreign (non-Schematron) elements
 * contained in a Schematron. Now a warning is emitted for each of them.
 *
 * @author Philip Helger
 */
public final class Issue186Test
{
  private static final Logger LOGGER = LoggerFactory.getLogger (Issue186Test.class);

  private static final String SCH = "src/test/resources/external/issues/github186/schematron.sch";
  private static final String XML = "src/test/resources/external/issues/github186/test.xml";

  @Test
  public void testForeignElementsAreWarnedAbout () throws Exception
  {
    final CollectingPSErrorHandler aErrorHandler = new CollectingPSErrorHandler ();
    final SchematronResourcePureXPath aSCH = SchematronResourcePureXPath.builderFromFile (SCH)
                                                                        .errorHandler (aErrorHandler)
                                                                        // Ensure the binding
                                                                        // really happens
                                                                        .useCache (false)
                                                                        .build ();

    // The foreign elements must not prevent the validation
    final SchematronOutputType aSVRL = aSCH.applySchematronValidationToSVRL (new FileSystemResource (XML));
    assertNotNull (aSVRL);
    assertEquals (0, SVRLHelper.getAllFailedAssertionsAndSuccessfulReports (aSVRL).size ());

    LOGGER.info (aErrorHandler.getErrorList ().toString ());

    // One warning for the schema level <xsl:function> and one for the rule level <xsl:variable>
    final ICommonsList <IError> aWarnings = new CommonsArrayList <> ();
    for (final IError aError : aErrorHandler.getErrorList ())
      if (aError.getErrorLevel ().isEQ (EErrorLevel.WARN))
        aWarnings.add (aError);
    assertEquals (aErrorHandler.getErrorList ().toString (), 2, aWarnings.size ());

    final String sWarning1 = aWarnings.get (0).getErrorText (null);
    assertTrue (sWarning1,
                sWarning1.contains ("The pure Schematron engine ignores the foreign element <function> from namespace 'http://www.w3.org/1999/XSL/Transform'"));
    assertEquals ("PSSchema", aWarnings.get (0).getErrorFieldName ());

    final String sWarning2 = aWarnings.get (1).getErrorText (null);
    assertTrue (sWarning2,
                sWarning2.contains ("The pure Schematron engine ignores the foreign element <variable> from namespace 'http://www.w3.org/1999/XSL/Transform'"));
    assertEquals ("PSRule", aWarnings.get (1).getErrorFieldName ());
  }
}
