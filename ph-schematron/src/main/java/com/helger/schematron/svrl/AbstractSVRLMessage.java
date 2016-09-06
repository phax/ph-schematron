/**
 * Copyright (C) 2014-2016 Philip Helger (www.helger.com)
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
package com.helger.schematron.svrl;

import java.util.List;
import java.util.regex.Matcher;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import org.oclc.purl.dsdl.svrl.DiagnosticReference;

import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.ext.CommonsArrayList;
import com.helger.commons.collection.ext.ICommonsList;
import com.helger.commons.error.level.IErrorLevel;
import com.helger.commons.error.location.ErrorLocation;
import com.helger.commons.regex.RegExHelper;
import com.helger.commons.string.StringHelper;
import com.helger.commons.string.ToStringGenerator;
import com.helger.schematron.svrl.SVRLResourceError.SVRLErrorBuilder;

/**
 * A wrapper around FailedAssert and SuccessfulReport with easier error level
 * handling.
 *
 * @author Philip Helger
 */
public abstract class AbstractSVRLMessage
{
  protected ICommonsList <DiagnosticReference> m_aDiagnosticReferences;
  protected String m_sText;
  protected String m_sLocation;
  protected String m_sTest;
  protected String m_sRole;
  protected IErrorLevel m_aFlag;

  @Nonnull
  protected static String getBeautifiedLocation (@Nonnull final String sLocation)
  {
    String sResult = sLocation;
    // Handle namespaces:
    // Search for "*:xx[namespace-uri()='yy']" where xx is the localname and yy
    // is the namespace URI
    final Matcher aMatcher = RegExHelper.getMatcher ("\\Q*:\\E([a-zA-Z0-9_]+)\\Q[namespace-uri()='\\E([^']+)\\Q']\\E",
                                                     sResult);
    while (aMatcher.find ())
    {
      final String sLocalName = aMatcher.group (1);
      final String sNamespaceURI = aMatcher.group (2);

      // Check if there is a known beautifier for this pair of namespace and
      // local name
      final String sBeautified = SVRLLocationBeautifierRegistry.getBeautifiedLocation (sNamespaceURI, sLocalName);
      if (sBeautified != null)
        sResult = StringHelper.replaceAll (sResult, aMatcher.group (), sBeautified);
    }
    return sResult;
  }

  public AbstractSVRLMessage ()
  {}

  public AbstractSVRLMessage (@Nullable final List <DiagnosticReference> aDiagnosticReferences,
                              @Nullable final String sText,
                              @Nullable final String sLocation,
                              @Nullable final String sTest,
                              @Nullable final String sRole,
                              @Nullable final IErrorLevel aFlag)
  {
    m_aDiagnosticReferences = new CommonsArrayList<> (aDiagnosticReferences);
    m_sText = sText;
    m_sLocation = sLocation;
    m_sTest = sTest;
    m_sRole = sRole;
    m_aFlag = aFlag;
  }

  @Nonnull
  @ReturnsMutableCopy
  public ICommonsList <DiagnosticReference> getDiagnisticReferences ()
  {
    return m_aDiagnosticReferences.getClone ();
  }

  @Nullable
  public String getText ()
  {
    return m_sText;
  }

  @Nullable
  public String getLocation ()
  {
    return m_sLocation;
  }

  @Nullable
  public String getTest ()
  {
    return m_sTest;
  }

  @Nullable
  public String getRole ()
  {
    return m_sRole;
  }

  @Nonnull
  public IErrorLevel getFlag ()
  {
    return m_aFlag;
  }

  @Nonnull
  public SVRLResourceError getAsResourceError (@Nullable final String sResourceName)
  {
    return new SVRLErrorBuilder (m_sTest).setErrorLevel (m_aFlag)
                                         .setErrorFieldName (m_sLocation)
                                         .setErrorLocation (new ErrorLocation (sResourceName))
                                         .setErrorText (m_sText)
                                         .build ();
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("diagnosticRefs", m_aDiagnosticReferences)
                                       .append ("text", m_sText)
                                       .append ("location", m_sLocation)
                                       .append ("test", m_sTest)
                                       .appendIfNotNull ("role", m_sRole)
                                       .append ("flag", m_aFlag)
                                       .toString ();
  }
}
