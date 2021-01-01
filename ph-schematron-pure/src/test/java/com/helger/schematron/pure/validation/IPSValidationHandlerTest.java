/**
 * Copyright (C) 2014-2021 Philip Helger (www.helger.com)
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
package com.helger.schematron.pure.validation;

import static org.junit.Assert.assertNotSame;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertSame;

import org.junit.Test;

/**
 * Test class for class {@link IPSValidationHandler}.
 *
 * @author Philip Helger
 */
public final class IPSValidationHandlerTest
{
  @Test
  public void testAnd ()
  {
    final IPSValidationHandler x = new LoggingPSValidationHandler ();
    final IPSValidationHandler y = new LoggingPSValidationHandler ();
    assertNotSame (x, y);
    assertSame (x, x.and (null));
    assertSame (y, y.and (null));
    final IPSValidationHandler xy = x.and (y);
    assertNotSame (x, xy);
    assertNotSame (x, xy);
    assertNull (IPSValidationHandler.and (null, null));
    assertSame (x, IPSValidationHandler.and (x, null));
    assertSame (x, IPSValidationHandler.and (null, x));
    assertNotSame (x, IPSValidationHandler.and (x, x));
  }
}
