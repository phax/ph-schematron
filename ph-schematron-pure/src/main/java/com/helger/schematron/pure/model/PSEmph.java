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
package com.helger.schematron.pure.model;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.NotThreadSafe;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.Nonempty;
import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.CollectionHelper;
import com.helger.commons.collection.impl.CommonsArrayList;
import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.string.StringHelper;
import com.helger.commons.string.ToStringGenerator;
import com.helger.schematron.CSchematron;
import com.helger.schematron.CSchematronXML;
import com.helger.schematron.pure.errorhandler.IPSErrorHandler;
import com.helger.xml.microdom.IMicroElement;
import com.helger.xml.microdom.MicroElement;

/**
 * A single Schematron emph-element.<br>
 * A portion of text that should be rendered with some emphasis.<br>
 * An implementation is not required to make use of this element.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class PSEmph implements IPSClonableElement <PSEmph>, IPSOptionalElement, IPSHasTexts
{
  private final ICommonsList <String> m_aContent = new CommonsArrayList <> ();

  public PSEmph ()
  {}

  public boolean isValid (@Nonnull final IPSErrorHandler aErrorHandler)
  {
    if (m_aContent.isEmpty ())
    {
      aErrorHandler.error (this, "<emph> has no content");
      return false;
    }
    return true;
  }

  public void validateCompletely (@Nonnull final IPSErrorHandler aErrorHandler)
  {
    if (m_aContent.isEmpty ())
      aErrorHandler.error (this, "<emph> has no content");
  }

  public boolean isMinimal ()
  {
    return true;
  }

  public void addText (@Nonnull @Nonempty final String sText)
  {
    ValueEnforcer.notEmpty (sText, "Text");
    m_aContent.add (sText);
  }

  public boolean hasAnyText ()
  {
    return m_aContent.isNotEmpty ();
  }

  @Nonnull
  @ReturnsMutableCopy
  public ICommonsList <String> getAllTexts ()
  {
    return m_aContent.getClone ();
  }

  @Nullable
  public String getAsText ()
  {
    return StringHelper.getImploded (m_aContent);
  }

  @Nonnull
  public IMicroElement getAsMicroElement ()
  {
    final IMicroElement ret = new MicroElement (CSchematron.NAMESPACE_SCHEMATRON, CSchematronXML.ELEMENT_EMPH);
    for (final String sContent : m_aContent)
      ret.appendText (sContent);
    return ret;
  }

  @Nonnull
  public PSEmph getClone ()
  {
    final PSEmph ret = new PSEmph ();
    for (final String sContent : m_aContent)
      ret.addText (sContent);
    return ret;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).appendIf ("content", m_aContent, CollectionHelper::isNotEmpty).getToString ();
  }
}
