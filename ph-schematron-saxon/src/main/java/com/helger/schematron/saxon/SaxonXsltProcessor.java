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
package com.helger.schematron.saxon;

import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.w3c.dom.Document;

import com.helger.annotation.Nonempty;
import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.IsSPIImplementation;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.schematron.api.telemetry.ISchematronTemplateTelemetry;
import com.helger.schematron.api.telemetry.SaxonTraceListenerInstaller;
import com.helger.schematron.api.telemetry.SchematronTraceListener;
import com.helger.schematron.api.xslt.processor.ISchematronXsltProcessorSpi;

import net.sf.saxon.jaxp.TransformerImpl;

/**
 * The Saxon implementation of the Schematron XSLT processor. It uses the factories of
 * {@link SchematronTransformerFactory}.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@Immutable
@IsSPIImplementation
public final class SaxonXsltProcessor implements ISchematronXsltProcessorSpi
{
  /** The ID of this processor */
  public static final String ID = "saxon";

  public SaxonXsltProcessor ()
  {}

  @NonNull
  @Nonempty
  public String getID ()
  {
    return ID;
  }

  @NonNull
  public TransformerFactory getDefaultTransformerFactory ()
  {
    return SchematronTransformerFactory.getDefault ();
  }

  @NonNull
  public TransformerFactory createTransformerFactory (final boolean bEnableTracing)
  {
    return SchematronTransformerFactory.createTransformerFactory (bEnableTracing);
  }

  @NonNull
  public Source createSourceForInternalDocument (@NonNull final Document aDoc, @Nullable final String sBaseUri)
  {
    // A SaxonDOMSource lets Saxon build its native tree once instead of navigating the wrapped DOM
    return new SaxonDOMSource (aDoc, sBaseUri);
  }

  @NonNull
  public Source getEffectiveSource (@NonNull final Source aSource,
                                    @NonNull final Transformer aTransformer) throws TransformerException
  {
    if (aSource instanceof final SaxonDOMSource aDOMSource &&
        aDOMSource.getNode () instanceof Document &&
        aTransformer instanceof final TransformerImpl aSaxonTransformer)
    {
      // Repeated XPath navigation over a wrapped DOM is expensive, especially for
      // large sibling lists. Build the configured Saxon tree once per validation.
      return aSaxonTransformer.getUnderlyingController ()
                              .getConfiguration ()
                              .buildDocumentTree (aSource)
                              .getRootNode ();
    }
    return aSource;
  }

  public void installTemplateTelemetry (@NonNull final Transformer aTransformer,
                                        @NonNull final ISchematronTemplateTelemetry aTelemetry)
  {
    SaxonTraceListenerInstaller.install (aTransformer, new SchematronTraceListener (aTelemetry));
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("ID", ID).getToString ();
  }
}
