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
package com.helger.schematron.supplementary;

import static org.junit.Assert.assertFalse;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.commons.io.resource.IReadableResource;
import com.helger.schematron.pure.SchematronResourcePure;
import com.helger.schematron.pure.errorhandler.IPSErrorHandler;
import com.helger.schematron.pure.model.IPSElement;
import com.helger.xml.ls.SimpleLSResourceResolver;
import com.helger.xml.sax.InputSourceFactory;

/**
 * Test code for issue #30
 *
 * @author Philip Helger
 */
public final class Issue30Test
{
  private static final Logger s_aLogger = LoggerFactory.getLogger (Issue30Test.class);

  @Test
  public void testOfSchematronPH () throws Exception
  {
    final SchematronResourcePure aResPure = SchematronResourcePure.fromFile ("src/test/resources/issues/github30/ph-test.sch");
    aResPure.setEntityResolver ( (publicId, systemId) -> {
      final String sBaseURI = aResPure.getResource ().getAsURL ().toExternalForm ();
      final IReadableResource aResolvedRes = SimpleLSResourceResolver.doStandardResourceResolving (systemId, sBaseURI);
      if (aResolvedRes == null)
        return null;
      return InputSourceFactory.create (aResolvedRes);
    });
    final IPSErrorHandler aErrorHandler = new IPSErrorHandler ()
    {
      @Override
      public void warn (final IReadableResource aRes, final IPSElement aSourceElement, final String sMessage)
      {
        s_aLogger.info (sMessage);
      }

      @Override
      public void error (final IReadableResource aRes,
                         final IPSElement aSourceElement,
                         final String sMessage,
                         final Throwable t)
      {
        s_aLogger.info (sMessage);
      }

      @Override
      public void error (final IPSElement aSourceElement, final String sMessage)
      {
        s_aLogger.info (sMessage);
      }
    };
    aResPure.setErrorHandler (aErrorHandler);

    aResPure.validateCompletely ();
    assertFalse (aResPure.isValidSchematron ());
  }
}
