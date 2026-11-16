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

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import java.io.File;

import javax.xml.catalog.CatalogResolver;

import org.junit.Test;
import org.xml.sax.InputSource;

import com.helger.collection.commons.CommonsArrayList;

/**
 * Test class for class {@link SchematronCatalogHelper}.
 *
 * @author Philip Helger
 */
public final class SchematronCatalogHelperTest
{
  private static final File CATALOG = new File ("src/test/resources/external/catalog/catalog.xml");

  @Test
  public void testNoCatalog ()
  {
    assertNull (SchematronCatalogHelper.createCatalogResolver (null));
    assertNull (SchematronCatalogHelper.createCatalogResolver (new CommonsArrayList <> ()));
  }

  @Test (expected = IllegalArgumentException.class)
  public void testMissingCatalog ()
  {
    SchematronCatalogHelper.createCatalogResolver (new CommonsArrayList <> (new File ("does-not-exist.xml")));
  }

  @Test
  public void testResolve () throws Exception
  {
    final CatalogResolver aResolver = SchematronCatalogHelper.createCatalogResolver (new CommonsArrayList <> (CATALOG));
    assertNotNull (aResolver);

    // Catalog entry: resolved relative to the catalog
    final InputSource aIS = aResolver.resolveEntity ("-//helger//DTD catalog test//EN",
                                                     "http://www.example.invalid/does-not-exist.dtd");
    assertNotNull (aIS);
    assertTrue (aIS.getSystemId (), aIS.getSystemId ().endsWith ("/external/catalog/test.dtd"));

    // No catalog entry: continue as usual
    assertNull (aResolver.resolveEntity ("-//helger//DTD unknown//EN", "http://www.example.invalid/unknown.dtd"));
  }
}
