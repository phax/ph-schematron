/**
 * Copyright (C) 2014 Philip Helger (www.helger.com)
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
package com.helger.schematron.pure.binding.xpath;

import javax.annotation.concurrent.Immutable;

import com.helger.commons.annotations.PresentForCodeCoverage;

/**
 * Constants for handling XPath expressions
 *
 * @author Philip Helger
 */
@Immutable
public final class CXPath
{
  /** The namespace for XPath functions usually bound to the 'fn' prefix */
  public static final String NAMESPACE_XPATH_FUNCTIONS = "http://www.w3.org/2005/xpath-functions";

  @PresentForCodeCoverage
  @SuppressWarnings ("unused")
  private static final CXPath s_aInstance = new CXPath ();

  private CXPath ()
  {}
}
