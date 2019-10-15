package com.helger.schematron.pure.validation;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.state.EContinue;
import com.helger.schematron.pure.model.PSAssertReport;
import com.helger.schematron.pure.model.PSPattern;
import com.helger.schematron.pure.model.PSPhase;
import com.helger.schematron.pure.model.PSRule;
import com.helger.schematron.pure.model.PSSchema;

/**
 * A logging implementation of {@link IPSValidationHandler}
 * 
 * @author Philip Helger
 * @since 5.3.0
 */
public class LoggingPSValidationHandler implements IPSValidationHandler
{
  private final Logger m_aLogger;

  public LoggingPSValidationHandler ()
  {
    this (LoggerFactory.getLogger (LoggingPSValidationHandler.class));
  }

  public LoggingPSValidationHandler (@Nonnull final Logger aLogger)
  {
    ValueEnforcer.notNull (aLogger, "Logger");
    m_aLogger = aLogger;
  }

  @Nonnull
  protected final Logger getLogger ()
  {
    return m_aLogger;
  }

  public void onStart (@Nonnull final PSSchema aSchema,
                       @Nullable final PSPhase aActivePhase,
                       @Nullable final String sBaseURI) throws SchematronValidationException
  {
    m_aLogger.info ("onStart (" + aSchema + ", " + aActivePhase + ", " + sBaseURI + ")");
  }

  public void onPattern (@Nonnull final PSPattern aPattern) throws SchematronValidationException
  {
    m_aLogger.info ("onPattern (" + aPattern + ")");
  }

  public void onRuleStart (@Nonnull final PSRule aRule,
                           @Nonnull final NodeList aContextList) throws SchematronValidationException
  {
    m_aLogger.info ("onRuleStart (" + aRule + ", " + aContextList + ")");
  }

  public void onFiredRule (@Nonnull final PSRule aRule,
                           @Nonnull final String sContext) throws SchematronValidationException
  {
    m_aLogger.info ("onFiredRule (" + aRule + ", " + sContext + ")");
  }

  @Nonnull
  public EContinue onFailedAssert (@Nonnull final PSAssertReport aAssertReport,
                                   @Nonnull final String sTestExpression,
                                   @Nonnull final Node aRuleMatchingNode,
                                   final int nNodeIndex,
                                   @Nullable final Object aContext) throws SchematronValidationException
  {
    m_aLogger.info ("onFailedAssert (" +
                    aAssertReport +
                    ", " +
                    sTestExpression +
                    ", " +
                    aRuleMatchingNode +
                    ", " +
                    nNodeIndex +
                    ", " +
                    aContext +
                    ")");
    return EContinue.CONTINUE;
  }

  @Nonnull
  public EContinue onSuccessfulReport (@Nonnull final PSAssertReport aAssertReport,
                                       @Nonnull final String sTestExpression,
                                       @Nonnull final Node aRuleMatchingNode,
                                       final int nNodeIndex,
                                       @Nullable final Object aContext) throws SchematronValidationException
  {
    m_aLogger.info ("onSuccessfulReport (" +
                    aAssertReport +
                    ", " +
                    sTestExpression +
                    ", " +
                    aRuleMatchingNode +
                    ", " +
                    nNodeIndex +
                    ", " +
                    aContext +
                    ")");
    return EContinue.CONTINUE;
  }

  public void onEnd (@Nonnull final PSSchema aSchema,
                     @Nullable final PSPhase aActivePhase) throws SchematronValidationException
  {
    m_aLogger.info ("onSuccessfulReport (" + aSchema + ", " + aActivePhase + ")");
  }
}
