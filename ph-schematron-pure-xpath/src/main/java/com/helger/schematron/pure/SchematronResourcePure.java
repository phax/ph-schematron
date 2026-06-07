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
package com.helger.schematron.pure;

import java.io.File;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.charset.Charset;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.Nonempty;
import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.FileSystemResource;
import com.helger.io.resource.IReadableResource;
import com.helger.io.resource.URLResource;
import com.helger.io.resource.inmemory.ReadableResourceByteArray;
import com.helger.io.resource.inmemory.ReadableResourceInputStream;
import com.helger.schematron.errorhandler.IPSErrorHandler;
import com.helger.schematron.model.PSSchema;
import com.helger.schematron.pure.validation.IPSValidationHandler;
import com.helger.schematron.pure.xpath.IXPathConfig;

/**
 * Pre-v10 name for {@link SchematronResourcePureXPath}. Preserved as a deprecated source-compatible
 * subclass for callers that already use the older type name; the implementation lives entirely on
 * the parent class. New code should use {@link SchematronResourcePureXPath} directly.
 * <p>
 * Setter methods are overridden with covariant return type so that existing chained code that
 * assigns the result back to a {@code SchematronResourcePure} variable continues to compile.
 *
 * @author Philip Helger
 * @deprecated Use {@link SchematronResourcePureXPath} instead. Will remain as a deprecated alias
 *             for the foreseeable future to maintain pre-10.0 source compatibility.
 */
@Deprecated (since = "10.0.0", forRemoval = false)
@NotThreadSafe
public class SchematronResourcePure extends SchematronResourcePureXPath
{
  @Deprecated (since = "10.0.0", forRemoval = false)
  public SchematronResourcePure (@NonNull final IReadableResource aResource)
  {
    super (aResource);
  }

  @Deprecated (since = "10.0.0", forRemoval = false)
  public SchematronResourcePure (@NonNull final IReadableResource aResource,
                                 @Nullable final String sPhase,
                                 @Nullable final IPSErrorHandler aErrorHandler)
  {
    super (aResource, sPhase, aErrorHandler);
  }

  // === Covariant setters so old `SchematronResourcePure x = new
  // SchematronResourcePure(r).setPhase(...);`
  // chained code keeps compiling without explicit casts ===

  @Deprecated (since = "10.0.0", forRemoval = false)
  @Override
  @NonNull
  public final SchematronResourcePure setPhase (@Nullable final String sPhase)
  {
    super.setPhase (sPhase);
    return this;
  }

  @Deprecated (since = "10.0.0", forRemoval = false)
  @Override
  @NonNull
  public final SchematronResourcePure setErrorHandler (@Nullable final IPSErrorHandler aErrorHandler)
  {
    super.setErrorHandler (aErrorHandler);
    return this;
  }

  @Deprecated (since = "10.0.0", forRemoval = false)
  @Override
  @NonNull
  public final SchematronResourcePure setCustomValidationHandler (@Nullable final IPSValidationHandler aCustomValidationHandler)
  {
    super.setCustomValidationHandler (aCustomValidationHandler);
    return this;
  }

  @Deprecated (since = "10.0.0", forRemoval = false)
  @Override
  @NonNull
  public final SchematronResourcePure setXPathConfig (@NonNull final IXPathConfig aXPathConfig)
  {
    super.setXPathConfig (aXPathConfig);
    return this;
  }

  @Deprecated (since = "10.0.0", forRemoval = false)
  @Override
  @NonNull
  public final SchematronResourcePure setTelemetry (final boolean bTelemetry)
  {
    super.setTelemetry (bTelemetry);
    return this;
  }

  @Deprecated (since = "10.0.0", forRemoval = false)
  @Override
  @NonNull
  public final SchematronResourcePure setPerAssertionTelemetry (final boolean bPerAssertionTelemetry)
  {
    super.setPerAssertionTelemetry (bPerAssertionTelemetry);
    return this;
  }

  // === Covariant static factories so `SchematronResourcePure x =
  // SchematronResourcePure.fromFile(f);`
  // chained code keeps compiling. These hide (not override) the parent's static methods. ===

  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourcePure fromClassPath (@NonNull @Nonempty final String sSCHPath)
  {
    return new SchematronResourcePure (new ClassPathResource (sSCHPath));
  }

  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourcePure fromClassPath (@NonNull @Nonempty final String sSCHPath,
                                                      @Nullable final ClassLoader aClassLoader)
  {
    return new SchematronResourcePure (new ClassPathResource (sSCHPath, aClassLoader));
  }

  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourcePure fromFile (@NonNull @Nonempty final String sSCHPath)
  {
    return new SchematronResourcePure (new FileSystemResource (sSCHPath));
  }

  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourcePure fromFile (@NonNull final File aSCHFile)
  {
    return new SchematronResourcePure (new FileSystemResource (aSCHFile));
  }

  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourcePure fromURL (@NonNull @Nonempty final String sSCHURL) throws MalformedURLException
  {
    return new SchematronResourcePure (new URLResource (sSCHURL));
  }

  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourcePure fromURL (@NonNull final URL aSCHURL)
  {
    return new SchematronResourcePure (new URLResource (aSCHURL));
  }

  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourcePure fromInputStream (@NonNull @Nonempty final String sResourceID,
                                                        @NonNull final InputStream aSchematronIS)
  {
    return new SchematronResourcePure (new ReadableResourceInputStream (sResourceID, aSchematronIS));
  }

  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourcePure fromByteArray (@NonNull final byte [] aSchematron)
  {
    return new SchematronResourcePure (new ReadableResourceByteArray (aSchematron));
  }

  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourcePure fromString (@NonNull final String sSchematron, @NonNull final Charset aCharset)
  {
    return fromByteArray (sSchematron.getBytes (aCharset));
  }

  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourcePure fromSchema (@NonNull final PSSchema aSchematron)
  {
    // Round-trip via SchematronResourcePureXPath.fromSchema's serialization, but wrap the result
    // in a SchematronResourcePure so callers that typed the variable as SchematronResourcePure
    // still compile.
    final SchematronResourcePureXPath aXPath = SchematronResourcePureXPath.fromSchema (aSchematron);
    return new SchematronResourcePure (aXPath.getResource ());
  }
}
