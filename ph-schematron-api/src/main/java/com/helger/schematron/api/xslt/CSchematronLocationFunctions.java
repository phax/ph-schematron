/*
 * Copyright (C) 2014-2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.api.xslt;

import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.PresentForCodeCoverage;

/**
 * Names of the extension functions that the XSLT processors register to compute the SVRL
 * <code>location</code> of a node in linear time. The portable expressions count the preceding
 * siblings again for every node, which makes a document with many failures on many siblings
 * quadratic. The pure XSLT engine uses them in the stylesheets it compiles in-process; the
 * stylesheets it exports stay portable. Both XSLT processors also register them on the JAXP
 * factories they create, so that other stylesheets can use them, e.g. guarded by
 * <code>use-when="function-available(...)"</code>.
 * <ul>
 * <li><code>fn-path($n)</code> - the same result as <code>fn:path($n)</code> without options</li>
 * <li><code>index-by-name($e)</code> - the same result as
 * <code>1 + count($e/preceding-sibling::*[name() = name($e)])</code></li>
 * <li><code>index-by-ns-name($e)</code> - the same result as
 * <code>1 + count($e/preceding-sibling::*[local-name() = local-name($e) and namespace-uri() = namespace-uri($e)])</code></li>
 * </ul>
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@Immutable
public final class CSchematronLocationFunctions
{
  /** The namespace URI of the functions */
  public static final String NAMESPACE_URI = "urn:com:helger:schematron:pure-xslt-functions:v1.0";
  /** The prefix the generated stylesheets bind the namespace URI to */
  public static final String DEFAULT_PREFIX = "phsch";

  /** Local name of the <code>fn:path()</code> replacement */
  public static final String LOCAL_NAME_FN_PATH = "fn-path";
  /** Local name of the position by <code>name()</code> */
  public static final String LOCAL_NAME_INDEX_BY_NAME = "index-by-name";
  /** Local name of the position by namespace URI and local name */
  public static final String LOCAL_NAME_INDEX_BY_NS_NAME = "index-by-ns-name";

  @PresentForCodeCoverage
  private static final CSchematronLocationFunctions INSTANCE = new CSchematronLocationFunctions ();

  private CSchematronLocationFunctions ()
  {}
}
