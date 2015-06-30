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
import org.slf4j.helpers.FormattingTuple;
import org.slf4j.helpers.MarkerIgnoringBase;
import org.slf4j.helpers.MessageFormatter;

/**
 * Implementation of {@link org.slf4j.Logger} transforming SLF4J messages to
 * Maven log messages.
 * <p>
 * The class has too many methods, but we can't do anything with this since the
 * parent class requires us to implement them all.
 * <p>
 * The class is thread-safe.
 * 
 * @author Yegor Bugayenko (yegor@jcabi.com)
 * @version $Id$
 * @since 0.1.6
 * @see <a href="http://www.slf4j.org/faq.html#slf4j_compatible">SLF4J FAQ</a>
 */
final class Slf4jAdapter extends MarkerIgnoringBase
{
  /**
   * Serialization ID.
   */
  public static final long serialVersionUID = 0x12C0976798AB5439L;

  /**
   * The log to use.
   */
  private transient Log m_aMavenLog;

  /**
   * Set Maven log.
   * <p>
   * Class variable is used as a synchronization lock, mostly because only one
   * instance of this class may exist.
   * 
   * @param log
   *        The log to set
   */
  public void setMavenLog (final Log log)
  {
    synchronized (Slf4jAdapter.class)
    {
      m_aMavenLog = log;
    }
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public String getName ()
  {
    return getClass ().getName ();
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public boolean isTraceEnabled ()
  {
    return false;
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public void trace (final String msg)
  {
    _log ().debug (msg);
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public void trace (final String format, final Object arg)
  {
    _log ().debug (_format (format, arg));
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public void trace (final String format, final Object first, final Object second)
  {
    _log ().debug (_format (format, first, second));
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public void trace (final String format, final Object... array)
  {
    _log ().debug (_format (format, array));
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public void trace (final String msg, final Throwable thr)
  {
    _log ().debug (msg, thr);
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public boolean isDebugEnabled ()
  {
    return _log ().isDebugEnabled ();
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public void debug (final String msg)
  {
    _log ().debug (msg);
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public void debug (final String format, final Object arg)
  {
    _log ().debug (_format (format, arg));
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public void debug (final String format, final Object first, final Object second)
  {
    _log ().debug (_format (format, first, second));
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public void debug (final String format, final Object... array)
  {
    _log ().debug (_format (format, array));
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public void debug (final String msg, final Throwable thr)
  {
    _log ().debug (msg, thr);
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public boolean isInfoEnabled ()
  {
    return true;
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public void info (final String msg)
  {
    _log ().info (msg);
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public void info (final String format, final Object arg)
  {
    _log ().info (_format (format, arg));
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public void info (final String format, final Object first, final Object second)
  {
    _log ().info (_format (format, first, second));
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public void info (final String format, final Object... array)
  {
    _log ().info (_format (format, array));
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public void info (final String msg, final Throwable thr)
  {
    _log ().info (msg, thr);
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public boolean isWarnEnabled ()
  {
    return true;
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public void warn (final String msg)
  {
    _log ().warn (msg);
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public void warn (final String format, final Object arg)
  {
    _log ().warn (_format (format, arg));
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public void warn (final String format, final Object... array)
  {
    _log ().warn (_format (format, array));
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public void warn (final String format, final Object first, final Object second)
  {
    _log ().warn (_format (format, first, second));
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public void warn (final String msg, final Throwable thr)
  {
    _log ().warn (msg, thr);
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public boolean isErrorEnabled ()
  {
    return true;
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public void error (final String msg)
  {
    _log ().error (msg);
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public void error (final String format, final Object arg)
  {
    _log ().error (_format (format, arg));
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public void error (final String format, final Object first, final Object second)
  {
    _log ().error (_format (format, first, second));
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public void error (final String format, final Object... array)
  {
    _log ().error (_format (format, array));
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public void error (final String msg, final Throwable thr)
  {
    _log ().error (msg, thr);
  }

  /**
   * Get Maven Log.
   * 
   * @return The log from Maven plugin
   */
  private Log _log ()
  {
    if (m_aMavenLog == null)
      throw new IllegalStateException ("initialize StaticLoggerBinder with #setMavenLog() first");
    return m_aMavenLog;
  }

  /**
   * Format with one object.
   * 
   * @param format
   *        Format to use
   * @param arg
   *        One argument
   * @return The message
   */
  private String _format (final String format, final Object arg)
  {
    final FormattingTuple tuple = MessageFormatter.format (format, arg);
    return tuple.getMessage ();
  }

  /**
   * Format with two objects.
   * 
   * @param format
   *        Format to use
   * @param first
   *        First argument
   * @param second
   *        Second argument
   * @return The message
   */
  private String _format (final String format, final Object first, final Object second)
  {
    final FormattingTuple tuple = MessageFormatter.format (format, first, second);
    return tuple.getMessage ();
  }

  /**
   * Format with array.
   * 
   * @param format
   *        Format to use
   * @param array
   *        List of arguments
   * @return The message
   */
  private String _format (final String format, final Object [] array)
  {
    final FormattingTuple tuple = MessageFormatter.format (format, array);
    return tuple.getMessage ();
  }
}
