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
package com.helger.schematron.xslt;

import java.io.File;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.NotThreadSafe;
import javax.xml.transform.ErrorListener;
import javax.xml.transform.URIResolver;

import com.helger.commons.annotations.Nonempty;
import com.helger.commons.io.IReadableResource;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.FileSystemResource;

/**
 * A Schematron resource that is based on an existing, pre-compiled XSLT script.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class SchematronResourceXSLT extends AbstractSchematronXSLTResource
{
  /**
   * Constructor
   *
   * @param aXSLTResource
   *        The XSLT resource. May not be <code>null</code>.
   */
  public SchematronResourceXSLT (@Nonnull final IReadableResource aXSLTResource)
  {
    this (aXSLTResource, (ErrorListener) null, (URIResolver) null);
  }

  /**
   * Constructor
   *
   * @param aXSLTResource
   *        The XSLT resource. May not be <code>null</code>.
   * @param aValidator
   *        The validator to be used to determine whether a Schematron
   *        validation was successful or not. May not be <code>null</code>.
   */
  public SchematronResourceXSLT (@Nonnull final IReadableResource aXSLTResource,
                                 @Nonnull final ISchematronXSLTValidator aValidator)
  {
    this (aXSLTResource, (ErrorListener) null, (URIResolver) null, aValidator);
  }

  /**
   * Constructor
   *
   * @param aXSLTResource
   *        The XSLT resource. May not be <code>null</code>.
   * @param aCustomErrorListener
   *        An optional custom XSLT error listener that is used when applying
   *        the XSLT resource to an XML document. May be <code>null</code>.
   * @param aCustomURIResolver
   *        An optional custom XSLT URI resolver that is used when applying the
   *        XSLT resource to an XML document. May be <code>null</code>.
   */
  public SchematronResourceXSLT (@Nonnull final IReadableResource aXSLTResource,
                                 @Nullable final ErrorListener aCustomErrorListener,
                                 @Nullable final URIResolver aCustomURIResolver)
  {
    super (aXSLTResource,
           aCustomErrorListener,
           aCustomURIResolver,
           SchematronResourceXSLTCache.getSchematronXSLTProvider (aXSLTResource));
  }

  /**
   * Constructor
   *
   * @param aXSLTResource
   *        The XSLT resource. May not be <code>null</code>.
   * @param aCustomErrorListener
   *        An optional custom XSLT error listener that is used when applying
   *        the XSLT resource to an XML document. May be <code>null</code>.
   * @param aCustomURIResolver
   *        An optional custom XSLT URI resolver that is used when applying the
   *        XSLT resource to an XML document. May be <code>null</code>.
   * @param aValidator
   *        The validator to be used to determine whether a Schematron
   *        validation was successful or not. May not be <code>null</code>.
   */
  public SchematronResourceXSLT (@Nonnull final IReadableResource aXSLTResource,
                                 @Nullable final ErrorListener aCustomErrorListener,
                                 @Nullable final URIResolver aCustomURIResolver,
                                 @Nonnull final ISchematronXSLTValidator aValidator)
  {
    super (aXSLTResource,
           aCustomErrorListener,
           aCustomURIResolver,
           SchematronResourceXSLTCache.getSchematronXSLTProvider (aXSLTResource),
           aValidator);
  }

  @Nonnull
  public static SchematronResourceXSLT fromClassPath (@Nonnull @Nonempty final String sXSLTPath)
  {
    return new SchematronResourceXSLT (new ClassPathResource (sXSLTPath));
  }

  @Nonnull
  public static SchematronResourceXSLT fromClassPath (@Nonnull @Nonempty final String sXSLTPath,
                                                      @Nonnull final ISchematronXSLTValidator aValidator)
  {
    return new SchematronResourceXSLT (new ClassPathResource (sXSLTPath), aValidator);
  }

  @Nonnull
  public static SchematronResourceXSLT fromClassPath (@Nonnull @Nonempty final String sXSLTPath,
                                                      @Nullable final ErrorListener aCustomErrorListener,
                                                      @Nullable final URIResolver aCustomURIResolver)
  {
    return new SchematronResourceXSLT (new ClassPathResource (sXSLTPath), aCustomErrorListener, aCustomURIResolver);
  }

  @Nonnull
  public static SchematronResourceXSLT fromClassPath (@Nonnull @Nonempty final String sXSLTPath,
                                                      @Nullable final ErrorListener aCustomErrorListener,
                                                      @Nullable final URIResolver aCustomURIResolver,
                                                      @Nonnull final ISchematronXSLTValidator aValidator)
  {
    return new SchematronResourceXSLT (new ClassPathResource (sXSLTPath),
                                       aCustomErrorListener,
                                       aCustomURIResolver,
                                       aValidator);
  }

  @Nonnull
  public static SchematronResourceXSLT fromFile (@Nonnull @Nonempty final String sXSLTPath)
  {
    return new SchematronResourceXSLT (new FileSystemResource (sXSLTPath));
  }

  @Nonnull
  public static SchematronResourceXSLT fromFile (@Nonnull @Nonempty final String sXSLTPath,
                                                 @Nonnull final ISchematronXSLTValidator aValidator)
  {
    return new SchematronResourceXSLT (new FileSystemResource (sXSLTPath), aValidator);
  }

  @Nonnull
  public static SchematronResourceXSLT fromFile (@Nonnull @Nonempty final String sXSLTPath,
                                                 @Nullable final ErrorListener aCustomErrorListener,
                                                 @Nullable final URIResolver aCustomURIResolver)
  {
    return new SchematronResourceXSLT (new FileSystemResource (sXSLTPath), aCustomErrorListener, aCustomURIResolver);
  }

  @Nonnull
  public static SchematronResourceXSLT fromFile (@Nonnull @Nonempty final String sXSLTPath,
                                                 @Nullable final ErrorListener aCustomErrorListener,
                                                 @Nullable final URIResolver aCustomURIResolver,
                                                 @Nonnull final ISchematronXSLTValidator aValidator)
  {
    return new SchematronResourceXSLT (new FileSystemResource (sXSLTPath),
                                       aCustomErrorListener,
                                       aCustomURIResolver,
                                       aValidator);
  }

  @Nonnull
  public static SchematronResourceXSLT fromFile (@Nonnull final File aXSLTFile)
  {
    return new SchematronResourceXSLT (new FileSystemResource (aXSLTFile));
  }

  @Nonnull
  public static SchematronResourceXSLT fromFile (@Nonnull final File aXSLTFile,
                                                 @Nonnull final ISchematronXSLTValidator aValidator)
  {
    return new SchematronResourceXSLT (new FileSystemResource (aXSLTFile), aValidator);
  }

  @Nonnull
  public static SchematronResourceXSLT fromFile (@Nonnull final File aXSLTFile,
                                                 @Nullable final ErrorListener aCustomErrorListener,
                                                 @Nullable final URIResolver aCustomURIResolver)
  {
    return new SchematronResourceXSLT (new FileSystemResource (aXSLTFile), aCustomErrorListener, aCustomURIResolver);
  }

  @Nonnull
  public static SchematronResourceXSLT fromFile (@Nonnull final File aXSLTFile,
                                                 @Nullable final ErrorListener aCustomErrorListener,
                                                 @Nullable final URIResolver aCustomURIResolver,
                                                 @Nonnull final ISchematronXSLTValidator aValidator)
  {
    return new SchematronResourceXSLT (new FileSystemResource (aXSLTFile),
                                       aCustomErrorListener,
                                       aCustomURIResolver,
                                       aValidator);
  }
}
