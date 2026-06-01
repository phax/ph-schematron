/*
 * Copyright (C) 2014-2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.pure.xpath;

import java.util.Iterator;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.concurrent.Immutable;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.collection.commons.ICommonsMap;

import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.XPathExecutable;
import net.sf.saxon.s9api.XPathSelector;
import net.sf.saxon.s9api.XdmItem;
import net.sf.saxon.s9api.XdmNode;
import net.sf.saxon.s9api.XdmValue;

/**
 * Helper to evaluate compiled {@link XPathExecutable} instances against an {@link XdmItem} context,
 * optionally bound to a set of variables. Since v9.2.0 this is purely based on the Saxon s9api.
 *
 * @author Philip Helger
 * @since 5.0.0
 */
@Immutable
public final class XPathEvaluationHelper
{
  private XPathEvaluationHelper ()
  {}

  private static boolean _expressionReferencesVariable (@NonNull final XPathExecutable aExecutable,
                                                        @NonNull final QName aName)
  {
    // iterateExternalVariables returns the externally declared variables that the expression
    // actually references
    final Iterator <QName> it = aExecutable.iterateExternalVariables ();
    while (it.hasNext ())
      if (aName.equals (it.next ()))
        return true;
    return false;
  }

  /**
   * Build a {@link XPathSelector} from the executable, bind the context item, and apply all
   * variables.
   *
   * @param aExecutable
   *        The compiled executable. Never <code>null</code>.
   * @param aContext
   *        The context item. May be <code>null</code> for context-free expressions.
   * @param aVariables
   *        Variable name to value mapping. May be <code>null</code> or empty.
   * @return A loaded {@link XPathSelector} ready to be evaluated.
   * @throws SaxonApiException
   *         If applying the context or the variables fails.
   */
  @NonNull
  public static XPathSelector createSelector (@NonNull final XPathExecutable aExecutable,
                                              @Nullable final XdmItem aContext,
                                              @Nullable final ICommonsMap <QName, XdmValue> aVariables) throws SaxonApiException
  {
    final XPathSelector aSelector = aExecutable.load ();
    if (aContext != null)
      aSelector.setContextItem (aContext);

    if (aVariables != null && aVariables.isNotEmpty ())
    {
      for (final var aEntry : aVariables.entrySet ())
      {
        // Only set variables that the expression actually references
        if (_expressionReferencesVariable (aExecutable, aEntry.getKey ()))
          aSelector.setVariable (aEntry.getKey (), aEntry.getValue ());
      }
    }
    return aSelector;
  }

  /**
   * Evaluate the expression and return the full sequence.
   *
   * @param aExecutable
   *        The compiled expression. Never <code>null</code>.
   * @param aContext
   *        The context item. May be <code>null</code>.
   * @param aVariables
   *        Variables to bind. May be <code>null</code>.
   * @return The result as an {@link XdmValue}. Never <code>null</code> (may be the empty sequence).
   * @throws SaxonApiException
   *         On evaluation failure.
   */
  @NonNull
  public static XdmValue evaluate (@NonNull final XPathExecutable aExecutable,
                                   @Nullable final XdmItem aContext,
                                   @Nullable final ICommonsMap <QName, XdmValue> aVariables) throws SaxonApiException
  {
    return createSelector (aExecutable, aContext, aVariables).evaluate ();
  }

  /**
   * Evaluate the expression using the XPath effective boolean value rules.
   *
   * @param aExecutable
   *        The compiled expression. Never <code>null</code>.
   * @param aContext
   *        The context item. May be <code>null</code>.
   * @param aVariables
   *        Variables to bind. May be <code>null</code>.
   * @return The effective boolean value.
   * @throws SaxonApiException
   *         On evaluation failure.
   */
  public static boolean evaluateAsBoolean (@NonNull final XPathExecutable aExecutable,
                                           @Nullable final XdmItem aContext,
                                           @Nullable final ICommonsMap <QName, XdmValue> aVariables) throws SaxonApiException
  {
    return createSelector (aExecutable, aContext, aVariables).effectiveBooleanValue ();
  }

  /**
   * Evaluate the expression and return the concatenated string value of the result.
   *
   * @param aExecutable
   *        The compiled expression. Never <code>null</code>.
   * @param aContext
   *        The context item. May be <code>null</code>.
   * @param aVariables
   *        Variables to bind. May be <code>null</code>.
   * @param sItemSeparator
   *        The separator to be printed between multiple items. May not be <code>null</code>.
   * @return The result as a string. Empty string if the result is the empty sequence.
   * @throws SaxonApiException
   *         On evaluation failure.
   */
  @NonNull
  public static String evaluateAsString (@NonNull final XPathExecutable aExecutable,
                                         @Nullable final XdmItem aContext,
                                         @Nullable final ICommonsMap <QName, XdmValue> aVariables,
                                         @NonNull final String sItemSeparator) throws SaxonApiException
  {
    final XdmValue aResult = evaluate (aExecutable, aContext, aVariables);
    if (aResult.isEmptySequence ())
      return "";

    final StringBuilder aSB = new StringBuilder ();
    boolean bFirst = true;
    for (final XdmItem aItem : aResult)
    {
      if (bFirst)
        bFirst = false;
      else
        aSB.append (sItemSeparator);
      aSB.append (aItem.getStringValue ());
    }
    return aSB.toString ();
  }

  /**
   * Evaluate the expression and collect all returned items that are XML nodes.
   *
   * @param aExecutable
   *        The compiled expression. Never <code>null</code>.
   * @param aContext
   *        The context item. May be <code>null</code>.
   * @param aVariables
   *        Variables to bind. May be <code>null</code>.
   * @return A list of all matching {@link XdmNode} items. Never <code>null</code>.
   * @throws SaxonApiException
   *         On evaluation failure.
   */
  @NonNull
  public static ICommonsList <XdmNode> evaluateAsXdmNodes (@NonNull final XPathExecutable aExecutable,
                                                           @Nullable final XdmItem aContext,
                                                           @Nullable final ICommonsMap <QName, XdmValue> aVariables) throws SaxonApiException
  {
    final XdmValue aResult = evaluate (aExecutable, aContext, aVariables);
    final ICommonsList <XdmNode> ret = new CommonsArrayList <> (aResult.size ());
    for (final XdmItem aItem : aResult)
      if (aItem instanceof final XdmNode aNode)
        ret.add (aNode);
    return ret;
  }
}
