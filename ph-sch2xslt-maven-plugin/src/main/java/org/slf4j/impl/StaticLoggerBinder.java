/**
 * Copyright (C) 2014-2015 Philip Helger (www.helger.com)
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
package org.slf4j.impl;

import org.apache.maven.plugin.logging.Log;
import org.slf4j.ILoggerFactory;
import org.slf4j.spi.LoggerFactoryBinder;

/**
 * The binding of {@link ILoggerFactory} class with an actual instance of
 * {@link ILoggerFactory} is performed using information returned by this class.
 * <p>
 * This is what you should do in your Maven plugin (before everything else):
 * 
 * <pre>
 * import org.apache.maven.plugin.AbstractMojo;
 * import org.slf4j.impl.StaticLoggerBinder;
 * 
 * public class MyMojo extends AbstractMojo
 * {
 *   &#064;Override
 *   public void execute ()
 *   {
 *     StaticLoggerBinder.getSingleton ().setMavenLog (getLog ());
 *     // ... all the rest
 *   }
 * }
 * 
 * 
 * 
 * 
 * 
 * </pre>
 * <p>
 * All SLF4J calls will be forwarded to Maven Log.
 * <p>
 * The class is thread-safe.
 * 
 * @author Yegor Bugayenko (yegor@jcabi.com)
 * @version $Id$
 * @since 0.1.6
 * @see <a href="http://www.slf4j.org/faq.html#slf4j_compatible">SLF4J FAQ</a>
 */
public final class StaticLoggerBinder implements LoggerFactoryBinder
{
  /**
   * Declare the version of the SLF4J API this implementation is compiled
   * against. The value of this field is usually modified with each release.
   */
  public static final String REQUESTED_API_VERSION = "1.6";

  /**
   * The unique instance of this class.
   */
  private static final StaticLoggerBinder SINGLETON = new StaticLoggerBinder ();

  /**
   * The {@link ILoggerFactory} instance returned by the
   * {@link #getLoggerFactory()} method should always be the same object.
   */
  private final transient Loggers m_aLoggers = new Loggers ();

  /**
   * Private ctor to avoid direct instantiation of the class.
   */
  private StaticLoggerBinder ()
  {}

  /**
   * Return the singleton of this class.
   * 
   * @return The StaticLoggerBinder singleton
   */
  public static StaticLoggerBinder getSingleton ()
  {
    return StaticLoggerBinder.SINGLETON;
  }

  /**
   * Set Maven Log.
   * 
   * @param log
   *        The log from Maven plugin
   */
  public void setMavenLog (final Log log)
  {
    m_aLoggers.setMavenLog (log);
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public ILoggerFactory getLoggerFactory ()
  {
    return m_aLoggers;
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public String getLoggerFactoryClassStr ()
  {
    return m_aLoggers.getClass ().getName ();
  }
}
