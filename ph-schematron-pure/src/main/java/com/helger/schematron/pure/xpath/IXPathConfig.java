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
package com.helger.schematron.pure.xpath;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.style.MustImplementEqualsAndHashcode;
import com.helger.collection.commons.ICommonsList;
import com.helger.collection.commons.ICommonsMap;

import net.sf.saxon.s9api.ExtensionFunction;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.XdmValue;

/**
 * XPath configuration to use.
 * <p>
 * Since v9.2.0 this is based on the Saxon s9api (XPath 2.0/3.x/4.x). The configuration carries the
 * Saxon {@link Processor} that is used for compiling and evaluating XPath expressions, the
 * {@link EXPathVersion} that the compiler should target, an optional list of Saxon
 * {@link ExtensionFunction}s to be registered on the processor, and an optional map of external
 * variables to be pre-bound before each evaluation.
 * </p>
 *
 * @author Philip Helger
 * @since 5.5.0
 * @see com.helger.schematron.pure.SchematronResourcePure
 * @see com.helger.schematron.pure.bound.xpath.PSXPathBoundSchema
 * @see com.helger.schematron.pure.bound.PSBoundSchemaCacheKey
 */
@MustImplementEqualsAndHashcode
public interface IXPathConfig
{
  /**
   * @return The Saxon {@link Processor} to use. Never <code>null</code>.
   */
  @NonNull
  Processor getProcessor ();

  /**
   * @return The XPath language version that the Saxon {@code XPathCompiler} is asked to apply.
   *         Never <code>null</code>.
   * @since 9.2.0
   * @see net.sf.saxon.s9api.XPathCompiler#setLanguageVersion(String)
   */
  @NonNull
  EXPathVersion getXPathVersion ();

  /**
   * @return The Saxon {@link ExtensionFunction} instances to be registered on the {@link Processor}
   *         when this configuration is activated. Never <code>null</code> but maybe empty.
   */
  @NonNull
  ICommonsList <ExtensionFunction> getAllExtensionFunctions ();

  /**
   * @return The external XPath variables, as a map from variable name to its sequence value. These
   *         are bound before every XPath evaluation in addition to schema-local
   *         &lt;let&gt;-variables. Never <code>null</code> but maybe empty.
   */
  @NonNull
  ICommonsMap <QName, XdmValue> getAllExternalVariables ();
}
