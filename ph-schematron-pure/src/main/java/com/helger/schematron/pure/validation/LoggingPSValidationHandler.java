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

import javax.annotation.Nonnegative;
import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.error.level.EErrorLevel;
import com.helger.commons.error.level.IErrorLevel;
import com.helger.commons.log.LogHelper;
import com.helger.commons.state.EContinue;
import com.helger.commons.string.StringHelper;
import com.helger.commons.string.ToStringGenerator;
import com.helger.schematron.pure.model.PSAssertReport;
import com.helger.schematron.pure.model.PSPattern;
import com.helger.schematron.pure.model.PSPhase;
import com.helger.schematron.pure.model.PSRule;
import com.helger.schematron.pure.model.PSSchema;

import net.sf.saxon.s9api.XdmItem;
import net.sf.saxon.s9api.XdmNode;
import net.sf.saxon.s9api.XdmValue;

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
  public LoggingPSValidationHandler (@Nonnull final Logger aLogger)
  {
    ValueEnforcer.notNull (aLogger, "Logger");
    m_aLogger = aLogger;
  }

  @Nonnull
  public final Logger getLogger ()
  {
    return m_aLogger;
  }

  @Nonnull
  public final IErrorLevel getLogLevel ()
  {
    return m_aLogLevel;
  }

  @Nonnull
  public final LoggingPSValidationHandler setLogLevel (@Nonnull final IErrorLevel aLogLevel)
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

  @Nonnull
  public final LoggingPSValidationHandler setLogPrefix (@Nullable final String sLogPrefix)
  {
    m_sLogPrefix = sLogPrefix;
    return this;
  }

  private void _log (@Nonnull final String sMsg)
  {
    LogHelper.log (m_aLogger, m_aLogLevel, StringHelper.getConcatenatedOnDemand (m_sLogPrefix, sMsg));
  }

  @Nonnull
  public static String getAsString (@Nonnull final XdmValue aNode)
  {
    // TODO XdmValue toString
    return aNode.toString ();
    // return XMLDebug.getNodeTypeAsString (aNode.getNodeType ()) + ": " + aNode.toString ();
  }

  @Nonnull
  public static String getAsString (@Nonnull final XdmItem aNL)
  {
    // TODO XdmItem toString
    return aNL.toString ();
    /*
     * final int nLen = aNL.getLength (); final StringBuilder aSB = new StringBuilder (); aSB.append
     * ("NodeList[").append (nLen).append ("]("); for (int i = 0; i < nLen; ++i) { if (i > 0)
     * aSB.append (", "); aSB.append (getAsString (aNL.item (i))); } aSB.append (')'); return
     * aSB.toString ();
     */
  }

  @Override
  public void onStart (@Nonnull final PSSchema aSchema,
                       @Nullable final PSPhase aActivePhase,
                       @Nullable final String sBaseURI) throws SchematronValidationException
  {
    _log ("onStart (" + aSchema + ", " + aActivePhase + ", " + sBaseURI + ")");
  }

  @Override
  public void onPattern (@Nonnull final PSPattern aPattern) throws SchematronValidationException
  {
    _log ("onPattern (" + aPattern + ")");
  }

  @Override
  public void onRuleStart (@Nonnull final PSRule aRule, @Nonnull final XdmValue aContextList)
                                                                                              throws SchematronValidationException
  {
    _log ("onRuleStart (" + aRule + ", " + getAsString (aContextList) + ")");
  }

  @Override
  public void onFiredRule (@Nonnull final PSRule aRule,
                           @Nonnull final String sContext,
                           @Nonnegative final int nNodeIndex,
                           @Nonnegative final int nNodeCount) throws SchematronValidationException
  {
    _log ("onFiredRule (" + aRule + ", " + sContext + ", " + nNodeIndex + ", " + nNodeCount + ")");
  }

  @Nonnull
  @Override
  public EContinue onFailedAssert (@Nonnull final PSRule aOwningRule,
                                   @Nonnull final PSAssertReport aAssertReport,
                                   @Nonnull final String sTestExpression,
                                   @Nonnull final XdmNode aRuleMatchingNode,
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

  @Nonnull
  @Override
  public EContinue onSuccessfulReport (@Nonnull final PSRule aOwningRule,
                                       @Nonnull final PSAssertReport aAssertReport,
                                       @Nonnull final String sTestExpression,
                                       @Nonnull final XdmNode aRuleMatchingNode,
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
  public void onEnd (@Nonnull final PSSchema aSchema, @Nullable final PSPhase aActivePhase)
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
