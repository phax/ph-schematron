/**
 * Copyright (C) 2014-2018 Philip Helger (www.helger.com)
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
  private static final AtomicBoolean s_bSaveIntermediateXSLTFiles = new AtomicBoolean (false);
  private static File s_aIntermediateMinifiedSCHFolder = new File ("test-minified");
  private static File s_aIntermediateFinalXSLTFolder = new File ("test-final");
  private static final AtomicBoolean s_aShowCreatedXSLT = new AtomicBoolean (false);
  private static final AtomicBoolean s_aShowCreatedSVRL = new AtomicBoolean (false);
  private static final AtomicBoolean s_aShowPreprocessedSchematron = new AtomicBoolean (false);
  private static final AtomicBoolean s_aShowResolvedSourceSchematron = new AtomicBoolean (false);

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
    return s_bSaveIntermediateXSLTFiles.get ();
  }

  public static void setSaveIntermediateXSLTFiles (final boolean bSaveIntermediateFiles)
  {
    s_bSaveIntermediateXSLTFiles.set (bSaveIntermediateFiles);
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

  public static void setIntermediateFinalXSLTFolder (@Nonnull final File aIntermediateFinalXSLTFolder)
  {
    ValueEnforcer.notNull (aIntermediateFinalXSLTFolder, "IntermediateFinalXSLTFolder");
    s_aIntermediateFinalXSLTFolder = aIntermediateFinalXSLTFolder;
  }

  public static void setShowCreatedXSLT (final boolean bShow)
  {
    s_aShowCreatedXSLT.set (bShow);
  }

  /**
   * @return <code>true</code> if the created XSLT should be logged. Only
   *         applied in XSLT based mode.
   */
  public static boolean isShowCreatedXSLT ()
  {
    return s_aShowCreatedXSLT.get ();
  }

  public static void setShowCreatedSVRL (final boolean bShow)
  {
    s_aShowCreatedSVRL.set (bShow);
  }

  /**
   * @return <code>true</code> to log the created SVRL.
   */
  public static boolean isShowCreatedSVRL ()
  {
    return s_aShowCreatedSVRL.get ();
  }

  public static void setShowResolvedSourceSchematron (final boolean bShow)
  {
    s_aShowResolvedSourceSchematron.set (bShow);
  }

  /**
   * @return <code>true</code> to log the read, with includes resolved,
   *         Schematron. This is only applied in pure mode.
   */
  public static boolean isShowResolvedSourceSchematron ()
  {
    return s_aShowResolvedSourceSchematron.get ();
  }

  public static void setShowPreprocessedSchematron (final boolean bShow)
  {
    s_aShowPreprocessedSchematron.set (bShow);
  }

  /**
   * @return <code>true</code> to log the created preprocessed Schematron. This
   *         is only applied in pure mode.
   */
  public static boolean isShowPreprocessedSchematron ()
  {
    return s_aShowPreprocessedSchematron.get ();
  }
}
