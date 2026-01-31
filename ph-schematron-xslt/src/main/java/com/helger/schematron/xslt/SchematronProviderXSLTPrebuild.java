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
package com.helger.schematron.xslt;

import javax.xml.transform.ErrorListener;
import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.URIResolver;

import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.api.xslt.ISchematronXSLTBasedProvider;
import com.helger.schematron.saxon.SchematronTransformerFactory;
import com.helger.xml.serialize.read.DOMReader;
import com.helger.xml.transform.DefaultTransformURIResolver;
import com.helger.xml.transform.TransformSourceFactory;

/**
 * This Schematron validator factory uses an existing, precompiled Schematron
 * XSLT for validation.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class SchematronProviderXSLTPrebuild implements ISchematronXSLTBasedProvider
{
  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronProviderXSLTPrebuild.class);

  private Document m_aSchematronXSLTDoc;
  private Templates m_aSchematronXSLTTemplates;

  public SchematronProviderXSLTPrebuild (@Nullable final IReadableResource aXSLTResource,
                                         @Nullable final ErrorListener aCustomErrorListener,
                                         @Nullable final URIResolver aCustomURIResolver)
  {
    try
    {
      // Read XSLT file as XML
      m_aSchematronXSLTDoc = DOMReader.readXMLDOM (aXSLTResource);

      // compile result of read file
      final TransformerFactory aTF = SchematronTransformerFactory.createTransformerFactorySaxonFirst (SchematronProviderXSLTPrebuild.class.getClassLoader (),
                                                                                                      aCustomErrorListener,
                                                                                                      new DefaultTransformURIResolver (aCustomURIResolver));
      m_aSchematronXSLTTemplates = aTF.newTemplates (TransformSourceFactory.create (m_aSchematronXSLTDoc));
    }
    catch (final Exception ex)
    {
      LOGGER.error ("XSLT read/compilation error for " + aXSLTResource, ex);
    }
  }

  public boolean isValidSchematron ()
  {
    return m_aSchematronXSLTTemplates != null;
  }

  @Nullable
  public Document getXSLTDocument ()
  {
    return m_aSchematronXSLTDoc;
  }

  @Nullable
  public Transformer getXSLTTransformer () throws TransformerConfigurationException
  {
    return m_aSchematronXSLTTemplates == null ? null : m_aSchematronXSLTTemplates.newTransformer ();
  }
}
