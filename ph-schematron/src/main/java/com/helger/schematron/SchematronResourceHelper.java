/**
 * Copyright (C) 2014-2017 Philip Helger (www.helger.com)
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
package com.helger.schematron;

import java.io.InputStream;
import java.io.Reader;
import java.net.MalformedURLException;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.Immutable;
import javax.xml.transform.Source;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.SAXException;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.PresentForCodeCoverage;
import com.helger.commons.io.resource.URLResource;
import com.helger.commons.string.StringHelper;
import com.helger.xml.serialize.read.DOMReader;

/**
 * This is a common utility class.
 *
 * @author Philip Helger
 */
@Immutable
public final class SchematronResourceHelper
{
  private static final Logger s_aLogger = LoggerFactory.getLogger (SchematronResourceHelper.class);

  @PresentForCodeCoverage
  private static final SchematronResourceHelper s_aInstance = new SchematronResourceHelper ();

  private SchematronResourceHelper ()
  {}

  /**
   * Convert the passed transform source into a DOM node. Currently on
   * {@link DOMSource} and {@link StreamSource} can be handled.
   *
   * @param aSource
   *        The transform source to use. May not be <code>null</code>.
   * @return The DOM node and never <code>null</code>.
   * @throws SAXException
   *         In case XML parsing fails
   * @throws IllegalArgumentException
   *         in case an unsupported {@link Source} implementation is provided.
   */
  @Nullable
  public static Node getNodeOfSource (@Nonnull final Source aSource) throws SAXException
  {
    ValueEnforcer.notNull (aSource, "Source");

    if (aSource instanceof DOMSource)
    {
      // Node is already in DOMSource
      return ((DOMSource) aSource).getNode ();
    }

    if (aSource instanceof StreamSource)
    {
      // In StreamSource it can either be a byte stream or a character stream or
      // a system ID
      final StreamSource aStreamSource = (StreamSource) aSource;

      final InputStream aIS = aStreamSource.getInputStream ();
      if (aIS != null)
      {
        // Byte stream
        final Document aDoc = DOMReader.readXMLDOM (aIS);
        if (aDoc == null)
          throw new IllegalArgumentException ("Failed to read source " + aSource + " as XML from InputStream " + aIS);
        return aDoc;
      }

      final Reader aReader = aStreamSource.getReader ();
      if (aReader != null)
      {
        // CHaracter stream
        final Document aDoc = DOMReader.readXMLDOM (aReader);
        if (aDoc == null)
          throw new IllegalArgumentException ("Failed to read source " + aSource + " as XML from Reader " + aReader);
        return aDoc;
      }

      final String sSystemID = aStreamSource.getSystemId ();
      if (StringHelper.hasText (sSystemID))
      {
        // System ID
        try
        {
          final URLResource aURL = new URLResource (sSystemID);
          final Document aDoc = DOMReader.readXMLDOM (aURL);
          if (aDoc == null)
            throw new IllegalArgumentException ("Failed to read source " +
                                                aSource +
                                                " as XML from SystemID '" +
                                                sSystemID +
                                                "'");
          return aDoc;
        }
        catch (final MalformedURLException ex)
        {
          throw new IllegalArgumentException ("Failed to read source " +
                                              aSource +
                                              " as XML from SystemID '" +
                                              sSystemID +
                                              "': " +
                                              ex.getMessage ());
        }
      }

      // Neither InputStream nor Reader present
      s_aLogger.error ("StreamSource contains neither InputStream nor Reader nor SystemID - cannot handle!");
      return null;
    }

    final String sMsg = "Can only handle DOMSource and StreamSource - having " +
                        aSource +
                        " with system ID '" +
                        aSource.getSystemId () +
                        "'";
    s_aLogger.error (sMsg);
    throw new IllegalArgumentException (sMsg);
  }
}
