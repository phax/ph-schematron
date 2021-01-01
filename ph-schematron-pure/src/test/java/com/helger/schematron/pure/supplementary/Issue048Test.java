/**
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
package com.helger.schematron.pure.supplementary;

import static org.junit.Assert.assertNotNull;

import java.io.File;
import java.nio.charset.StandardCharsets;

import javax.annotation.Nonnull;

import org.junit.Test;

import com.helger.commons.io.resource.FileSystemResource;
import com.helger.commons.io.resource.inmemory.ReadableResourceString;
import com.helger.schematron.SchematronDebug;
import com.helger.schematron.pure.binding.xpath.PSXPathQueryBinding;
import com.helger.schematron.pure.exchange.PSReader;
import com.helger.schematron.pure.exchange.PSWriter;
import com.helger.schematron.pure.exchange.PSWriterSettings;
import com.helger.schematron.pure.model.PSSchema;
import com.helger.schematron.pure.preprocess.PSPreprocessor;
import com.helger.schematron.sch.SchematronResourceSCH;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.xml.serialize.write.XMLWriterSettings;

public final class Issue048Test
{
  public static void validateAndProduceSVRL (@Nonnull final File aSchematron, final File aXML) throws Exception
  {
    final PSSchema aSchema = new PSReader (new FileSystemResource (aSchematron)).readSchema ();
    final PSPreprocessor aPreprocessor = new PSPreprocessor (PSXPathQueryBinding.getInstance ());
    final PSSchema aPreprocessedSchema = aPreprocessor.getAsPreprocessedSchema (aSchema);
    final String sSCH = new PSWriter (new PSWriterSettings ().setXMLWriterSettings (new XMLWriterSettings ())).getXMLString (aPreprocessedSchema);

    if (false)
      System.out.println (sSCH);

    final SchematronResourceSCH aSCH = new SchematronResourceSCH (new ReadableResourceString (sSCH, StandardCharsets.UTF_8));

    // Perform validation
    final SchematronOutputType aSVRL = aSCH.applySchematronValidationToSVRL (new FileSystemResource (aXML));
    assertNotNull (aSVRL);
    if (false)
      System.out.println (new SVRLMarshaller ().getAsString (aSVRL));
  }

  @Test
  public void testIssue () throws Exception
  {
    SchematronDebug.setSaveIntermediateXSLTFiles (true);

    validateAndProduceSVRL (new File ("src/test/resources/issues/github48/schematron.sch"),
                            new File ("src/test/resources/issues/github48/test.xml"));
  }

  @Test
  public void testIssue2 () throws Exception
  {
    SchematronDebug.setSaveIntermediateXSLTFiles (true);

    validateAndProduceSVRL (new File ("src/test/resources/issues/github48/schematron2.sch"),
                            new File ("src/test/resources/issues/github48/test.xml"));
  }
}
