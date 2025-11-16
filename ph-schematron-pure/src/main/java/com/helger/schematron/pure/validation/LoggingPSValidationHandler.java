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
package com.helger.schematron.pure.validation;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.helger.annotation.Nonnegative;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.state.EContinue;
import com.helger.base.string.StringHelper;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.diagnostics.error.level.EErrorLevel;
import com.helger.diagnostics.error.level.IErrorLevel;
import com.helger.diagnostics.log.LogHelper;
import com.helger.schematron.pure.model.PSAssertReport;
import com.helger.schematron.pure.model.PSPattern;
import com.helger.schematron.pure.model.PSPhase;
import com.helger.schematron.pure.model.PSRule;
import com.helger.schematron.pure.model.PSSchema;
import com.helger.xml.XMLDebug;

/**
 * A logging implementation of {@link IPSValidationHandler}
 *
 * @author Philip Helger
 * @since 5.3.0
 */
public class LoggingPSValidationHandler implements IPSValidationHandler
{
  private final Logger m_aLogger;
  private IErrorLevel m_aLogLevel = EErrorLevel.INFO;
  private String m_sLogPrefix;

  /**
   * Default constructor.
   */
  public LoggingPSValidationHandler ()
  {
    this (LoggerFactory.getLogger (LoggingPSValidationHandler.class));
  }

  /**
   * Constructor with a custom logger
   *
   * @param aLogger
   *        The logger to use. May not be <code>null</code>.
   */
  public LoggingPSValidationHandler (@NonNull final Logger aLogger)
  {
    ValueEnforcer.notNull (aLogger, "Logger");
    m_aLogger = aLogger;
  }

  @NonNull
  public final Logger getLogger ()
  {
    return m_aLogger;
  }

  @NonNull
  public final IErrorLevel getLogLevel ()
  {
    return m_aLogLevel;
  }

  @NonNull
  public final LoggingPSValidationHandler setLogLevel (@NonNull final IErrorLevel aLogLevel)
  {
    ValueEnforcer.notNull (aLogLevel, "LogLevel");
    m_aLogLevel = aLogLevel;
    return this;
  }

  @Nullable
  public final String getLogPrefix ()
  {
    return m_sLogPrefix;
  }

  @NonNull
  public final LoggingPSValidationHandler setLogPrefix (@Nullable final String sLogPrefix)
  {
    m_sLogPrefix = sLogPrefix;
    return this;
  }

  private void _log (@NonNull final String sMsg)
  {
    LogHelper.log (m_aLogger, m_aLogLevel, StringHelper.getConcatenatedOnDemand (m_sLogPrefix, sMsg));
  }

  @NonNull
  public static String getAsString (@NonNull final Node aNode)
  {
    return XMLDebug.getNodeTypeAsString (aNode.getNodeType ()) + ": " + aNode.toString ();
  }

  @NonNull
  public static String getAsString (@NonNull final NodeList aNL)
  {
    final int nLen = aNL.getLength ();
    final StringBuilder aSB = new StringBuilder ();
    aSB.append ("NodeList[").append (nLen).append ("](");
    for (int i = 0; i < nLen; ++i)
    {
      if (i > 0)
        aSB.append (", ");
      aSB.append (getAsString (aNL.item (i)));
    }
    aSB.append (')');
    return aSB.toString ();
  }

  @Override
  public void onStart (@NonNull final PSSchema aSchema,
                       @Nullable final PSPhase aActivePhase,
                       @Nullable final String sBaseURI) throws SchematronValidationException
  {
    _log ("onStart (" + aSchema + ", " + aActivePhase + ", " + sBaseURI + ")");
  }

  @Override
  public void onPattern (@NonNull final PSPattern aPattern) throws SchematronValidationException
  {
    _log ("onPattern (" + aPattern + ")");
  }

  @Override
  public void onRuleStart (@NonNull final PSRule aRule, @NonNull final NodeList aContextList)
                                                                                              throws SchematronValidationException
  {
    _log ("onRuleStart (" + aRule + ", " + getAsString (aContextList) + ")");
  }

  @Override
  public void onFiredRule (@NonNull final PSRule aRule,
                           @NonNull final String sContext,
                           @Nonnegative final int nNodeIndex,
                           @Nonnegative final int nNodeCount) throws SchematronValidationException
  {
    _log ("onFiredRule (" + aRule + ", " + sContext + ", " + nNodeIndex + ", " + nNodeCount + ")");
  }

  @NonNull
  @Override
  public EContinue onFailedAssert (@NonNull final PSRule aOwningRule,
                                   @NonNull final PSAssertReport aAssertReport,
                                   @NonNull final String sTestExpression,
                                   @NonNull final Node aRuleMatchingNode,
                                   final int nNodeIndex,
                                   @Nullable final Object aContext,
                                   @Nullable final Exception aEvaluationException) throws SchematronValidationException
  {
    _log ("onFailedAssert (" +
          aOwningRule +
          ", " +
          aAssertReport +
          ", " +
          sTestExpression +
          ", " +
          getAsString (aRuleMatchingNode) +
          ", " +
          nNodeIndex +
          ", " +
          aContext +
          ")");
    return EContinue.CONTINUE;
  }

  @NonNull
  @Override
  public EContinue onSuccessfulReport (@NonNull final PSRule aOwningRule,
                                       @NonNull final PSAssertReport aAssertReport,
                                       @NonNull final String sTestExpression,
                                       @NonNull final Node aRuleMatchingNode,
                                       final int nNodeIndex,
                                       @Nullable final Object aContext,
                                       @Nullable final Exception aEvaluationException) throws SchematronValidationException
  {
    _log ("onSuccessfulReport (" +
          aOwningRule +
          ", " +
          aAssertReport +
          ", " +
          sTestExpression +
          ", " +
          getAsString (aRuleMatchingNode) +
          ", " +
          nNodeIndex +
          ", " +
          aContext +
          ")");
    return EContinue.CONTINUE;
  }

  @Override
  public void onEnd (@NonNull final PSSchema aSchema, @Nullable final PSPhase aActivePhase)
                                                                                            throws SchematronValidationException
  {
    _log ("onEnd (" + aSchema + ", " + aActivePhase + ")");
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("Logger", m_aLogger)
                                       .append ("LogLevel", m_aLogLevel)
                                       .append ("LogPrefix", m_sLogPrefix)
                                       .getToString ();
  }
}
