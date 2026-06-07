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

import javax.xml.transform.Source;
import javax.xml.transform.TransformerException;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

import com.helger.base.state.EValidity;
import com.helger.schematron.ISchematronValidator;
import com.helger.schematron.api.xslt.validator.ISchematronOutputValidityDeterminator;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;

/**
 * Shared contract for the builder-driven Schematron validator entry points that are backed by an
 * XSLT transformation (ISO Schematron, SchXslt 1.x / 2.x and pre-built XSLT). Adds raw SVRL DOM
 * access and the XSLT-specific configuration knobs on top of {@link ISchematronValidator}.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
public interface ISchematronXSLTBasedValidator extends ISchematronValidator
{
  /** Default value for {@link #isValidateSVRL()}. */
  boolean DEFAULT_VALIDATE_SVRL = true;

  /**
   * @return The compiled XSLT-based provider, or <code>null</code> if compilation failed (e.g.
   *         missing or invalid resource).
   */
  @Nullable
  ISchematronXSLTBasedProvider getXSLTProvider ();

  /**
   * @return The validity determinator used to interpret the SVRL output. Never <code>null</code>.
   */
  @NonNull
  ISchematronOutputValidityDeterminator getOutputValidityDeterminator ();

  /**
   * @return <code>true</code> if the produced SVRL DOM is validated against the SVRL JAXB schema
   *         while unmarshalling. Default is {@link #DEFAULT_VALIDATE_SVRL}.
   */
  boolean isValidateSVRL ();

  /**
   * Apply the Schematron validation to the given XML source and return the raw SVRL DOM.
   *
   * @param aSource
   *        The XML source to validate. May not be <code>null</code>.
   * @return The SVRL DOM document or <code>null</code> if the provider is unusable.
   * @throws TransformerException
   *         If the XSLT transformation fails.
   */
  @Nullable
  Document applyValidation (@NonNull Source aSource) throws TransformerException;

  /**
   * Apply the Schematron validation to the given DOM node and return the raw SVRL DOM.
   *
   * @param aXMLNode
   *        The XML node to validate. May not be <code>null</code>.
   * @param sBaseURI
   *        Optional base URI used as the source system ID.
   * @return The SVRL DOM document or <code>null</code> if the provider is unusable.
   * @throws TransformerException
   *         If the XSLT transformation fails.
   */
  @Nullable
  Document applyValidation (@NonNull Node aXMLNode, @Nullable String sBaseURI) throws TransformerException;

  @Override
  @Nullable
  SchematronOutputType applyToSVRL (@NonNull Node aXMLNode, @Nullable String sBaseURI) throws TransformerException;

  @Override
  @NonNull
  EValidity getValidity (@NonNull Node aXMLNode, @Nullable String sBaseURI) throws TransformerException;
}
