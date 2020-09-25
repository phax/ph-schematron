package com.helger.schematron.xslt;

import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.stream.StringInputStream;
import org.junit.Assert;
import org.junit.Test;
import org.w3c.dom.Document;

import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;

import static org.junit.Assert.assertNotNull;

public class SchematronResourceXSLTTest {
    private static final String VALID_XSLT_SCHEMATRON = "/test-xslt/valid01.xslt";
    private static final String VALID_XMLINSTANCE = "/test-xml/valid01.xml";

    @Test
    public void testFromUrl() throws Exception {
        final URL schUrl = getClass().getResource(VALID_XSLT_SCHEMATRON);
        final SchematronResourceXSLT sch = SchematronResourceXSLT.fromURL(schUrl);
        Assert.assertTrue("invalid schematron", sch.isValidSchematron());

        final Document aDoc = sch.applySchematronValidation(new ClassPathResource(VALID_XMLINSTANCE));
        assertNotNull(aDoc);
    }

    @Test
    public void testFromStringUrl() throws Exception {
        final URL schUrl = getClass().getResource(VALID_XSLT_SCHEMATRON);
        final SchematronResourceXSLT sch = SchematronResourceXSLT.fromURL(schUrl.toString());
        Assert.assertTrue("invalid schematron", sch.isValidSchematron());

        final Document aDoc = sch.applySchematronValidation(new ClassPathResource(VALID_XMLINSTANCE));
        assertNotNull(aDoc);
    }

    @Test
    public void testFromInputStream() throws Exception {
        final String schStr = loadSchString(VALID_XSLT_SCHEMATRON);
        final SchematronResourceXSLT sch = SchematronResourceXSLT.fromInputStream(new StringInputStream(schStr, StandardCharsets.UTF_8));
        Assert.assertTrue("invalid schematron", sch.isValidSchematron());

        final Document aDoc = sch.applySchematronValidation(new ClassPathResource(VALID_XMLINSTANCE));
        assertNotNull(aDoc);
    }

    @Test
    public void testFromByteArray() throws Exception {
        final String schStr = loadSchString(VALID_XSLT_SCHEMATRON);
        final byte[] ba = schStr.getBytes();
        final SchematronResourceXSLT sch = SchematronResourceXSLT.fromByteArray(ba);
        Assert.assertTrue("invalid schematron", sch.isValidSchematron());

        final Document aDoc = sch.applySchematronValidation(new ClassPathResource(VALID_XMLINSTANCE));
        assertNotNull(aDoc);
    }

    @Test
    public void testFromString() throws Exception {
        final String schStr = loadSchString(VALID_XSLT_SCHEMATRON);
        final SchematronResourceXSLT sch = SchematronResourceXSLT.fromString(schStr, StandardCharsets.UTF_8);
        Assert.assertTrue("invalid schematron", sch.isValidSchematron());

        final Document aDoc = sch.applySchematronValidation(new ClassPathResource(VALID_XMLINSTANCE));
        assertNotNull(aDoc);
    }

    private String loadSchString(final String path) throws Exception {
        return new String(Files.readAllBytes(new ClassPathResource(path).getAsFile().toPath()));
    }
}
