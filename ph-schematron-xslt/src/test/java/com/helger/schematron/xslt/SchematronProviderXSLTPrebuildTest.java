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
package com.helger.schematron.xslt;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertSame;
import static org.junit.Assert.assertTrue;

import org.junit.Test;
import org.w3c.dom.Document;

import com.helger.base.io.nonblocking.NonBlockingByteArrayInputStream;
import com.helger.base.io.stream.StreamHelper;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.inmemory.ReadableResourceInputStream;
import com.helger.schematron.api.xslt.SchematronXSLTValidator;
import com.helger.xml.transform.TransformSourceFactory;

/**
 * Test class for class {@link SchematronProviderXSLTPrebuild}.
 *
 * @author GT
 */
public final class SchematronProviderXSLTPrebuildTest
{
  private static final ClassPathResource VALID_XSLT_SCHEMATRON = new ClassPathResource ("external/test-xslt/valid01.xslt");
  private static final ClassPathResource VALID_XMLINSTANCE = new ClassPathResource ("external/test-xml/valid01.xml");

  @Test
  public void testXSLTDocumentIsReadOnDemand () throws Exception
  {
    final SchematronProviderXSLTPrebuild aProvider = new SchematronProviderXSLTPrebuild (VALID_XSLT_SCHEMATRON,
                                                                                         null,
                                                                                         null);
    assertTrue (aProvider.isValidSchematron ());
    assertNotNull (SchematronXSLTValidator.applyValidation (aProvider,
                                                            TransformSourceFactory.create (VALID_XMLINSTANCE),
                                                            null,
                                                            null,
                                                            null,
                                                            null));

    final Document aDoc = aProvider.getXSLTDocument ();
    assertNotNull (aDoc);
    assertEquals ("stylesheet", aDoc.getDocumentElement ().getLocalName ());
    assertSame (aDoc, aProvider.getXSLTDocument ());
  }

  @Test
  public void testReadOnceResource () throws Exception
  {
    // An input stream can only be read once, but is needed for compilation and getXSLTDocument
    final byte [] aPayload = StreamHelper.getAllBytes (VALID_XSLT_SCHEMATRON);
    final SchematronProviderXSLTPrebuild aProvider = new SchematronProviderXSLTPrebuild (new ReadableResourceInputStream ("mock-res-id",
                                                                                                                          new NonBlockingByteArrayInputStream (aPayload)),
                                                                                         null,
                                                                                         null);
    assertTrue (aProvider.isValidSchematron ());
    assertNotNull (aProvider.getXSLTDocument ());
  }

  @Test
  public void testMissingResource ()
  {
    final SchematronProviderXSLTPrebuild aProvider = new SchematronProviderXSLTPrebuild (new ClassPathResource ("external/test-xslt/does-not-exist.xslt"),
                                                                                         null,
                                                                                         null);
    assertFalse (aProvider.isValidSchematron ());
    assertNull (aProvider.getXSLTDocument ());
  }
}
