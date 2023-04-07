<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<transform xmlns="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <ns0:Description xmlns:ns0="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
    <ns1:creator xmlns:ns1="http://purl.org/dc/terms/">
      <ns1:Agent>
        <ns2:prefLabel xmlns:ns2="http://www.w3.org/2004/02/skos/core#">SchXslt/1.9.5 SAXON/HE 11.4</ns2:prefLabel>
        <ns2:schxslt.compile.typed-variables xmlns:ns2="https://doi.org/10.5281/zenodo.1495494#">true</ns2:schxslt.compile.typed-variables>
      </ns1:Agent>
    </ns1:creator>
    <ns1:created xmlns:ns1="http://purl.org/dc/terms/">2023-02-22T09:22:26.1725479+01:00</ns1:created>
  </ns0:Description>
  <output indent="yes" />
  <key match="/cellar-book/cat:wine-catalog/cat:wine" name="colors" use="cat:properties/cat:color" />
  <template match="root()">
    <variable as="element()?" name="metadata" />
    <variable as="element(schxslt:report)" name="report">
      <ns0:report xmlns:ns0="https://doi.org/10.5281/zenodo.1495494">
        <call-template name="w21176aab7" />
      </ns0:report>
    </variable>
    <variable as="node()*" name="schxslt:report">
      <sequence select="$metadata" />
      <for-each select="$report/schxslt:document">
        <for-each select="schxslt:pattern">
          <sequence select="node()" />
          <sequence select="../schxslt:rule[@pattern = current()/@id]/node()" />
        </for-each>
      </for-each>
    </variable>
    <ns0:schematron-output xmlns:ns0="http://purl.oclc.org/dsdl/svrl" title="Validation using Schematron rules">
      <ns0:ns-prefix-in-attribute-values prefix="cat" uri="http://www.iro.umontreal.ca/lapalme/wine-catalog" />
      <sequence select="$schxslt:report" />
    </ns0:schematron-output>
  </template>
  <template match="text() | @*" mode="#all" priority="-10" />
  <template match="/" mode="#all" priority="-10">
    <apply-templates mode="#current" select="node()" />
  </template>
  <template match="*" mode="#all" priority="-10">
    <apply-templates mode="#current" select="@*" />
    <apply-templates mode="#current" select="node()" />
  </template>
  <template name="w21176aab7">
    <ns0:document xmlns:ns0="https://doi.org/10.5281/zenodo.1495494">
      <ns0:pattern id="w21176aab7">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w21176aab9">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w21176aac11">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w21176aac13">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <apply-templates mode="w21176aab7" select="root()" />
    </ns0:document>
  </template>
  <template match="wine" mode="w21176aab7" priority="3">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w21176aab7']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w21176aab7">
          <comment>WARNING: Rule for context "wine" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">wine</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w21176aab7">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">wine</attribute>
          </ns1:fired-rule>
          <if test="rating/@stars>1 and not(comment)">
            <ns1:successful-report xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">rating/@stars&gt;1 and not(comment)</attribute>
              <ns1:text> 
                There should be a comment for a wine with more than one star.
            </ns1:text>
            </ns1:successful-report>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w21176aab7')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="cellar" mode="w21176aab7" priority="2">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <variable name="nbBottles" select="sum(wine/quantity)" />
    <variable name="winesFromCellar" select="/cellar-book/cellar/wine" />
    <variable name="colors" select="/cellar-book/cat:wine-catalog/cat:wine" />
    <variable name="nbReds" select="sum($winesFromCellar[@code='red']/quantity)" />
    <variable name="nbWhites" select="sum($winesFromCellar[@code='white']/quantity)" />
    <variable name="nbRosés" select="sum($winesFromCellar[@code='rosé']/quantity)" />
    <variable name="nbColors" select="$nbReds+$nbWhites+$nbRosés" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w21176aab9']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w21176aab9">
          <comment>WARNING: Rule for context "cellar" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cellar</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w21176aab9">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cellar</attribute>
          </ns1:fired-rule>
          <if test="$nbBottles &lt; 10">
            <ns1:successful-report xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">$nbBottles &lt; 10</attribute>
              <ns1:text>
                Only <value-of select="$nbBottles" /> bottles left in the cellar.
            </ns1:text>
            </ns1:successful-report>
          </if>
          <if test="not($nbReds>$nbColors div 3)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">$nbReds&gt;$nbColors div 3</attribute>
              <ns1:text>
                Not enough reds (<value-of select="$nbReds" /> over 
                <value-of select="$nbColors" />) left in the cellar.
            </ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not($nbWhites>$nbColors div 4)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">$nbWhites&gt;$nbColors div 4</attribute>
              <ns1:text>
                Not enough whites (<value-of select="$nbWhites" /> over 
                <value-of select="$nbColors" />) left in the cellar.
            </ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not($nbRosés>$nbColors div 4)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">$nbRosés&gt;$nbColors div 4</attribute>
              <ns1:text>
                Not enough rosés (<value-of select="$nbRosés" /> over 
                <value-of select="$nbColors" />) left in the cellar.
            </ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not($nbBottles=$nbColors)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">$nbBottles=$nbColors</attribute>
              <ns1:text>
                Inconsistent count of bottles: total is <value-of select="$nbBottles" /> 
                but the count by colors is <value-of select="$nbColors" />: 
                (<value-of select="$nbReds" /> reds, <value-of select="$nbWhites" /> 
                whites and <value-of select="$nbRosés" /> rosés).
            </ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w21176aab9')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="comment|cat:comment|cat:food-pairing|cat:tasting-note" mode="w21176aab7" priority="1">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w21176aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w21176aac11">
          <comment>WARNING: Rule for context "comment|cat:comment|cat:food-pairing|cat:tasting-note" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">comment|cat:comment|cat:food-pairing|cat:tasting-note</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w21176aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">comment|cat:comment|cat:food-pairing|cat:tasting-note</attribute>
          </ns1:fired-rule>
          <if test="starts-with(cat:bold,' ') or                            substring(cat:bold,string-length(cat:bold))=' '">
            <ns1:successful-report xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">starts-with(cat:bold,' ') or                            substring(cat:bold,string-length(cat:bold))=' '</attribute>
              <ns1:text>
                A <value-of select="name(cat:bold)" /> element within a <value-of select="name()" /> 
                should not start or end with a space.
            </ns1:text>
            </ns1:successful-report>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w21176aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="comment|cat:comment|cat:food-pairing|cat:tasting-note" mode="w21176aab7" priority="0">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w21176aac13']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w21176aac13">
          <comment>WARNING: Rule for context "comment|cat:comment|cat:food-pairing|cat:tasting-note" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">comment|cat:comment|cat:food-pairing|cat:tasting-note</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w21176aac13">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">comment|cat:comment|cat:food-pairing|cat:tasting-note</attribute>
          </ns1:fired-rule>
          <if test="starts-with(cat:emph,' ') or                            substring(cat:emph,string-length(cat:emph))=' '">
            <ns1:successful-report xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">starts-with(cat:emph,' ') or                            substring(cat:emph,string-length(cat:emph))=' '</attribute>
              <ns1:text>
                A <value-of select="name(cat:emph)" /> element within a <value-of select="name()" /> 
                should not start or end with a space.
            </ns1:text>
            </ns1:successful-report>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w21176aac13')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <function as="xs:string" name="schxslt:location">
    <param as="node()" name="node" />
    <variable as="xs:string*" name="segments">
      <for-each select="($node/ancestor-or-self::node())">
        <variable name="position">
          <number level="single" />
        </variable>
        <choose>
          <when test=". instance of element()">
            <value-of select="concat('Q{', namespace-uri(.), '}', local-name(.), '[', $position, ']')" />
          </when>
          <when test=". instance of attribute()">
            <value-of select="concat('@Q{', namespace-uri(.), '}', local-name(.))" />
          </when>
          <when test=". instance of processing-instruction()">
            <value-of select="concat('processing-instruction(&quot;', name(.), '&quot;)[', $position, ']')" />
          </when>
          <when test=". instance of comment()">
            <value-of select="concat('comment()[', $position, ']')" />
          </when>
          <when test=". instance of text()">
            <value-of select="concat('text()[', $position, ']')" />
          </when>
          <otherwise />
        </choose>
      </for-each>
    </variable>
    <value-of select="concat('/', string-join($segments, '/'))" />
  </function>
</transform>
