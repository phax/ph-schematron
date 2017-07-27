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
import javax.annotation.concurrent.NotThreadSafe;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.commons.annotation.PresentForCodeCoverage;
import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.lang.ServiceLoaderHelper;

/**
 * A central registry for all {@link ISVRLLocationBeautifierSPI} instances.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public final class SVRLLocationBeautifierRegistry
{
  private static final Logger s_aLogger = LoggerFactory.getLogger (SVRLLocationBeautifierRegistry.class);
  private static final ICommonsList <ISVRLLocationBeautifierSPI> s_aList = ServiceLoaderHelper.getAllSPIImplementations (ISVRLLocationBeautifierSPI.class);

  @PresentForCodeCoverage
  private static final SVRLLocationBeautifierRegistry s_aInstance = new SVRLLocationBeautifierRegistry ();

  private SVRLLocationBeautifierRegistry ()
  {}

  /**
   * Get the beautified location for the given namespace and local name.
   *
   * @param sNamespaceURI
   *        The namespace URI
   * @param sLocalName
   *        The element local name
   * @return <code>null</code> if no beautification is available
   */
  @Nullable
  public static String getBeautifiedLocation (@Nonnull final String sNamespaceURI, @Nonnull final String sLocalName)
  {
    for (final ISVRLLocationBeautifierSPI aBeautifier : s_aList)
    {
      final String sBeautified = aBeautifier.getReplacementText (sNamespaceURI, sLocalName);
      if (sBeautified != null)
        return sBeautified;
    }
    if (s_aLogger.isDebugEnabled ())
      s_aLogger.debug ("Unsupported elements for beautification: " + sNamespaceURI + " -- " + sLocalName);
    return null;
  }
}
