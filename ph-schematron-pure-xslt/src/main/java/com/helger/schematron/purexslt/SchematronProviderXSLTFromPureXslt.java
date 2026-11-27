/*
 * Copyright (C) 2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.purexslt;

import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;

import org.jspecify.annotations.NonNull;
import org.w3c.dom.Document;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.schematron.api.xslt.ISchematronXSLTBasedProvider;
import com.helger.schematron.api.xslt.processor.ISchematronXsltProcessor;

/**
 * The XSLT provider of the pure XSLT engine: the XSLT generated from the Schematron in Java and its
 * compiled form. Created by {@link SchematronPureXsltConfig#compile()}, so it always contains a
 * valid compiled XSLT.
 *
 * @author Philip Helger
 * @since 11.1.0
 */
@Immutable
public final class SchematronProviderXSLTFromPureXslt implements ISchematronXSLTBasedProvider
{
  private final ISchematronXsltProcessor m_aXsltProcessor;
  private final Document m_aXsltDoc;
  private final Templates m_aTemplates;

  /**
   * Constructor
   *
   * @param aXsltProcessor
   *        The XSLT processor that compiled the XSLT. May not be <code>null</code>.
   * @param aXsltDoc
   *        The generated XSLT. May not be <code>null</code>.
   * @param aTemplates
   *        The compiled XSLT. May not be <code>null</code>.
   */
  public SchematronProviderXSLTFromPureXslt (@NonNull final ISchematronXsltProcessor aXsltProcessor,
                                             @NonNull final Document aXsltDoc,
                                             @NonNull final Templates aTemplates)
  {
    ValueEnforcer.notNull (aXsltProcessor, "XsltProcessor");
    ValueEnforcer.notNull (aXsltDoc, "XsltDoc");
    ValueEnforcer.notNull (aTemplates, "Templates");
    m_aXsltProcessor = aXsltProcessor;
    m_aXsltDoc = aXsltDoc;
    m_aTemplates = aTemplates;
  }

  @NonNull
  public ISchematronXsltProcessor getXsltProcessor ()
  {
    return m_aXsltProcessor;
  }

  /**
   * @return Always <code>true</code>, because an instance is only created for a compiled XSLT.
   */
  public boolean isValidSchematron ()
  {
    return true;
  }

  @NonNull
  public Document getXSLTDocument ()
  {
    return m_aXsltDoc;
  }

  @NonNull
  public Transformer getXSLTTransformer () throws TransformerConfigurationException
  {
    return m_aTemplates.newTransformer ();
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("XsltProcessor", m_aXsltProcessor).getToString ();
  }
}
