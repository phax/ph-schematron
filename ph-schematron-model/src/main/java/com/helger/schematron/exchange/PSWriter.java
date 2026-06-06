/*
 * Copyright (C) 2015-2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.exchange;

import java.io.File;
import java.io.OutputStream;
import java.io.Writer;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.WillClose;
import com.helger.annotation.style.OverrideOnDemand;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.state.ESuccess;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.schematron.errorhandler.IPSErrorHandler;
import com.helger.schematron.errorhandler.LoggingPSErrorHandler;
import com.helger.schematron.model.IPSElement;
import com.helger.schematron.model.PSSchema;
import com.helger.schematron.model.PSVersionChecker;
import com.helger.xml.microdom.IMicroDocument;
import com.helger.xml.microdom.IMicroElement;
import com.helger.xml.microdom.IMicroNode;
import com.helger.xml.microdom.MicroDocument;
import com.helger.xml.microdom.serialize.MicroWriter;

/**
 * This class serializes the Schematron created within the domain object
 *
 * @author Philip Helger
 */
public class PSWriter
{
  private final IPSWriterSettings m_aWriterSettings;
  private IPSErrorHandler m_aErrorHandler;

  /**
   * Constructor using the default {@link PSWriterSettings} instance.
   */
  public PSWriter ()
  {
    this (PSWriterSettings.DEFAULT_SETTINGS);
  }

  /**
   * Constructor.
   *
   * @param aWriterSettings
   *        The writer settings to be used. May not be <code>null</code>.
   */
  public PSWriter (@NonNull final IPSWriterSettings aWriterSettings)
  {
    m_aWriterSettings = ValueEnforcer.notNull (aWriterSettings, "WriterSettings");
    m_aErrorHandler = new LoggingPSErrorHandler ();
  }

  /**
   * @return The writer settings specified in the constructor.
   */
  @NonNull
  public IPSWriterSettings getWriterSettings ()
  {
    return m_aWriterSettings;
  }

  /**
   * @return The error handler used to report version-compliance warnings when a
   *         {@link PSSchema} is serialised. Never <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public IPSErrorHandler getErrorHandler ()
  {
    return m_aErrorHandler;
  }

  /**
   * Override the error handler that receives version-compliance warnings when a {@link PSSchema}
   * is about to be written.
   *
   * @param aErrorHandler
   *        The new error handler. May not be <code>null</code>.
   * @return this for chaining
   * @since 10.0.0
   */
  @NonNull
  public PSWriter setErrorHandler (@NonNull final IPSErrorHandler aErrorHandler)
  {
    m_aErrorHandler = ValueEnforcer.notNull (aErrorHandler, "ErrorHandler");
    return this;
  }

  /**
   * Run the central Schematron version check when serialising a {@link PSSchema}. The check is a
   * no-op for any other element kind.
   *
   * @param aPSElement
   *        The element about to be written. May not be <code>null</code>.
   * @since 10.0.0
   */
  protected void runVersionCheck (@NonNull final IPSElement aPSElement)
  {
    if (aPSElement instanceof PSSchema)
      PSVersionChecker.checkSchematronVersionCompliance ((PSSchema) aPSElement, m_aErrorHandler);
  }

  @NonNull
  @OverrideOnDemand
  protected IMicroNode getAsDocument (@NonNull final IMicroElement aElement)
  {
    final IMicroDocument aDoc = new MicroDocument ();
    aDoc.addChild (aElement);
    return aDoc;
  }

  /**
   * Write the passed Schematron element to the passed file.
   *
   * @param aPSElement
   *        The schematron element to write. May not be <code>null</code>.
   * @param aFile
   *        The file to write things to. May not be <code>null</code>.
   * @return {@link ESuccess}.
   */
  @NonNull
  public ESuccess writeToFile (@NonNull final IPSElement aPSElement, @NonNull final File aFile)
  {
    ValueEnforcer.notNull (aPSElement, "PSElement");
    runVersionCheck (aPSElement);
    final IMicroElement eXML = aPSElement.getAsMicroElement ();
    return MicroWriter.writeToFile (getAsDocument (eXML), aFile, m_aWriterSettings.getXMLWriterSettings ());
  }

  /**
   * Write the passed Schematron element to the passed output stream.
   *
   * @param aPSElement
   *        The schematron element to write. May not be <code>null</code>.
   * @param aOS
   *        The output stream to write things to. May not be <code>null</code>. The stream is
   *        automatically closed.
   * @return {@link ESuccess}.
   */
  @NonNull
  public ESuccess writeToStream (@NonNull final IPSElement aPSElement, @NonNull @WillClose final OutputStream aOS)
  {
    ValueEnforcer.notNull (aPSElement, "PSElement");
    runVersionCheck (aPSElement);
    final IMicroElement eXML = aPSElement.getAsMicroElement ();
    return MicroWriter.writeToStream (getAsDocument (eXML), aOS, m_aWriterSettings.getXMLWriterSettings ());
  }

  /**
   * Write the passed Schematron element to the passed writer.
   *
   * @param aPSElement
   *        The schematron element to write. May not be <code>null</code>.
   * @param aWriter
   *        The writer to write things to. May not be <code>null</code>. The writer is automatically
   *        closed.
   * @return {@link ESuccess}.
   */
  @NonNull
  public ESuccess writeToWriter (@NonNull final IPSElement aPSElement, @NonNull @WillClose final Writer aWriter)
  {
    ValueEnforcer.notNull (aPSElement, "PSElement");
    runVersionCheck (aPSElement);
    final IMicroElement eXML = aPSElement.getAsMicroElement ();
    return MicroWriter.writeToWriter (getAsDocument (eXML), aWriter, m_aWriterSettings.getXMLWriterSettings ());
  }

  /**
   * Get the passed Schematron element as a String
   *
   * @param aPSElement
   *        The schematron element to convert to a string. May not be <code>null</code>.
   * @return The passed element as a string or <code>null</code> if serialization failed.
   */
  @Nullable
  public String getXMLString (@NonNull final IPSElement aPSElement)
  {
    ValueEnforcer.notNull (aPSElement, "PSElement");
    runVersionCheck (aPSElement);
    final IMicroElement eXML = aPSElement.getAsMicroElement ();
    return MicroWriter.getNodeAsString (getAsDocument (eXML), m_aWriterSettings.getXMLWriterSettings ());
  }

  /**
   * Get the passed Schematron element as a String
   *
   * @param aPSElement
   *        The schematron element to convert to a string. May not be <code>null</code>.
   * @return The passed element as a string and never <code>null</code>.
   * @throws IllegalStateException
   *         if serialization failed
   */
  @Nullable
  public String getXMLStringNotNull (@NonNull final IPSElement aPSElement)
  {
    final String ret = getXMLString (aPSElement);
    if (ret == null)
      throw new IllegalStateException ("Failed to serialize the passed PS element: " + aPSElement);
    return ret;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("WriterSettings", m_aWriterSettings)
                                       .append ("ErrorHandler", m_aErrorHandler)
                                       .getToString ();
  }
}
