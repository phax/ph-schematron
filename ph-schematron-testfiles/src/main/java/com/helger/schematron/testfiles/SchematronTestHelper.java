/*
 * Copyright (C) 2014-2025 Philip Helger (www.helger.com)
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

import java.io.File;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.annotation.Nonempty;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.lang.ClassPathHelper;
import com.helger.base.string.StringHelper;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.io.file.FileSystemRecursiveIterator;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
import com.helger.xml.microdom.IMicroDocument;
import com.helger.xml.microdom.IMicroElement;
import com.helger.xml.microdom.serialize.MicroReader;

import jakarta.annotation.Nonnull;

/**
 * A utility class to list all the available test files.
 *
 * @author Philip Helger
 */
public final class SchematronTestHelper
{
  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronTestHelper.class);
  private static final ICommonsList <SchematronTestFile> SCH = _readDirIndex (new ClassPathResource ("external/test-sch/dirindex.xml"));
  private static final ICommonsList <SchematronTestFile> SVRL = _readDirIndex (new ClassPathResource ("external/test-svrl/dirindex.xml"));
  private static final ICommonsList <SchematronTestFile> XML = _readDirIndex (new ClassPathResource ("external/test-xml/dirindex.xml"));

  @Nonnull
  private static ICommonsList <SchematronTestFile> _readDirIndex (@Nonnull final IReadableResource aRes)
  {
    if (false)
      ClassPathHelper.getAllClassPathEntries ().forEach (x -> {
        LOGGER.info (x);
        if (new File (x).isDirectory ())
        {
          final FileSystemRecursiveIterator it = new FileSystemRecursiveIterator (new File (x));
          it.forEach (y -> LOGGER.info (StringHelper.getRepeated ("  ", it.getLevel ()) + y));
        }
      });
    ValueEnforcer.notNull (aRes, "Resource");
    ValueEnforcer.isTrue (aRes.exists (), () -> "Resource " + aRes + " does not exist!");

    final ICommonsList <SchematronTestFile> ret = new CommonsArrayList <> ();
    final IMicroDocument aDoc = MicroReader.readMicroXML (aRes);
    if (aDoc == null)
      throw new IllegalArgumentException ("Failed to open/parse " + aRes + " as XML");
    String sLastParentDirBaseName = null;
    for (final IMicroElement eItem : aDoc.getDocumentElement ().getAllChildElements ())
      if (eItem.getTagName ().equals ("directory"))
        sLastParentDirBaseName = "external/" + eItem.getAttributeValue ("basename");
      else
        if (eItem.getTagName ().equals ("file"))
          ret.add (new SchematronTestFile (sLastParentDirBaseName,
                                           new ClassPathResource ("external/" + eItem.getAttributeValue ("name")),
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
    return SCH.getAllMapped (aFile -> !aFile.getFileBaseName ().startsWith ("invalid") &&
                                      !aFile.getParentDirBaseName ().endsWith ("include"),
                             SchematronTestFile::getResource);
  }

  @Nonnull
  @Nonempty
  public static ICommonsList <IReadableResource> getAllInvalidSchematronFiles ()
  {
    return SCH.getAllMapped (aFile -> aFile.getFileBaseName ().startsWith ("invalid") &&
                                      !aFile.getParentDirBaseName ().endsWith ("include"),
                             SchematronTestFile::getResource);
  }

  @Nonnull
  @Nonempty
  public static ICommonsList <IReadableResource> getAllValidSVRLFiles ()
  {
    return SVRL.getAllMapped (aFile -> !aFile.getFileBaseName ().startsWith ("invalid"),
                              SchematronTestFile::getResource);
  }

  @Nonnull
  @Nonempty
  public static ICommonsList <IReadableResource> getAllInvalidSVRLFiles ()
  {
    return SVRL.getAllMapped (aFile -> aFile.getFileBaseName ().startsWith ("invalid"),
                              SchematronTestFile::getResource);
  }

  @Nonnull
  @Nonempty
  public static ICommonsList <IReadableResource> getAllValidXMLFiles ()
  {
    return XML.getAllMapped (aFile -> !aFile.getFileBaseName ().startsWith ("invalid"),
                             SchematronTestFile::getResource);
  }

  @Nonnull
  @Nonempty
  public static ICommonsList <IReadableResource> getAllInvalidXMLFiles ()
  {
    return XML.getAllMapped (aFile -> aFile.getFileBaseName ().startsWith ("invalid"), SchematronTestFile::getResource);
  }
}
