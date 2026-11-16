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

import javax.xml.transform.ErrorListener;
import javax.xml.transform.URIResolver;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.style.ReturnsMutableObject;
import com.helger.collection.commons.ICommonsOrderedMap;
import com.helger.schematron.ISchematronResource;
import com.helger.schematron.api.xslt.validator.ISchematronOutputValidityDeterminator;

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
   * @return The {@link URIResolver} to be used for reading the Schematron. May be
   *         <code>null</code>.
   */
  @Nullable
  URIResolver getURIResolver ();

  /**
   * @return A mutable (=writable) copy of the parameters map. Never <code>null</code>.
   */
  @NonNull
  @ReturnsMutableObject
  ICommonsOrderedMap <String, Object> parameters ();

  /**
   * Enable or disable the warning on contained elements from a different namespace. See #61. It is
   * a shortcut for <code>parameters ().put ("allow-foreign", bAllow ? "true" : "false");</code>
   *
   * @param bAllow
   *        <code>true</code> to allow foreign elements, <code>false</code> to disallow them.
   */
  default void setAllowForeignElements (final boolean bAllow)
  {
    parameters ().put ("allow-foreign", bAllow ? "true" : "false");
  }

  /**
   * Note: The method was renamed in v8 from <code>getXSLTValidator</code>.
   *
   * @return The Schematron output validity determinator to be used. Never <code>null</code>.
   */
  @NonNull
  ISchematronOutputValidityDeterminator getOutputValidityDeterminator ();

  /**
   * @return <code>true</code> if the created SVRL should be validated or not. Defaults to
   *         <code>true</code>.
   * @since 6.3.3
   */
  boolean isValidateSVRL ();

}
