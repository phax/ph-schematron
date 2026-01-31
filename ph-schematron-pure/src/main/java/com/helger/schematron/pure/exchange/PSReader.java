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
package com.helger.schematron.pure.exchange;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.xml.sax.EntityResolver;

import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.location.SimpleLocation;
import com.helger.base.string.StringParser;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.diagnostics.error.SingleError;
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.CSchematron;
import com.helger.schematron.CSchematronXML;
import com.helger.schematron.SchematronDebug;
import com.helger.schematron.SchematronHelper;
import com.helger.schematron.pure.errorhandler.IPSErrorHandler;
import com.helger.schematron.pure.errorhandler.LoggingPSErrorHandler;
import com.helger.schematron.pure.model.*;
import com.helger.schematron.pure.model.PSDir.EDirValue;
import com.helger.schematron.pure.model.PSRichGroup.ESpace;
import com.helger.schematron.resolve.ISchematronIncludeResolver;
import com.helger.xml.microdom.IMicroDocument;
import com.helger.xml.microdom.IMicroElement;
import com.helger.xml.microdom.serialize.MicroWriter;
import com.helger.xml.serialize.read.SAXReaderSettings;

/**
 * Utility class for reading all Schematron elements from a resource.
 *
 * @author Philip Helger
 */
public class PSReader
{
  private static final Logger LOGGER = LoggerFactory.getLogger (PSReader.class);

  private final IReadableResource m_aResource;
  private final IPSErrorHandler m_aErrorHandler;
  private ISchematronIncludeResolver m_aSchematronIncludeResolver;
  private final EntityResolver m_aEntityResolver;
  private boolean m_bLenient = CSchematron.DEFAULT_ALLOW_DEPRECATED_NAMESPACES;

  /**
   * Constructor without an error handler
   *
   * @param aResource
   *        The resource to read the Schematron from. May not be <code>null</code>.
   */
  public PSReader (@NonNull final IReadableResource aResource)
  {
    this (aResource, null, null);
  }

  /**
   * Constructor with an error handler
   *
   * @param aResource
   *        The resource to read the Schematron from. May not be <code>null</code>.
   * @param aErrorHandler
   *        The error handler to use. May be <code>null</code>. If the error handler is
   *        <code>null</code> a {@link LoggingPSErrorHandler} is automatically created and used.
   * @param aEntityResolver
   *        The XML entity resolver to be used. May be <code>null</code>.
   * @since 4.1.1
   */
  public PSReader (@NonNull final IReadableResource aResource,
                   @Nullable final IPSErrorHandler aErrorHandler,
                   @Nullable final EntityResolver aEntityResolver)
  {
    ValueEnforcer.notNull (aResource, "Resource");
    m_aResource = aResource;
    m_aErrorHandler = aErrorHandler != null ? aErrorHandler : new LoggingPSErrorHandler ();
    m_aEntityResolver = aEntityResolver;
  }

  /**
   * @return The resource from which the Schematron schema is read. Never <code>null</code>.
   */
  @NonNull
  public final IReadableResource getResource ()
  {
    return m_aResource;
  }

  /**
   * @return The error handler used. If no error handler was passed in the constructor, than a
   *         {@link LoggingPSErrorHandler} is automatically used.
   */
  @NonNull
  public final IPSErrorHandler getErrorHandler ()
  {
    return m_aErrorHandler;
  }

  /**
   * @return The entity handler provided in the constructor. May be <code>null</code>.
   * @since v8
   */
  @Nullable
  public final EntityResolver getEntityResolver ()
  {
    return m_aEntityResolver;
  }

  /**
   * @return <code>true</code> if the old Schematron namespace is supported, <code>false</code> if
   *         not. Default is {@link CSchematron#DEFAULT_ALLOW_DEPRECATED_NAMESPACES}.
   * @since 5.4.1
   */
  public final boolean isLenient ()
  {
    return m_bLenient;
  }

  /**
   * Allow or disallow the support for old namespace prefix. By default this is deprecated.
   *
   * @param bLenient
   *        <code>true</code> to enable support for old namespace URIs, <code>false</code> to
   *        disallow it.
   * @return this for chaining
   * @since 5.4.1
   */
  @NonNull
  public final PSReader setLenient (final boolean bLenient)
  {
    m_bLenient = bLenient;
    return this;
  }

  /**
   * @return The custom Schematron include resolver. May be <code>null</code>.
   * @since 8.0.5
   */
  @Nullable
  public final ISchematronIncludeResolver getSchematronIncludeResolver ()
  {
    return m_aSchematronIncludeResolver;
  }

  /**
   * Set the customer schematron include resolver to be used.
   *
   * @param aSchematronIncludeResolver
   *        The resolver to be used. May be <code>null</code>.
   * @return this for chaining
   * @since 8.0.5
   */
  @NonNull
  public final PSReader setSchematronIncludeResolver (@Nullable final ISchematronIncludeResolver aSchematronIncludeResolver)
  {
    m_aSchematronIncludeResolver = aSchematronIncludeResolver;
    return this;
  }

  /**
   * Utility method to get a real attribute value, by trimming spaces, if the value is
   * non-<code>null</code>.
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
  private void _warn (@NonNull final IPSElement aSourceElement, @NonNull final String sMessage)
  {
    ValueEnforcer.notNull (aSourceElement, "SourceElement");
    ValueEnforcer.notNull (sMessage, "Message");

    m_aErrorHandler.handleError (SingleError.builderWarn ()
                                            .errorLocation (new SimpleLocation (m_aResource.getPath ()))
                                            .errorFieldName (IPSErrorHandler.getErrorFieldName (aSourceElement))
                                            .errorText (sMessage)
                                            .build ());
  }

  /**
   * Read an &lt;active&gt; element
   *
   * @param eActive
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @NonNull
  public PSActive readActiveFromXML (@NonNull final IMicroElement eActive)
  {
    final PSActive ret = new PSActive ();
    eActive.forAllAttributes ( (sNS, sAttrName, sVal) -> {
      final String sAttrValue = _getAttributeValue (sVal);
      if (sAttrName.equals (CSchematronXML.ATTR_PATTERN))
        ret.setPattern (sAttrValue);
      else
        ret.addForeignAttribute (sAttrName, sAttrValue);
    });

    eActive.forAllChildren (aActiveChild -> {
      switch (aActiveChild.getType ())
      {
        case TEXT:
          ret.addText (aActiveChild.getNodeValue ());
          break;
        case ELEMENT:
          final IMicroElement eElement = (IMicroElement) aActiveChild;
          if (isValidSchematronNS (eElement.getNamespaceURI ()))
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
    });
    return ret;
  }

  private static void _handleRichGroup (@NonNull final String sAttrName,
                                        @NonNull final String sAttrValue,
                                        @NonNull final PSRichGroup aRichGroup)
  {
    if (sAttrName.equals (CSchematronXML.ATTR_ICON))
      aRichGroup.setIcon (sAttrValue);
    else
      if (sAttrName.equals (CSchematronXML.ATTR_SEE))
        aRichGroup.setSee (sAttrValue);
      else
        if (sAttrName.equals (CSchematronXML.ATTR_FPI))
          aRichGroup.setFPI (sAttrValue);
        else
          if (sAttrName.equals (CSchematronXML.ATTR_XML_LANG))
            aRichGroup.setXmlLang (sAttrValue);
          else
            if (sAttrName.equals (CSchematronXML.ATTR_XML_SPACE))
              aRichGroup.setXmlSpace (ESpace.getFromIDOrNull (sAttrValue));
  }

  private static void _handleLinkableGroup (@NonNull final String sAttrName,
                                            @NonNull final String sAttrValue,
                                            @NonNull final PSLinkableGroup aLinkableGroup)
  {
    if (sAttrName.equals (CSchematronXML.ATTR_ROLE))
      aLinkableGroup.setRole (sAttrValue);
    else
      if (sAttrName.equals (CSchematronXML.ATTR_SUBJECT))
        aLinkableGroup.setSubject (sAttrValue);
  }

  /**
   * Read an &lt;assert&gt; or a &lt;report&gt; element
   *
   * @param eAssertReport
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @NonNull
  public PSAssertReport readAssertReportFromXML (@NonNull final IMicroElement eAssertReport)
  {
    final PSAssertReport ret = new PSAssertReport (eAssertReport.getLocalName ()
                                                                .equals (CSchematronXML.ELEMENT_ASSERT));

    final PSRichGroup aRichGroup = new PSRichGroup ();
    final PSLinkableGroup aLinkableGroup = new PSLinkableGroup ();
    eAssertReport.forAllAttributes ( (sNS, sAttrName, sVal) -> {
      final String sAttrValue = _getAttributeValue (sVal);
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
              if (PSRichGroup.isRichAttribute (sAttrName))
                _handleRichGroup (sAttrName, sAttrValue, aRichGroup);
              else
                if (PSLinkableGroup.isLinkableAttribute (sAttrName))
                  _handleLinkableGroup (sAttrName, sAttrValue, aLinkableGroup);
                else
                  ret.addForeignAttribute (sAttrName, sAttrValue);
    });
    ret.setRich (aRichGroup);
    ret.setLinkable (aLinkableGroup);

    eAssertReport.forAllChildren (aAssertReportChild -> {
      switch (aAssertReportChild.getType ())
      {
        case TEXT:
          ret.addText (aAssertReportChild.getNodeValue ());
          break;
        case ELEMENT:
          final IMicroElement eElement = (IMicroElement) aAssertReportChild;
          if (isValidSchematronNS (eElement.getNamespaceURI ()))
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
    });
    return ret;
  }

  /**
   * Read a &lt;diagnostic&gt; element
   *
   * @param eDiagnostic
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @NonNull
  public PSDiagnostic readDiagnosticFromXML (@NonNull final IMicroElement eDiagnostic)
  {
    final PSDiagnostic ret = new PSDiagnostic ();

    final PSRichGroup aRichGroup = new PSRichGroup ();
    eDiagnostic.forAllAttributes ( (sNS, sAttrName, sVal) -> {
      final String sAttrValue = _getAttributeValue (sVal);
      if (sAttrName.equals (CSchematronXML.ATTR_ID))
        ret.setID (sAttrValue);
      else
        if (PSRichGroup.isRichAttribute (sAttrName))
          _handleRichGroup (sAttrName, sAttrValue, aRichGroup);
        else
          ret.addForeignAttribute (sAttrName, sAttrValue);
    });
    ret.setRich (aRichGroup);

    eDiagnostic.forAllChildren (aDiagnosticChild -> {
      switch (aDiagnosticChild.getType ())
      {
        case TEXT:
          ret.addText (aDiagnosticChild.getNodeValue ());
          break;
        case ELEMENT:
          final IMicroElement eElement = (IMicroElement) aDiagnosticChild;
          if (isValidSchematronNS (eElement.getNamespaceURI ()))
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
    });
    return ret;
  }

  /**
   * Read a &lt;diagnostics&gt; element
   *
   * @param eDiagnostics
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @NonNull
  public PSDiagnostics readDiagnosticsFromXML (@NonNull final IMicroElement eDiagnostics)
  {
    final PSDiagnostics ret = new PSDiagnostics ();

    eDiagnostics.forAllAttributes ( (sNS, sAttrName, sVal) -> {
      final String sAttrValue = _getAttributeValue (sVal);
      ret.addForeignAttribute (sAttrName, sAttrValue);
    });

    eDiagnostics.forAllChildElements (eDiagnosticsChild -> {
      if (isValidSchematronNS (eDiagnosticsChild.getNamespaceURI ()))
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
    });
    return ret;
  }

  /**
   * Read a &lt;dir&gt; element
   *
   * @param eDir
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @NonNull
  public PSDir readDirFromXML (@NonNull final IMicroElement eDir)
  {
    final PSDir ret = new PSDir ();

    eDir.forAllAttributes ( (sNS, sAttrName, sVal) -> {
      final String sAttrValue = _getAttributeValue (sVal);
      if (sAttrName.equals (CSchematronXML.ATTR_VALUE))
        ret.setValue (EDirValue.getFromIDOrNull (sAttrValue));
      else
        ret.addForeignAttribute (sAttrName, sAttrValue);
    });

    eDir.forAllChildren (aDirChild -> {
      switch (aDirChild.getType ())
      {
        case TEXT:
          ret.addText (aDirChild.getNodeValue ());
          break;
        case ELEMENT:
          final IMicroElement eElement = (IMicroElement) aDirChild;
          if (isValidSchematronNS (eElement.getNamespaceURI ()))
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
    });
    return ret;
  }

  /**
   * Read an &lt;emph&gt; element
   *
   * @param eEmph
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @NonNull
  public PSEmph readEmphFromXML (@NonNull final IMicroElement eEmph)
  {
    final PSEmph ret = new PSEmph ();

    eEmph.forAllAttributes ( (sNS, sAttrName, sVal) -> {
      final String sAttrValue = _getAttributeValue (sVal);
      _warn (ret, "Unsupported attribute '" + sAttrName + "'='" + sAttrValue + "'");
    });

    eEmph.forAllChildren (aEmphChild -> {
      switch (aEmphChild.getType ())
      {
        case TEXT:
          ret.addText (aEmphChild.getNodeValue ());
          break;
        case ELEMENT:
          final IMicroElement eElement = (IMicroElement) aEmphChild;
          if (isValidSchematronNS (eElement.getNamespaceURI ()))
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
    });
    return ret;
  }

  /**
   * Read an &lt;extends&gt; element
   *
   * @param eExtends
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @NonNull
  public PSExtends readExtendsFromXML (@NonNull final IMicroElement eExtends)
  {
    final PSExtends ret = new PSExtends ();

    eExtends.forAllAttributes ( (sNS, sAttrName, sVal) -> {
      final String sAttrValue = _getAttributeValue (sVal);
      if (sAttrName.equals (CSchematronXML.ATTR_RULE))
        ret.setRule (sAttrValue);
      else
        ret.addForeignAttribute (sAttrName, sAttrValue);
    });

    eExtends.forAllChildElements (eChild -> {
      if (isValidSchematronNS (eChild.getNamespaceURI ()))
      {
        _warn (ret, "Unsupported Schematron element '" + eChild.getLocalName () + "'");
      }
      else
        _warn (ret, "Unsupported namespace URI '" + eChild.getNamespaceURI () + "'");
    });
    return ret;
  }

  /**
   * Read an &lt;include&gt; element
   *
   * @param eInclude
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @NonNull
  public PSInclude readIncludeFromXML (@NonNull final IMicroElement eInclude)
  {
    final PSInclude ret = new PSInclude ();

    eInclude.forAllAttributes ( (sNS, sAttrName, sVal) -> {
      final String sAttrValue = _getAttributeValue (sVal);
      if (sAttrName.equals (CSchematronXML.ATTR_HREF))
        ret.setHref (sAttrValue);
      else
        _warn (ret, "Unsupported attribute '" + sAttrName + "'='" + sAttrValue + "'");
    });

    eInclude.forAllChildElements (eValueOfChild -> {
      if (isValidSchematronNS (eValueOfChild.getNamespaceURI ()))
      {
        _warn (ret, "Unsupported Schematron element '" + eValueOfChild.getLocalName () + "'");
      }
      else
        _warn (ret, "Unsupported namespace URI '" + eValueOfChild.getNamespaceURI () + "'");
    });
    return ret;
  }

  /**
   * Read a &lt;let&gt; element
   *
   * @param eLet
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @NonNull
  public PSLet readLetFromXML (@NonNull final IMicroElement eLet)
  {
    final PSLet ret = new PSLet ();

    eLet.forAllAttributes ( (sNS, sAttrName, sVal) -> {
      final String sAttrValue = _getAttributeValue (sVal);
      if (sAttrName.equals (CSchematronXML.ATTR_NAME))
        ret.setName (sAttrValue);
      else
        if (sAttrName.equals (CSchematronXML.ATTR_VALUE))
          ret.setValue (sAttrValue);
        else
          _warn (ret, "Unsupported attribute '" + sAttrName + "'='" + sAttrValue + "'");
    });

    eLet.forAllChildElements (eLetChild -> {
      if (isValidSchematronNS (eLetChild.getNamespaceURI ()))
      {
        _warn (ret, "Unsupported Schematron element '" + eLetChild.getLocalName () + "'");
      }
      else
        _warn (ret, "Unsupported namespace URI '" + eLetChild.getNamespaceURI () + "'");
    });
    return ret;
  }

  /**
   * Read a &lt;name&gt; element
   *
   * @param eName
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @NonNull
  public PSName readNameFromXML (@NonNull final IMicroElement eName)
  {
    final PSName ret = new PSName ();

    eName.forAllAttributes ( (sNS, sAttrName, sVal) -> {
      final String sAttrValue = _getAttributeValue (sVal);
      if (sAttrName.equals (CSchematronXML.ATTR_PATH))
        ret.setPath (sAttrValue);
      else
        ret.addForeignAttribute (sAttrName, sAttrValue);
    });

    eName.forAllChildElements (eNameChild -> {
      if (isValidSchematronNS (eNameChild.getNamespaceURI ()))
      {
        _warn (ret, "Unsupported Schematron element '" + eNameChild.getLocalName () + "'");
      }
      else
        _warn (ret, "Unsupported namespace URI '" + eNameChild.getNamespaceURI () + "'");
    });
    return ret;
  }

  /**
   * Read a &lt;ns&gt; element
   *
   * @param eNS
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @NonNull
  public PSNS readNSFromXML (@NonNull final IMicroElement eNS)
  {
    final PSNS ret = new PSNS ();

    eNS.forAllAttributes ( (sNS, sAttrName, sVal) -> {
      final String sAttrValue = _getAttributeValue (sVal);
      if (sAttrName.equals (CSchematronXML.ATTR_URI))
        ret.setUri (sAttrValue);
      else
        if (sAttrName.equals (CSchematronXML.ATTR_PREFIX))
          ret.setPrefix (sAttrValue);
        else
          ret.addForeignAttribute (sAttrName, sAttrValue);
    });

    eNS.forAllChildElements (eLetChild -> {
      if (isValidSchematronNS (eLetChild.getNamespaceURI ()))
      {
        _warn (ret, "Unsupported Schematron element '" + eLetChild.getLocalName () + "'");
      }
      else
        _warn (ret, "Unsupported namespace URI '" + eLetChild.getNamespaceURI () + "'");
    });
    return ret;
  }

  /**
   * Read a &lt;p&gt; element
   *
   * @param eP
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @NonNull
  public PSP readPFromXML (@NonNull final IMicroElement eP)
  {
    final PSP ret = new PSP ();
    eP.forAllAttributes ( (sNS, sAttrName, sVal) -> {
      final String sAttrValue = _getAttributeValue (sVal);
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
    });

    eP.forAllChildren (aChild -> {
      switch (aChild.getType ())
      {
        case TEXT:
          ret.addText (aChild.getNodeValue ());
          break;
        case ELEMENT:
          final IMicroElement eElement = (IMicroElement) aChild;
          if (isValidSchematronNS (eElement.getNamespaceURI ()))
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
    });
    return ret;
  }

  /**
   * Read a &lt;param&gt; element
   *
   * @param eParam
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @NonNull
  public PSParam readParamFromXML (@NonNull final IMicroElement eParam)
  {
    final PSParam ret = new PSParam ();

    eParam.forAllAttributes ( (sNS, sAttrName, sVal) -> {
      final String sAttrValue = _getAttributeValue (sVal);
      if (sAttrName.equals (CSchematronXML.ATTR_NAME))
        ret.setName (sAttrValue);
      else
        if (sAttrName.equals (CSchematronXML.ATTR_VALUE))
          ret.setValue (sAttrValue);
        else
          _warn (ret, "Unsupported attribute '" + sAttrName + "'='" + sAttrValue + "'");
    });

    eParam.forAllChildElements (eParamChild -> {
      if (isValidSchematronNS (eParamChild.getNamespaceURI ()))
      {
        _warn (ret, "Unsupported Schematron element '" + eParamChild.getLocalName () + "'");
      }
      else
        _warn (ret, "Unsupported namespace URI '" + eParamChild.getNamespaceURI () + "'");
    });
    return ret;
  }

  /**
   * Read a &lt;pattern&gt; element
   *
   * @param ePattern
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @NonNull
  public PSPattern readPatternFromXML (@NonNull final IMicroElement ePattern)
  {
    final PSPattern ret = new PSPattern ();

    final PSRichGroup aRichGroup = new PSRichGroup ();
    ePattern.forAllAttributes ( (sNS, sAttrName, sVal) -> {
      final String sAttrValue = _getAttributeValue (sVal);
      if (sAttrName.equals (CSchematronXML.ATTR_ABSTRACT))
        ret.setAbstract (StringParser.parseBool (sAttrValue));
      else
        if (sAttrName.equals (CSchematronXML.ATTR_ID))
          ret.setID (sAttrValue);
        else
          if (sAttrName.equals (CSchematronXML.ATTR_IS_A))
            ret.setIsA (sAttrValue);
          else
            if (PSRichGroup.isRichAttribute (sAttrName))
              _handleRichGroup (sAttrName, sAttrValue, aRichGroup);
            else
              ret.addForeignAttribute (sAttrName, sAttrValue);
    });
    ret.setRich (aRichGroup);

    ePattern.forAllChildElements (ePatternChild -> {
      if (isValidSchematronNS (ePatternChild.getNamespaceURI ()))
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
    });
    return ret;
  }

  /**
   * Read a &lt;phase&gt; element
   *
   * @param ePhase
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @NonNull
  public PSPhase readPhaseFromXML (@NonNull final IMicroElement ePhase)
  {
    final PSPhase ret = new PSPhase ();

    final PSRichGroup aRichGroup = new PSRichGroup ();
    ePhase.forAllAttributes ( (sNS, sAttrName, sVal) -> {
      final String sAttrValue = _getAttributeValue (sVal);
      if (sAttrName.equals (CSchematronXML.ATTR_ID))
        ret.setID (sAttrValue);
      else
        if (PSRichGroup.isRichAttribute (sAttrName))
          _handleRichGroup (sAttrName, sAttrValue, aRichGroup);
        else
          ret.addForeignAttribute (sAttrName, sAttrValue);
    });
    ret.setRich (aRichGroup);

    ePhase.forAllChildElements (ePhaseChild -> {
      if (isValidSchematronNS (ePhaseChild.getNamespaceURI ()))
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
    });
    return ret;
  }

  /**
   * Read a &lt;rule&gt; element
   *
   * @param eRule
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @NonNull
  public PSRule readRuleFromXML (@NonNull final IMicroElement eRule)
  {
    final PSRule ret = new PSRule ();

    final PSRichGroup aRichGroup = new PSRichGroup ();
    final PSLinkableGroup aLinkableGroup = new PSLinkableGroup ();
    eRule.forAllAttributes ( (sNS, sAttrName, sVal) -> {
      final String sAttrValue = _getAttributeValue (sVal);
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
              if (PSRichGroup.isRichAttribute (sAttrName))
                _handleRichGroup (sAttrName, sAttrValue, aRichGroup);
              else
                if (PSLinkableGroup.isLinkableAttribute (sAttrName))
                  _handleLinkableGroup (sAttrName, sAttrValue, aLinkableGroup);
                else
                  ret.addForeignAttribute (sAttrName, sAttrValue);
    });
    ret.setRich (aRichGroup);
    ret.setLinkable (aLinkableGroup);

    eRule.forAllChildElements (eRuleChild -> {
      if (isValidSchematronNS (eRuleChild.getNamespaceURI ()))
      {
        final String sLocalName = eRuleChild.getLocalName ();
        if (sLocalName.equals (CSchematronXML.ELEMENT_INCLUDE))
          ret.addInclude (readIncludeFromXML (eRuleChild));
        else
          if (sLocalName.equals (CSchematronXML.ELEMENT_LET))
            ret.addLet (readLetFromXML (eRuleChild));
          else
            if (sLocalName.equals (CSchematronXML.ELEMENT_ASSERT) || sLocalName.equals (CSchematronXML.ELEMENT_REPORT))
              ret.addAssertReport (readAssertReportFromXML (eRuleChild));
            else
              if (sLocalName.equals (CSchematronXML.ELEMENT_EXTENDS))
                ret.addExtends (readExtendsFromXML (eRuleChild));
              else
                _warn (ret, "Unsupported Schematron element '" + sLocalName + "'");
      }
      else
        ret.addForeignElement (eRuleChild.getClone ());
    });
    return ret;
  }

  public boolean isValidSchematronNS (@Nullable final String sNamespaceURI)
  {
    return SchematronHelper.isValidSchematronNS (sNamespaceURI, isLenient ());
  }

  /**
   * Parse the Schematron into a pure Java object. This method makes no assumptions on the validity
   * of the document!
   *
   * @param eSchema
   *        The XML element to use. May not be <code>null</code>.
   * @return The created {@link PSSchema} object or <code>null</code> in case of <code>null</code>
   *         document or a fatal error.
   * @throws SchematronReadException
   *         If reading fails
   */
  @NonNull
  public PSSchema readSchemaFromXML (@NonNull final IMicroElement eSchema) throws SchematronReadException
  {
    ValueEnforcer.notNull (eSchema, "Schema");

    if (!isLenient () && SchematronHelper.isDeprecatedSchematronNS (eSchema.getNamespaceURI ()))
      LOGGER.warn ("OLD Schematron NS '" +
                   eSchema.getNamespaceURI () +
                   "' is deprecated, use '" +
                   CSchematron.NAMESPACE_SCHEMATRON +
                   "' instead");

    if (!isValidSchematronNS (eSchema.getNamespaceURI ()))
      throw new SchematronReadException (m_aResource, "The passed element is not an ISO Schematron element!");

    final PSSchema ret = new PSSchema (m_aResource);
    final PSRichGroup aRichGroup = new PSRichGroup ();
    eSchema.forAllAttributes ( (sNS, sAttrName, sVal) -> {
      final String sAttrValue = _getAttributeValue (sVal);
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
              if (PSRichGroup.isRichAttribute (sAttrName))
                _handleRichGroup (sAttrName, sAttrValue, aRichGroup);
              else
                ret.addForeignAttribute (sAttrName, sAttrValue);
    });
    ret.setRich (aRichGroup);

    eSchema.forAllChildElements (eSchemaChild -> {
      if (isValidSchematronNS (eSchemaChild.getNamespaceURI ()))
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
    });
    return ret;
  }

  /**
   * Read a &lt;span&gt; element
   *
   * @param eSpan
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @NonNull
  public PSSpan readSpanFromXML (@NonNull final IMicroElement eSpan)
  {
    final PSSpan ret = new PSSpan ();

    eSpan.forAllAttributes ( (sNS, sAttrName, sVal) -> {
      final String sAttrValue = _getAttributeValue (sVal);
      if (sAttrName.equals (CSchematronXML.ATTR_CLASS))
        ret.setClazz (sAttrValue);
      else
        ret.addForeignAttribute (sAttrName, sAttrValue);
    });

    eSpan.forAllChildren (aSpanChild -> {
      switch (aSpanChild.getType ())
      {
        case TEXT:
          ret.addText (aSpanChild.getNodeValue ());
          break;
        case ELEMENT:
          final IMicroElement eElement = (IMicroElement) aSpanChild;
          if (isValidSchematronNS (eElement.getNamespaceURI ()))
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
    });
    return ret;
  }

  /**
   * Read a &lt;title&gt; element
   *
   * @param eTitle
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @NonNull
  public PSTitle readTitleFromXML (@NonNull final IMicroElement eTitle)
  {
    final PSTitle ret = new PSTitle ();

    eTitle.forAllAttributes ( (sNS, sAttrName, sVal) -> {
      final String sAttrValue = _getAttributeValue (sVal);
      _warn (ret, "Unsupported attribute '" + sAttrName + "'='" + sAttrValue + "'");
    });

    eTitle.forAllChildren (aTitleChild -> {
      switch (aTitleChild.getType ())
      {
        case TEXT:
          ret.addText (aTitleChild.getNodeValue ());
          break;
        case ELEMENT:
          final IMicroElement eElement = (IMicroElement) aTitleChild;
          if (isValidSchematronNS (eElement.getNamespaceURI ()))
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
    });
    return ret;
  }

  /**
   * Read a &lt;value-of&gt; element
   *
   * @param eValueOf
   *        The source micro element. Never <code>null</code>.
   * @return The created domain object. May not be <code>null</code>.
   */
  @NonNull
  public PSValueOf readValueOfFromXML (@NonNull final IMicroElement eValueOf)
  {
    final PSValueOf ret = new PSValueOf ();

    eValueOf.forAllAttributes ( (sNS, sAttrName, sVal) -> {
      final String sAttrValue = _getAttributeValue (sVal);
      if (sAttrName.equals (CSchematronXML.ATTR_SELECT))
        ret.setSelect (sAttrValue);
      else
        ret.addForeignAttribute (sAttrName, sAttrValue);
    });

    eValueOf.forAllChildElements (eValueOfChild -> {
      if (isValidSchematronNS (eValueOfChild.getNamespaceURI ()))
      {
        _warn (ret, "Unsupported Schematron element '" + eValueOfChild.getLocalName () + "'");
      }
      else
        _warn (ret, "Unsupported namespace URI '" + eValueOfChild.getNamespaceURI () + "'");
    });
    return ret;
  }

  /**
   * Read the schema from the resource supplied in the constructor. First all includes are resolved
   * and than {@link #readSchemaFromXML(IMicroElement)} is called.
   *
   * @return The read {@link PSSchema}.
   * @throws SchematronReadException
   *         If reading fails
   */
  @NonNull
  public PSSchema readSchema () throws SchematronReadException
  {
    // Resolve all includes as the first action
    final SAXReaderSettings aSettings = new SAXReaderSettings ().setEntityResolver (m_aEntityResolver);

    final IMicroDocument aDoc = SchematronHelper.getWithResolvedSchematronIncludes (m_aResource,
                                                                                    aSettings,
                                                                                    m_aErrorHandler,
                                                                                    m_aSchematronIncludeResolver,
                                                                                    m_bLenient);
    if (aDoc == null || aDoc.getDocumentElement () == null)
      throw new SchematronReadException (m_aResource,
                                         "Failed to resolve includes in Schematron resource " + m_aResource);

    if (SchematronDebug.isShowResolvedSourceSchematron ())
      LOGGER.info ("Resolved source Schematron:\n" + MicroWriter.getNodeAsString (aDoc));

    return readSchemaFromXML (aDoc.getDocumentElement ());
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("Resource", m_aResource)
                                       .append ("ErrorHandler", m_aErrorHandler)
                                       .append ("EntityResolver", m_aEntityResolver)
                                       .append ("Lenient", m_bLenient)
                                       .getToString ();
  }
}
