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
package com.helger.schematron.pure.binding;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.ThreadSafe;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.Nonempty;
import com.helger.commons.annotation.PresentForCodeCoverage;
import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.CollectionHelper;
import com.helger.commons.exception.InitializationException;
import com.helger.schematron.pure.binding.xpath.PSXPathQueryBinding;

/**
 * The registry class for all available query bindings. To register your own
 * query binding, call {@link #registerQueryBinding(String, IPSQueryBinding)}.
 *
 * @author Philip Helger
 */
@ThreadSafe
public final class PSQueryBindingRegistry
{
  /**
   * Name of the query binding for which the default binding is registered.
   */
  public static final String QUERY_BINDING_XSLT = "xslt";

  /**
   * Name of the query binding for which the default binding is registered.
   */
  public static final String QUERY_BINDING_XSLT2 = "xslt2";

  /**
   * The default XPath binding object to be used
   */
  public static final IPSQueryBinding DEFAULT_QUERY_BINDING = PSXPathQueryBinding.getInstance ();

  private static final ReadWriteLock s_aRWLock = new ReentrantReadWriteLock ();
  private static final Map <String, IPSQueryBinding> s_aMap = new HashMap <String, IPSQueryBinding> ();

  static
  {
    try
    {
      registerQueryBinding (QUERY_BINDING_XSLT, DEFAULT_QUERY_BINDING);
      registerQueryBinding (QUERY_BINDING_XSLT2, DEFAULT_QUERY_BINDING);
    }
    catch (final SchematronBindException ex)
    {
      throw new InitializationException (ex);
    }
  }

  @PresentForCodeCoverage
  private static final PSQueryBindingRegistry s_aInstance = new PSQueryBindingRegistry ();

  private PSQueryBindingRegistry ()
  {}

  public static void registerQueryBinding (@Nonnull @Nonempty final String sName,
                                           @Nonnull final IPSQueryBinding aQueryBinding) throws SchematronBindException
  {
    ValueEnforcer.notEmpty (sName, "Name");
    ValueEnforcer.notNull (aQueryBinding, "QueryBinding");

    s_aRWLock.writeLock ().lock ();
    try
    {
      if (s_aMap.containsKey (sName))
        throw new SchematronBindException ("A queryBinding with the name '" + sName + "' is already registered!");
      s_aMap.put (sName, aQueryBinding);
    }
    finally
    {
      s_aRWLock.writeLock ().unlock ();
    }
  }

  /**
   * Get the query binding with the specified name.
   *
   * @param sName
   *        The name to the query binding to retrieve. May be <code>null</code>.
   *        If it is <code>null</code> than the {@link #DEFAULT_QUERY_BINDING}
   *        object is returned.
   * @return <code>null</code> if no such query binding was found.
   */
  @Nullable
  public static IPSQueryBinding getQueryBindingOfName (@Nullable final String sName)
  {
    if (sName == null)
      return DEFAULT_QUERY_BINDING;

    s_aRWLock.readLock ().lock ();
    try
    {
      return s_aMap.get (sName);
    }
    finally
    {
      s_aRWLock.readLock ().unlock ();
    }
  }

  /**
   * Get the query binding with the specified name
   *
   * @param sName
   *        The name of the query binding to look up. May be <code>null</code>.
   * @return Never <code>null</code>.
   * @throws SchematronBindException
   *         In case the query binding could not be resolved!
   */
  @Nonnull
  public static IPSQueryBinding getQueryBindingOfNameOrThrow (@Nullable final String sName) throws SchematronBindException
  {
    final IPSQueryBinding aQB = getQueryBindingOfName (sName);
    if (aQB == null)
      throw new SchematronBindException ("No query binding implementation present for query binding '" + sName + "'");
    return aQB;
  }

  /**
   * @return A non-<code>null</code> map with all contained query bindings from
   *         name to object.
   */
  @Nonnull
  @ReturnsMutableCopy
  public static Map <String, IPSQueryBinding> getAllRegisteredQueryBindings ()
  {
    s_aRWLock.readLock ().lock ();
    try
    {
      return CollectionHelper.newMap (s_aMap);
    }
    finally
    {
      s_aRWLock.readLock ().unlock ();
    }
  }
}
