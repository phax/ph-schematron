#ph-schematron

Java Schematron library that applies Schematron rules onto XML document.
It supports XSLT and native (pure) application onto the XML.

There is also a [Schematron to XSLT Maven plugin](https://github.com/phax/ph-sch2xslt-maven-plugin) available.

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
    