/*
 * Copyright (C) 2014-2023 Philip Helger (www.helger.com)
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
package com.helger.schematron.pure.exchange;

import java.io.File;
import java.io.OutputStream;
import java.io.Writer;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.WillClose;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.OverrideOnDemand;
import com.helger.commons.state.ESuccess;
import com.helger.commons.string.ToStringGenerator;
import com.helger.schematron.pure.model.IPSElement;
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
  public PSWriter (@Nonnull final IPSWriterSettings aWriterSettings)
  {
    m_aWriterSettings = ValueEnforcer.notNull (aWriterSettings, "WriterSettings");
  }

  /**
   * @return The writer settings specified in the constructor.
   */
  @Nonnull
  public IPSWriterSettings getWriterSettings ()
  {
    return m_aWriterSettings;
  }

  @Nonnull
  @OverrideOnDemand
  protected IMicroNode getAsDocument (@Nonnull final IMicroElement aElement)
  {
    final IMicroDocument aDoc = new MicroDocument ();
    aDoc.appendChild (aElement);
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
  @Nonnull
  public ESuccess writeToFile (@Nonnull final IPSElement aPSElement, @Nonnull final File aFile)
  {
    ValueEnforcer.notNull (aPSElement, "PSElement");
    final IMicroElement eXML = aPSElement.getAsMicroElement ();
    return MicroWriter.writeToFile (getAsDocument (eXML), aFile, m_aWriterSettings.getXMLWriterSettings ());
  }

  /**
   * Write the passed Schematron element to the passed output stream.
   *
   * @param aPSElement
   *        The schematron element to write. May not be <code>null</code>.
   * @param aOS
   *        The output stream to write things to. May not be <code>null</code>.
   *        The stream is automatically closed.
   * @return {@link ESuccess}.
   */
  @Nonnull
  public ESuccess writeToStream (@Nonnull final IPSElement aPSElement, @Nonnull @WillClose final OutputStream aOS)
  {
    ValueEnforcer.notNull (aPSElement, "PSElement");
    final IMicroElement eXML = aPSElement.getAsMicroElement ();
    return MicroWriter.writeToStream (getAsDocument (eXML), aOS, m_aWriterSettings.getXMLWriterSettings ());
  }

  /**
   * Write the passed Schematron element to the passed writer.
   *
   * @param aPSElement
   *        The schematron element to write. May not be <code>null</code>.
   * @param aWriter
   *        The writer to write things to. May not be <code>null</code>. The
   *        writer is automatically closed.
   * @return {@link ESuccess}.
   */
  @Nonnull
  public ESuccess writeToWriter (@Nonnull final IPSElement aPSElement, @Nonnull @WillClose final Writer aWriter)
  {
    ValueEnforcer.notNull (aPSElement, "PSElement");
    final IMicroElement eXML = aPSElement.getAsMicroElement ();
    return MicroWriter.writeToWriter (getAsDocument (eXML), aWriter, m_aWriterSettings.getXMLWriterSettings ());
  }

  /**
   * Get the passed Schematron element as a String
   *
   * @param aPSElement
   *        The schematron element to convert to a string. May not be
   *        <code>null</code>.
   * @return The passed element as a string or <code>null</code> if
   *         serialization failed.
   */
  @Nullable
  public String getXMLString (@Nonnull final IPSElement aPSElement)
  {
    ValueEnforcer.notNull (aPSElement, "PSElement");
    final IMicroElement eXML = aPSElement.getAsMicroElement ();
    return MicroWriter.getNodeAsString (getAsDocument (eXML), m_aWriterSettings.getXMLWriterSettings ());
  }

  /**
   * Get the passed Schematron element as a String
   *
   * @param aPSElement
   *        The schematron element to convert to a string. May not be
   *        <code>null</code>.
   * @return The passed element as a string and never <code>null</code>.
   * @throws IllegalStateException
   *         if serialization failed
   */
  @Nullable
  public String getXMLStringNotNull (@Nonnull final IPSElement aPSElement)
  {
    final String ret = getXMLString (aPSElement);
    if (ret == null)
      throw new IllegalStateException ("Failed to serialize the passed PS element: " + aPSElement);
    return ret;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("writerSettings", m_aWriterSettings).getToString ();
  }
}
