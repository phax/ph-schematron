/**
 * Copyright (C) 2014-2017 Philip Helger (www.helger.com)
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
package com.helger.schematron.supplementary;

import static org.junit.Assert.assertNotNull;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import org.junit.Ignore;
import org.junit.Test;
import org.oclc.purl.dsdl.svrl.SchematronOutputType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;

import com.helger.commons.collection.ext.ICommonsList;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.io.resource.wrapped.GZIPReadableResource;
import com.helger.schematron.ISchematronResource;
import com.helger.schematron.pure.SchematronResourcePure;
import com.helger.schematron.svrl.SVRLFailedAssert;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.xml.transform.ResourceStreamSource;

/**
 * Test code for issue #29
 *
 * @author Philip Helger
 */
public final class Issue29Test
{
  private static final Logger s_aLogger = LoggerFactory.getLogger (Issue29Test.class);

  @Nullable
  static SchematronOutputType validateXmlUsingSchematron (@Nonnull final IReadableResource aRes)
  {
    SchematronOutputType ob = null;

    // Must use the XSLT based version, because of "key" usage
    final ISchematronResource aResSCH = new SchematronResourcePure (new ClassPathResource ("issues/github29/pbs.sch"));
    if (!aResSCH.isValidSchematron ())
      throw new IllegalArgumentException ("Invalid Schematron!");
    try
    {
      final Document aDoc = aResSCH.applySchematronValidation (new ResourceStreamSource (aRes));
      if (aDoc != null)
      {
        final SVRLMarshaller marshaller = new SVRLMarshaller ();
        marshaller.setClassLoader (SchematronOutputType.class.getClassLoader ());
        ob = marshaller.read (aDoc);
      }
    }
    catch (final Exception pE)
    {
      pE.printStackTrace ();
    }
    return ob;
  }

  @Test
  @Ignore ("Takes too long - more than 1 min")
  public void testGood () throws Exception
  {
    final SchematronOutputType aSOT = validateXmlUsingSchematron (new GZIPReadableResource (new ClassPathResource ("issues/github29/sample.xml.gz")));
    assertNotNull (aSOT);
    final ICommonsList <SVRLFailedAssert> aErrors = SVRLHelper.getAllFailedAssertions (aSOT);
    assertNotNull (aErrors);
    s_aLogger.info ("Errors found: " + aErrors);
  }
}