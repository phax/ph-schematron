/**
 * Copyright (C) 2014-2018 Philip Helger (www.helger.com)
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

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;
import javax.xml.bind.annotation.XmlSchema;

import org.oclc.purl.dsdl.svrl.SchematronOutputType;

import com.helger.commons.annotation.CodingStyleguideUnaware;
import com.helger.commons.annotation.PresentForCodeCoverage;
import com.helger.commons.collection.impl.CommonsArrayList;
import com.helger.commons.exception.InitializationException;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.string.StringHelper;

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
  public static final String SVRL_XSD_PATH = "schemas/svrl.xsd";

  @CodingStyleguideUnaware
  public static final List <ClassPathResource> SVRL_XSDS = new CommonsArrayList <> (new ClassPathResource (SVRL_XSD_PATH,
                                                                                                           _getCL ())).getAsUnmodifiable ();

  /** Path to the SVRL RelaxNG Compact file within the class path */
  public static final String SVRL_RNC_PATH = "schemas/svrl.rnc";

  /** The namespace of the SVRL files. */
  public static final String SVRL_NAMESPACE_URI;

  static
  {
    final XmlSchema aXmlSchema = SchematronOutputType.class.getPackage ().getAnnotation (XmlSchema.class);
    if (aXmlSchema == null)
      throw new InitializationException ("SchematronOutputType.class is missing @XmlSchema annotation!");

    SVRL_NAMESPACE_URI = aXmlSchema.namespace ();

    // Small sanity check :)
    if (StringHelper.hasNoText (SVRL_NAMESPACE_URI))
      throw new IllegalStateException ("Failed to determine SVRL namespace");
  }

  @PresentForCodeCoverage
  private static final CSVRL s_aInstance = new CSVRL ();

  private CSVRL ()
  {}
}
