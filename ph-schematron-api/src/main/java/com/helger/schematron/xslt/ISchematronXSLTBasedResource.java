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
package com.helger.schematron.xslt;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.xml.transform.ErrorListener;
import javax.xml.transform.URIResolver;

import org.xml.sax.EntityResolver;

import com.helger.commons.annotation.ReturnsMutableObject;
import com.helger.commons.collection.impl.ICommonsOrderedMap;
import com.helger.schematron.ISchematronResource;
import com.helger.schematron.xslt.validator.ISchematronXSLTValidator;

/**
 * Special Schematron resource for XSLT based implementations.
 *
 * @author Philip Helger
 * @since 5.0.2
 */
public interface ISchematronXSLTBasedResource extends ISchematronResource
{
  /**
   * @return The error listener to be used. May be <code>null</code>.
   */
  @Nullable
  ErrorListener getErrorListener ();

  /**
   * @param aCustomErrorListener
   *        Error listener to use.
   * @return this for chaining
   */
  @Nonnull
  ISchematronXSLTBasedResource setErrorListener (@Nullable ErrorListener aCustomErrorListener);

  /**
   * @return The {@link URIResolver} to be used for reading the Schematron. May
   *         be <code>null</code>.
   */
  @Nullable
  URIResolver getURIResolver ();

  /**
   * Set the {@link URIResolver} to be used for reading Schematron.
   *
   * @param aCustomURIResolver
   *        The {@link URIResolver} to use. May be <code>null</code>,
   * @return this for chaining
   */
  @Nonnull
  ISchematronXSLTBasedResource setURIResolver (@Nullable URIResolver aCustomURIResolver);

  /**
   * @return A mutable (=writable) copy of the parameters map. Never
   *         <code>null</code>.
   */
  @Nonnull
  @ReturnsMutableObject
  ICommonsOrderedMap <String, Object> parameters ();

  /**
   * Enable or disable the warning on contained elements from a different
   * namespace. See #61. It is a shortcut for
   * <code>parameters ().put ("allow-foreign", bAllow ? "true" : "false");</code>
   *
   * @param bAllow
   *        <code>true</code> to allow foreign elements, <code>false</code> to
   *        disallow them.
   */
  default void setAllowForeignElements (final boolean bAllow)
  {
    parameters ().put ("allow-foreign", bAllow ? "true" : "false");
  }

  /**
   * Set the XML entity resolver to be used when reading the Schematron or the
   * XML to be validated. This can only be set before the Schematron is bound.
   * If it is already bound an exception is thrown to indicate the unnecessity
   * of the call.
   *
   * @param aEntityResolver
   *        The entity resolver to set. May be <code>null</code>.
   * @return this for chaining
   */
  @Nonnull
  ISchematronXSLTBasedResource setEntityResolver (@Nullable EntityResolver aEntityResolver);

  /**
   * @return The XSLT validator to be used. Never <code>null</code>.
   */
  @Nonnull
  ISchematronXSLTValidator getXSLTValidator ();

  /**
   * Set the XSLT validator to be used.
   *
   * @param aXSLTValidator
   *        Validator instance to use. May not be <code>null</code>.
   * @return this for chaining
   */
  @Nonnull
  ISchematronXSLTBasedResource setXSLTValidator (@Nonnull final ISchematronXSLTValidator aXSLTValidator);
}
