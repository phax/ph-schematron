/**
 * Copyright (C) 2014-2018 Philip Helger (www.helger.com)
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
package com.helger.schematron.xpath;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.Immutable;
import javax.xml.namespace.QName;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;

import org.w3c.dom.Node;

import com.helger.commons.lang.GenericReflection;
import com.helger.xml.XMLHelper;

import net.sf.saxon.dom.DocumentWrapper;
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
  private XPathEvaluationHelper ()
  {}

  public static <T> T evaluate (@Nonnull final XPathExpression aXPath,
                                @Nonnull final Node aItem,
                                @Nonnull final QName aReturnType,
                                @Nullable final String sBaseURI) throws XPathExpressionException
  {
    Object aRealItem = aItem;
    if (sBaseURI != null && "net.sf.saxon.xpath.XPathExpressionImpl".equals (aXPath.getClass ().getName ()))
    {
      // Saxon specific handling
      // This is trick needed for #47 - "base-uri()"
      final XPathExpressionImpl aImpl = (XPathExpressionImpl) aXPath;
      aRealItem = new DocumentWrapper (XMLHelper.getOwnerDocument (aItem),
                                       sBaseURI,
                                       aImpl.getConfiguration ()).wrap (aItem);
    }

    return GenericReflection.uncheckedCast (aXPath.evaluate (aRealItem, aReturnType));
  }
}
