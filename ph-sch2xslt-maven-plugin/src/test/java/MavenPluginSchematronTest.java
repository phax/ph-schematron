import java.io.File;

import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.apache.maven.project.MavenProject;
import org.easymock.EasyMockRule;
import org.easymock.Mock;
import org.easymock.TestSubject;
import org.junit.Rule;
import org.junit.Test;
import org.sonatype.plexus.build.incremental.BuildContext;

import com.helger.maven.sch2xslt.Schematron2XSLTMojo;

import static org.easymock.EasyMock.*;

public class MavenPluginSchematronTest
{
  @Rule
  public EasyMockRule mocks = new EasyMockRule(this);

  @Mock
  private MavenProject project;

  @Mock
  private BuildContext buildContext;

  @TestSubject
  private Schematron2XSLTMojo OUT = new Schematron2XSLTMojo();

  @Test
  public void testMavenPlugin() throws MojoExecutionException,
      MojoFailureException
  {
    expect(project.getBasedir()).andReturn(new File(".")).anyTimes();

    replay(project);

    OUT.setSchematronDirectory(new File("src/test/schematron"));
    OUT.setSchematronPattern("**\\/*.sch");
    OUT.setXsltDirectory(new File("target/test/schematron-via-maven-plugin"));
    OUT.setXsltExtension(".xslt");
    OUT.execute();

    verify(project);
  }
}
