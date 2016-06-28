package com.helger.schematron.supplemantery;

import static org.junit.Assert.assertTrue;

import org.junit.Test;

import com.helger.commons.charset.CCharset;
import com.helger.commons.io.resource.inmemory.ReadableResourceString;
import com.helger.schematron.ISchematronResource;
import com.helger.schematron.xslt.SchematronResourceSCH;

/**
 * Test for StackOverflow
 * http://stackoverflow.com/questions/32784781/ph-schematron-namespace-prefix-error-after-compiling-schematron-to-xslt-using-p
 *
 * @author Philip Helger
 */
public final class SO32784781Test
{
  @Test
  public void testBasic ()
  {
    final String sSCH = "<schema xmlns=\"http://purl.oclc.org/dsdl/schematron\">\r\n" +
                        "  <ns prefix=\"m\" uri=\"http://www.ociweb.com/movies\"/>\r\n" +
                        "  <pattern name=\"all\">\r\n" +
                        "    <rule context=\"m:actor\">\r\n" +
                        "      <report test=\"@role=preceding-sibling::m:actor/@role\"\r\n" +
                        "          diagnostics=\"duplicateActorRole\">\r\n" +
                        "        Duplicate role!\r\n" +
                        "      </report>\r\n" +
                        "    </rule>\r\n" +
                        "  </pattern>\r\n" +
                        "  <diagnostics>\r\n" +
                        "    <diagnostic id=\"duplicateActorRole\">\r\n" +
                        "      More than one actor plays the role<value-of select=\"@role\"/>.\r\n" +
                        "      A duplicate is named<value-of select=\"@name\"/>.\r\n" +
                        "    </diagnostic>\r\n" +
                        "  </diagnostics>\r\n" +
                        "</schema>";
    final ISchematronResource isr = new SchematronResourceSCH (new ReadableResourceString (sSCH,
                                                                                           CCharset.CHARSET_UTF_8_OBJ));
    assertTrue (isr.isValidSchematron ());
  }
}
