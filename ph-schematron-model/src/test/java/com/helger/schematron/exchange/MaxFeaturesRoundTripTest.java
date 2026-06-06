/*
 * Copyright (C) 2015-2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.exchange;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.util.Locale;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.junit.Test;

import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.diagnostics.error.IError;
import com.helger.diagnostics.error.level.EErrorLevel;
import com.helger.io.resource.ClassPathResource;
import com.helger.schematron.ESchematronVersion;
import com.helger.schematron.errorhandler.IPSErrorHandler;
import com.helger.schematron.model.PSGroup;
import com.helger.schematron.model.PSLibrary;
import com.helger.schematron.model.PSSchema;
import com.helger.schematron.model.PSVersionChecker;

/**
 * Round-trip + version-checker matrix over the four mock schemas <code>max-2006.sch</code>,
 * <code>max-2016.sch</code>, <code>max-2020.sch</code>, <code>max-2025.sch</code>. Each mock uses
 * the maximum features permitted by the corresponding RNC plus a simple foreign element.
 * <p>
 * The cross-version assertions reuse the model: every mock is parsed once, then re-checked under
 * every declared <code>schematronEdition</code>. The expectation is:
 * <ul>
 * <li>declared edition &ge; the schema's own edition &rarr; zero warnings,</li>
 * <li>declared edition &lt; the schema's own edition &rarr; at least one warning (the version
 * checker correctly flags the misused feature).</li>
 * </ul>
 *
 * @author Philip Helger
 */
public final class MaxFeaturesRoundTripTest
{
  private static final ESchematronVersion [] ALL = ESchematronVersion.values ();

  private static final String [] MOCKS = { "external/test-sch/versions/max-2006.sch",
                                           "external/test-sch/versions/max-2016.sch",
                                           "external/test-sch/versions/max-2020.sch",
                                           "external/test-sch/versions/max-2025.sch" };

  /**
   * The intrinsic edition of each mock - the version in which its features were first introduced.
   */
  private static final ESchematronVersion [] MOCK_EDITION = { ESchematronVersion.SCHEMATRON_2006,
                                                              ESchematronVersion.SCHEMATRON_2016,
                                                              ESchematronVersion.SCHEMATRON_2020,
                                                              ESchematronVersion.SCHEMATRON_2025 };

  /**
   * Capturing error handler so tests can assert exactly which warnings the version checker emits.
   */
  private static final class CollectingErrorHandler implements IPSErrorHandler
  {
    private final ICommonsList <IError> m_aErrors = new CommonsArrayList <> ();

    public void handleError (@NonNull final IError aError)
    {
      m_aErrors.add (aError);
    }

    @NonNull
    public ICommonsList <IError> getAllErrors ()
    {
      return m_aErrors.getClone ();
    }

    @NonNull
    public String dump ()
    {
      final StringBuilder aSB = new StringBuilder ();
      for (final IError aError : m_aErrors)
      {
        aSB.append ("  - ").append (aError.getErrorText ((Locale) null)).append ('\n');
      }
      return aSB.toString ();
    }

    public int countWarnings ()
    {
      int n = 0;
      for (final IError aError : m_aErrors)
        if (aError.getErrorLevel ().isEQ (EErrorLevel.WARN))
          n++;
      return n;
    }
  }

  @NonNull
  private static PSSchema _read (@NonNull final String sPath) throws SchematronReadException
  {
    final ClassPathResource aResource = new ClassPathResource (sPath);
    assertTrue ("Mock " + sPath + " must exist on the classpath", aResource.exists ());
    // Use a non-capturing handler so the read itself doesn't pollute the assertions.
    final CollectingErrorHandler aNoise = new CollectingErrorHandler ();
    final PSReader aReader = new PSReader (aResource, aNoise, null);
    return aReader.readSchema ();
  }

  /**
   * Force the schema to declare a specific edition (independently of any value the source XML may
   * have carried). Tests use this to drive the cross-version matrix.
   */
  private static void _setDeclaredEdition (@NonNull final PSSchema aSchema, @Nullable final ESchematronVersion eEdition)
  {
    aSchema.setSchematronEdition (eEdition);
  }

  // ------------------------------------------------------------------------------------------
  // Read / parse smoke tests - every mock must parse cleanly.
  // ------------------------------------------------------------------------------------------

  @Test
  public void test2006Reads () throws SchematronReadException
  {
    final PSSchema aSchema = _read (MOCKS[0]);
    assertNotNull (aSchema);
    assertTrue ("2006 mock should have foreign elements (ext:metadata)", aSchema.hasForeignElements ());
    assertTrue ("2006 mock has at least one pattern", aSchema.hasPatterns ());
  }

  @Test
  public void test2016Reads () throws SchematronReadException
  {
    final PSSchema aSchema = _read (MOCKS[1]);
    assertNotNull (aSchema);
    assertTrue ("2016 mock declares properties", aSchema.hasProperties ());
  }

  @Test
  public void test2020Reads () throws SchematronReadException
  {
    final PSSchema aSchema = _read (MOCKS[2]);
    assertNotNull (aSchema);
    assertNotNull ("2020 mock has diagnostic with @role", aSchema.getDiagnostics ());
  }

  @Test
  public void test2025Reads () throws SchematronReadException
  {
    final PSSchema aSchema = _read (MOCKS[3]);
    assertNotNull (aSchema);
    assertTrue ("2025 mock declares schematronEdition=2025",
                aSchema.getSchematronEdition () == ESchematronVersion.SCHEMATRON_2025);
    assertTrue ("2025 mock has top-level <extends>", aSchema.hasAnyExtends ());
    assertTrue ("2025 mock has top-level <param>", aSchema.hasAnyParam ());
    assertTrue ("2025 mock has a <group>", aSchema.hasAnyGroup ());
    assertTrue ("2025 mock has a <rules> container", aSchema.hasAnyAbstractRulesContainer ());
    // sanity-check that the group carries the new @role
    final PSGroup aGroup = aSchema.getAllGroups ().getFirstOrNull ();
    assertNotNull (aGroup);
    assertNotNull ("group @role round-trips", aGroup.getRole ());
  }

  // ------------------------------------------------------------------------------------------
  // Write smoke tests - every mock must serialise back to XML.
  // ------------------------------------------------------------------------------------------

  @Test
  public void testAllMocksWriteRoundTrip () throws SchematronReadException
  {
    final PSWriter aWriter = new PSWriter ();
    final CollectingErrorHandler aHandler = new CollectingErrorHandler ();
    aWriter.setErrorHandler (aHandler);
    for (final String sPath : MOCKS)
    {
      final PSSchema aSchema = _read (sPath);
      final String sXml = aWriter.getXMLString (aSchema);
      assertNotNull ("Serialisation of " + sPath + " must succeed", sXml);
      assertTrue ("Output of " + sPath + " must contain <schema>", sXml.contains ("schema"));
    }
  }

  // ------------------------------------------------------------------------------------------
  // <library> mock - 2025-only root element
  // ------------------------------------------------------------------------------------------

  /**
   * The 2025 mock declares <code>&lt;sch:extends href=&quot;library-2025.xml#libContent&quot;/&gt;</code>
   * at the schema top level; this test exercises the library document itself through
   * {@link PSReader#readLibrary()} and {@link PSWriter}.
   */
  @Test
  public void testLibraryReadAndWrite () throws SchematronReadException
  {
    final String sPath = "external/test-sch/versions/library-2025.sch";
    final ClassPathResource aResource = new ClassPathResource (sPath);
    assertTrue (sPath + " must exist on the classpath", aResource.exists ());
    final CollectingErrorHandler aNoise = new CollectingErrorHandler ();
    final PSLibrary aLibrary = new PSReader (aResource, aNoise, null).readLibrary ();
    assertNotNull (aLibrary);
    // smoke-check that the v4 library content model survived the round-trip
    assertTrue ("library has abstract-rules", !aLibrary.getAllAbstractRulesContainers ().isEmpty ());
    assertTrue ("library has patterns", !aLibrary.getAllPatterns ().isEmpty ());
    assertTrue ("library has groups", !aLibrary.getAllGroups ().isEmpty ());
    assertTrue ("library has params", !aLibrary.getAllParams ().isEmpty ());
    assertTrue ("library has lets", !aLibrary.getAllLets ().isEmpty ());
    assertNotNull ("library has diagnostics", aLibrary.getDiagnostics ());
    assertNotNull ("library has properties", aLibrary.getProperties ());
    // round-trip through PSWriter
    final String sXml = new PSWriter ().getXMLString (aLibrary);
    assertNotNull ("Library serialisation must succeed", sXml);
    assertTrue ("Library output must contain <library>", sXml.contains ("library"));
    assertTrue ("Library output must contain the abstract-rules id", sXml.contains ("libRules"));
  }

  // ------------------------------------------------------------------------------------------
  // Cross-version matrix - the version checker must flag mis-used features.
  // ------------------------------------------------------------------------------------------

  /**
   * For each mock, set every possible declared edition and check that the version checker either
   * stays silent (declared &ge; mock edition) or emits warnings (declared &lt; mock edition).
   */
  @Test
  public void testCrossVersionMatrix () throws SchematronReadException
  {
    for (int i = 0; i < MOCKS.length; i++)
    {
      final String sPath = MOCKS[i];
      final ESchematronVersion eMockEdition = MOCK_EDITION[i];
      for (final ESchematronVersion eDeclared : ALL)
      {
        final PSSchema aSchema = _read (sPath);
        _setDeclaredEdition (aSchema, eDeclared);

        final CollectingErrorHandler aHandler = new CollectingErrorHandler ();
        PSVersionChecker.checkSchematronVersionCompliance (aSchema, aHandler);

        final int nWarnings = aHandler.countWarnings ();
        if (eDeclared.isOlderThan (eMockEdition))
        {
          // The mock uses features newer than the declared edition - we must see at least one
          // warning from the version checker.
          assertTrue (sPath +
                      " under declared " +
                      eDeclared.getEditionYear () +
                      " (mock edition " +
                      eMockEdition.getEditionYear () +
                      ") - expected at least one warning, got " +
                      nWarnings +
                      ":\n" +
                      aHandler.dump (),
                      nWarnings >= 1);
        }
        else
        {
          // declared >= mock edition: nothing should be flagged
          assertFalse (sPath +
                       " under declared " +
                       eDeclared.getEditionYear () +
                       " (mock edition " +
                       eMockEdition.getEditionYear () +
                       ") - expected zero warnings, got " +
                       nWarnings +
                       ":\n" +
                       aHandler.dump (),
                       nWarnings > 0);
        }
      }
    }
  }
}
