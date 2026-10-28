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

import java.net.URI;

import javax.xml.transform.Source;
import javax.xml.transform.sax.SAXSource;
import javax.xml.transform.stream.StreamSource;

import org.jspecify.annotations.NonNull;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.InputSource;
import org.xml.sax.XMLReader;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.string.StringHelper;
import com.helger.xml.serialize.read.SAXReaderFactory;

import net.sf.saxon.dom.NodeOverNodeInfo;
import net.sf.saxon.s9api.DocumentBuilder;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.XdmNode;

/**
 * Helper to read XML into Saxon's native tree model (usually a TinyTree) and to present it as a
 * read-only DOM facade. A {@link StreamSource} is parsed through a hardened {@link XMLReader}, so
 * that the same XXE protection applies as for DOM parsing.
 *
 * @author Philip Helger
 * @since 10.2.1
 */
@Immutable
public final class SaxonTinyTreeHelper
{
  private SaxonTinyTreeHelper ()
  {}

  /**
   * Build a Saxon document from the provided source and wrap it into a DOM facade.
   *
   * @param aProcessor
   *        The Saxon processor whose configuration is used to build the tree. May not be
   *        <code>null</code>.
   * @param aSource
   *        The source to read. A {@link StreamSource} and a {@link SAXSource} without an
   *        {@link XMLReader} are parsed with a hardened {@link XMLReader}; all other sources are
   *        passed to Saxon as is. May not be <code>null</code>.
   * @return A {@link NodeOverNodeInfo} based {@link Document}. Never <code>null</code>.
   * @throws SaxonApiException
   *         If reading fails.
   */
  @NonNull
  public static Document buildDocumentFacade (@NonNull final Processor aProcessor,
                                              @NonNull final Source aSource) throws SaxonApiException
  {
    ValueEnforcer.notNull (aProcessor, "Processor");
    ValueEnforcer.notNull (aSource, "Source");

    final DocumentBuilder aBuilder = aProcessor.newDocumentBuilder ();
    // No DTD validation - it would require loading the (potentially external) DTD
    aBuilder.setDTDValidation (false);
    // No schema validation - it could load external schemas via xsi:schemaLocation
    aBuilder.setSchemaValidator (null);
    final String sSystemId = aSource.getSystemId ();
    if (StringHelper.isNotEmpty (sSystemId))
      try
      {
        aBuilder.setBaseURI (new URI (sSystemId));
      }
      catch (final Exception ex)
      {
        // Not a valid URI - skip; Saxon will fall back to whatever the Source carries
      }

    // Bridge through a hardened XMLReader so Saxon's TinyTree fast path inherits XXE protection.
    // Saxon parses a StreamSource and a SAXSource without XMLReader itself - SAXSource with an
    // XMLReader is parsed by the caller's reader, DOMSource / StAXSource walk a pre-built tree (no
    // parsing).
    final Source aSafeSource;
    if (aSource instanceof final StreamSource aStreamSrc)
    {
      final XMLReader aXMLReader = SAXReaderFactory.createXMLReader ();

      final InputSource aInputSrc;
      if (aStreamSrc.getInputStream () != null)
        aInputSrc = new InputSource (aStreamSrc.getInputStream ());
      else
        if (aStreamSrc.getReader () != null)
          aInputSrc = new InputSource (aStreamSrc.getReader ());
        else
          aInputSrc = new InputSource (aStreamSrc.getSystemId ());
      if (StringHelper.isNotEmpty (aStreamSrc.getSystemId ()))
        aInputSrc.setSystemId (aStreamSrc.getSystemId ());
      if (StringHelper.isNotEmpty (aStreamSrc.getPublicId ()))
        aInputSrc.setPublicId (aStreamSrc.getPublicId ());

      final SAXSource aSAXSrc = new SAXSource (aXMLReader, aInputSrc);
      if (StringHelper.isNotEmpty (aStreamSrc.getSystemId ()))
        aSAXSrc.setSystemId (aStreamSrc.getSystemId ());

      aSafeSource = aSAXSrc;
    }
    else
      if (aSource instanceof final SAXSource aSAXSrc && aSAXSrc.getXMLReader () == null)
      {
        // Don't modify the caller's object
        final SAXSource aSecureSAXSrc = new SAXSource (SAXReaderFactory.createXMLReader (), aSAXSrc.getInputSource ());
        aSecureSAXSrc.setSystemId (aSAXSrc.getSystemId ());
        aSafeSource = aSecureSAXSrc;
      }
      else
      {
        // Parsing is the caller's responsibility (or there is none).
        aSafeSource = aSource;
      }

    final XdmNode aXdm = aBuilder.build (aSafeSource);
    final Node aDom = NodeOverNodeInfo.wrap (aXdm.getUnderlyingNode ());
    if (aDom instanceof final Document aDoc)
      return aDoc;

    throw new IllegalStateException ("Saxon DocumentBuilder did not return a document NodeInfo: " + aDom);
  }
}
