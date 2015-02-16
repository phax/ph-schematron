package com.helger.schematron.xslt.util;

import javax.annotation.Nonnull;
import javax.xml.transform.ErrorListener;
import javax.xml.transform.TransformerException;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.io.IReadableResource;
import com.helger.schematron.pure.errorhandler.IPSErrorHandler;
import com.helger.schematron.pure.model.IPSElement;

/**
 * A wrapper around {@link IPSErrorHandler} to implement the
 * {@link ErrorListener} interface.
 * 
 * @author Philip Helger
 */
public class PSErrorListener implements ErrorListener
{
  private final IPSErrorHandler m_aPSErrorHandler;

  public PSErrorListener (@Nonnull final IPSErrorHandler aPSErrorHandler)
  {
    m_aPSErrorHandler = ValueEnforcer.notNull (aPSErrorHandler, "PSErrorHandler");
  }

  @Nonnull
  public IPSErrorHandler getErrorHandler ()
  {
    return m_aPSErrorHandler;
  }

  public void warning (@Nonnull final TransformerException ex) throws TransformerException
  {
    m_aPSErrorHandler.warn ((IReadableResource) null, (IPSElement) null, ex.getMessage ());
  }

  public void error (@Nonnull final TransformerException ex) throws TransformerException
  {
    m_aPSErrorHandler.error ((IReadableResource) null, (IPSElement) null, ex.getMessage (), ex);
  }

  public void fatalError (@Nonnull final TransformerException ex) throws TransformerException
  {
    m_aPSErrorHandler.error ((IReadableResource) null, (IPSElement) null, ex.getMessage (), ex);
  }
}
