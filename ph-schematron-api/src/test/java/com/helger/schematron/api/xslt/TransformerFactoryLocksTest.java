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
package com.helger.schematron.api.xslt;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNotSame;
import static org.junit.Assert.assertSame;

import javax.xml.transform.TransformerFactory;

import org.junit.Test;

import com.helger.base.concurrent.SimpleLock;
import com.helger.xml.transform.XMLTransformerFactory;

/**
 * Test class for class {@link TransformerFactoryLocks}.
 *
 * @author Philip Helger
 */
public final class TransformerFactoryLocksTest
{
  @Test
  public void testGetLock ()
  {
    final TransformerFactory aTF1 = XMLTransformerFactory.createTransformerFactory (null, null);
    final TransformerFactory aTF2 = XMLTransformerFactory.createTransformerFactory (null, null);

    final SimpleLock aLock1 = TransformerFactoryLocks.getLock (aTF1);
    assertNotNull (aLock1);
    // Same factory, same lock
    assertSame (aLock1, TransformerFactoryLocks.getLock (aTF1));
    // Different factory, different lock
    assertNotSame (aLock1, TransformerFactoryLocks.getLock (aTF2));
  }
}
