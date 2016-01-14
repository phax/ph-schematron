/**
 * Copyright (C) 2014-2016 Philip Helger (www.helger.com)
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
package com.helger.schematron.svrl;

import javax.annotation.concurrent.Immutable;
import javax.xml.bind.annotation.XmlSchema;

import org.oclc.purl.dsdl.svrl.SchematronOutputType;

import com.helger.commons.annotation.PresentForCodeCoverage;
import com.helger.commons.string.StringHelper;

/**
 * SVRL constants.
 *
 * @author Philip Helger
 */
@Immutable
public final class CSVRL
{
  /** Path to the SVRL XSD file within the class path */
  public static final String SVRL_XSD_PATH = "schemas/svrl.xsd";

  /** Path to the SVRL RelaxNG Compact file within the class path */
  public static final String SVRL_RNC_PATH = "schemas/svrl.rnc";

  /** The namespace of the SVRL files. */
  public static final String SVRL_NAMESPACE_URI = SchematronOutputType.class.getPackage ()
                                                                            .getAnnotation (XmlSchema.class)
                                                                            .namespace ();

  static
  {
    // Small sanity check :)
    if (StringHelper.hasNoText (SVRL_NAMESPACE_URI))
      throw new IllegalStateException ("Failed to determine SVRL namespace");
  }

  @PresentForCodeCoverage
  private static final CSVRL s_aInstance = new CSVRL ();

  private CSVRL ()
  {}
}
