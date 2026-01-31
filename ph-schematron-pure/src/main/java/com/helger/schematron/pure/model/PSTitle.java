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
package com.helger.schematron.pure.model;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.Nonempty;
import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.collection.CollectionHelper;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.schematron.CSchematron;
import com.helger.schematron.CSchematronXML;
import com.helger.schematron.pure.errorhandler.IPSErrorHandler;
import com.helger.xml.microdom.IMicroElement;
import com.helger.xml.microdom.MicroElement;

/**
 * A single Schematron title-element.<br>
 * A summary of the purpose or role of the schema or pattern, for the purpose of documentation or a
 * rich user interface.<br>
 * An implementation is not required to make use of this element.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class PSTitle implements IPSClonableElement <PSTitle>, IPSOptionalElement, IPSHasMixedContent
{
  private final ICommonsList <Object> m_aContent = new CommonsArrayList <> ();

  public PSTitle ()
  {}

  public boolean isValid (@NonNull final IPSErrorHandler aErrorHandler)
  {
    for (final Object aContent : m_aContent)
      if (aContent instanceof IPSElement)
        if (!((IPSElement) aContent).isValid (aErrorHandler))
          return false;
    return true;
  }

  public void validateCompletely (@NonNull final IPSErrorHandler aErrorHandler)
  {
    for (final Object aContent : m_aContent)
      if (aContent instanceof IPSElement)
        ((IPSElement) aContent).validateCompletely (aErrorHandler);
  }

  public boolean isMinimal ()
  {
    return false;
  }

  public void addText (@NonNull @Nonempty final String sText)
  {
    ValueEnforcer.notEmpty (sText, "Text");
    m_aContent.add (sText);
  }

  public boolean hasAnyText ()
  {
    return m_aContent.containsAny (String.class::isInstance);
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <String> getAllTexts ()
  {
    return m_aContent.getAllInstanceOf (String.class);
  }

  public void addDir (@NonNull final PSDir aDir)
  {
    ValueEnforcer.notNull (aDir, "Dir");
    m_aContent.add (aDir);
  }

  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <PSDir> getAllDirs ()
  {
    return m_aContent.getAllInstanceOf (PSDir.class);
  }

  /**
   * @return A list of {@link String} and {@link PSDir} elements.
   */
  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <Object> getAllContentElements ()
  {
    return m_aContent.getClone ();
  }

  @NonNull
  public IMicroElement getAsMicroElement ()
  {
    final IMicroElement ret = new MicroElement (CSchematron.NAMESPACE_SCHEMATRON, CSchematronXML.ELEMENT_TITLE);
    for (final Object aContent : m_aContent)
      if (aContent instanceof String)
        ret.addText ((String) aContent);
      else
        ret.addChild (((IPSElement) aContent).getAsMicroElement ());
    return ret;
  }

  @NonNull
  public PSTitle getClone ()
  {
    final PSTitle ret = new PSTitle ();
    for (final Object aContent : m_aContent)
      if (aContent instanceof String)
        ret.addText ((String) aContent);
      else
        if (aContent instanceof PSDir)
          ret.addDir (((PSDir) aContent).getClone ());
    return ret;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).appendIf ("content", m_aContent, CollectionHelper::isNotEmpty).getToString ();
  }
}
