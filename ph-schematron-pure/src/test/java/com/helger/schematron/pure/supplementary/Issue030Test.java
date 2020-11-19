/**
 * Copyright (C) 2014-2020 Philip Helger (www.helger.com)
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

import static org.junit.Assert.assertFalse;

import java.util.Locale;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.schematron.pure.SchematronResourcePure;
import com.helger.schematron.pure.errorhandler.IPSErrorHandler;
import com.helger.schematron.pure.errorhandler.LoggingPSErrorHandler;
import com.helger.xml.sax.DefaultEntityResolver;

/**
 * Test code for issue #30
 *
 * @author Philip Helger
 */
public final class Issue030Test
{
  private static final Logger LOGGER = LoggerFactory.getLogger (Issue030Test.class);

  @Test
  public void testOfSchematronPH () throws Exception
  {
    final SchematronResourcePure aResPure = SchematronResourcePure.fromFile ("src/test/resources/issues/github30/ph-test.sch");
    aResPure.setEntityResolver (DefaultEntityResolver.createOnDemand (aResPure.getResource ()));
    final IPSErrorHandler aErrorHandler = aError -> LOGGER.info (LoggingPSErrorHandler.DEFAULT_PS.getErrorText (aError, Locale.US));
    aResPure.setErrorHandler (aErrorHandler);

    aResPure.validateCompletely ();
    assertFalse (aResPure.isValidSchematron ());
  }
}
