/*
 * Copyright (C) 2014-2025 Philip Helger (www.helger.com)
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
package com.helger.schematron.pure.bound;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.w3c.dom.Node;

import com.helger.annotation.OverridingMethodsMustInvokeSuper;
import com.helger.annotation.style.OverrideOnDemand;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.location.SimpleLocation;
import com.helger.base.state.EValidity;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.diagnostics.error.SingleError;
import com.helger.schematron.CSchematron;
import com.helger.schematron.pure.binding.IPSQueryBinding;
import com.helger.schematron.pure.errorhandler.IPSErrorHandler;
import com.helger.schematron.pure.errorhandler.LoggingPSErrorHandler;
import com.helger.schematron.pure.model.IPSElement;
import com.helger.schematron.pure.model.PSActive;
import com.helger.schematron.pure.model.PSPattern;
import com.helger.schematron.pure.model.PSPhase;
import com.helger.schematron.pure.model.PSSchema;
import com.helger.schematron.pure.validation.IPSPartialValidationHandler;
import com.helger.schematron.pure.validation.IPSValidationHandler;
import com.helger.schematron.pure.validation.PSValidationHandlerBreakOnFirstError;
import com.helger.schematron.pure.validation.SchematronValidationException;
import com.helger.schematron.pure.validation.xpath.PSXPathValidationHandlerSVRL;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.xml.namespace.MapBasedNamespaceContext;

/**
 * Base implementation of {@link IPSBoundSchema} with all common elements. It is
 * independent of the used query binding.
 *
 * @author Philip Helger
 */
public abstract class AbstractPSBoundSchema implements IPSBoundSchema
{
  private final IPSQueryBinding m_aQueryBinding;
  private final PSSchema m_aOrigSchema;
  private final IPSErrorHandler m_aErrorHandler;
  private final boolean m_bDefaultErrorHandler;
  private final MapBasedNamespaceContext m_aNamespaceContext;
  private final String m_sPhaseID;
  private final PSPhase m_aPhase;
  private final ICommonsList <PSPattern> m_aPatterns = new CommonsArrayList <> ();
  private final IPSValidationHandler m_aCustomValidationHandler;

  public AbstractPSBoundSchema (@NonNull final IPSQueryBinding aQueryBinding,
                                @NonNull final PSSchema aOrigSchema,
                                @Nullable final String sPhaseID,
                                @Nullable final IPSErrorHandler aCustomErrorHandler,
                                @Nullable final IPSValidationHandler aCustomValidationHandler)
  {
    ValueEnforcer.notNull (aQueryBinding, "QueryBinding");
    ValueEnforcer.notNull (aOrigSchema, "OrigSchema");

    m_aQueryBinding = aQueryBinding;
    m_aOrigSchema = aOrigSchema;
    m_aErrorHandler = aCustomErrorHandler != null ? aCustomErrorHandler : new LoggingPSErrorHandler ();
    m_bDefaultErrorHandler = aCustomErrorHandler == null;

    // Determine all namespaces of the schema
    m_aNamespaceContext = aOrigSchema.getAsNamespaceContext ();

    // Determine the phase ID to use
    String sRealPhaseID = sPhaseID != null ? sPhaseID : CSchematron.PHASE_DEFAULT;
    if (sRealPhaseID.equals (CSchematron.PHASE_DEFAULT))
    {
      sRealPhaseID = aOrigSchema.getDefaultPhase ();
      if (sRealPhaseID == null)
        sRealPhaseID = CSchematron.PHASE_ALL;
    }
    if (!sRealPhaseID.equals (CSchematron.PHASE_ALL))
    {
      m_aPhase = aOrigSchema.getPhaseOfID (sRealPhaseID);
      if (m_aPhase == null)
        warn (aOrigSchema, "Failed to resolve phase with ID '" + sRealPhaseID + "' - default to all patterns");
    }
    else
      m_aPhase = null;
    m_sPhaseID = sRealPhaseID;

    // Determine all patterns of the phase to use
    if (m_aPhase == null)
    {
      // Apply all patterns
      m_aPatterns.addAll (aOrigSchema.getAllPatterns ());
    }
    else
    {
      // Scan all active phases
      for (final PSActive aActive : m_aPhase.getAllActives ())
      {
        final String sActivePatternID = aActive.getPattern ();
        final PSPattern aPattern = aOrigSchema.getPatternOfID (sActivePatternID);
        if (aPattern == null)
        {
          warn (aOrigSchema,
                "Failed to resolve pattern with ID '" +
                             sActivePatternID +
                             "' - ignoring this pattern in phase '" +
                             sRealPhaseID +
                             "'");
        }
        else
        {
          // Add the pattern of this phase
          m_aPatterns.add (aPattern);
        }
      }
    }
    if (m_aPatterns.isEmpty ())
      if (m_aPhase == null)
        error (aOrigSchema, "No patterns found in schema!");
      else
        error (aOrigSchema, "No patterns found in schema for phase '" + m_aPhase.getID () + "!");

    m_aCustomValidationHandler = aCustomValidationHandler;
  }

  @NonNull
  public final IPSErrorHandler getErrorHandler ()
  {
    return m_aErrorHandler;
  }

  public final boolean isDefaultErrorHandler ()
  {
    return m_bDefaultErrorHandler;
  }

  @OverridingMethodsMustInvokeSuper
  protected void warn (@NonNull final IPSElement aSourceElement, @NonNull final String sMsg)
  {
    getErrorHandler ().handleError (SingleError.builderWarn ()
                                               .errorLocation (new SimpleLocation (m_aOrigSchema.getResource ()
                                                                                                .getPath ()))
                                               .errorFieldName (IPSErrorHandler.getErrorFieldName (aSourceElement))
                                               .errorText (sMsg)
                                               .build ());
  }

  @OverridingMethodsMustInvokeSuper
  protected void error (@NonNull final IPSElement aSourceElement, @NonNull final String sMsg)
  {
    error (aSourceElement, sMsg, (Throwable) null);
  }

  @OverridingMethodsMustInvokeSuper
  protected void error (@NonNull final IPSElement aSourceElement,
                        @NonNull final String sMsg,
                        @Nullable final Throwable t)
  {
    getErrorHandler ().handleError (SingleError.builderError ()
                                               .errorLocation (new SimpleLocation (m_aOrigSchema.getResource ()
                                                                                                .getPath ()))
                                               .errorFieldName (IPSErrorHandler.getErrorFieldName (aSourceElement))
                                               .errorText (sMsg)
                                               .linkedException (t)
                                               .build ());
  }

  @NonNull
  public final IPSQueryBinding getQueryBinding ()
  {
    return m_aQueryBinding;
  }

  @NonNull
  public final PSSchema getOriginalSchema ()
  {
    return m_aOrigSchema;
  }

  @NonNull
  public final MapBasedNamespaceContext getNamespaceContext ()
  {
    return m_aNamespaceContext;
  }

  @NonNull
  public final String getPhaseID ()
  {
    return m_sPhaseID;
  }

  @Nullable
  public final PSPhase getPhase ()
  {
    return m_aPhase;
  }

  public final boolean isPhaseSpecified ()
  {
    return m_aPhase != null;
  }

  @NonNull
  @ReturnsMutableCopy
  public final ICommonsList <PSPattern> getAllRelevantPatterns ()
  {
    return m_aPatterns.getClone ();
  }

  @Nullable
  public final IPSValidationHandler getCustomValidationHandler ()
  {
    return m_aCustomValidationHandler;
  }

  /**
   * Override this implementation in a derived class to modify the behavior.
   *
   * @return An implementation of {@link IPSPartialValidationHandler} to use for
   *         partial validation. May not be <code>null</code>.
   */
  @NonNull
  @OverrideOnDemand
  protected IPSPartialValidationHandler createPartialValidationHandler ()
  {
    return new PSValidationHandlerBreakOnFirstError ();
  }

  @NonNull
  public EValidity validatePartially (@NonNull final Node aNode,
                                      @Nullable final String sBaseURI) throws SchematronValidationException
  {
    final IPSPartialValidationHandler aValidationHandler = createPartialValidationHandler ();
    validate (aNode, sBaseURI, aValidationHandler.and (m_aCustomValidationHandler));
    return aValidationHandler.getValidity ();
  }

  @NonNull
  public SchematronOutputType validateComplete (@NonNull final Node aNode,
                                                @Nullable final String sBaseURI) throws SchematronValidationException
  {
    final PSXPathValidationHandlerSVRL aValidationHandler = new PSXPathValidationHandlerSVRL (getErrorHandler ());
    validate (aNode, sBaseURI, aValidationHandler.and (m_aCustomValidationHandler));
    return aValidationHandler.getSVRL ();
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("QueryBinding", m_aQueryBinding)
                                       .append ("OrigSchema", m_aOrigSchema)
                                       .appendIfNotNull ("ErrorHandler", m_aErrorHandler)
                                       .append ("NamespaceContext", m_aNamespaceContext)
                                       .appendIfNotNull ("PhaseID", m_sPhaseID)
                                       .appendIfNotNull ("Phase", m_aPhase)
                                       .append ("Patterns", m_aPatterns)
                                       .getToString ();
  }
}
