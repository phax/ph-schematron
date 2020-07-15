/**
 * Copyright (C) 2014-2020 Philip Helger (www.helger.com)
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
package com.helger.maven.schematron;

import java.io.File;
import java.util.Locale;

import javax.annotation.Nonnull;

import org.sonatype.plexus.build.incremental.BuildContext;

import com.helger.commons.error.IError;
import com.helger.commons.string.StringHelper;
import com.helger.xml.transform.AbstractTransformErrorListener;

public class PluginErrorListener extends AbstractTransformErrorListener
{
  private final BuildContext m_aBuildContext;
  private final File m_aSourceFile;

  public PluginErrorListener (@Nonnull final BuildContext aBuildContext, @Nonnull final File aSource)
  {
    m_aBuildContext = aBuildContext;
    m_aSourceFile = aSource;
  }

  public static void logIError (@Nonnull final BuildContext aBuildContext, @Nonnull final File aSourceFile, @Nonnull final IError aResError)
  {
    final int nLine = aResError.getErrorLocation ().getLineNumber ();
    final int nColumn = aResError.getErrorLocation ().getColumnNumber ();
    final String sMessage = StringHelper.getImplodedNonEmpty (" - ",
                                                              aResError.getErrorText (Locale.US),
                                                              aResError.getLinkedExceptionMessage ());

    // 0 means undefined line/column
    aBuildContext.addMessage (aSourceFile,
                              nLine <= 0 ? 0 : nLine,
                              nColumn <= 0 ? 0 : nColumn,
                              sMessage,
                              aResError.isError () ? BuildContext.SEVERITY_ERROR : BuildContext.SEVERITY_WARNING,
                              aResError.getLinkedExceptionCause ());
  }

  @Override
  protected void internalLog (@Nonnull final IError aResError)
  {
    logIError (m_aBuildContext, m_aSourceFile, aResError);
  }
}
