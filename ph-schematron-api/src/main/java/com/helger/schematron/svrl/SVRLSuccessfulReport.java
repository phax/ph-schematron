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
package com.helger.schematron.svrl;

import java.util.function.Function;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.diagnostics.error.level.IErrorLevel;
import com.helger.schematron.svrl.jaxb.SuccessfulReport;

/**
 * A wrapper around {@link SuccessfulReport} with easier error level handling.
 *
 * @author Philip Helger
 */
@Immutable
public class SVRLSuccessfulReport extends AbstractSVRLMessage
{
  public SVRLSuccessfulReport (@NonNull final SuccessfulReport aSuccessfulReport)
  {
    this (aSuccessfulReport, SVRLHelper::getErrorLevelFromSuccessfulReport);
  }

  public SVRLSuccessfulReport (@NonNull final SuccessfulReport aSuccessfulReport,
                               @NonNull final Function <? super SuccessfulReport, ? extends IErrorLevel> aErrLevelProvider)
  {
    this (aSuccessfulReport, x -> SVRLHelper.getBeautifiedLocation (x.getLocation ()), aErrLevelProvider);
  }

  public SVRLSuccessfulReport (@NonNull final SuccessfulReport aSuccessfulReport,
                               @NonNull final Function <? super SuccessfulReport, String> aLocationProvider,
                               @NonNull final Function <? super SuccessfulReport, ? extends IErrorLevel> aErrLevelProvider)
  {
    super (SVRLHelper.getAllDiagnosticReferences (aSuccessfulReport),
           aSuccessfulReport.getId (),
           SVRLHelper.getAsString (SVRLHelper.getText (aSuccessfulReport)),
           aLocationProvider.apply (aSuccessfulReport),
           aSuccessfulReport.getTest (),
           aSuccessfulReport.getRole (),
           aErrLevelProvider.apply (aSuccessfulReport));
  }
}
