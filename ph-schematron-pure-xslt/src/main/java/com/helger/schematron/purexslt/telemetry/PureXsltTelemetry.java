/*
 * Copyright (C) 2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.purexslt.telemetry;

import com.helger.schematron.ESchematronEngine;

/**
 * Telemetry constants and helpers used by {@code SchematronResourcePureXslt}.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
public final class PureXsltTelemetry
{
  /**
   * Engine ID this engine tags telemetry with - the canonical {@link ESchematronEngine#PURE_XSLT}
   * ID.
   */
  public static final String ENGINE_VALUE = ESchematronEngine.PURE_XSLT.getID ();

  private PureXsltTelemetry ()
  {}
}
