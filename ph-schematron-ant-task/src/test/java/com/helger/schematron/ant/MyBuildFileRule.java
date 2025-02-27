/*
 * Copyright (C) 2017-2025 Philip Helger (www.helger.com)
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
package com.helger.schematron.ant;

import java.io.File;
import java.io.OutputStream;
import java.io.PrintStream;

import javax.annotation.Nonnull;

import org.apache.tools.ant.BuildEvent;
import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.BuildListener;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.ProjectHelper;
import org.apache.tools.ant.util.ProcessUtil;
import org.junit.rules.ExternalResource;

/**
 * Provides access for JUnit tests to execute Ant targets and access execution
 * details (i.e logs). Example usage: <code>
 * public class MyTest {
 *
 *     \@Rule
 *     public BuildFileRule rule = new BuildFileRule();
 *
 *     \@Before
 *     public void setUp() {
 *         rule.configureProject("my/and/file.xml");
 *     }
 *
 *     \@Test
 *     public void testSuccess() {
 *         rule.executeTarget("passingTaget");
 *         assertEquals("Incorrect log message", "[taskName] Action Complete", rule.getLog());
 *     }
 *
 *     \@Test
 *     public void testException() {
 *         try {
 *             rule.executeTarget("failingTarget");
 *             fail("Target should have thrown a BuildException");
 *         } catch (BuildException ex) {
 *             assertContains("Exception did not contain correct text", "Could not find compiler on classpath", ex.getMessage());
 *         }
 *     }
 *
 * }
 * </code>
 */
public final class MyBuildFileRule extends ExternalResource
{
  private Project project;
  private StringBuffer logBuffer;
  private StringBuffer fullLogBuffer;
  private StringBuffer outputBuffer;
  private StringBuffer errorBuffer;

  /**
   * Tidies up following a test execution. If the currently configured project
   * has a <code>tearDown</code> target then this will automatically be called,
   * otherwise this method will not perform any actions.
   */
  @Override
  protected void after ()
  {
    if (project == null)
    {
      // configureProject has not been called - nothing we can clean-up
      return;
    }
    final String tearDown = "tearDown";
    if (project.getTargets ().containsKey (tearDown))
    {
      project.executeTarget (tearDown);
    }
  }

  /**
   * Gets the INFO, WARNING and ERROR message from the current execution, unless
   * the logging level is set above any of these level in which case the message
   * is excluded. This is only valid if configureProject() has been called.
   *
   * @return The INFO, WARN and ERROR messages in the log.
   */
  public String getLog ()
  {
    return logBuffer.toString ();
  }

  /**
   * Gets any messages that have been logged during the current execution,
   * unless the logging level has been set above the log level defined in the
   * message. Only valid if configureProject() has been called.
   *
   * @return the content of the log.
   */
  public String getFullLog ()
  {
    return fullLogBuffer.toString ();
  }

  /**
   * Provides all output sent to the System.out stream during the current
   * execution.
   *
   * @return all output messages in a single string, normalised to have platform
   *         independent line breaks.
   */
  public String getOutput ()
  {
    return _cleanBuffer (outputBuffer);
  }

  /**
   * Provides all output sent to the System.err stream during the current
   * execution.
   *
   * @return all error messages in a single string, normalised to have platform
   *         independent line breaks.
   */
  public String getError ()
  {
    return _cleanBuffer (errorBuffer);
  }

  private String _cleanBuffer (final StringBuffer buffer)
  {
    final StringBuilder cleanedBuffer = new StringBuilder (buffer.length ());
    for (int i = 0; i < buffer.length (); i++)
    {
      final char ch = buffer.charAt (i);
      if (ch != '\r')
        cleanedBuffer.append (ch);
    }
    return cleanedBuffer.toString ();
  }

  /**
   * Sets up to run the named project
   *
   * @param filename
   *        name of project file to run
   * @throws BuildException
   *         on error
   */
  public void configureProject (final String filename) throws BuildException
  {
    configureProject (filename, Project.MSG_DEBUG);
  }

  /**
   * Sets up to run the named project
   *
   * @param filename
   *        name of project file to run
   * @param logLevel
   *        Log level
   * @throws BuildException
   *         on error
   */
  public void configureProject (final String filename, final int logLevel) throws BuildException
  {
    logBuffer = new StringBuffer ();
    fullLogBuffer = new StringBuffer ();
    project = new Project ();
    project.init ();
    final File antFile = new File (System.getProperty ("root"), filename);
    project.setProperty ("ant.processid", ProcessUtil.getProcessId ("<Process>"));
    project.setProperty ("ant.threadname", Thread.currentThread ().getName ());
    project.setUserProperty ("ant.file", antFile.getAbsolutePath ());
    project.addBuildListener (new AntTestListener (logLevel));
    ProjectHelper.configureProject (project, antFile);
  }

  /**
   * Executes a target in the configured Ant build file. Requires
   * #configureProject() to have been invoked before this call.
   *
   * @param targetName
   *        the target in the currently configured build file to run.
   */
  public void executeTarget (final String targetName)
  {
    outputBuffer = new StringBuffer ();
    final PrintStream out = new PrintStream (new AntOutputStream (outputBuffer));
    errorBuffer = new StringBuffer ();
    final PrintStream err = new PrintStream (new AntOutputStream (errorBuffer));
    logBuffer = new StringBuffer ();
    fullLogBuffer = new StringBuffer ();

    /*
     * we synchronize to protect our custom output streams from being overridden
     * by other tests executing targets concurrently. Ultimately this would only
     * happen if we ran a multi-threaded test executing multiple targets at
     * once, and this protection doesn't prevent a target from internally
     * modifying the output stream during a test - but at least this scenario is
     * fairly deterministic so easier to troubleshoot.
     */
    synchronized (System.out)
    {
      final PrintStream sysOut = System.out;
      final PrintStream sysErr = System.err;
      sysOut.flush ();
      sysErr.flush ();
      try
      {
        System.setOut (out);
        System.setErr (err);
        project.executeTarget (targetName);
      }
      finally
      {
        System.setOut (sysOut);
        System.setErr (sysErr);
      }
    }
  }

  /**
   * Get the project which has been configured for a test.
   *
   * @return the Project instance for this test.
   */
  public Project getProject ()
  {
    return project;
  }

  /**
   * An output stream which saves contents to our buffer.
   */
  protected static class AntOutputStream extends OutputStream
  {
    private final StringBuffer m_aSB;

    public AntOutputStream (final StringBuffer buffer)
    {
      m_aSB = buffer;
    }

    @Override
    public void write (final int b)
    {
      m_aSB.append ((char) b);
    }
  }

  /**
   * Our own personal build listener.
   */
  private class AntTestListener implements BuildListener
  {
    private final int m_nLogLevel;

    /**
     * Constructs a test listener which will ignore log events above the given
     * level.
     *
     * @param logLevel
     *        Log level
     */
    public AntTestListener (final int logLevel)
    {
      m_nLogLevel = logLevel;
    }

    /**
     * Fired before any targets are started.
     */
    public void buildStarted (final BuildEvent event)
    {}

    /**
     * Fired after the last target has finished. This event will still be thrown
     * if an error occurred during the build.
     *
     * @see BuildEvent#getException()
     */
    public void buildFinished (final BuildEvent event)
    {}

    /**
     * Fired when a target is started.
     *
     * @see BuildEvent#getTarget()
     */
    public void targetStarted (final BuildEvent event)
    {}

    /**
     * Fired when a target has finished. This event will still be thrown if an
     * error occurred during the build.
     *
     * @see BuildEvent#getException()
     */
    public void targetFinished (final BuildEvent event)
    {}

    /**
     * Fired when a task is started.
     *
     * @see BuildEvent#getTask()
     */
    public void taskStarted (final BuildEvent event)
    {}

    /**
     * Fired when a task has finished. This event will still be throw if an
     * error occurred during the build.
     *
     * @see BuildEvent#getException()
     */
    public void taskFinished (final BuildEvent event)
    {}

    /**
     * Fired whenever a message is logged.
     *
     * @see BuildEvent#getMessage()
     * @see BuildEvent#getPriority()
     */
    public void messageLogged (final BuildEvent event)
    {
      if (event.getPriority () > m_nLogLevel)
      {
        // ignore event
        return;
      }

      if (event.getPriority () == Project.MSG_INFO || event.getPriority () == Project.MSG_WARN || event.getPriority () == Project.MSG_ERR)
      {
        logBuffer.append (event.getMessage ()).append ('\n');
      }
      fullLogBuffer.append (event.getMessage ()).append ('\n');
    }
  }

  @Nonnull
  public File getOutputDir ()
  {
    return new File (getProject ().getProperty ("output"));
  }
}
