/*
 * Copyright (C) 2014-2025 Philip Helger (www.helger.com)
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
package com.helger.schematron.pure.xpath;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.xml.xpath.XPathFactory;
import javax.xml.xpath.XPathFactoryConfigurationException;

import com.helger.commons.collection.impl.CommonsArrayList;
import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.string.ToStringGenerator;
import com.helger.xml.xpath.MapBasedXPathFunctionResolver;
import com.helger.xml.xpath.MapBasedXPathVariableResolver;
import com.helger.xml.xpath.XPathHelper;

import net.sf.saxon.lib.ExtensionFunctionDefinition;

/**
 * Builder class for {@link IXPathConfig}.
 *
 * @author Thomas Pasch
 * @since 5.5.0
 */
public class XPathConfigBuilder
{
  public static final XPathFactory XPATH_FACTORY_SAXON_FIRST = XPathHelper.createXPathFactorySaxonFirst ();
  public static final IXPathConfig DEFAULT = new XPathConfig (XPATH_FACTORY_SAXON_FIRST, null, null, null);

  private MapBasedXPathVariableResolver m_aXPathVariableResolver;
  private MapBasedXPathFunctionResolver m_aXPathFunctionResolver;
  private final ICommonsList <ExtensionFunctionDefinition> m_aEFDs = new CommonsArrayList <> ();

  public XPathConfigBuilder ()
  {}

  @Nullable
  public final MapBasedXPathVariableResolver getXPathVariableResolver ()
  {
    return m_aXPathVariableResolver;
  }

  @Nonnull
  public final XPathConfigBuilder setXPathVariableResolver (@Nullable final MapBasedXPathVariableResolver xPathVariableResolver)
  {
    m_aXPathVariableResolver = xPathVariableResolver;
    return this;
  }

  @Nullable
  public final MapBasedXPathFunctionResolver getXPathFunctionResolver ()
  {
    return m_aXPathFunctionResolver;
  }

  @Nonnull
  public final XPathConfigBuilder setXPathFunctionResolver (@Nullable final MapBasedXPathFunctionResolver xPathFunctionResolver)
  {
    m_aXPathFunctionResolver = xPathFunctionResolver;
    return this;
  }

  @Nonnull
  public XPathConfigBuilder addEFD (@Nonnull final ExtensionFunctionDefinition aEFD)
  {
    m_aEFDs.add (aEFD);
    return this;
  }

  @Nonnull
  public ICommonsList <ExtensionFunctionDefinition> getAllEFDs ()
  {
    return m_aEFDs;
  }

  /**
   * @return XPath configuration. Never {@link NullPointerException}.
   * @throws XPathFactoryConfigurationException
   *         In case of error
   */
  @Nonnull
  public IXPathConfig build () throws XPathFactoryConfigurationException
  {
    return new XPathConfig (XPATH_FACTORY_SAXON_FIRST, m_aXPathVariableResolver, m_aXPathFunctionResolver, m_aEFDs);
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("XPathVariableResolver", m_aXPathVariableResolver)
                                       .append ("XPathFunctionResolver", m_aXPathFunctionResolver)
                                       .getToString ();
  }
}
