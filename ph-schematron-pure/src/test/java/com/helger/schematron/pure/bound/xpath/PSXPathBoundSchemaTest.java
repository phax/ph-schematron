/*
 * Copyright (C) 2014-2025 Philip Helger (www.helger.com)
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
package com.helger.schematron.pure.bound.xpath;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TestRule;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.commons.error.level.EErrorLevel;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.junit.DebugModeTestRule;
import com.helger.commons.mock.CommonsTestHelper;
import com.helger.schematron.SchematronException;
import com.helger.schematron.SchematronHelper;
import com.helger.schematron.pure.binding.xpath.PSXPathQueryBinding;
import com.helger.schematron.pure.bound.IPSBoundSchema;
import com.helger.schematron.pure.errorhandler.CollectingPSErrorHandler;
import com.helger.schematron.pure.errorhandler.LoggingPSErrorHandler;
import com.helger.schematron.pure.exchange.PSReader;
import com.helger.schematron.pure.model.PSSchema;
import com.helger.schematron.pure.preprocess.PSPreprocessor;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.schematron.testfiles.SchematronTestHelper;
import com.helger.xml.microdom.IMicroDocument;
import com.helger.xml.serialize.read.DOMReader;

/**
 * Test class for class {@link PSPreprocessor}.
 *
 * @author Philip Helger
 */
public final class PSXPathBoundSchemaTest
{
  private static final Logger LOGGER = LoggerFactory.getLogger (PSXPathBoundSchemaTest.class);
  @Rule
  public final TestRule m_aRule = new DebugModeTestRule ();

  private static final String [] SCH = new String [] { "valid01.sch",
                                                       "valid02.sch",
                                                       "biicore/BIICORE-UBL-T01.sch",
                                                       "biirules/BIIRULES-UBL-T01.sch",
                                                       "CellarBook.sch",
                                                       "VariableTests.sch" };
  private static final String [] XML = new String [] { "valid01.xml",
                                                       "valid01.xml",
                                                       "goodOrder01.xml",
                                                       "goodOrder01.xml",
                                                       "CellarBook.xml",
                                                       "valid01.xml" };

  @Test
  public void testSchematronValidation () throws SchematronException
  {
    for (int i = 0; i < SCH.length; ++i)
    {
      final IReadableResource aSchRes = new ClassPathResource ("external/test-sch/" + SCH[i]);
      assertTrue (aSchRes.getPath (), aSchRes.exists ());
      final IReadableResource aXmlRes = new ClassPathResource ("external/test-xml/" + XML[i]);
      assertTrue (aXmlRes.getPath (), aXmlRes.exists ());

      // Resolve all includes
      final IMicroDocument aDoc = SchematronHelper.getWithResolvedSchematronIncludes (aSchRes,
                                                                                      new LoggingPSErrorHandler ());
      assertNotNull (aDoc);

      // Read to domain object
      final PSReader aReader = new PSReader (aSchRes);
      final PSSchema aSchema = aReader.readSchemaFromXML (aDoc.getDocumentElement ());
      assertNotNull (aSchema);

      // Create a compiled schema
      final IPSBoundSchema aBoundSchema = PSXPathQueryBinding.getInstance ().bind (aSchema);

      // Validate completely
      final SchematronOutputType aSVRL = aBoundSchema.validateComplete (DOMReader.readXMLDOM (aXmlRes),
                                                                        aXmlRes.getAsURL ().toExternalForm ());
      assertNotNull (aSVRL);

      if (false)
        LOGGER.info (new SVRLMarshaller ().getAsString (aSVRL));
    }
  }

  @Test
  public void testBindAllValidSchematrons () throws SchematronException
  {
    for (final IReadableResource aRes : SchematronTestHelper.getAllValidSchematronFiles ())
    {
      if (true)
        LOGGER.info ("Binding " + aRes.getPath ());

      // Parse the schema
      final PSSchema aSchema = new PSReader (aRes).readSchema ();
      assertNotNull (aSchema);
      CommonsTestHelper.testToStringImplementation (aSchema);

      final CollectingPSErrorHandler aErrHdl = new CollectingPSErrorHandler ();
      if (!aSchema.isValid (aErrHdl))
        fail (aRes.getPath () + " - " + aErrHdl.getAllErrors ());
      assertTrue (aRes.getPath () + " - " + aErrHdl.getAllErrors (), aErrHdl.isEmpty ());

      // Create a compiled schema
      final IPSBoundSchema aBoundSchema = PSXPathQueryBinding.getInstance ().bind (aSchema);
      assertNotNull (aBoundSchema);
    }
  }

  @Test
  public void testBindAllInvalidSchematrons ()
  {
    for (final IReadableResource aRes : SchematronTestHelper.getAllInvalidSchematronFiles ())
    {
      LOGGER.info (aRes.toString ());
      try
      {
        // Parse the schema
        final PSSchema aSchema = new PSReader (aRes).readSchema ();
        final CollectingPSErrorHandler aCEH = new CollectingPSErrorHandler ();
        PSXPathQueryBinding.getInstance ().bind (aSchema, null, aCEH, null, null);
        // Either an ERROR was collected or an exception was thrown
        assertTrue (aCEH.getErrorList ().getMostSevereErrorLevel ().isGE (EErrorLevel.ERROR));
      }
      catch (final SchematronException ex)
      {
        LOGGER.error ("  " + ex.getMessage ());
      }
    }
  }
}
