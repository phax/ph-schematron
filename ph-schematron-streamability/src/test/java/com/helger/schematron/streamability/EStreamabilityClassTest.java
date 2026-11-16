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
package com.helger.schematron.streamability;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertSame;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

/**
 * Test class for class {@link EStreamabilityClass}.
 *
 * @author Philip Helger
 */
public final class EStreamabilityClassTest
{
  @Test
  public void testBasic ()
  {
    for (final EStreamabilityClass e : EStreamabilityClass.values ())
    {
      assertSame (e, EStreamabilityClass.getFromIDOrNull (e.getID ()));
      assertFalse (e.isWorseThan (e));
      assertSame (e, e.getWorse (e));
    }
    assertNull (EStreamabilityClass.getFromIDOrNull ("bla"));
    assertNull (EStreamabilityClass.getFromIDOrNull (null));
    assertEquals ("non-local", EStreamabilityClass.NON_LOCAL.getID ());
  }

  @Test
  public void testOrder ()
  {
    assertTrue (EStreamabilityClass.BURST.isWorseThan (EStreamabilityClass.MOTIONLESS));
    assertTrue (EStreamabilityClass.NON_LOCAL.isWorseThan (EStreamabilityClass.BURST));
    assertFalse (EStreamabilityClass.MOTIONLESS.isWorseThan (EStreamabilityClass.NON_LOCAL));
    assertSame (EStreamabilityClass.BURST, EStreamabilityClass.MOTIONLESS.getWorse (EStreamabilityClass.BURST));
    assertSame (EStreamabilityClass.NON_LOCAL, EStreamabilityClass.NON_LOCAL.getWorse (EStreamabilityClass.BURST));
  }
}
