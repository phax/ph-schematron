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

import java.util.List;

import javax.xml.xpath.XPathFunction;
import javax.xml.xpath.XPathFunctionException;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.tostring.ToStringGenerator;

import net.sf.saxon.Configuration;
import net.sf.saxon.Controller;
import net.sf.saxon.expr.JPConverter;
import net.sf.saxon.expr.XPathContextMajor;
import net.sf.saxon.expr.instruct.UserFunction;
import net.sf.saxon.om.Sequence;
import net.sf.saxon.om.StructuredQName;

/**
 * A proxy for an {@link XPathFunction} that is implemented as a Saxon
 * {@link UserFunction}. This works only if Saxon is present in the classpath.
 *
 * @author Philip Helger
 */
public final class XPathFunctionFromUserFunction implements XPathFunction
{
  private static final Logger LOGGER = LoggerFactory.getLogger (XPathFunctionFromUserFunction.class);

  private final Configuration m_aConfiguration;
  private final Controller m_aXQController;
  private final UserFunction m_aUserFunc;

  public XPathFunctionFromUserFunction (@NonNull final Configuration aConfiguration,
                                        @NonNull final Controller aXQController,
                                        @NonNull final UserFunction aUserFunc)
  {
    m_aConfiguration = ValueEnforcer.notNull (aConfiguration, "Configuration");
    m_aUserFunc = ValueEnforcer.notNull (aUserFunc, "UserFunc");
    m_aXQController = ValueEnforcer.notNull (aXQController, "XQController");
  }

  /**
   * @return The underlying Saxon user function.
   */
  @NonNull
  public UserFunction getUserFunction ()
  {
    return m_aUserFunc;
  }

  /**
   * @return The function name.
   */
  @NonNull
  public StructuredQName getFunctionName ()
  {
    return m_aUserFunc.getFunctionName ();
  }

  @Nullable
  public Object evaluate (@NonNull final List <?> aArgs) throws XPathFunctionException
  {
    LOGGER.info ("Evaluating user function '" + getFunctionName () + "' with " + aArgs.size () + " parameter(s)");

    try
    {
      // Convert the parameters
      final Sequence [] aSequences = new Sequence [aArgs.size ()];
      if (!aArgs.isEmpty ())
      {
        // Create a new context per evaluation
        final XPathContextMajor aXPathContext = m_aXQController.newXPathContext ();

        int nIndex = 0;
        for (final Object aArg : aArgs)
        {
          // Ripped from Saxon itself; genericType is not needed
          final JPConverter aConverter = JPConverter.allocate (aArg.getClass (), null, m_aConfiguration);
          // Convert to Sequence
          aSequences[nIndex] = aConverter.convert (aArg, aXPathContext);
          ++nIndex;
        }
      }
      // Finally invoke user function
      return m_aUserFunc.call (aSequences, m_aXQController);
    }
    catch (final Exception ex)
    {
      // Wrap all exceptions
      throw new XPathFunctionException (ex);
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
