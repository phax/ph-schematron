/*
 * Copyright (C) 2014-2023 Philip Helger (www.helger.com)
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
package com.helger.schematron;

import java.io.File;
import java.util.concurrent.atomic.AtomicBoolean;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.ThreadSafe;

import com.helger.commons.ValueEnforcer;

/**
 * Global Schematron debug settings etc.
 *
 * @author Philip Helger
 * @since 4.3.4
 */
@ThreadSafe
public final class SchematronDebug
{
  private static final AtomicBoolean SAVE_INTERMEDIATE_XSLT_FILES = new AtomicBoolean (false);
  private static File s_aIntermediateMinifiedSCHFolder = new File ("test-minified");
  private static File s_aIntermediateFinalXSLTFolder = new File ("test-final");
  private static final AtomicBoolean SHOW_CREATED_XSLT = new AtomicBoolean (false);
  private static final AtomicBoolean SHOW_CREATED_SVRL = new AtomicBoolean (false);
  private static final AtomicBoolean SHOW_PREPROCESSED_SCH = new AtomicBoolean (false);
  private static final AtomicBoolean SHOW_RESOLVED_SOURCE_SCH = new AtomicBoolean (false);

  private SchematronDebug ()
  {}

  /**
   * Globally enable/disable debug mode
   *
   * @param bDebugMode
   *        <code>true</code> to enable debug mode, <code>false</code>
   *        otherwise.
   * @see #setSaveIntermediateXSLTFiles(boolean)
   * @see #setShowCreatedXSLT(boolean)
   * @see #setShowCreatedSVRL(boolean)
   * @see #setShowResolvedSourceSchematron(boolean)
   * @see #setShowPreprocessedSchematron(boolean)
   */
  public static void setDebugMode (final boolean bDebugMode)
  {
    setSaveIntermediateXSLTFiles (bDebugMode);
    setShowCreatedXSLT (bDebugMode);
    setShowCreatedSVRL (bDebugMode);
    setShowResolvedSourceSchematron (bDebugMode);
    setShowPreprocessedSchematron (bDebugMode);
  }

  /**
   * @return <code>true</code> if the intermediate files during XSLT creation.
   *         Applied only in XSTL based modes.
   */
  public static boolean isSaveIntermediateXSLTFiles ()
  {
    return SAVE_INTERMEDIATE_XSLT_FILES.get ();
  }

  /**
   * Enable/disable the saving of intermediate XSLT files
   *
   * @param bSaveIntermediateFiles
   *        <code>true</code> to save them, <code>false</code> to disable it.
   * @see #setDebugMode(boolean) to trigger all debug options at once
   */
  public static void setSaveIntermediateXSLTFiles (final boolean bSaveIntermediateFiles)
  {
    SAVE_INTERMEDIATE_XSLT_FILES.set (bSaveIntermediateFiles);
  }

  /**
   * @return The folder to which the minified SCH should be stored. Never
   *         <code>null</code>. Only used in XSLT based modes if
   *         {@link #isSaveIntermediateXSLTFiles()} is <code>true</code>.
   */
  @Nonnull
  public static File getIntermediateMinifiedSCHFolder ()
  {
    return s_aIntermediateMinifiedSCHFolder;
  }

  /**
   * Set the folder to which the intermediate minified SCH files should be save
   * to
   *
   * @param aIntermediateMinifiedSCHFolder
   *        The folder to save to. May not be <code>null</code>.
   */
  public static void setIntermediateMinifiedSCHFolder (@Nonnull final File aIntermediateMinifiedSCHFolder)
  {
    ValueEnforcer.notNull (aIntermediateMinifiedSCHFolder, "IntermediateMinifiedSCHFolder");
    s_aIntermediateMinifiedSCHFolder = aIntermediateMinifiedSCHFolder;
  }

  /**
   * @return The folder to which the final XSLT should be stored. Never
   *         <code>null</code>. Only used in XSLT based modes if
   *         {@link #isSaveIntermediateXSLTFiles()} is <code>true</code>.
   */
  @Nonnull
  public static File getIntermediateFinalXSLTFolder ()
  {
    return s_aIntermediateFinalXSLTFolder;
  }

  /**
   * Set the folder to which the intermediate minified SCH files should be save
   * to.
   *
   * @param aIntermediateFinalXSLTFolder
   *        The folder to save to. May not be <code>null</code>.
   */
  public static void setIntermediateFinalXSLTFolder (@Nonnull final File aIntermediateFinalXSLTFolder)
  {
    ValueEnforcer.notNull (aIntermediateFinalXSLTFolder, "IntermediateFinalXSLTFolder");
    s_aIntermediateFinalXSLTFolder = aIntermediateFinalXSLTFolder;
  }

  /**
   * @return <code>true</code> if the created XSLT should be logged. Only
   *         applied in XSLT based mode.
   */
  public static boolean isShowCreatedXSLT ()
  {
    return SHOW_CREATED_XSLT.get ();
  }

  /**
   * Log the created XSLT files or not
   *
   * @param bShow
   *        <code>true</code> to enable logging, <code>false</code> to disable
   *        it.
   * @see #setDebugMode(boolean) to trigger all debug options at once
   */
  public static void setShowCreatedXSLT (final boolean bShow)
  {
    SHOW_CREATED_XSLT.set (bShow);
  }

  /**
   * @return <code>true</code> to log the created SVRL.
   */
  public static boolean isShowCreatedSVRL ()
  {
    return SHOW_CREATED_SVRL.get ();
  }

  /**
   * Log the created SVRL results or not
   *
   * @param bShow
   *        <code>true</code> to enable logging, <code>false</code> to disable
   *        it.
   * @see #setDebugMode(boolean) to trigger all debug options at once
   */
  public static void setShowCreatedSVRL (final boolean bShow)
  {
    SHOW_CREATED_SVRL.set (bShow);
  }

  /**
   * @return <code>true</code> to log the read, with includes resolved,
   *         Schematron. This is only applied in pure mode.
   */
  public static boolean isShowResolvedSourceSchematron ()
  {
    return SHOW_RESOLVED_SOURCE_SCH.get ();
  }

  /**
   * Log the created Schematron with the includes resolved
   *
   * @param bShow
   *        <code>true</code> to enable logging, <code>false</code> to disable
   *        it.
   * @see #setDebugMode(boolean) to trigger all debug options at once
   */
  public static void setShowResolvedSourceSchematron (final boolean bShow)
  {
    SHOW_RESOLVED_SOURCE_SCH.set (bShow);
  }

  /**
   * @return <code>true</code> to log the created preprocessed Schematron. This
   *         is only applied in pure mode.
   */
  public static boolean isShowPreprocessedSchematron ()
  {
    return SHOW_PREPROCESSED_SCH.get ();
  }

  /**
   * Log the complete created preprocessed Schematron
   *
   * @param bShow
   *        <code>true</code> to enable logging, <code>false</code> to disable
   *        it.
   * @see #setDebugMode(boolean) to trigger all debug options at once
   */
  public static void setShowPreprocessedSchematron (final boolean bShow)
  {
    SHOW_PREPROCESSED_SCH.set (bShow);
  }
}
