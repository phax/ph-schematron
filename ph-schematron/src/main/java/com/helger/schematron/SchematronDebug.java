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
   * @see #setShowPreprocessedSchematron(boolean)
   * @see #setShowResolvedSourceSchematron(boolean)
   */
  public static void setDebugMode (final boolean bDebugMode)
  {
    setSaveIntermediateXSLTFiles (bDebugMode);
    setShowCreatedXSLT (bDebugMode);
    setShowCreatedSVRL (bDebugMode);
    setShowPreprocessedSchematron (bDebugMode);
    setShowResolvedSourceSchematron (bDebugMode);
  }

  /**
   * @return <code>true</code> if the intermediate files during XSLT creation.
   *         Applied only in XSTL based modes.
   */
  public static final boolean isSaveIntermediateXSLTFiles ()
  {
    return s_bSaveIntermediateXSLTFiles.get ();
  }

  public static final void setSaveIntermediateXSLTFiles (final boolean bSaveIntermediateFiles)
  {
    s_bSaveIntermediateXSLTFiles.set (bSaveIntermediateFiles);
  }

  /**
   * @return The folder to which the minified SCH should be stored. Never
   *         <code>null</code>. Only used in XSLT based modes if
   *         {@link #isSaveIntermediateXSLTFiles()} is <code>true</code>.
   */
  @Nonnull
  public static final File getIntermediateMinifiedSCHFolder ()
  {
    return s_aIntermediateMinifiedSCHFolder;
  }

  public static final void setIntermediateMinifiedSCHFolder (@Nonnull final File aIntermediateMinifiedSCHFolder)
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
  public static final File getIntermediateFinalXSLTFolder ()
  {
    return s_aIntermediateFinalXSLTFolder;
  }

  public static final void setIntermediateFinalXSLTFolder (@Nonnull final File aIntermediateFinalXSLTFolder)
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
   * @return <code>true</code> to show the created SVRL.
   */
  public static boolean isShowCreatedSVRL ()
  {
    return s_aShowCreatedSVRL.get ();
  }

  public static void setShowPreprocessedSchematron (final boolean bShow)
  {
    s_aShowPreprocessedSchematron.set (bShow);
  }

  public static boolean isShowPreprocessedSchematron ()
  {
    return s_aShowPreprocessedSchematron.get ();
  }

  public static void setShowResolvedSourceSchematron (final boolean bShow)
  {
    s_aShowResolvedSourceSchematron.set (bShow);
  }

  public static boolean isShowResolvedSourceSchematron ()
  {
    return s_aShowResolvedSourceSchematron.get ();
  }
}
