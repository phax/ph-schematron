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
package com.helger.schematron.svrl;

import java.util.List;

import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.CodingStyleguideUnaware;
import com.helger.annotation.style.PresentForCodeCoverage;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.io.resource.ClassPathResource;
import com.helger.xsds.xml.CXML_XSD;

import jakarta.annotation.Nonnull;

/**
 * SVRL constants.
 *
 * @author Philip Helger
 */
@Immutable
public final class CSVRL
{
  @Nonnull
  private static ClassLoader _getCL ()
  {
    return CSVRL.class.getClassLoader ();
  }

  /** Path to the SVRL XSD file within the class path */
  public static final String SVRL_XSD_PATH = "external/schemas/svrl.xsd";

  @CodingStyleguideUnaware
  public static final List <ClassPathResource> SVRL_XSDS = new CommonsArrayList <> (CXML_XSD.getXSDResource (),
                                                                                    new ClassPathResource (SVRL_XSD_PATH,
                                                                                                           _getCL ())).getAsUnmodifiable ();

  /** The namespace of the SVRL files. */
  public static final String SVRL_NAMESPACE_URI = "http://purl.oclc.org/dsdl/svrl";

  @PresentForCodeCoverage
  private static final CSVRL INSTANCE = new CSVRL ();

  private CSVRL ()
  {}
}
