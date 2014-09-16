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

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;

import javax.annotation.Nonnull;
import javax.annotation.WillClose;

import net.sf.saxon.Configuration;
import net.sf.saxon.Controller;
import net.sf.saxon.expr.instruct.UserFunction;
import net.sf.saxon.functions.ExecutableFunctionLibrary;
import net.sf.saxon.functions.FunctionLibrary;
import net.sf.saxon.functions.FunctionLibraryList;
import net.sf.saxon.query.StaticQueryContext;
import net.sf.saxon.query.XQueryExpression;
import net.sf.saxon.trans.XPathException;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotations.Nonempty;
import com.helger.commons.collections.ContainerHelper;
import com.helger.commons.io.streams.StreamUtils;
import com.helger.commons.xml.xpath.MapBasedXPathFunctionResolver;

/**
 * This class loads XQuery modules and provides a list of XPath functions.
 *
 * @author Philip Helger
 */
public class XQueryAsXPathFunctionConverter
{
  private final String m_sBaseURL;

  /**
   * Default ctor using the current working directory as the base URL for the
   * XQuery resource resolver.
   *
   * @throws MalformedURLException
   *         In case the conversion to URL failed
   */
  public XQueryAsXPathFunctionConverter () throws MalformedURLException
  {
    this (new File (""));
  }

  /**
   * Constructor using the passed file as a working directory as the base URL
   * for the XQuery resource resolver.
   *
   * @param aBasePath
   *        Base path for XQuery resource resolving. May not be
   *        <code>null</code>.
   * @throws MalformedURLException
   *         In case the conversion to URL failed
   */
  public XQueryAsXPathFunctionConverter (@Nonnull final File aBasePath) throws MalformedURLException
  {
    this (aBasePath.toURI ().toURL ().toExternalForm ());
  }

  /**
   * Constructor using the passed URL as a working directory as the base URL for
   * the XQuery resource resolver.
   *
   * @param sBaseURL
   *        Base URL for XQuery resource resolving. May neither be
   *        <code>null</code> nor empty.
   */
  public XQueryAsXPathFunctionConverter (@Nonnull @Nonempty final String sBaseURL)
  {
    m_sBaseURL = ValueEnforcer.notEmpty (sBaseURL, "BaseURL");
  }

  /**
   * @return The base URL provided in the constructor. Neither <code>null</code>
   *         nor empty.
   */
  @Nonnull
  @Nonempty
  public String getBaseURL ()
  {
    return m_sBaseURL;
  }

  /**
   * Load XQuery functions from an input stream. As this function is supposed to
   * work with Saxon HE, this method allows only for loading full XQuery modules
   * and not for XQuery libraries.
   *
   * @param aXQueryIS
   *        The Input Stream to read from. May not be <code>null</code>. Will be
   *        closed automatically in this method.
   * @return A non-<code>null</code> {@link MapBasedXPathFunctionResolver}
   *         containing all loaded functions.
   * @throws XPathException
   *         if the syntax of the expression is wrong, or if it references
   *         namespaces, variables, or functions that have not been declared, or
   *         any other static error is reported.
   * @throws IOException
   *         if a failure occurs reading the supplied input.
   */
  @Nonnull
  public MapBasedXPathFunctionResolver loadXQuery (@Nonnull @WillClose final InputStream aXQueryIS) throws XPathException,
                                                                                                   IOException
  {
    ValueEnforcer.notNull (aXQueryIS, "XQueryIS");

    try
    {
      final MapBasedXPathFunctionResolver aFunctionResolver = new MapBasedXPathFunctionResolver ();

      // create a Configuration object
      final Configuration aConfiguration = new Configuration ();
      final StaticQueryContext aStaticQueryCtx = aConfiguration.newStaticQueryContext ();
      // The base URI required for resolving within the XQuery
      aStaticQueryCtx.setBaseURI (m_sBaseURL);
      final XQueryExpression exp = aStaticQueryCtx.compileQuery (aXQueryIS, null);
      final Controller aXQController = exp.newController ();

      // find all loaded methods and convert them to XPath functions
      final FunctionLibraryList aFuncLibList = exp.getExecutable ().getFunctionLibrary ();
      for (final FunctionLibrary aFuncLib : aFuncLibList.getLibraryList ())
      {
        // Ignore all Vendor, System etc. internal libraries
        if (aFuncLib instanceof FunctionLibraryList)
        {
          // This is the custom function library list
          final FunctionLibraryList aRealFuncLib = (FunctionLibraryList) aFuncLib;
          // Assumption works with Saxon HE 9.5.1-6 :)
          for (final FunctionLibrary aNestedFuncLib : aRealFuncLib.getLibraryList ())
          {
            // Currently the user functions are in ExecutableFunctionLibrary
            if (aNestedFuncLib instanceof ExecutableFunctionLibrary)
              for (final UserFunction aUserFunc : ContainerHelper.newList (((ExecutableFunctionLibrary) aNestedFuncLib).iterateFunctions ()))
              {
                aFunctionResolver.addUniqueFunction (aUserFunc.getFunctionName ().getNamespaceBinding ().getURI (),
                                                     aUserFunc.getFunctionName ().getLocalPart (),
                                                     aUserFunc.getNumberOfArguments (),
                                                     new XPathFunctionFromUserFunction (aConfiguration,
                                                                                        aXQController,
                                                                                        aUserFunc));
              }
          }
        }
      }

      return aFunctionResolver;
    }
    finally
    {
      StreamUtils.close (aXQueryIS);
    }
  }
}
