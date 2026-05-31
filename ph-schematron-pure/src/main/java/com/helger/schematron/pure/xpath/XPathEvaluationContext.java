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

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.w3c.dom.Node;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.collection.commons.ICommonsMap;

import net.sf.saxon.dom.DocumentWrapper;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.XdmNode;
import net.sf.saxon.s9api.XdmValue;

/**
 * Per-thread context that lets the SVRL validation handler (or any other code invoked downstream
 * from
 * {@link com.helger.schematron.pure.bound.xpath.PSXPathBoundSchema#validate(Node, String, com.helger.schematron.pure.validation.IPSValidationHandler)})
 * re-wrap DOM nodes into Saxon {@link XdmNode}s using the same {@link DocumentWrapper} as the
 * bound schema, and access the currently effective Schematron variable bindings.
 *
 * @author Philip Helger
 * @since 9.2.0
 */
@NotThreadSafe
public final class XPathEvaluationContext
{
  private static final ThreadLocal <XPathEvaluationContext> TL = new ThreadLocal <> ();

  private final Processor m_aProcessor;
  private final DocumentWrapper m_aDocumentWrapper;
  private final XPathLetVariableResolver m_aLetVars;
  private final String m_sBaseURI;

  public XPathEvaluationContext (@NonNull final Processor aProcessor,
                                 @NonNull final DocumentWrapper aDocumentWrapper,
                                 @NonNull final XPathLetVariableResolver aLetVars,
                                 @Nullable final String sBaseURI)
  {
    m_aProcessor = ValueEnforcer.notNull (aProcessor, "Processor");
    m_aDocumentWrapper = ValueEnforcer.notNull (aDocumentWrapper, "DocumentWrapper");
    m_aLetVars = ValueEnforcer.notNull (aLetVars, "LetVars");
    m_sBaseURI = sBaseURI;
  }

  @NonNull
  public Processor getProcessor ()
  {
    return m_aProcessor;
  }

  @NonNull
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
   * Wrap a DOM {@link Node} into a Saxon {@link XdmNode} using the document wrapper of the current
   * validation.
   *
   * @param aDomNode
   *        The DOM node to wrap. Must not be <code>null</code>.
   * @return The wrapped {@link XdmNode}. Never <code>null</code>.
   */
  @NonNull
  public XdmNode wrap (@NonNull final Node aDomNode)
  {
    ValueEnforcer.notNull (aDomNode, "DomNode");
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
