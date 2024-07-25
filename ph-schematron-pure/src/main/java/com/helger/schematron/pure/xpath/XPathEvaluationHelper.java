/*
 * Copyright (C) 2014-2024 Philip Helger (www.helger.com)
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
package com.helger.schematron.pure.xpath;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.Immutable;
import javax.xml.namespace.QName;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.helger.commons.lang.GenericReflection;
import com.helger.xml.XMLHelper;

import net.sf.saxon.dom.DocumentWrapper;
import net.sf.saxon.expr.ArithmeticExpression;
import net.sf.saxon.expr.CastExpression;
import net.sf.saxon.expr.ContextItemExpression;
import net.sf.saxon.expr.Expression;
import net.sf.saxon.expr.FirstItemExpression;
import net.sf.saxon.expr.ForExpression;
import net.sf.saxon.expr.GeneralComparison;
import net.sf.saxon.expr.Literal;
import net.sf.saxon.expr.SlashExpression;
import net.sf.saxon.expr.StaticFunctionCall;
import net.sf.saxon.expr.StringLiteral;
import net.sf.saxon.expr.ValueComparison;
import net.sf.saxon.expr.sort.DocumentSorter;
import net.sf.saxon.om.FunctionItem;
import net.sf.saxon.pattern.NodeKindTest;
import net.sf.saxon.type.AtomicType;
import net.sf.saxon.type.BuiltInAtomicType;
import net.sf.saxon.type.ItemType;
import net.sf.saxon.type.UType;
import net.sf.saxon.value.BigDecimalValue;
import net.sf.saxon.value.BooleanValue;
import net.sf.saxon.value.Int64Value;
import net.sf.saxon.value.SequenceExtent;
import net.sf.saxon.xpath.JAXPVariableReference;
import net.sf.saxon.xpath.XPathExpressionImpl;

/**
 * XPath evaluation helper
 *
 * @author Philip Helger
 * @since 5.0.0
 */
@Immutable
public final class XPathEvaluationHelper
{
  // Separate class that only gets loaded if Saxon is on the classpath
  @Immutable
  private static final class SaxonEvaluator
  {
    private static final Logger LOGGER = LoggerFactory.getLogger (SaxonEvaluator.class);

    private SaxonEvaluator ()
    {}

    @Nonnull
    static Object getBaseUriFixed (@Nonnull final XPathExpression aXPath,
                                   @Nonnull final Node aNode,
                                   @Nonnull final String sBaseURI)
    {
      // Saxon specific handling
      // This is trick needed for #47 - "base-uri()"
      final XPathExpressionImpl aImpl = (XPathExpressionImpl) aXPath;
      return new DocumentWrapper (XMLHelper.getOwnerDocument (aNode), sBaseURI, aImpl.getConfiguration ()).wrap (aNode);
    }

    private static QName _findReturnType (final UType uType)
    {
      if (uType == UType.BOOLEAN)
        return XPathConstants.BOOLEAN;
      if (uType == UType.DECIMAL || uType == UType.FLOAT || uType == UType.DOUBLE)
        return XPathConstants.NUMBER;
      if (uType == UType.ATTRIBUTE ||
          uType == UType.TEXT ||
          uType == UType.COMMENT ||
          uType == UType.PI ||
          uType == UType.NAMESPACE ||
          uType == UType.STRING ||
          uType == UType.DURATION ||
          uType == UType.DATE_TIME ||
          uType == UType.DATE ||
          uType == UType.TIME ||
          uType == UType.G_YEAR_MONTH ||
          uType == UType.G_YEAR ||
          uType == UType.G_MONTH_DAY ||
          uType == UType.G_DAY ||
          uType == UType.G_MONTH ||
          uType == UType.HEX_BINARY ||
          uType == UType.BASE64_BINARY ||
          uType == UType.ANY_URI ||
          uType == UType.QNAME ||
          uType == UType.NOTATION ||
          uType == UType.UNTYPED_ATOMIC)
        return XPathConstants.STRING;
      if (uType == UType.DOCUMENT || uType == UType.ELEMENT)
        return XPathConstants.NODE;
      if (uType == UType.ANY_NODE)
        return XPathConstants.NODESET;

      // Else: FUNCTION, EXTENSION
      LOGGER.warn ("Unknown Saxon UType: " + uType);
      return null;
    }

    @Nullable
    private static QName _findReturnType (@Nonnull final ItemType type)
    {
      if (type instanceof BuiltInAtomicType)
      {
        final BuiltInAtomicType biat = (BuiltInAtomicType) type;
        if (biat.equals (BuiltInAtomicType.BOOLEAN))
          return XPathConstants.BOOLEAN;
        if (biat.isNumericType ())
          return XPathConstants.NUMBER;
        if (BuiltInAtomicType.isStringLike (biat))
          return XPathConstants.STRING;
        // Fall back to node set
        return XPathConstants.NODESET;
      }
      if (type instanceof NodeKindTest)
      {
        final NodeKindTest nkt = (NodeKindTest) type;
        return _findReturnType (nkt.getUType ());
      }
      LOGGER.warn ("Unknown Saxon type: " + (type == null ? "null" : type.getClass ().getName ()));
      return null;
    }

    @Nullable
    private static QName _findReturnType (@Nonnull final Expression expr)
    {
      if (expr instanceof ValueComparison || expr instanceof GeneralComparison)
        return XPathConstants.BOOLEAN;
      if (expr instanceof StringLiteral)
        return XPathConstants.STRING;
      if (expr instanceof ArithmeticExpression)
        return XPathConstants.NUMBER;
      if (expr instanceof ContextItemExpression || expr instanceof FirstItemExpression)
        return XPathConstants.NODE;
      if (expr instanceof SlashExpression || expr instanceof DocumentSorter || expr instanceof ForExpression)
        return XPathConstants.NODESET;
      if (expr instanceof Literal)
      {
        final Literal lit = (Literal) expr;
        final var litValue = lit.getGroundedValue ();
        if (litValue instanceof BooleanValue)
          return XPathConstants.BOOLEAN;
        if (litValue instanceof BigDecimalValue || litValue instanceof Int64Value)
          return XPathConstants.NUMBER;
        if (litValue instanceof SequenceExtent.Of)
          return XPathConstants.NODESET;
        LOGGER.warn ("Unknown Saxon grounded value type: " +
                     (litValue == null ? "null" : litValue.getClass ().getName ()));
        return null;
      }
      if (expr instanceof CastExpression)
      {
        final AtomicType aTargetType = ((CastExpression) expr).getTargetType ();
        return _findReturnType (aTargetType);
      }
      if (expr instanceof StaticFunctionCall)
      {
        final FunctionItem aTargetFun = ((StaticFunctionCall) expr).getTargetFunction ();
        return _findReturnType (aTargetFun.getFunctionItemType ().getResultType ().getPrimaryType ());
      }
      if (expr instanceof JAXPVariableReference)
      {
        // As it is unclear, if the variable can be resolved at all, we just
        // skip this
        return null;
      }

      LOGGER.warn ("Unknown Saxon expression type: " + expr.getClass ().getName ());
      return null;
    }

    @Nullable
    static QName findReturnType (@Nonnull final XPathExpression aXPath)
    {
      final XPathExpressionImpl aImpl = (XPathExpressionImpl) aXPath;
      try
      {
        // tested with Saxon 12.5
        return _findReturnType (aImpl.getInternalExpression ());
      }
      catch (final Throwable ex)
      {
        // E.g. method not found, type not found etc. Just a catch all
        LOGGER.error ("Failed to evaluate Saxon internal type: " +
                      ex.getClass ().getName () +
                      " - " +
                      ex.getMessage ());
        return null;
      }
    }
  }

  private XPathEvaluationHelper ()
  {}

  private static boolean isSaxonImplementation (@Nonnull final XPathExpression aXPath)
  {
    return "net.sf.saxon.xpath.XPathExpressionImpl".equals (aXPath.getClass ().getName ());
  }

  @Nullable
  public static Object evaluateWithTypeAutodetect (@Nonnull final XPathExpression aXPath,
                                                   @Nonnull final Node aNode,
                                                   @Nullable final String sBaseURI) throws XPathExpressionException
  {
    if (!isSaxonImplementation (aXPath))
      return null;

    // Saxon specific magic
    final QName aReturnType = SaxonEvaluator.findReturnType (aXPath);
    if (aReturnType == null)
      return null;

    return evaluate (aXPath, aNode, aReturnType, sBaseURI);
  }

  @Nullable
  public static <T> T evaluate (@Nonnull final XPathExpression aXPath,
                                @Nonnull final Node aNode,
                                @Nonnull final QName aReturnType,
                                @Nullable final String sBaseURI) throws XPathExpressionException
  {
    Object aRealItem = aNode;
    if (sBaseURI != null && isSaxonImplementation (aXPath))
    {
      aRealItem = SaxonEvaluator.getBaseUriFixed (aXPath, aNode, sBaseURI);
    }

    // Unfortunately there is no "any" type
    final Object ret = aXPath.evaluate (aRealItem, aReturnType);
    return GenericReflection.uncheckedCast (ret);
  }

  @Nullable
  public static Boolean evaluateAsBooleanObj (@Nonnull final XPathExpression aXPath,
                                              @Nonnull final Node aNode,
                                              @Nullable final String sBaseURI) throws XPathExpressionException
  {
    return evaluate (aXPath, aNode, XPathConstants.BOOLEAN, sBaseURI);
  }

  public static boolean evaluateAsBoolean (@Nonnull final XPathExpression aXPath,
                                           @Nonnull final Node aNode,
                                           @Nullable final String sBaseURI) throws XPathExpressionException
  {
    final Boolean aVal = evaluateAsBooleanObj (aXPath, aNode, sBaseURI);
    if (aVal == null)
      throw new XPathExpressionException ("Failed to evaluate the XPath expression as boolean");
    return aVal.booleanValue ();
  }

  @Nullable
  public static Node evaluateAsNode (@Nonnull final XPathExpression aXPath,
                                     @Nonnull final Node aNode,
                                     @Nullable final String sBaseURI) throws XPathExpressionException
  {
    return evaluate (aXPath, aNode, XPathConstants.NODE, sBaseURI);
  }

  @Nullable
  public static NodeList evaluateAsNodeList (@Nonnull final XPathExpression aXPath,
                                             @Nonnull final Node aNode,
                                             @Nullable final String sBaseURI) throws XPathExpressionException
  {
    return evaluate (aXPath, aNode, XPathConstants.NODESET, sBaseURI);
  }

  @Nullable
  public static Double evaluateAsNumber (@Nonnull final XPathExpression aXPath,
                                         @Nonnull final Node aNode,
                                         @Nullable final String sBaseURI) throws XPathExpressionException
  {
    return evaluate (aXPath, aNode, XPathConstants.NUMBER, sBaseURI);
  }

  @Nullable
  public static String evaluateAsString (@Nonnull final XPathExpression aXPath,
                                         @Nonnull final Node aNode,
                                         @Nullable final String sBaseURI) throws XPathExpressionException
  {
    return evaluate (aXPath, aNode, XPathConstants.STRING, sBaseURI);
  }
}
