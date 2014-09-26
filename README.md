#ph-schematron

ph-schematron is a Java library that validates XML documents via [ISO Schematron](http://www.schematron.com). It offers several different possibilities to perform this task where each solution offers its own advantages and disadvantages that are outlined below in more detail. ph-schematron only supports ISO Schematron and no other Schematron version.
The most common way is to convert the source Schematron file to an XSLT script and apply this XSLT on the XML document to be validated. Alternatively ph-schematron offers a native implementation for the Schematron XPath binding which offers superior performance over the XSLT approach but has some other minor limitations.

#Maven usage
Add the following to your pom.xml to use this artifact:
```
<dependency>
  <groupId>com.helger</groupId>
  <artifactId>ph-schematron</artifactId>
  <version>2.8.3</version>
</dependency>
```

#News and noteworthy

  * Since version 2.8.3 there is an easy way to use XQuery functions (like funcx library)
    as custom XPath functions

# Prerequisites
It is assumed that you have a basic knowledge what Schematron is, and what Schematron can do for you. A good introduction can be found in Dave Pawsons Schematron tutorial at http://www.dpawson.co.uk/schematron/.
It is also assumed that you have basic knowledge of the Java language, so that you can understand the code examples, that you have at least basic understanding of XSLT (Extensible Stylesheet Language Transformations) and that you have good knowledge of XML itself.

# XML document validation
The goal of Schematron is to provide validation mechanisms for XML documents that are beyond DTD and XML Schema. DTD and XML Schema both purely test the structure and the data types of the content of an XML document whereas Schematron can check relations and structure of an XML document.
The most basic type of validation is to check, if an XML document confirms to a set of Schematron rules or not. So the output of the basic check is either "true" - meaning the XML document conforms to the Schematron rules - or "false" - meaning that the XML document does not conform to the Schematron rules. Additionally Schematron defines a result document type called "SVRL" which is short for "Schematron Validation Report Language". It is a more complex, XML-based result that outlines exactly what assertions failed and what reports succeeded. ph-schematron is capable of performing both types of validation.

## Validation via XSLT
The proposed way to perform a Schematron validation is to apply a set of three pre-defined XSLT scripts onto a Schematron file. After these transformations the original Schematron rule set has been transformed into an XSLT script itself, which can then be applied onto XML documents for validation. The output of this validation is an SVRL document. Because the pre-compilation step from Schematron to XSLT is very time consuming (it can take many minutes for a mid-sized Schematron rule set), it is strongly suggested to cache the resulting XSLT script, as it can be applied to all XML documents to be validated. Please note that the created Schematron XSLT scripts differ when you choose a special Schematron phase!
ph-schematron ships with a special Apache Maven plugin called [ph-schematron2xslt-maven-plugin](https://github.com/phax/ph-sch2xslt-maven-plugin) that can be used to create the XSLT scripts from Schematron files during build time. It is described in more detail below.

## Validation via Pure Schematron
As an alternative to the XSLT-based approach, ph-schematron provides a pure Java implementation which will be referred to as "Pure Schematron" within this document. With Pure Schematron the same results can be achieved as with the XSLT approach: basic validity checks and SVRL output documents.
The advantage of Pure Schematron is that you don't need to apply the timely conversion to XSLT before you can start validating. The internal steps for validating an XML document with Pure Schematron are the following:

  1. Read the Schematron resource from a file or a URL or create it manually. When reading an existing Schematron resource, all Schematron includes are resolved, so that one large Schematron document is created.
  2. Determine the query binding to be used. ph-schematron ships with a standard XPath binding that will be used if none is specified.
  3. Now the Schematron needs to be pre-processed, to resolve abstract patterns, abstract rules and perform variable replacement.
  4. Finally the pre-processed Schematron must be "bound". In this step a Schematron phase can be selected which should be used. When the default query binding is used, all XPath expressions are pre-compiled so that they can be evaluated faster. When you supply your own query binding, you need to make sure to create an efficient representation to use as a bound schema.
  5. This created bound schema can now be used to validate arbitrary XML documents. Ideally it should also be cached like the XSLT script from above, because the XPath compilation is kind of costly, but by far not as costly as the XSLT creation.

Pure Schematron is designed for maximum extensibility, meaning that you can create your own query binding, configure the reading and pre-processing of Schematron objects etc. The drawbacks of Pure Schematron are currently:

  * Include handling, as it works only when you read a Schematron from a resource and not if you create your Schematron from scratch. If you have this in mind when creating your Schematron files it should not affect you much.
  * XML attributes and elements from other namespaces are read from an existing Schematron resource but they have no impact on the validation process itself when the default query binding is used. If you have an idea how this can be solved in a proper way, please drop me an email.

Additionally ph-schematron gives you the possibility to write a Schematron rule set easily to disk, it offers the possibility to check whether a Schematron is minified, preprocessed and valid. It also supports validating a Schematron resource against the RelaxNG Compact scheme with the additional library called “ph-schematron-validator”. This library was externalized because it is not used in any regular workflow and brings a lot of additional dependencies.
    