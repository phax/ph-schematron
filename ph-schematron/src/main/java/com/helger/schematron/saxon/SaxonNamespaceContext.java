package com.helger.schematron.saxon;

import java.util.Iterator;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.xml.namespace.NamespaceContext;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.collection.ext.CommonsArrayList;
import com.helger.commons.collection.ext.ICommonsList;
import com.helger.commons.string.StringHelper;
import com.helger.commons.xml.namespace.MapBasedNamespaceContext;

import net.sf.saxon.om.NamespaceResolver;

public final class SaxonNamespaceContext implements NamespaceContext, NamespaceResolver
{
  private final MapBasedNamespaceContext m_aCtx;

  public SaxonNamespaceContext (@Nonnull final MapBasedNamespaceContext aCtx)
  {
    m_aCtx = ValueEnforcer.notNull (aCtx, "Ctx");
  }

  @Nullable
  public String getURIForPrefix (@Nullable final String sPrefix, final boolean bUseDefault)
  {
    if (bUseDefault && StringHelper.hasNoText (sPrefix))
      return m_aCtx.getDefaultNamespaceURI ();
    return m_aCtx.getCustomNamespaceURI (sPrefix);
  }

  @Nonnull
  public Iterator <String> iteratePrefixes ()
  {
    final ICommonsList <String> aList = new CommonsArrayList <> (m_aCtx.getPrefixToNamespaceURIMap ().keySet ());
    aList.add ("");
    return aList.iterator ();
  }

  @Nonnull
  public String getNamespaceURI (@Nonnull final String sPrefix)
  {
    return m_aCtx.getNamespaceURI (sPrefix);
  }

  @Nullable
  public String getPrefix (@Nonnull final String sNamespaceURI)
  {
    return m_aCtx.getPrefix (sNamespaceURI);
  }

  @Nonnull
  public Iterator <?> getPrefixes (@Nonnull final String sNamespaceURI)
  {
    return m_aCtx.getPrefixes (sNamespaceURI);
  }
}