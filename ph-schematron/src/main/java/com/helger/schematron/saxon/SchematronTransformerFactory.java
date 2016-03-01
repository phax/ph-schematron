package com.helger.schematron.saxon;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.xml.transform.ErrorListener;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.URIResolver;

import com.helger.commons.CGlobal;
import com.helger.commons.exception.InitializationException;
import com.helger.commons.lang.ClassLoaderHelper;
import com.helger.commons.xml.transform.DefaultTransformURIResolver;
import com.helger.commons.xml.transform.LoggingTransformErrorListener;

/**
 * A special {@link TransformerFactory} handler that prefers Saxon's
 * {@link TransformerFactory} before calling the SPI version
 * <code>TransformerFactory.newInstance ()</code>. This is mainly to solve the
 * interoperability issue when using Xalan and Saxon together in the class path.
 *
 * @author Philip Helger
 */
public final class SchematronTransformerFactory
{
  private static final TransformerFactory s_aDefaultFactory;

  static
  {
    s_aDefaultFactory = createTransformerFactorySaxonFirst (new LoggingTransformErrorListener (CGlobal.DEFAULT_LOCALE),
                                                            new DefaultTransformURIResolver ());
  }

  private SchematronTransformerFactory ()
  {}

  @Nonnull
  public static TransformerFactory getDefaultSaxonFirst ()
  {
    return s_aDefaultFactory;
  }

  @Nonnull
  public static TransformerFactory createTransformerFactorySaxonFirst (@Nullable final ErrorListener aErrorListener,
                                                                       @Nullable final URIResolver aURIResolver)
  {
    TransformerFactory aFactory;
    try
    {
      // Try Saxon first
      aFactory = TransformerFactory.newInstance ("net.sf.saxon.TransformerFactoryImpl",
                                                 ClassLoaderHelper.getContextClassLoader ());
    }
    catch (final TransformerFactoryConfigurationError ex)
    {
      try
      {
        // Try default afterwards
        aFactory = TransformerFactory.newInstance ();
      }
      catch (final TransformerFactoryConfigurationError ex2)
      {
        throw new InitializationException ("Failed to create XML TransformerFactory", ex2);
      }
    }
    if (aErrorListener != null)
      aFactory.setErrorListener (aErrorListener);
    if (aURIResolver != null)
      aFactory.setURIResolver (aURIResolver);
    return aFactory;
  }
}
