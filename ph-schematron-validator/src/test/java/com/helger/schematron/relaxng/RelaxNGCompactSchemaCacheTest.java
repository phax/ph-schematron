/**
 * Copyright (C) 2014-2019 Philip Helger (www.helger.com)
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
package com.helger.schematron.relaxng;

import static org.junit.Assert.fail;

import java.io.File;
import java.io.IOException;

import javax.xml.validation.Validator;

import org.junit.Test;
import org.xml.sax.SAXException;

import com.helger.commons.io.resource.ClassPathResource;
import com.helger.xml.transform.TransformSourceFactory;

/**
 * Test class for RelaxNG
 *
 * @author Philip Helger
 */
public final class RelaxNGCompactSchemaCacheTest
{
  @Test
  public void testRNCtoRNG2006 ()
  {
    String [] args = new String [] { "-I",
                                     "rnc",
                                     "-O",
                                     "rng",
                                     new File ("src/main/resources/schemas/iso-schematron-2006.rnc").getAbsolutePath (),
                                     new File ("src/test/resources/schemas/iso-schematron-2006.rng").getAbsolutePath () };
    // Call trang
    new com.thaiopensource.relaxng.translate.Driver ().run (args);

    args = new String [] { "-I",
                           "rnc",
                           "-O",
                           "rng",
                           new File ("src/main/resources/schemas/svrl-2006.rnc").getAbsolutePath (),
                           new File ("src/test/resources/schemas/svrl-2006.rng").getAbsolutePath () };
    // Call trang
    new com.thaiopensource.relaxng.translate.Driver ().run (args);
  }

  @Test
  public void testRNCtoXSD2006 ()
  {
    String [] args = new String [] { "-I",
                                     "rnc",
                                     "-O",
                                     "rng",
                                     new File ("src/main/resources/schemas/iso-schematron-2006.rnc").getAbsolutePath (),
                                     new File ("src/test/resources/schemas/iso-schematron-2006.xsd").getAbsolutePath () };
    // Call trang
    new com.thaiopensource.relaxng.translate.Driver ().run (args);

    args = new String [] { "-I",
                           "rnc",
                           "-O",
                           "xsd",
                           new File ("src/main/resources/schemas/svrl-2006.rnc").getAbsolutePath (),
                           new File ("src/test/resources/schemas/svrl-2006.xsd").getAbsolutePath () };
    // Call trang
    new com.thaiopensource.relaxng.translate.Driver ().run (args);
  }

  @Test
  public void testRNCtoRNG2016 ()
  {
    String [] args = new String [] { "-I",
                                     "rnc",
                                     "-O",
                                     "rng",
                                     new File ("src/main/resources/schemas/iso-schematron-2016.rnc").getAbsolutePath (),
                                     new File ("src/test/resources/schemas/iso-schematron-2016.rng").getAbsolutePath () };
    // Call trang
    new com.thaiopensource.relaxng.translate.Driver ().run (args);

    args = new String [] { "-I",
                           "rnc",
                           "-O",
                           "rng",
                           new File ("src/main/resources/schemas/svrl-2016.rnc").getAbsolutePath (),
                           new File ("src/test/resources/schemas/svrl-2016.rng").getAbsolutePath () };
    // Call trang
    new com.thaiopensource.relaxng.translate.Driver ().run (args);
  }

  @Test
  public void testRNCtoXSD2016 ()
  {
    String [] args = new String [] { "-I",
                                     "rnc",
                                     "-O",
                                     "rng",
                                     new File ("src/main/resources/schemas/iso-schematron-2016.rnc").getAbsolutePath (),
                                     new File ("src/test/resources/schemas/iso-schematron-2016.xsd").getAbsolutePath () };
    // Call trang
    new com.thaiopensource.relaxng.translate.Driver ().run (args);

    args = new String [] { "-I",
                           "rnc",
                           "-O",
                           "xsd",
                           new File ("src/main/resources/schemas/svrl-2016.rnc").getAbsolutePath (),
                           new File ("src/test/resources/schemas/svrl-2016.xsd").getAbsolutePath () };
    // Call trang
    new com.thaiopensource.relaxng.translate.Driver ().run (args);
  }

  @Test
  public void testSVRL () throws IOException
  {
    // Check the document
    try
    {
      // Get a validator from the schema.
      final Validator aValidator = RelaxNGCompactSchemaCache.getInstance ()
                                                            .getValidator (new ClassPathResource ("schemas/svrl-2006.rnc"));

      aValidator.validate (TransformSourceFactory.create (new ClassPathResource ("test-svrl/test1.svrl")));
      // Success
    }
    catch (final SAXException ex)
    {
      fail (ex.getMessage ());
    }
  }
}
