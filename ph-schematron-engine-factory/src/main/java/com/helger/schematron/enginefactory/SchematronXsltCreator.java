/*
 * Copyright (C) 2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.enginefactory;

import java.io.File;
import java.io.OutputStream;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicBoolean;

import javax.xml.XMLConstants;
import javax.xml.transform.ErrorListener;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.w3c.dom.Document;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.CGlobal;
import com.helger.base.concurrent.ExecutorServiceHelper;
import com.helger.base.concurrent.ThreadHelper;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.log.ILogHandler;
import com.helger.base.string.StringHelper;
import com.helger.base.timing.StopWatch;
import com.helger.base.wrapper.Wrapper;
import com.helger.collection.commons.CommonsLinkedHashMap;
import com.helger.collection.commons.ICommonsMap;
import com.helger.io.file.FileHelper;
import com.helger.io.resource.FileSystemResource;
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.svrl.CSVRL;
import com.helger.xml.XMLHelper;
import com.helger.xml.namespace.MapBasedNamespaceContext;
import com.helger.xml.serialize.write.IXMLWriterSettings;
import com.helger.xml.serialize.write.XMLWriter;
import com.helger.xml.serialize.write.XMLWriterSettings;

/**
 * Converts Schematron files to XSLT files, as done by the Maven goal <code>convert</code>, the Ant
 * task <code>schematron-convert</code> and the command line client. A Schematron can also be
 * converted in memory, independent of the engine, with
 * {@link #createXsltDocument(IReadableResource, ErrorListener)} and
 * {@link #createXsltString(IReadableResource, ErrorListener)}.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@NotThreadSafe
public class SchematronXsltCreator
{
  /** The interval of the progress messages in seconds */
  public static final int PROGRESS_INTERVAL_SECONDS = 5;

  private final SchematronEngineSettings m_aSettings;
  private final ILogHandler m_aLogger;
  private String m_sXsltHeader;
  private boolean m_bShowProgress;

  /**
   * @param aSettings
   *        The engine settings. The engine must be one where
   *        {@link SchematronEngineFactory#isXsltCreating(com.helger.schematron.ESchematronEngine)}
   *        is <code>true</code>. May not be <code>null</code>.
   * @param aLogger
   *        The logger to use. May not be <code>null</code>.
   */
  public SchematronXsltCreator (@NonNull final SchematronEngineSettings aSettings,
                                @NonNull final ILogHandler aLogger)
  {
    ValueEnforcer.notNull (aSettings, "Settings");
    ValueEnforcer.notNull (aLogger, "Logger");
    m_aSettings = aSettings;
    m_aLogger = aLogger;
  }

  /**
   * @param sXsltHeader
   *        A text that is added as an XML comment before the root element of each created XSLT.
   *        May be <code>null</code>.
   * @return this for chaining
   */
  @NonNull
  public SchematronXsltCreator setXsltHeader (@Nullable final String sXsltHeader)
  {
    m_sXsltHeader = sXsltHeader;
    return this;
  }

  /**
   * @param bShowProgress
   *        <code>true</code> to log an info message every {@link #PROGRESS_INTERVAL_SECONDS}
   *        seconds while a conversion is running.
   * @return this for chaining
   */
  @NonNull
  public SchematronXsltCreator setShowProgress (final boolean bShowProgress)
  {
    m_bShowProgress = bShowProgress;
    return this;
  }

  private static void _addXsltHeader (@NonNull final Document aXsltDoc, @NonNull final String sXsltHeader)
  {
    // Inject the header into the XSLT
    aXsltDoc.insertBefore (aXsltDoc.createComment (sXsltHeader), aXsltDoc.getDocumentElement ());
  }

  @NonNull
  private static IXMLWriterSettings _prepareForWriting (@NonNull final Document aXsltDoc,
                                                        @Nullable final String sXsltHeader)
  {
    if (StringHelper.isNotEmpty (sXsltHeader))
      _addXsltHeader (aXsltDoc, sXsltHeader);

    // Add all namespaces from XSLT document root
    final String sNSPrefix = XMLConstants.XMLNS_ATTRIBUTE + ":";
    final ICommonsMap <String, String> aMapFromXml = new CommonsLinkedHashMap <> ();
    XMLHelper.forAllAttributes (aXsltDoc.getDocumentElement (), (sAttrName, sAttrValue) -> {
      if (sAttrName.startsWith (sNSPrefix))
        aMapFromXml.put (sAttrName.substring (sNSPrefix.length ()), sAttrValue);
    });

    final MapBasedNamespaceContext aNSContext = new MapBasedNamespaceContext ();
    if (!aMapFromXml.containsKey ("svrl"))
      aNSContext.addMapping ("svrl", CSVRL.SVRL_NAMESPACE_URI);
    for (final var e : aMapFromXml.entrySet ())
      aNSContext.addMapping (e.getKey (), e.getValue ());

    return new XMLWriterSettings ().setNamespaceContext (aNSContext).setPutNamespaceContextPrefixesInRoot (true);
  }

  /**
   * Write an XSLT document with all namespaces of the root element declared on the root element.
   *
   * @param aXsltDoc
   *        The XSLT document to write. May not be <code>null</code>.
   * @param sXsltHeader
   *        An optional header that is added as an XML comment. May be <code>null</code>.
   * @param aXsltFile
   *        The file to write to. May not be <code>null</code>.
   * @throws SchematronToolException
   *         If the file cannot be opened
   */
  public static void writeXsltDocument (@NonNull final Document aXsltDoc,
                                        @Nullable final String sXsltHeader,
                                        @NonNull final File aXsltFile) throws SchematronToolException
  {
    final IXMLWriterSettings aXWS = _prepareForWriting (aXsltDoc, sXsltHeader);

    final OutputStream aOS = FileHelper.getOutputStream (aXsltFile);
    if (aOS == null)
      throw new SchematronToolException ("Failed to open output stream for file '" + aXsltFile.getAbsolutePath () + "'");
    if (XMLWriter.writeToStream (aXsltDoc, aOS, aXWS).isFailure ())
      throw new SchematronToolException ("Failed to write XSLT file '" + aXsltFile.getAbsolutePath () + "'");
  }

  /**
   * Get an XSLT document as a string, the same way {@link #writeXsltDocument(Document, String, File)}
   * writes it.
   *
   * @param aXsltDoc
   *        The XSLT document to serialise. May not be <code>null</code>.
   * @param sXsltHeader
   *        An optional header that is added as an XML comment. May be <code>null</code>.
   * @return The XSLT as a string. Never <code>null</code>.
   * @throws SchematronToolException
   *         If serialising fails
   */
  @NonNull
  public static String getXsltDocumentAsString (@NonNull final Document aXsltDoc,
                                                @Nullable final String sXsltHeader) throws SchematronToolException
  {
    final String ret = XMLWriter.getNodeAsString (aXsltDoc, _prepareForWriting (aXsltDoc, sXsltHeader));
    if (ret == null)
      throw new SchematronToolException ("Failed to serialise the XSLT document");
    return ret;
  }

  @NonNull
  private Document _createXsltDocument (@NonNull final IReadableResource aSchematronRes,
                                        @NonNull final String sDisplayName,
                                        @Nullable final ErrorListener aErrorListener) throws SchematronToolException
  {
    m_aLogger.debug ("Compiling Schematron '" + sDisplayName + "' with engine " + m_aSettings.getEngine ().getID ());

    final Document aXsltDoc;
    try
    {
      aXsltDoc = SchematronEngineFactory.createXsltDocument (aSchematronRes, m_aSettings, aErrorListener);
    }
    catch (final SchematronToolException ex)
    {
      throw ex;
    }
    catch (final Exception ex)
    {
      throw new SchematronToolException ("Failed to convert '" + sDisplayName + "' to XSLT", ex);
    }
    if (aXsltDoc == null)
      throw new SchematronToolException ("Failed to convert '" +
                                         sDisplayName +
                                         "': the Schematron resource is invalid");

    if (StringHelper.isNotEmpty (m_sXsltHeader))
      _addXsltHeader (aXsltDoc, m_sXsltHeader);
    return aXsltDoc;
  }

  @NonNull
  private Document _createXsltDocumentWithProgress (@NonNull final IReadableResource aSchematronRes,
                                                    @NonNull final String sDisplayName,
                                                    @Nullable final ErrorListener aErrorListener) throws SchematronToolException
  {
    // Run conversion in one thread and run another thread that logs the time
    final Wrapper <Document> aResult = new Wrapper <> ();
    final Wrapper <SchematronToolException> aException = new Wrapper <> ();
    final ExecutorService aES = Executors.newSingleThreadExecutor ();
    aES.submit ( () -> {
      try
      {
        aResult.set (_createXsltDocument (aSchematronRes, sDisplayName, aErrorListener));
      }
      catch (final SchematronToolException ex)
      {
        aException.set (ex);
      }
      catch (final RuntimeException ex)
      {
        // Would otherwise be swallowed by the executor
        aException.set (new SchematronToolException ("Failed to convert '" + sDisplayName + "' to XSLT", ex));
      }
    });

    final StopWatch aSW = StopWatch.createdStarted ();
    final AtomicBoolean aLoggedAnything = new AtomicBoolean (false);
    final Thread aProgressThread = new Thread ( () -> {
      long nLastSecs = 0;
      while (!Thread.currentThread ().isInterrupted ())
      {
        if (ThreadHelper.sleep (500).isSuccess ())
        {
          final long nDurationSecs = aSW.getMillis () / CGlobal.MILLISECONDS_PER_SECOND;
          // Log only every x seconds
          if (nDurationSecs >= nLastSecs + PROGRESS_INTERVAL_SECONDS)
          {
            m_aLogger.info ("Schematron conversion of '" +
                            sDisplayName +
                            "' already takes " +
                            nDurationSecs +
                            " seconds - please wait...");
            nLastSecs = nDurationSecs;
            aLoggedAnything.set (true);
          }
        }
      }
    });
    aProgressThread.setDaemon (true);
    aProgressThread.start ();
    ExecutorServiceHelper.shutdownAndWaitUntilAllTasksAreFinished (aES);
    aProgressThread.interrupt ();
    if (aLoggedAnything.get ())
    {
      // Log finalization of conversion if it took longer
      m_aLogger.info ("Schematron conversion of '" +
                      sDisplayName +
                      "' was finalized after " +
                      aSW.getMillis () / CGlobal.MILLISECONDS_PER_SECOND +
                      " seconds");
    }

    if (aException.isSet ())
      throw aException.get ();
    return aResult.get ();
  }

  @NonNull
  private Document _createXsltDocumentMaybeProgress (@NonNull final IReadableResource aSchematronRes,
                                                     @NonNull final String sDisplayName,
                                                     @Nullable final ErrorListener aErrorListener) throws SchematronToolException
  {
    if (m_bShowProgress)
      return _createXsltDocumentWithProgress (aSchematronRes, sDisplayName, aErrorListener);
    return _createXsltDocument (aSchematronRes, sDisplayName, aErrorListener);
  }

  /**
   * Convert a Schematron to an XSLT document in memory, with the engine of the settings. This works
   * the same for all engines where
   * {@link SchematronEngineFactory#isXsltCreating(com.helger.schematron.ESchematronEngine)} is
   * <code>true</code>, and is the code path that {@link #convertFile(File, File, ErrorListener)}
   * uses. The XSLT header (if set) is added as an XML comment before the root element. For a
   * Schematron that is only available as a byte array or an input stream use a
   * {@link com.helger.io.resource.inmemory.ReadableResourceByteArray}.
   *
   * @param aSchematronRes
   *        The Schematron to convert. May not be <code>null</code>.
   * @param aErrorListener
   *        The error listener of the XSLT pipeline. May be <code>null</code>.
   * @return The created XSLT document. Never <code>null</code>.
   * @throws SchematronToolException
   *         If the Schematron is invalid or the conversion fails
   * @since 11.1.0
   */
  @NonNull
  public Document createXsltDocument (@NonNull final IReadableResource aSchematronRes,
                                      @Nullable final ErrorListener aErrorListener) throws SchematronToolException
  {
    ValueEnforcer.notNull (aSchematronRes, "SchematronRes");

    return _createXsltDocumentMaybeProgress (aSchematronRes, aSchematronRes.getResourceID (), aErrorListener);
  }

  /**
   * Convert a Schematron to an XSLT in memory and serialise it, the same way
   * {@link #convertFile(File, File, ErrorListener)} writes it.
   *
   * @param aSchematronRes
   *        The Schematron to convert. May not be <code>null</code>.
   * @param aErrorListener
   *        The error listener of the XSLT pipeline. May be <code>null</code>.
   * @return The created XSLT as a string. Never <code>null</code>.
   * @throws SchematronToolException
   *         If the Schematron is invalid, the conversion fails or serialising fails
   * @see #createXsltDocument(IReadableResource, ErrorListener)
   * @since 11.1.0
   */
  @NonNull
  public String createXsltString (@NonNull final IReadableResource aSchematronRes,
                                  @Nullable final ErrorListener aErrorListener) throws SchematronToolException
  {
    return getXsltDocumentAsString (createXsltDocument (aSchematronRes, aErrorListener), null);
  }

  /**
   * Convert a single Schematron file to an XSLT file. The parent directory of the XSLT file is
   * created if needed.
   *
   * @param aSchematronFile
   *        The Schematron file to convert. May not be <code>null</code>.
   * @param aXsltFile
   *        The XSLT file to write. May not be <code>null</code>.
   * @param aErrorListener
   *        The error listener of the XSLT pipeline. May be <code>null</code>.
   * @throws SchematronToolException
   *         If the conversion or writing fails
   */
  public void convertFile (@NonNull final File aSchematronFile,
                           @NonNull final File aXsltFile,
                           @Nullable final ErrorListener aErrorListener) throws SchematronToolException
  {
    ValueEnforcer.notNull (aSchematronFile, "SchematronFile");
    ValueEnforcer.notNull (aXsltFile, "XsltFile");

    final File aXsltFileDirectory = aXsltFile.getParentFile ();
    if (aXsltFileDirectory != null && !aXsltFileDirectory.exists ())
    {
      m_aLogger.debug ("Creating directory '" + aXsltFileDirectory.getPath () + "'");
      if (!aXsltFileDirectory.mkdirs ())
        throw new SchematronToolException ("Failed to convert '" +
                                           aSchematronFile.getPath () +
                                           "' because directory '" +
                                           aXsltFileDirectory.getPath () +
                                           "' could not be created");
    }

    final Document aXsltDoc = _createXsltDocumentMaybeProgress (new FileSystemResource (aSchematronFile),
                                                                aSchematronFile.getPath (),
                                                                aErrorListener);
    writeXsltDocument (aXsltDoc, null, aXsltFile);
    m_aLogger.debug ("Finished creating XSLT file '" + aXsltFile.getPath () + "'");
  }
}
