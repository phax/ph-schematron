/*
 * Copyright (C) 2014-2025 Philip Helger (www.helger.com)
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

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.xml.xpath.XPathFactory;
import javax.xml.xpath.XPathFunctionResolver;
import javax.xml.xpath.XPathVariableResolver;

import com.helger.commons.annotation.MustImplementEqualsAndHashcode;
import com.helger.commons.collection.impl.ICommonsList;
import com.helger.xml.xpath.MapBasedXPathFunctionResolver;
import com.helger.xml.xpath.MapBasedXPathVariableResolver;

import net.sf.saxon.lib.ExtensionFunctionDefinition;

/**
 * XPath configuration to use.
 * <p>
 * This is a counter-measure against
 * <a href="https://github.com/phax/ph-schematron/issues/96">#96</a>: When using Saxon-HE, you have
 * stripped down XPath support (no XPath higher order functions according to the
 * <a href= "https://www.saxonica.com/html/products/feature-matrix-9-9.html">saxon feature
 * matrix</a>). In this case, you perhaps want to use a different <em>XPath implementation</em>
 * (most commonly the XPath implementation shipped with Java).
 * </p>
 *
 * @author Thomas Pasch
 * @since 5.5.0
 * @see com.helger.schematron.pure.SchematronResourcePure
 * @see com.helger.schematron.pure.bound.xpath.PSXPathBoundSchema
 * @see com.helger.schematron.pure.bound.PSBoundSchemaCacheKey
 */
@MustImplementEqualsAndHashcode
public interface IXPathConfig
{
  /**
   * @return The {@link XPathFactory} to use. May not be <code>null</code>.
   */
  @Nonnull
  XPathFactory getXPathFactory ();

  /**
   * @return The {@link XPathVariableResolver} to use. May be <code>null</code>.
   */
  @Nullable
  MapBasedXPathVariableResolver getXPathVariableResolver ();

  /**
   * @return The {@link XPathFunctionResolver} to use. May not be <code>null</code>.
   */
  @Nullable
  MapBasedXPathFunctionResolver getXPathFunctionResolver ();

  @Nullable
  ICommonsList <ExtensionFunctionDefinition> getAllEFDs ();
}
