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
package com.helger.schematron.supplementary;

import static org.junit.Assert.assertNotNull;

import java.io.File;

import org.jspecify.annotations.NonNull;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.io.resource.FileSystemResource;
import com.helger.schematron.sch.SchematronResourceSCH;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.xml.serialize.write.XMLWriter;

import net.sf.saxon.TransformerFactoryImpl;
import net.sf.saxon.s9api.ExtensionFunction;
import net.sf.saxon.s9api.ItemType;
import net.sf.saxon.s9api.OccurrenceIndicator;
import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.SequenceType;
import net.sf.saxon.s9api.XdmAtomicValue;
import net.sf.saxon.s9api.XdmValue;

public final class Issue129Test
{
  private static final Logger LOGGER = LoggerFactory.getLogger (Issue129Test.class);

  private static class EF_Test implements ExtensionFunction
  {
    @Override
    public QName getName ()
    {
      return new QName ("http://some.namespace.com", "test");
    }

    @Override
    public SequenceType getResultType ()
    {
      return SequenceType.makeSequenceType (ItemType.STRING, OccurrenceIndicator.ONE);
    }

    @Override
    public net.sf.saxon.s9api.SequenceType [] getArgumentTypes ()
    {
      return new SequenceType [] {};
    }

    @Override
    public XdmValue call (final XdmValue [] arguments) throws SaxonApiException
    {
      final String result = "Saxon is being extended correctly.";
      return new XdmAtomicValue (result);
    }
  }

  private static class EF_Mul3 implements ExtensionFunction
  {
    @Override
    public QName getName ()
    {
      return new QName ("http://some.namespace.com", "mul3");
    }

    @Override
    public SequenceType getResultType ()
    {
      return SequenceType.makeSequenceType (ItemType.INTEGER, OccurrenceIndicator.ONE);
    }

    @Override
    public net.sf.saxon.s9api.SequenceType [] getArgumentTypes ()
    {
      return new SequenceType [] { SequenceType.makeSequenceType (ItemType.INTEGER, OccurrenceIndicator.ONE) };
    }

    @Override
    public XdmValue call (final XdmValue [] arguments) throws SaxonApiException
    {
      final long nArg = ((XdmAtomicValue) arguments[0]).getLongValue ();
      return new XdmAtomicValue (nArg * 3);
    }
  }

  public static void validateAndProduceSVRL (@NonNull final File aSchematron, final File aXML) throws Exception
  {
    final SchematronResourceSCH aSCH = new SchematronResourceSCH (new FileSystemResource (aSchematron));
    // Register Saxon extension functions on the underlying Processor just before the validation
    // stylesheet is compiled, via the new transformerFactoryCustomizer hook.
    aSCH.setTransformerFactoryCustomizer (aTransformerFactory -> {
      if (aTransformerFactory instanceof TransformerFactoryImpl)
      {
        final net.sf.saxon.TransformerFactoryImpl aSaxonTF = (net.sf.saxon.TransformerFactoryImpl) aTransformerFactory;
        final net.sf.saxon.Configuration saxonConfig = aSaxonTF.getConfiguration ();
        final net.sf.saxon.s9api.Processor processor = (net.sf.saxon.s9api.Processor) saxonConfig.getProcessor ();
        processor.registerExtensionFunction (new EF_Test ());
        processor.registerExtensionFunction (new EF_Mul3 ());
      }
    });

    if (false)
      LOGGER.info (XMLWriter.getNodeAsString (aSCH.getXSLTProvider ().getXSLTDocument ()));

    // Perform validation
    final SchematronOutputType aSVRL = aSCH.applySchematronValidationToSVRL (new FileSystemResource (aXML));
    assertNotNull (aSVRL);
    if (true)
      LOGGER.info (new SVRLMarshaller ().getAsString (aSVRL));
  }

  @Test
  public void testIssue () throws Exception
  {
    validateAndProduceSVRL (new File ("src/test/resources/external/issues/github129/schematron.sch"),
                            new File ("src/test/resources/external/issues/github129/test.xml"));
  }
}
