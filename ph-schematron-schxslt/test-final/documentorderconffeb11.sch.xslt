<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<transform xmlns="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <ns0:Description xmlns:ns0="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
    <ns1:creator xmlns:ns1="http://purl.org/dc/terms/">
      <ns1:Agent>
        <ns2:prefLabel xmlns:ns2="http://www.w3.org/2004/02/skos/core#">SchXslt/1.9.4 SAXON/HE 11.4</ns2:prefLabel>
        <ns2:schxslt.compile.typed-variables xmlns:ns2="https://doi.org/10.5281/zenodo.1495494#">true</ns2:schxslt.compile.typed-variables>
      </ns1:Agent>
    </ns1:creator>
    <ns1:created xmlns:ns1="http://purl.org/dc/terms/">2022-11-17T08:43:08+01:00</ns1:created>
  </ns0:Description>
  <output indent="yes" />
  <template match="root()">
    <variable as="element()?" name="metadata">
      <ns0:metadata xmlns:ns0="http://purl.oclc.org/dsdl/svrl">
        <ns1:creator xmlns:ns1="http://purl.org/dc/terms/">
          <ns1:Agent>
            <ns2:prefLabel xmlns:ns2="http://www.w3.org/2004/02/skos/core#">
              <value-of select="(system-property('xsl:product-name'), system-property('xsl:product-version'))" separator="/" />
            </ns2:prefLabel>
          </ns1:Agent>
        </ns1:creator>
        <ns1:created xmlns:ns1="http://purl.org/dc/terms/">
          <value-of select="current-dateTime()" />
        </ns1:created>
        <ns1:source xmlns:ns1="http://purl.org/dc/terms/">
          <ns2:Description xmlns:ns2="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
            <ns1:creator>
              <ns1:Agent>
                <ns3:prefLabel xmlns:ns3="http://www.w3.org/2004/02/skos/core#">SchXslt/1.9.4 SAXON/HE 11.4</ns3:prefLabel>
                <ns3:schxslt.compile.typed-variables xmlns:ns3="https://doi.org/10.5281/zenodo.1495494#">true</ns3:schxslt.compile.typed-variables>
              </ns1:Agent>
            </ns1:creator>
            <ns1:created>2022-11-17T08:43:08+01:00</ns1:created>
          </ns2:Description>
        </ns1:source>
      </ns0:metadata>
    </variable>
    <variable as="element(schxslt:report)" name="report">
      <ns0:report xmlns:ns0="https://doi.org/10.5281/zenodo.1495494">
        <call-template name="w705aac17" />
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
    <ns0:schematron-output xmlns:ns0="http://purl.oclc.org/dsdl/svrl" schemaVersion="iso" title="Schematron for DocumentOrderConfirmation">
      <ns0:ns-prefix-in-attribute-values prefix="p1" uri="http://erpel.at/schemas/1p0/documents" />
      <ns0:ns-prefix-in-attribute-values prefix="ext" uri="http://erpel.at/schemas/1p0/documents/ext" />
      <ns0:ns-prefix-in-attribute-values prefix="pharmaceuticals" uri="http://erpel.at/schemas/1p0/documents/extensions/pharmaceuticals" />
      <ns0:ns-prefix-in-attribute-values prefix="telecom" uri="http://erpel.at/schemas/1p0/documents/extensions/telecom" />
      <ns0:ns-prefix-in-attribute-values prefix="dsig" uri="http://www.w3.org/2000/09/xmldsig#" />
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
  <template name="w705aac17">
    <ns0:document xmlns:ns0="https://doi.org/10.5281/zenodo.1495494">
      <ns0:pattern id="w705aac17">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w705aac21">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w705aac25">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w705aac29">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w705aac33">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w705aac37">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w705aac41">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w705aac45">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w705aac49">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w705aac53">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w705aac57">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w705aac61">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w705aac65">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w705aac69">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w705aac73">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w705aac77">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w705aac81">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w705aac85">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w705aac89">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w705aac93">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w705aac97">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w705aad101">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w705aad105">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <apply-templates mode="w705aac17" select="root()" />
    </ns0:document>
  </template>
  <template match="/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem" mode="w705aac17" priority="22">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w705aac17']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac17">
          <comment>WARNING: Rule for context "/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac17">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem</attribute>
          </ns1:fired-rule>
          <if test="not(p1:TaxRate)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">p1:TaxRate</attribute>
              <ns1:text>
					Regel 1: Das Element '/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:TaxRate' muss in diesem Kontext auftreten.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w705aac17')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem" mode="w705aac17" priority="21">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w705aac21']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac21">
          <comment>WARNING: Rule for context "/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac21">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem</attribute>
          </ns1:fired-rule>
          <if test="not(p1:UnitPrice)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">p1:UnitPrice</attribute>
              <ns1:text>
	Regel 2: Das Element 'p1:UnitPrice' ist in diesem Kontext erforderlich.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w705aac21')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:TaxRate" mode="w705aac17" priority="20">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w705aac25']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac25">
          <comment>WARNING: Rule for context "/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:TaxRate" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:TaxRate</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac25">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:TaxRate</attribute>
          </ns1:fired-rule>
          <if test="not(@p1:TaxCode)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">@p1:TaxCode</attribute>
              <ns1:text>
				Regel 3: Das Attribut '/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:TaxRate/@p1:TaxCode' ist in diesem Kontext erforderlich.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w705aac25')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/p1:Document/p1:PaymentConditions/p1:Discount" mode="w705aac17" priority="19">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w705aac29']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac29">
          <comment>WARNING: Rule for context "/p1:Document/p1:PaymentConditions/p1:Discount" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:PaymentConditions/p1:Discount</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac29">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:PaymentConditions/p1:Discount</attribute>
          </ns1:fired-rule>
          <if test="not(p1:PaymentDate)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">p1:PaymentDate</attribute>
              <ns1:text>
					Regel 4: Das Element '/p1:Document/p1:PaymentConditions/p1:Discount/p1:PaymentDate' muss genau 1 mal auftreten.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(p1:Percentage)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">p1:Percentage</attribute>
              <ns1:text>
					Regel 5: Das Element ''/p1:Document/p1:PaymentConditions/p1/PaymentDate/p1:Percentage' muss genau 1 mal auftreten.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w705aac29')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/p1:Document/p1:ReductionDetails/p1:Reduction" mode="w705aac17" priority="18">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w705aac33']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac33">
          <comment>WARNING: Rule for context "/p1:Document/p1:ReductionDetails/p1:Reduction" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:ReductionDetails/p1:Reduction</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac33">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:ReductionDetails/p1:Reduction</attribute>
          </ns1:fired-rule>
          <if test="not(p1:TaxRate)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">p1:TaxRate</attribute>
              <ns1:text>
					Regel 6: Das Element '/p1:Document/p1:ReductionDetails/p1:Reduction/p1:TaxRate' muss in diesem Kontext auftreten.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w705aac33')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/p1:Document/p1:ReductionDetails/p1:Reduction/p1:TaxRate" mode="w705aac17" priority="17">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w705aac37']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac37">
          <comment>WARNING: Rule for context "/p1:Document/p1:ReductionDetails/p1:Reduction/p1:TaxRate" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:ReductionDetails/p1:Reduction/p1:TaxRate</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac37">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:ReductionDetails/p1:Reduction/p1:TaxRate</attribute>
          </ns1:fired-rule>
          <if test="not(@p1:TaxCode)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">@p1:TaxCode</attribute>
              <ns1:text>
					Regel 7: Das Attribut '/p1:Document/p1:ReductionDetails/p1:Reduction/p1:TaxRate/@p1:TaxCode' ist in diesem Kontext erforderlich.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w705aac37')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/p1:Document/p1:Tax/p1:VAT/p1:Item" mode="w705aac17" priority="16">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w705aac41']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac41">
          <comment>WARNING: Rule for context "/p1:Document/p1:Tax/p1:VAT/p1:Item" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Tax/p1:VAT/p1:Item</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac41">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Tax/p1:VAT/p1:Item</attribute>
          </ns1:fired-rule>
          <if test="not(p1:TaxRate)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">p1:TaxRate</attribute>
              <ns1:text>
					Regel 8: Das Element '/p1:Document/p1:Tax/p1:VAT/p1:Item/p1:TaxRate' muss in diesem Kontext auftreten.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w705aac41')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/p1:Document/p1:Tax/p1:VAT/p1:Item/p1:TaxRate" mode="w705aac17" priority="15">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w705aac45']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac45">
          <comment>WARNING: Rule for context "/p1:Document/p1:Tax/p1:VAT/p1:Item/p1:TaxRate" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Tax/p1:VAT/p1:Item/p1:TaxRate</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac45">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Tax/p1:VAT/p1:Item/p1:TaxRate</attribute>
          </ns1:fired-rule>
          <if test="not(@p1:TaxCode)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">@p1:TaxCode</attribute>
              <ns1:text>
					Regel 9: Das Attribut '/p1:Document/p1:Tax/p1:VAT/p1:Item/p1:TaxRate/@p1:TaxCode' ist in diesem Kontext erforderlich.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w705aac45')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/p1:Document/p1:Supplier/p1:Address" mode="w705aac17" priority="14">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w705aac49']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac49">
          <comment>WARNING: Rule for context "/p1:Document/p1:Supplier/p1:Address" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Supplier/p1:Address</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac49">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Supplier/p1:Address</attribute>
          </ns1:fired-rule>
          <if test="not(p1:Street or p1:POBox)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">p1:Street or p1:POBox</attribute>
              <ns1:text>
			   Regel 10: Straße oder POBox wurde in Document/Supplier/Address nicht angegeben.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w705aac49')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/p1:Document/p1:Customer/p1:Address" mode="w705aac17" priority="13">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w705aac53']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac53">
          <comment>WARNING: Rule for context "/p1:Document/p1:Customer/p1:Address" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Customer/p1:Address</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac53">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Customer/p1:Address</attribute>
          </ns1:fired-rule>
          <if test="not(p1:Street or p1:POBox)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">p1:Street or p1:POBox</attribute>
              <ns1:text>
			   Regel 11: Straße oder POBox wurde in DocumentCustomer/Address nicht angegeben.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w705aac53')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/p1:Document/p1:OrderingParty/p1:Address" mode="w705aac17" priority="12">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w705aac57']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac57">
          <comment>WARNING: Rule for context "/p1:Document/p1:OrderingParty/p1:Address" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:OrderingParty/p1:Address</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac57">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:OrderingParty/p1:Address</attribute>
          </ns1:fired-rule>
          <if test="not(p1:Street or p1:POBox)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">p1:Street or p1:POBox</attribute>
              <ns1:text>
			   Regel 12: Straße oder POBox wurde in Document/OrderingParty/Address nicht angegeben.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w705aac57')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/p1:Document/p1:Shipper/p1:Address" mode="w705aac17" priority="11">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w705aac61']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac61">
          <comment>WARNING: Rule for context "/p1:Document/p1:Shipper/p1:Address" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Shipper/p1:Address</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac61">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Shipper/p1:Address</attribute>
          </ns1:fired-rule>
          <if test="not(p1:Street or p1:POBox)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">p1:Street or p1:POBox</attribute>
              <ns1:text>
			   Regel 13: Straße oder POBox wurde in Document/:Shipper/Address nicht angegeben.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w705aac61')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/p1:Document/p1:Delivery/p1:DeliveryRecipient/p1:Address" mode="w705aac17" priority="10">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w705aac65']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac65">
          <comment>WARNING: Rule for context "/p1:Document/p1:Delivery/p1:DeliveryRecipient/p1:Address" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Delivery/p1:DeliveryRecipient/p1:Address</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac65">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Delivery/p1:DeliveryRecipient/p1:Address</attribute>
          </ns1:fired-rule>
          <if test="not(p1:Street or p1:POBox)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">p1:Street or p1:POBox</attribute>
              <ns1:text>
			   Regel 14: Straße oder POBox wurde in Document/Delivery/DeliveryRecipient/Address nicht angegeben.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w705aac65')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:ArticleNumber" mode="w705aac17" priority="9">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w705aac69']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac69">
          <comment>WARNING: Rule for context "/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:ArticleNumber" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:ArticleNumber</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac69">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:ArticleNumber</attribute>
          </ns1:fired-rule>
          <if test="not(p1:SuppliersArticleNumber or p1:CustomersArticleNumber)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">p1:SuppliersArticleNumber or p1:CustomersArticleNumber</attribute>
              <ns1:text>
			   Regel 15: Eine Artikelnummer wurde in Document/Details/ItemList/ListLineItem/ArticleNumber nicht angegeben.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w705aac69')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/p1:Document/p1:Delivery/p1:DeliveryDetails" mode="w705aac17" priority="8">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w705aac73']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac73">
          <comment>WARNING: Rule for context "/p1:Document/p1:Delivery/p1:DeliveryDetails" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Delivery/p1:DeliveryDetails</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac73">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Delivery/p1:DeliveryDetails</attribute>
          </ns1:fired-rule>
          <if test="not(not(p1:Date and p1:Period))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">not(p1:Date and p1:Period)</attribute>
              <ns1:text>
			   Regel 16: Die Angabe von Date UND Period ist in Document/Details/ItemList/ListLineItem/Delivery/DeliveryDetails unzulässig.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w705aac73')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/p1:Document/p1:Delivery/p1:DeliveryDetails/p1:Period" mode="w705aac17" priority="7">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w705aac77']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac77">
          <comment>WARNING: Rule for context "/p1:Document/p1:Delivery/p1:DeliveryDetails/p1:Period" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Delivery/p1:DeliveryDetails/p1:Period</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac77">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Delivery/p1:DeliveryDetails/p1:Period</attribute>
          </ns1:fired-rule>
          <if test="not(@p1:FromDate and @p1:ToDate)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">@p1:FromDate and @p1:ToDate</attribute>
              <ns1:text>
			   Regel 17: Die Attribute FromDate und ToDate müssen in 'p1:Document/p1:Delivery/p1:DeliveryDetails/p1:Period' angegeben werden.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w705aac77')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails" mode="w705aac17" priority="6">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w705aac81']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac81">
          <comment>WARNING: Rule for context "/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac81">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails</attribute>
          </ns1:fired-rule>
          <if test="not(not(p1:Date and p1:Period))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">not(p1:Date and p1:Period)</attribute>
              <ns1:text>
			   Regel 18: Die Angabe von Date UND Period ist in Document/Details/ItemList/ListLineItem/Delivery/DeliveryDetails unzulässig.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w705aac81')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails/p1:Period" mode="w705aac17" priority="5">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w705aac85']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac85">
          <comment>WARNING: Rule for context "/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails/p1:Period" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails/p1:Period</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac85">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails/p1:Period</attribute>
          </ns1:fired-rule>
          <if test="not(@p1:FromDate and @p1:ToDate)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">@p1:FromDate and @p1:ToDate</attribute>
              <ns1:text>
			   Regel 19: Die Attribute FromDate und ToDate müssen in 'p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails/p1:Period' angegeben werden.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w705aac85')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem" mode="w705aac17" priority="4">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w705aac89']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac89">
          <comment>WARNING: Rule for context "/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac89">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem</attribute>
          </ns1:fired-rule>
          <if test="not(p1:ListLineItemReduction and (p1:ListLineItemReduction/p1:ReductionAmount or p1:ListLineItemReduction/p1:ReductionRate))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">p1:ListLineItemReduction and (p1:ListLineItemReduction/p1:ReductionAmount or p1:ListLineItemReduction/p1:ReductionRate)</attribute>
              <ns1:text>
			   Regel 20: Das Element ListLineItemReduction ist in Document/Details/ItemList/ListLineItem nicht vorhanden und muss entweder ein Element ReductionAmount oder ein Element ReductionRate enthalten.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w705aac89')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem" mode="w705aac17" priority="3">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w705aac93']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac93">
          <comment>WARNING: Rule for context "/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac93">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem</attribute>
          </ns1:fired-rule>
          <if test="not(p1:DiscountFlag)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">p1:DiscountFlag</attribute>
              <ns1:text>
			   Regel 21: Eine DiscountFlag muß in Document/Details/ItemList/ListLineItem angegeben werden.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w705aac93')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem" mode="w705aac17" priority="2">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w705aac97']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac97">
          <comment>WARNING: Rule for context "/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aac97">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem</attribute>
          </ns1:fired-rule>
          <if test="not(p1:UnitPrice)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">p1:UnitPrice</attribute>
              <ns1:text>
			   Regel 22: Ein UnitPrice muß in Document/Details/ItemList/ListLineItem angegeben werden.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w705aac97')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/p1:Document" mode="w705aac17" priority="1">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w705aad101']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aad101">
          <comment>WARNING: Rule for context "/p1:Document" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aad101">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document</attribute>
          </ns1:fired-rule>
          <if test="not(p1:TotalGrossAmount)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">p1:TotalGrossAmount</attribute>
              <ns1:text>
			   Regel 23: Ein TotalGrossAmount muß in Document angegeben werden.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w705aad101')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/p1:Document" mode="w705aac17" priority="0">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w705aad105']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aad105">
          <comment>WARNING: Rule for context "/p1:Document" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w705aad105">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/p1:Document</attribute>
          </ns1:fired-rule>
          <if test="not(@p1:DocumentType='OrderConfirmation')">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">@p1:DocumentType='OrderConfirmation'</attribute>
              <ns1:text>
			  Regel 24: Der DocumentType entspricht nicht einer OrderConfirmation</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w705aad105')" />
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
