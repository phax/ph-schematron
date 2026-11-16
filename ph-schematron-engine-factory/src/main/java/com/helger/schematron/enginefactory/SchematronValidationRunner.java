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
import java.util.Collection;
import java.util.Locale;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.w3c.dom.Document;
import org.xml.sax.EntityResolver;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.log.ILogHandler;
import com.helger.base.string.StringHelper;
import com.helger.base.string.StringImplode;
import com.helger.base.wrapper.Wrapper;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.CommonsHashSet;
import com.helger.collection.commons.ICommonsList;
import com.helger.collection.commons.ICommonsSet;
import com.helger.diagnostics.error.ErrorTextProvider;
import com.helger.diagnostics.error.level.EErrorLevel;
import com.helger.io.file.FileIOError;
import com.helger.io.file.FileOperationManager;
import com.helger.io.resource.FileSystemResource;
import com.helger.schematron.ISchematronResource;
import com.helger.schematron.svrl.AbstractSVRLMessage;
import com.helger.schematron.svrl.ISVRLErrorLevelDeterminator;
import com.helger.schematron.svrl.SVRLFailedAssert;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.SVRLNamespaceContext;
import com.helger.schematron.svrl.SVRLSuccessfulReport;
import com.helger.schematron.svrl.jaxb.FailedAssert;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.schematron.svrl.jaxb.SuccessfulReport;
import com.helger.xml.EXMLParserFeature;
import com.helger.xml.serialize.read.DOMReader;
import com.helger.xml.serialize.read.DOMReaderSettings;
import com.helger.xml.transform.TransformSourceFactory;

/**
 * Validates XML files against one Schematron and checks the result against an expectation, as
 * done by the Maven goal <code>validate</code>, the Ant task <code>schematron</code> and the
 * command line client.
 * <p>
 * Only failed asserts and successful reports with level error or fatal error decide whether a
 * file is valid. Warnings and information are logged; they make a file fail only with
 * {@link #setFailOnValidationWarn(boolean)} or {@link #setFailOnValidationInfo(boolean)}.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@NotThreadSafe
public class SchematronValidationRunner
{
  /** The extension of the SVRL files */
  public static final String SVRL_FILE_EXTENSION = ".svrl";

  private static final Locale DISPLAY_LOCALE = Locale.US;

  private final ISchematronResource m_aSchematron;
  private final ILogHandler m_aLogger;
  private boolean m_bIgnoreWarnings = false;
  private final ICommonsSet <String> m_aErrorRoles = new CommonsHashSet <> ();
  private boolean m_bFailOnValidationError = false;
  private boolean m_bFailOnValidationWarn = false;
  private boolean m_bFailOnValidationInfo = false;
  private EntityResolver m_aEntityResolver;

  public SchematronValidationRunner (@NonNull final ISchematronResource aSchematron,
                                     @NonNull final ILogHandler aLogger)
  {
    ValueEnforcer.notNull (aSchematron, "Schematron");
    ValueEnforcer.notNull (aLogger, "Logger");
    m_aSchematron = aSchematron;
    m_aLogger = aLogger;
  }

  /**
   * @param bIgnoreWarnings
   *        <code>true</code> to drop all failed asserts and successful reports below level error:
   *        they are neither logged nor counted.
   * @return this for chaining
   */
  @NonNull
  public SchematronValidationRunner setIgnoreWarnings (final boolean bIgnoreWarnings)
  {
    m_bIgnoreWarnings = bIgnoreWarnings;
    return this;
  }

  /**
   * @param aErrorRoles
   *        Values of <code>role</code>, <code>flag</code> or <code>severity</code> that are
   *        treated as level error, compared case insensitive. May be <code>null</code>.
   * @return this for chaining
   */
  @NonNull
  public SchematronValidationRunner setErrorRoles (@Nullable final Collection <String> aErrorRoles)
  {
    m_aErrorRoles.clear ();
    if (aErrorRoles != null)
      for (final String sRole : aErrorRoles)
        if (StringHelper.isNotEmpty (sRole))
          m_aErrorRoles.add (sRole.toLowerCase (Locale.ROOT));
    return this;
  }

  /**
   * @param b
   *        <code>true</code> to fail a file that contains at least one error, also if it was
   *        expected to be invalid.
   * @return this for chaining
   */
  @NonNull
  public SchematronValidationRunner setFailOnValidationError (final boolean b)
  {
    m_bFailOnValidationError = b;
    return this;
  }

  /**
   * @param b
   *        <code>true</code> to fail a file that contains at least one warning.
   * @return this for chaining
   */
  @NonNull
  public SchematronValidationRunner setFailOnValidationWarn (final boolean b)
  {
    m_bFailOnValidationWarn = b;
    return this;
  }

  /**
   * @param b
   *        <code>true</code> to fail a file that contains at least one information.
   * @return this for chaining
   */
  @NonNull
  public SchematronValidationRunner setFailOnValidationInfo (final boolean b)
  {
    m_bFailOnValidationInfo = b;
    return this;
  }

  /**
   * @param aEntityResolver
   *        The entity resolver for reading the XML files, usually from an XML catalog. If it is
   *        set, each XML file is read into a DOM with this resolver and the DOM is validated:
   *        external DTDs and entities are loaded, but only via this resolver. A reference it does
   *        not resolve (returns <code>null</code>) makes the file fail instead of being loaded from
   *        its system ID. If it is not set, the file is passed to the engine as is. May be
   *        <code>null</code>.
   * @return this for chaining
   */
  @NonNull
  public SchematronValidationRunner setEntityResolver (@Nullable final EntityResolver aEntityResolver)
  {
    m_aEntityResolver = aEntityResolver;
    return this;
  }

  /**
   * @param aSVRLDirectory
   *        The directory to write the SVRL files to. May be <code>null</code>.
   * @param sRelativeXMLPath
   *        The path of the XML file relative to the directory it was found in. May not be
   *        <code>null</code>.
   * @return <code>null</code> if no SVRL directory is provided, the SVRL file otherwise (relative
   *         path plus {@link #SVRL_FILE_EXTENSION}).
   */
  @Nullable
  public static File getSVRLFile (@Nullable final File aSVRLDirectory, @NonNull final String sRelativeXMLPath)
  {
    return aSVRLDirectory == null ? null : new File (aSVRLDirectory, sRelativeXMLPath + SVRL_FILE_EXTENSION);
  }

  @NonNull
  private ISVRLErrorLevelDeterminator _getErrorLevelDeterminator ()
  {
    // The error roles are applied locally, without changing the global determinator
    final ISVRLErrorLevelDeterminator aBase = SVRLHelper.getErrorLevelDeterminator ();
    if (m_aErrorRoles.isEmpty ())
      return aBase;
    return sValue -> {
      if (sValue != null && m_aErrorRoles.contains (sValue.toLowerCase (Locale.ROOT)))
        return EErrorLevel.ERROR;
      return aBase.getErrorLevelFromString (sValue);
    };
  }

  @NonNull
  private ICommonsList <AbstractSVRLMessage> _getAllMessages (@Nullable final SchematronOutputType aSOT)
  {
    final ICommonsList <AbstractSVRLMessage> ret = new CommonsArrayList <> ();
    if (aSOT != null)
    {
      final ISVRLErrorLevelDeterminator aELD = _getErrorLevelDeterminator ();
      for (final Object aObj : aSOT.getActivePatternOrActiveGroupAndFiredRule ())
        if (aObj instanceof final FailedAssert aFA)
          ret.add (new SVRLFailedAssert (aFA, aELD::getErrorLevelFromFailedAssert));
        else
          if (aObj instanceof final SuccessfulReport aSR)
            ret.add (new SVRLSuccessfulReport (aSR, aELD::getErrorLevelFromSuccessfulReport));
    }
    return ret;
  }

  private void _writeSVRL (@NonNull final SchematronOutputType aSOT, @NonNull final File aSVRLFile)
  {
    // Beautified SVRL
    final SVRLMarshaller aMarshaller = new SVRLMarshaller ();
    aMarshaller.setUseSchema (false);
    aMarshaller.setFormattedOutput (true);
    aMarshaller.setNamespaceContext (SVRLNamespaceContext.getInstance ());

    final FileIOError aIOErr = FileOperationManager.INSTANCE.createDirRecursiveIfNotExisting (aSVRLFile.getParentFile ());
    if (aIOErr.isFailure ())
      m_aLogger.error ("Failed to create parent directory of '" + aSVRLFile.getAbsolutePath () + "': " + aIOErr);

    if (aMarshaller.write (aSOT, aSVRLFile).isSuccess ())
      m_aLogger.info ("Successfully saved SVRL file '" + aSVRLFile.getPath () + "'");
    else
      m_aLogger.error ("Error saving SVRL file '" + aSVRLFile.getPath () + "'");

    m_aLogger.debug ( () -> "Created SVRL:\n" + aMarshaller.getAsString (aSOT));
  }

  @Nullable
  private SchematronOutputType _applyValidation (@NonNull final File aXMLFile) throws Exception
  {
    if (m_aEntityResolver == null)
      return m_aSchematron.applySchematronValidationToSVRL (TransformSourceFactory.create (aXMLFile));

    // External DTDs and entities only from the entity resolver - nothing else is loaded
    final Wrapper <String> aUnresolved = new Wrapper <> ();
    final EntityResolver aStrictResolver = (sPublicID, sSystemID) -> {
      final InputSource ret = m_aEntityResolver.resolveEntity (sPublicID, sSystemID);
      if (ret == null)
      {
        aUnresolved.set ("public ID '" + sPublicID + "', system ID '" + sSystemID + "'");
        throw new SAXException ("The external entity with " + aUnresolved.get () + " is not in the XML catalog");
      }
      return ret;
    };

    // Comments are part of the XML to be validated
    final DOMReaderSettings aDRS = new DOMReaderSettings ().setEntityResolver (aStrictResolver)
                                                           .setIgnoringComments (false);
    aDRS.setFeatureValue (EXMLParserFeature.DISALLOW_DOCTYPE_DECL, false);
    aDRS.setFeatureValue (EXMLParserFeature.LOAD_EXTERNAL_DTD, true);
    aDRS.setFeatureValue (EXMLParserFeature.EXTERNAL_GENERAL_ENTITIES, true);
    aDRS.setFeatureValue (EXMLParserFeature.EXTERNAL_PARAMETER_ENTITIES, true);
    // Remember the parse error for the failure message instead of logging it
    final Wrapper <Throwable> aParseError = new Wrapper <> ();
    aDRS.exceptionCallbacks ().set (aParseError::set);
    final Document aDoc = DOMReader.readXMLDOM (new FileSystemResource (aXMLFile), aDRS);
    if (aDoc == null)
    {
      final String sReason;
      if (aUnresolved.isSet ())
        sReason = ": the external entity with " + aUnresolved.get () + " is not in the XML catalog";
      else
        if (aParseError.isSet ())
          sReason = ": " + aParseError.get ().getMessage ();
        else
          sReason = "";
      throw new IllegalArgumentException ("Failed to read XML file '" + aXMLFile.getPath () + "'" + sReason);
    }
    return m_aSchematron.applySchematronValidationToSVRL (aDoc, aXMLFile.getAbsoluteFile ().toURI ().toString ());
  }

  @NonNull
  private static String _getCountText (final int nErrors, final int nWarnings, final int nInfos)
  {
    final ICommonsList <String> aParts = new CommonsArrayList <> ();
    if (nErrors > 0)
      aParts.add (nErrors + " Schematron error" + (nErrors == 1 ? "" : "s"));
    if (nWarnings > 0)
      aParts.add (nWarnings + " Schematron warning" + (nWarnings == 1 ? "" : "s"));
    if (nInfos > 0)
      aParts.add (nInfos + " Schematron information");
    return StringImplode.imploder ().source (aParts).separator (" and ").build ();
  }

  /**
   * Validate a single XML file, log the outcome and all failed asserts and successful reports, and
   * optionally write the SVRL.
   *
   * @param aXMLFile
   *        The XML file to validate. May not be <code>null</code>.
   * @param aSVRLFile
   *        The SVRL file to write. May be <code>null</code> to write no SVRL.
   * @param bExpectSuccess
   *        <code>true</code> if the file must not contain an error, <code>false</code> if it must
   *        contain at least one error.
   * @return The result. Never <code>null</code>.
   */
  @NonNull
  public SchematronFileValidationResult validateFile (@NonNull final File aXMLFile,
                                                      @Nullable final File aSVRLFile,
                                                      final boolean bExpectSuccess)
  {
    ValueEnforcer.notNull (aXMLFile, "XMLFile");

    final String sSchematronPath = m_aSchematron.getResource ().getPath ();
    m_aLogger.info ("Validating XML file '" +
                    aXMLFile.getPath () +
                    "' against Schematron rules from '" +
                    sSchematronPath +
                    "' expecting " +
                    (bExpectSuccess ? "success" : "failure"));

    final SchematronOutputType aSOT;
    try
    {
      aSOT = _applyValidation (aXMLFile);
    }
    catch (final Exception ex)
    {
      final String sMessage = "Exception validating XML file '" +
                              aXMLFile.getPath () +
                              "' against Schematron rules from '" +
                              sSchematronPath +
                              "'. Technical details: " +
                              ex.getClass ().getSimpleName () +
                              " - " +
                              ex.getMessage ();
      m_aLogger.error (sMessage, ex);
      return new SchematronFileValidationResult (aXMLFile, bExpectSuccess, 0, 0, 0, sMessage, null, ex);
    }

    if (aSOT == null)
    {
      final String sMessage = "Validating XML file '" +
                              aXMLFile.getPath () +
                              "' against Schematron rules from '" +
                              sSchematronPath +
                              "' created no SVRL";
      m_aLogger.error (sMessage);
      return new SchematronFileValidationResult (aXMLFile, bExpectSuccess, 0, 0, 0, sMessage, null, null);
    }

    if (aSVRLFile != null)
      _writeSVRL (aSOT, aSVRLFile);

    ICommonsList <AbstractSVRLMessage> aMessages = _getAllMessages (aSOT);
    if (m_bIgnoreWarnings)
    {
      final int nOld = aMessages.size ();
      aMessages = aMessages.getAll (x -> x.getFlag ().isGE (EErrorLevel.ERROR));
      final int nIgnored = nOld - aMessages.size ();
      if (nIgnored > 0)
        m_aLogger.info ("Ignoring " + nIgnored + " Schematron warnings and information");
    }

    final int nErrors = aMessages.getCount (x -> x.getFlag ().isGE (EErrorLevel.ERROR));
    final int nWarnings = aMessages.getCount (x -> x.getFlag ().isEQ (EErrorLevel.WARN));
    final int nInfos = aMessages.getCount (x -> x.getFlag ().isLT (EErrorLevel.WARN));
    final String sCounts = _getCountText (nErrors, nWarnings, nInfos);

    String sFailureMessage = null;
    if (bExpectSuccess)
    {
      if (nErrors == 0)
        m_aLogger.info ("XML file '" +
                        aXMLFile.getPath () +
                        "' was validated against Schematron '" +
                        sSchematronPath +
                        "' and matches the rules" +
                        (sCounts.isEmpty () ? "" : " (" + sCounts + " found)"));
      else
        sFailureMessage = sCounts + " for XML file '" + aXMLFile.getPath () + "'";
    }
    else
    {
      if (nErrors > 0)
        m_aLogger.info ("XML file '" +
                        aXMLFile.getPath () +
                        "' was validated against Schematron '" +
                        sSchematronPath +
                        "' - " +
                        sCounts +
                        " found (as expected)");
      else
        sFailureMessage = "No Schematron errors for erroneous XML file '" +
                          aXMLFile.getPath () +
                          "'" +
                          (sCounts.isEmpty () ? "" : " (" + sCounts + " found)");
    }
    if (sFailureMessage != null)
      m_aLogger.error (sFailureMessage);

    // List details
    for (final AbstractSVRLMessage aMessage : aMessages)
    {
      final String sText = ErrorTextProvider.DEFAULT.getErrorText (aMessage.getAsResourceError (aXMLFile.getPath ()),
                                                                   DISPLAY_LOCALE);
      SchematronToolLogHelper.log (m_aLogger, aMessage.getFlag (), sText);
    }

    String sLevelFailureMessage = null;
    if (nErrors > 0 && m_bFailOnValidationError)
      sLevelFailureMessage = "Validation errors are present in XML file '" + aXMLFile.getPath () + "'";
    else
      if (nWarnings > 0 && m_bFailOnValidationWarn)
        sLevelFailureMessage = "Validation warnings are present in XML file '" + aXMLFile.getPath () + "'";
      else
        if (nInfos > 0 && m_bFailOnValidationInfo)
          sLevelFailureMessage = "Validation information are present in XML file '" + aXMLFile.getPath () + "'";
    if (sLevelFailureMessage != null)
      m_aLogger.error (sLevelFailureMessage);

    return new SchematronFileValidationResult (aXMLFile,
                                               bExpectSuccess,
                                               nErrors,
                                               nWarnings,
                                               nInfos,
                                               sFailureMessage,
                                               sLevelFailureMessage,
                                               null);
  }
}
