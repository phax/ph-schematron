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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.tostring.ToStringGenerator;

import net.sf.saxon.Configuration;
import net.sf.saxon.Controller;
import net.sf.saxon.expr.instruct.UserFunction;
import net.sf.saxon.om.Sequence;
import net.sf.saxon.s9api.ExtensionFunction;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.SequenceType;
import net.sf.saxon.s9api.XdmValue;

/**
 * A Saxon {@link ExtensionFunction} that proxies an XQuery {@link UserFunction}. This class is
 * used by {@link XQueryAsXPathFunctionConverter} to expose XQuery user functions as XPath
 * extension functions. The argument and result {@link SequenceType}s are taken from the
 * underlying {@link UserFunction}, so Saxon performs the same automatic coercion (atomization,
 * cardinality checks, etc.) at call time that it would for any built-in function.
 *
 * @author Philip Helger
 */
public final class XPathFunctionFromUserFunction implements ExtensionFunction
{
  private static final Logger LOGGER = LoggerFactory.getLogger (XPathFunctionFromUserFunction.class);

  private final Configuration m_aConfiguration;
  private final Controller m_aXQController;
  private final UserFunction m_aUserFunc;
  private final QName m_aName;
  private final SequenceType [] m_aArgumentTypes;
  private final SequenceType m_aResultType;

  public XPathFunctionFromUserFunction (@NonNull final Configuration aConfiguration,
                                        @NonNull final Controller aXQController,
                                        @NonNull final UserFunction aUserFunc)
  {
    m_aConfiguration = ValueEnforcer.notNull (aConfiguration, "Configuration");
    m_aXQController = ValueEnforcer.notNull (aXQController, "XQController");
    m_aUserFunc = ValueEnforcer.notNull (aUserFunc, "UserFunc");
    m_aName = new QName (aUserFunc.getFunctionName ());

    // Translate the UserFunction's argument and result SequenceTypes into the s9api flavor so
    // that Saxon applies the same coercion (atomization, cardinality, type promotion, ...) that
    // it would for the corresponding XQuery call. Without this, e.g. calling
    // functx:are-distinct-values (which declares xs:anyAtomicType*) with a sequence of element
    // nodes throws ClassCastException inside distinct-values().
    final Processor aProc = (Processor) aConfiguration.getProcessor ();
    if (aProc == null)
      throw new IllegalStateException ("Saxon Configuration has no s9api Processor attached. " +
                                       "Use net.sf.saxon.s9api.Processor.getUnderlyingConfiguration() to obtain a Configuration.");

    final int nArity = aUserFunc.getArity ();
    m_aArgumentTypes = new SequenceType [nArity];
    for (int i = 0; i < nArity; i++)
      m_aArgumentTypes[i] = SequenceType.fromUnderlyingSequenceType (aProc, aUserFunc.getArgumentType (i));

    m_aResultType = SequenceType.fromUnderlyingSequenceType (aProc, aUserFunc.getResultType ());
  }

  /**
   * @return The underlying Saxon user function. Never <code>null</code>.
   */
  @NonNull
  public UserFunction getUserFunction ()
  {
    return m_aUserFunc;
  }

  @NonNull
  public QName getName ()
  {
    return m_aName;
  }

  @NonNull
  public SequenceType [] getArgumentTypes ()
  {
    return m_aArgumentTypes;
  }

  @Override
  @NonNull
  public SequenceType getResultType ()
  {
    return m_aResultType;
  }

  @NonNull
  public XdmValue call (@NonNull final XdmValue [] aArgs) throws SaxonApiException
  {
    if (LOGGER.isDebugEnabled ())
      LOGGER.debug ("Evaluating user function '" + m_aName + "' with " + aArgs.length + " parameter(s)");

    try
    {
      final Sequence [] aSequences = new Sequence [aArgs.length];
      for (int i = 0; i < aArgs.length; i++)
        aSequences[i] = aArgs[i].getUnderlyingValue ();

      final Sequence aResult = m_aUserFunc.call (aSequences, m_aXQController);
      return XdmValue.wrap (aResult);
    }
    catch (final Exception ex)
    {
      throw new SaxonApiException (ex);
    }
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("Configuration", m_aConfiguration)
                                       .append ("XQController", m_aXQController)
                                       .append ("UserFunc", m_aUserFunc)
                                       .getToString ();
  }
}
