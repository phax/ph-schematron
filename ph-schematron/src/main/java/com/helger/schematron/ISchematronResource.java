/**
 * Copyright (C) 2014-2015 Philip Helger (www.helger.com)
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

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.xml.transform.Source;

import org.oclc.purl.dsdl.svrl.SchematronOutputType;
import org.w3c.dom.Document;

import com.helger.commons.id.IHasID;
import com.helger.commons.io.IHasInputStream;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.state.EValidity;
import com.helger.schematron.svrl.SVRLReader;

/**
 * Base interface for a Schematron resource. The implementation can e.g. be a
 * SCH file that needs preprocessing to XSLT or an already precompiled XSLT
 * file.
 *
 * @author Philip Helger
 */
public interface ISchematronResource extends IHasID <String>
{
  /**
   * @return The non-<code>null</code> resource from which to read the
   *         Schematron rules.
   */
  @Nonnull
  IReadableResource getResource ();

  /**
   * @return <code>true</code> if this Schematron can be used to validate XML
   *         instances. If not, the Schematron is invalid and the log files must
   *         be investigated.
   */
  boolean isValidSchematron ();

  /**
   * A method to check if the passed XML DOM node matches the Schematron rules
   * or not. This is the quick check method, as it breaks upon the first failed
   * assertion or the first successful report, if the implementation supports it
   * (as e.g. the native pure Schematron version).
   *
   * @param aXMLResource
   *        The source XML to read and validate against the Schematron. May not
   *        be <code>null</code>.
   * @return {@link EValidity#VALID} if the document is valid,
   *         {@link EValidity#INVALID} if it is invalid.
   * @throws Exception
   *         in case of a sever error validating the schema
   */
  @Nonnull
  EValidity getSchematronValidity (@Nonnull final IHasInputStream aXMLResource) throws Exception;

  /**
   * A method to check if the passed XML DOM node matches the Schematron rules
   * or not. This is the quick check method, as it breaks upon the first failed
   * assertion or the first successful report, if the implementation supports it
   * (as e.g. the native pure Schematron version).
   *
   * @param aXMLSource
   *        The source XML to be validated against the Schematron. May not be
   *        <code>null</code>.
   * @return {@link EValidity#VALID} if the document is valid,
   *         {@link EValidity#INVALID} if it is invalid.
   * @throws Exception
   *         in case of a sever error validating the schema
   */
  @Nonnull
  EValidity getSchematronValidity (@Nonnull final Source aXMLSource) throws Exception;

  /**
   * Apply the Schematron validation on the passed XML resource and return an
   * SVRL XML DOM Document.
   *
   * @param aXMLResource
   *        The XML resource to validate via Schematron. May not be
   *        <code>null</code>.
   * @return <code>null</code> if the passed resource does not exist or the non-
   *         <code>null</code> SVRL document otherwise.
   * @throws Exception
   *         In case the transformation somehow goes wrong.
   * @see SVRLReader#readXML(org.w3c.dom.Node) on how to convert the document
   *      into a domain object
   */
  @Nullable
  Document applySchematronValidation (@Nonnull IHasInputStream aXMLResource) throws Exception;

  /**
   * Apply the Schematron validation on the passed XML source and return an SVRL
   * XML DOM Document.
   *
   * @param aXMLSource
   *        The XML source to validate via Schematron. May not be
   *        <code>null</code>.
   * @return The SVRL XML document containing the result. May be
   *         <code>null</code> when interpreting the Schematron failed.
   * @throws Exception
   *         In case the transformation somehow goes wrong.
   * @see SVRLReader#readXML(org.w3c.dom.Node) on how to convert the document
   *      into a domain object
   */
  @Nullable
  Document applySchematronValidation (@Nonnull Source aXMLSource) throws Exception;

  /**
   * Apply the Schematron validation on the passed XML resource and return a
   * {@link SchematronOutputType} object.
   *
   * @param aXMLResource
   *        The XML resource to validate via Schematron. May not be
   *        <code>null</code>.
   * @return The SVRL object containing the result. May be <code>null</code>
   *         when interpreting the Schematron failed.
   * @throws Exception
   *         In case the transformation somehow goes wrong.
   */
  @Nullable
  SchematronOutputType applySchematronValidationToSVRL (@Nonnull IHasInputStream aXMLResource) throws Exception;

  /**
   * Apply the Schematron validation on the passed XML source and return a
   * {@link SchematronOutputType} object.
   *
   * @param aXMLSource
   *        The XML source to validate via Schematron. May not be
   *        <code>null</code>.
   * @return The SVRL object containing the result. May be <code>null</code>
   *         when interpreting the Schematron failed.
   * @throws Exception
   *         In case the transformation somehow goes wrong.
   */
  @Nullable
  SchematronOutputType applySchematronValidationToSVRL (@Nonnull Source aXMLSource) throws Exception;
}
