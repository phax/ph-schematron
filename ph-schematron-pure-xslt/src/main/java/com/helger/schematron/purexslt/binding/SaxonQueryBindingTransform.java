/*
 * Copyright (C) 2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.purexslt.binding;

import java.util.List;
import java.util.Map;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.string.StringReplace;
import com.helger.collection.commons.CommonsTreeMap;
import com.helger.collection.commons.ICommonsNavigableMap;
import com.helger.schematron.model.IPSQueryBindingTransform;
import com.helger.schematron.model.PSParam;
import com.helger.text.compare.ComparatorHelper;

/**
 * Minimal XPath-style implementation of {@link IPSQueryBindingTransform} used to drive
 * {@link com.helger.schematron.preprocess.PSPreprocessor} from the pure-saxon module without
 * pulling in {@code ph-schematron-pure} (which owns the full {@code IPSQueryBinding}).
 * <p>
 * The semantics mirror those of {@code PSXPathQueryBinding} in the pure module: parameters are
 * referenced as {@code $name} in expressions, the negation form is {@code not(X)} (or strips an
 * existing {@code not(...)} wrapper) and parameter substitution is a longest-key-first multi-string
 * replace.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
public final class SaxonQueryBindingTransform implements IPSQueryBindingTransform
{
  public static final char PARAM_VARIABLE_PREFIX = '$';

  private static final SaxonQueryBindingTransform INSTANCE = new SaxonQueryBindingTransform ();

  private SaxonQueryBindingTransform ()
  {}

  @NonNull
  public static SaxonQueryBindingTransform getInstance ()
  {
    return INSTANCE;
  }

  @NonNull
  public String getNegatedTestExpression (@NonNull final String sTest)
  {
    ValueEnforcer.notNull (sTest, "Test");
    // Strip an outer not(...) rather than doubling it
    if (sTest.startsWith ("not(") && sTest.endsWith (")"))
      return sTest.substring (4, sTest.length () - 1);
    return "not(" + sTest + ")";
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsNavigableMap <String, String> getStringReplacementMap (@NonNull final List <PSParam> aParams)
  {
    // Longest matches first so $foo doesn't shadow $foo-bar
    final ICommonsNavigableMap <String, String> ret = new CommonsTreeMap <> (ComparatorHelper.getComparatorStringLongestFirst ());
    for (final PSParam aParam : aParams)
      ret.put (PARAM_VARIABLE_PREFIX + aParam.getName (), aParam.getValue ());
    return ret;
  }

  @Nullable
  public String getWithParamTextsReplaced (@Nullable final String sText, @Nullable final Map <String, String> aStringReplacements)
  {
    if (sText == null)
      return null;
    if (sText.indexOf (PARAM_VARIABLE_PREFIX) < 0)
      return sText;
    return StringReplace.replaceMultiple (sText, aStringReplacements);
  }
}
