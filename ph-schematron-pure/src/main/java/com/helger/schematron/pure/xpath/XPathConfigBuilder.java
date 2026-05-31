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

import java.util.Map;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.base.builder.IBuilder;
import com.helger.base.enforce.ValueEnforcer;
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
 * Builder class for {@link IXPathConfig}. Since v9.2.0 this is based on the Saxon s9api.
 *
 * @author Philip Helger
 * @since 5.5.0
 */
public class XPathConfigBuilder implements IBuilder <IXPathConfig>
{
  /**
   * The default Saxon {@link Processor} used when no explicit one is provided. It uses Saxon-HE in
   * non-licensed mode.
   */
  public static final Processor DEFAULT_PROCESSOR = new Processor (false);

  /**
   * The default {@link IXPathConfig} when nothing is customized.
   */
  public static final IXPathConfig DEFAULT = new XPathConfig (DEFAULT_PROCESSOR, EXPathVersion.DEFAULT, null, null);

  private Processor m_aProcessor;
  private EXPathVersion m_eXPathVersion = EXPathVersion.DEFAULT;
  private final ICommonsList <ExtensionFunction> m_aExtensionFunctions = new CommonsArrayList <> ();
  private final ICommonsMap <QName, XdmValue> m_aExternalVariables = new CommonsHashMap <> ();

  public XPathConfigBuilder ()
  {}

  @Nullable
  public final Processor getProcessor ()
  {
    return m_aProcessor;
  }

  /**
   * Set the Saxon {@link Processor} to use. If never set, {@link #DEFAULT_PROCESSOR} is used by
   * {@link #build()}.
   *
   * @param aProcessor
   *        The Saxon Processor to use. May not be <code>null</code>.
   * @return this for chaining
   */
  @NonNull
  public final XPathConfigBuilder setProcessor (@NonNull final Processor aProcessor)
  {
    ValueEnforcer.notNull (aProcessor, "Processor");
    m_aProcessor = aProcessor;
    return this;
  }

  @NonNull
  public final EXPathVersion getXPathVersion ()
  {
    return m_eXPathVersion;
  }

  /**
   * Set the XPath language version applied to the Saxon {@code XPathCompiler}. Defaults to
   * {@link EXPathVersion#DEFAULT}.
   *
   * @param eXPathVersion
   *        The XPath version. May not be <code>null</code>.
   * @return this for chaining
   * @see net.sf.saxon.s9api.XPathCompiler#setLanguageVersion(String)
   * @since 9.2.0
   */
  @NonNull
  public final XPathConfigBuilder setXPathVersion (@NonNull final EXPathVersion eXPathVersion)
  {
    ValueEnforcer.notNull (eXPathVersion, "XPathVersion");
    m_eXPathVersion = eXPathVersion;
    return this;
  }

  /**
   * Add a Saxon {@link ExtensionFunction} to be registered on the {@link Processor}.
   *
   * @param aFunction
   *        The function to add. May not be <code>null</code>.
   * @return this for chaining
   */
  @NonNull
  public final XPathConfigBuilder addExtensionFunction (@NonNull final ExtensionFunction aFunction)
  {
    ValueEnforcer.notNull (aFunction, "Function");
    m_aExtensionFunctions.add (aFunction);
    return this;
  }

  /**
   * Add several Saxon {@link ExtensionFunction}s to be registered on the {@link Processor}.
   *
   * @param aFunctions
   *        The functions to add. May be <code>null</code>.
   * @return this for chaining
   */
  @NonNull
  public final XPathConfigBuilder addAllExtensionFunctions (@Nullable final Iterable <? extends ExtensionFunction> aFunctions)
  {
    if (aFunctions != null)
      for (final ExtensionFunction aFunc : aFunctions)
        if (aFunc != null)
          m_aExtensionFunctions.add (aFunc);
    return this;
  }

  /**
   * Add an external XPath variable binding.
   *
   * @param aName
   *        The variable name. May not be <code>null</code>.
   * @param aValue
   *        The variable value as an {@link XdmValue}. May not be <code>null</code>.
   * @return this for chaining
   */
  @NonNull
  public final XPathConfigBuilder addExternalVariable (@NonNull final QName aName, @NonNull final XdmValue aValue)
  {
    ValueEnforcer.notNull (aName, "Name");
    ValueEnforcer.notNull (aValue, "Value");
    m_aExternalVariables.put (aName, aValue);
    return this;
  }

  /**
   * Add several external XPath variable bindings.
   *
   * @param aVariables
   *        Variable name to value mapping. May be <code>null</code>.
   * @return this for chaining
   */
  @NonNull
  public final XPathConfigBuilder addAllExternalVariables (@Nullable final Map <QName, ? extends XdmValue> aVariables)
  {
    if (aVariables != null)
      for (final Map.Entry <QName, ? extends XdmValue> aEntry : aVariables.entrySet ())
        m_aExternalVariables.put (aEntry.getKey (), aEntry.getValue ());
    return this;
  }

  @NonNull
  public IXPathConfig build ()
  {
    // Choose the target Processor:
    // - If the caller supplied a Processor explicitly, use it (the caller owns its lifecycle and
    //   accepts that registerExtensionFunction will mutate it).
    // - Otherwise, when there is nothing to register, return the shared DEFAULT_PROCESSOR
    //   untouched.
    // - When there ARE extension functions to register and no explicit Processor was given,
    //   allocate a fresh Processor instead of mutating the shared DEFAULT_PROCESSOR. The
    //   alternative - registering on the shared singleton - was a process-wide side effect
    //   that leaked extension functions across unrelated callers and races inside Saxon's
    //   HashMap-backed function registry (which is not thread-safe).
    final Processor aProcessor;
    if (m_aProcessor != null)
      aProcessor = m_aProcessor;
    else
      if (m_aExtensionFunctions.isEmpty ())
        aProcessor = DEFAULT_PROCESSOR;
      else
        aProcessor = new Processor (false);

    // Register extension functions on the chosen Processor
    for (final ExtensionFunction aFunc : m_aExtensionFunctions)
      aProcessor.registerExtensionFunction (aFunc);

    return new XPathConfig (aProcessor, m_eXPathVersion, m_aExtensionFunctions, m_aExternalVariables);
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("Processor", m_aProcessor)
                                       .append ("XPathVersion", m_eXPathVersion)
                                       .append ("ExtensionFunctions", m_aExtensionFunctions)
                                       .append ("ExternalVariables", m_aExternalVariables)
                                       .getToString ();
  }
}
