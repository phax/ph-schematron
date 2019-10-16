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
