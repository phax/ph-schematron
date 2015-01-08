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
package com.helger.schematron.xslt;

import javax.annotation.Nullable;
import javax.annotation.concurrent.NotThreadSafe;
import javax.xml.transform.ErrorListener;
import javax.xml.transform.TransformerFactory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.commons.io.IReadableResource;
import com.helger.commons.xml.serialize.DOMReader;
import com.helger.commons.xml.transform.DefaultTransformURIResolver;
import com.helger.commons.xml.transform.TransformSourceFactory;
import com.helger.commons.xml.transform.XMLTransformerFactory;

/**
 * This Schematron validator factory uses an existing, precompiled Schematron
 * XSLT for validation.
 *
 * @author Philip Helger
 */
@NotThreadSafe
final class SchematronProviderXSLTPrebuild extends AbstractSchematronXSLTProvider
{
  private static final Logger s_aLogger = LoggerFactory.getLogger (SchematronProviderXSLTPrebuild.class);

  public SchematronProviderXSLTPrebuild (@Nullable final IReadableResource aXSLTResource,
                                         @Nullable final ErrorListener aCustomErrorListener)
  {
    try
    {
      // Read XSLT file as XML
      m_aSchematronXSLTDoc = DOMReader.readXMLDOM (aXSLTResource);

      // compile result of read file
      final TransformerFactory aTF = XMLTransformerFactory.createTransformerFactory (aCustomErrorListener,
                                                                                     new DefaultTransformURIResolver ());
      m_aSchematronXSLT = aTF.newTemplates (TransformSourceFactory.create (m_aSchematronXSLTDoc));
    }
    catch (final Exception ex)
    {
      s_aLogger.error ("XSLT read/compilation error for " + aXSLTResource, ex);
    }
  }
}
