package com.helger.schematron.config;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.xml.xpath.XPathFactory;
import javax.xml.xpath.XPathFactoryConfigurationException;
import javax.xml.xpath.XPathFunctionResolver;
import javax.xml.xpath.XPathVariableResolver;
import java.lang.reflect.InvocationTargetException;

public class XPathConfigBuilder {

    private static final Class<?>[] EMPTY_CLASS_ARRAY = new Class<?>[0];

    private static final Object[] EMPTY_OBJECT_ARRAY = new Object[0];

    private Class<? extends XPathFactory> xPathFactoryClass;

    private XPathVariableResolver xPathVariableResolver;

    private XPathFunctionResolver xPathFunctionResolver;

    public XPathConfigBuilder() {
    }

    public Class<? extends XPathFactory> getxPathFactoryClass() {
        return xPathFactoryClass;
    }

    public XPathVariableResolver getxPathVariableResolver() {
        return xPathVariableResolver;
    }

    public XPathFunctionResolver getxPathFunctionResolver() {
        return xPathFunctionResolver;
    }

    public XPathConfigBuilder setXPathFactoryClass(@Nonnull Class<? extends XPathFactory> xPathFactoryClass) {
        this.xPathFactoryClass = xPathFactoryClass;
        return this;
    }

    public XPathConfigBuilder setXPathVariableResolver(@Nullable XPathVariableResolver xPathVariableResolver) {
        this.xPathVariableResolver = xPathVariableResolver;
        return this;
    }

    public XPathConfigBuilder setXPathFunctionResolver(@Nullable XPathFunctionResolver xPathFunctionResolver) {
        this.xPathFunctionResolver = xPathFunctionResolver;
        return this;
    }

    public XPathConfig build() throws XPathFactoryConfigurationException {
        XPathFactory aXPathFactory = null;
        if (xPathFactoryClass != null) {
            try {
                aXPathFactory = xPathFactoryClass.getConstructor(EMPTY_CLASS_ARRAY)
                        .newInstance(EMPTY_OBJECT_ARRAY);
            } catch (InstantiationException e) {
                throw new XPathFactoryConfigurationException(e);
            } catch (IllegalAccessException e) {
                throw new XPathFactoryConfigurationException(e);
            } catch (InvocationTargetException e) {
                throw new XPathFactoryConfigurationException(e.getCause());
            } catch (NoSuchMethodException e) {
                throw new XPathFactoryConfigurationException(e);
            }
        } else {
            // DEFAULT as fallback
            aXPathFactory = XPathConfigs.SAXON_FIRST;
        }
        XPathConfig result = new XPathConfigImpl(aXPathFactory, xPathVariableResolver, xPathFunctionResolver);
        return result;
    }
}
