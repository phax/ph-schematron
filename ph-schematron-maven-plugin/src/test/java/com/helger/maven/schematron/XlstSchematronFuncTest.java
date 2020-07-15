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
package com.helger.maven.schematron;

import java.io.File;
import java.io.IOException;

import org.junit.Ignore;
import org.junit.Test;

import com.helger.commons.io.resource.ClassPathResource;
import com.helger.schematron.xslt.SchematronProviderXSLTFromSCH;

import net.sf.saxon.Transform;

public final class XlstSchematronFuncTest
{
  private static final String TEST_XSLT_SCHEMATRON = "testXsltSchematron";

  @Test
  @Ignore ("Does not work on the commandline, because the XSLT resources are only available in the classpath")
  public void testXsltSchematron () throws IOException
  {
    final Transform saxonTransform = new Transform ();

    final String sourcePath = new File ("src/test/resources/schematron/check-classifications.sch").getCanonicalPath ();
    final String step1Path = new ClassPathResource (SchematronProviderXSLTFromSCH.XSLT2_STEP1).getAsURL ().toExternalForm ();
    final String step2Path = new ClassPathResource (SchematronProviderXSLTFromSCH.XSLT2_STEP2).getAsURL ().toExternalForm ();
    final String step3Path = new ClassPathResource (SchematronProviderXSLTFromSCH.XSLT2_STEP3).getAsURL ().toExternalForm ();
    final String outputPath = new File ("target/test/schematron-via-xslt/").getCanonicalPath ();

    final String [] step1Commands = { "-xsl:" + step1Path, "-s:" + sourcePath, "-o:" + outputPath + "/step1.sch" };
    final String [] step2Commands = { "-xsl:" + step2Path, "-s:" + outputPath + "/step1.sch", "-o:" + outputPath + "/step2.sch" };
    final String [] step3Commands = { "-xsl:" + step3Path,
                                      "-s:" + outputPath + "/step2.sch",
                                      "-o:" + outputPath + "/check-classifications.xslt" };

    saxonTransform.doTransform (step1Commands, TEST_XSLT_SCHEMATRON);
    saxonTransform.doTransform (step2Commands, TEST_XSLT_SCHEMATRON);
    saxonTransform.doTransform (step3Commands, TEST_XSLT_SCHEMATRON);
  }
}
