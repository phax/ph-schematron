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

import java.util.Map;

import javax.xml.transform.ErrorListener;
import javax.xml.transform.URIResolver;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.Nonempty;
import com.helger.schematron.ISchematronValidatorBuilder;
import com.helger.schematron.api.telemetry.ISchematronTemplateTelemetry;

/**
 * Shared contract for the fluent builders of the XSLT-engine validators (ISO Schematron, pre-built
 * XSLT, SchXslt 1.x and 2.x). Hoists the configuration knobs that all four XSLT-engine builders
 * expose with identical signatures.
 * <p>
 * Concrete implementations narrow the return type of every setter to their own {@code Builder} via
 * covariant return types so that chaining stays typed.
 *
 * @author Philip Helger
 * @since 10.0.0
 * @param <CONFIG>
 *        The concrete config value type produced by {@link #build()}.
 * @param <CACHE>
 *        The cache type accepted by {@link #buildCached(Object)}.
 * @param <V>
 *        The concrete {@link ISchematronXSLTBasedValidator} produced by the <code>build*</code>
 *        shortcuts.
 */
public interface ISchematronXSLTBasedValidatorBuilder <CONFIG, CACHE, V extends ISchematronXSLTBasedValidator> extends
                                                      ISchematronValidatorBuilder <CONFIG, CACHE, V>
{
  /**
   * Set the XSLT {@link ErrorListener} used during compilation and validation.
   *
   * @param a
   *        The error listener, or <code>null</code> to use the engine default.
   * @return this for chaining
   */
  @NonNull
  ISchematronXSLTBasedValidatorBuilder <CONFIG, CACHE, V> errorListener (@Nullable ErrorListener a);

  /**
   * Set the XSLT {@link URIResolver} used to resolve <code>xsl:include</code> /
   * <code>xsl:import</code>.
   *
   * @param a
   *        The URI resolver, or <code>null</code> to use the engine default.
   * @return this for chaining
   */
  @NonNull
  ISchematronXSLTBasedValidatorBuilder <CONFIG, CACHE, V> uriResolver (@Nullable URIResolver a);

  /**
   * Set a single XSLT stylesheet parameter.
   *
   * @param sName
   *        The parameter name. May neither be <code>null</code> nor empty.
   * @param aValue
   *        The parameter value, or <code>null</code> to remove the parameter.
   * @return this for chaining
   */
  @NonNull
  ISchematronXSLTBasedValidatorBuilder <CONFIG, CACHE, V> parameter (@NonNull @Nonempty String sName,
                                                                     @Nullable Object aValue);

  /**
   * Replace the set of XSLT stylesheet parameters with the supplied map.
   *
   * @param aParameters
   *        The new parameter map, or <code>null</code> to clear all parameters.
   * @return this for chaining
   */
  @NonNull
  ISchematronXSLTBasedValidatorBuilder <CONFIG, CACHE, V> parameters (@Nullable Map <String, ?> aParameters);

  /**
   * Set the {@link ISchematronTemplateTelemetry} hook invoked by the XSLT engine.
   *
   * @param a
   *        The telemetry hook, or <code>null</code> for none.
   * @return this for chaining
   */
  @NonNull
  ISchematronXSLTBasedValidatorBuilder <CONFIG, CACHE, V> telemetry (@Nullable ISchematronTemplateTelemetry a);
}
