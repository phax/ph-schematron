/**
 * Copyright (C) 2014-2015 Philip Helger (www.helger.com)
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

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Nonnull;

import com.helger.commons.annotation.Nonempty;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.microdom.IMicroDocument;
import com.helger.commons.microdom.IMicroElement;
import com.helger.commons.microdom.serialize.MicroReader;

/**
 * A utility class to list all the available test files.
 *
 * @author Philip Helger
 */
public final class SchematronTestHelper
{
  private static final List <SchematronTestFile> s_aSCHs = _readDI (new ClassPathResource ("test-sch/dirindex.xml"));
  private static final List <SchematronTestFile> s_aSVRLs = _readDI (new ClassPathResource ("test-svrl/dirindex.xml"));
  private static final List <SchematronTestFile> s_aXMLs = _readDI (new ClassPathResource ("test-xml/dirindex.xml"));

  @Nonnull
  private static List <SchematronTestFile> _readDI (@Nonnull final IReadableResource aDI)
  {
    final List <SchematronTestFile> ret = new ArrayList <SchematronTestFile> ();
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
  public static List <IReadableResource> getAllValidSchematronFiles ()
  {
    final List <IReadableResource> ret = new ArrayList <IReadableResource> ();
    for (final SchematronTestFile aFile : s_aSCHs)
      if (!aFile.getFileBaseName ().startsWith ("invalid") && !aFile.getParentDirBaseName ().equals ("include"))
        ret.add (aFile.getResource ());
    return ret;
  }

  @Nonnull
  @Nonempty
  public static List <IReadableResource> getAllInvalidSchematronFiles ()
  {
    final List <IReadableResource> ret = new ArrayList <IReadableResource> ();
    for (final SchematronTestFile aFile : s_aSCHs)
      if (aFile.getFileBaseName ().startsWith ("invalid") && !aFile.getParentDirBaseName ().equals ("include"))
        ret.add (aFile.getResource ());
    return ret;
  }

  @Nonnull
  @Nonempty
  public static List <IReadableResource> getAllValidSVRLFiles ()
  {
    final List <IReadableResource> ret = new ArrayList <IReadableResource> ();
    for (final SchematronTestFile aFile : s_aSVRLs)
      if (!aFile.getFileBaseName ().startsWith ("invalid"))
        ret.add (aFile.getResource ());
    return ret;
  }

  @Nonnull
  @Nonempty
  public static List <IReadableResource> getAllInvalidSVRLFiles ()
  {
    final List <IReadableResource> ret = new ArrayList <IReadableResource> ();
    for (final SchematronTestFile aFile : s_aSVRLs)
      if (aFile.getFileBaseName ().startsWith ("invalid"))
        ret.add (aFile.getResource ());
    return ret;
  }

  @Nonnull
  @Nonempty
  public static List <IReadableResource> getAllValidXMLFiles ()
  {
    final List <IReadableResource> ret = new ArrayList <IReadableResource> ();
    for (final SchematronTestFile aFile : s_aXMLs)
      if (aFile.getFileBaseName ().startsWith ("invalid"))
        ret.add (aFile.getResource ());
    return ret;
  }

  @Nonnull
  @Nonempty
  public static List <IReadableResource> getAllInvalidXMLFiles ()
  {
    final List <IReadableResource> ret = new ArrayList <IReadableResource> ();
    for (final SchematronTestFile aFile : s_aXMLs)
      if (!aFile.getFileBaseName ().startsWith ("invalid"))
        ret.add (aFile.getResource ());
    return ret;
  }
}
