/**
 * Copyright (C) 2014 phloc systems (www.phloc.com)
 * Copyright (C) 2014 Philip Helger (www.helger.com)
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
package com.helger.schematron.xslt;

import javax.annotation.Nullable;
import javax.annotation.concurrent.NotThreadSafe;
import javax.xml.transform.Templates;

import org.w3c.dom.Document;

import com.helger.commons.string.ToStringGenerator;

/**
 * Abstract base class handling XSLT to perform Schematron validation.
 * 
 * @author PEPPOL.AT, BRZ, Philip Helger
 */
@NotThreadSafe
public abstract class AbstractSchematronXSLTProvider implements ISchematronXSLTProvider
{
  // To be set be the implementing sub classes!
  protected Document m_aSchematronXSLTDoc;
  protected Templates m_aSchematronXSLT;

  protected AbstractSchematronXSLTProvider ()
  {}

  public final boolean isValidSchematron ()
  {
    return m_aSchematronXSLT != null;
  }

  @Nullable
  public final Document getXSLTDocument ()
  {
    return m_aSchematronXSLTDoc;
  }

  @Nullable
  public final Templates getXSLTTemplates ()
  {
    return m_aSchematronXSLT;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).appendIfNotNull ("sch2xsltDoc", m_aSchematronXSLTDoc)
                                       .appendIfNotNull ("sch2xsltTemplates", m_aSchematronXSLT)
                                       .toString ();
  }
}
