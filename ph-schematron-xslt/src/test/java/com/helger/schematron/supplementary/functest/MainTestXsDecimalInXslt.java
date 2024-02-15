package com.helger.schematron.supplementary.functest;

import java.io.File;

import javax.xml.transform.Templates;
import javax.xml.transform.TransformerFactory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.schematron.saxon.SchematronTransformerFactory;
import com.helger.xml.transform.StringStreamResult;
import com.helger.xml.transform.TransformSourceFactory;

public class MainTestXsDecimalInXslt
{
  private static final Logger LOGGER = LoggerFactory.getLogger (MainTestXsDecimalInXslt.class);

  public static void main (final String [] args) throws Exception
  {
    // compile result of read file
    final TransformerFactory aTF = SchematronTransformerFactory.getDefaultSaxonFirst ();
    final Templates aTemplates = aTF.newTemplates (TransformSourceFactory.create (new File ("src/test/resources/xslt/test.xslt")));
    final StringStreamResult ret = new StringStreamResult ();
    aTemplates.newTransformer ()
              .transform (TransformSourceFactory.create ("<root>" +
                                                         "<e1 />" +
                                                         "<e2>" +
                                                         "<existing-element>" +
                                                         "1.23" +
                                                         "</existing-element>" +
                                                         "</e2>" +
                                                         "<e3>" +
                                                         "<existing-element>" +
                                                         "2.78" +
                                                         "</existing-element>" +
                                                         "</e3>" +
                                                         "</root>"), ret);
    /**
     * Expected output:
     *
     * <pre>
    e1[][][]
    e2[1.23][1.23][6.23]
    e3[2.78][2.78] -- [][4.01] -- [2.78][4.01]
     * </pre>
     */

    LOGGER.info (ret.getAsString ());
  }
}
