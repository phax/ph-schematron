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
import org.slf4j.Logger;

/**
 * Implementation of {@link ILoggerFactory} returning the appropriate named
 * Slf4jAdapter instance.
 * <p>
 * The class is thread-safe.
 * </p>
 *
 * @author Yegor Bugayenko (yegor@jcabi.com)
 * @version $Id$
 * @since 0.1.6
 * @see <a href="http://www.slf4j.org/faq.html#slf4j_compatible">SLF4J FAQ</a>
 */
final class Loggers implements ILoggerFactory
{
  /**
   * The adapter between SLF4J and Maven.
   */
  private final transient Slf4jAdapter m_aAdapter = new Slf4jAdapter ();

  /**
   * {@inheritDoc}
   */
  @Override
  public Logger getLogger (final String name)
  {
    if (name == null)
      throw new IllegalArgumentException ("logger name can't be NULL");
    return m_aAdapter;
  }

  /**
   * Set Maven log.
   *
   * @param log
   *        The log to set
   */
  public void setMavenLog (final Log log)
  {
    m_aAdapter.setMavenLog (log);
  }
}
