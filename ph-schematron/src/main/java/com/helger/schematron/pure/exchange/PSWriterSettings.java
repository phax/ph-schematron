/**
 * Copyright (C) 2014-2019 Philip Helger (www.helger.com)
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

import javax.annotation.Nonnull;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.lang.ICloneable;
import com.helger.commons.string.ToStringGenerator;
import com.helger.schematron.CSchematron;
import com.helger.schematron.pure.model.PSNS;
import com.helger.schematron.pure.model.PSSchema;
import com.helger.xml.namespace.MapBasedNamespaceContext;
import com.helger.xml.serialize.write.EXMLSerializeIndent;
import com.helger.xml.serialize.write.IXMLWriterSettings;
import com.helger.xml.serialize.write.XMLWriterSettings;

/**
 * This class contains the settings to be used with {@link PSWriter}.
 *
 * @author Philip Helger
 */
public class PSWriterSettings implements ICloneable <PSWriterSettings>, IPSWriterSettings
{
  /**
   * The default writer settings to be used when nothing else is specified. By
   * default indent and align is disabled, to avoid that newlines are
   * interpreted as part of the content.
   */
  public static final IPSWriterSettings DEFAULT_SETTINGS = new PSWriterSettings ().setXMLWriterSettings (new XMLWriterSettings ().setIndent (EXMLSerializeIndent.NONE));

  private IXMLWriterSettings m_aXMLWriterSettings = new XMLWriterSettings ();

  public PSWriterSettings ()
  {}

  public PSWriterSettings (@Nonnull final IPSWriterSettings aOther)
  {
    ValueEnforcer.notNull (aOther, "Other");
    m_aXMLWriterSettings = aOther.getXMLWriterSettings ();
  }

  @Nonnull
  public IPSWriterSettings setXMLWriterSettings (@Nonnull final IXMLWriterSettings aXMLWriterSettings)
  {
    ValueEnforcer.notNull (aXMLWriterSettings, "XMLWriterSettings");
    m_aXMLWriterSettings = new XMLWriterSettings (aXMLWriterSettings);
    return this;
  }

  @Nonnull
  @ReturnsMutableCopy
  public XMLWriterSettings getXMLWriterSettings ()
  {
    return new XMLWriterSettings (m_aXMLWriterSettings);
  }

  /**
   * Helper method to extract the namespace mapping from the provided
   * Schematron.
   *
   * @param aSchema
   *        The schema to extract the namespace context from. May not be
   *        <code>null</code>.
   * @return A non-<code>null</code> but maybe empty namespace context
   */
  @Nonnull
  @ReturnsMutableCopy
  public static MapBasedNamespaceContext createNamespaceMapping (@Nonnull final PSSchema aSchema)
  {
    final MapBasedNamespaceContext ret = new MapBasedNamespaceContext ();
    ret.addDefaultNamespaceURI (CSchematron.NAMESPACE_SCHEMATRON);
    ret.addMapping ("xsl", CSchematron.NAMESPACE_URI_XSL);
    for (final PSNS aItem : aSchema.getAllNSs ())
      ret.addMapping (aItem.getPrefix (), aItem.getUri ());
    return ret;
  }

  @Nonnull
  public PSWriterSettings getClone ()
  {
    return new PSWriterSettings (this);
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("XMLWriterSettings", m_aXMLWriterSettings).getToString ();
  }
}
