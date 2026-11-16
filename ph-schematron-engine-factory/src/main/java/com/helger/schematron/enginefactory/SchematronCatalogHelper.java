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
package com.helger.schematron.enginefactory;

import java.io.File;
import java.net.URI;
import java.util.List;

import javax.xml.catalog.CatalogFeatures;
import javax.xml.catalog.CatalogManager;
import javax.xml.catalog.CatalogResolver;

import org.jspecify.annotations.Nullable;

import com.helger.annotation.concurrent.Immutable;

/**
 * Creates the resolver for OASIS XML catalog files with the JDK catalog API
 * (<code>javax.xml.catalog</code>).
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@Immutable
public final class SchematronCatalogHelper
{
  private SchematronCatalogHelper ()
  {}

  /**
   * Create a resolver from XML catalog files. The resolver is both an
   * {@link org.xml.sax.EntityResolver} and a {@link javax.xml.transform.URIResolver}. References
   * that are not in a catalog are resolved as usual.
   *
   * @param aCatalogFiles
   *        The catalog files to use. May be <code>null</code>.
   * @return <code>null</code> if no catalog file is provided.
   * @throws IllegalArgumentException
   *         If a catalog file does not exist
   */
  @Nullable
  public static CatalogResolver createCatalogResolver (@Nullable final List <File> aCatalogFiles)
  {
    if (aCatalogFiles == null || aCatalogFiles.isEmpty ())
      return null;

    final URI [] aURIs = new URI [aCatalogFiles.size ()];
    int nIndex = 0;
    for (final File aFile : aCatalogFiles)
    {
      if (!aFile.isFile ())
        throw new IllegalArgumentException ("The XML catalog file '" + aFile.getPath () + "' does not exist");
      aURIs[nIndex++] = aFile.getAbsoluteFile ().toURI ();
    }

    // "continue" lets references without a catalog entry pass instead of failing
    final CatalogFeatures aFeatures = CatalogFeatures.builder ()
                                                     .with (CatalogFeatures.Feature.RESOLVE, "continue")
                                                     .build ();
    return CatalogManager.catalogResolver (aFeatures, aURIs);
  }
}
