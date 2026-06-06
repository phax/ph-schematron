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
 * A single Schematron <code>pattern</code> element.<br>
 * A structure, simple or complex. A set of rules giving constraints that are in some way related.
 * The id attribute provides a unique name for the pattern and is required for abstract
 * patterns.<br>
 * The title and p elements allow rich documentation.<br>
 * The icon, see and fpi attributes allow rich interfaces and documentation.<br>
 * When a pattern element has the attribute abstract with a value true, then the pattern defines an
 * abstract pattern. An abstract pattern shall not have a is-a attribute and shall have an id
 * attribute.<br>
 * Abstract patterns allow a common definition mechanism for structures which use different names
 * and paths, but which are at heart the same. For example, there are different table markup
 * languages, but they all can be in large part represented as an abstract pattern where a table
 * contains rows and rows contain entries, as defined in the following example using the default
 * query language binding:<br>
 *
 * <pre>
 *     &lt;sch:pattern abstract="true" id="table"&gt;
 *         &lt;sch:rule context="$table"&gt;
 *             &lt;sch:assert test="$row"&gt;
 *             The element &lt;sch:name/&gt; is a table. Tables contain rows.
 *             &lt;/sch:assert&gt;
 *         &lt;/sch:rule&gt;
 *         &lt;sch:rule context="$row"&gt;
 *             &lt;sch:assert test="$entry"&gt;
 *             The element &lt;sch:name/&gt; is a table row. Rows contain entries.
 *             &lt;/sch:assert&gt;
 *         &lt;/sch:rule&gt;
 *     &lt;/sch:pattern&gt;
 * </pre>
 *
 * When a pattern element has the attribute is-a with a value specifying the name of an abstract
 * pattern, then the pattern is an instance of an abstract pattern. Such a pattern shall not contain
 * any rule elements, but shall have param elements for all parameters used in the abstract
 * pattern.<br>
 * <p>
 * As of {@code 10.0.0} the shared content model with the new ISO/IEC 19757-3:2025 <code>group</code>
 * element is captured by {@link AbstractPSPatternLike}; {@code PSPattern} now contributes only the
 * <code>pattern</code> element name. {@link PSGroup} is a sibling subclass &mdash; it is
 * intentionally NOT a {@code PSPattern}, so existing {@code instanceof PSPattern} checks continue
 * to address only true patterns and ignore groups.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class PSPattern extends AbstractPSPatternLike
{
  public PSPattern ()
  {}

  @Override
  @NonNull
  @Nonempty
  protected String getElementName ()
  {
    return CSchematronXML.ELEMENT_PATTERN;
  }
}
