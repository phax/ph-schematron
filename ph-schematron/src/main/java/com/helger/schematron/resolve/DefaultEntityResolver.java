package com.helger.schematron.resolve;

import java.io.IOException;
import java.net.URL;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import org.xml.sax.EntityResolver;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.DevelopersNote;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.xml.ls.SimpleLSResourceResolver;
import com.helger.xml.sax.InputSourceFactory;

/**
 * A simple version of {@link EntityResolver} using
 * {@link SimpleLSResourceResolver} with a base URL.<br>
 * TODO use version from ph-commons
 *
 * @author Philip Helger
 */
@Deprecated
@DevelopersNote ("Use version from ph-commons as of 8.6.5")
public class DefaultEntityResolver implements EntityResolver
{
  private final String m_sBaseURI;

  public DefaultEntityResolver (@Nonnull final URL aBaseURL)
  {
    this (aBaseURL.toExternalForm ());
  }

  public DefaultEntityResolver (@Nonnull final String sBaseURI)
  {
    m_sBaseURI = ValueEnforcer.notNull (sBaseURI, "BaseURI");
  }

  @Nullable
  public InputSource resolveEntity (@Nullable final String sPublicID,
                                    @Nullable final String sSystemID) throws SAXException, IOException
  {
    final IReadableResource aResolvedRes = SimpleLSResourceResolver.doStandardResourceResolving (sSystemID, m_sBaseURI);
    if (aResolvedRes == null)
      return null;
    return InputSourceFactory.create (aResolvedRes);
  }

  /**
   * Factory method with a resource.
   *
   * @param aBaseResource
   *        The base resource. May not be <code>null</code>.
   * @return <code>null</code> if the resource does not exist
   */
  @Nullable
  public static DefaultEntityResolver createOnDemand (@Nonnull final IReadableResource aBaseResource)
  {
    final URL aURL = aBaseResource.getAsURL ();
    return aURL == null ? null : new DefaultEntityResolver (aURL);
  }
}
