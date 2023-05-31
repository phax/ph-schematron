/*
 * Copyright (C) 2014-2023 Philip Helger (www.helger.com)
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
package com.helger.schematron.schxslt;

import static org.junit.Assert.assertTrue;

import org.junit.Test;

import com.helger.schematron.schxslt.xslt2.SchematronResourceSchXslt_XSLT2;

/**
 * Test class for class {@link SchematronResourceSchXslt_XSLT2}.
 *
 * @author Philip Helger
 */
public final class SchematronResourceSchXslt_XSLT2Test
{
  @Test
  public void testReadISOSchematron2006SCH ()
  {
    final SchematronResourceSchXslt_XSLT2 aSCH = SchematronResourceSchXslt_XSLT2.fromClassPath ("external/schematron/iso-schematron-2006.sch");
    assertTrue (aSCH.isValidSchematron ());
  }

  @Test
  public void testReadISOSchematron2016SCH ()
  {
    final SchematronResourceSchXslt_XSLT2 aSCH = SchematronResourceSchXslt_XSLT2.fromClassPath ("external/schematron/iso-schematron-2016.sch");
    assertTrue (aSCH.isValidSchematron ());
  }
}
