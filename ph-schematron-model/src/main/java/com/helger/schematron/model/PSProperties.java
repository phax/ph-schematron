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
import org.jspecify.annotations.Nullable;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.string.StringHelper;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.collection.CollectionHelper;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.schematron.CSchematron;
import com.helger.schematron.CSchematronXML;
import com.helger.schematron.errorhandler.IPSErrorHandler;
import com.helger.xml.microdom.IMicroElement;
import com.helger.xml.microdom.MicroElement;

/**
 * A single Schematron <code>properties</code> container introduced in ISO/IEC 19757-3:2016.<br>
 * Holds a sequence of {@link PSProperty} declarations and is itself the child of a
 * {@link PSSchema} or {@link PSLibrary}. The element is optional in the v3 (2020) RNC.
 *
 * @author Philip Helger
 * @since 10.0.0 (Schematron 2016)
 */
@NotThreadSafe
public class PSProperties implements IPSElement
{
  private final ICommonsList <PSProperty> m_aProperties = new CommonsArrayList <> ();

  public PSProperties ()
  {}

  public boolean isValid (@NonNull final IPSErrorHandler aErrorHandler)
  {
    for (final PSProperty aProperty : m_aProperties)
      if (!aProperty.isValid (aErrorHandler))
        return false;
    return true;
  }

  public void validateCompletely (@NonNull final IPSErrorHandler aErrorHandler)
  {
    for (final PSProperty aProperty : m_aProperties)
      aProperty.validateCompletely (aErrorHandler);
  }

  public boolean isMinimal ()
  {
    return false;
  }

  public void addProperty (@NonNull final PSProperty aProperty)
  {
    ValueEnforcer.notNull (aProperty, "Property");
    m_aProperties.add (aProperty);
  }

  public boolean hasAnyProperty ()
  {
    return m_aProperties.isNotEmpty ();
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <PSProperty> getAllProperties ()
  {
    return m_aProperties.getClone ();
  }

  @Nullable
  public PSProperty getPropertyOfID (@Nullable final String sID)
  {
    if (StringHelper.isNotEmpty (sID))
      for (final PSProperty aProperty : m_aProperties)
        if (sID.equals (aProperty.getID ()))
          return aProperty;
    return null;
  }

  @NonNull
  public IMicroElement getAsMicroElement ()
  {
    final IMicroElement ret = new MicroElement (CSchematron.NAMESPACE_SCHEMATRON, CSchematronXML.ELEMENT_PROPERTIES);
    for (final PSProperty aProperty : m_aProperties)
      ret.addChild (aProperty.getAsMicroElement ());
    return ret;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).appendIf ("Properties", m_aProperties, CollectionHelper::isNotEmpty)
                                       .getToString ();
  }
}
