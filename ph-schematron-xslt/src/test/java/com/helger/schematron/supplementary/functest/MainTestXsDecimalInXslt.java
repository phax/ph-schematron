/*
 * Copyright (C) 2014-2024 Philip Helger (www.helger.com)
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
package com.helger.schematron.supplementary.functest;

import java.io.File;

import javax.xml.transform.Templates;
import javax.xml.transform.TransformerFactory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.schematron.saxon.SchematronTransformerFactory;
import com.helger.xml.transform.StringStreamResult;
import com.helger.xml.transform.TransformSourceFactory;

public class MainTestXsDecimalInXslt
{
  private static final Logger LOGGER = LoggerFactory.getLogger (MainTestXsDecimalInXslt.class);

  public static void main (final String [] args) throws Exception
  {
    // compile result of read file
    final TransformerFactory aTF = SchematronTransformerFactory.getDefaultSaxonFirst ();
    final Templates aTemplates = aTF.newTemplates (TransformSourceFactory.create (new File ("src/test/resources/xslt/test.xslt")));
    final StringStreamResult ret = new StringStreamResult ();
    aTemplates.newTransformer ()
              .transform (TransformSourceFactory.create ("<root>" +
                                                         "<e1 />" +
                                                         "<e2>" +
                                                         "<existing-element>" +
                                                         "1.23" +
                                                         "</existing-element>" +
                                                         "</e2>" +
                                                         "<e3>" +
                                                         "<existing-element>" +
                                                         "2.78" +
                                                         "</existing-element>" +
                                                         "</e3>" +
                                                         "</root>"), ret);
    /**
     * Expected output:
     *
     * <pre>
    e1[][][]
    e2[1.23][1.23][6.23]
    e3[2.78][2.78] -- [][4.01] -- [2.78][4.01]
     * </pre>
     */

    LOGGER.info (ret.getAsString ());
  }
}
