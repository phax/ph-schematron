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
package com.helger.schematron.pure.xpath;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.equals.EqualsHelper;
import com.helger.base.hashcode.HashCodeGenerator;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.CommonsHashMap;
import com.helger.collection.commons.ICommonsList;
import com.helger.collection.commons.ICommonsMap;

import net.sf.saxon.s9api.ExtensionFunction;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.XdmValue;

/**
 * The immutable default implementation of {@link IXPathConfig}.
 *
 * @author Philip Helger
 * @since 5.5.0
 */
@Immutable
public class XPathConfig implements IXPathConfig
{
  private final Processor m_aProcessor;
  private final ICommonsList <ExtensionFunction> m_aExtensionFunctions;
  private final ICommonsMap <QName, XdmValue> m_aExternalVariables;

  public XPathConfig (@NonNull final Processor aProcessor,
                      @Nullable final ICommonsList <ExtensionFunction> aExtensionFunctions,
                      @Nullable final ICommonsMap <QName, XdmValue> aExternalVariables)
  {
    ValueEnforcer.notNull (aProcessor, "Processor");
    m_aProcessor = aProcessor;
    m_aExtensionFunctions = aExtensionFunctions != null ? aExtensionFunctions.getClone () : new CommonsArrayList <> ();
    m_aExternalVariables = aExternalVariables != null ? aExternalVariables.getClone () : new CommonsHashMap <> ();
  }

  @NonNull
  public Processor getProcessor ()
  {
    return m_aProcessor;
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <ExtensionFunction> getAllExtensionFunctions ()
  {
    return m_aExtensionFunctions.getClone ();
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsMap <QName, XdmValue> getAllExternalVariables ()
  {
    return m_aExternalVariables.getClone ();
  }

  @Override
  public boolean equals (final Object o)
  {
    if (this == o)
      return true;
    if (o == null || !getClass ().equals (o.getClass ()))
      return false;
    final XPathConfig rhs = (XPathConfig) o;
    return m_aProcessor.equals (rhs.m_aProcessor) &&
           EqualsHelper.equals (m_aExtensionFunctions, rhs.m_aExtensionFunctions) &&
           EqualsHelper.equals (m_aExternalVariables, rhs.m_aExternalVariables);
  }

  @Override
  public int hashCode ()
  {
    return new HashCodeGenerator (this).append (m_aProcessor)
                                       .append (m_aExtensionFunctions)
                                       .append (m_aExternalVariables)
                                       .getHashCode ();
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("Processor", m_aProcessor)
                                       .append ("ExtensionFunctions", m_aExtensionFunctions)
                                       .append ("ExternalVariables", m_aExternalVariables)
                                       .getToString ();
  }
}
