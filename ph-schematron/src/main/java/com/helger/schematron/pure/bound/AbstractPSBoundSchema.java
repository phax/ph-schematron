/**
 * Copyright (C) 2014-2017 Philip Helger (www.helger.com)
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

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.OverridingMethodsMustInvokeSuper;

import org.w3c.dom.Node;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.OverrideOnDemand;
import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.impl.CommonsArrayList;
import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.state.EValidity;
import com.helger.commons.string.ToStringGenerator;
import com.helger.schematron.CSchematron;
import com.helger.schematron.pure.binding.IPSQueryBinding;
import com.helger.schematron.pure.errorhandler.IPSErrorHandler;
import com.helger.schematron.pure.errorhandler.LoggingPSErrorHandler;
import com.helger.schematron.pure.model.IPSElement;
import com.helger.schematron.pure.model.PSActive;
import com.helger.schematron.pure.model.PSPattern;
import com.helger.schematron.pure.model.PSPhase;
import com.helger.schematron.pure.model.PSSchema;
import com.helger.schematron.pure.validation.AbstractPSPartialValidationHandler;
import com.helger.schematron.pure.validation.PSValidationHandlerBreakOnFirstError;
import com.helger.schematron.pure.validation.SchematronValidationException;
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
  private final String m_sPhase;
  private final PSPhase m_aPhase;
  private final ICommonsList <PSPattern> m_aPatterns = new CommonsArrayList <> ();

  public AbstractPSBoundSchema (@Nonnull final IPSQueryBinding aQueryBinding,
                                @Nonnull final PSSchema aOrigSchema,
                                @Nullable final String sPhase,
                                @Nullable final IPSErrorHandler aCustomErrorHandler)
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
    String sRealPhase = sPhase != null ? sPhase : CSchematron.PHASE_DEFAULT;
    if (sRealPhase.equals (CSchematron.PHASE_DEFAULT))
    {
      sRealPhase = aOrigSchema.getDefaultPhase ();
      if (sRealPhase == null)
        sRealPhase = CSchematron.PHASE_ALL;
    }
    if (!sRealPhase.equals (CSchematron.PHASE_ALL))
    {
      m_aPhase = aOrigSchema.getPhaseOfID (sRealPhase);
      if (m_aPhase == null)
        warn (aOrigSchema, "Failed to resolve phase with ID '" + sRealPhase + "' - default to all patterns");
    }
    else
      m_aPhase = null;
    m_sPhase = sRealPhase;

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
                             sRealPhase +
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
  }

  @Nonnull
  protected IPSErrorHandler getErrorHandler ()
  {
    return m_aErrorHandler;
  }

  protected boolean isDefaultErrorHandler ()
  {
    return m_bDefaultErrorHandler;
  }

  @OverridingMethodsMustInvokeSuper
  protected void warn (@Nonnull final IPSElement aSourceElement, @Nonnull final String sMsg)
  {
    getErrorHandler ().warn (m_aOrigSchema.getResource (), aSourceElement, sMsg);
  }

  @OverridingMethodsMustInvokeSuper
  protected void error (@Nonnull final IPSElement aSourceElement, @Nonnull final String sMsg)
  {
    error (aSourceElement, sMsg, (Throwable) null);
  }

  @OverridingMethodsMustInvokeSuper
  protected void error (@Nonnull final IPSElement aSourceElement,
                        @Nonnull final String sMsg,
                        @Nullable final Throwable t)
  {
    getErrorHandler ().error (m_aOrigSchema.getResource (), aSourceElement, sMsg, t);
  }

  @Nonnull
  public final IPSQueryBinding getQueryBinding ()
  {
    return m_aQueryBinding;
  }

  @Nonnull
  public final PSSchema getOriginalSchema ()
  {
    return m_aOrigSchema;
  }

  @Nonnull
  public final MapBasedNamespaceContext getNamespaceContext ()
  {
    return m_aNamespaceContext;
  }

  @Nonnull
  public final String getPhaseID ()
  {
    return m_sPhase;
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

  @Nonnull
  @ReturnsMutableCopy
  public final ICommonsList <PSPattern> getAllRelevantPatterns ()
  {
    return m_aPatterns.getClone ();
  }

  /**
   * Override this implementation in a derived class to modify the behavior.
   *
   * @return An implementation of {@link AbstractPSPartialValidationHandler} to
   *         use for partial validation. May not be <code>null</code>.
   */
  @Nonnull
  @OverrideOnDemand
  protected AbstractPSPartialValidationHandler createPartialValidationHandler ()
  {
    return new PSValidationHandlerBreakOnFirstError ();
  }

  @Nonnull
  public EValidity validatePartially (@Nonnull final Node aNode) throws SchematronValidationException
  {
    final AbstractPSPartialValidationHandler aValidationHandler = createPartialValidationHandler ();
    validate (aNode, aValidationHandler);
    return aValidationHandler.getValidity ();
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("queryBinding", m_aQueryBinding)
                                       .append ("origSchema", m_aOrigSchema)
                                       .appendIfNotNull ("errorHandler", m_aErrorHandler)
                                       .append ("namespaceContext", m_aNamespaceContext)
                                       .appendIfNotNull ("phase", m_sPhase)
                                       .appendIfNotNull ("phase", m_aPhase)
                                       .append ("patterns", m_aPatterns)
                                       .getToString ();
  }
}
