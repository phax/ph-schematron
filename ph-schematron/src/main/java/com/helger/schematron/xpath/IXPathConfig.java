package com.helger.schematron.xpath;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.xml.xpath.XPathFactory;
import javax.xml.xpath.XPathFunctionResolver;
import javax.xml.xpath.XPathVariableResolver;

/**
 * XPath configuration to use.
 * <p>
 * This is a counter-measure against
 * <a href="https://github.com/phax/ph-schematron/issues/96">#96</a>: When using
 * Saxon-HE, you have stripped down XPath support (no XPath higher order
 * functions according to the <a href=
 * "https://www.saxonica.com/html/products/feature-matrix-9-9.html">saxon
 * feature matrix</a>). In this case, you perhaps want to use a different
 * <em>XPath implementation</em> (most commonly the XPath implementation shipped
 * with Java).
 * </p>
 *
 * @author Thomas Pasch
 * @since 5.5.0
 * @see com.helger.schematron.pure.SchematronResourcePure
 * @see com.helger.schematron.pure.bound.xpath.PSXPathBoundSchema
 * @see com.helger.schematron.pure.bound.PSBoundSchemaCacheKey
 */
public interface IXPathConfig
{
  @Nonnull
  XPathFactory getXPathFactory ();

  @Nullable
  XPathVariableResolver getXPathVariableResolver ();

  @Nullable
  XPathFunctionResolver getXPathFunctionResolver ();
}
