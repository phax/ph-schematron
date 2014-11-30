/**
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
 * A Schematron resource that is based on the original SCH file.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class SchematronResourceSCH extends AbstractSchematronXSLTResource
{
  /**
   * Constructor
   *
   * @param aSCHResource
   *        The Schematron resource. May not be <code>null</code>.
   */
  public SchematronResourceSCH (@Nonnull final IReadableResource aSCHResource)
  {
    this (aSCHResource, null, null, null, null);
  }

  /**
   * Constructor
   *
   * @param aSCHResource
   *        The Schematron resource. May not be <code>null</code>.
   * @param aValidator
   *        The validator to be used to determine whether a Schematron
   *        validation was successful or not. May not be <code>null</code>.
   */
  public SchematronResourceSCH (@Nonnull final IReadableResource aSCHResource,
                                @Nonnull final ISchematronXSLTValidator aValidator)
  {
    this (aSCHResource, (ErrorListener) null, (URIResolver) null, (String) null, (String) null, aValidator);
  }

  /**
   * Constructor
   *
   * @param aSCHResource
   *        The Schematron resource. May not be <code>null</code>.
   * @param aCustomErrorListener
   *        An optional custom XSLT error listener that is used when converting
   *        the Schematron resource to an XSLT document, as well as for the
   *        application of the XSLT onto the XML to be validated. May be
   *        <code>null</code>.
   * @param aCustomURIResolver
   *        An optional custom XSLT URI resolver that is used when converting
   *        the Schematron resource to an XSLT document, as well as for the
   *        application of the XSLT onto the XML to be validated. May be
   *        <code>null</code>.
   */
  public SchematronResourceSCH (@Nonnull final IReadableResource aSCHResource,
                                @Nullable final ErrorListener aCustomErrorListener,
                                @Nullable final URIResolver aCustomURIResolver)
  {
    this (aSCHResource, aCustomErrorListener, aCustomURIResolver, (String) null, (String) null);
  }

  /**
   * Constructor
   *
   * @param aSCHResource
   *        The Schematron resource. May not be <code>null</code>.
   * @param sPhase
   *        Optional phase to use. If not specified, the defaultPhase from the
   *        schema is used. If no default phase is specified, than all patterns
   *        are used
   * @param sLanguageCode
   *        An optional language code for the error messages. <code>null</code>
   *        means English. Supported language codes are: cs, de, en, fr, nl (see
   *        directory files schematron\20100414-xslt2\sch-messages-??.xhtml).
   */
  public SchematronResourceSCH (@Nonnull final IReadableResource aSCHResource,
                                @Nullable final String sPhase,
                                @Nullable final String sLanguageCode)
  {
    this (aSCHResource, (ErrorListener) null, (URIResolver) null, sPhase, sLanguageCode);
  }

  /**
   * Constructor
   *
   * @param aSCHResource
   *        The Schematron resource. May not be <code>null</code>.
   * @param aCustomErrorListener
   *        An optional custom XSLT error listener that is used when converting
   *        the Schematron resource to an XSLT document. May be
   *        <code>null</code>.
   * @param aCustomURIResolver
   *        An optional custom XSLT URI resolver that is used when converting
   *        the Schematron resource to an XSLT document. May be
   *        <code>null</code>.
   * @param sPhase
   *        Optional phase to use. If not specified, the defaultPhase from the
   *        schema is used. If no default phase is specified, than all patterns
   *        are used
   * @param sLanguageCode
   *        An optional language code for the error messages. <code>null</code>
   *        means English. Supported language codes are: cs, de, en, fr, nl (see
   *        directory files schematron\20100414-xslt2\sch-messages-??.xhtml).
   */
  public SchematronResourceSCH (@Nonnull final IReadableResource aSCHResource,
                                @Nullable final ErrorListener aCustomErrorListener,
                                @Nullable final URIResolver aCustomURIResolver,
                                @Nullable final String sPhase,
                                @Nullable final String sLanguageCode)
  {
    this (aSCHResource,
          aCustomErrorListener,
          aCustomURIResolver,
          sPhase,
          sLanguageCode,
          new SchematronXSLTValidatorDefault ());
  }

  /**
   * Constructor
   *
   * @param aSCHResource
   *        The Schematron resource. May not be <code>null</code>.
   * @param aCustomErrorListener
   *        An optional custom XSLT error listener that is used when converting
   *        the Schematron resource to an XSLT document, as well as for the
   *        application of the XSLT onto the XML to be validated. May be
   *        <code>null</code>.
   * @param aCustomURIResolver
   *        An optional custom XSLT URI resolver that is used when converting
   *        the Schematron resource to an XSLT document, as well as for the
   *        application of the XSLT onto the XML to be validated. May be
   *        <code>null</code>.
   * @param sPhase
   *        Optional phase to use. If not specified, the defaultPhase from the
   *        schema is used. If no default phase is specified, than all patterns
   *        are used
   * @param sLanguageCode
   *        An optional language code for the error messages. <code>null</code>
   *        means English. Supported language codes are: cs, de, en, fr, nl (see
   *        directory files schematron\20100414-xslt2\sch-messages-??.xhtml).
   * @param aValidator
   *        The validator to be used to determine whether a Schematron
   *        validation was successful or not. May not be <code>null</code>.
   */
  public SchematronResourceSCH (@Nonnull final IReadableResource aSCHResource,
                                @Nullable final ErrorListener aCustomErrorListener,
                                @Nullable final URIResolver aCustomURIResolver,
                                @Nullable final String sPhase,
                                @Nullable final String sLanguageCode,
                                @Nonnull final ISchematronXSLTValidator aValidator)
  {
    super (aSCHResource,
           aCustomErrorListener,
           aCustomURIResolver,
           SchematronResourceSCHCache.getSchematronXSLTProvider (aSCHResource,
                                                                 aCustomErrorListener,
                                                                 aCustomURIResolver,
                                                                 sPhase,
                                                                 sLanguageCode), aValidator);
  }

  /**
   * Create a new Schematron resource.
   *
   * @param sSCHPath
   *        The classpath relative path to the Schematron file. May neither be
   *        <code>null</code> nor empty.
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourceSCH fromClassPath (@Nonnull @Nonempty final String sSCHPath)
  {
    return new SchematronResourceSCH (new ClassPathResource (sSCHPath));
  }

  /**
   * Create a new Schematron resource.
   *
   * @param sSCHPath
   *        The classpath relative path to the Schematron file. May neither be
   *        <code>null</code> nor empty.
   * @param aValidator
   *        The validator to be used to determine whether a Schematron
   *        validation was successful or not. May not be <code>null</code>.
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourceSCH fromClassPath (@Nonnull @Nonempty final String sSCHPath,
                                                     @Nonnull final ISchematronXSLTValidator aValidator)
  {
    return new SchematronResourceSCH (new ClassPathResource (sSCHPath), aValidator);
  }

  /**
   * Create a new Schematron resource.
   *
   * @param sSCHPath
   *        The classpath relative path to the Schematron file. May neither be
   *        <code>null</code> nor empty.
   * @param aCustomErrorListener
   *        An optional custom XSLT error listener that is used when converting
   *        the Schematron resource to an XSLT document, as well as for the
   *        application of the XSLT onto the XML to be validated. May be
   *        <code>null</code>.
   * @param aCustomURIResolver
   *        An optional custom XSLT URI resolver that is used when converting
   *        the Schematron resource to an XSLT document, as well as for the
   *        application of the XSLT onto the XML to be validated. May be
   *        <code>null</code>.
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourceSCH fromClassPath (@Nonnull @Nonempty final String sSCHPath,
                                                     @Nullable final ErrorListener aCustomErrorListener,
                                                     @Nullable final URIResolver aCustomURIResolver)
  {
    return new SchematronResourceSCH (new ClassPathResource (sSCHPath), aCustomErrorListener, aCustomURIResolver);
  }

  /**
   * Create a new Schematron resource.
   *
   * @param sSCHPath
   *        The classpath relative path to the Schematron file. May neither be
   *        <code>null</code> nor empty.
   * @param aCustomErrorListener
   *        An optional custom XSLT error listener that is used when converting
   *        the Schematron resource to an XSLT document, as well as for the
   *        application of the XSLT onto the XML to be validated. May be
   *        <code>null</code>.
   * @param aCustomURIResolver
   *        An optional custom XSLT URI resolver that is used when converting
   *        the Schematron resource to an XSLT document, as well as for the
   *        application of the XSLT onto the XML to be validated. May be
   *        <code>null</code>.
   * @param aValidator
   *        The validator to be used to determine whether a Schematron
   *        validation was successful or not. May not be <code>null</code>.
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourceSCH fromClassPath (@Nonnull @Nonempty final String sSCHPath,
                                                     @Nullable final ErrorListener aCustomErrorListener,
                                                     @Nullable final URIResolver aCustomURIResolver,
                                                     @Nonnull final ISchematronXSLTValidator aValidator)
  {
    return new SchematronResourceSCH (new ClassPathResource (sSCHPath),
                                      aCustomErrorListener,
                                      aCustomURIResolver,
                                      (String) null,
                                      (String) null,
                                      aValidator);
  }

  /**
   * Create a new Schematron resource.
   *
   * @param sSCHPath
   *        The classpath relative path to the Schematron file. May neither be
   *        <code>null</code> nor empty.
   * @param sPhase
   *        Optional phase to use. If not specified, the defaultPhase from the
   *        schema is used. If no default phase is specified, than all patterns
   *        are used
   * @param sLanguageCode
   *        An optional language code for the error messages. <code>null</code>
   *        means English. Supported language codes are: cs, de, en, fr, nl (see
   *        directory files schematron\20100414-xslt2\sch-messages-??.xhtml).
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourceSCH fromClassPath (@Nonnull @Nonempty final String sSCHPath,
                                                     @Nullable final String sPhase,
                                                     @Nullable final String sLanguageCode)
  {
    return new SchematronResourceSCH (new ClassPathResource (sSCHPath), sPhase, sLanguageCode);
  }

  /**
   * Create a new Schematron resource.
   *
   * @param sSCHPath
   *        The classpath relative path to the Schematron file. May neither be
   *        <code>null</code> nor empty.
   * @param sPhase
   *        Optional phase to use. If not specified, the defaultPhase from the
   *        schema is used. If no default phase is specified, than all patterns
   *        are used
   * @param sLanguageCode
   *        An optional language code for the error messages. <code>null</code>
   *        means English. Supported language codes are: cs, de, en, fr, nl (see
   *        directory files schematron\20100414-xslt2\sch-messages-??.xhtml).
   * @param aValidator
   *        The validator to be used to determine whether a Schematron
   *        validation was successful or not. May not be <code>null</code>.
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourceSCH fromClassPath (@Nonnull @Nonempty final String sSCHPath,
                                                     @Nullable final String sPhase,
                                                     @Nullable final String sLanguageCode,
                                                     @Nonnull final ISchematronXSLTValidator aValidator)
  {
    return new SchematronResourceSCH (new ClassPathResource (sSCHPath),
                                      (ErrorListener) null,
                                      (URIResolver) null,
                                      sPhase,
                                      sLanguageCode,
                                      aValidator);
  }

  /**
   * Create a new Schematron resource.
   *
   * @param sSCHPath
   *        The classpath relative path to the Schematron file. May neither be
   *        <code>null</code> nor empty.
   * @param aCustomErrorListener
   *        An optional custom XSLT error listener that is used when converting
   *        the Schematron resource to an XSLT document, as well as for the
   *        application of the XSLT onto the XML to be validated. May be
   *        <code>null</code>.
   * @param aCustomURIResolver
   *        An optional custom XSLT URI resolver that is used when converting
   *        the Schematron resource to an XSLT document, as well as for the
   *        application of the XSLT onto the XML to be validated. May be
   *        <code>null</code>.
   * @param sPhase
   *        Optional phase to use. If not specified, the defaultPhase from the
   *        schema is used. If no default phase is specified, than all patterns
   *        are used
   * @param sLanguageCode
   *        An optional language code for the error messages. <code>null</code>
   *        means English. Supported language codes are: cs, de, en, fr, nl (see
   *        directory files schematron\20100414-xslt2\sch-messages-??.xhtml).
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourceSCH fromClassPath (@Nonnull @Nonempty final String sSCHPath,
                                                     @Nullable final ErrorListener aCustomErrorListener,
                                                     @Nullable final URIResolver aCustomURIResolver,
                                                     @Nullable final String sPhase,
                                                     @Nullable final String sLanguageCode)
  {
    return new SchematronResourceSCH (new ClassPathResource (sSCHPath),
                                      aCustomErrorListener,
                                      aCustomURIResolver,
                                      sPhase,
                                      sLanguageCode);
  }

  /**
   * Create a new Schematron resource.
   *
   * @param sSCHPath
   *        The classpath relative path to the Schematron file. May neither be
   *        <code>null</code> nor empty.
   * @param aCustomErrorListener
   *        An optional custom XSLT error listener that is used when converting
   *        the Schematron resource to an XSLT document, as well as for the
   *        application of the XSLT onto the XML to be validated. May be
   *        <code>null</code>.
   * @param aCustomURIResolver
   *        An optional custom XSLT URI resolver that is used when converting
   *        the Schematron resource to an XSLT document, as well as for the
   *        application of the XSLT onto the XML to be validated. May be
   *        <code>null</code>.
   * @param sPhase
   *        Optional phase to use. If not specified, the defaultPhase from the
   *        schema is used. If no default phase is specified, than all patterns
   *        are used
   * @param sLanguageCode
   *        An optional language code for the error messages. <code>null</code>
   *        means English. Supported language codes are: cs, de, en, fr, nl (see
   *        directory files schematron\20100414-xslt2\sch-messages-??.xhtml).
   * @param aValidator
   *        The validator to be used to determine whether a Schematron
   *        validation was successful or not. May not be <code>null</code>.
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourceSCH fromClassPath (@Nonnull @Nonempty final String sSCHPath,
                                                     @Nullable final ErrorListener aCustomErrorListener,
                                                     @Nullable final URIResolver aCustomURIResolver,
                                                     @Nullable final String sPhase,
                                                     @Nullable final String sLanguageCode,
                                                     @Nonnull final ISchematronXSLTValidator aValidator)
  {
    return new SchematronResourceSCH (new ClassPathResource (sSCHPath),
                                      aCustomErrorListener,
                                      aCustomURIResolver,
                                      sPhase,
                                      sLanguageCode,
                                      aValidator);
  }

  /**
   * Create a new Schematron resource.
   *
   * @param sSCHPath
   *        The file system path to the Schematron file. May neither be
   *        <code>null</code> nor empty.
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourceSCH fromFile (@Nonnull @Nonempty final String sSCHPath)
  {
    return new SchematronResourceSCH (new FileSystemResource (sSCHPath));
  }

  /**
   * Create a new Schematron resource.
   *
   * @param sSCHPath
   *        The file system path to the Schematron file. May neither be
   *        <code>null</code> nor empty.
   * @param aValidator
   *        The validator to be used to determine whether a Schematron
   *        validation was successful or not. May not be <code>null</code>.
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourceSCH fromFile (@Nonnull @Nonempty final String sSCHPath,
                                                @Nonnull final ISchematronXSLTValidator aValidator)
  {
    return new SchematronResourceSCH (new FileSystemResource (sSCHPath), aValidator);
  }

  /**
   * Create a new Schematron resource.
   *
   * @param sSCHPath
   *        The file system path to the Schematron file. May neither be
   *        <code>null</code> nor empty.
   * @param aCustomErrorListener
   *        An optional custom XSLT error listener that is used when converting
   *        the Schematron resource to an XSLT document, as well as for the
   *        application of the XSLT onto the XML to be validated. May be
   *        <code>null</code>.
   * @param aCustomURIResolver
   *        An optional custom XSLT URI resolver that is used when converting
   *        the Schematron resource to an XSLT document, as well as for the
   *        application of the XSLT onto the XML to be validated. May be
   *        <code>null</code>.
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourceSCH fromFile (@Nonnull @Nonempty final String sSCHPath,
                                                @Nullable final ErrorListener aCustomErrorListener,
                                                @Nullable final URIResolver aCustomURIResolver)
  {
    return new SchematronResourceSCH (new FileSystemResource (sSCHPath), aCustomErrorListener, aCustomURIResolver);
  }

  /**
   * Create a new Schematron resource.
   *
   * @param sSCHPath
   *        The file system path to the Schematron file. May neither be
   *        <code>null</code> nor empty.
   * @param aCustomErrorListener
   *        An optional custom XSLT error listener that is used when converting
   *        the Schematron resource to an XSLT document, as well as for the
   *        application of the XSLT onto the XML to be validated. May be
   *        <code>null</code>.
   * @param aCustomURIResolver
   *        An optional custom XSLT URI resolver that is used when converting
   *        the Schematron resource to an XSLT document, as well as for the
   *        application of the XSLT onto the XML to be validated. May be
   *        <code>null</code>.
   * @param aValidator
   *        The validator to be used to determine whether a Schematron
   *        validation was successful or not. May not be <code>null</code>.
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourceSCH fromFile (@Nonnull @Nonempty final String sSCHPath,
                                                @Nullable final ErrorListener aCustomErrorListener,
                                                @Nullable final URIResolver aCustomURIResolver,
                                                @Nonnull final ISchematronXSLTValidator aValidator)
  {
    return new SchematronResourceSCH (new FileSystemResource (sSCHPath),
                                      aCustomErrorListener,
                                      aCustomURIResolver,
                                      (String) null,
                                      (String) null,
                                      aValidator);
  }

  /**
   * Create a new Schematron resource.
   *
   * @param sSCHPath
   *        The file system path to the Schematron file. May neither be
   *        <code>null</code> nor empty.
   * @param sPhase
   *        Optional phase to use. If not specified, the defaultPhase from the
   *        schema is used. If no default phase is specified, than all patterns
   *        are used
   * @param sLanguageCode
   *        An optional language code for the error messages. <code>null</code>
   *        means English. Supported language codes are: cs, de, en, fr, nl (see
   *        directory files schematron\20100414-xslt2\sch-messages-??.xhtml).
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourceSCH fromFile (@Nonnull @Nonempty final String sSCHPath,
                                                @Nullable final String sPhase,
                                                @Nullable final String sLanguageCode)
  {
    return new SchematronResourceSCH (new FileSystemResource (sSCHPath), sPhase, sLanguageCode);
  }

  /**
   * Create a new Schematron resource.
   *
   * @param sSCHPath
   *        The file system path to the Schematron file. May neither be
   *        <code>null</code> nor empty.
   * @param sPhase
   *        Optional phase to use. If not specified, the defaultPhase from the
   *        schema is used. If no default phase is specified, than all patterns
   *        are used
   * @param sLanguageCode
   *        An optional language code for the error messages. <code>null</code>
   *        means English. Supported language codes are: cs, de, en, fr, nl (see
   *        directory files schematron\20100414-xslt2\sch-messages-??.xhtml).
   * @param aValidator
   *        The validator to be used to determine whether a Schematron
   *        validation was successful or not. May not be <code>null</code>.
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourceSCH fromFile (@Nonnull @Nonempty final String sSCHPath,
                                                @Nullable final String sPhase,
                                                @Nullable final String sLanguageCode,
                                                @Nonnull final ISchematronXSLTValidator aValidator)
  {
    return new SchematronResourceSCH (new FileSystemResource (sSCHPath),
                                      (ErrorListener) null,
                                      (URIResolver) null,
                                      sPhase,
                                      sLanguageCode,
                                      aValidator);
  }

  /**
   * Create a new Schematron resource.
   *
   * @param sSCHPath
   *        The file system path to the Schematron file. May neither be
   *        <code>null</code> nor empty.
   * @param aCustomErrorListener
   *        An optional custom XSLT error listener that is used when converting
   *        the Schematron resource to an XSLT document, as well as for the
   *        application of the XSLT onto the XML to be validated. May be
   *        <code>null</code>.
   * @param aCustomURIResolver
   *        An optional custom XSLT URI resolver that is used when converting
   *        the Schematron resource to an XSLT document, as well as for the
   *        application of the XSLT onto the XML to be validated. May be
   *        <code>null</code>.
   * @param sPhase
   *        Optional phase to use. If not specified, the defaultPhase from the
   *        schema is used. If no default phase is specified, than all patterns
   *        are used
   * @param sLanguageCode
   *        An optional language code for the error messages. <code>null</code>
   *        means English. Supported language codes are: cs, de, en, fr, nl (see
   *        directory files schematron\20100414-xslt2\sch-messages-??.xhtml).
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourceSCH fromFile (@Nonnull @Nonempty final String sSCHPath,
                                                @Nullable final ErrorListener aCustomErrorListener,
                                                @Nullable final URIResolver aCustomURIResolver,
                                                @Nullable final String sPhase,
                                                @Nullable final String sLanguageCode)
  {
    return new SchematronResourceSCH (new FileSystemResource (sSCHPath),
                                      aCustomErrorListener,
                                      aCustomURIResolver,
                                      sPhase,
                                      sLanguageCode);
  }

  /**
   * Create a new Schematron resource.
   *
   * @param sSCHPath
   *        The file system path to the Schematron file. May neither be
   *        <code>null</code> nor empty.
   * @param aCustomErrorListener
   *        An optional custom XSLT error listener that is used when converting
   *        the Schematron resource to an XSLT document, as well as for the
   *        application of the XSLT onto the XML to be validated. May be
   *        <code>null</code>.
   * @param aCustomURIResolver
   *        An optional custom XSLT URI resolver that is used when converting
   *        the Schematron resource to an XSLT document, as well as for the
   *        application of the XSLT onto the XML to be validated. May be
   *        <code>null</code>.
   * @param sPhase
   *        Optional phase to use. If not specified, the defaultPhase from the
   *        schema is used. If no default phase is specified, than all patterns
   *        are used
   * @param sLanguageCode
   *        An optional language code for the error messages. <code>null</code>
   *        means English. Supported language codes are: cs, de, en, fr, nl (see
   *        directory files schematron\20100414-xslt2\sch-messages-??.xhtml).
   * @param aValidator
   *        The validator to be used to determine whether a Schematron
   *        validation was successful or not. May not be <code>null</code>.
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourceSCH fromFile (@Nonnull @Nonempty final String sSCHPath,
                                                @Nullable final ErrorListener aCustomErrorListener,
                                                @Nullable final URIResolver aCustomURIResolver,
                                                @Nullable final String sPhase,
                                                @Nullable final String sLanguageCode,
                                                @Nonnull final ISchematronXSLTValidator aValidator)
  {
    return new SchematronResourceSCH (new FileSystemResource (sSCHPath),
                                      aCustomErrorListener,
                                      aCustomURIResolver,
                                      sPhase,
                                      sLanguageCode,
                                      aValidator);
  }

  /**
   * Create a new Schematron resource.
   *
   * @param aSCHFile
   *        The Schematron file. May not be <code>null</code>.
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourceSCH fromFile (@Nonnull final File aSCHFile)
  {
    return new SchematronResourceSCH (new FileSystemResource (aSCHFile));
  }

  /**
   * Create a new Schematron resource.
   *
   * @param aSCHFile
   *        The Schematron file. May not be <code>null</code>.
   * @param aValidator
   *        The validator to be used to determine whether a Schematron
   *        validation was successful or not. May not be <code>null</code>.
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourceSCH fromFile (@Nonnull final File aSCHFile,
                                                @Nonnull final ISchematronXSLTValidator aValidator)
  {
    return new SchematronResourceSCH (new FileSystemResource (aSCHFile), aValidator);
  }

  /**
   * Create a new Schematron resource.
   *
   * @param aSCHFile
   *        The Schematron file. May not be <code>null</code>.
   * @param aCustomErrorListener
   *        An optional custom XSLT error listener that is used when converting
   *        the Schematron resource to an XSLT document, as well as for the
   *        application of the XSLT onto the XML to be validated. May be
   *        <code>null</code>.
   * @param aCustomURIResolver
   *        An optional custom XSLT URI resolver that is used when converting
   *        the Schematron resource to an XSLT document, as well as for the
   *        application of the XSLT onto the XML to be validated. May be
   *        <code>null</code>.
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourceSCH fromFile (@Nonnull final File aSCHFile,
                                                @Nullable final ErrorListener aCustomErrorListener,
                                                @Nullable final URIResolver aCustomURIResolver)
  {
    return new SchematronResourceSCH (new FileSystemResource (aSCHFile), aCustomErrorListener, aCustomURIResolver);
  }

  /**
   * Create a new Schematron resource.
   *
   * @param aSCHFile
   *        The Schematron file. May not be <code>null</code>.
   * @param aCustomErrorListener
   *        An optional custom XSLT error listener that is used when converting
   *        the Schematron resource to an XSLT document, as well as for the
   *        application of the XSLT onto the XML to be validated. May be
   *        <code>null</code>.
   * @param aCustomURIResolver
   *        An optional custom XSLT URI resolver that is used when converting
   *        the Schematron resource to an XSLT document, as well as for the
   *        application of the XSLT onto the XML to be validated. May be
   *        <code>null</code>.
   * @param aValidator
   *        The validator to be used to determine whether a Schematron
   *        validation was successful or not. May not be <code>null</code>.
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourceSCH fromFile (@Nonnull final File aSCHFile,
                                                @Nullable final ErrorListener aCustomErrorListener,
                                                @Nullable final URIResolver aCustomURIResolver,
                                                @Nonnull final ISchematronXSLTValidator aValidator)
  {
    return new SchematronResourceSCH (new FileSystemResource (aSCHFile),
                                      aCustomErrorListener,
                                      aCustomURIResolver,
                                      (String) null,
                                      (String) null,
                                      aValidator);
  }

  /**
   * Create a new Schematron resource.
   *
   * @param aSCHFile
   *        The Schematron file. May not be <code>null</code>.
   * @param sPhase
   *        Optional phase to use. If not specified, the defaultPhase from the
   *        schema is used. If no default phase is specified, than all patterns
   *        are used
   * @param sLanguageCode
   *        An optional language code for the error messages. <code>null</code>
   *        means English. Supported language codes are: cs, de, en, fr, nl (see
   *        directory files schematron\20100414-xslt2\sch-messages-??.xhtml).
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourceSCH fromFile (@Nonnull final File aSCHFile,
                                                @Nullable final String sPhase,
                                                @Nullable final String sLanguageCode)
  {
    return new SchematronResourceSCH (new FileSystemResource (aSCHFile), sPhase, sLanguageCode);
  }

  /**
   * Create a new Schematron resource.
   *
   * @param aSCHFile
   *        The Schematron file. May not be <code>null</code>.
   * @param sPhase
   *        Optional phase to use. If not specified, the defaultPhase from the
   *        schema is used. If no default phase is specified, than all patterns
   *        are used
   * @param sLanguageCode
   *        An optional language code for the error messages. <code>null</code>
   *        means English. Supported language codes are: cs, de, en, fr, nl (see
   *        directory files schematron\20100414-xslt2\sch-messages-??.xhtml).
   * @param aValidator
   *        The validator to be used to determine whether a Schematron
   *        validation was successful or not. May not be <code>null</code>.
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourceSCH fromFile (@Nonnull final File aSCHFile,
                                                @Nullable final String sPhase,
                                                @Nullable final String sLanguageCode,
                                                @Nonnull final ISchematronXSLTValidator aValidator)
  {
    return new SchematronResourceSCH (new FileSystemResource (aSCHFile),
                                      (ErrorListener) null,
                                      (URIResolver) null,
                                      sPhase,
                                      sLanguageCode,
                                      aValidator);
  }

  /**
   * Create a new Schematron resource.
   *
   * @param aSCHFile
   *        The Schematron file. May not be <code>null</code>.
   * @param aCustomErrorListener
   *        An optional custom XSLT error listener that is used when converting
   *        the Schematron resource to an XSLT document, as well as for the
   *        application of the XSLT onto the XML to be validated. May be
   *        <code>null</code>.
   * @param aCustomURIResolver
   *        An optional custom XSLT URI resolver that is used when converting
   *        the Schematron resource to an XSLT document, as well as for the
   *        application of the XSLT onto the XML to be validated. May be
   *        <code>null</code>.
   * @param sPhase
   *        Optional phase to use. If not specified, the defaultPhase from the
   *        schema is used. If no default phase is specified, than all patterns
   *        are used
   * @param sLanguageCode
   *        An optional language code for the error messages. <code>null</code>
   *        means English. Supported language codes are: cs, de, en, fr, nl (see
   *        directory files schematron\20100414-xslt2\sch-messages-??.xhtml).
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourceSCH fromFile (@Nonnull final File aSCHFile,
                                                @Nullable final ErrorListener aCustomErrorListener,
                                                @Nullable final URIResolver aCustomURIResolver,
                                                @Nullable final String sPhase,
                                                @Nullable final String sLanguageCode)
  {
    return new SchematronResourceSCH (new FileSystemResource (aSCHFile),
                                      aCustomErrorListener,
                                      aCustomURIResolver,
                                      sPhase,
                                      sLanguageCode);
  }

  /**
   * Create a new Schematron resource.
   *
   * @param aSCHFile
   *        The Schematron file. May not be <code>null</code>.
   * @param aCustomErrorListener
   *        An optional custom XSLT error listener that is used when converting
   *        the Schematron resource to an XSLT document, as well as for the
   *        application of the XSLT onto the XML to be validated. May be
   *        <code>null</code>.
   * @param aCustomURIResolver
   *        An optional custom XSLT URI resolver that is used when converting
   *        the Schematron resource to an XSLT document, as well as for the
   *        application of the XSLT onto the XML to be validated. May be
   *        <code>null</code>.
   * @param sPhase
   *        Optional phase to use. If not specified, the defaultPhase from the
   *        schema is used. If no default phase is specified, than all patterns
   *        are used
   * @param sLanguageCode
   *        An optional language code for the error messages. <code>null</code>
   *        means English. Supported language codes are: cs, de, en, fr, nl (see
   *        directory files schematron\20100414-xslt2\sch-messages-??.xhtml).
   * @param aValidator
   *        The validator to be used to determine whether a Schematron
   *        validation was successful or not. May not be <code>null</code>.
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourceSCH fromFile (@Nonnull final File aSCHFile,
                                                @Nullable final ErrorListener aCustomErrorListener,
                                                @Nullable final URIResolver aCustomURIResolver,
                                                @Nullable final String sPhase,
                                                @Nullable final String sLanguageCode,
                                                @Nonnull final ISchematronXSLTValidator aValidator)
  {
    return new SchematronResourceSCH (new FileSystemResource (aSCHFile),
                                      aCustomErrorListener,
                                      aCustomURIResolver,
                                      sPhase,
                                      sLanguageCode,
                                      aValidator);
  }
}
