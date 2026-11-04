/*
 * Copyright (C) 2015-2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.model;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertSame;

import java.nio.charset.StandardCharsets;

import org.jspecify.annotations.NonNull;
import org.junit.Test;

import com.helger.base.state.EContinue;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.io.resource.inmemory.ReadableResourceByteArray;
import com.helger.schematron.exchange.PSReader;

/**
 * Test class for class {@link PSVoidVisitorWrapper}.
 *
 * @author Philip Helger
 */
public final class PSVoidVisitorWrapperTest
{
  @Test
  public void testBasic () throws Exception
  {
    final String sSchema = "<?xml version='1.0' encoding='UTF-8'?>\n" +
                           "<sch:schema xmlns:sch='http://purl.oclc.org/dsdl/schematron'>\n" +
                           "  <sch:pattern>\n" +
                           "    <sch:rule context='/root'>\n" +
                           "      <sch:assert test='true()'>Text</sch:assert>\n" +
                           "    </sch:rule>\n" +
                           "  </sch:pattern>\n" +
                           "</sch:schema>";
    final PSReader aReader = new PSReader (new ReadableResourceByteArray (sSchema.getBytes (StandardCharsets.UTF_8)));
    final PSSchema aSchema = aReader.readSchema ();
    assertNotNull (aSchema);

    final ICommonsList <String> aEvents = new CommonsArrayList <> ();
    final IPSVoidVisitor aVoidVisitor = new IPSVoidVisitor ()
    {
      @Override
      public void onRuleStart (@NonNull final PSRule aRule)
      {
        aEvents.add ("RuleStart");
      }

      @Override
      public void onTextContent (@NonNull final IPSElement aParent, @NonNull final String sText)
      {
        aEvents.add (sText);
      }
    };
    final PSVoidVisitorWrapper aWrapper = new PSVoidVisitorWrapper (aVoidVisitor);
    assertSame (aVoidVisitor, aWrapper.getWrappedVisitor ());

    // The wrapper never stops the walk
    assertEquals (EContinue.CONTINUE, PSVisitor.visit (aSchema, aWrapper));
    assertEquals (new CommonsArrayList <> ("RuleStart", "Text"), aEvents);
  }
}
