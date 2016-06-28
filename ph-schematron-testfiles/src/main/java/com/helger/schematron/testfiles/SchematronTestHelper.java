/**
 * Copyright (C) 2014-2016 Philip Helger (www.helger.com)
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
package com.helger.schematron.testfiles;

import javax.annotation.Nonnull;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.Nonempty;
import com.helger.commons.collection.ext.CommonsArrayList;
import com.helger.commons.collection.ext.ICommonsList;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.xml.microdom.IMicroDocument;
import com.helger.xml.microdom.IMicroElement;
import com.helger.xml.microdom.serialize.MicroReader;

/**
 * A utility class to list all the available test files.
 *
 * @author Philip Helger
 */
public final class SchematronTestHelper
{
  private static final ICommonsList <SchematronTestFile> s_aSCHs = _readDI (new ClassPathResource ("test-sch/dirindex.xml"));
  private static final ICommonsList <SchematronTestFile> s_aSVRLs = _readDI (new ClassPathResource ("test-svrl/dirindex.xml"));
  private static final ICommonsList <SchematronTestFile> s_aXMLs = _readDI (new ClassPathResource ("test-xml/dirindex.xml"));

  @Nonnull
  private static ICommonsList <SchematronTestFile> _readDI (@Nonnull final IReadableResource aDI)
  {
    ValueEnforcer.notNull (aDI, "Resource");
    ValueEnforcer.isTrue (aDI.exists (), () -> "Resource " + aDI + " does not exist!");

    final ICommonsList <SchematronTestFile> ret = new CommonsArrayList<> ();
    final IMicroDocument aDoc = MicroReader.readMicroXML (aDI);
    if (aDoc == null)
      throw new IllegalArgumentException ("Failed to open/parse " + aDI + " as XML");
    String sLastParentDirBaseName = null;
    for (final IMicroElement eItem : aDoc.getDocumentElement ().getAllChildElements ())
      if (eItem.getTagName ().equals ("directory"))
        sLastParentDirBaseName = eItem.getAttributeValue ("basename");
      else
        if (eItem.getTagName ().equals ("file"))
          ret.add (new SchematronTestFile (sLastParentDirBaseName,
                                           new ClassPathResource (eItem.getAttributeValue ("name")),
                                           eItem.getAttributeValue ("basename")));
        else
          throw new IllegalArgumentException ("Cannot handle " + eItem);
    return ret;
  }

  private SchematronTestHelper ()
  {}

  @Nonnull
  @Nonempty
  public static ICommonsList <IReadableResource> getAllValidSchematronFiles ()
  {
    return s_aSCHs.getAllMapped (aFile -> !aFile.getFileBaseName ().startsWith ("invalid") &&
                                          !aFile.getParentDirBaseName ().equals ("include"),
                                 SchematronTestFile::getResource);
  }

  @Nonnull
  @Nonempty
  public static ICommonsList <IReadableResource> getAllInvalidSchematronFiles ()
  {
    return s_aSCHs.getAllMapped (aFile -> aFile.getFileBaseName ().startsWith ("invalid") &&
                                          !aFile.getParentDirBaseName ().equals ("include"),
                                 SchematronTestFile::getResource);
  }

  @Nonnull
  @Nonempty
  public static ICommonsList <IReadableResource> getAllValidSVRLFiles ()
  {
    return s_aSVRLs.getAllMapped (aFile -> !aFile.getFileBaseName ().startsWith ("invalid"),
                                  SchematronTestFile::getResource);
  }

  @Nonnull
  @Nonempty
  public static ICommonsList <IReadableResource> getAllInvalidSVRLFiles ()
  {
    return s_aSVRLs.getAllMapped (aFile -> aFile.getFileBaseName ().startsWith ("invalid"),
                                  SchematronTestFile::getResource);
  }

  @Nonnull
  @Nonempty
  public static ICommonsList <IReadableResource> getAllValidXMLFiles ()
  {
    return s_aXMLs.getAllMapped (aFile -> !aFile.getFileBaseName ().startsWith ("invalid"),
                                 SchematronTestFile::getResource);
  }

  @Nonnull
  @Nonempty
  public static ICommonsList <IReadableResource> getAllInvalidXMLFiles ()
  {
    return s_aXMLs.getAllMapped (aFile -> aFile.getFileBaseName ().startsWith ("invalid"),
                                 SchematronTestFile::getResource);
  }
}
