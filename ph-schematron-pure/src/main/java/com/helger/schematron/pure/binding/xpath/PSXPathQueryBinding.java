/*
 * Copyright (C) 2014-2023 Philip Helger (www.helger.com)
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
package com.helger.schematron.pure.binding.xpath;

import java.util.List;
import java.util.Map;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.impl.CommonsTreeMap;
import com.helger.commons.collection.impl.ICommonsNavigableMap;
import com.helger.commons.compare.IComparator;
import com.helger.commons.string.StringHelper;
import com.helger.schematron.SchematronException;
import com.helger.schematron.pure.binding.IPSQueryBinding;
import com.helger.schematron.pure.binding.SchematronBindException;
import com.helger.schematron.pure.bound.IPSBoundSchema;
import com.helger.schematron.pure.bound.xpath.PSXPathBoundSchema;
import com.helger.schematron.pure.errorhandler.CollectingPSErrorHandler;
import com.helger.schematron.pure.errorhandler.IPSErrorHandler;
import com.helger.schematron.pure.model.PSParam;
import com.helger.schematron.pure.model.PSSchema;
import com.helger.schematron.pure.preprocess.PSPreprocessor;
import com.helger.schematron.pure.validation.IPSValidationHandler;
import com.helger.schematron.pure.xpath.IXPathConfig;

/**
 * Default XPath/XSLT query binding
 *
 * @author Philip Helger
 */
public class PSXPathQueryBinding implements IPSQueryBinding
{
  public static final char PARAM_VARIABLE_PREFIX = '$';

  private static final Logger LOGGER = LoggerFactory.getLogger (PSXPathQueryBinding.class);
  private static final PSXPathQueryBinding INSTANCE = new PSXPathQueryBinding ();

  private PSXPathQueryBinding ()
  {}

  @Nonnull
  public static PSXPathQueryBinding getInstance ()
  {
    return INSTANCE;
  }

  @Nonnull
  public String getNegatedTestExpression (@Nonnull final String sTest)
  {
    ValueEnforcer.notNull (sTest, "Test");

    if (sTest.startsWith ("not(") && sTest.endsWith (")"))
    {
      // Avoid double not() by stripping the outer not()
      return sTest.substring (4, sTest.length () - 2);
    }

    return "not(" + sTest + ")";
  }

  @Nonnull
  @ReturnsMutableCopy
  public ICommonsNavigableMap <String, String> getStringReplacementMap (@Nonnull final List <PSParam> aParams)
  {
    // Longest matches must go first
    final ICommonsNavigableMap <String, String> ret = new CommonsTreeMap <> (IComparator.getComparatorStringLongestFirst ());
    for (final PSParam aParam : aParams)
      ret.put (PARAM_VARIABLE_PREFIX + aParam.getName (), aParam.getValue ());
    return ret;
  }

  @Nullable
  public static String getWithParamTextsReplacedStatic (@Nullable final String sText,
                                                        @Nullable final Map <String, String> aStringReplacements)
  {
    if (sText == null)
      return null;
    if (sText.indexOf (PARAM_VARIABLE_PREFIX) < 0)
    {
      // No replacement necessary
      return sText;
    }
    final String ret = StringHelper.replaceMultiple (sText, aStringReplacements);
    if (false)
      if (ret.indexOf (PARAM_VARIABLE_PREFIX) >= 0)
        LOGGER.warn ("Text still contains variables after replacement: " + ret);
    return ret;
  }

  @Nullable
  public String getWithParamTextsReplaced (@Nullable final String sText,
                                           @Nullable final Map <String, String> aStringReplacements)
  {
    return getWithParamTextsReplacedStatic (sText, aStringReplacements);
  }

  @Nonnull
  public IPSBoundSchema bind (@Nonnull final PSSchema aSchema,
                              @Nullable final String sPhase,
                              @Nullable final IPSErrorHandler aCustomErrorListener,
                              @Nullable final IPSValidationHandler aCustomValidationHandler,
                              @Nullable final IXPathConfig aXPathConfig) throws SchematronException
  {
    ValueEnforcer.notNull (aSchema, "Schema");

    final IPSErrorHandler aErrorHandler = aCustomErrorListener != null ? aCustomErrorListener
                                                                       : new CollectingPSErrorHandler ();
    if (!aSchema.isValid (aErrorHandler))
      throw new SchematronBindException ("The passed schema is not valid and can therefore not be bound" +
                                         (aErrorHandler == aCustomErrorListener ? ". Errors are in the provided error handler."
                                                                                : ": " +
                                                                                  ((CollectingPSErrorHandler) aErrorHandler).getErrorList ()
                                                                                                                            .toString ()));

    PSSchema aSchemaToUse = aSchema;
    if (!aSchemaToUse.isPreprocessed ())
    {
      // Required for parameter resolution
      final PSPreprocessor aPreprocessor = PSPreprocessor.createPreprocessorWithoutInformationLoss (this);

      // Apply preprocessing
      aSchemaToUse = aPreprocessor.getForcedPreprocessedSchema (aSchema);
    }

    final PSXPathBoundSchema ret = new PSXPathBoundSchema (this,
                                                           aSchemaToUse,
                                                           sPhase,
                                                           aCustomErrorListener,
                                                           aCustomValidationHandler,
                                                           aXPathConfig);
    ret.bind ();
    return ret;
  }
}
