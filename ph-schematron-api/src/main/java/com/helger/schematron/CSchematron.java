/*
 * Copyright (C) 2014-2022 Philip Helger (www.helger.com)
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
package com.helger.schematron;

import javax.annotation.concurrent.Immutable;

import com.helger.commons.annotation.PresentForCodeCoverage;

/**
 * Constants for handling Schematron documents
 *
 * @author Philip Helger
 */
@Immutable
public final class CSchematron
{
  /** The namespace URL for Schematron documents */
  public static final String NAMESPACE_SCHEMATRON = "http://purl.oclc.org/dsdl/schematron";

  /**
   * The namespace URL for an old version of Schematron documents. Don't use it
   * explicitly
   */
  public static final String DEPRECATED_NAMESPACE_SCHEMATRON = "http://www.ascc.net/xml/schematron";

  /**
   * By default deprecated namespaces are not supported.
   */
  public static final boolean DEFAULT_ALLOW_DEPRECATED_NAMESPACES = false;

  /** The namespace URL for XSLT transformation */
  public static final String NAMESPACE_URI_XSL = "http://www.w3.org/1999/XSL/Transform";

  /** Special phase name denoting that all patterns are active */
  public static final String PHASE_ALL = "#ALL";

  /**
   * Special phase name denoting that the name given in the defaultPhase
   * attribute on the schema element should be used
   */
  public static final String PHASE_DEFAULT = "#DEFAULT";

  @PresentForCodeCoverage
  private static final CSchematron INSTANCE = new CSchematron ();

  private CSchematron ()
  {}
}
