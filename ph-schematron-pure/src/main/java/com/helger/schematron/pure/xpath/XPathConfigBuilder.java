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

import java.lang.reflect.InvocationTargetException;

import javax.xml.xpath.XPathFactory;
import javax.xml.xpath.XPathFactoryConfigurationException;
import javax.xml.xpath.XPathFunctionResolver;
import javax.xml.xpath.XPathVariableResolver;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.base.CGlobal;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.string.StringHelper;
import com.helger.base.system.SystemProperties;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.xml.xpath.XPathHelper;

import jakarta.annotation.Nonnull;
import jakarta.annotation.Nullable;

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

  private XPathFactory m_aXPathFactory;
  private Class <? extends XPathFactory> m_aXPathFactoryClass;
  private String m_sGlobalXPathFactoryClassName;
  private XPathVariableResolver m_aXPathVariableResolver;
  private XPathFunctionResolver m_aXPathFunctionResolver;

  public XPathConfigBuilder ()
  {}

  @Nullable
  public final XPathFactory getXPathFactory ()
  {
    return m_aXPathFactory;
  }

  /**
   * Set the {@link XPathFactory} to use. This instance always has priority 1.
   *
   * @param aXPathFactory
   *        The factory to use. May not be <code>null</code>.
   * @return this for chaining.
   */
  @Nonnull
  public final XPathConfigBuilder setXPathFactory (@Nonnull final XPathFactory aXPathFactory)
  {
    ValueEnforcer.notNull (aXPathFactory, "XPathFactoryClass");
    m_aXPathFactory = aXPathFactory;
    return this;
  }

  @Nullable
  public final Class <? extends XPathFactory> getXPathFactoryClass ()
  {
    return m_aXPathFactoryClass;
  }

  /**
   * Set the {@link XPathFactory} class to instantiate. This has priority 2 and is only used if
   * {@link #getXPathFactory()} is <code>null</code>.
   *
   * @param aXPathFactoryClass
   *        The factory to use. May not be <code>null</code>.
   * @return this for chaining.
   * @see #setXPathFactory(XPathFactory)
   * @see #setGlobalXPathFactory(String)
   */
  @Nonnull
  public final XPathConfigBuilder setXPathFactoryClass (@Nonnull final Class <? extends XPathFactory> aXPathFactoryClass)
  {
    ValueEnforcer.notNull (aXPathFactoryClass, "XPathFactoryClass");
    m_aXPathFactoryClass = aXPathFactoryClass;
    return this;
  }

  @Nullable
  public final String getGlobalXPathFactory ()
  {
    return m_sGlobalXPathFactoryClassName;
  }

  /**
   * With Java 11+ module path system, you can't access
   * <code>com.sun.org.apache.xpath.internal.jaxp.XPathFactoryImpl</code> as package
   * <code>com.sun.org.apache.xpath.internal.jaxp</code> is declared in module java.xml, which does
   * not export it.<br>
   * The only way to use it, is to set/alter the <code>javax.xml.xpath.XPathFactory</code> system
   * property. However, this change is <em>global</em> to the application.
   *
   * @param sGlobalXPathFactory
   *        Fully qualified class name of the 'default' {@link XPathFactory}. Most commonly set to
   *        'com.sun.org.apache.xpath.internal.jaxp.XPathFactoryImpl'.
   * @return this for chaining
   * @see #setXPathFactory(XPathFactory)
   * @see #setXPathFactoryClass(Class)
   */
  @Nonnull
  public final XPathConfigBuilder setGlobalXPathFactory (@Nullable final String sGlobalXPathFactory)
  {
    m_sGlobalXPathFactoryClassName = sGlobalXPathFactory;
    return this;
  }

  @Nullable
  public final XPathVariableResolver getXPathVariableResolver ()
  {
    return m_aXPathVariableResolver;
  }

  @Nonnull
  public final XPathConfigBuilder setXPathVariableResolver (@Nullable final XPathVariableResolver xPathVariableResolver)
  {
    m_aXPathVariableResolver = xPathVariableResolver;
    return this;
  }

  @Nullable
  public final XPathFunctionResolver getXPathFunctionResolver ()
  {
    return m_aXPathFunctionResolver;
  }

  @Nonnull
  public final XPathConfigBuilder setXPathFunctionResolver (@Nullable final XPathFunctionResolver xPathFunctionResolver)
  {
    m_aXPathFunctionResolver = xPathFunctionResolver;
    return this;
  }

  @Nonnull
  public IXPathConfig build () throws XPathFactoryConfigurationException
  {
    // Check if a predefined XPathFactory is present
    XPathFactory aXPathFactory = m_aXPathFactory;
    if (aXPathFactory != null)
    {
      if (LOGGER.isDebugEnabled ())
        LOGGER.debug ("Using provided XPathFactory instance");
    }
    else
    {
      if (m_aXPathFactoryClass != null)
      {
        if (LOGGER.isDebugEnabled ())
          LOGGER.debug ("Trying to instantiate XPathFactory class " + m_aXPathFactoryClass);

        try
        {
          aXPathFactory = m_aXPathFactoryClass.getConstructor (CGlobal.EMPTY_CLASS_ARRAY)
                                              .newInstance (CGlobal.EMPTY_OBJECT_ARRAY);
        }
        catch (final InvocationTargetException ex)
        {
          throw new XPathFactoryConfigurationException (ex.getCause ());
        }
        catch (final Exception ex)
        {
          throw new XPathFactoryConfigurationException (ex);
        }
      }
      else
        if (StringHelper.isNotEmpty (m_sGlobalXPathFactoryClassName))
        {
          if (LOGGER.isDebugEnabled ())
            LOGGER.debug ("Trying to set global XPathFactory system property to '" +
                          m_sGlobalXPathFactoryClassName +
                          "'");

          if (SystemProperties.setPropertyValue ("javax.xml.xpath.XPathFactory", m_sGlobalXPathFactoryClassName)
                              .isChanged ())
          {
            LOGGER.info ("Setting global system property 'javax.xml.xpath.XPathFactory' to '" +
                         m_sGlobalXPathFactoryClassName +
                         "'");
          }

          // Fall back to the global XPath factory
          aXPathFactory = XPathFactory.newInstance ();
        }
        else
        {
          if (LOGGER.isDebugEnabled ())
            LOGGER.debug ("The XPathConfigBuilder contains no clue what XPathFactory to use - using default.");

          // DEFAULT as fallback
          aXPathFactory = XPATH_FACTORY_SAXON_FIRST;
        }
    }

    return new XPathConfig (aXPathFactory, m_aXPathVariableResolver, m_aXPathFunctionResolver);
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("XPathFactory", m_aXPathFactory)
                                       .append ("XPathFactoryClass", m_aXPathFactoryClass)
                                       .append ("GlobalXPathFactoryClassName", m_sGlobalXPathFactoryClassName)
                                       .append ("XPathVariableResolver", m_aXPathVariableResolver)
                                       .append ("XPathFunctionResolver", m_aXPathFunctionResolver)
                                       .getToString ();
  }
}
