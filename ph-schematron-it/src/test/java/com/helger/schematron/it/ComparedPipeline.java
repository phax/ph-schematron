/*
 * Copyright (C) 2014-2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.it;

import javax.xml.transform.TransformerException;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.w3c.dom.Document;

import com.helger.annotation.concurrent.Immutable;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.CommonsHashSet;
import com.helger.collection.commons.ICommonsList;
import com.helger.collection.commons.ICommonsSet;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.api.xslt.AbstractSchematronXSLTBasedResource;
import com.helger.schematron.api.xslt.processor.ISchematronXsltProcessor;
import com.helger.schematron.sch.SchematronProviderXSLTFromSCH;
import com.helger.schematron.sch.SchematronResourceSCH;
import com.helger.schematron.sch.SchematronSCHConfig;
import com.helger.schematron.schxslt.xslt2.SchematronProviderXSLTFromSchXslt_XSLT2;
import com.helger.schematron.schxslt.xslt2.SchematronResourceSchXslt_XSLT2;
import com.helger.schematron.schxslt.xslt2.SchematronSchXslt_XSLT2Config;
import com.helger.schematron.schxslt2.xslt.SchematronProviderXSLTFromSchXslt2;
import com.helger.schematron.schxslt2.xslt.SchematronResourceSchXslt2;
import com.helger.schematron.schxslt2.xslt.SchematronSchXslt2Config;
import com.helger.schematron.testfiles.SchematronTestHelper;
import com.helger.schematron.xslt.SchematronResourceXSLT;

/**
 * An XSLT based pipeline that is compared between Saxon and phoxtrot, with the files that are
 * known to behave differently.
 *
 * @author Philip Helger
 */
@Immutable
final class ComparedPipeline
{
  @FunctionalInterface
  interface IXSLTCreator
  {
    @NonNull
    Document createXSLT (@NonNull IReadableResource aRes, @NonNull ISchematronXsltProcessor aProcessor) throws TransformerException;
  }

  @FunctionalInterface
  interface IResourceCreator
  {
    @NonNull
    AbstractSchematronXSLTBasedResource <?> create (@NonNull IReadableResource aRes,
                                                    @NonNull ISchematronXsltProcessor aProcessor);
  }

  /**
   * Saxon takes very long for these (see SchematronSCHCacheTest in ph-schematron-isosch), so they
   * are only converted on phoxtrot.
   */
  private static final ICommonsSet <String> BIICORE_SLOW = new CommonsHashSet <> ("external/test-sch/biicore/BIICORE-UBL-T01.sch",
                                                                                  "external/test-sch/biicore/BIICORE-UBL-T10.sch",
                                                                                  "external/test-sch/biicore/BIICORE-UBL-T14.sch",
                                                                                  "external/test-sch/biicore/BIICORE-UBL-T15.sch");

  static final ComparedPipeline ISO = new ComparedPipeline ("iso",
                                                            SchematronTestHelper.getAllValidSchematronFiles (),
                                                            (r,
                                                             p) -> SchematronProviderXSLTFromSCH.createSchematronXSLT (SchematronSCHConfig.builder (r)
                                                                                                                                          .xsltProcessor (p)
                                                                                                                                          .build ()),
                                                            (r, p) -> SchematronResourceSCH.builder (r)
                                                                                           .xsltProcessor (p)
                                                                                           .useCache (false)
                                                                                           .build (),
                                                            BIICORE_SLOW,
                                                            new CommonsHashSet <> (),
                                                            new CommonsHashSet <> ());

  static final ComparedPipeline SCHXSLT1 = new ComparedPipeline ("schxslt1",
                                                                 SchematronTestHelper.getAllValidSchematronFiles (),
                                                                 (r,
                                                                  p) -> SchematronProviderXSLTFromSchXslt_XSLT2.createSchematronXSLT (SchematronSchXslt_XSLT2Config.builder (r)
                                                                                                                                                                   .xsltProcessor (p)
                                                                                                                                                                   .build ()),
                                                                 (r, p) -> SchematronResourceSchXslt_XSLT2.builder (r)
                                                                                                          .xsltProcessor (p)
                                                                                                          .useCache (false)
                                                                                                          .build (),
                                                                 BIICORE_SLOW,
                                                                 new CommonsHashSet <> (),
                                                                 new CommonsHashSet <> ());

  static final ComparedPipeline SCHXSLT2 = new ComparedPipeline ("schxslt2",
                                                                 SchematronTestHelper.getAllValidSchematronFiles (),
                                                                 (r,
                                                                  p) -> SchematronProviderXSLTFromSchXslt2.createSchematronXSLT (SchematronSchXslt2Config.builder (r)
                                                                                                                                                         .xsltProcessor (p)
                                                                                                                                                         .build ()),
                                                                 (r, p) -> SchematronResourceSchXslt2.builder (r)
                                                                                                     .xsltProcessor (p)
                                                                                                     .useCache (false)
                                                                                                     .build (),
                                                                 BIICORE_SLOW,
                                                                 new CommonsHashSet <> (),
                                                                 new CommonsHashSet <> ());

  static final ComparedPipeline XSLT_PREBUILT = new ComparedPipeline ("xslt",
                                                                      new CommonsArrayList <> (new ClassPathResource ("external/test-xslt/valid01.xslt")),
                                                                      null,
                                                                      (r, p) -> SchematronResourceXSLT.builder (r)
                                                                                                      .xsltProcessor (p)
                                                                                                      .useCache (false)
                                                                                                      .build (),
                                                                      new CommonsHashSet <> (),
                                                                      new CommonsHashSet <> (),
                                                                      new CommonsHashSet <> ());

  private final String m_sID;
  private final ICommonsList <IReadableResource> m_aSources;
  private final IXSLTCreator m_aXSLTCreator;
  private final IResourceCreator m_aResourceCreator;
  private final ICommonsSet <String> m_aNoSaxonReference;
  private final ICommonsSet <String> m_aKnownPhoxtrotFailures;
  private final ICommonsSet <String> m_aKnownDifferentXSLT;

  private ComparedPipeline (@NonNull final String sID,
                            @NonNull final ICommonsList <IReadableResource> aSources,
                            @Nullable final IXSLTCreator aXSLTCreator,
                            @NonNull final IResourceCreator aResourceCreator,
                            @NonNull final ICommonsSet <String> aNoSaxonReference,
                            @NonNull final ICommonsSet <String> aKnownPhoxtrotFailures,
                            @NonNull final ICommonsSet <String> aKnownDifferentXSLT)
  {
    m_sID = sID;
    m_aSources = aSources;
    m_aXSLTCreator = aXSLTCreator;
    m_aResourceCreator = aResourceCreator;
    m_aNoSaxonReference = aNoSaxonReference;
    m_aKnownPhoxtrotFailures = aKnownPhoxtrotFailures;
    m_aKnownDifferentXSLT = aKnownDifferentXSLT;
  }

  @NonNull
  String getID ()
  {
    return m_sID;
  }

  /**
   * @return The Schematron (or XSLT) files to compare.
   */
  @NonNull
  ICommonsList <IReadableResource> getAllSources ()
  {
    return m_aSources;
  }

  /**
   * @return The creator of the XSLT from the Schematron, or <code>null</code> for the pre-built
   *         XSLT.
   */
  @Nullable
  IXSLTCreator getXSLTCreator ()
  {
    return m_aXSLTCreator;
  }

  @NonNull
  AbstractSchematronXSLTBasedResource <?> createResource (@NonNull final IReadableResource aRes,
                                                          @NonNull final ISchematronXsltProcessor aProcessor)
  {
    return m_aResourceCreator.create (aRes, aProcessor);
  }

  /**
   * @return The paths that are only run on phoxtrot, because Saxon takes too long.
   */
  @NonNull
  ICommonsSet <String> getNoSaxonReference ()
  {
    return m_aNoSaxonReference;
  }

  /**
   * @return The paths for which phoxtrot is known to fail, each with a phoxtrot suggestion.
   */
  @NonNull
  ICommonsSet <String> getKnownPhoxtrotFailures ()
  {
    return m_aKnownPhoxtrotFailures;
  }

  /**
   * @return The paths for which the created XSLT is known to differ even after the normalisation,
   *         each with a phoxtrot suggestion.
   */
  @NonNull
  ICommonsSet <String> getKnownDifferentXSLT ()
  {
    return m_aKnownDifferentXSLT;
  }

  @Override
  public String toString ()
  {
    return m_sID;
  }
}
