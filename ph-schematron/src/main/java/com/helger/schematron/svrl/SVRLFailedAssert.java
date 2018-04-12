/**
 * Copyright (C) 2014-2018 Philip Helger (www.helger.com)
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
package com.helger.schematron.svrl;

import java.util.function.Function;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import org.oclc.purl.dsdl.svrl.FailedAssert;

import com.helger.commons.error.level.IErrorLevel;

/**
 * A wrapper around {@link FailedAssert} with easier error level handling.
 *
 * @author Philip Helger
 */
@Immutable
public class SVRLFailedAssert extends AbstractSVRLMessage
{
  public SVRLFailedAssert (@Nonnull final FailedAssert aFailedAssert)
  {
    this (aFailedAssert, SVRLHelper::getErrorLevelFromFailedAssert);
  }

  public SVRLFailedAssert (@Nonnull final FailedAssert aFailedAssert,
                           @Nonnull final Function <? super FailedAssert, ? extends IErrorLevel> aErrLevelProvider)
  {
    this (aFailedAssert, x -> SVRLHelper.getBeautifiedLocation (x.getLocation ()), aErrLevelProvider);
  }

  public SVRLFailedAssert (@Nonnull final FailedAssert aFailedAssert,
                           @Nonnull final Function <? super FailedAssert, String> aLocationProvider,
                           @Nonnull final Function <? super FailedAssert, ? extends IErrorLevel> aErrLevelProvider)
  {
    super (aFailedAssert.getDiagnosticReference (),
           aFailedAssert.getText (),
           aLocationProvider.apply (aFailedAssert),
           aFailedAssert.getTest (),
           aFailedAssert.getRole (),
           aErrLevelProvider.apply (aFailedAssert));
  }
}
