package com.helger.schematron.config;

import javax.xml.xpath.XPathFactory;
import javax.xml.xpath.XPathFunctionResolver;
import javax.xml.xpath.XPathVariableResolver;
import java.util.Objects;

public class XPathConfigImpl implements XPathConfig {

    private final XPathFactory xPathFactory;

    private final XPathVariableResolver xPathVariableResolver;

    private final XPathFunctionResolver xPathFunctionResolver;

    XPathConfigImpl(XPathFactory xPathFactory, XPathVariableResolver xPathVariableResolver,
                           XPathFunctionResolver xPathFunctionResolver) {
        this.xPathFactory = xPathFactory;
        this.xPathVariableResolver = xPathVariableResolver;
        this.xPathFunctionResolver = xPathFunctionResolver;
    }

    @Override
    public XPathFactory getXPathFactory() {
        return xPathFactory;
    }

    @Override
    public XPathVariableResolver getXPathVariableResolver() {
        return xPathVariableResolver;
    }

    @Override
    public XPathFunctionResolver getXPathFunctionResolver() {
        return xPathFunctionResolver;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof XPathConfigImpl)) return false;
        XPathConfigImpl that = (XPathConfigImpl) o;
        return xPathFactory.equals(that.xPathFactory) &&
                Objects.equals(xPathVariableResolver, that.xPathVariableResolver) &&
                Objects.equals(xPathFunctionResolver, that.xPathFunctionResolver);
    }

    @Override
    public int hashCode() {
        return Objects.hash(xPathFactory, xPathVariableResolver, xPathFunctionResolver);
    }

    @Override
    public String toString() {
        final StringBuilder sb = new StringBuilder("XPathConfig{");
        sb.append("xPathFactory=").append(xPathFactory);
        sb.append(", xPathVariableResolver=").append(xPathVariableResolver);
        sb.append(", xPathFunctionResolver=").append(xPathFunctionResolver);
        sb.append('}');
        return sb.toString();
    }
}
