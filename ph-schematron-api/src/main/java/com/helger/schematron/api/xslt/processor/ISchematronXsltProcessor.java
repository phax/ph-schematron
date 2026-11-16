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
package com.helger.schematron.api.xslt.processor;

import javax.xml.transform.ErrorListener;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.URIResolver;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.w3c.dom.Document;

import com.helger.annotation.Nonempty;
import com.helger.base.id.IHasID;
import com.helger.schematron.api.telemetry.ISchematronTemplateTelemetry;

/**
 * An XSLT processor that runs the XSLT based Schematron pipelines (e.g. Saxon or phoxtrot). It
 * creates the JAXP {@link TransformerFactory} instances for the conversion steps and the validation
 * stylesheet, and provides the processor specific parts of a validation.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
public interface ISchematronXsltProcessor extends IHasID <String>
{
  /**
   * @return The unique ID of this processor, e.g. <code>saxon</code>. Never <code>null</code> nor
   *         empty.
   */
  @NonNull
  @Nonempty
  String getID ();

  /**
   * @return The shared default {@link TransformerFactory} of this processor, used to compile the
   *         stylesheets of the Schematron to XSLT conversion. Never <code>null</code>.
   */
  @NonNull
  TransformerFactory getDefaultTransformerFactory ();

  /**
   * Create a new {@link TransformerFactory} of this processor.
   *
   * @param bEnableTracing
   *        <code>true</code> if the stylesheets compiled with the factory must support per-template
   *        telemetry (see {@link #installTemplateTelemetry(Transformer, ISchematronTemplateTelemetry)}).
   * @return A new {@link TransformerFactory}. Never <code>null</code>.
   */
  @NonNull
  TransformerFactory createTransformerFactory (boolean bEnableTracing);

  /**
   * Create a new {@link TransformerFactory} of this processor with the provided error listener and
   * URI resolver.
   *
   * @param aErrorListener
   *        The error listener to set. May be <code>null</code> to keep the default.
   * @param aURIResolver
   *        The URI resolver to set. May be <code>null</code> to keep the default.
   * @param bEnableTracing
   *        <code>true</code> if the stylesheets compiled with the factory must support per-template
   *        telemetry.
   * @return A new {@link TransformerFactory}. Never <code>null</code>.
   */
  @NonNull
  default TransformerFactory createTransformerFactory (@Nullable final ErrorListener aErrorListener,
                                                       @Nullable final URIResolver aURIResolver,
                                                       final boolean bEnableTracing)
  {
    final TransformerFactory aFactory = createTransformerFactory (bEnableTracing);
    if (aErrorListener != null)
      aFactory.setErrorListener (aErrorListener);
    if (aURIResolver != null)
      aFactory.setURIResolver (aURIResolver);
    return aFactory;
  }

  /**
   * Create the {@link Source} for a DOM document that was created internally (e.g. parsed from an
   * input stream) and is never exposed to the caller. The processor may therefore convert it into
   * its own tree model before the validation.
   *
   * @param aDoc
   *        The internally created document. May not be <code>null</code>.
   * @param sBaseUri
   *        The base URI of the document. May be <code>null</code>.
   * @return The source to validate. Never <code>null</code>.
   */
  @NonNull
  Source createSourceForInternalDocument (@NonNull Document aDoc, @Nullable String sBaseUri);

  /**
   * Get the source that is really passed to the validation transformer. Called once per validation,
   * right before the transformation.
   *
   * @param aSource
   *        The source provided to the validation. May not be <code>null</code>.
   * @param aTransformer
   *        The validation transformer created by this processor. May not be <code>null</code>.
   * @return The source to transform. Never <code>null</code>. May be the provided source.
   * @throws TransformerException
   *         If the source cannot be converted
   */
  @NonNull
  Source getEffectiveSource (@NonNull Source aSource, @NonNull Transformer aTransformer) throws TransformerException;

  /**
   * Install per-template telemetry on a validation transformer. Only stylesheets compiled with a
   * factory from {@link #createTransformerFactory(boolean)} with tracing enabled are guaranteed to
   * emit events.
   *
   * @param aTransformer
   *        The validation transformer created by this processor. May not be <code>null</code>.
   * @param aTelemetry
   *        The telemetry callback. May not be <code>null</code>.
   */
  void installTemplateTelemetry (@NonNull Transformer aTransformer, @NonNull ISchematronTemplateTelemetry aTelemetry);
}
