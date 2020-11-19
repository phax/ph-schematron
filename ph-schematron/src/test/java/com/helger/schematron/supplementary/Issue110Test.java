package com.helger.schematron.supplementary;

import java.nio.file.Files;
import java.nio.file.Paths;

import org.junit.Test;

import com.helger.commons.io.resource.ClassPathResource;
import com.helger.schematron.ISchematronResource;
import com.helger.schematron.xslt.SchematronResourceSCH;

public final class Issue110Test
{
  @Test
  public void testIncludedFilesNotDeleted () throws Exception
  {
    final String sPath = "issues/github110/";
    final ISchematronResource aSV = SchematronResourceSCH.fromClassPath (sPath + "ATGOV-UBL-T10.sch");
    aSV.applySchematronValidation (new ClassPathResource (sPath + "test.xml"));
    Files.delete (Paths.get (new ClassPathResource (sPath + "include/ATGOV-T10-abstract.sch").getAsURL ().toURI ()));
    Files.delete (Paths.get (new ClassPathResource (sPath + "include/ATGOV-T10-abstract.sch").getAsURL ().toURI ()));
  }
}
