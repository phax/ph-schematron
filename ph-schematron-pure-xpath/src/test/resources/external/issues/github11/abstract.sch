<?xml version="1.0" encoding="UTF-8"?>
<pattern name="AbstractRules" id="abstracts" xmlns="http://purl.oclc.org/dsdl/schematron">
  <rule abstract="true" id="lengthCheck">
    <assert test="string-length(A) &lt;=10">
      A exceeds 10 characters
    </assert>
    <assert test="string-length(B) &lt;=5">
      B exceeds 5 characters
    </assert>
  </rule>
</pattern>