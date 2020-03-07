package com.helger.schematron.config;

import javax.xml.xpath.XPathFactory;
import javax.xml.xpath.XPathFunctionResolver;
import javax.xml.xpath.XPathVariableResolver;
import java.util.Objects;

public class XPathConfig {

    private final XPathFactory xPathFactory;

    private final XPathVariableResolver xPathVariableResolver;

    private final XPathFunctionResolver xPathFunctionResolver;

    public XPathConfig(XPathFactory xPathFactory, XPathVariableResolver xPathVariableResolver,
                       XPathFunctionResolver xPathFunctionResolver) {
        this.xPathFactory = xPathFactory;
        this.xPathVariableResolver = xPathVariableResolver;
        this.xPathFunctionResolver = xPathFunctionResolver;
    }

    public XPathFactory getXPathFactory() {
        return xPathFactory;
    }

    public XPathVariableResolver getXPathVariableResolver() {
        return xPathVariableResolver;
    }

    public XPathFunctionResolver getXPathFunctionResolver() {
        return xPathFunctionResolver;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof XPathConfig)) return false;
        XPathConfig that = (XPathConfig) o;
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
