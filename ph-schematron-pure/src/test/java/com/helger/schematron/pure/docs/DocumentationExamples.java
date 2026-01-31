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
package com.helger.schematron.pure.docs;

import java.io.File;

import javax.xml.transform.stream.StreamSource;

import org.jspecify.annotations.NonNull;
import org.w3c.dom.Document;

import com.helger.io.file.FileHelper;
import com.helger.io.resource.FileSystemResource;
import com.helger.schematron.ISchematronResource;
import com.helger.schematron.pure.SchematronResourcePure;
import com.helger.schematron.pure.binding.IPSQueryBinding;
import com.helger.schematron.pure.binding.PSQueryBindingRegistry;
import com.helger.schematron.pure.bound.IPSBoundSchema;
import com.helger.schematron.pure.errorhandler.DoNothingPSErrorHandler;
import com.helger.schematron.pure.exchange.PSReader;
import com.helger.schematron.pure.model.PSSchema;
import com.helger.schematron.pure.model.PSTitle;
import com.helger.schematron.pure.preprocess.PSPreprocessor;
import com.helger.xml.microdom.serialize.MicroWriter;
import com.helger.xml.serialize.read.DOMReader;

/**
 * This class contains code examples that are used in the documentation.
 *
 * @author Philip Helger
 */
public final class DocumentationExamples
{
  public static boolean validateXMLViaPureSchematron (@NonNull final File aSchematronFile, @NonNull final File aXMLFile) throws Exception
  {
    final ISchematronResource aResPure = SchematronResourcePure.fromFile (aSchematronFile);
    if (!aResPure.isValidSchematron ())
      throw new IllegalArgumentException ("Invalid Schematron!");
    return aResPure.getSchematronValidity (new StreamSource (aXMLFile)).isValid ();
  }

  public static boolean validateXMLViaPureSchematron2 (@NonNull final File aSchematronFile, @NonNull final File aXMLFile) throws Exception
  {
    // Read the schematron from file
    final PSSchema aSchema = new PSReader (new FileSystemResource (aSchematronFile)).readSchema ();
    if (!aSchema.isValid (new DoNothingPSErrorHandler ()))
      throw new IllegalArgumentException ("Invalid Schematron!");
    // Resolve the query binding to use
    final IPSQueryBinding aQueryBinding = PSQueryBindingRegistry.getQueryBindingOfNameOrThrow (aSchema.getQueryBinding ());
    // Pre-process schema
    final PSPreprocessor aPreprocessor = new PSPreprocessor (aQueryBinding);
    aPreprocessor.setKeepTitles (true);
    final PSSchema aPreprocessedSchema = aPreprocessor.getAsPreprocessedSchema (aSchema);
    // Bind the pre-processed schema
    final IPSBoundSchema aBoundSchema = aQueryBinding.bind (aPreprocessedSchema);
    // Read the XML file
    final Document aXMLNode = DOMReader.readXMLDOM (aXMLFile);
    if (aXMLNode == null)
      return false;
    // Perform the validation
    return aBoundSchema.validatePartially (aXMLNode, FileHelper.getAsURLString (aXMLFile)).isValid ();
  }

  public static boolean readModifyAndWrite (@NonNull final File aSchematronFile) throws Exception
  {
    final PSSchema aSchema = new PSReader (new FileSystemResource (aSchematronFile)).readSchema ();
    final PSTitle aTitle = new PSTitle ();
    aTitle.addText ("Created by ph-schematron");
    aSchema.setTitle (aTitle);
    return MicroWriter.writeToFile (aSchema.getAsMicroElement (), aSchematronFile).isSuccess ();
  }
}
