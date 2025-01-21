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
package com.helger.schematron.svrl;

import javax.annotation.concurrent.NotThreadSafe;

import com.helger.commons.debug.GlobalDebug;
import com.helger.jaxb.GenericJAXBMarshaller;
import com.helger.schematron.svrl.jaxb.ObjectFactory;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;

/**
 * This is the XML reader and write for Schematron SVRL documents. It reads XML
 * DOM documents and returns {@link SchematronOutputType} elements and vice
 * versa. The reading and writing itself is done with JAXB.<br>
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class SVRLMarshaller extends GenericJAXBMarshaller <SchematronOutputType>
{
  public SVRLMarshaller ()
  {
    this (true);
  }

  public SVRLMarshaller (final boolean bValidationEnabled)
  {
    super (SchematronOutputType.class,
           bValidationEnabled ? CSVRL.SVRL_XSDS : null,
           new ObjectFactory ()::createSchematronOutput);
    setFormattedOutput (GlobalDebug.isDebugMode ());

    // Use the default namespace context
    setNamespaceContext (SVRLNamespaceContext.getInstance ());
  }
}
