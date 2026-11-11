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
package com.helger.schematron.phoxtrot;

import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;

import com.helger.annotation.Nonempty;
import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.IsSPIImplementation;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.phoxtrot.xdm.bridge.DomToXdm;
import com.helger.phoxtrot.xslt.jaxp.PhoxtrotTransformer;
import com.helger.phoxtrot.xslt.jaxp.XdmSource;
import com.helger.schematron.api.telemetry.ISchematronTemplateTelemetry;
import com.helger.schematron.api.xslt.processor.ISchematronXsltProcessorSpi;

/**
 * The phoxtrot implementation of the Schematron XSLT processor. It uses the factories of
 * {@link PhoxtrotTransformerFactories}.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@Immutable
@IsSPIImplementation
public final class PhoxtrotXsltProcessor implements ISchematronXsltProcessorSpi
{
  /** The ID of this processor */
  public static final String ID = "phoxtrot";

  private static final Logger LOGGER = LoggerFactory.getLogger (PhoxtrotXsltProcessor.class);

  public PhoxtrotXsltProcessor ()
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
    return PhoxtrotTransformerFactories.getDefault ();
  }

  @NonNull
  public TransformerFactory createTransformerFactory (final boolean bEnableTracing)
  {
    // phoxtrot needs no special compilation for tracing
    return PhoxtrotTransformerFactories.createTransformerFactory ();
  }

  @NonNull
  public Source createSourceForInternalDocument (@NonNull final Document aDoc, @Nullable final String sBaseUri)
  {
    // The DOM is never exposed, so it is converted into a phoxtrot tree once
    return new XdmSource (DomToXdm.convertDocument (aDoc, sBaseUri));
  }

  @NonNull
  public Source getEffectiveSource (@NonNull final Source aSource, @NonNull final Transformer aTransformer)
  {
    // phoxtrot converts all other sources itself
    return aSource;
  }

  public void installTemplateTelemetry (@NonNull final Transformer aTransformer,
                                        @NonNull final ISchematronTemplateTelemetry aTelemetry)
  {
    if (aTransformer instanceof final PhoxtrotTransformer aPhoxtrotTransformer)
      aPhoxtrotTransformer.setTraceListener (new PhoxtrotTemplateTelemetry (aTelemetry));
    else
      LOGGER.warn ("Cannot install the phoxtrot trace listener: transformer is not a PhoxtrotTransformer (was " +
                   aTransformer.getClass ().getName () +
                   "); template telemetry will not be emitted.");
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("ID", ID).getToString ();
  }
}
