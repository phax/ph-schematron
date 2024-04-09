/*
 * Copyright (C) 2014-2024 Philip Helger (www.helger.com)
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
package com.helger.schematron.svrl;

import java.util.function.Function;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.error.level.EErrorLevel;
import com.helger.commons.error.level.IErrorLevel;

/**
 * The default implementation of {@link ISVRLErrorLevelDeterminator}.<br/>
 * See also https://schematron.com/document/141.html
 *
 * @author Philip Helger
 */
public class DefaultSVRLErrorLevelDeterminator implements ISVRLErrorLevelDeterminator
{
  private static final Logger LOGGER = LoggerFactory.getLogger (DefaultSVRLErrorLevelDeterminator.class);
  public static final IErrorLevel DEFAULT_ERROR_LEVEL = EErrorLevel.ERROR;
  public static final Function <String, IErrorLevel> UNKNOWN_ERROR_LEVEL_HANDLER = sFlag -> {
    if (sFlag != null)
      LOGGER.warn ("Cannot convert the SVRL flag '" +
                   sFlag +
                   "' to an error level. Using default error level instead!");
    return DEFAULT_ERROR_LEVEL;
  };

  private final Function <String, ? extends IErrorLevel> m_aUnknwownErrorLevelHandler;

  /**
   * Default constructor using {@link #UNKNOWN_ERROR_LEVEL_HANDLER}.
   */
  public DefaultSVRLErrorLevelDeterminator ()
  {
    this (UNKNOWN_ERROR_LEVEL_HANDLER);
  }

  /**
   * Constructor with a custom error level.
   *
   * @param aUnknwownErrorLevelHandler
   *        Custom error level provider. May not be <code>null</code>.
   * @since 5.0.2
   */
  public DefaultSVRLErrorLevelDeterminator (@Nonnull final Function <String, ? extends IErrorLevel> aUnknwownErrorLevelHandler)
  {
    m_aUnknwownErrorLevelHandler = ValueEnforcer.notNull (aUnknwownErrorLevelHandler, "UnknwownErrorLevelHandler");
  }

  /**
   * @return The handler for unknown error levels.
   * @since 5.0.2
   */
  @Nonnull
  public Function <String, ? extends IErrorLevel> getUnknwownErrorLevelHandler ()
  {
    return m_aUnknwownErrorLevelHandler;
  }

  @Nullable
  public static IErrorLevel getDefaultErrorLevelFromString (@Nullable final String sFlag)
  {
    if (sFlag != null)
    {
      if (sFlag.equalsIgnoreCase ("information") ||
          sFlag.equalsIgnoreCase ("info") ||
          sFlag.equalsIgnoreCase ("notice") ||
          sFlag.equalsIgnoreCase ("note") ||
          sFlag.equalsIgnoreCase ("caution") ||
          sFlag.equalsIgnoreCase ("hint") ||
          sFlag.equalsIgnoreCase ("trace") ||
          sFlag.equalsIgnoreCase ("debug"))
        return EErrorLevel.INFO;

      if (sFlag.equalsIgnoreCase ("warning") || sFlag.equalsIgnoreCase ("warn"))
        return EErrorLevel.WARN;

      if (sFlag.equalsIgnoreCase ("error") || sFlag.equalsIgnoreCase ("err") || sFlag.equalsIgnoreCase ("nonfatal"))
        return EErrorLevel.ERROR;

      if (sFlag.equalsIgnoreCase ("fatal") ||
          sFlag.equalsIgnoreCase ("fatal_error") ||
          sFlag.equalsIgnoreCase ("fatal-error") ||
          sFlag.equalsIgnoreCase ("fatalerror"))
        return EErrorLevel.FATAL_ERROR;
    }

    return null;
  }

  @Nonnull
  public IErrorLevel getErrorLevelFromString (@Nullable final String sFlag)
  {
    final IErrorLevel ret = getDefaultErrorLevelFromString (sFlag);
    if (ret != null)
      return ret;

    return m_aUnknwownErrorLevelHandler.apply (sFlag);
  }
}
