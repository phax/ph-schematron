/*
 * Copyright (C) 2015-2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.model;

import java.util.function.BiConsumer;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.PresentForCodeCoverage;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.xml.microdom.IMicroElement;

/**
 * Central helper to find all foreign (non-Schematron) elements contained in a {@link PSSchema},
 * based on {@link PSVisitor}. Foreign elements are all elements that are not in the Schematron
 * namespace - most commonly XSLT elements like <code>&lt;xsl:function&gt;</code> or
 * <code>&lt;xsl:variable&gt;</code>. They are retained in the model by
 * {@link com.helger.schematron.exchange.PSReader} but not every engine can interpret them - engines
 * that ignore them should tell the user about it.
 *
 * @author Philip Helger
 * @since 10.0.2
 */
@Immutable
public final class PSForeignElementVisitor
{
  @PresentForCodeCoverage
  private static final PSForeignElementVisitor INSTANCE = new PSForeignElementVisitor ();

  private PSForeignElementVisitor ()
  {}

  /**
   * Walk the whole schema and invoke the provided consumer for each contained foreign element. The
   * consumer receives the {@link IPSElement} in which the foreign element is contained as the first
   * parameter and the foreign element itself as the second parameter.
   *
   * @param aSchema
   *        The schema to be scanned. May not be <code>null</code>.
   * @param aConsumer
   *        The consumer to be invoked for each foreign element. May not be <code>null</code>.
   */
  public static void forEachForeignElement (@NonNull final PSSchema aSchema,
                                            @NonNull final BiConsumer <IPSElement, IMicroElement> aConsumer)
  {
    ValueEnforcer.notNull (aSchema, "Schema");
    ValueEnforcer.notNull (aConsumer, "Consumer");

    PSVisitor.visit (aSchema, new IPSVoidVisitor ()
    {
      @Override
      public void onForeignElement (@NonNull final IPSElement aParent, @NonNull final IMicroElement aForeignElement)
      {
        aConsumer.accept (aParent, aForeignElement);
      }
    });
  }
}
