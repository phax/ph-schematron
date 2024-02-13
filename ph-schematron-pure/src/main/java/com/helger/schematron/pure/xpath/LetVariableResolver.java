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

import javax.annotation.Nullable;
import javax.xml.namespace.QName;
import javax.xml.xpath.XPathVariableResolver;

import com.helger.commons.collection.impl.CommonsHashMap;
import com.helger.commons.collection.impl.ICommonsMap;

public class LetVariableResolver implements XPathVariableResolver
{
  private final XPathVariableResolver m_aDelegatedResolver;
  private final ICommonsMap<QName, Object> m_aVariables;

  public LetVariableResolver (XPathVariableResolver resolver)
  {
    this.m_aDelegatedResolver = resolver;
    this.m_aVariables = new CommonsHashMap<> ();
  }

  public void setValue (QName variableName, Object value)
  {
    m_aVariables.put (variableName, value);
  }

    /**
   * Remove all variables with the specified names
   *
   * @param aVarName
   *        The variable name to be removed. May be <code>null</code>.
   */
  public void remove (@Nullable final QName aVarName)
  {
    if (aVarName != null)
      m_aVariables.remove (aVarName);
  }

  @Override
  public Object resolveVariable (QName variableName)
  {
    Object result = m_aVariables.get (variableName);
    if (result == null && m_aDelegatedResolver != null) {
      return m_aDelegatedResolver.resolveVariable (variableName);
    }

    return result;
  }
}
