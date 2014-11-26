/**
 * Copyright (C) 2014 Philip Helger (www.helger.com)
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

import net.sf.saxon.Configuration;
import net.sf.saxon.Controller;
import net.sf.saxon.expr.JPConverter;
import net.sf.saxon.expr.XPathContextMajor;
import net.sf.saxon.expr.instruct.UserFunction;
import net.sf.saxon.om.Sequence;

import com.helger.commons.ValueEnforcer;

/**
 * A proxy for an {@link XPathFunction} that is implemented as a Saxon
 * {@link UserFunction}.
 *
 * @author Philip Helger
 */
public final class XPathFunctionFromUserFunction implements XPathFunction
{
  private final Configuration m_aConfiguration;
  private final Controller m_aXQController;
  private final UserFunction m_aUserFunc;
  private final XPathContextMajor m_aXPathContext;

  public XPathFunctionFromUserFunction (@Nonnull final Configuration aConfiguration,
                                        @Nonnull final Controller aXQController,
                                        @Nonnull final UserFunction aUserFunc)
  {
    m_aConfiguration = ValueEnforcer.notNull (aConfiguration, "Configuration");
    m_aUserFunc = ValueEnforcer.notNull (aUserFunc, "UserFunc");
    m_aXQController = ValueEnforcer.notNull (aXQController, "XQController");
    // This is surely not correct, but it works :)
    m_aXPathContext = aXQController.newXPathContext ();
  }

  @Nullable
  public Object evaluate (@SuppressWarnings ("rawtypes") final List args) throws XPathFunctionException
  {
    try
    {
      // Convert the parameters
      final Sequence [] aValues = new Sequence [args.size ()];
      int i = 0;
      for (final Object arg : args)
      {
        // Ripped from Saxon itself
        final JPConverter converter = JPConverter.allocate (arg.getClass (), null, m_aConfiguration);
        aValues[i] = converter.convert (arg, m_aXPathContext);
        ++i;
      }
      // Invoke function
      return m_aUserFunc.call (aValues, m_aXQController);
    }
    catch (final Exception ex)
    {
      // Wrap all exceptions
      throw new XPathFunctionException (ex);
    }
  }
}
