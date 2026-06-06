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

import org.jspecify.annotations.NonNull;

import com.helger.annotation.Nonempty;
import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.schematron.CSchematronXML;

/**
 * A single Schematron <code>group</code> element introduced in ISO/IEC 19757-3:2025.<br>
 * Per the v4 RELAX NG schema, a <code>group</code> and a <code>pattern</code> share the same
 * content model (the productions <code>pattern</code> and <code>rule-set</code> both expand to
 * <code>rule-set-or-pattern</code>). The difference is at validation time: inside a
 * <code>pattern</code> the &quot;if-then-else&quot; rule semantics apply (only the first matching
 * rule fires per context node), whereas inside a <code>group</code> every contained rule is
 * matched independently of the others.
 * <p>
 * This class is a sibling of {@link PSPattern} &mdash; both extend {@link AbstractPSPatternLike},
 * which captures the shared content model. {@code PSGroup} is deliberately NOT a {@code PSPattern}
 * subtype: code that performs {@code instanceof PSPattern} will continue to match only true
 * patterns and ignore groups.
 *
 * @author Philip Helger
 * @since 10.0.0 (Schematron 2025)
 */
@NotThreadSafe
public class PSGroup extends AbstractPSPatternLike
{
  public PSGroup ()
  {}

  @Override
  @NonNull
  @Nonempty
  protected String getElementName ()
  {
    return CSchematronXML.ELEMENT_GROUP;
  }
}
