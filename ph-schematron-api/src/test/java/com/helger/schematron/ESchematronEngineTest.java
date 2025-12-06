package com.helger.schematron;

import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertSame;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

import com.helger.base.string.StringHelper;

/**
 * Test class for class {@link ESchematronEngine}.
 *
 * @author Philip Helger
 */
public final class ESchematronEngineTest
{
  @Test
  public void testBasic ()
  {
    for (final var e : ESchematronEngine.values ())
    {
      assertTrue (StringHelper.isNotEmpty (e.getID ()));
      assertSame (e, ESchematronEngine.getFromIDOrNull (e.getID ()));
    }
    // Additional ID
    assertSame (ESchematronEngine.ISO_SCHEMATRON, ESchematronEngine.getFromIDOrNull ("iso"));
    // Case sensitive
    assertNull (ESchematronEngine.getFromIDOrNull ("ISO"));
  }
}
