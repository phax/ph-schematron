/*
 * Copyright (C) 2024 Philip Helger (www.helger.com)
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
import javax.annotation.concurrent.NotThreadSafe;
import javax.xml.namespace.QName;
import javax.xml.xpath.XPathVariableResolver;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.collection.impl.CommonsHashMap;
import com.helger.commons.collection.impl.ICommonsMap;
import com.helger.commons.string.ToStringGenerator;

@NotThreadSafe
public class XPathLetVariableResolver implements XPathVariableResolver
{
  private final ICommonsMap <QName, Object> m_aVariables = new CommonsHashMap <> ();
  private final XPathVariableResolver m_aDelegatedResolver;

  public XPathLetVariableResolver (@Nullable final XPathVariableResolver aResolver)
  {
    m_aDelegatedResolver = aResolver;
  }

  public void setVariableValue (@Nonnull final QName aVariableName, @Nullable final Object aValue)
  {
    ValueEnforcer.notNull (aVariableName, "VariableName");
    m_aVariables.put (aVariableName, aValue);
  }

  /**
   * Remove all variables with the specified names
   *
   * @param aVariableName
   *        The variable name to be removed. May be <code>null</code>.
   */
  public void removeVariable (@Nullable final QName aVariableName)
  {
    if (aVariableName != null)
      m_aVariables.remove (aVariableName);
  }

  @Override
  public Object resolveVariable (@Nullable final QName aVariableName)
  {
    if (aVariableName != null)
    {
      // 1. variables
      final Object result = m_aVariables.get (aVariableName);
      if (result != null)
        return result;

      // 2. delegated resolver
      if (m_aDelegatedResolver != null)
        return m_aDelegatedResolver.resolveVariable (aVariableName);
    }

    // 3. no match
    return null;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("Variables", m_aVariables)
                                       .append ("DelegatedResolver", m_aDelegatedResolver)
                                       .getToString ();
  }
}
