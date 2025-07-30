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
import javax.annotation.concurrent.Immutable;
import javax.xml.xpath.XPathFactory;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.equals.EqualsHelper;
import com.helger.commons.hashcode.HashCodeGenerator;
import com.helger.commons.string.ToStringGenerator;
import com.helger.xml.xpath.MapBasedXPathFunctionResolver;
import com.helger.xml.xpath.MapBasedXPathVariableResolver;

import net.sf.saxon.lib.ExtensionFunctionDefinition;

/**
 * The immutable default implementation of {@link IXPathConfig}
 *
 * @author Thomas Pasch
 * @since 5.5.0
 */
@Immutable
public class XPathConfig implements IXPathConfig
{
  private final XPathFactory m_aXPathFactory;
  private final MapBasedXPathVariableResolver m_aXPathVariableResolver;
  private final MapBasedXPathFunctionResolver m_aXPathFunctionResolver;
  private final ICommonsList <ExtensionFunctionDefinition> m_aEFDs;

  public XPathConfig (@Nonnull final XPathFactory aXPathFactory,
                      @Nullable final MapBasedXPathVariableResolver aXPathVariableResolver,
                      @Nullable final MapBasedXPathFunctionResolver aXPathFunctionResolver,
                      @Nullable final ICommonsList <ExtensionFunctionDefinition> aEFDs)
  {
    ValueEnforcer.notNull (aXPathFactory, "XPathFactory");
    m_aXPathFactory = aXPathFactory;
    m_aXPathVariableResolver = aXPathVariableResolver;
    m_aXPathFunctionResolver = aXPathFunctionResolver;
    m_aEFDs = aEFDs;
  }

  @Nonnull
  public XPathFactory getXPathFactory ()
  {
    return m_aXPathFactory;
  }

  @Nullable
  public MapBasedXPathVariableResolver getXPathVariableResolver ()
  {
    return m_aXPathVariableResolver;
  }

  @Nullable
  public MapBasedXPathFunctionResolver getXPathFunctionResolver ()
  {
    return m_aXPathFunctionResolver;
  }

  @Nullable
  public ICommonsList <ExtensionFunctionDefinition> getAllEFDs ()
  {
    return m_aEFDs;
  }

  @Override
  public boolean equals (final Object o)
  {
    if (this == o)
      return true;
    if (o == null || !getClass ().equals (o.getClass ()))
      return false;
    final XPathConfig rhs = (XPathConfig) o;
    return m_aXPathFactory.equals (rhs.m_aXPathFactory) &&
           EqualsHelper.equals (m_aXPathVariableResolver, rhs.m_aXPathVariableResolver) &&
           EqualsHelper.equals (m_aXPathFunctionResolver, rhs.m_aXPathFunctionResolver);
  }

  @Override
  public int hashCode ()
  {
    return new HashCodeGenerator (this).append (m_aXPathFactory)
                                       .append (m_aXPathVariableResolver)
                                       .append (m_aXPathFunctionResolver)
                                       .getHashCode ();
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("XPathFactory", m_aXPathFactory)
                                       .append ("XPathVariableResolver", m_aXPathVariableResolver)
                                       .append ("XPathFunctionResolver", m_aXPathFunctionResolver)
                                       .getToString ();
  }
}
