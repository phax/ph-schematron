/**
 * Copyright (C) 2014 Philip Helger (www.helger.com)
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
package com.helger.schematron.pure.exchange;

import java.util.Map;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.io.IReadableResource;
import com.helger.commons.microdom.IMicroDocument;
import com.helger.commons.microdom.IMicroElement;
import com.helger.commons.microdom.IMicroNode;
import com.helger.commons.microdom.IMicroText;
import com.helger.commons.string.StringParser;
import com.helger.commons.string.ToStringGenerator;
import com.helger.schematron.CSchematron;
import com.helger.schematron.CSchematronXML;
import com.helger.schematron.SchematronHelper;
import com.helger.schematron.pure.errorhandler.IPSErrorHandler;
import com.helger.schematron.pure.errorhandler.LoggingPSErrorHandler;
import com.helger.schematron.pure.model.IPSElement;
import com.helger.schematron.pure.model.PSActive;
import com.helger.schematron.pure.model.PSAssertReport;
import com.helger.schematron.pure.model.PSDiagnostic;
import com.helger.schematron.pure.model.PSDiagnostics;
import com.helger.schematron.pure.model.PSDir;
import com.helger.schematron.pure.model.PSDir.EDirValue;
import com.helger.schematron.pure.model.PSEmph;
import com.helger.schematron.pure.model.PSExtends;
import com.helger.schematron.pure.model.PSInclude;
import com.helger.schematron.pure.model.PSLet;
import com.helger.schematron.pure.model.PSLinkableGroup;
import com.helger.schematron.pure.model.PSNS;
import com.helger.schematron.pure.model.PSName;
import com.helger.schematron.pure.model.PSP;
import com.helger.schematron.pure.model.PSParam;
import com.helger.schematron.pure.model.PSPattern;
import com.helger.schematron.pure.model.PSPhase;
import com.helger.schematron.pure.model.PSRichGroup;
import com.helger.schematron.pure.model.PSRichGroup.ESpace;
import com.helger.schematron.pure.model.PSRule;
import com.helger.schematron.pure.model.PSSchema;
import com.helger.schematron.pure.model.PSSpan;
import com.helger.schematron.pure.model.PSTitle;
import com.helger.schematron.pure.model.PSValueOf;

/**
 * Utility class for reading all Schematron elements from a resource.
 *
 * @author Philip Helger
 */
@Immutable
public class PSReader
{
  private final IReadableResource m_aResource;
  private final IPSErrorHandler m_aErrorHandler;

  /**
   * Constructor without an error handler
   *
   * @param aResource
   *        The resource to read the Schematron from. May not be
   *        <code>null</code>.
   */
  public PSReader (@Nonnull final IReadableResource aResource)
  {
    this (aResource, null);
  }

  /**
   * Constructor with an error handler
   *
   * @param aResource
   *        The resource to read the Schematron from. May not be
   *        <code>null</code>.
   * @param aErrorHandler
   *        The error handler to use. May be <code>null</code>. If the error
   *        handler is <code>null</code> a {@link LoggingPSErrorHandler} is
   *        automatically created and used.
   */
  public PSReader (@Nonnull final IReadableResource aResource, @Nullable final IPSErrorHandler aErrorHandler)
  {
    ValueEnforcer.notNull (aResource, "Resource");
    m_aResource = aResource;
    m_aErrorHandler = aErrorHandler != null ? aErrorHandler : new LoggingPSErrorHandler ();
  }

  /**
   * @return The resource from which the Schematron schema is read. Never
   *         <code>null</code>.
   */
  @Nonnull
  public IReadableResource getResource ()
  {
    return m_aResource;
  }

  /**
   * @return The error handler used. If no error handler was passed in the
   *         constructor, than a {@link LoggingPSErrorHandler} is automatically
   *         used.
   */
  @Nonnull
  public IPSErrorHandler getErrorHandler ()
  {
    return m_aErrorHandler;
  }

  /**
   * Utility method to get a real attribute value, by trimming spaces, if the
   * value is non-<code>null</code>.
   *
   * @param sAttrValue
   *        The source attribute value. May be <code>null</code>.
   * @return <code>null</code> if the input parameter is <code>null</code>.
   */
  @Nullable
  private static String _getAttributeValue (@Nullable final String sAttrValue)
  {
    return sAttrValue == null ? null : sAttrValue.trim ();
  }

  /**
   * Emit a warning with the registered error handler.
   *
   * @param aSourceElement
   *        The source element where the error occurred.
   * @param sMessage
   *        The main warning message.
   */
  private void _warn (@Nonnull final IPSElement aSourceElement, @Nonnull final String sMessage)
  {
    ValueEnforcer.notNull (aSourceElement, "SourceElement");
    ValueEnforcer.notNull (sMessage, "Message");

    m_aErrorHandler.warn (m_aResource, aSourceElement, sMessage);
  }

  /**
   * Read an &lt;active&gt; element
   *
   * @param eActive
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @Nonnull
  public PSActive readActiveFromXML (@Nonnull final IMicroElement eActive)
  {
    final PSActive ret = new PSActive ();
    final Map <String, String> aAttrs = eActive.getAllAttributes ();
    if (aAttrs != null)
      for (final Map.Entry <String, String> aEntry : aAttrs.entrySet ())
      {
        final String sAttrName = aEntry.getKey ();
        final String sAttrValue = _getAttributeValue (aEntry.getValue ());
        if (sAttrName.equals (CSchematronXML.ATTR_PATTERN))
          ret.setPattern (sAttrValue);
        else
          ret.addForeignAttribute (sAttrName, sAttrValue);
      }

    if (eActive.hasChildren ())
      for (final IMicroNode aActiveChild : eActive.getAllChildren ())
        switch (aActiveChild.getType ())
        {
          case TEXT:
            ret.addText (((IMicroText) aActiveChild).getNodeValue ());
            break;
          case ELEMENT:
            final IMicroElement eElement = (IMicroElement) aActiveChild;
            if (CSchematron.NAMESPACE_SCHEMATRON.equals (eElement.getNamespaceURI ()))
            {
              final String sLocalName = eElement.getLocalName ();
              if (sLocalName.equals (CSchematronXML.ELEMENT_DIR))
                ret.addDir (readDirFromXML (eElement));
              else
                if (sLocalName.equals (CSchematronXML.ELEMENT_EMPH))
                  ret.addEmph (readEmphFromXML (eElement));
                else
                  if (sLocalName.equals (CSchematronXML.ELEMENT_SPAN))
                    ret.addSpan (readSpanFromXML (eElement));
                  else
                    _warn (ret, "Unsupported Schematron element '" + sLocalName + "'");
            }
            else
              ret.addForeignElement (eElement.getClone ());

            break;
          case COMMENT:
            // Ignore comments
            break;
          default:
            _warn (ret, "Unsupported child node: " + aActiveChild);
        }
    return ret;
  }

  /**
   * Read an &lt;assert&gt; or a &lt;report&gt; element
   *
   * @param eAssertReport
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @Nonnull
  public PSAssertReport readAssertReportFromXML (@Nonnull final IMicroElement eAssertReport)
  {
    final PSAssertReport ret = new PSAssertReport (eAssertReport.getLocalName ().equals (CSchematronXML.ELEMENT_ASSERT));
    final Map <String, String> aAttrs = eAssertReport.getAllAttributes ();
    if (aAttrs != null)
    {
      for (final Map.Entry <String, String> aEntry : aAttrs.entrySet ())
      {
        final String sAttrName = aEntry.getKey ();
        final String sAttrValue = _getAttributeValue (aEntry.getValue ());
        if (sAttrName.equals (CSchematronXML.ATTR_TEST))
          ret.setTest (sAttrValue);
        else
          if (sAttrName.equals (CSchematronXML.ATTR_FLAG))
            ret.setFlag (sAttrValue);
          else
            if (sAttrName.equals (CSchematronXML.ATTR_ID))
              ret.setID (sAttrValue);
            else
              if (sAttrName.equals (CSchematronXML.ATTR_DIAGNOSTICS))
                ret.setDiagnostics (sAttrValue);
              else
                if (!PSRichGroup.isRichAttribute (sAttrName) && !PSLinkableGroup.isLinkableAttribute (sAttrName))
                  ret.addForeignAttribute (sAttrName, sAttrValue);
      }
      ret.setRich (readRichGroupFromXML (aAttrs));
      ret.setLinkable (readLinkableGroupFromXML (aAttrs));
    }

    if (eAssertReport.hasChildren ())
      for (final IMicroNode aAssertReportChild : eAssertReport.getAllChildren ())
        switch (aAssertReportChild.getType ())
        {
          case TEXT:
            ret.addText (((IMicroText) aAssertReportChild).getNodeValue ());
            break;
          case ELEMENT:
            final IMicroElement eElement = (IMicroElement) aAssertReportChild;
            if (CSchematron.NAMESPACE_SCHEMATRON.equals (eElement.getNamespaceURI ()))
            {
              final String sLocalName = eElement.getLocalName ();
              if (sLocalName.equals (CSchematronXML.ELEMENT_NAME))
                ret.addName (readNameFromXML (eElement));
              else
                if (sLocalName.equals (CSchematronXML.ELEMENT_VALUE_OF))
                  ret.addValueOf (readValueOfFromXML (eElement));
                else
                  if (sLocalName.equals (CSchematronXML.ELEMENT_EMPH))
                    ret.addEmph (readEmphFromXML (eElement));
                  else
                    if (sLocalName.equals (CSchematronXML.ELEMENT_DIR))
                      ret.addDir (readDirFromXML (eElement));
                    else
                      if (sLocalName.equals (CSchematronXML.ELEMENT_SPAN))
                        ret.addSpan (readSpanFromXML (eElement));
                      else
                        _warn (ret, "Unsupported Schematron element '" + sLocalName + "'");
            }
            else
              ret.addForeignElement (eElement.getClone ());

            break;
          case COMMENT:
            // Ignore comments
            break;
          default:
            _warn (ret, "Unsupported child node: " + aAssertReportChild);
        }
    return ret;
  }

  /**
   * Read a &lt;diagnostic&gt; element
   *
   * @param eDiagnostic
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @Nonnull
  public PSDiagnostic readDiagnosticFromXML (@Nonnull final IMicroElement eDiagnostic)
  {
    final PSDiagnostic ret = new PSDiagnostic ();
    final Map <String, String> aAttrs = eDiagnostic.getAllAttributes ();
    if (aAttrs != null)
    {
      for (final Map.Entry <String, String> aEntry : aAttrs.entrySet ())
      {
        final String sAttrName = aEntry.getKey ();
        final String sAttrValue = _getAttributeValue (aEntry.getValue ());
        if (sAttrName.equals (CSchematronXML.ATTR_ID))
          ret.setID (sAttrValue);
        else
          if (!PSRichGroup.isRichAttribute (sAttrName))
            ret.addForeignAttribute (sAttrName, sAttrValue);
      }
      ret.setRich (readRichGroupFromXML (aAttrs));
    }

    if (eDiagnostic.hasChildren ())
      for (final IMicroNode aDiagnosticChild : eDiagnostic.getAllChildren ())
        switch (aDiagnosticChild.getType ())
        {
          case TEXT:
            ret.addText (((IMicroText) aDiagnosticChild).getNodeValue ());
            break;
          case ELEMENT:
            final IMicroElement eElement = (IMicroElement) aDiagnosticChild;
            if (CSchematron.NAMESPACE_SCHEMATRON.equals (eElement.getNamespaceURI ()))
            {
              final String sLocalName = eElement.getLocalName ();
              if (sLocalName.equals (CSchematronXML.ELEMENT_VALUE_OF))
                ret.addValueOf (readValueOfFromXML (eElement));
              else
                if (sLocalName.equals (CSchematronXML.ELEMENT_EMPH))
                  ret.addEmph (readEmphFromXML (eElement));
                else
                  if (sLocalName.equals (CSchematronXML.ELEMENT_DIR))
                    ret.addDir (readDirFromXML (eElement));
                  else
                    if (sLocalName.equals (CSchematronXML.ELEMENT_SPAN))
                      ret.addSpan (readSpanFromXML (eElement));
                    else
                      _warn (ret, "Unsupported Schematron element '" + sLocalName + "'");
            }
            else
              ret.addForeignElement (eElement.getClone ());

            break;
          case COMMENT:
            // Ignore comments
            break;
          default:
            _warn (ret, "Unsupported child node: " + aDiagnosticChild);
        }
    return ret;
  }

  /**
   * Read a &lt;diagnostics&gt; element
   *
   * @param eDiagnostics
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @Nonnull
  public PSDiagnostics readDiagnosticsFromXML (@Nonnull final IMicroElement eDiagnostics)
  {
    final PSDiagnostics ret = new PSDiagnostics ();

    final Map <String, String> aAttrs = eDiagnostics.getAllAttributes ();
    if (aAttrs != null)
      for (final Map.Entry <String, String> aEntry : aAttrs.entrySet ())
      {
        final String sAttrName = aEntry.getKey ();
        final String sAttrValue = _getAttributeValue (aEntry.getValue ());
        ret.addForeignAttribute (sAttrName, sAttrValue);
      }

    for (final IMicroElement eDiagnosticsChild : eDiagnostics.getAllChildElements ())
    {
      if (CSchematron.NAMESPACE_SCHEMATRON.equals (eDiagnosticsChild.getNamespaceURI ()))
      {
        if (eDiagnosticsChild.getLocalName ().equals (CSchematronXML.ELEMENT_INCLUDE))
          ret.addInclude (readIncludeFromXML (eDiagnosticsChild));
        else
          if (eDiagnosticsChild.getLocalName ().equals (CSchematronXML.ELEMENT_DIAGNOSTIC))
            ret.addDiagnostic (readDiagnosticFromXML (eDiagnosticsChild));
          else
            _warn (ret, "Unsupported Schematron element '" + eDiagnosticsChild.getLocalName () + "'");
      }
      else
        ret.addForeignElement (eDiagnosticsChild.getClone ());
    }
    return ret;
  }

  /**
   * Read a &lt;dir&gt; element
   *
   * @param eDir
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @Nonnull
  public PSDir readDirFromXML (@Nonnull final IMicroElement eDir)
  {
    final PSDir ret = new PSDir ();
    final Map <String, String> aAttrs = eDir.getAllAttributes ();
    if (aAttrs != null)
      for (final Map.Entry <String, String> aEntry : aAttrs.entrySet ())
      {
        final String sAttrName = aEntry.getKey ();
        final String sAttrValue = _getAttributeValue (aEntry.getValue ());
        if (sAttrName.equals (CSchematronXML.ATTR_VALUE))
          ret.setValue (EDirValue.getFromIDOrNull (sAttrValue));
        else
          ret.addForeignAttribute (sAttrName, sAttrValue);
      }

    if (eDir.hasChildren ())
      for (final IMicroNode aDirChild : eDir.getAllChildren ())
        switch (aDirChild.getType ())
        {
          case TEXT:
            ret.addText (((IMicroText) aDirChild).getNodeValue ());
            break;
          case ELEMENT:
            final IMicroElement eElement = (IMicroElement) aDirChild;
            if (CSchematron.NAMESPACE_SCHEMATRON.equals (eElement.getNamespaceURI ()))
            {
              _warn (ret, "Unsupported Schematron element '" + eElement.getLocalName () + "'");
            }
            else
              ret.addForeignElement (eElement.getClone ());

            break;
          case COMMENT:
            // Ignore comments
            break;
          default:
            _warn (ret, "Unsupported child node: " + aDirChild);
        }
    return ret;
  }

  /**
   * Read an &lt;emph&gt; element
   *
   * @param eEmph
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @Nonnull
  public PSEmph readEmphFromXML (@Nonnull final IMicroElement eEmph)
  {
    final PSEmph ret = new PSEmph ();
    final Map <String, String> aAttrs = eEmph.getAllAttributes ();
    if (aAttrs != null)
      for (final Map.Entry <String, String> aEntry : aAttrs.entrySet ())
      {
        final String sAttrName = aEntry.getKey ();
        final String sAttrValue = _getAttributeValue (aEntry.getValue ());
        _warn (ret, "Unsupported attribute '" + sAttrName + "'='" + sAttrValue + "'");
      }

    if (eEmph.hasChildren ())
      for (final IMicroNode aEmphChild : eEmph.getAllChildren ())
        switch (aEmphChild.getType ())
        {
          case TEXT:
            ret.addText (((IMicroText) aEmphChild).getNodeValue ());
            break;
          case ELEMENT:
            final IMicroElement eElement = (IMicroElement) aEmphChild;
            if (CSchematron.NAMESPACE_SCHEMATRON.equals (eElement.getNamespaceURI ()))
            {
              _warn (ret, "Unsupported Schematron element '" + eElement.getLocalName () + "'");
            }
            else
              _warn (ret, "Unsupported namespace URI '" + eElement.getNamespaceURI () + "'");

            break;
          case COMMENT:
            // Ignore comments
            break;
          default:
            _warn (ret, "Unsupported child node: " + aEmphChild);
        }
    return ret;
  }

  /**
   * Read an &lt;extends&gt; element
   *
   * @param eExtends
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @Nonnull
  public PSExtends readExtendsFromXML (@Nonnull final IMicroElement eExtends)
  {
    final PSExtends ret = new PSExtends ();
    final Map <String, String> aAttrs = eExtends.getAllAttributes ();
    if (aAttrs != null)
      for (final Map.Entry <String, String> aEntry : aAttrs.entrySet ())
      {
        final String sAttrName = aEntry.getKey ();
        final String sAttrValue = _getAttributeValue (aEntry.getValue ());
        if (sAttrName.equals (CSchematronXML.ATTR_RULE))
          ret.setRule (sAttrValue);
        else
          ret.addForeignAttribute (sAttrName, sAttrValue);
      }

    for (final IMicroElement eChild : eExtends.getAllChildElements ())
    {
      if (CSchematron.NAMESPACE_SCHEMATRON.equals (eChild.getNamespaceURI ()))
      {
        _warn (ret, "Unsupported Schematron element '" + eChild.getLocalName () + "'");
      }
      else
        _warn (ret, "Unsupported namespace URI '" + eChild.getNamespaceURI () + "'");
    }
    return ret;
  }

  /**
   * Read an &lt;include&gt; element
   *
   * @param eInclude
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @Nonnull
  public PSInclude readIncludeFromXML (@Nonnull final IMicroElement eInclude)
  {
    final PSInclude ret = new PSInclude ();
    final Map <String, String> aAttrs = eInclude.getAllAttributes ();
    if (aAttrs != null)
      for (final Map.Entry <String, String> aEntry : aAttrs.entrySet ())
      {
        final String sAttrName = aEntry.getKey ();
        final String sAttrValue = _getAttributeValue (aEntry.getValue ());
        if (sAttrName.equals (CSchematronXML.ATTR_HREF))
          ret.setHref (sAttrValue);
        else
          _warn (ret, "Unsupported attribute '" + sAttrName + "'='" + sAttrValue + "'");
      }

    for (final IMicroElement eValueOfChild : eInclude.getAllChildElements ())
    {
      if (CSchematron.NAMESPACE_SCHEMATRON.equals (eValueOfChild.getNamespaceURI ()))
      {
        _warn (ret, "Unsupported Schematron element '" + eValueOfChild.getLocalName () + "'");
      }
      else
        _warn (ret, "Unsupported namespace URI '" + eValueOfChild.getNamespaceURI () + "'");
    }
    return ret;
  }

  /**
   * Read a &lt;let&gt; element
   *
   * @param eLet
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @Nonnull
  public PSLet readLetFromXML (@Nonnull final IMicroElement eLet)
  {
    final PSLet ret = new PSLet ();
    final Map <String, String> aAttrs = eLet.getAllAttributes ();
    if (aAttrs != null)
      for (final Map.Entry <String, String> aEntry : aAttrs.entrySet ())
      {
        final String sAttrName = aEntry.getKey ();
        final String sAttrValue = _getAttributeValue (aEntry.getValue ());
        if (sAttrName.equals (CSchematronXML.ATTR_NAME))
          ret.setName (sAttrValue);
        else
          if (sAttrName.equals (CSchematronXML.ATTR_VALUE))
            ret.setValue (sAttrValue);
          else
            _warn (ret, "Unsupported attribute '" + sAttrName + "'='" + sAttrValue + "'");
      }

    for (final IMicroElement eLetChild : eLet.getAllChildElements ())
    {
      if (CSchematron.NAMESPACE_SCHEMATRON.equals (eLetChild.getNamespaceURI ()))
      {
        _warn (ret, "Unsupported Schematron element '" + eLetChild.getLocalName () + "'");
      }
      else
        _warn (ret, "Unsupported namespace URI '" + eLetChild.getNamespaceURI () + "'");
    }
    return ret;
  }

  /**
   * Read all attributes for a linkable group
   *
   * @param aAttrs
   *        The attributes of a micro element. May be <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @Nonnull
  public PSLinkableGroup readLinkableGroupFromXML (@Nullable final Map <String, String> aAttrs)
  {
    final PSLinkableGroup ret = new PSLinkableGroup ();
    if (aAttrs != null)
      for (final Map.Entry <String, String> aEntry : aAttrs.entrySet ())
      {
        final String sAttrName = aEntry.getKey ();
        final String sAttrValue = _getAttributeValue (aEntry.getValue ());
        if (sAttrName.equals (CSchematronXML.ATTR_ROLE))
          ret.setRole (sAttrValue);
        else
          if (sAttrName.equals (CSchematronXML.ATTR_SUBJECT))
            ret.setSubject (sAttrValue);
      }
    return ret;
  }

  /**
   * Read a &lt;name&gt; element
   *
   * @param eName
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @Nonnull
  public PSName readNameFromXML (@Nonnull final IMicroElement eName)
  {
    final PSName ret = new PSName ();
    final Map <String, String> aAttrs = eName.getAllAttributes ();
    if (aAttrs != null)
      for (final Map.Entry <String, String> aEntry : aAttrs.entrySet ())
      {
        final String sAttrName = aEntry.getKey ();
        final String sAttrValue = _getAttributeValue (aEntry.getValue ());
        if (sAttrName.equals (CSchematronXML.ATTR_PATH))
          ret.setPath (sAttrValue);
        else
          ret.addForeignAttribute (sAttrName, sAttrValue);
      }

    for (final IMicroElement eNameChild : eName.getAllChildElements ())
    {
      if (CSchematron.NAMESPACE_SCHEMATRON.equals (eNameChild.getNamespaceURI ()))
      {
        _warn (ret, "Unsupported Schematron element '" + eNameChild.getLocalName () + "'");
      }
      else
        _warn (ret, "Unsupported namespace URI '" + eNameChild.getNamespaceURI () + "'");
    }
    return ret;
  }

  /**
   * Read a &lt;ns&gt; element
   *
   * @param eNS
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @Nonnull
  public PSNS readNSFromXML (@Nonnull final IMicroElement eNS)
  {
    final PSNS ret = new PSNS ();
    final Map <String, String> aAttrs = eNS.getAllAttributes ();
    if (aAttrs != null)
      for (final Map.Entry <String, String> aEntry : aAttrs.entrySet ())
      {
        final String sAttrName = aEntry.getKey ();
        final String sAttrValue = _getAttributeValue (aEntry.getValue ());
        if (sAttrName.equals (CSchematronXML.ATTR_URI))
          ret.setUri (sAttrValue);
        else
          if (sAttrName.equals (CSchematronXML.ATTR_PREFIX))
            ret.setPrefix (sAttrValue);
          else
            ret.addForeignAttribute (sAttrName, sAttrValue);
      }

    for (final IMicroElement eLetChild : eNS.getAllChildElements ())
    {
      if (CSchematron.NAMESPACE_SCHEMATRON.equals (eLetChild.getNamespaceURI ()))
      {
        _warn (ret, "Unsupported Schematron element '" + eLetChild.getLocalName () + "'");
      }
      else
        _warn (ret, "Unsupported namespace URI '" + eLetChild.getNamespaceURI () + "'");
    }
    return ret;
  }

  /**
   * Read a &lt;p&gt; element
   *
   * @param eP
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @Nonnull
  public PSP readPFromXML (@Nonnull final IMicroElement eP)
  {
    final PSP ret = new PSP ();
    final Map <String, String> aAttrs = eP.getAllAttributes ();
    if (aAttrs != null)
      for (final Map.Entry <String, String> aEntry : aAttrs.entrySet ())
      {
        final String sAttrName = aEntry.getKey ();
        final String sAttrValue = _getAttributeValue (aEntry.getValue ());
        if (sAttrName.equals (CSchematronXML.ATTR_ID))
          ret.setID (sAttrValue);
        else
          if (sAttrName.equals (CSchematronXML.ATTR_CLASS))
            ret.setClazz (sAttrValue);
          else
            if (sAttrName.equals (CSchematronXML.ATTR_ICON))
              ret.setIcon (sAttrValue);
            else
              ret.addForeignAttribute (sAttrName, sAttrValue);
      }

    if (eP.hasChildren ())
      for (final IMicroNode aChild : eP.getAllChildren ())
        switch (aChild.getType ())
        {
          case TEXT:
            ret.addText (((IMicroText) aChild).getNodeValue ());
            break;
          case ELEMENT:
            final IMicroElement eElement = (IMicroElement) aChild;
            if (CSchematron.NAMESPACE_SCHEMATRON.equals (eElement.getNamespaceURI ()))
            {
              final String sLocalName = eElement.getLocalName ();
              if (sLocalName.equals (CSchematronXML.ELEMENT_DIR))
                ret.addDir (readDirFromXML (eElement));
              else
                if (sLocalName.equals (CSchematronXML.ELEMENT_EMPH))
                  ret.addEmph (readEmphFromXML (eElement));
                else
                  if (sLocalName.equals (CSchematronXML.ELEMENT_SPAN))
                    ret.addSpan (readSpanFromXML (eElement));
                  else
                    _warn (ret, "Unsupported Schematron element '" + sLocalName + "'");
            }
            else
              ret.addForeignElement (eElement.getClone ());

            break;
          case COMMENT:
            // Ignore comments
            break;
          default:
            _warn (ret, "Unsupported child node: " + aChild);
        }
    return ret;
  }

  /**
   * Read a &lt;param&gt; element
   *
   * @param eParam
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @Nonnull
  public PSParam readParamFromXML (@Nonnull final IMicroElement eParam)
  {
    final PSParam ret = new PSParam ();
    final Map <String, String> aAttrs = eParam.getAllAttributes ();
    if (aAttrs != null)
      for (final Map.Entry <String, String> aEntry : aAttrs.entrySet ())
      {
        final String sAttrName = aEntry.getKey ();
        final String sAttrValue = _getAttributeValue (aEntry.getValue ());
        if (sAttrName.equals (CSchematronXML.ATTR_NAME))
          ret.setName (sAttrValue);
        else
          if (sAttrName.equals (CSchematronXML.ATTR_VALUE))
            ret.setValue (sAttrValue);
          else
            _warn (ret, "Unsupported attribute '" + sAttrName + "'='" + sAttrValue + "'");
      }

    for (final IMicroElement eParamChild : eParam.getAllChildElements ())
    {
      if (CSchematron.NAMESPACE_SCHEMATRON.equals (eParamChild.getNamespaceURI ()))
      {
        _warn (ret, "Unsupported Schematron element '" + eParamChild.getLocalName () + "'");
      }
      else
        _warn (ret, "Unsupported namespace URI '" + eParamChild.getNamespaceURI () + "'");
    }
    return ret;
  }

  /**
   * Read a &lt;pattern&gt; element
   *
   * @param ePattern
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @Nonnull
  public PSPattern readPatternFromXML (@Nonnull final IMicroElement ePattern)
  {
    final PSPattern ret = new PSPattern ();
    final Map <String, String> aAttrs = ePattern.getAllAttributes ();
    if (aAttrs != null)
    {
      for (final Map.Entry <String, String> aEntry : aAttrs.entrySet ())
      {
        final String sAttrName = aEntry.getKey ();
        final String sAttrValue = _getAttributeValue (aEntry.getValue ());
        if (sAttrName.equals (CSchematronXML.ATTR_ABSTRACT))
          ret.setAbstract (StringParser.parseBool (sAttrValue));
        else
          if (sAttrName.equals (CSchematronXML.ATTR_ID))
            ret.setID (sAttrValue);
          else
            if (sAttrName.equals (CSchematronXML.ATTR_IS_A))
              ret.setIsA (sAttrValue);
            else
              if (!PSRichGroup.isRichAttribute (sAttrName))
                ret.addForeignAttribute (sAttrName, sAttrValue);
      }
      ret.setRich (readRichGroupFromXML (aAttrs));
    }

    for (final IMicroElement ePatternChild : ePattern.getAllChildElements ())
    {
      if (CSchematron.NAMESPACE_SCHEMATRON.equals (ePatternChild.getNamespaceURI ()))
      {
        if (ePatternChild.getLocalName ().equals (CSchematronXML.ELEMENT_INCLUDE))
          ret.addInclude (readIncludeFromXML (ePatternChild));
        else
          if (ePatternChild.getLocalName ().equals (CSchematronXML.ELEMENT_TITLE))
            ret.setTitle (readTitleFromXML (ePatternChild));
          else
            if (ePatternChild.getLocalName ().equals (CSchematronXML.ELEMENT_P))
              ret.addP (readPFromXML (ePatternChild));
            else
              if (ePatternChild.getLocalName ().equals (CSchematronXML.ELEMENT_LET))
                ret.addLet (readLetFromXML (ePatternChild));
              else
                if (ePatternChild.getLocalName ().equals (CSchematronXML.ELEMENT_RULE))
                  ret.addRule (readRuleFromXML (ePatternChild));
                else
                  if (ePatternChild.getLocalName ().equals (CSchematronXML.ELEMENT_PARAM))
                    ret.addParam (readParamFromXML (ePatternChild));
                  else
                    _warn (ret,
                           "Unsupported Schematron element '" +
                               ePatternChild.getLocalName () +
                               "' in " +
                               ret.toString ());
      }
      else
        ret.addForeignElement (ePatternChild.getClone ());
    }
    return ret;
  }

  /**
   * Read a &lt;phase&gt; element
   *
   * @param ePhase
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @Nonnull
  public PSPhase readPhaseFromXML (@Nonnull final IMicroElement ePhase)
  {
    final PSPhase ret = new PSPhase ();
    final Map <String, String> aAttrs = ePhase.getAllAttributes ();
    if (aAttrs != null)
    {
      for (final Map.Entry <String, String> aEntry : aAttrs.entrySet ())
      {
        final String sAttrName = aEntry.getKey ();
        final String sAttrValue = _getAttributeValue (aEntry.getValue ());
        if (sAttrName.equals (CSchematronXML.ATTR_ID))
          ret.setID (sAttrValue);
        else
          if (!PSRichGroup.isRichAttribute (sAttrName))
            ret.addForeignAttribute (sAttrName, sAttrValue);
      }
      ret.setRich (readRichGroupFromXML (aAttrs));
    }

    for (final IMicroElement ePhaseChild : ePhase.getAllChildElements ())
    {
      if (CSchematron.NAMESPACE_SCHEMATRON.equals (ePhaseChild.getNamespaceURI ()))
      {
        if (ePhaseChild.getLocalName ().equals (CSchematronXML.ELEMENT_INCLUDE))
          ret.addInclude (readIncludeFromXML (ePhaseChild));
        else
          if (ePhaseChild.getLocalName ().equals (CSchematronXML.ELEMENT_P))
            ret.addP (readPFromXML (ePhaseChild));
          else
            if (ePhaseChild.getLocalName ().equals (CSchematronXML.ELEMENT_LET))
              ret.addLet (readLetFromXML (ePhaseChild));
            else
              if (ePhaseChild.getLocalName ().equals (CSchematronXML.ELEMENT_ACTIVE))
                ret.addActive (readActiveFromXML (ePhaseChild));
              else
                _warn (ret, "Unsupported Schematron element '" + ePhaseChild.getLocalName () + "'");
      }
      else
        ret.addForeignElement (ePhaseChild.getClone ());
    }
    return ret;
  }

  /**
   * Read all attributes that make up a rich group
   *
   * @param aAttrs
   *        The attributes of a micro element. May be <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @Nonnull
  public PSRichGroup readRichGroupFromXML (@Nullable final Map <String, String> aAttrs)
  {
    final PSRichGroup ret = new PSRichGroup ();
    if (aAttrs != null)
      for (final Map.Entry <String, String> aEntry : aAttrs.entrySet ())
      {
        final String sAttrName = aEntry.getKey ();
        final String sAttrValue = _getAttributeValue (aEntry.getValue ());
        if (sAttrName.equals (CSchematronXML.ATTR_ICON))
          ret.setIcon (sAttrValue);
        else
          if (sAttrName.equals (CSchematronXML.ATTR_SEE))
            ret.setSee (sAttrValue);
          else
            if (sAttrName.equals (CSchematronXML.ATTR_FPI))
              ret.setFPI (sAttrValue);
            else
              if (sAttrName.equals (CSchematronXML.ATTR_XML_LANG))
                ret.setXmlLang (sAttrValue);
              else
                if (sAttrName.equals (CSchematronXML.ATTR_XML_SPACE))
                  ret.setXmlSpace (ESpace.getFromIDOrNull (sAttrValue));

      }
    return ret;
  }

  /**
   * Read a &lt;rule&gt; element
   *
   * @param eRule
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @Nonnull
  public PSRule readRuleFromXML (@Nonnull final IMicroElement eRule)
  {
    final PSRule ret = new PSRule ();
    final Map <String, String> aAttrs = eRule.getAllAttributes ();
    if (aAttrs != null)
    {
      for (final Map.Entry <String, String> aEntry : aAttrs.entrySet ())
      {
        final String sAttrName = aEntry.getKey ();
        final String sAttrValue = _getAttributeValue (aEntry.getValue ());
        if (sAttrName.equals (CSchematronXML.ATTR_FLAG))
          ret.setFlag (sAttrValue);
        else
          if (sAttrName.equals (CSchematronXML.ATTR_ABSTRACT))
            ret.setAbstract (StringParser.parseBool (sAttrValue));
          else
            if (sAttrName.equals (CSchematronXML.ATTR_CONTEXT))
              ret.setContext (sAttrValue);
            else
              if (sAttrName.equals (CSchematronXML.ATTR_ID))
                ret.setID (sAttrValue);
              else
                if (!PSRichGroup.isRichAttribute (sAttrName) && !PSLinkableGroup.isLinkableAttribute (sAttrName))
                  ret.addForeignAttribute (sAttrName, sAttrValue);
      }
      ret.setRich (readRichGroupFromXML (aAttrs));
      ret.setLinkable (readLinkableGroupFromXML (aAttrs));
    }

    for (final IMicroElement eRuleChild : eRule.getAllChildElements ())
    {
      if (CSchematron.NAMESPACE_SCHEMATRON.equals (eRuleChild.getNamespaceURI ()))
      {
        if (eRuleChild.getLocalName ().equals (CSchematronXML.ELEMENT_INCLUDE))
          ret.addInclude (readIncludeFromXML (eRuleChild));
        else
          if (eRuleChild.getLocalName ().equals (CSchematronXML.ELEMENT_LET))
            ret.addLet (readLetFromXML (eRuleChild));
          else
            if (eRuleChild.getLocalName ().equals (CSchematronXML.ELEMENT_ASSERT) ||
                eRuleChild.getLocalName ().equals (CSchematronXML.ELEMENT_REPORT))
              ret.addAssertReport (readAssertReportFromXML (eRuleChild));
            else
              if (eRuleChild.getLocalName ().equals (CSchematronXML.ELEMENT_EXTENDS))
                ret.addExtends (readExtendsFromXML (eRuleChild));
              else
                _warn (ret, "Unsupported Schematron element '" + eRuleChild.getLocalName () + "'");
      }
      else
        ret.addForeignElement (eRuleChild.getClone ());
    }
    return ret;
  }

  /**
   * Parse the Schematron into a pure Java object. This method makes no
   * assumptions on the validity of the document!
   *
   * @param eSchema
   *        The XML element to use. May not be <code>null</code>.
   * @return The created {@link PSSchema} object or <code>null</code> in case of
   *         <code>null</code> document or a fatal error.
   * @throws SchematronReadException
   *         If reading fails
   */
  @Nonnull
  public PSSchema readSchemaFromXML (@Nonnull final IMicroElement eSchema) throws SchematronReadException
  {
    ValueEnforcer.notNull (eSchema, "Schema");
    if (!CSchematron.NAMESPACE_SCHEMATRON.equals (eSchema.getNamespaceURI ()))
      throw new SchematronReadException (m_aResource, "The passed element is not an ISO Schematron element!");

    final PSSchema ret = new PSSchema (m_aResource);
    final Map <String, String> aAttrs = eSchema.getAllAttributes ();
    if (aAttrs != null)
    {
      for (final Map.Entry <String, String> aEntry : aAttrs.entrySet ())
      {
        final String sAttrName = aEntry.getKey ();
        final String sAttrValue = _getAttributeValue (aEntry.getValue ());
        if (sAttrName.equals (CSchematronXML.ATTR_ID))
          ret.setID (sAttrValue);
        else
          if (sAttrName.equals (CSchematronXML.ATTR_SCHEMA_VERSION))
            ret.setSchemaVersion (sAttrValue);
          else
            if (sAttrName.equals (CSchematronXML.ATTR_DEFAULT_PHASE))
              ret.setDefaultPhase (sAttrValue);
            else
              if (sAttrName.equals (CSchematronXML.ATTR_QUERY_BINDING))
                ret.setQueryBinding (sAttrValue);
              else
                if (!PSRichGroup.isRichAttribute (sAttrName))
                  ret.addForeignAttribute (sAttrName, sAttrValue);
      }
      ret.setRich (readRichGroupFromXML (aAttrs));
    }

    for (final IMicroElement eSchemaChild : eSchema.getAllChildElements ())
    {
      if (CSchematron.NAMESPACE_SCHEMATRON.equals (eSchemaChild.getNamespaceURI ()))
      {
        if (eSchemaChild.getLocalName ().equals (CSchematronXML.ELEMENT_INCLUDE))
          ret.addInclude (readIncludeFromXML (eSchemaChild));
        else
          if (eSchemaChild.getLocalName ().equals (CSchematronXML.ELEMENT_TITLE))
            ret.setTitle (readTitleFromXML (eSchemaChild));
          else
            if (eSchemaChild.getLocalName ().equals (CSchematronXML.ELEMENT_NS))
              ret.addNS (readNSFromXML (eSchemaChild));
            else
              if (eSchemaChild.getLocalName ().equals (CSchematronXML.ELEMENT_P))
              {
                final PSP aP = readPFromXML (eSchemaChild);
                if (ret.hasNoPatterns ())
                  ret.addStartP (aP);
                else
                  ret.addEndP (aP);
              }
              else
                if (eSchemaChild.getLocalName ().equals (CSchematronXML.ELEMENT_LET))
                  ret.addLet (readLetFromXML (eSchemaChild));
                else
                  if (eSchemaChild.getLocalName ().equals (CSchematronXML.ELEMENT_PHASE))
                    ret.addPhase (readPhaseFromXML (eSchemaChild));
                  else
                    if (eSchemaChild.getLocalName ().equals (CSchematronXML.ELEMENT_PATTERN))
                      ret.addPattern (readPatternFromXML (eSchemaChild));
                    else
                      if (eSchemaChild.getLocalName ().equals (CSchematronXML.ELEMENT_DIAGNOSTICS))
                        ret.setDiagnostics (readDiagnosticsFromXML (eSchemaChild));
                      else
                        _warn (ret, "Unsupported Schematron element '" + eSchemaChild.getLocalName () + "'");
      }
      else
        ret.addForeignElement (eSchemaChild.getClone ());
    }
    return ret;
  }

  /**
   * Read a &lt;span&gt; element
   *
   * @param eSpan
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @Nonnull
  public PSSpan readSpanFromXML (@Nonnull final IMicroElement eSpan)
  {
    final PSSpan ret = new PSSpan ();
    final Map <String, String> aAttrs = eSpan.getAllAttributes ();
    if (aAttrs != null)
      for (final Map.Entry <String, String> aEntry : aAttrs.entrySet ())
      {
        final String sAttrName = aEntry.getKey ();
        final String sAttrValue = _getAttributeValue (aEntry.getValue ());
        if (sAttrName.equals (CSchematronXML.ATTR_CLASS))
          ret.setClazz (sAttrValue);
        else
          ret.addForeignAttribute (sAttrName, sAttrValue);
      }

    if (eSpan.hasChildren ())
      for (final IMicroNode aSpanChild : eSpan.getAllChildren ())
        switch (aSpanChild.getType ())
        {
          case TEXT:
            ret.addText (((IMicroText) aSpanChild).getNodeValue ());
            break;
          case ELEMENT:
            final IMicroElement eElement = (IMicroElement) aSpanChild;
            if (CSchematron.NAMESPACE_SCHEMATRON.equals (eElement.getNamespaceURI ()))
            {
              _warn (ret, "Unsupported Schematron element '" + eElement.getLocalName () + "'");
            }
            else
              ret.addForeignElement (eElement.getClone ());

            break;
          case COMMENT:
            // Ignore comments
            break;
          default:
            _warn (ret, "Unsupported child node: " + aSpanChild);
        }
    return ret;
  }

  /**
   * Read a &lt;title&gt; element
   *
   * @param eTitle
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @Nonnull
  public PSTitle readTitleFromXML (@Nonnull final IMicroElement eTitle)
  {
    final PSTitle ret = new PSTitle ();
    final Map <String, String> aAttrs = eTitle.getAllAttributes ();
    if (aAttrs != null)
      for (final Map.Entry <String, String> aEntry : aAttrs.entrySet ())
      {
        final String sAttrName = aEntry.getKey ();
        final String sAttrValue = _getAttributeValue (aEntry.getValue ());
        _warn (ret, "Unsupported attribute '" + sAttrName + "'='" + sAttrValue + "'");
      }

    if (eTitle.hasChildren ())
      for (final IMicroNode aTitleChild : eTitle.getAllChildren ())
        switch (aTitleChild.getType ())
        {
          case TEXT:
            ret.addText (((IMicroText) aTitleChild).getNodeValue ());
            break;
          case ELEMENT:
            final IMicroElement eElement = (IMicroElement) aTitleChild;
            if (CSchematron.NAMESPACE_SCHEMATRON.equals (eElement.getNamespaceURI ()))
            {
              final String sLocalName = eElement.getLocalName ();
              if (sLocalName.equals (CSchematronXML.ELEMENT_DIR))
                ret.addDir (readDirFromXML (eElement));
              else
                _warn (ret, "Unsupported Schematron element '" + sLocalName + "'");
            }
            else
              _warn (ret, "Unsupported namespace URI '" + eElement.getNamespaceURI () + "'");

            break;
          case COMMENT:
            // Ignore comments
            break;
          default:
            _warn (ret, "Unsupported child node: " + aTitleChild);
        }
    return ret;
  }

  /**
   * Read a &lt;value-of&gt; element
   *
   * @param eValueOf
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @Nonnull
  public PSValueOf readValueOfFromXML (@Nonnull final IMicroElement eValueOf)
  {
    final PSValueOf ret = new PSValueOf ();
    final Map <String, String> aAttrs = eValueOf.getAllAttributes ();
    if (aAttrs != null)
      for (final Map.Entry <String, String> aEntry : aAttrs.entrySet ())
      {
        final String sAttrName = aEntry.getKey ();
        final String sAttrValue = _getAttributeValue (aEntry.getValue ());
        if (sAttrName.equals (CSchematronXML.ATTR_SELECT))
          ret.setSelect (sAttrValue);
        else
          ret.addForeignAttribute (sAttrName, sAttrValue);
      }

    for (final IMicroElement eValueOfChild : eValueOf.getAllChildElements ())
    {
      if (CSchematron.NAMESPACE_SCHEMATRON.equals (eValueOfChild.getNamespaceURI ()))
      {
        _warn (ret, "Unsupported Schematron element '" + eValueOfChild.getLocalName () + "'");
      }
      else
        _warn (ret, "Unsupported namespace URI '" + eValueOfChild.getNamespaceURI () + "'");
    }
    return ret;
  }

  /**
   * Read the schema from the resource supplied in the constructor. First all
   * includes are resolved and the {@link #readSchemaFromXML(IMicroElement)} is
   * called.
   *
   * @return The read {@link PSSchema}.
   * @throws SchematronReadException
   *         If reading fails
   */
  @Nonnull
  public PSSchema readSchema () throws SchematronReadException
  {
    // Resolve all includes as the first action
    final IMicroDocument aDoc = SchematronHelper.getWithResolvedSchematronIncludes (m_aResource);
    if (aDoc == null || aDoc.getDocumentElement () == null)
      throw new SchematronReadException (m_aResource, "Failed to resolve includes in resource " + m_aResource);

    return readSchemaFromXML (aDoc.getDocumentElement ());
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("resource", m_aResource)
                                       .append ("errorHandler", m_aErrorHandler)
                                       .toString ();
  }
}
