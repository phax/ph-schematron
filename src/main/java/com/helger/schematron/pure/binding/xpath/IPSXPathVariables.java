package com.helger.schematron.pure.binding.xpath;

import java.io.Serializable;
import java.util.Map;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import com.helger.commons.ICloneable;
import com.helger.commons.annotations.ReturnsMutableCopy;

/**
 * Read-only interface for {@link PSXPathVariables}.
 *
 * @author Philip Helger
 */
public interface IPSXPathVariables extends ICloneable <PSXPathVariables>, Serializable
{
  /**
   * Perform the text replacement of all variables in the specified text.
   *
   * @param sText
   *        The source text. May be <code>null</code>.
   * @return The text with all values replaced. May be <code>null</code> if the
   *         source text is <code>null</code>.
   */
  @Nullable
  String getAppliedReplacement (@Nullable String sText);

  /**
   * @return All contained variable key value pairs. Never <code>null</code>.
   */
  @Nonnull
  @ReturnsMutableCopy
  Map <String, String> getAll ();

  /**
   * @param sName
   *        Name of the variable to check
   * @return <code>true</code> if a variable with the passed name in present.
   */
  boolean contains (@Nullable String sName);

  /**
   * @param sName
   *        Variable name
   * @return The variable value of the variable with the specified name or
   *         <code>null</code> if no such variable is present.
   */
  @Nullable
  String get (@Nullable String sName);
}
