<?xml version="1.0" encoding="UTF-8"?>
<!--
  Triggers the attributes SchXslt 1 copies from the Schematron to the SVRL:
  xml:* on schema, pattern, rule, assert, report, diagnostic, property and
  p; see, icon and fpi on rule, assert, report and property; id, class and
  icon on p; and xml:* on dir, emph and span. Use together with
  schxslt-svrl-extensions.xml.
-->
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        queryBinding="xslt2"
        xml:lang="en"
        xml:space="default">
  <title>Rich attributes</title>
  <p id="p1" class="intro" icon="intro.png" xml:lang="en">A paragraph with <emph xml:lang="en">emphasis</emph></p>
  <pattern id="P1" xml:lang="en">
    <rule id="R1" context="/root" role="ruleRole" flag="ruleFlag" see="rule.html" icon="rule.png" fpi="rule-fpi" xml:lang="en">
      <assert id="A1" test="b" role="error" see="assert.html" icon="assert.png" fpi="assert-fpi" xml:lang="en" diagnostics="D1" properties="PR1">There must be a <dir value="ltr" xml:lang="en">b</dir></assert>
      <report id="S1" test="a" role="info" see="report.html" icon="report.png" fpi="report-fpi" xml:lang="de" diagnostics="D1">Es gibt ein <span class="el" xml:lang="de">a</span></report>
    </rule>
  </pattern>
  <properties>
    <property id="PR1" role="propRole" scheme="propScheme" see="prop.html" icon="prop.png" fpi="prop-fpi" xml:lang="en">A property</property>
  </properties>
  <diagnostics>
    <diagnostic id="D1" role="diagRole" see="diag.html" icon="diag.png" fpi="diag-fpi" xml:lang="en" xml:space="preserve">A diagnostic</diagnostic>
  </diagnostics>
</schema>
