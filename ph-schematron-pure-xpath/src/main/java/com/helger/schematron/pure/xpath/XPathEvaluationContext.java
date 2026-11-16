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

import java.util.IdentityHashMap;
import java.util.Iterator;
import java.util.Map;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.w3c.dom.Node;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.collection.commons.ICommonsMap;

import net.sf.saxon.dom.DocumentWrapper;
import net.sf.saxon.dom.NodeOverNodeInfo;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.XPathExecutable;
import net.sf.saxon.s9api.XPathSelector;
import net.sf.saxon.s9api.XdmItem;
import net.sf.saxon.s9api.XdmNode;
import net.sf.saxon.s9api.XdmValue;

/**
 * Per-thread context that lets the SVRL validation handler (or any other code invoked downstream
 * from
 * {@link com.helger.schematron.pure.bound.xpath.PSXPathBoundSchema#validate(Node, String, com.helger.schematron.pure.validation.IPSValidationHandler)})
 * re-wrap DOM nodes into Saxon {@link XdmNode}s and access the currently effective Schematron
 * variable bindings.
 * <p>
 * If validation runs over a real DOM input, a {@link DocumentWrapper} is supplied to bridge DOM
 * nodes to Saxon. When validation runs over a Saxon-built tree (TinyTree wrapped behind
 * {@link NodeOverNodeInfo}), {@link #wrap(Node)} short-circuits to the underlying NodeInfo and the
 * {@link DocumentWrapper} is not needed.
 * </p>
 *
 * @author Philip Helger
 * @since 9.2.0
 */
@NotThreadSafe
public final class XPathEvaluationContext
{
  /**
   * The selector of one XPath executable, that is reused for all evaluations of that executable
   * within one validation. The variable values that were set last are remembered, so that a
   * variable is only set again if its value changed.
   */
  private static final class ReusableSelector
  {
    private final XPathSelector m_aSelector;
    private final QName [] m_aVarNames;
    private final XdmValue [] m_aSetValues;
    private final XdmValue [] m_aNewValues;

    private ReusableSelector (@NonNull final XPathExecutable aExecutable)
    {
      m_aSelector = aExecutable.load ();
      final ICommonsList <QName> aNames = new CommonsArrayList <> ();
      final Iterator <QName> it = aExecutable.iterateExternalVariables ();
      while (it.hasNext ())
        aNames.add (it.next ());
      m_aVarNames = aNames.toArray (new QName [aNames.size ()]);
      m_aSetValues = new XdmValue [m_aVarNames.length];
      m_aNewValues = new XdmValue [m_aVarNames.length];
    }
  }

  private static final ThreadLocal <XPathEvaluationContext> TL = new ThreadLocal <> ();

  private final Processor m_aProcessor;
  private final DocumentWrapper m_aDocumentWrapper;
  private final XPathLetVariableResolver m_aLetVars;
  private final String m_sBaseURI;
  private final Map <XPathExecutable, ReusableSelector> m_aSelectors = new IdentityHashMap <> ();

  public XPathEvaluationContext (@NonNull final Processor aProcessor,
                                 @Nullable final DocumentWrapper aDocumentWrapper,
                                 @NonNull final XPathLetVariableResolver aLetVars,
                                 @Nullable final String sBaseURI)
  {
    m_aProcessor = ValueEnforcer.notNull (aProcessor, "Processor");
    m_aDocumentWrapper = aDocumentWrapper;
    m_aLetVars = ValueEnforcer.notNull (aLetVars, "LetVars");
    m_sBaseURI = sBaseURI;
  }

  @NonNull
  public Processor getProcessor ()
  {
    return m_aProcessor;
  }

  /**
   * @return The {@link DocumentWrapper} used to bridge DOM nodes to Saxon, or <code>null</code> if
   *         the current validation operates on a Saxon-built tree directly (no DOM bridge needed).
   */
  @Nullable
  public DocumentWrapper getDocumentWrapper ()
  {
    return m_aDocumentWrapper;
  }

  @Nullable
  public String getBaseURI ()
  {
    return m_sBaseURI;
  }

  /**
   * @return The currently effective variable bindings. Never <code>null</code>.
   */
  @NonNull
  public ICommonsMap <QName, XdmValue> getCurrentVariables ()
  {
    return m_aLetVars.getCurrentVariables ();
  }

  /**
   * Create a new selector the same way as
   * {@link XPathEvaluationHelper#createSelector(XPathExecutable, XdmItem, ICommonsMap)} does. Used if
   * a reusable selector cannot be used.
   */
  @NonNull
  private XPathSelector _createNewSelector (@NonNull final XPathExecutable aExecutable,
                                            @Nullable final XdmItem aContextItem) throws SaxonApiException
  {
    final XPathSelector aSelector = aExecutable.load ();
    if (aContextItem != null)
      aSelector.setContextItem (aContextItem);

    final Iterator <QName> it = aExecutable.iterateExternalVariables ();
    while (it.hasNext ())
    {
      final QName aName = it.next ();
      final XdmValue aValue = m_aLetVars.resolveVariable (aName);
      if (aValue != null)
        aSelector.setVariable (aName, aValue);
    }
    return aSelector;
  }

  /**
   * Get a selector for the provided executable, with the provided context item and the currently
   * effective values of all variables the expression references. Within one validation (that is,
   * for the lifetime of this context object) the selector of each executable is reused, as Saxon
   * allows to reuse a selector in a single thread for the evaluation of the same expression. A
   * variable value is only set on the selector if it is not the value set before. The returned
   * selector must be evaluated before this method is called again for the same executable.
   *
   * @param aExecutable
   *        The compiled XPath expression. May not be <code>null</code>.
   * @param aContextItem
   *        The context item. May be <code>null</code> for context-free expressions.
   * @return The selector, ready to be evaluated. Never <code>null</code>.
   * @throws SaxonApiException
   *         If applying the context item or a variable fails.
   */
  @NonNull
  private XPathSelector _getPreparedSelector (@NonNull final XPathExecutable aExecutable,
                                             @Nullable final XdmItem aContextItem) throws SaxonApiException
  {
    // A context item set before cannot be removed again
    if (aContextItem == null)
      return _createNewSelector (aExecutable, null);

    ReusableSelector aRS = m_aSelectors.get (aExecutable);
    if (aRS == null)
    {
      aRS = new ReusableSelector (aExecutable);
      m_aSelectors.put (aExecutable, aRS);
    }

    // Resolve all referenced variables first
    final int nVarCount = aRS.m_aVarNames.length;
    for (int i = 0; i < nVarCount; ++i)
    {
      final XdmValue aValue = m_aLetVars.resolveVariable (aRS.m_aVarNames[i]);
      if (aValue == null)
      {
        // A variable value set before cannot be removed again
        return _createNewSelector (aExecutable, aContextItem);
      }
      aRS.m_aNewValues[i] = aValue;
    }

    final XPathSelector aSelector = aRS.m_aSelector;
    aSelector.setContextItem (aContextItem);
    for (int i = 0; i < nVarCount; ++i)
    {
      final XdmValue aValue = aRS.m_aNewValues[i];
      aRS.m_aNewValues[i] = null;
      if (aValue != aRS.m_aSetValues[i])
      {
        // Forget the old value first, in case setting the new value fails
        aRS.m_aSetValues[i] = null;
        aSelector.setVariable (aRS.m_aVarNames[i], aValue);
        aRS.m_aSetValues[i] = aValue;
      }
    }
    return aSelector;
  }

  /**
   * Evaluate the provided executable with the provided context item and the currently effective
   * values of all variables the expression references. Within one validation (that is, for the
   * lifetime of this context object) the Saxon selector of each executable is reused. If the
   * evaluation fails, the selector is discarded, so that the next evaluation starts with a new
   * selector again (e.g. a document that could not be loaded is tried again).
   *
   * @param aExecutable
   *        The compiled XPath expression. May not be <code>null</code>.
   * @param aContextItem
   *        The context item. May be <code>null</code> for context-free expressions.
   * @return The result as an {@link XdmValue}. Never <code>null</code> (may be the empty sequence).
   * @throws SaxonApiException
   *         On evaluation failure.
   * @since 11.0.0
   */
  @NonNull
  public XdmValue evaluate (@NonNull final XPathExecutable aExecutable,
                            @Nullable final XdmItem aContextItem) throws SaxonApiException
  {
    try
    {
      return _getPreparedSelector (aExecutable, aContextItem).evaluate ();
    }
    catch (final SaxonApiException | RuntimeException ex)
    {
      m_aSelectors.remove (aExecutable);
      throw ex;
    }
  }

  /**
   * Evaluate the provided executable like {@link #evaluate(XPathExecutable, XdmItem)} but using the
   * XPath effective boolean value rules.
   *
   * @param aExecutable
   *        The compiled XPath expression. May not be <code>null</code>.
   * @param aContextItem
   *        The context item. May be <code>null</code> for context-free expressions.
   * @return The effective boolean value.
   * @throws SaxonApiException
   *         On evaluation failure.
   * @since 11.0.0
   */
  public boolean evaluateAsBoolean (@NonNull final XPathExecutable aExecutable,
                                    @Nullable final XdmItem aContextItem) throws SaxonApiException
  {
    try
    {
      return _getPreparedSelector (aExecutable, aContextItem).effectiveBooleanValue ();
    }
    catch (final SaxonApiException | RuntimeException ex)
    {
      m_aSelectors.remove (aExecutable);
      throw ex;
    }
  }

  /**
   * Wrap a DOM {@link Node} into a Saxon {@link XdmNode}. Saxon-backed DOM facades
   * ({@link NodeOverNodeInfo}) are unwrapped directly to their underlying NodeInfo; "real" DOM
   * nodes go through the {@link DocumentWrapper} of the current validation.
   *
   * @param aDomNode
   *        The DOM node to wrap. Must not be <code>null</code>.
   * @return The wrapped {@link XdmNode}. Never <code>null</code>.
   * @throws IllegalStateException
   *         If the node is a real DOM node but no {@link DocumentWrapper} was provided.
   */
  @NonNull
  public XdmNode wrap (@NonNull final Node aDomNode)
  {
    ValueEnforcer.notNull (aDomNode, "DomNode");

    if (aDomNode instanceof final NodeOverNodeInfo aSaxonFacade)
      return (XdmNode) XdmValue.wrap (aSaxonFacade.getUnderlyingNodeInfo ());

    if (m_aDocumentWrapper == null)
      throw new IllegalStateException ("Cannot wrap a non-Saxon DOM node without a DocumentWrapper.");
    return (XdmNode) XdmValue.wrap (m_aDocumentWrapper.wrap (aDomNode));
  }

  /**
   * @return The current thread's evaluation context, or <code>null</code> if no validation is in
   *         progress on this thread.
   */
  @Nullable
  public static XPathEvaluationContext current ()
  {
    return TL.get ();
  }

  /**
   * Install the given context as the current thread's evaluation context.
   *
   * @param aContext
   *        The context to install. May not be <code>null</code>.
   */
  public static void set (@NonNull final XPathEvaluationContext aContext)
  {
    ValueEnforcer.notNull (aContext, "Context");
    TL.set (aContext);
  }

  /**
   * Remove the current thread's evaluation context, if any.
   */
  public static void clear ()
  {
    TL.remove ();
  }
}
