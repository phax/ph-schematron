/*
 * Copyright (C) 2014-2021 Philip Helger (www.helger.com)
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
package com.helger.schematron.validator;

import static org.junit.Assert.assertTrue;

import java.util.Locale;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.commons.io.resource.IReadableResource;
import com.helger.schematron.SchematronHelper;
import com.helger.schematron.testfiles.SchematronTestHelper;
import com.helger.xml.microdom.IMicroDocument;

/**
 * Test class for class {@link SchematronValidator}.
 *
 * @author Philip Helger
 */
public final class SchematronValidatorTest
{
  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronValidatorTest.class);

  @Test
  public void testSchematron ()
  {
    // Check all documents
    for (final IReadableResource aRes : SchematronTestHelper.getAllValidSchematronFiles ())
    {
      final IMicroDocument aDoc = SchematronHelper.getWithResolvedSchematronIncludes (aRes, x -> LOGGER.error (x.getAsString (Locale.US)));
      final boolean bIsValid = SchematronValidator.isValidSchematron (aDoc);
      assertTrue (aRes.getPath (), bIsValid);
    }
  }
}
