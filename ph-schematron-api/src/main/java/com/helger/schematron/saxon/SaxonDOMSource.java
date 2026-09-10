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
package com.helger.schematron.saxon;

import javax.xml.transform.dom.DOMSource;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.w3c.dom.Node;

import com.helger.base.enforce.ValueEnforcer;

/**
 * A DOM source that opts into copying documents to the transformer's configured Saxon tree model
 * before XSLT-based Schematron validation. Native Saxon trees can substantially reduce the cost of
 * repeated XPath navigation over large DOM documents.
 * <p>
 * The original DOM is not modified. Unlike a regular {@link DOMSource}, the transformation uses a
 * snapshot: DOM object identity is not retained, and base URIs are resolved against this source's
 * system ID while building the tree. Use a regular {@link DOMSource} when the stylesheet or
 * extension functions require the original DOM nodes or wrapped-DOM behavior.
 * <p>
 * Conversion uses the running transformer's configuration, so the source can be reused across
 * validators with different Saxon configurations. No converted tree is cached. With a custom
 * non-Saxon transformer, or a node other than a document, this behaves like a regular
 * {@link DOMSource}.
 *
 * @author Philip Helger
 * @since 10.0.2
 */
public class SaxonDOMSource extends DOMSource
{
  /**
   * @param aNode
   *        The DOM node to snapshot for validation. May not be <code>null</code>.
   */
  public SaxonDOMSource (@NonNull final Node aNode)
  {
    this (aNode, null);
  }

  /**
   * @param aNode
   *        The DOM node to snapshot for validation. May not be <code>null</code>.
   * @param sSystemID
   *        The base URI to use when building the native tree. May be <code>null</code>.
   */
  public SaxonDOMSource (@NonNull final Node aNode, @Nullable final String sSystemID)
  {
    super (ValueEnforcer.notNull (aNode, "Node"), sSystemID);
  }
}
