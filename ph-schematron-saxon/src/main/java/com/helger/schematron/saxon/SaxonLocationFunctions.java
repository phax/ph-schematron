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
package com.helger.schematron.saxon;

import java.util.Map;
import java.util.WeakHashMap;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.concurrent.GuardedBy;
import com.helger.annotation.concurrent.ThreadSafe;
import com.helger.base.concurrent.SimpleLock;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.CommonsHashMap;
import com.helger.collection.commons.ICommonsList;
import com.helger.collection.commons.ICommonsMap;
import com.helger.schematron.api.xslt.CSchematronLocationFunctions;

import net.sf.saxon.Configuration;
import net.sf.saxon.Controller;
import net.sf.saxon.expr.XPathContext;
import net.sf.saxon.lib.ExtensionFunctionCall;
import net.sf.saxon.lib.ExtensionFunctionDefinition;
import net.sf.saxon.om.GNode;
import net.sf.saxon.om.NamespaceUri;
import net.sf.saxon.om.NodeInfo;
import net.sf.saxon.om.Sequence;
import net.sf.saxon.om.StructuredQName;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.trans.XPathException;
import net.sf.saxon.tree.util.Navigator;
import net.sf.saxon.type.Type;
import net.sf.saxon.value.Int64Value;
import net.sf.saxon.value.SequenceType;
import net.sf.saxon.value.StringValue;

/**
 * The Saxon implementation of the extension functions of {@link CSchematronLocationFunctions},
 * which compute the SVRL <code>location</code> of a node in linear time. They determine the
 * positions of all child elements of a parent once per transformation and remember them.
 * <p>
 * They are registered on the {@link Processor} of the pure XSLT engine and on every
 * {@link javax.xml.transform.TransformerFactory} created by {@link SchematronTransformerFactory}.
 * </p>
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@ThreadSafe
public final class SaxonLocationFunctions
{
  private static final String CACHE_KEY = SaxonLocationFunctions.class.getName ();
  private static final String CACHE_NAME = "element-indexes";
  private static final String FN_ROOT = "Q{" + NamespaceUri.FN.toString () + "}root()";

  private static final SimpleLock LOCK = new SimpleLock ();
  @GuardedBy ("LOCK")
  private static final Map <Configuration, Boolean> REGISTERED = new WeakHashMap <> ();

  /**
   * The positions of the child elements of all parents seen in one transformation.
   */
  private static final class IndexCache
  {
    private static final int [] PARENTLESS = { 1, 1 };

    // Element to { position by name(), position by namespace URI and local name }
    private final ICommonsMap <NodeInfo, int []> m_aIndexes = new CommonsHashMap <> ();

    private void _addAllChildElements (@NonNull final NodeInfo aParent)
    {
      final ICommonsMap <String, int []> aByName = new CommonsHashMap <> ();
      final ICommonsMap <String, int []> aByNsName = new CommonsHashMap <> ();
      for (final NodeInfo aChild : aParent.children ())
        if (aChild.getNodeKind () == Type.ELEMENT)
        {
          // A local name never contains a '}', so the key is unique
          final String sNsName = "Q{" + aChild.getNamespaceUri ().toString () + "}" + aChild.getLocalPart ();
          final int nByName = ++aByName.computeIfAbsent (aChild.getDisplayName (), k -> new int [1])[0];
          final int nByNsName = ++aByNsName.computeIfAbsent (sNsName, k -> new int [1])[0];
          m_aIndexes.put (aChild, new int [] { nByName, nByNsName });
        }
    }

    @NonNull
    int [] getIndexes (@NonNull final NodeInfo aElement)
    {
      int [] ret = m_aIndexes.get (aElement);
      if (ret == null)
      {
        if (aElement.getParent () instanceof final NodeInfo aParent)
        {
          _addAllChildElements (aParent);
          ret = m_aIndexes.get (aElement);
        }
        if (ret == null)
        {
          // An element without a parent has no siblings
          ret = PARENTLESS;
          m_aIndexes.put (aElement, ret);
        }
      }
      return ret;
    }
  }

  private SaxonLocationFunctions ()
  {}

  @NonNull
  private static IndexCache _getCache (@NonNull final XPathContext aContext)
  {
    final Controller aController = aContext.getController ();
    if (aController == null)
    {
      // No transformation to remember the positions for
      return new IndexCache ();
    }
    IndexCache ret = (IndexCache) aController.getUserData (CACHE_KEY, CACHE_NAME);
    if (ret == null)
    {
      ret = new IndexCache ();
      aController.setUserData (CACHE_KEY, CACHE_NAME, ret);
    }
    return ret;
  }

  @NonNull
  private static String _getQualifier (@NonNull final NamespaceUri aNamespaceURI)
  {
    return "Q{" + aNamespaceURI.toString () + "}";
  }

  /**
   * Get the path of a node like <code>fn:path()</code> without options.
   *
   * @param aNode
   *        The node to get the path of. May not be <code>null</code>.
   * @param aCache
   *        The cache with the element positions. May not be <code>null</code>.
   * @param aContext
   *        The dynamic context, used for the positions of other nodes than elements. May be
   *        <code>null</code>.
   * @return The path. Never <code>null</code>.
   */
  @NonNull
  private static String _getPath (@NonNull final NodeInfo aNode,
                                   @NonNull final IndexCache aCache,
                                   @Nullable final XPathContext aContext)
  {
    if (aNode.getNodeKind () == Type.DOCUMENT)
      return "/";

    final ICommonsList <String> aSteps = new CommonsArrayList <> ();
    String sRoot = "";
    NodeInfo aCur = aNode;
    while (true)
    {
      final GNode aParent = aCur.getParent ();
      if (!(aParent instanceof final NodeInfo aParentNode))
      {
        // A tree that is not rooted at a document node
        if (aCur.getNodeKind () != Type.DOCUMENT)
          sRoot = FN_ROOT;
        break;
      }

      switch (aCur.getNodeKind ())
      {
        case Type.ELEMENT:
          aSteps.add ("/" +
                      _getQualifier (aCur.getNamespaceUri ()) +
                      aCur.getLocalPart () +
                      "[" +
                      aCache.getIndexes (aCur)[1] +
                      "]");
          break;
        case Type.ATTRIBUTE:
          aSteps.add ("/@" +
                      (aCur.getNamespaceUri () == NamespaceUri.NULL ? "" : _getQualifier (aCur.getNamespaceUri ())) +
                      aCur.getLocalPart ());
          break;
        case Type.TEXT:
          aSteps.add ("/text()[" + Navigator.getNumberSimple (aCur, aContext) + "]");
          break;
        case Type.COMMENT:
          aSteps.add ("/comment()[" + Navigator.getNumberSimple (aCur, aContext) + "]");
          break;
        case Type.PROCESSING_INSTRUCTION:
          aSteps.add ("/processing-instruction(" +
                      aCur.getLocalPart () +
                      ")[" +
                      Navigator.getNumberSimple (aCur, aContext) +
                      "]");
          break;
        case Type.NAMESPACE:
          aSteps.add ("/namespace::" +
                      (aCur.getLocalPart ().isEmpty () ? "*[" + _getQualifier (NamespaceUri.FN) + "local-name()=\"\"]"
                                                       : aCur.getLocalPart ()));
          break;
        default:
          throw new IllegalStateException ("Unexpected node kind " + aCur.getNodeKind ());
      }
      aCur = aParentNode;
    }

    final StringBuilder aSB = new StringBuilder (sRoot);
    for (int i = aSteps.size () - 1; i >= 0; --i)
      aSB.append (aSteps.get (i));
    return aSB.toString ();
  }

  private abstract static class AbstractLocationFunction extends ExtensionFunctionDefinition
  {
    private final StructuredQName m_aName;
    private final SequenceType m_aResultType;

    AbstractLocationFunction (@NonNull final String sLocalName, @NonNull final SequenceType aResultType)
    {
      m_aName = new StructuredQName (CSchematronLocationFunctions.DEFAULT_PREFIX,
                                     CSchematronLocationFunctions.NAMESPACE_URI,
                                     sLocalName);
      m_aResultType = aResultType;
    }

    @Override
    public final StructuredQName getFunctionQName ()
    {
      return m_aName;
    }

    @Override
    public final SequenceType [] getArgumentTypes ()
    {
      return new SequenceType [] { SequenceType.SINGLE_NODE };
    }

    @Override
    public final SequenceType getResultType (final SequenceType [] aSuppliedArgumentTypes)
    {
      return m_aResultType;
    }

    @NonNull
    protected abstract Sequence call (@NonNull NodeInfo aNode,
                                      @NonNull IndexCache aCache,
                                      @NonNull XPathContext aContext) throws XPathException;

    @Override
    public final ExtensionFunctionCall makeCallExpression ()
    {
      return new ExtensionFunctionCall ()
      {
        @Override
        public Sequence call (final XPathContext aContext, final Sequence [] aArgs) throws XPathException
        {
          if (!(aArgs[0].head () instanceof final NodeInfo aNode))
            throw new XPathException ("Function " + m_aName.getDisplayName () + " expects a node");
          return AbstractLocationFunction.this.call (aNode, _getCache (aContext), aContext);
        }
      };
    }
  }

  private static final class IndexFunction extends AbstractLocationFunction
  {
    private final int m_nIndex;

    IndexFunction (@NonNull final String sLocalName, final int nIndex)
    {
      super (sLocalName, SequenceType.SINGLE_INTEGER);
      m_nIndex = nIndex;
    }

    @Override
    protected Sequence call (@NonNull final NodeInfo aNode,
                             @NonNull final IndexCache aCache,
                             @NonNull final XPathContext aContext) throws XPathException
    {
      if (aNode.getNodeKind () != Type.ELEMENT)
        throw new XPathException ("Function " + getFunctionQName ().getDisplayName () + " expects an element");
      return Int64Value.makeIntegerValue (aCache.getIndexes (aNode)[m_nIndex]);
    }
  }

  private static final class PathFunction extends AbstractLocationFunction
  {
    PathFunction ()
    {
      super (CSchematronLocationFunctions.LOCAL_NAME_FN_PATH, SequenceType.SINGLE_STRING);
    }

    @Override
    protected Sequence call (@NonNull final NodeInfo aNode,
                             @NonNull final IndexCache aCache,
                             @NonNull final XPathContext aContext) throws XPathException
    {
      return StringValue.makeStringValue (_getPath (aNode, aCache, aContext));
    }
  }

  /**
   * Register the location functions on the passed {@link Configuration}, unless that was already
   * done. Saxon considers functions registered this way as trusted, so they also work if calls to
   * external functions are disallowed.
   *
   * @param aConfig
   *        The configuration that compiles the stylesheet. May not be <code>null</code>.
   */
  public static void registerIfMissing (@NonNull final Configuration aConfig)
  {
    LOCK.locked ( () -> {
      if (REGISTERED.put (aConfig, Boolean.TRUE) == null)
      {
        aConfig.registerExtensionFunction (new PathFunction ());
        aConfig.registerExtensionFunction (new IndexFunction (CSchematronLocationFunctions.LOCAL_NAME_INDEX_BY_NAME,
                                                              0));
        aConfig.registerExtensionFunction (new IndexFunction (CSchematronLocationFunctions.LOCAL_NAME_INDEX_BY_NS_NAME,
                                                              1));
      }
    });
  }

  /**
   * Register the location functions on the {@link Configuration} of the passed {@link Processor},
   * unless that was already done.
   *
   * @param aProcessor
   *        The processor that compiles the stylesheet. May not be <code>null</code>.
   * @see #registerIfMissing(Configuration)
   */
  public static void registerIfMissing (@NonNull final Processor aProcessor)
  {
    registerIfMissing (aProcessor.getUnderlyingConfiguration ());
  }
}
