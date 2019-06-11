<?xml version="1.0" encoding="UTF-8"?>
<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform"
            version="2.0"
            xmlns:nf="http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#NDRFunctions">
  <function name="nf:get-document-element" as="element()">
    <param name="context" as="element()"/>
    <sequence select="root($context)/*"/>
  </function>
</stylesheet>
