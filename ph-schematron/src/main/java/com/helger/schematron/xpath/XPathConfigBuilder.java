/**
 * Copyright (C) 2014-2020 Philip Helger (www.helger.com)
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
package com.helger.schematron.xpath;

import java.lang.reflect.InvocationTargetException;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.xml.xpath.XPathFactory;
import javax.xml.xpath.XPathFactoryConfigurationException;
import javax.xml.xpath.XPathFunctionResolver;
import javax.xml.xpath.XPathVariableResolver;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.collection.ArrayHelper;
import com.helger.commons.string.StringHelper;
import com.helger.commons.system.SystemProperties;
import com.helger.xml.xpath.XPathHelper;

/**
 * Builder class for {@link IXPathConfig}.
 *
 * @author Thomas Pasch
 * @since 5.5.0
 */
public class XPathConfigBuilder
{
  public static final XPathFactory XPATH_FACTORY_SAXON_FIRST = XPathHelper.createXPathFactorySaxonFirst ();
  public static final IXPathConfig DEFAULT = new XPathConfig (XPATH_FACTORY_SAXON_FIRST, null, null);

  private static final Logger LOGGER = LoggerFactory.getLogger (XPathConfigBuilder.class);
  private static final Class <?> [] EMPTY_CLASS_ARRAY = new Class <?> [0];

  private Class <? extends XPathFactory> m_aXPathFactoryClass;
  private String m_sGlobalXPathFactory;
  private XPathVariableResolver m_aXPathVariableResolver;
  private XPathFunctionResolver m_aXPathFunctionResolver;

  public XPathConfigBuilder ()
  {}

  @Nullable
  public Class <? extends XPathFactory> getXPathFactoryClass ()
  {
    return m_aXPathFactoryClass;
  }

  @Nonnull
  public XPathConfigBuilder setXPathFactoryClass (@Nonnull final Class <? extends XPathFactory> aXPathFactoryClass)
  {
    ValueEnforcer.notNull (aXPathFactoryClass, "XPathFactoryClass");
    m_aXPathFactoryClass = aXPathFactoryClass;
    return this;
  }

  @Nullable
  public String getGlobalXPathFactory ()
  {
    return m_sGlobalXPathFactory;
  }

  /**
   * With Java 11+ module path system, you can't access
   * <code>com.sun.org.apache.xpath.internal.jaxp.XPathFactoryImpl</code> as
   * package <code>com.sun.org.apache.xpath.internal.jaxp</code> is declared in
   * module java.xml, which does not export it.<br>
   * The only way to use it, is to set/alter the
   * <code>javax.xml.xpath.XPathFactory</code> system property. However, this
   * change is <em>global</em> to the application.
   *
   * @param sGlobalXPathFactory
   *        Fully qualified class name of the 'default' {@link XPathFactory}.
   *        Most commonly set to
   *        'com.sun.org.apache.xpath.internal.jaxp.XPathFactoryImpl'.
   * @return this for chaining
   */
  @Nonnull
  public XPathConfigBuilder setGlobalXPathFactory (@Nullable final String sGlobalXPathFactory)
  {
    m_sGlobalXPathFactory = sGlobalXPathFactory;
    return this;
  }

  @Nullable
  public XPathVariableResolver getXPathVariableResolver ()
  {
    return m_aXPathVariableResolver;
  }

  @Nonnull
  public XPathConfigBuilder setXPathVariableResolver (@Nullable final XPathVariableResolver xPathVariableResolver)
  {
    m_aXPathVariableResolver = xPathVariableResolver;
    return this;
  }

  @Nullable
  public XPathFunctionResolver getXPathFunctionResolver ()
  {
    return m_aXPathFunctionResolver;
  }

  @Nonnull
  public XPathConfigBuilder setXPathFunctionResolver (@Nullable final XPathFunctionResolver xPathFunctionResolver)
  {
    m_aXPathFunctionResolver = xPathFunctionResolver;
    return this;
  }

  @Nonnull
  public IXPathConfig build () throws XPathFactoryConfigurationException
  {
    if (StringHelper.hasText (m_sGlobalXPathFactory))
    {
      if (SystemProperties.setPropertyValue ("javax.xml.xpath.XPathFactory", m_sGlobalXPathFactory).isChanged ())
      {
        LOGGER.info ("Setting global system property 'javax.xml.xpath.XPathFactory' to '" +
                     m_sGlobalXPathFactory +
                     "'");
      }
    }

    final XPathFactory aXPathFactory;
    if (m_aXPathFactoryClass != null)
    {
      try
      {
        aXPathFactory = m_aXPathFactoryClass.getConstructor (EMPTY_CLASS_ARRAY)
                                            .newInstance (ArrayHelper.EMPTY_OBJECT_ARRAY);
      }
      catch (final InvocationTargetException e)
      {
        throw new XPathFactoryConfigurationException (e.getCause ());
      }
      catch (final Exception e)
      {
        throw new XPathFactoryConfigurationException (e);
      }
    }
    else
      if (StringHelper.hasText (m_sGlobalXPathFactory))
      {
        // Fall back to the global XPath factory
        aXPathFactory = XPathFactory.newInstance ();
      }
      else
      {
        // DEFAULT as fallback
        aXPathFactory = XPATH_FACTORY_SAXON_FIRST;
      }

    return new XPathConfig (aXPathFactory, m_aXPathVariableResolver, m_aXPathFunctionResolver);
  }
}
