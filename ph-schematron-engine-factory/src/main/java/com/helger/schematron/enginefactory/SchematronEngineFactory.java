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
import java.util.Arrays;
import java.util.function.Predicate;

import javax.xml.transform.ErrorListener;
import javax.xml.transform.TransformerException;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.w3c.dom.Document;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.string.StringImplode;
import com.helger.collection.commons.ICommonsOrderedMap;
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.ESchematronEngine;
import com.helger.schematron.SchematronException;
import com.helger.schematron.api.xslt.processor.ISchematronXsltProcessor;
import com.helger.schematron.api.xslt.processor.SchematronXsltProcessorRegistry;
import com.helger.schematron.errorhandler.CollectingPSErrorHandler;
import com.helger.schematron.pure.SchematronResourcePureXPath;
import com.helger.schematron.purexslt.SchematronResourcePureXslt;
import com.helger.schematron.purexslt.xslt.EPureXsltVersion;
import com.helger.schematron.purexslt.xslt.SchematronToXsltConverter;
import com.helger.schematron.sch.SchematronProviderXSLTFromSCH;
import com.helger.schematron.sch.SchematronResourceSCH;
import com.helger.schematron.sch.SchematronSCHConfig;
import com.helger.schematron.schxslt.xslt2.SchematronProviderXSLTFromSchXslt_XSLT2;
import com.helger.schematron.schxslt.xslt2.SchematronResourceSchXslt_XSLT2;
import com.helger.schematron.schxslt.xslt2.SchematronSchXslt_XSLT2Config;
import com.helger.schematron.schxslt2.xslt.SchematronProviderXSLTFromSchXslt2;
import com.helger.schematron.schxslt2.xslt.SchematronResourceSchXslt2;
import com.helger.schematron.schxslt2.xslt.SchematronSchXslt2Config;
import com.helger.schematron.xslt.SchematronResourceXSLT;
import com.helger.xml.transform.CollectingTransformErrorListener;

/**
 * Creates the Schematron resource of every {@link ESchematronEngine} and the XSLT of every engine
 * that can convert a Schematron to XSLT, from one set of {@link SchematronEngineSettings}. Used by
 * the Maven plugin, the Ant tasks and the command line client.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@Immutable
public final class SchematronEngineFactory
{
  /** The parameter that suppresses the SchXslt 1 compilation metadata in a created XSLT */
  public static final String SCHXSLT1_PARAM_COMPILE_METADATA = "schxslt.compile.metadata";

  private SchematronEngineFactory ()
  {}

  /**
   * @param eEngine
   *        The engine to check. May not be <code>null</code>.
   * @return <code>true</code> if the engine can convert a Schematron to an XSLT, which is the case
   *         for all XSLT based engines except {@link ESchematronEngine#XSLT_PREBUILT}.
   */
  public static boolean isXsltCreating (@NonNull final ESchematronEngine eEngine)
  {
    return eEngine.isXSLTBased () && eEngine != ESchematronEngine.XSLT_PREBUILT;
  }

  /**
   * @param aFilter
   *        The engines to list. May not be <code>null</code>.
   * @return The quoted IDs of all matching engines, comma separated, for error messages.
   */
  @NonNull
  public static String getEngineIDsAsString (@NonNull final Predicate <ESchematronEngine> aFilter)
  {
    return StringImplode.imploder ()
                        .source (Arrays.stream (ESchematronEngine.values ()).filter (aFilter).toList (),
                                 e -> "'" + e.getID () + "'")
                        .separator (", ")
                        .build ();
  }

  /**
   * Resolve the XSLT processor for an engine.
   *
   * @param eEngine
   *        The engine to use. May not be <code>null</code>.
   * @param sXsltProcessorID
   *        The ID of the XSLT processor. May be <code>null</code> to use the only processor on the
   *        class path.
   * @return <code>null</code> if the engine has no selectable XSLT processor.
   * @throws IllegalArgumentException
   *         If the XSLT processor ID is unknown
   * @throws IllegalStateException
   *         If no ID is provided and not exactly one XSLT processor is on the class path
   */
  @Nullable
  public static ISchematronXsltProcessor getXsltProcessor (@NonNull final ESchematronEngine eEngine,
                                                           @Nullable final String sXsltProcessorID)
  {
    ValueEnforcer.notNull (eEngine, "Engine");
    if (!eEngine.isXsltProcessorSelectable ())
      return null;
    return SchematronXsltProcessorRegistry.getProcessorOfIDOrDefault (sXsltProcessorID);
  }

  /**
   * Create the Schematron resource for the engine of the settings and check the Schematron.
   *
   * @param aSchematronFile
   *        The Schematron file. For {@link ESchematronEngine#XSLT_PREBUILT} it is an XSLT file. May
   *        not be <code>null</code>.
   * @param aSettings
   *        The settings to use. May not be <code>null</code>.
   * @return The resource and the errors of the Schematron check. Never <code>null</code>.
   */
  @NonNull
  public static SchematronEngineResource createResource (@NonNull final File aSchematronFile,
                                                         @NonNull final SchematronEngineSettings aSettings)
  {
    ValueEnforcer.notNull (aSchematronFile, "SchematronFile");
    ValueEnforcer.notNull (aSettings, "Settings");

    final ESchematronEngine eEngine = aSettings.getEngine ();
    final ICommonsOrderedMap <String, String> aParams = aSettings.getAllParameters ();
    return switch (eEngine)
    {
      case PURE_XPATH ->
      {
        final CollectingPSErrorHandler aErrorHdl = new CollectingPSErrorHandler ();
        final SchematronResourcePureXPath aRes = SchematronResourcePureXPath.builderFromFile (aSchematronFile)
                                                                            .phase (aSettings.getPhase ())
                                                                            .lenient (aSettings.isLenient ())
                                                                            .errorHandler (aErrorHdl)
                                                                            .entityResolver (aSettings.getEntityResolver ())
                                                                            .build ();
        aRes.validateCompletely ();
        yield new SchematronEngineResource (aRes, aErrorHdl.getAllErrors ());
      }
      case PURE_XSLT ->
      {
        final CollectingPSErrorHandler aErrorHdl = new CollectingPSErrorHandler ();
        final SchematronResourcePureXslt aRes = SchematronResourcePureXslt.builderFromFile (aSchematronFile)
                                                                          .phase (aSettings.getPhase ())
                                                                          .errorHandler (aErrorHdl)
                                                                          .xsltProcessor (aSettings.getXsltProcessor ())
                                                                          .build ();
        aRes.isValidSchematron ();
        yield new SchematronEngineResource (aRes, aErrorHdl.getAllErrors ());
      }
      case ISO_SCHEMATRON ->
      {
        final CollectingTransformErrorListener aErrorHdl = new CollectingTransformErrorListener ();
        final SchematronResourceSCH aRes = SchematronResourceSCH.builderFromFile (aSchematronFile)
                                                                .phase (aSettings.getPhase ())
                                                                .languageCode (aSettings.getLanguageCode ())
                                                                .forceCacheResult (aSettings.isForceCacheResult ())
                                                                .parameters (aParams)
                                                                .errorListener (aErrorHdl)
                                                                .xsltProcessor (aSettings.getXsltProcessor ())
                                                                .uriResolver (aSettings.getURIResolver ())
                                                                .entityResolver (aSettings.getEntityResolver ())
                                                                .build ();
        aRes.isValidSchematron ();
        yield new SchematronEngineResource (aRes, aErrorHdl.getErrorList ());
      }
      case SCHXSLT1 ->
      {
        final CollectingTransformErrorListener aErrorHdl = new CollectingTransformErrorListener ();
        final SchematronResourceSchXslt_XSLT2 aRes = SchematronResourceSchXslt_XSLT2.builderFromFile (aSchematronFile)
                                                                                    .phase (aSettings.getPhase ())
                                                                                    .languageCode (aSettings.getLanguageCode ())
                                                                                    .forceCacheResult (aSettings.isForceCacheResult ())
                                                                                    .parameters (aParams)
                                                                                    .errorListener (aErrorHdl)
                                                                                    .xsltProcessor (aSettings.getXsltProcessor ())
                                                                                    .uriResolver (aSettings.getURIResolver ())
                                                                                    .entityResolver (aSettings.getEntityResolver ())
                                                                                    .build ();
        aRes.isValidSchematron ();
        yield new SchematronEngineResource (aRes, aErrorHdl.getErrorList ());
      }
      case SCHXSLT2 ->
      {
        final CollectingTransformErrorListener aErrorHdl = new CollectingTransformErrorListener ();
        final SchematronResourceSchXslt2 aRes = SchematronResourceSchXslt2.builderFromFile (aSchematronFile)
                                                                          .phase (aSettings.getPhase ())
                                                                          .languageCode (aSettings.getLanguageCode ())
                                                                          .forceCacheResult (aSettings.isForceCacheResult ())
                                                                          .parameters (aParams)
                                                                          .errorListener (aErrorHdl)
                                                                          .xsltProcessor (aSettings.getXsltProcessor ())
                                                                          .uriResolver (aSettings.getURIResolver ())
                                                                          .entityResolver (aSettings.getEntityResolver ())
                                                                          .build ();
        aRes.isValidSchematron ();
        yield new SchematronEngineResource (aRes, aErrorHdl.getErrorList ());
      }
      case XSLT_PREBUILT ->
      {
        // Phase and language code were fixed when the XSLT was created
        final CollectingTransformErrorListener aErrorHdl = new CollectingTransformErrorListener ();
        final SchematronResourceXSLT aRes = SchematronResourceXSLT.builderFromFile (aSchematronFile)
                                                                  .parameters (aParams)
                                                                  .errorListener (aErrorHdl)
                                                                  .xsltProcessor (aSettings.getXsltProcessor ())
                                                                  .uriResolver (aSettings.getURIResolver ())
                                                                  .entityResolver (aSettings.getEntityResolver ())
                                                                  .build ();
        aRes.isValidSchematron ();
        yield new SchematronEngineResource (aRes, aErrorHdl.getErrorList ());
      }
    };
  }

  /**
   * Convert a Schematron to an XSLT with the engine of the settings.
   *
   * @param aSchematronResource
   *        The Schematron to convert. May not be <code>null</code>.
   * @param aSettings
   *        The settings to use. The engine must be one where {@link #isXsltCreating(ESchematronEngine)}
   *        is <code>true</code>. May not be <code>null</code>.
   * @param aErrorListener
   *        The error listener of the XSLT pipeline. May be <code>null</code>.
   * @return <code>null</code> if the Schematron is invalid.
   * @throws TransformerException
   *         If the XSLT pipeline fails
   * @throws SchematronException
   *         If the engine cannot create an XSLT, or the pure-Java conversion fails
   */
  @Nullable
  public static Document createXsltDocument (@NonNull final IReadableResource aSchematronResource,
                                             @NonNull final SchematronEngineSettings aSettings,
                                             @Nullable final ErrorListener aErrorListener) throws TransformerException,
                                                                                           SchematronException
  {
    ValueEnforcer.notNull (aSchematronResource, "SchematronResource");
    ValueEnforcer.notNull (aSettings, "Settings");

    final ESchematronEngine eEngine = aSettings.getEngine ();
    return switch (eEngine)
    {
      case ISO_SCHEMATRON ->
      {
        // An unset URI resolver overrides the default of the config builder
        final SchematronSCHConfig aConfig = SchematronSCHConfig.builder (aSchematronResource)
                                                               .errorListener (aErrorListener)
                                                               .xsltProcessor (aSettings.getXsltProcessor ())
                                                               .uriResolver (aSettings.getURIResolver ())
                                                               .phase (aSettings.getPhase ())
                                                               .languageCode (aSettings.getLanguageCode ())
                                                               .parameters (aSettings.getAllParameters ())
                                                               .forceCacheResult (aSettings.isForceCacheResult ())
                                                               .build ();
        yield SchematronProviderXSLTFromSCH.createSchematronXSLT (aConfig);
      }
      case SCHXSLT1 ->
      {
        final ICommonsOrderedMap <String, String> aParams = aSettings.getAllParameters ();
        aParams.put (SCHXSLT1_PARAM_COMPILE_METADATA, "false");
        final SchematronSchXslt_XSLT2Config aConfig = SchematronSchXslt_XSLT2Config.builder (aSchematronResource)
                                                                                   .errorListener (aErrorListener)
                                                                                   .xsltProcessor (aSettings.getXsltProcessor ())
                                                                                   .uriResolver (aSettings.getURIResolver ())
                                                                                   .phase (aSettings.getPhase ())
                                                                                   .languageCode (aSettings.getLanguageCode ())
                                                                                   .parameters (aParams)
                                                                                   .forceCacheResult (aSettings.isForceCacheResult ())
                                                                                   .build ();
        yield SchematronProviderXSLTFromSchXslt_XSLT2.createSchematronXSLT (aConfig);
      }
      case SCHXSLT2 ->
      {
        final SchematronSchXslt2Config aConfig = SchematronSchXslt2Config.builder (aSchematronResource)
                                                                         .errorListener (aErrorListener)
                                                                         .xsltProcessor (aSettings.getXsltProcessor ())
                                                                         .uriResolver (aSettings.getURIResolver ())
                                                                         .phase (aSettings.getPhase ())
                                                                         .languageCode (aSettings.getLanguageCode ())
                                                                         .parameters (aSettings.getAllParameters ())
                                                                         .forceCacheResult (aSettings.isForceCacheResult ())
                                                                         .build ();
        yield SchematronProviderXSLTFromSchXslt2.createSchematronXSLT (aConfig);
      }
      case PURE_XSLT ->
      {
        // Language code and parameters are SCH/SchXslt settings that don't apply to the Java
        // generator; the phase is honoured
        yield SchematronToXsltConverter.fromResource (aSchematronResource)
                                       .setPhase (aSettings.getPhase ())
                                       .setXsltVersion (EPureXsltVersion.DEFAULT)
                                       .getAsDocument ();
      }
      default -> throw new SchematronToolException ("The Schematron engine '" +
                                                    eEngine.getID () +
                                                    "' cannot create an XSLT. Supported engines are: " +
                                                    getEngineIDsAsString (SchematronEngineFactory::isXsltCreating));
    };
  }
}
