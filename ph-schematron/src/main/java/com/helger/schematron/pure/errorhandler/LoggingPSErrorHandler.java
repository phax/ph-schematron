/**
 * Copyright (C) 2014-2020 Philip Helger (www.helger.com)
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
package com.helger.schematron.pure.errorhandler;

import java.util.Locale;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.error.ErrorTextProvider;
import com.helger.commons.error.ErrorTextProvider.EField;
import com.helger.commons.error.IError;
import com.helger.commons.error.IErrorTextProvider;
import com.helger.commons.log.LogHelper;

/**
 * An implementation if {@link IPSErrorHandler} that logs to an SLF4J logger.
 *
 * @author Philip Helger
 */
public class LoggingPSErrorHandler extends AbstractPSErrorHandler
{
  public static final IErrorTextProvider DEFAULT_PS = new ErrorTextProvider ().addItem (EField.ERROR_LEVEL, "[$]")
                                                                              .addItem (EField.ERROR_ID, "[$]")
                                                                              .addItem (EField.ERROR_FIELD_NAME, "[$]")
                                                                              .addItem (EField.ERROR_LOCATION, "@ $")
                                                                              .addItem (EField.ERROR_TEXT, "$")
                                                                              .addItem (EField.ERROR_LINKED_EXCEPTION_CLASS,
                                                                                        "($:")
                                                                              .addItem (EField.ERROR_LINKED_EXCEPTION_MESSAGE,
                                                                                        "$)")
                                                                              .setFieldSeparator (" ");

  private static final Logger LOGGER = LoggerFactory.getLogger (LoggingPSErrorHandler.class);

  private IErrorTextProvider m_aETP = DEFAULT_PS;

  public LoggingPSErrorHandler ()
  {
    super ();
  }

  public LoggingPSErrorHandler (@Nullable final IPSErrorHandler aNestedErrorHandler)
  {
    super (aNestedErrorHandler);
  }

  @Nonnull
  public final IErrorTextProvider getErrorTextProvider ()
  {
    return m_aETP;
  }

  @Nonnull
  public final LoggingPSErrorHandler setErrorTextProvider (@Nonnull final IErrorTextProvider aETP)
  {
    ValueEnforcer.notNull (aETP, "ErrorTextProvider");
    m_aETP = aETP;
    return this;
  }

  @Override
  protected void handleInternally (@Nonnull final IError aError)
  {
    LogHelper.log (LOGGER,
                   aError.getErrorLevel (),
                   m_aETP.getErrorText (aError, Locale.US),
                   aError.getLinkedException ());
  }
}
