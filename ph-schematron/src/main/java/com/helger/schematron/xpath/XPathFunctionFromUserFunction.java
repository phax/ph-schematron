/**
 * Copyright (C) 2014-2018 Philip Helger (www.helger.com)
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

import java.util.List;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.xml.xpath.XPathFunction;
import javax.xml.xpath.XPathFunctionException;

import com.helger.commons.ValueEnforcer;

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
  private final Configuration m_aConfiguration;
  private final Controller m_aXQController;
  private final UserFunction m_aUserFunc;

  public XPathFunctionFromUserFunction (@Nonnull final Configuration aConfiguration,
                                        @Nonnull final Controller aXQController,
                                        @Nonnull final UserFunction aUserFunc)
  {
    m_aConfiguration = ValueEnforcer.notNull (aConfiguration, "Configuration");
    m_aUserFunc = ValueEnforcer.notNull (aUserFunc, "UserFunc");
    m_aXQController = ValueEnforcer.notNull (aXQController, "XQController");
  }

  /**
   * @return The underlying Saxon user function.
   */
  @Nonnull
  public UserFunction getUserFunction ()
  {
    return m_aUserFunc;
  }

  /**
   * @return The function name.
   */
  @Nonnull
  public StructuredQName getFunctionName ()
  {
    return m_aUserFunc.getFunctionName ();
  }

  @Nullable
  public Object evaluate (final List aArgs) throws XPathFunctionException
  {
    try
    {
      // Convert the parameters
      final Sequence [] aSequences = new Sequence [aArgs.size ()];
      if (aArgs.size () > 0)
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
}
