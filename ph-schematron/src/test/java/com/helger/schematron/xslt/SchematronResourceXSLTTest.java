package com.helger.schematron.xslt;

import static org.junit.Assert.assertNotNull;

import java.nio.charset.StandardCharsets;

import org.junit.Assert;
import org.junit.Test;
import org.w3c.dom.Document;

import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.stream.NonBlockingByteArrayInputStream;
import com.helger.commons.io.stream.StreamHelper;

/**
 * Test class for class {@link SchematronResourceXSLT}.
 *
 * @author Philip Helger
 */
public final class SchematronResourceXSLTTest
{
  private static final ClassPathResource VALID_XSLT_SCHEMATRON = new ClassPathResource ("/test-xslt/valid01.xslt");
  private static final ClassPathResource VALID_XMLINSTANCE = new ClassPathResource ("/test-xml/valid01.xml");

  @Test
  public void testFromUrl () throws Exception
  {
    final SchematronResourceXSLT sch = SchematronResourceXSLT.fromURL (VALID_XSLT_SCHEMATRON.getAsURL ());
    Assert.assertTrue ("invalid schematron", sch.isValidSchematron ());

    final Document aDoc = sch.applySchematronValidation (VALID_XMLINSTANCE);
    assertNotNull (aDoc);
  }

  @Test
  public void testFromStringUrl () throws Exception
  {
    final SchematronResourceXSLT sch = SchematronResourceXSLT.fromURL (VALID_XSLT_SCHEMATRON.getAsURL ().toExternalForm ());
    Assert.assertTrue ("invalid schematron", sch.isValidSchematron ());

    final Document aDoc = sch.applySchematronValidation (VALID_XMLINSTANCE);
    assertNotNull (aDoc);
  }

  @Test
  public void testFromInputStream () throws Exception
  {
    final byte [] aPayload = StreamHelper.getAllBytes (VALID_XSLT_SCHEMATRON);
    final SchematronResourceXSLT sch = SchematronResourceXSLT.fromInputStream (new NonBlockingByteArrayInputStream (aPayload));
    Assert.assertTrue ("invalid schematron", sch.isValidSchematron ());

    final Document aDoc = sch.applySchematronValidation (VALID_XMLINSTANCE);
    assertNotNull (aDoc);
  }

  @Test
  public void testFromByteArray () throws Exception
  {
    final byte [] aPayload = StreamHelper.getAllBytes (VALID_XSLT_SCHEMATRON);
    final SchematronResourceXSLT sch = SchematronResourceXSLT.fromByteArray (aPayload);
    Assert.assertTrue ("invalid schematron", sch.isValidSchematron ());

    final Document aDoc = sch.applySchematronValidation (VALID_XMLINSTANCE);
    assertNotNull (aDoc);
  }

  @Test
  public void testFromString () throws Exception
  {
    final byte [] aPayload = StreamHelper.getAllBytes (VALID_XSLT_SCHEMATRON);
    final SchematronResourceXSLT sch = SchematronResourceXSLT.fromString (new String (aPayload, StandardCharsets.UTF_8),
                                                                          StandardCharsets.UTF_8);
    Assert.assertTrue ("invalid schematron", sch.isValidSchematron ());

    final Document aDoc = sch.applySchematronValidation (VALID_XMLINSTANCE);
    assertNotNull (aDoc);
  }
}
