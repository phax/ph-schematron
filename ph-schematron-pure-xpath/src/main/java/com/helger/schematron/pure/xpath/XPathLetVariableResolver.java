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
package com.helger.schematron.pure.xpath;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.annotation.style.ReturnsMutableObject;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.collection.commons.CommonsHashMap;
import com.helger.collection.commons.ICommonsMap;

import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.XdmValue;

/**
 * Stores the currently effective Schematron &lt;let&gt; variable bindings during validation. The
 * bindings are kept per thread, so that nested validations of multiple threads do not interfere
 * with each other.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class XPathLetVariableResolver
{
  private final ICommonsMap <QName, XdmValue> m_aSeedVariables;
  private final ThreadLocal <ICommonsMap <QName, XdmValue>> m_aTLVariables = ThreadLocal.withInitial (CommonsHashMap::new);

  /**
   * Constructor with optional seed variables that are always available.
   *
   * @param aSeedVariables
   *        Initial variable bindings. May be <code>null</code> for none.
   */
  public XPathLetVariableResolver (@Nullable final ICommonsMap <QName, XdmValue> aSeedVariables)
  {
    m_aSeedVariables = aSeedVariables;
  }

  /**
   * Bind the given variable to the given value for the current thread.
   *
   * @param aName
   *        Variable name. May not be <code>null</code>.
   * @param aValue
   *        Variable value. May not be <code>null</code>.
   */
  public void setVariableValue (@NonNull final QName aName, @NonNull final XdmValue aValue)
  {
    ValueEnforcer.notNull (aName, "Name");
    ValueEnforcer.notNull (aValue, "Value");
    m_aTLVariables.get ().put (aName, aValue);
  }

  /**
   * Remove the binding for the given variable name from the current thread.
   *
   * @param aName
   *        Variable name. May be <code>null</code> in which case nothing happens.
   */
  public void removeVariable (@Nullable final QName aName)
  {
    if (aName != null)
      m_aTLVariables.get ().remove (aName);
  }

  /**
   * Drop every &lt;let&gt; binding that the current thread is holding. Called from a {@code finally}
   * block in {@code PSXPathBoundSchema.validate(...)} so that early returns
   * (e.g. {@code IPSValidationHandler} requesting {@code BREAK}) and exceptions out of validation
   * callbacks cannot leak per-request bindings into the next request handled by the same
   * thread-pool worker. Seed variables (supplied by the {@link com.helger.schematron.pure.xpath.IXPathConfig})
   * are not affected.
   *
   * @since 9.2.0
   */
  public void clearAllForCurrentThread ()
  {
    // Use remove() rather than clear() on the held map: this also detaches the ThreadLocal entry
    // itself, so an idle worker drops the (small) map allocation.
    m_aTLVariables.remove ();
  }

  /**
   * @return The currently effective per-thread variable map (let variables overlaid on top of seed
   *         variables). Never <code>null</code>.
   */
  @NonNull
  @ReturnsMutableObject
  public ICommonsMap <QName, XdmValue> getCurrentVariables ()
  {
    final ICommonsMap <QName, XdmValue> aLetVars = m_aTLVariables.get ();
    if (m_aSeedVariables == null || m_aSeedVariables.isEmpty ())
      return aLetVars;

    // Combine seed + let, with let taking precedence
    final ICommonsMap <QName, XdmValue> ret = new CommonsHashMap <> (m_aSeedVariables);
    ret.putAll (aLetVars);
    return ret;
  }

  /**
   * Resolve a variable, looking first at the per-thread let variables and then at the seed
   * variables.
   *
   * @param aName
   *        Variable name. May be <code>null</code>.
   * @return The variable value, or <code>null</code> if not found.
   */
  @Nullable
  public XdmValue resolveVariable (@Nullable final QName aName)
  {
    if (aName == null)
      return null;

    final XdmValue aLetValue = m_aTLVariables.get ().get (aName);
    if (aLetValue != null)
      return aLetValue;

    if (m_aSeedVariables != null)
      return m_aSeedVariables.get (aName);

    return null;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).appendIfNotNull ("SeedVariables", m_aSeedVariables)
                                       .append ("Variables", m_aTLVariables.get ())
                                       .getToString ();
  }
}
