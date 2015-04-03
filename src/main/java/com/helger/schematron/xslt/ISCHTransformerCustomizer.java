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
package com.helger.schematron.xslt;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.xml.transform.Transformer;

/**
 * This interface is used internally to when converting Schematron to XSLT.
 *
 * @author Philip Helger
 */
public interface ISCHTransformerCustomizer
{
  public enum EStep
  {
    SCH2XSLT_1,
    SCH2XSLT_2,
    SCH2XSLT_3;
  }

  /**
   * Determine if the output can be cached. This is e.g. <code>false</code> when
   * custom parameters are provided.
   *
   * @return <code>true</code> if the result can be cached, <code>false</code>
   *         if not.
   */
  boolean canCacheResult ();

  /**
   * Customize the given transformer.
   *
   * @param eStep
   *        The step that is currently to be executed. Never <code>null</code>.
   *        When using the conversion from Schematron to XSLT the first 3 steps
   *        are used in the given order. When a the final XSLT is applied onto
   *        the XML document, the last step is used.
   * @param aTransformer
   *        The transformer to be customized. Never <code>null</code>.
   */
  void customize (@Nonnull EStep eStep, @Nonnull Transformer aTransformer);

  @Nullable
  String getPhase ();

  @Nullable
  String getLanguageCode ();
}
