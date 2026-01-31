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
package com.helger.schematron.config;

import org.jspecify.annotations.Nullable;

import com.helger.annotation.style.IsSPIImplementation;
import com.helger.base.thirdparty.ELicense;
import com.helger.base.thirdparty.IThirdPartyModule;
import com.helger.base.thirdparty.IThirdPartyModuleProviderSPI;
import com.helger.base.thirdparty.ThirdPartyModule;
import com.helger.base.version.Version;

/**
 * Implement this SPI interface if your JAR file contains external third party modules.
 *
 * @author Philip Helger
 */
@IsSPIImplementation
public final class ThirdPartyModuleProvider_ph_schematron implements IThirdPartyModuleProviderSPI
{
  public static final IThirdPartyModule SAXON_HE = new ThirdPartyModule ("Saxon HE",
                                                                         "Saxonica Limited",
                                                                         ELicense.MPL20,
                                                                         new Version (12, 9, 0, "HE"),
                                                                         "http://saxon.sourceforge.net/");

  @Nullable
  public IThirdPartyModule [] getAllThirdPartyModules ()
  {
    return new IThirdPartyModule [] { SAXON_HE };
  }
}
