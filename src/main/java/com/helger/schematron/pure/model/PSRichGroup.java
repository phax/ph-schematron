/**
 * Copyright (C) 2014-2015 Philip Helger (www.helger.com)
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
package com.helger.schematron.pure.model;

import java.io.Serializable;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.NotThreadSafe;
import javax.xml.XMLConstants;

import com.helger.commons.annotation.Nonempty;
import com.helger.commons.id.IHasID;
import com.helger.commons.lang.EnumHelper;
import com.helger.commons.lang.ICloneable;
import com.helger.commons.microdom.IMicroElement;
import com.helger.commons.string.ToStringGenerator;
import com.helger.schematron.CSchematronXML;

/**
 * A single "rich" group
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class PSRichGroup implements ICloneable <PSRichGroup>, Serializable
{
  public static enum ESpace implements IHasID <String>
  {
    PRESERVE ("preserve"),
    DEFAULT ("default");

    private final String m_sID;

    private ESpace (@Nonnull @Nonempty final String sID)
    {
      m_sID = sID;
    }

    @Nonnull
    @Nonempty
    public String getID ()
    {
      return m_sID;
    }

    @Nullable
    public static ESpace getFromIDOrNull (@Nullable final String sID)
    {
      return EnumHelper.getFromIDOrNull (ESpace.class, sID);
    }
  }

  private String m_sIcon;
  private String m_sSee;
  private String m_sFPI;
  private String m_sXmlLang;
  private ESpace m_eXmlSpace;

  public PSRichGroup ()
  {}

  public void setIcon (@Nullable final String sIcon)
  {
    m_sIcon = sIcon;
  }

  /**
   * The location of a graphics file containing some visible representation of
   * the severity, significance or other grouping of the associated element.<br>
   * An implementation is not required to make use of this attribute.
   *
   * @return The icon value
   */
  @Nullable
  public String getIcon ()
  {
    return m_sIcon;
  }

  public void setSee (@Nullable final String sSee)
  {
    m_sSee = sSee;
  }

  /**
   * The URI of external information of interest to maintainers and users of the
   * schema.<br>
   * An implementation is not required to make use of this attribute.
   *
   * @return The see value
   */
  @Nullable
  public String getSee ()
  {
    return m_sSee;
  }

  public void setFPI (@Nullable final String sFPI)
  {
    m_sFPI = sFPI;
  }

  /**
   * A formal public identifier for the schema, phase or other element.<br>
   * An implementation is not required to make use of this attribute.
   *
   * @return The FPI value
   */
  @Nullable
  public String getFPI ()
  {
    return m_sFPI;
  }

  public void setXmlLang (@Nullable final String sXmlLang)
  {
    m_sXmlLang = sXmlLang;
  }

  @Nullable
  public String getXmlLang ()
  {
    return m_sXmlLang;
  }

  public void setXmlSpace (@Nullable final ESpace eXmlSpace)
  {
    m_eXmlSpace = eXmlSpace;
  }

  @Nullable
  public ESpace getXmlSpace ()
  {
    return m_eXmlSpace;
  }

  public static boolean isRichAttribute (@Nullable final String sAttrName)
  {
    return CSchematronXML.ATTR_ICON.equals (sAttrName) ||
           CSchematronXML.ATTR_SEE.equals (sAttrName) ||
           CSchematronXML.ATTR_FPI.equals (sAttrName) ||
           CSchematronXML.ATTR_XML_LANG.equals (sAttrName) ||
           CSchematronXML.ATTR_XML_SPACE.equals (sAttrName);
  }

  public void fillMicroElement (@Nonnull final IMicroElement aElement)
  {
    aElement.setAttribute (CSchematronXML.ATTR_ICON, m_sIcon);
    aElement.setAttribute (CSchematronXML.ATTR_SEE, m_sSee);
    aElement.setAttribute (CSchematronXML.ATTR_FPI, m_sFPI);
    aElement.setAttribute (XMLConstants.XML_NS_URI, CSchematronXML.ATTR_XML_LANG, m_sXmlLang);
    if (m_eXmlSpace != null)
      aElement.setAttribute (XMLConstants.XML_NS_URI, CSchematronXML.ATTR_XML_SPACE, m_eXmlSpace.getID ());
  }

  @Nonnull
  public PSRichGroup getClone ()
  {
    final PSRichGroup ret = new PSRichGroup ();
    ret.setIcon (m_sIcon);
    ret.setSee (m_sSee);
    ret.setFPI (m_sFPI);
    ret.setXmlLang (m_sXmlLang);
    ret.setXmlSpace (m_eXmlSpace);
    return ret;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).appendIfNotNull ("icon", m_sIcon)
                                       .appendIfNotNull ("see", m_sSee)
                                       .appendIfNotNull ("fpi", m_sFPI)
                                       .appendIfNotNull ("xml:lang", m_sXmlLang)
                                       .appendIfNotNull ("xml:space", m_eXmlSpace)
                                       .toString ();
  }
}
