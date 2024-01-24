/*
 * Copyright (C) 2014-2024 Philip Helger (www.helger.com)
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
package com.helger.schematron.relaxng;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.ThreadSafe;
import javax.xml.XMLConstants;
import javax.xml.validation.SchemaFactory;

import org.w3c.dom.ls.LSResourceResolver;
import org.xml.sax.ErrorHandler;

import com.helger.commons.annotation.Singleton;
import com.helger.commons.system.SystemProperties;
import com.helger.xml.ls.SimpleLSResourceResolver;
import com.helger.xml.sax.LoggingSAXErrorHandler;
import com.helger.xml.schema.SchemaCache;

/**
 * This class is used to cache Relax NG Compact schema objects.
 *
 * @author Philip Helger
 */
@ThreadSafe
@Singleton
public class RelaxNGCompactSchemaCache extends SchemaCache
{
  static
  {
    // Ensure to use the JING RelaxNG Compact factory
    SystemProperties.setPropertyValue ("javax.xml.validation.SchemaFactory:" + XMLConstants.RELAXNG_NS_URI,
                                       com.thaiopensource.relaxng.jaxp.CompactSyntaxSchemaFactory.class.getName ());
  }

  private static final class SingletonHolder
  {
    static final RelaxNGCompactSchemaCache INSTANCE = new RelaxNGCompactSchemaCache ();
  }

  private static boolean s_bDefaultInstantiated = false;

  public RelaxNGCompactSchemaCache ()
  {
    this (new LoggingSAXErrorHandler (), new SimpleLSResourceResolver ());
  }

  public RelaxNGCompactSchemaCache (@Nullable final ErrorHandler aErrorHandler)
  {
    this (aErrorHandler, null);
  }

  public RelaxNGCompactSchemaCache (@Nullable final LSResourceResolver aResourceResolver)
  {
    this (null, aResourceResolver);
  }

  public RelaxNGCompactSchemaCache (@Nullable final ErrorHandler aErrorHandler, @Nullable final LSResourceResolver aResourceResolver)
  {
    super ("RelaxNGCompact", SchemaFactory.newInstance (XMLConstants.RELAXNG_NS_URI), aErrorHandler, aResourceResolver);
  }

  /**
   * @return <code>true</code> if the default singleton is already instantiated,
   *         <code>false</code> if not.
   */
  public static boolean isInstantiated ()
  {
    return s_bDefaultInstantiated;
  }

  /**
   * @return The default cache object. Never <code>null</code>.
   */
  @Nonnull
  public static RelaxNGCompactSchemaCache getInstance ()
  {
    final RelaxNGCompactSchemaCache ret = SingletonHolder.INSTANCE;
    s_bDefaultInstantiated = true;
    return ret;
  }
}
