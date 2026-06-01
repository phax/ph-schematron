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

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;

import org.jspecify.annotations.NonNull;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.annotation.Nonempty;
import com.helger.annotation.WillClose;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.io.stream.StreamHelper;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.CommonsIterableIterator;
import com.helger.collection.commons.ICommonsList;
import com.helger.io.file.FileHelper;

import net.sf.saxon.Configuration;
import net.sf.saxon.Controller;
import net.sf.saxon.expr.instruct.UserFunction;
import net.sf.saxon.functions.ExecutableFunctionLibrary;
import net.sf.saxon.functions.FunctionLibrary;
import net.sf.saxon.functions.FunctionLibraryList;
import net.sf.saxon.om.StructuredQName;
import net.sf.saxon.query.DynamicQueryContext;
import net.sf.saxon.query.StaticQueryContext;
import net.sf.saxon.query.XQueryExpression;
import net.sf.saxon.query.XQueryFunction;
import net.sf.saxon.query.XQueryFunctionLibrary;
import net.sf.saxon.s9api.ExtensionFunction;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.trans.XPathException;

/**
 * Load an XQuery module and expose its functions as Saxon {@link ExtensionFunction}s, ready to be
 * registered on a {@link net.sf.saxon.s9api.Processor}.
 *
 * @author Philip Helger
 */
public class XQueryAsXPathFunctionConverter
{
  private static final Logger LOGGER = LoggerFactory.getLogger (XQueryAsXPathFunctionConverter.class);

  private final String m_sBaseURL;

  /**
   * Default ctor using the current working directory as the base URL for the XQuery resource
   * resolver.
   *
   * @throws MalformedURLException
   *         In case the conversion to URL failed
   */
  public XQueryAsXPathFunctionConverter () throws MalformedURLException
  {
    this (new File (""));
  }

  /**
   * Constructor using the passed file as a working directory as the base URL for the XQuery
   * resource resolver.
   *
   * @param aBasePath
   *        Base path for XQuery resource resolving. May not be <code>null</code>.
   * @throws MalformedURLException
   *         In case the conversion to URL failed
   */
  public XQueryAsXPathFunctionConverter (@NonNull final File aBasePath) throws MalformedURLException
  {
    this (FileHelper.getAsURLString (aBasePath));
  }

  /**
   * Constructor using the passed URL as a working directory as the base URL for the XQuery resource
   * resolver.
   *
   * @param sBaseURL
   *        Base URL for XQuery resource resolving. May neither be <code>null</code> nor empty.
   */
  public XQueryAsXPathFunctionConverter (@NonNull @Nonempty final String sBaseURL)
  {
    m_sBaseURL = ValueEnforcer.notEmpty (sBaseURL, "BaseURL");
  }

  /**
   * @return The base URL provided in the constructor. Neither <code>null</code> nor empty.
   */
  @NonNull
  @Nonempty
  public String getBaseURL ()
  {
    return m_sBaseURL;
  }

  /**
   * Load XQuery functions from an input stream. As this function is supposed to work with Saxon HE,
   * this method allows only for loading full XQuery modules and not for XQuery libraries.
   *
   * @param aXQueryIS
   *        The Input Stream to read from. May not be <code>null</code>. Will be closed
   *        automatically in this method.
   * @return A non-<code>null</code> list of {@link ExtensionFunction}s — one per declared XQuery
   *         user function.
   * @throws XPathException
   *         if the syntax of the expression is wrong, or if it references namespaces, variables, or
   *         functions that have not been declared, or any other static error is reported.
   * @throws IOException
   *         if a failure occurs reading the supplied input.
   */
  @NonNull
  public ICommonsList <ExtensionFunction> loadXQuery (@NonNull @WillClose final InputStream aXQueryIS) throws XPathException,
                                                                                                       IOException
  {
    ValueEnforcer.notNull (aXQueryIS, "XQueryIS");

    try
    {
      final ICommonsList <ExtensionFunction> aResult = new CommonsArrayList <> ();

      // Create the Configuration through a Processor so that Configuration.getProcessor() is wired
      // up - XPathFunctionFromUserFunction relies on it to translate Saxon-internal SequenceTypes
      // to s9api SequenceTypes (which in turn lets Saxon coerce argument values at call time, e.g.
      // atomize node sequences when the user function declares xs:anyAtomicType*).
      final Processor aXQProcessor = new Processor (false);
      final Configuration aConfiguration = aXQProcessor.getUnderlyingConfiguration ();
      final DynamicQueryContext aDynamicQueryContext = new DynamicQueryContext (aConfiguration);
      final StaticQueryContext aStaticQueryCtx = aConfiguration.newStaticQueryContext ();

      aStaticQueryCtx.setBaseURI (m_sBaseURL);

      // null == auto detect
      final String sEncoding = null;

      final XQueryExpression exp = aStaticQueryCtx.compileQuery (aXQueryIS, sEncoding);
      final Controller aXQController = exp.newController (aDynamicQueryContext);

      final FunctionLibraryList aFuncLibList = exp.getExecutable ().getFunctionLibrary ();
      for (final FunctionLibrary aFuncLib : aFuncLibList.getLibraryList ())
      {
        if (aFuncLib instanceof final FunctionLibraryList aRealFuncLib)
        {
          for (final FunctionLibrary aNestedFuncLib : aRealFuncLib.getLibraryList ())
          {
            if (aNestedFuncLib instanceof final ExecutableFunctionLibrary aExecNestedFuncLib)
            {
              for (final UserFunction aUserFunc : new CommonsIterableIterator <> (aExecNestedFuncLib.getAllFunctions ()))
              {
                aResult.add (new XPathFunctionFromUserFunction (aConfiguration, aXQController, aUserFunc));
                if (LOGGER.isDebugEnabled ())
                {
                  final StructuredQName aFN = aUserFunc.getFunctionName ();
                  LOGGER.debug ("Registered user function '" +
                                aFN.getNamespaceBinding ().getPrefix () +
                                ":" +
                                aFN.getLocalPart () +
                                "' with arity of " +
                                aUserFunc.getArity ());
                }
              }
            }
            else
            {
              if (LOGGER.isDebugEnabled ())
                LOGGER.debug ("Ignoring other nested function library of type " +
                              aNestedFuncLib.getClass ().getName ());
            }
          }
        }
        else
          if (aFuncLib instanceof final XQueryFunctionLibrary aRealFuncLib)
          {
            for (final XQueryFunction aXQueryFunction : new CommonsIterableIterator <> (aRealFuncLib.getFunctionDefinitions ()))
            {
              // Ensure the function is compiled
              aXQueryFunction.compile ();
              aResult.add (new XPathFunctionFromUserFunction (aConfiguration,
                                                              aXQController,
                                                              aXQueryFunction.getUserFunction ()));
              if (LOGGER.isDebugEnabled ())
              {
                final StructuredQName aFN = aXQueryFunction.getFunctionName ();
                LOGGER.debug ("Registered user function '" +
                              aFN.getNamespaceBinding ().getPrefix () +
                              ":" +
                              aFN.getLocalPart () +
                              "' with arity of " +
                              aXQueryFunction.getNumberOfParameters ());
              }
            }
          }
          else
          {
            if (LOGGER.isDebugEnabled ())
              LOGGER.debug ("Ignoring other function library of type " + aFuncLib.getClass ().getName ());
          }
      }

      return aResult;
    }
    finally
    {
      StreamHelper.close (aXQueryIS);
    }
  }
}
