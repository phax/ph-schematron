#ph-schematron

ph-schematron is a Java library that validates XML documents via [ISO Schematron](http://www.schematron.com).

*ph-schematron* is the successor of *phloc-schematron* and all further development happens here. 

It offers several different possibilities to perform this task where each solution offers its own advantages and disadvantages that are outlined below in more detail. ph-schematron only supports ISO Schematron and no other Schematron version.
The most common way is to convert the source Schematron file to an XSLT script and apply this XSLT on the XML document to be validated. Alternatively ph-schematron offers a native implementation for the Schematron XPath binding which offers superior performance over the XSLT approach but has some other minor limitations.

Continue reading the **full documentation** at http://phax.github.io/ph-schematron/.

##News and noteworthy

  * Since version 2.8.3 there is an easy way to use XQuery functions (like funcx library)
    as custom XPath functions

## Usage with Maven
The dependency for ph-schematron looks like this:
```
<dependency>
  <groupId>com.helger</groupId>
  <artifactId>ph-schematron</artifactId>
  <version>2.9.0</version>
</dependency>
```
It transitively contains [ph-commons](https://github.com/phax/ph-commons), [SLF4J](http://www.slf4j.org/) and [Saxon HE](http://saxon.sourceforge.net/).

---

On Twitter: <a href="https://twitter.com/philiphelger">Follow @philiphelger</a>
