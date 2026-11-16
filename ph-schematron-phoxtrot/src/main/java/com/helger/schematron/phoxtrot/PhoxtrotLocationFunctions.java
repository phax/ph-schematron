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
package com.helger.schematron.phoxtrot;

import java.util.concurrent.atomic.AtomicBoolean;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.ThreadSafe;
import com.helger.collection.commons.CommonsHashMap;
import com.helger.collection.commons.ICommonsMap;
import com.helger.phoxtrot.xdm.IXdmNode;
import com.helger.phoxtrot.xdm.XdmQName;
import com.helger.phoxtrot.xpath.context.DynamicContext;
import com.helger.phoxtrot.xpath.value.XdmAtomic;
import com.helger.phoxtrot.xpath.value.XdmSequence;
import com.helger.phoxtrot.xslt.compile.XsltExtensionRegistry;
import com.helger.schematron.api.xslt.CSchematronLocationFunctions;

/**
 * The phoxtrot implementation of the extension function
 * {@link CSchematronLocationFunctions#LOCAL_NAME_INDEX_BY_NS_NAME}, with which a stylesheet can
 * compute the SVRL <code>location</code> of an element in linear time. It determines the positions
 * of all child elements of a parent once per transformation and remembers them. The other functions
 * of {@link CSchematronLocationFunctions} are only used by the pure XSLT engine, which runs on Saxon
 * only.
 * <p>
 * phoxtrot has no per factory function library, so the function is registered once in the global
 * {@link XsltExtensionRegistry} and is available to every stylesheet that phoxtrot compiles
 * afterwards. It is in a namespace of its own, so it cannot hide another function.
 * </p>
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@ThreadSafe
public final class PhoxtrotLocationFunctions
{
  private static final String RUN_CACHE_KEY = PhoxtrotLocationFunctions.class.getName ();
  private static final AtomicBoolean REGISTERED = new AtomicBoolean (false);

  /**
   * The positions of the child elements of all parents seen in one transformation.
   */
  private static final class IndexCache
  {
    // The nodes have no equals, so they are compared by identity
    private final ICommonsMap <IXdmNode, int []> m_aIndexes = new CommonsHashMap <> ();

    private void _addAllChildElements (@NonNull final IXdmNode aParent)
    {
      final ICommonsMap <XdmQName, int []> aByNsName = new CommonsHashMap <> ();
      final int nCount = aParent.getChildCount ();
      for (int i = 0; i < nCount; ++i)
      {
        final IXdmNode aChild = aParent.getChildAtIndex (i);
        if (aChild.isElement ())
        {
          final XdmQName aName = aChild.getName ();
          // The prefix is not part of the comparison
          final XdmQName aKey = new XdmQName (aName.namespaceUri (), aName.localName ());
          final int nByNsName = ++aByNsName.computeIfAbsent (aKey, k -> new int [1])[0];
          m_aIndexes.put (aChild, new int [] { nByNsName });
        }
      }
    }

    int getIndexByNsName (@NonNull final IXdmNode aElement)
    {
      int [] ret = m_aIndexes.get (aElement);
      if (ret == null)
      {
        final IXdmNode aParent = aElement.getParent ();
        if (aParent != null)
        {
          _addAllChildElements (aParent);
          ret = m_aIndexes.get (aElement);
        }
        if (ret == null)
        {
          // An element without a parent has no siblings
          ret = new int [] { 1 };
          m_aIndexes.put (aElement, ret);
        }
      }
      return ret[0];
    }
  }

  private PhoxtrotLocationFunctions ()
  {}

  @NonNull
  private static XdmSequence _indexByNsName (@NonNull final DynamicContext aCtx, @NonNull final IXdmNode aElement)
  {
    final IndexCache aCache = (IndexCache) aCtx.getRunCache ().computeIfAbsent (RUN_CACHE_KEY, k -> new IndexCache ());
    return XdmSequence.of (XdmAtomic.integer (aCache.getIndexByNsName (aElement)));
  }

  /**
   * Register the location function in the global {@link XsltExtensionRegistry}, unless that was
   * already done. It is available to all stylesheets compiled afterwards.
   */
  public static void registerIfMissing ()
  {
    if (REGISTERED.compareAndSet (false, true))
      XsltExtensionRegistry.getInstance ()
                           .registerFunctions (aLib -> aLib.register (CSchematronLocationFunctions.NAMESPACE_URI,
                                                                      CSchematronLocationFunctions.LOCAL_NAME_INDEX_BY_NS_NAME,
                                                                      "(element()) as xs:integer",
                                                                      (aCtx, aArgs) -> _indexByNsName (aCtx,
                                                                                                       (IXdmNode) aArgs.get (0)
                                                                                                                       .get (0))));
  }
}
