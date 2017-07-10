# ph-schematron

ph-schematron is a Java library that validates XML documents via [ISO Schematron](http://www.schematron.com).
It is licensed under Apache 2.0 license.

Schematron is now also on GitHub: https://github.com/Schematron 
It offers several different possibilities to perform this task where each solution offers its own advantages and disadvantages that are outlined below in more detail. ph-schematron only supports ISO Schematron and no other Schematron version.
The most common way is to convert the source Schematron file to an XSLT script and apply this XSLT on the XML document to be validated. Alternatively ph-schematron offers a native implementation for the Schematron XPath binding which offers superior performance over the XSLT approach but has some other minor limitations.

Continue reading the **full documentation** at http://phax.github.io/ph-schematron/.

## News and noteworthy

  * v4.3.2 - work in progress
    * Updated to Saxon-HE 9.8.0-3
    * Changed all XSLT scripts to use and create only XSLT 2.0 (because Saxon 9.8.x does not support XSLT 1.0 anymore)
  * v4.3.1 - 2017-05-29
    * Updated to ph-commons 8.6.5
    * Fixed too verbose logging of created XSLT
    * Removed some old deprecated methods
  * v4.3.0 - 2017-05-15
    * Updated to Saxon-HE 9.7.0-18
    * Fixed an error with nested SVRL directories in Maven plugin (#37)
    * Added possibility to use "negative" tests in Maven plugin (#38)
    * Added ANT plugin to validate Schematron resources (#39, #40)
    * Using the EntityResolver also for the XML files to be validated (not just the Schematron)
    * Added a default `EntityResolver` and a default `URIResolver` that tries to resolve includes relative to the base Schematron.
  * v4.2.2 - 2017-02-22
    * Updated to Saxon-HE 9.7.0-15
    * Fixed usage of `<let>` in `<extend>`-based rules for the pure implementation (#36)
  * v4.2.1 - 2017-01-20
    * Added WrappedCollectingPSErrorHandler
  * v4.2.0 - 2017-01-09
    * Binds to ph-commons 8.6.0
    * Updated to Saxon-HE 9.7.0-14
    * Added a new Schematron validation Maven plugin
  * v4.1.1 - 2016-11-03
    * Added possibility to use XML EntityResolver (#30)
    * Updated to Saxon-HE 9.7.0-10
  * v4.1.0 - 2016-09-09
    * Binding to ph-commons 8.5.x
  * v4.0.2 - 2016-07-22
  * v4.0.1 - 2016-07-05
    * better integration of sch2xslt Maven plugin into m2e - thanks to @baerrach
  * v4.0.0 - 2016-06-15
    * updated to JDK8
    * updated to Saxon-HE 9.7
  * v3.0.1 - 2015-10-14
    * keep diagnostics in Pure version; resource resolving emits to error handler
  * v3.0.0 - 2015-07-29
    * because of update to ph-commons 6.0.0; extended XSLT based API 
  * v2.9.2 - 2015-03-12
    * because of update to ph-commons 5.6.0 
  * v2.9.1 - 2015-02-03
    * fixes a classloader issue added in 2.9.0
  * v2.9.0 - 2015-01-30
    * introduced new APIs in several places
    * updated to Saxon-HE 9.6
  * v2.8.4 - 2014-10-30    
  * v2.8.3 - 2014-09-16
    * An easy way to use XQuery functions (like funcx library) as custom XPath functions was added
  * v2.8.2 - 2014-09-02
  * v2.8.1 - 2014-08-29
  * v2.8.0 - 2014-08-28

## Usage with Maven
The dependency for ph-schematron looks like this:
```xml
<dependency>
  <groupId>com.helger</groupId>
  <artifactId>ph-schematron</artifactId>
  <version>4.3.1</version>
</dependency>
```
It transitively contains [ph-commons](https://github.com/phax/ph-commons), [SLF4J](http://www.slf4j.org/) and [Saxon HE](http://saxon.sourceforge.net/).

# ph-sch2xslt-maven-plugin

Maven plugin to convert Schematron (SCH) to XSLT at compile time using [ph-schematron](https://github.com/phax/ph-schematron) as the converter.

The conversion of Schematron to XSLT is quite costly. That’s why this Maven plugin that does the conversion at build time. 

By default the plugin is run in the Maven lifecycle phase *generate-resources*. The basic configuration of the plugin in the `pom.xml` looks like this (inside the `<build>/<plugins>` element):
```xml
<plugin>
  <groupId>com.helger.maven</groupId>
  <artifactId>ph-sch2xslt-maven-plugin</artifactId>
  <version>4.3.1</version>
  <executions>
    <execution>
      <goals>
        <goal>convert</goal>
      </goals>
    </execution>
  </executions>
</plugin>
```
The possible configuration parameters are:
  * `schematronDirectory` - The directory where the Schematron files reside. Defaults to `${basedir}/src/main/schematron`.
  * `schematronPattern` - A pattern for the Schematron files. Can contain Ant-style wildcards and double wildcards. All files that match the pattern will be converted. Files in the `schematronDirectory` and its subdirectories will be considered. Default is `**/*.sch`.
  * `xsltDirectory` - The directory where the XSLT files will be saved. Default is `${basedir}/src/main/xslt`.
  * `xsltExtension` - The file extension of the created XSLT files. Default is `.xslt`.
  * `overwriteWithoutQuestion` - Overwrite existing Schematron files without notice? If this is set to `false` than existing XSLT files are not overwritten. Default is `true`.
  * `phaseName` - Define the phase to be used for XSLT creation. By default the `defaultPhase` attribute of the Schematron file is used.
  * `languageCode` - Define the language code for the XSLT creation. Default is `null` which means English. Supported language codes are: cs, de, en, fr, nl.

# ph-schematron-maven-plugin

Maven plugin to validate XML files against convert Schematron (SCH) at compile time using [ph-schematron](https://github.com/phax/ph-schematron) as the validator.

This plugin was introduced in version 4.2.0.

By default the plugin is run in the Maven lifecycle phase *process-resources*. The basic configuration of the plugin in the `pom.xml` looks like this (inside the `<build>/<plugins>` element):
```xml
<plugin>
  <groupId>com.helger.maven</groupId>
  <artifactId>ph-schematron-maven-plugin</artifactId>
  <version>4.3.1</version>
  <executions>
    <execution>
      <goals>
        <goal>validate</goal>
      </goals>
    </execution>
  </executions>
</plugin>
```
The possible configuration parameters are:
  * `schematronFile` - The Schematron file to be applied. This parameter is mandatory.
  * `schematronProcessingEngine` - The Schematron processing engine to be used. Can be one of `pure` (pure implementation), `schematron` (Schematron to XSLT engine) and `xslt` (pre-compiled XSLT files available). Default is `pure`.
  * `xmlDirectory` - The directory where the XML files to be validated are contained. It is expected that the XML files in this directory match the Schematron rules. Either this parameter or `xmlErrorDirectory` parameter are mandatory.
  * `xmlIncludes` - A pattern for the XML files to be included. Can contain Ant-style wildcards and double wildcards. All files that match the pattern will be validated. Files in the `xmlDirectory` and its subdirectories will be considered. Default is `**/*.xml`.
  * `xmlExcludes` - A pattern for the XML files to be excluded. Can contain Ant-style wildcards and double wildcards. All files that match the pattern will **NOT** be validated. Files in the `xmlDirectory` and its subdirectories will be considered.
  * `svrlDirectory` - The directory where the SVRL (Schematron Validation Report Language) files will be saved. If this property is not specified, no SVRL files will be written. By default the name of the SVRL file corresponds to the XML file that is validated (defined by the parameters `xmlDirectory`, `xmlIncludes` and `xmlExcludes`) with the suffix `.svrl`.
  * `xmlErrorDirectory` (since v4.3.0) - The directory where the XML files to be validated are contained. It is expected that the XML files in this directory do **not** match the Schematron rules. Either this parameter or `xmlDirectory` parameter are mandatory.
  * `xmlErrorIncludes` (since v4.3.0) - A pattern for the erroneous XML files to be included. Can contain Ant-style wildcards and double wildcards. All files that match the pattern will be validated. Files in the `xmlDirectory` and its subdirectories will be considered. Default is `**/*.xml`.
  * `xmlErrorExcludes` (since v4.3.0) - A pattern for the erroneous XML files to be excluded. Can contain Ant-style wildcards and double wildcards. All files that match the pattern will **NOT** be validated. Files in the `xmlDirectory` and its subdirectories will be considered.
  * `svrlErrorDirectory` (since v4.3.0) - The directory where the erroneous SVRL files will be saved. If this property is not specified, no SVRL files will be written. By default the name of the SVRL file corresponds to the XML file that is validated (defined by the parameters `xmlErrorDirectory`, `xmlErrorIncludes` and `xmlErrorExcludes`) with the suffix `.svrl`.
  * `phaseName` - Define the phase to be used for XSLT creation. By default the `defaultPhase` attribute of the Schematron file is used.
  * `languageCode` - Define the language code for the XSLT creation. Default is `null` which means English. Supported language codes are: cs, de, en, fr, nl.


# ph-schematron-validator

A validator for Schematron definitions based on RelaxNG definition.

## Usage with Maven
Add the following to your pom.xml to use this artifact:
```
<dependency>
  <groupId>com.helger</groupId>
  <artifactId>ph-schematron-validator</artifactId>
  <version>4.3.1</version>
</dependency>
```

# Ant task

Since ph-schematron 4.3.0 there is an Apache Ant task that enables you to validate XML files against Schematron rules.
As I'm not an Ant expert please forgive me if some of the explanations are not 100% accurate.

## Declare the task

There is currently only one task:
```xml
<taskdef name="schematron" classname="com.helger.schematron.ant.Schematron" />
```

For this Ant Task to be available you need to include the `ph-schematron-ant-task` "JAR with dependencies" in your classpath.
Alternatively you can use the `classpath` attribute to reference a classpath that is defined internally in the build script. 

## Validate an XML file

The validation itself looks like this:
```xml
  <target name="validate">
...
    <schematron schematronFile="sample_schematron.sch" expectSuccess="true">
      <fileset dir="xml">
        <include name="*.xml" />
        <exclude name="err*.xml" />
      </fileset>
    </schematron>
...
  </target>
```

Basically you declare the Schematron file (relative to the project's base directory),
define whether you expect a successful validation or failures,
and finally you name the XML files to be validated (as resource collections - e.g. Filesets).

The `schematron` element allows for the following attributes:
  * `File` **schematronFile** - The Schematron file to be used for validation
  * `String` **schematronProcessingEngine** - The internal engine to be used. Must be one of `pure`, `schematron` or `xslt`. The default is `schematron`.
  * `File` **svrlDirectory** - An optional directory where the SVRL files should be written to.
  * `String` **phaseName** - The optional Schematron phase to be used. Note: this is only available when using the processing engine `pure` or `schematron`. For engine `xslt` this is not available because this was defined when the XSLT was created.
  * `String` **languageCode** - The optional language code to be used. Note: this is only available when using the processing engine `schematron`. For engine `xslt` this is not available because this was defined when the XSLT was created. Default is English (en). Supported language codes are: cs, de, en, fr, nl.
  * `boolean` **expectSuccess** - `true` to expect successful validation, `false` to expect validation errors. If the expectation is incorrect, the build will fail.
  
Additionally you can use an `XMLCatalog` that acts as an Entity and URI resolver both for the Schematron and the XML files to be validated! See https://ant.apache.org/manual/Types/xmlcatalog.html for details on the XML catalog. Here is an example that shows how to use an inline XML catalog:

```xml
  <target name="validate">
    <schematron schematronFile="../sch/test.sch" 
                expectSuccess="true"
                schematronProcessingEngine="pure">
      <fileset dir=".">
        <include name="test.xml" />
      </fileset>
      <xmlcatalog>
        <dtd publicId="-//bla//DTD XML test//EN" location="../dtd/test.dtd"/>
      </xmlcatalog>
    </schematron>
  </target>
```

---

My personal [Coding Styleguide](https://github.com/phax/meta/blob/master/CodeingStyleguide.md) |
On Twitter: <a href="https://twitter.com/philiphelger">@philiphelger</a>
