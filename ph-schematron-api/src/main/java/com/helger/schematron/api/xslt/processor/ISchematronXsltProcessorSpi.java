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

import com.helger.annotation.style.IsSPIInterface;

/**
 * Implement this SPI interface to make an {@link ISchematronXsltProcessor} available in
 * {@link SchematronXsltProcessorRegistry}. Implementations must have a public no-argument
 * constructor.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@IsSPIInterface
public interface ISchematronXsltProcessorSpi extends ISchematronXsltProcessor
{
  /* nothing additional */
}
