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
package com.helger.schematron.svrl;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.Immutable;

import org.oclc.purl.dsdl.svrl.SchematronOutputType;
import org.w3c.dom.Node;

import com.helger.commons.annotation.PresentForCodeCoverage;
import com.helger.commons.io.resource.IReadableResource;

/**
 * This is the XML reader for Schematron SVRL documents. It reads XML DOM
 * documents and returns {@link SchematronOutputType} elements. The reading
 * itself is done with JAXB.<br>
 *
 * @author Philip Helger
 */
@Immutable
public final class SVRLReader
{
  @PresentForCodeCoverage
  private static final SVRLReader s_aInstance = new SVRLReader ();

  private SVRLReader ()
  {}

  /**
   * Convert the passed resource into a SVRL domain object
   *
   * @param aRes
   *        The resource to be converted. May not be <code>null</code>.
   * @return <code>null</code> if the passed object could not be interpreted as
   *         SVRL.
   */
  @Nullable
  public static SchematronOutputType readXML (@Nonnull final IReadableResource aRes)
  {
    return new SVRLMarshaller ().read (aRes);
  }

  /**
   * Convert the passed W3C node into a SVRL domain object
   *
   * @param aNode
   *        The node to be converted. May not be <code>null</code>.
   * @return <code>null</code> if the passed object could not be interpreted as
   *         SVRL.
   */
  @Nullable
  public static SchematronOutputType readXML (@Nonnull final Node aNode)
  {
    return new SVRLMarshaller ().read (aNode);
  }
}
