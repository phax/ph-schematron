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
package com.helger.schematron.api.xslt;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.w3c.dom.Document;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.io.nonblocking.NonBlockingByteArrayOutputStream;
import com.helger.xml.serialize.read.DOMReader;
import com.helger.xml.transform.XMLTransformerFactory;

/**
 * Holds a generated XSLT document in serialised form. A W3C DOM of a large XSLT needs several times
 * the memory of its serialised form, and the DOM is not needed for validation once the XSLT is
 * compiled. The DOM is only parsed again on the first call to {@link #getDocument()}.
 * <p>
 * Serialisation uses an identity transformation instead of the ph-xml <code>XMLWriter</code>,
 * because all namespace declarations must be retained - XSLT uses namespace prefixes inside
 * attribute values (XPath expressions) as well.
 * </p>
 *
 * @author Philip Helger
 * @since 10.2.1
 */
@NotThreadSafe
public final class SerializedXSLTDocument
{
  private final byte [] m_aBytes;
  private Document m_aDoc;

  private SerializedXSLTDocument (final byte @NonNull [] aBytes)
  {
    m_aBytes = aBytes;
  }

  /**
   * @return The number of bytes of the serialised XSLT. Always &ge; 0.
   */
  public int getByteCount ()
  {
    return m_aBytes.length;
  }

  /**
   * @return The XSLT document. It is parsed from the serialised form on the first call and the
   *         same instance is returned afterwards. May be <code>null</code> if parsing fails.
   */
  @Nullable
  public Document getDocument ()
  {
    if (m_aDoc == null)
      m_aDoc = DOMReader.readXMLDOM (m_aBytes);
    return m_aDoc;
  }

  /**
   * Serialise the provided XSLT document.
   *
   * @param aDoc
   *        The XSLT document to serialise. May not be <code>null</code>.
   * @return The serialised document. Never <code>null</code>.
   * @throws TransformerException
   *         If serialisation fails.
   */
  @NonNull
  public static SerializedXSLTDocument create (@NonNull final Document aDoc) throws TransformerException
  {
    ValueEnforcer.notNull (aDoc, "Document");

    // Own factory, because the default factory is not thread-safe and compilations may run in
    // parallel
    final Transformer aTransformer = XMLTransformerFactory.newTransformer (XMLTransformerFactory.createTransformerFactory (null,
                                                                                                                       null));
    if (aTransformer == null)
      throw new TransformerException ("Failed to create the identity transformer to serialise the XSLT");

    try (final NonBlockingByteArrayOutputStream aBAOS = new NonBlockingByteArrayOutputStream ())
    {
      aTransformer.transform (new DOMSource (aDoc), new StreamResult (aBAOS));
      return new SerializedXSLTDocument (aBAOS.getBufferOrCopy ());
    }
  }
}
