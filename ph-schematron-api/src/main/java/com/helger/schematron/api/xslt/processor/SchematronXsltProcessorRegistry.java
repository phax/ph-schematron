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
package com.helger.schematron.api.xslt.processor;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.PresentForCodeCoverage;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.spi.ServiceLoaderHelper;
import com.helger.base.string.StringHelper;
import com.helger.base.string.StringImplode;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;

/**
 * A central registry for all {@link ISchematronXsltProcessorSpi} instances on the class path.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@Immutable
public final class SchematronXsltProcessorRegistry
{
  private static final ICommonsList <ISchematronXsltProcessor> LIST = new CommonsArrayList <> (ServiceLoaderHelper.getAllSPIImplementations (ISchematronXsltProcessorSpi.class));

  @PresentForCodeCoverage
  private static final SchematronXsltProcessorRegistry INSTANCE = new SchematronXsltProcessorRegistry ();

  private SchematronXsltProcessorRegistry ()
  {}

  /**
   * @return All XSLT processors found on the class path. Never <code>null</code> but maybe empty.
   */
  @NonNull
  @ReturnsMutableCopy
  public static ICommonsList <ISchematronXsltProcessor> getAllProcessors ()
  {
    return LIST.getClone ();
  }

  /**
   * @param sID
   *        The processor ID to search. May be <code>null</code>.
   * @return The XSLT processor with the provided ID or <code>null</code> if no such processor is on
   *         the class path.
   */
  @Nullable
  public static ISchematronXsltProcessor getProcessorOfID (@Nullable final String sID)
  {
    if (StringHelper.isEmpty (sID))
      return null;
    return LIST.findFirst (x -> x.getID ().equals (sID));
  }

  /**
   * Get the XSLT processor to use if none is selected explicitly. This is the only XSLT processor
   * on the class path.
   *
   * @return The only XSLT processor on the class path. Never <code>null</code>.
   * @throws IllegalStateException
   *         If no XSLT processor or more than one XSLT processor is on the class path
   */
  @NonNull
  public static ISchematronXsltProcessor getDefaultProcessor ()
  {
    if (LIST.isEmpty ())
      throw new IllegalStateException ("No Schematron XSLT processor is on the class path. Add 'ph-schematron-saxon' or 'ph-schematron-phoxtrot' as a dependency.");
    if (LIST.size () > 1)
      throw new IllegalStateException ("More than one Schematron XSLT processor is on the class path (" +
                                       StringImplode.imploder ()
                                                    .source (LIST, ISchematronXsltProcessor::getID)
                                                    .separator (", ")
                                                    .build () +
                                       "). Select one explicitly.");
    return LIST.getFirstOrNull ();
  }
}
