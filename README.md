#ph-schematron

ph-schematron is a Java library that validates XML documents via [ISO Schematron](http://www.schematron.com). It offers several different possibilities to perform this task where each solution offers its own advantages and disadvantages that are outlined below in more detail. ph-schematron only supports ISO Schematron and no other Schematron version.
The most common way is to convert the source Schematron file to an XSLT script and apply this XSLT on the XML document to be validated. Alternatively ph-schematron offers a native implementation for the Schematron XPath binding which offers superior performance over the XSLT approach but has some other minor limitations.

##News and noteworthy

  * Since version 2.8.3 there is an easy way to use XQuery functions (like funcx library)
    as custom XPath functions

## Prerequisites
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

Additionally ph-schematron gives you the possibility to write a Schematron rule set easily to disk, it offers the possibility to check whether a Schematron is minified, preprocessed and valid. It also supports validating a Schematron resource against the RelaxNG Compact scheme with the additional library called [ph-schematron-validator](https://github.com/phax/ph-schematron-validator). This library was externalized because it is not used in any regular workflow and brings a lot of additional dependencies.

# Technical details
ph-schematron is an operating system independent Java 1.6 library. As the underlying XPath Engine [SaxonHE 9.5.1.6](http://saxon.sourceforge.net/) is used. Compared to [Apache Xalan 2.7.1](http://xml.apache.org/xalan-j/) it offers more XPath functions out of the box. ph-schematron also depends on the OSS library [ph-commons](https://github.com/phax/ph-commons).

As the determination of the XPath engine is triggered by JAXP also the debugging mechanisms of JAXP must be used, to determine which XPath engine is effectively used. The simplest way to do this is to set the system property `jaxp.debug` to `true` before starting to work with Schematron. In this case the console will contain log messages that show what `XPathFactory` was loaded.

ph-schematron is built as an OSGI bundle via the org.apache.felix:maven-bundle-plugin.
The full code of the examples used in this document can be found in the file [DocumentationExamples.java](https://github.com/phax/ph-schematron/blob/master/src/test/java/com/helger/schematron/docs/DocumentationExamples.java).

## Usage with Maven
ph-schematron is build with Apache Maven. If you want to build it from source, at least Maven 3.0.4 is required. The dependency for ph-schematron looks like this:
```
<dependency>
  <groupId>com.helger</groupId>
  <artifactId>ph-schematron</artifactId>
  <version>2.8.3</version>
</dependency>
```
It transitively contains ph-commons, SLF4J and Saxon HE.

## Common API
A common API for both XSLT and Pure Schematron approach is available via the `com.helger.schematron.ISchematronResource` interface. It is meant for Schematron that is read from a file or URL. It offers the possibility to check if the read Schematron is valid itself via the `boolean isValidSchematron ()` method.

To check if an XML document simply matches a Schematron rule set the methods `com.helger.commons.state.EValidity getSchematronValidity(…)` are provided. These methods deliver either `EValidity.VALID` if the XML document matches the Schematron or `EValidity.INVALID` if the XML document does not match at least one Schematron rule. With this method you have no possibility to determine what the error exactly was. When using an XSLT based implementation this method does not offer any performance improvement, as the SVRL is fully created and analyzed afterwards. When using a Pure Schematron based implementation, the validation stops after the first error and does not continue to validate the supplied XML document.

Alternatively to the basic validation the interface also offers the possibility to create an SVRL result via the methods `org.w3c.dom.Document applySchematronValidation(…)` and `org.oclc.purl.dsdl.svrl.SchematronOutputType applySchematronValidationToSVRL(…)`. The first method type creates the SVRL only as an XML document node, where the second method type applies a JAXB binding, so that it is easier to access the information inside the SVRL. Internally these methods call each other depending on the concrete implementation, so they are ensured to deliver exactly the same result. The XSLT implementation is natively done in `applySchematronValidation` and then converted to a `SchematronOutputType` using the `com.helger.schematron.svrl.SVRLReader` class. With Pure Schematron a `SchematronOutputType` object is directly created and then converted to an XML document node via the class `com.helger.schematron.svrl.SVRLWriter`.

The classes `SVRLReader` and `SVRLWriter` can generically be used to read and write SVRL files in a structured way. Both classes validate the SVRL based on SVRL XML Schema contained in the library.

### Validation via XSLT
As described above it is highly recommended to cache the XSLT script that is created from the source Schematron rule set. Nevertheless ph-schematron offers both possibilities to use Schematron.

The easiest way to start working is by starting from a Schematron file. `com.helger.schematron.xslt.SchematronResourceSCH` is the implementation of the `ISchematronResource` interface to be used for this. The constructor takes at the least the Schematron resource that contains the rules. When using this class it is possibly to specify an optional Schematron phase to be used for validation. Additionally some static factory methods are present that allow creating `SchematronResourceSCH objects` from a `String` path or a `java.io.File` object.

If a precompiled XSLT script is present (e.g. via the schematron2xslt Maven plugin or via manual pre-processing) the implementation class `com.helger.schematron.xslt.SchematronResourceXSLT` should be instantiated. It offers the same constructors and factory methods as the `SchematronResourceSCH` class. Please recall that the chosen phase already affected the created XSLT script, so it is not possible to specify a phase when using this implementation.

Both implementations use an internal cache that keeps the created pre-precompiled `javax.xml.transform.Templates` objects in memory while the application is running. The cache for `SchematronResourceSCH` is located in the class `com.helger.schematron.xslt.SchematronResourceSCHCache` whereas the cache for `SchematronResourceXSLT` is located in the class `com.helger.schematron.xslt.SchematronResourceXSLTCache` – big surprise :)

A simple example to validate an XML file (to `true` or `false`) based on Schematron rules from a file looks like this:
```java
public static boolean validateXMLViaXSLTSchematron (@Nonnull final File aSchematronFile, @Nonnull final File aXMLFile) throws Exception
{
  final ISchematronResource aResSCH = SchematronResourceSCH.fromFile (aSchematronFile);
  if (!aResSCH.isValidSchematron ())
    throw new IllegalArgumentException ("Invalid Schematron!");
  return aResSCH.getSchematronValidity (new StreamSource(aXMLFile)).isValid ();
}
```
The same example but creating a real SVRL output looks like this:
```java
public static SchematronOutputType validateXMLViaXSLTSchematronFull (@Nonnull final File aSchematronFile, @Nonnull final File aXMLFile) throws Exception
{
  final ISchematronResource aResSCH = SchematronResourceSCH.fromFile (aSchematronFile);
  if (!aResSCH.isValidSchematron ())
    throw new IllegalArgumentException ("Invalid Schematron!");
  return aResSCH.applySchematronValidationToSVRL (new StreamSource (aXMLFile));
}
```
The difference to the simple example is that instead of the method `getSchematronValidity` the method `applySchematronValidationToSVRL` is invoked.


    