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
package com.helger.schematron;

import javax.annotation.concurrent.Immutable;

import com.helger.commons.annotation.PresentForCodeCoverage;

/**
 * Schematron XML constants.
 *
 * @author Philip Helger
 */
@Immutable
public final class CSchematronXML
{
  public static final String ATTR_ABSTRACT = "abstract";
  public static final String ATTR_CLASS = "class";
  public static final String ATTR_CONTEXT = "context";
  public static final String ATTR_DEFAULT_PHASE = "defaultPhase";
  public static final String ATTR_DIAGNOSTICS = "diagnostics";
  public static final String ATTR_FLAG = "flag";
  public static final String ATTR_FPI = "fpi";
  public static final String ATTR_HREF = "href";
  public static final String ATTR_ICON = "icon";
  public static final String ATTR_ID = "id";
  public static final String ATTR_IS_A = "is-a";
  public static final String ATTR_NAME = "name";
  public static final String ATTR_PATH = "path";
  public static final String ATTR_PATTERN = "pattern";
  public static final String ATTR_PREFIX = "prefix";
  public static final String ATTR_QUERY_BINDING = "queryBinding";
  public static final String ATTR_ROLE = "role";
  public static final String ATTR_RULE = "rule";
  public static final String ATTR_SCHEMA_VERSION = "schemaVersion";
  public static final String ATTR_SEE = "see";
  public static final String ATTR_SELECT = "select";
  public static final String ATTR_SUBJECT = "subject";
  public static final String ATTR_TEST = "test";
  public static final String ATTR_URI = "uri";
  public static final String ATTR_VALUE = "value";
  public static final String ATTR_XML_LANG = "lang";
  public static final String ATTR_XML_SPACE = "space";
  public static final String ELEMENT_ACTIVE = "active";
  public static final String ELEMENT_ASSERT = "assert";
  public static final String ELEMENT_DIAGNOSTIC = "diagnostic";
  public static final String ELEMENT_DIAGNOSTICS = "diagnostics";
  public static final String ELEMENT_DIR = "dir";
  public static final String ELEMENT_EMPH = "emph";
  public static final String ELEMENT_EXTENDS = "extends";
  public static final String ELEMENT_INCLUDE = "include";
  public static final String ELEMENT_LET = "let";
  public static final String ELEMENT_NAME = "name";
  public static final String ELEMENT_NS = "ns";
  public static final String ELEMENT_P = "p";
  public static final String ELEMENT_PARAM = "param";
  public static final String ELEMENT_PATTERN = "pattern";
  public static final String ELEMENT_PHASE = "phase";
  public static final String ELEMENT_REPORT = "report";
  public static final String ELEMENT_RULE = "rule";
  public static final String ELEMENT_SCHEMA = "schema";
  public static final String ELEMENT_SPAN = "span";
  public static final String ELEMENT_TITLE = "title";
  public static final String ELEMENT_VALUE_OF = "value-of";

  @PresentForCodeCoverage
  private static final CSchematronXML s_aInstance = new CSchematronXML ();

  private CSchematronXML ()
  {}
}
