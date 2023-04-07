package com.helger.schematron.svrl;

import static org.junit.Assert.assertTrue;

import org.junit.Test;

import com.helger.commons.io.resource.ClassPathResource;

/**
 * Test class for class {@link CSVRL}.
 *
 * @author Philip Helger
 */
public class CSVRLTest
{
  @Test
  public void testBasic ()
  {
    for (final ClassPathResource aRes : CSVRL.SVRL_XSDS)
    {
      assertTrue ("Not found: " + aRes.getPath (), aRes.exists ());
    }
  }
}
