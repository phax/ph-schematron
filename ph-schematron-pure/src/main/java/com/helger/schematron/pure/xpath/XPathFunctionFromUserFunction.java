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
import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.SequenceType;
import net.sf.saxon.s9api.XdmValue;

/**
 * A Saxon {@link ExtensionFunction} that proxies an XQuery {@link UserFunction}. This class is
 * used by {@link XQueryAsXPathFunctionConverter} to expose XQuery user functions as XPath
 * extension functions.
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

  public XPathFunctionFromUserFunction (@NonNull final Configuration aConfiguration,
                                        @NonNull final Controller aXQController,
                                        @NonNull final UserFunction aUserFunc)
  {
    m_aConfiguration = ValueEnforcer.notNull (aConfiguration, "Configuration");
    m_aXQController = ValueEnforcer.notNull (aXQController, "XQController");
    m_aUserFunc = ValueEnforcer.notNull (aUserFunc, "UserFunc");
    m_aName = new QName (aUserFunc.getFunctionName ());

    // Pin the arity; argument types are kept opaque (ANY) so we accept whatever the caller
    // passes - the underlying UserFunction will enforce its declared signature on invocation.
    final int nArity = aUserFunc.getArity ();
    m_aArgumentTypes = new SequenceType [nArity];
    for (int i = 0; i < nArity; i++)
      m_aArgumentTypes[i] = SequenceType.ANY;
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
    return SequenceType.ANY;
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
