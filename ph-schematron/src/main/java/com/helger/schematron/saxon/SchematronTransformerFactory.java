package com.helger.schematron.saxon;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.xml.transform.ErrorListener;
import javax.xml.transform.Source;
import javax.xml.transform.Templates;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.URIResolver;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.commons.CGlobal;
import com.helger.commons.ValueEnforcer;
import com.helger.commons.exception.InitializationException;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.xml.transform.DefaultTransformURIResolver;
import com.helger.commons.xml.transform.LoggingTransformErrorListener;
import com.helger.commons.xml.transform.TransformSourceFactory;

import net.sf.saxon.TransformerFactoryImpl;

/**
 * A special {@link TransformerFactory} handler that always uses Saxon's
 * {@link TransformerFactory} instead of calling the SPI version
 * <code>TransformerFactory.newInstance ()</code>. This is mainly to solve the
 * interoperability issue when using Xalan and Saxon together in the class path.
 *
 * @author Philip Helger
 */
public final class SchematronTransformerFactory
{
  private static final Logger s_aLogger = LoggerFactory.getLogger (SchematronTransformerFactory.class);
  private static final TransformerFactory s_aDefaultFactory;

  static
  {
    s_aDefaultFactory = createTransformerFactory (new LoggingTransformErrorListener (CGlobal.DEFAULT_LOCALE),
                                                  new DefaultTransformURIResolver ());
  }

  private SchematronTransformerFactory ()
  {}

  @Nonnull
  public static TransformerFactory createTransformerFactory (@Nullable final ErrorListener aErrorListener,
                                                             @Nullable final URIResolver aURIResolver)
  {
    try
    {
      // Force to SAXON!
      final TransformerFactory aFactory = true ? new TransformerFactoryImpl () : TransformerFactory.newInstance ();
      if (aErrorListener != null)
        aFactory.setErrorListener (aErrorListener);
      if (aURIResolver != null)
        aFactory.setURIResolver (aURIResolver);
      return aFactory;
    }
    catch (final TransformerFactoryConfigurationError ex)
    {
      throw new InitializationException ("Failed to create XML TransformerFactory", ex);
    }
  }

  /**
   * Create a new XSLT Template for the passed resource. This uses the central
   * <b>not thread safe</b> transformer factory.
   *
   * @param aResource
   *        The resource to be templated. May not be <code>null</code>.
   * @return <code>null</code> if something goes wrong
   */
  @Nullable
  public static Templates newTemplates (@Nonnull final IReadableResource aResource)
  {
    return newTemplates (s_aDefaultFactory, TransformSourceFactory.create (aResource));
  }

  /**
   * Create a new XSLT Template for the passed resource. This uses the central
   * <b>not thread safe</b> transformer factory.
   *
   * @param aSource
   *        The resource to be templated. May not be <code>null</code>.
   * @return <code>null</code> if something goes wrong
   */
  @Nullable
  public static Templates newTemplates (@Nonnull final Source aSource)
  {
    return newTemplates (s_aDefaultFactory, aSource);
  }

  /**
   * Create a new XSLT Template for the passed resource.
   *
   * @param aTransformerFactory
   *        The transformer factory to be used. May not be <code>null</code>.
   * @param aSource
   *        The resource to be templated. May not be <code>null</code>.
   * @return <code>null</code> if something goes wrong
   */
  @Nullable
  public static Templates newTemplates (@Nonnull final TransformerFactory aTransformerFactory,
                                        @Nonnull final Source aSource)
  {
    ValueEnforcer.notNull (aTransformerFactory, "TransformerFactory");
    ValueEnforcer.notNull (aSource, "Source");

    try
    {
      return aTransformerFactory.newTemplates (aSource);
    }
    catch (final TransformerConfigurationException ex)
    {
      s_aLogger.error ("Failed to parse " + aSource, ex);
      return null;
    }
  }
}
