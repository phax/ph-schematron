/*
 * Copyright (C) 2014-2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.cli;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.io.File;

import org.junit.Test;

import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.schematron.cli.CliFileCollector.CliInputFile;

/**
 * Test class for class {@link CliFileCollector}.
 *
 * @author Philip Helger
 */
public final class CliFileCollectorTest
{
  @Test
  public void testMatches ()
  {
    assertTrue (CliFileCollector.matches ("a.xml", "**/*.xml"));
    assertTrue (CliFileCollector.matches ("dir/a.xml", "**/*.xml"));
    assertTrue (CliFileCollector.matches ("dir/sub/a.xml", "**/*.xml"));
    assertFalse (CliFileCollector.matches ("a.sch", "**/*.xml"));
    assertTrue (CliFileCollector.matches ("a.xml", "*.xml"));
    assertFalse (CliFileCollector.matches ("dir/a.xml", "*.xml"));
  }

  @Test
  public void testCollect ()
  {
    final File aDir = new File ("src/test/resources/external");
    ICommonsList <CliInputFile> aFiles = CliFileCollector.collect (new CommonsArrayList <> (aDir),
                                                                   new CommonsArrayList <> ("**/*.xml"),
                                                                   new CommonsArrayList <> ("catalog/**"));
    assertEquals (aFiles.toString (), 3, aFiles.size ());
    assertEquals ("levels/error.xml", aFiles.get (0).relativePath ());

    // A file argument is taken as is
    aFiles = CliFileCollector.collect (new CommonsArrayList <> (new File (aDir, "levels/levels.sch")),
                                       new CommonsArrayList <> ("**/*.xml"),
                                       null);
    assertEquals (1, aFiles.size ());
    assertEquals ("levels.sch", aFiles.get (0).relativePath ());
  }

  @Test (expected = IllegalArgumentException.class)
  public void testMissing ()
  {
    CliFileCollector.collect (new CommonsArrayList <> (new File ("does-not-exist")), new CommonsArrayList <> ("*"), null);
  }
}
