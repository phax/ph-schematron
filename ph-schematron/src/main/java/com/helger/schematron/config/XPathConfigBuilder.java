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

    private String globalXPathFactory;

    private XPathVariableResolver xPathVariableResolver;

    private XPathFunctionResolver xPathFunctionResolver;

    public XPathConfigBuilder() {
    }

    public Class<? extends XPathFactory> getxPathFactoryClass() {
        return xPathFactoryClass;
    }

    public String getGlobalXPathFactory() {
        return globalXPathFactory;
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

    /**
     * With Java 11+ module path system, you can't access
     * @link{com.sun.org.apache.xpath.internal.jaxp.XPathFactoryImpl} as
     * 'package com.sun.org.apache.xpath.internal.jaxp is declared in module java.xml, which does not export it'.
     * <p>
     * The only way to use it, is to set/alter the 'javax.xml.xpath.XPathFactory' system property. However, this change is
     * <emph>global</emph> to the application.
     * </p>
     *
     * @param globalXPathFactory
     *        Fully qualified class name of the 'default' {@link XPathFactory}. Most commonly set to
     *        'com.sun.org.apache.xpath.internal.jaxp.XPathFactoryImpl'.
     */
    public XPathConfigBuilder setGlobalXPathFactory(String globalXPathFactory) {
        this.globalXPathFactory = globalXPathFactory;
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
        if (globalXPathFactory != null) {
            System.setProperty("javax.xml.xpath.XPathFactory", globalXPathFactory);
        }
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
        } else if (globalXPathFactory != null) {
            aXPathFactory = XPathFactory.newInstance();
        } else {
            // DEFAULT as fallback
            aXPathFactory = XPathConfigs.SAXON_FIRST;
        }
        XPathConfig result = new XPathConfigImpl(aXPathFactory, xPathVariableResolver, xPathFunctionResolver);
        return result;
    }
}
