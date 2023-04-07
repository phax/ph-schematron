<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<transform xmlns="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <ns0:Description xmlns:ns0="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
    <ns1:creator xmlns:ns1="http://purl.org/dc/terms/">
      <ns1:Agent>
        <ns2:prefLabel xmlns:ns2="http://www.w3.org/2004/02/skos/core#">SchXslt/1.9.4 SAXON/HE 11.4</ns2:prefLabel>
        <ns2:schxslt.compile.typed-variables xmlns:ns2="https://doi.org/10.5281/zenodo.1495494#">true</ns2:schxslt.compile.typed-variables>
      </ns1:Agent>
    </ns1:creator>
    <ns1:created xmlns:ns1="http://purl.org/dc/terms/">2022-11-17T08:43:07.306+01:00</ns1:created>
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
            <ns1:created>2022-11-17T08:43:07.306+01:00</ns1:created>
          </ns2:Description>
        </ns1:source>
      </ns0:metadata>
    </variable>
    <variable as="element(schxslt:report)" name="report">
      <ns0:report xmlns:ns0="https://doi.org/10.5281/zenodo.1495494">
        <call-template name="w432aac13" />
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
    <ns0:schematron-output xmlns:ns0="http://purl.oclc.org/dsdl/svrl" title="BIIRULES T10 bound to Facturae">
      <ns0:ns-prefix-in-attribute-values prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
      <ns0:ns-prefix-in-attribute-values prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
      <ns0:ns-prefix-in-attribute-values prefix="facturae" uri="http://www.facturae.es/Facturae/2009/v3.2/Facturae" />
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
  <template name="w432aac13">
    <ns0:document xmlns:ns0="https://doi.org/10.5281/zenodo.1495494">
      <ns0:pattern id="w432aac13">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl" id="Codes-T10" name="Codes-T10">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w432aac15">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl" id="FACTURAE-T10" name="FACTURAE-T10">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <apply-templates mode="w432aac13" select="root()" />
    </ns0:document>
  </template>
  <template match="cbc:DocumentCurrencyCode" mode="w432aac13" priority="21">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w432aac13']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac13">
          <comment>WARNING: Rule for context "cbc:DocumentCurrencyCode" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cbc:DocumentCurrencyCode</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac13">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cbc:DocumentCurrencyCode</attribute>
          </ns1:fired-rule>
          <if test="not(contains('�AED�AFN�ALL�AMD�ANG�AOA�ARS�AUD�AWG�AZN�BAM�BBD�BDT�BGN�BHD�BIF�BMD�BND�BOB�BOV�BRL�BSD�BTN�BWP�BYR�BZD�CAD�CDF�CHE�CHF�CHW�CLF�CLP�CNY�COP�COU�CRC�CUP�CVE�CZK�DJF�DKK�DOP�DZD�EEK�EGP�ERN�ETB�EUR�FJD�FKP�GBP�GEL�GHS�GIP�GMD�GNF�GTQ�GWP�GYD�HKD�HNL�HRK�HTG�HUF�IDR�ILS�INR�IQD�IRR�ISK�JMD�JOD�JPY�KES�KGS�KHR�KMF�KPW�KRW�KWD�KYD�KZT�LAK�LBP�LKR�LRD�LSL�LTL�LVL�LYD�MAD�MDL�MGA�MKD�MMK�MNT�MOP�MRO�MUR�MVR�MWK�MXN�MXV�MYR�MZN�NAD�NGN�NIO�NOK�NPR�NZD�OMR�PAB�PEN�PGK�PHP�PKR�PLN�PYG�QAR�RON�RSD�RUB�RWF�SAR�SBD�SCR�SDG�SEK�SGD�SHP�SKK�SLL�SOS�SRD�STD�SVC�SYP�SZL�THB�TJS�TMM�TND�TOP�TRY�TTD�TWD�TZS�UAH�UGX�USD�USN�USS�UYI�UYU�UZS�VEF�VND�VUV�WST�XAF�XAG�XAU�XBA�XBB�XBC�XBD�XCD�XDR�XFU�XOF�XPD�XPF�XTS�XXX�YER�ZAR�ZMK�ZWD�ZWR�',concat('�',.,'�')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">contains('�AED�AFN�ALL�AMD�ANG�AOA�ARS�AUD�AWG�AZN�BAM�BBD�BDT�BGN�BHD�BIF�BMD�BND�BOB�BOV�BRL�BSD�BTN�BWP�BYR�BZD�CAD�CDF�CHE�CHF�CHW�CLF�CLP�CNY�COP�COU�CRC�CUP�CVE�CZK�DJF�DKK�DOP�DZD�EEK�EGP�ERN�ETB�EUR�FJD�FKP�GBP�GEL�GHS�GIP�GMD�GNF�GTQ�GWP�GYD�HKD�HNL�HRK�HTG�HUF�IDR�ILS�INR�IQD�IRR�ISK�JMD�JOD�JPY�KES�KGS�KHR�KMF�KPW�KRW�KWD�KYD�KZT�LAK�LBP�LKR�LRD�LSL�LTL�LVL�LYD�MAD�MDL�MGA�MKD�MMK�MNT�MOP�MRO�MUR�MVR�MWK�MXN�MXV�MYR�MZN�NAD�NGN�NIO�NOK�NPR�NZD�OMR�PAB�PEN�PGK�PHP�PKR�PLN�PYG�QAR�RON�RSD�RUB�RWF�SAR�SBD�SCR�SDG�SEK�SGD�SHP�SKK�SLL�SOS�SRD�STD�SVC�SYP�SZL�THB�TJS�TMM�TND�TOP�TRY�TTD�TWD�TZS�UAH�UGX�USD�USN�USS�UYI�UYU�UZS�VEF�VND�VUV�WST�XAF�XAG�XAU�XBA�XBB�XBC�XBD�XCD�XDR�XFU�XOF�XPD�XPF�XTS�XXX�YER�ZAR�ZMK�ZWD�ZWR�',concat('�',.,'�'))</attribute>
              <ns1:text>[CL-010-002]-DocumentCurrencyCode MUST be coded using ISO code list 4217</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w432aac13')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="@currencyID" mode="w432aac13" priority="20">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w432aac13']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac13">
          <comment>WARNING: Rule for context "@currencyID" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">@currencyID</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac13">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">@currencyID</attribute>
          </ns1:fired-rule>
          <if test="not(contains('�AED�AFN�ALL�AMD�ANG�AOA�ARS�AUD�AWG�AZN�BAM�BBD�BDT�BGN�BHD�BIF�BMD�BND�BOB�BOV�BRL�BSD�BTN�BWP�BYR�BZD�CAD�CDF�CHE�CHF�CHW�CLF�CLP�CNY�COP�COU�CRC�CUP�CVE�CZK�DJF�DKK�DOP�DZD�EEK�EGP�ERN�ETB�EUR�FJD�FKP�GBP�GEL�GHS�GIP�GMD�GNF�GTQ�GWP�GYD�HKD�HNL�HRK�HTG�HUF�IDR�ILS�INR�IQD�IRR�ISK�JMD�JOD�JPY�KES�KGS�KHR�KMF�KPW�KRW�KWD�KYD�KZT�LAK�LBP�LKR�LRD�LSL�LTL�LVL�LYD�MAD�MDL�MGA�MKD�MMK�MNT�MOP�MRO�MUR�MVR�MWK�MXN�MXV�MYR�MZN�NAD�NGN�NIO�NOK�NPR�NZD�OMR�PAB�PEN�PGK�PHP�PKR�PLN�PYG�QAR�RON�RSD�RUB�RWF�SAR�SBD�SCR�SDG�SEK�SGD�SHP�SKK�SLL�SOS�SRD�STD�SVC�SYP�SZL�THB�TJS�TMM�TND�TOP�TRY�TTD�TWD�TZS�UAH�UGX�USD�USN�USS�UYI�UYU�UZS�VEF�VND�VUV�WST�XAF�XAG�XAU�XBA�XBB�XBC�XBD�XCD�XDR�XFU�XOF�XPD�XPF�XTS�XXX�YER�ZAR�ZMK�ZWD�ZWR�',concat('�',.,'�')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">contains('�AED�AFN�ALL�AMD�ANG�AOA�ARS�AUD�AWG�AZN�BAM�BBD�BDT�BGN�BHD�BIF�BMD�BND�BOB�BOV�BRL�BSD�BTN�BWP�BYR�BZD�CAD�CDF�CHE�CHF�CHW�CLF�CLP�CNY�COP�COU�CRC�CUP�CVE�CZK�DJF�DKK�DOP�DZD�EEK�EGP�ERN�ETB�EUR�FJD�FKP�GBP�GEL�GHS�GIP�GMD�GNF�GTQ�GWP�GYD�HKD�HNL�HRK�HTG�HUF�IDR�ILS�INR�IQD�IRR�ISK�JMD�JOD�JPY�KES�KGS�KHR�KMF�KPW�KRW�KWD�KYD�KZT�LAK�LBP�LKR�LRD�LSL�LTL�LVL�LYD�MAD�MDL�MGA�MKD�MMK�MNT�MOP�MRO�MUR�MVR�MWK�MXN�MXV�MYR�MZN�NAD�NGN�NIO�NOK�NPR�NZD�OMR�PAB�PEN�PGK�PHP�PKR�PLN�PYG�QAR�RON�RSD�RUB�RWF�SAR�SBD�SCR�SDG�SEK�SGD�SHP�SKK�SLL�SOS�SRD�STD�SVC�SYP�SZL�THB�TJS�TMM�TND�TOP�TRY�TTD�TWD�TZS�UAH�UGX�USD�USN�USS�UYI�UYU�UZS�VEF�VND�VUV�WST�XAF�XAG�XAU�XBA�XBB�XBC�XBD�XCD�XDR�XFU�XOF�XPD�XPF�XTS�XXX�YER�ZAR�ZMK�ZWD�ZWR�',concat('�',.,'�'))</attribute>
              <ns1:text>[CL-010-003]-currencyID MUST be coded using ISO code list 4217</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w432aac13')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="cac:Country//cbc:IdentificationCode" mode="w432aac13" priority="19">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w432aac13']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac13">
          <comment>WARNING: Rule for context "cac:Country//cbc:IdentificationCode" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:Country//cbc:IdentificationCode</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac13">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:Country//cbc:IdentificationCode</attribute>
          </ns1:fired-rule>
          <if test="not(contains('�AD�AE�AF�AG�AI�AL�AM�AN�AO�AQ�AR�AS�AT�AU�AW�AX�AZ�BA�BB�BD�BE�BF�BG�BH�BI�BJ�BL�BM�BN�BO�BR�BS�BT�BV�BW�BY�BZ�CA�CC�CD�CF�CG�CH�CI�CK�CL�CM�CN�CO�CR�CU�CV�CX�CY�CZ�DE�DJ�DK�DM�DO�DZ�EC�EE�EG�EH�ER�ES�ET�FI�FJ�FK�FM�FO�FR�GA�GB�GD�GE�GF�GG�GH�GI�GL�GM�GN�GP�GQ�GR�GS�GT�GU�GW�GY�HK�HM�HN�HR�HT�HU�ID�IE�IL�IM�IN�IO�IQ�IR�IS�IT�JE�JM�JO�JP�KE�KG�KH�KI�KM�KN�KP�KR�KW�KY�KZ�LA�LB�LC�LI�LK�LR�LS�LT�LU�LV�LY�MA�MC�MD�ME�MF�MG�MH�MK�ML�MM�MN�MO�MP�MQ�MR�MS�MT�MU�MV�MW�MX�MY�MZ�NA�NC�NE�NF�NG�NI�NL�NO�NP�NR�NU�NZ�OM�PA�PE�PF�PG�PH�PK�PL�PM�PN�PR�PS�PT�PW�PY�QA�RO�RS�RU�RW�SA�SB�SC�SD�SE�SG�SH�SI�SJ�SK�SL�SM�SN�SO�SR�ST�SV�SY�SZ�TC�TD�TF�TG�TH�TJ�TK�TL�TM�TN�TO�TR�TT�TV�TW�TZ�UA�UG�UM�US�UY�UZ�VA�VC�VE�VG�VI�VN�VU�WF�WS�YE�YT�ZA�ZM�ZW�',concat('�',.,'�')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">contains('�AD�AE�AF�AG�AI�AL�AM�AN�AO�AQ�AR�AS�AT�AU�AW�AX�AZ�BA�BB�BD�BE�BF�BG�BH�BI�BJ�BL�BM�BN�BO�BR�BS�BT�BV�BW�BY�BZ�CA�CC�CD�CF�CG�CH�CI�CK�CL�CM�CN�CO�CR�CU�CV�CX�CY�CZ�DE�DJ�DK�DM�DO�DZ�EC�EE�EG�EH�ER�ES�ET�FI�FJ�FK�FM�FO�FR�GA�GB�GD�GE�GF�GG�GH�GI�GL�GM�GN�GP�GQ�GR�GS�GT�GU�GW�GY�HK�HM�HN�HR�HT�HU�ID�IE�IL�IM�IN�IO�IQ�IR�IS�IT�JE�JM�JO�JP�KE�KG�KH�KI�KM�KN�KP�KR�KW�KY�KZ�LA�LB�LC�LI�LK�LR�LS�LT�LU�LV�LY�MA�MC�MD�ME�MF�MG�MH�MK�ML�MM�MN�MO�MP�MQ�MR�MS�MT�MU�MV�MW�MX�MY�MZ�NA�NC�NE�NF�NG�NI�NL�NO�NP�NR�NU�NZ�OM�PA�PE�PF�PG�PH�PK�PL�PM�PN�PR�PS�PT�PW�PY�QA�RO�RS�RU�RW�SA�SB�SC�SD�SE�SG�SH�SI�SJ�SK�SL�SM�SN�SO�SR�ST�SV�SY�SZ�TC�TD�TF�TG�TH�TJ�TK�TL�TM�TN�TO�TR�TT�TV�TW�TZ�UA�UG�UM�US�UY�UZ�VA�VC�VE�VG�VI�VN�VU�WF�WS�YE�YT�ZA�ZM�ZW�',concat('�',.,'�'))</attribute>
              <ns1:text>[CL-010-004]-Country codes in an invoice MUST be coded using ISO code list 3166-1</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w432aac13')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="cac:TaxScheme//cbc:ID" mode="w432aac13" priority="18">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w432aac13']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac13">
          <comment>WARNING: Rule for context "cac:TaxScheme//cbc:ID" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:TaxScheme//cbc:ID</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac13">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:TaxScheme//cbc:ID</attribute>
          </ns1:fired-rule>
          <if test="not(contains('�AAA�AAB�AAC�AAD�AAE�AAF�AAG�AAH�AAI�AAJ�AAK�AAL�ADD�BOL�CAP�CAR�COC�CST�CUD�CVD�ENV�EXC�EXP�FET�FRE�GCN�GST�ILL�IMP�IND�LAC�LCN�LDP�LOC�LST�MCA�MCD�OTH�PDB�PDC�PRF�SCN�SSS�STT�SUP�SUR�SWT�TAC�TOT�TOX�TTA�VAD�VAT�',concat('�',.,'�')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">contains('�AAA�AAB�AAC�AAD�AAE�AAF�AAG�AAH�AAI�AAJ�AAK�AAL�ADD�BOL�CAP�CAR�COC�CST�CUD�CVD�ENV�EXC�EXP�FET�FRE�GCN�GST�ILL�IMP�IND�LAC�LCN�LDP�LOC�LST�MCA�MCD�OTH�PDB�PDC�PRF�SCN�SSS�STT�SUP�SUR�SWT�TAC�TOT�TOX�TTA�VAD�VAT�',concat('�',.,'�'))</attribute>
              <ns1:text>[CL-010-005]-Invoice tax schemes MUST be coded using UN/ECE 5153 code list</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w432aac13')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="cac:PaymentMeans//cbc:PaymentMeansCode" mode="w432aac13" priority="17">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w432aac13']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac13">
          <comment>WARNING: Rule for context "cac:PaymentMeans//cbc:PaymentMeansCode" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:PaymentMeans//cbc:PaymentMeansCode</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac13">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:PaymentMeans//cbc:PaymentMeansCode</attribute>
          </ns1:fired-rule>
          <if test="not(contains('�1�10�11�12�13�14�15�16�17�18�19�2�20�21�22�23�24�25�26�27�28�29�3�30�31�32�33�34�35�36�37�38�39�4�40�41�42�43�44�45�46�47�48�49�5�50�51�52�53�6�60�61�62�63�64�65�66�67�7�70�74�75�76�77�78�8�9�91�92�93�94�95�96�97�',concat('�',.,'�')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">contains('�1�10�11�12�13�14�15�16�17�18�19�2�20�21�22�23�24�25�26�27�28�29�3�30�31�32�33�34�35�36�37�38�39�4�40�41�42�43�44�45�46�47�48�49�5�50�51�52�53�6�60�61�62�63�64�65�66�67�7�70�74�75�76�77�78�8�9�91�92�93�94�95�96�97�',concat('�',.,'�'))</attribute>
              <ns1:text>[CL-010-006]-Payment means in an invoice MUST be coded using CEFACT code list 4461</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w432aac13')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="cac:TaxCategory//cbc:ID" mode="w432aac13" priority="16">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w432aac13']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac13">
          <comment>WARNING: Rule for context "cac:TaxCategory//cbc:ID" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:TaxCategory//cbc:ID</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac13">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:TaxCategory//cbc:ID</attribute>
          </ns1:fired-rule>
          <if test="not(contains('�A�AA�AB�AC�AD�AE�B�C�E�G�H�O�S�Z�',concat('�',.,'�')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">contains('�A�AA�AB�AC�AD�AE�B�C�E�G�H�O�S�Z�',concat('�',.,'�'))</attribute>
              <ns1:text>[CL-010-007]-Invoice tax categories MUST be coded using UN/ECE 5305 code list</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w432aac13')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//Parties/BuyerParty" mode="w432aac13" priority="15">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w432aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac15">
          <comment>WARNING: Rule for context "//Parties/BuyerParty" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//Parties/BuyerParty</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//Parties/BuyerParty</attribute>
          </ns1:fired-rule>
          <if test="not(((LegalEntity/AddressInSpain/Town and LegalEntity/AddressInSpain/PostCode) or (LegalEntity/OverseasAddress/PostCodeandTown) or (Individual/AddressInSpain/Town and Individual/AddressInSpain/PostCode) or (Individual/OverseasAddress/PostCodeandTown)))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">((LegalEntity/AddressInSpain/Town and LegalEntity/AddressInSpain/PostCode) or (LegalEntity/OverseasAddress/PostCodeandTown) or (Individual/AddressInSpain/Town and Individual/AddressInSpain/PostCode) or (Individual/OverseasAddress/PostCodeandTown))</attribute>
              <ns1:text>[BIIRULE-T10-R004]-A customer address in an invoice SHOULD contain at least city and zip code or have an address identifier.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(((//CountryCode) and (preceding::SellerParty//CountryCode) and  ((//CountryCode) = (preceding::SellerParty//CountryCode) or ((//CountryCode) != (preceding::SellerParty//CountryCode) and starts-with(TaxIdentification/TaxIdentificationNumber, //CountryCode)))) or not((//CountryCode)) or not((preceding::SellerParty//CountryCode)))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">((//CountryCode) and (preceding::SellerParty//CountryCode) and  ((//CountryCode) = (preceding::SellerParty//CountryCode) or ((//CountryCode) != (preceding::SellerParty//CountryCode) and starts-with(TaxIdentification/TaxIdentificationNumber, //CountryCode)))) or not((//CountryCode)) or not((preceding::SellerParty//CountryCode))</attribute>
              <ns1:text>[BIIRULE-T10-R005]-In cross border trade the VAT identifier for the customer SHOULD be prefixed with country code.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w432aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//TaxesOutputs" mode="w432aac13" priority="14">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w432aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac15">
          <comment>WARNING: Rule for context "//TaxesOutputs" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//TaxesOutputs</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//TaxesOutputs</attribute>
          </ns1:fired-rule>
          <if test="not(./false)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">./false</attribute>
              <ns1:text>[BIIRULE-T10-R048]-Every tax category MUST be defined through an identifier.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w432aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:AdditionalDocumentReference" mode="w432aac13" priority="13">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w432aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac15">
          <comment>WARNING: Rule for context "//cac:AdditionalDocumentReference" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:AdditionalDocumentReference</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:AdditionalDocumentReference</attribute>
          </ns1:fired-rule>
          <if test="not(./false)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">./false</attribute>
              <ns1:text>[BIIRULE-T10-R037]-Any reference to a document MUST specify the document identifier.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w432aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//Items/InvoiceLine/UnitPriceWithoutTax" mode="w432aac13" priority="12">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w432aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac15">
          <comment>WARNING: Rule for context "//Items/InvoiceLine/UnitPriceWithoutTax" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//Items/InvoiceLine/UnitPriceWithoutTax</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//Items/InvoiceLine/UnitPriceWithoutTax</attribute>
          </ns1:fired-rule>
          <if test="not(number(.) >=0)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">number(.) &gt;=0</attribute>
              <ns1:text>[BIIRULE-T10-R022]-Prices of items MUST NOT be negative.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w432aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/facturae:Facturae" mode="w432aac13" priority="11">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w432aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac15">
          <comment>WARNING: Rule for context "/facturae:Facturae" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/facturae:Facturae</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/facturae:Facturae</attribute>
          </ns1:fired-rule>
          <if test="not((//InvoiceIssueData/IssueDate))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(//InvoiceIssueData/IssueDate)</attribute>
              <ns1:text>[BIIRULE-T10-R023]-An invoice MUST have the date of issue.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((//InvoiceHeader/InvoiceNumber))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(//InvoiceHeader/InvoiceNumber)</attribute>
              <ns1:text>[BIIRULE-T10-R024]-An invoice MUST have an invoice number.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((//SellerParty/LegalEntity/CorporateName) or (//SellerParty/Individual/Name))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(//SellerParty/LegalEntity/CorporateName) or (//SellerParty/Individual/Name)</attribute>
              <ns1:text>[BIIRULE-T10-R026]-An invoice MUST contain the full name of the supplier.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((//BuyerParty/LegalEntity/CorporateName) or (//BuyerParty/Individual/Name))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(//BuyerParty/LegalEntity/CorporateName) or (//BuyerParty/Individual/Name)</attribute>
              <ns1:text>[BIIRULE-T10-R027]-An invoice MUST contain the full name of the customer.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(./false)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">./false</attribute>
              <ns1:text>[BIIRULE-T10-R028]-If the VAT total amount in an invoice exists then the sum of taxable amount in sub categories MUST equal the sum of invoice tax exclusive amount.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(//SchemaVersion)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">//SchemaVersion</attribute>
              <ns1:text>[BIIRULE-T10-R029]-An invoice MUST have a syntax identifier.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(./false)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">./false</attribute>
              <ns1:text>[BIIRULE-T10-R030]-An invoice MUST have a customization identifier.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(./false)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">./false</attribute>
              <ns1:text>[BIIRULE-T10-R031]-An invoice MUST have a profile identifier.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((//Items/InvoiceLine))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(//Items/InvoiceLine)</attribute>
              <ns1:text>[BIIRULE-T10-R033]-An invoice MUST specify at least one line item.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((//InvoiceIssueData/InvoiceCurrencyCode))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(//InvoiceIssueData/InvoiceCurrencyCode)</attribute>
              <ns1:text>[BIIRULE-T10-R034]-An invoice MUST have a currency code for the document.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(./false)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">./false</attribute>
              <ns1:text>[BIIRULE-T10-R035]-Any reference to an order MUST specify the order identifier.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(./false)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">./false</attribute>
              <ns1:text>[BIIRULE-T10-R036]-Any reference to a contract MUST specify the contract identifier.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(//TotalExecutableAmount)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">//TotalExecutableAmount</attribute>
              <ns1:text>[BIIRULE-T10-R038]-An invoice MUST specify the total payable amount.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(//InvoiceTotal)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">//InvoiceTotal</attribute>
              <ns1:text>[BIIRULE-T10-R039]-An invoice MUST specify the total amount with taxes included.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(//TotalGrossAmountBeforeTaxes)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">//TotalGrossAmountBeforeTaxes</attribute>
              <ns1:text>[BIIRULE-T10-R042]-An invoice MUST specify the total amount without taxes.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(//TotalGrossAmount)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">//TotalGrossAmount</attribute>
              <ns1:text>[BIIRULE-T10-R043]-An invoice MUST specify the sum of the line amounts.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(./false)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">./false</attribute>
              <ns1:text>[BIIRULE-T10-R052]-An invoice MUST contain tax information</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w432aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//CountryCode" mode="w432aac13" priority="10">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w432aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac15">
          <comment>WARNING: Rule for context "//CountryCode" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//CountryCode</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//CountryCode</attribute>
          </ns1:fired-rule>
          <if test="not(.)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">.</attribute>
              <ns1:text>[BIIRULE-T10-R040]-Country in an address MUST be specified using the country code.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w432aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//NonExistingDummyNode" mode="w432aac13" priority="9">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w432aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac15">
          <comment>WARNING: Rule for context "//NonExistingDummyNode" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//NonExistingDummyNode</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//NonExistingDummyNode</attribute>
          </ns1:fired-rule>
          <if test="not(//Tax/TaxableBase)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">//Tax/TaxableBase</attribute>
              <ns1:text>[BIIRULE-T10-R046]-An invoice MUST specify the taxable amount per VAT subtotal.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(//Tax/TaxAmount)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">//Tax/TaxAmount</attribute>
              <ns1:text>[BIIRULE-T10-R047]-An invoice MUST specify the tax amount per VAT subtotal.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w432aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//Items/InvoiceLine" mode="w432aac13" priority="8">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w432aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac15">
          <comment>WARNING: Rule for context "//Items/InvoiceLine" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//Items/InvoiceLine</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//Items/InvoiceLine</attribute>
          </ns1:fired-rule>
          <if test="not(not(Quantity) or not(UnitPriceWithoutTax) or number(GrossAmount) = (round(number(UnitPriceWithoutTax) * number(Quantity) * 100) div 100))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">not(Quantity) or not(UnitPriceWithoutTax) or number(GrossAmount) = (round(number(UnitPriceWithoutTax) * number(Quantity) * 100) div 100)</attribute>
              <ns1:text>[BIIRULE-T10-R018]-Invoice line amount MUST be equal to the price amount multiplied by the quantity plus charges minus allowances at line level</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((//ItemDescription))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(//ItemDescription)</attribute>
              <ns1:text>[BIIRULE-T10-R025]-Each invoice line MUST contain the product/service name</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(//InvoiceHeader/InvoiceNumber)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">//InvoiceHeader/InvoiceNumber</attribute>
              <ns1:text>[BIIRULE-T10-R032]-Invoice lines MUST have a line identifier.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(//TotalCost)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">//TotalCost</attribute>
              <ns1:text>[BIIRULE-T10-R050]-Invoice lines MUST have a line total amount.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(./false)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">./false</attribute>
              <ns1:text>[BIIRULE-T10-R051]-Invoice lines MUST contain the item price</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w432aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/facturae:Facturae/Invoices/Invoice/TaxesOutputs" mode="w432aac13" priority="7">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w432aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac15">
          <comment>WARNING: Rule for context "/facturae:Facturae/Invoices/Invoice/TaxesOutputs" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/facturae:Facturae/Invoices/Invoice/TaxesOutputs</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/facturae:Facturae/Invoices/Invoice/TaxesOutputs</attribute>
          </ns1:fired-rule>
          <if test="not(count(Tax)>1 or count(Tax) = 1)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">count(Tax)&gt;1 or count(Tax) = 1</attribute>
              <ns1:text>[BIIRULE-T10-R009]-An invoice MUST have a tax total refering to a single tax scheme</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(number(following::InvoiceTotals/TotalTaxOutputs) = number(round(sum(child::Tax/TaxAmount/TotalAmount) * 100) div 100))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">number(following::InvoiceTotals/TotalTaxOutputs) = number(round(sum(child::Tax/TaxAmount/TotalAmount) * 100) div 100)</attribute>
              <ns1:text>[BIIRULE-T10-R010]-Each tax total MUST equal the sum of the tax subcategory amounts.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w432aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//LegalEntity" mode="w432aac13" priority="6">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w432aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac15">
          <comment>WARNING: Rule for context "//LegalEntity" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//LegalEntity</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//LegalEntity</attribute>
          </ns1:fired-rule>
          <if test="not(//RegistrationData)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">//RegistrationData</attribute>
              <ns1:text>[BIIRULE-T10-R041]-Company identifier MUST be specified when describing a company legal entity.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w432aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//Parties/SellerParty" mode="w432aac13" priority="5">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w432aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac15">
          <comment>WARNING: Rule for context "//Parties/SellerParty" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//Parties/SellerParty</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//Parties/SellerParty</attribute>
          </ns1:fired-rule>
          <if test="not(((LegalEntity/AddressInSpain/Town and LegalEntity/AddressInSpain/PostCode) or (LegalEntity/OverseasAddress/PostCodeandTown) or (Individual/AddressInSpain/Town and Individual/AddressInSpain/PostCode) or (Individual/OverseasAddress/PostCodeandTown)))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">((LegalEntity/AddressInSpain/Town and LegalEntity/AddressInSpain/PostCode) or (LegalEntity/OverseasAddress/PostCodeandTown) or (Individual/AddressInSpain/Town and Individual/AddressInSpain/PostCode) or (Individual/OverseasAddress/PostCodeandTown))</attribute>
              <ns1:text>[BIIRULE-T10-R002]-A supplier address in an invoice SHOULD contain at least the city name and a zip code or have an address identifier.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(((//CountryCode) and (following::BuyerParty//CountryCode) and ((//CountryCode) = (following::BuyerParty//CountryCode) or ((//CountryCode) != (following::BuyerParty//CountryCode) and starts-with(TaxIdentification/TaxIdentificationNumber, //CountryCode)))) or not(//CountryCode) or not(following::BuyerParty//CountryCode))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">((//CountryCode) and (following::BuyerParty//CountryCode) and ((//CountryCode) = (following::BuyerParty//CountryCode) or ((//CountryCode) != (following::BuyerParty//CountryCode) and starts-with(TaxIdentification/TaxIdentificationNumber, //CountryCode)))) or not(//CountryCode) or not(following::BuyerParty//CountryCode)</attribute>
              <ns1:text>[BIIRULE-T10-R003]-In cross border trade the VAT identifier for the supplier SHOULD be prefixed with country code.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w432aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//Items/InvoiceLine" mode="w432aac13" priority="4">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w432aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac15">
          <comment>WARNING: Rule for context "//Items/InvoiceLine" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//Items/InvoiceLine</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//Items/InvoiceLine</attribute>
          </ns1:fired-rule>
          <if test="not(string-length(string(//ItemDescription)) &lt;= 50)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">string-length(string(//ItemDescription)) &lt;= 50</attribute>
              <ns1:text>[BIIRULE-T10-R019]-Product names SHOULD NOT exceed 50 characters long</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(./true)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">./true</attribute>
              <ns1:text>[BIIRULE-T10-R020]-If standard identifiers are provided within an item description, a Scheme Identifier SHOULD be provided (e.g. GTIN)</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(//ArticleCode))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(//ArticleCode)</attribute>
              <ns1:text>[BIIRULE-T10-R021]-Classification codes within an item description SHOULD use a standard scheme for codes (e.g. CPV or UNSPSC)</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w432aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//InvoiceTotals" mode="w432aac13" priority="3">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w432aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac15">
          <comment>WARNING: Rule for context "//InvoiceTotals" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//InvoiceTotals</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//InvoiceTotals</attribute>
          </ns1:fired-rule>
          <if test="not(number(TotalGrossAmount) = number(round(sum(following::Items/InvoiceLine/GrossAmount) * 100) div 100))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">number(TotalGrossAmount) = number(round(sum(following::Items/InvoiceLine/GrossAmount) * 100) div 100)</attribute>
              <ns1:text>[BIIRULE-T10-R011]-Invoice total line extension amount MUST equal the sum of the line totals</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(((TotalGeneralSurcharges) and (TotalGeneralDiscounts) and (number(TotalGrossAmountBeforeTaxes) = (number(TotalGrossAmount) + number(TotalGeneralSurcharges) - number(TotalGeneralDiscounts)))) or (not(TotalGeneralSurcharges) and (TotalGeneralDiscounts) and (number(TotalGrossAmountBeforeTaxes) = number(TotalGrossAmount) - number(TotalGeneralDiscounts))) or ((TotalGeneralSurcharges) and not(TotalGeneralDiscounts) and (number(TotalGrossAmountBeforeTaxes) = number(TotalGrossAmount) + number(TotalGeneralSurcharges))) or (not(TotalGeneralSurcharges) and not(TotalGeneralDiscounts) and (number(TotalGrossAmountBeforeTaxes) = number(TotalGrossAmount))))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">((TotalGeneralSurcharges) and (TotalGeneralDiscounts) and (number(TotalGrossAmountBeforeTaxes) = (number(TotalGrossAmount) + number(TotalGeneralSurcharges) - number(TotalGeneralDiscounts)))) or (not(TotalGeneralSurcharges) and (TotalGeneralDiscounts) and (number(TotalGrossAmountBeforeTaxes) = number(TotalGrossAmount) - number(TotalGeneralDiscounts))) or ((TotalGeneralSurcharges) and not(TotalGeneralDiscounts) and (number(TotalGrossAmountBeforeTaxes) = number(TotalGrossAmount) + number(TotalGeneralSurcharges))) or (not(TotalGeneralSurcharges) and not(TotalGeneralDiscounts) and (number(TotalGrossAmountBeforeTaxes) = number(TotalGrossAmount)))</attribute>
              <ns1:text>[BIIRULE-T10-R012]-Invoice tax exclusive amount MUST equal the sum of lines plus allowances and charges on header level.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(number(InvoiceTotal) = number(TotalGrossAmountBeforeTaxes) - number(TotalTaxesWithheld) + number(TotalTaxOutputs))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">number(InvoiceTotal) = number(TotalGrossAmountBeforeTaxes) - number(TotalTaxesWithheld) + number(TotalTaxOutputs)</attribute>
              <ns1:text>[BIIRULE-T10-R013]-Invoice tax inclusive amount MUST equal the tax exclusive amount plus all tax total amounts and the rounding amount.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(number(InvoiceTotal) >= 0)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">number(InvoiceTotal) &gt;= 0</attribute>
              <ns1:text>[BIIRULE-T10-R014]-Tax inclusive amount in an invoice MUST NOT be negative</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((TotalGeneralDiscounts) and TotalGeneralDiscounts = (round(sum(//Discount/DiscountAmount) * 100) div 100) or not(TotalGeneralDiscounts))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(TotalGeneralDiscounts) and TotalGeneralDiscounts = (round(sum(//Discount/DiscountAmount) * 100) div 100) or not(TotalGeneralDiscounts)</attribute>
              <ns1:text>[BIIRULE-T10-R015]-Total allowance MUST be equal to the sum of allowances at document level</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((TotalGeneralSurcharges) and TotalGeneralSurcharges = (round(sum(//Charge/ChargeAmount) * 100) div 100) or not(TotalGeneralSurcharges))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(TotalGeneralSurcharges) and TotalGeneralSurcharges = (round(sum(//Charge/ChargeAmount) * 100) div 100) or not(TotalGeneralSurcharges)</attribute>
              <ns1:text>[BIIRULE-T10-R016]-Total charges MUST be equal to the sum of document level charges.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((TotalPaymentsOnAccount) and (number(TotalExecutableAmount) = number(InvoiceTotal - TotalPaymentsOnAccount)) or TotalExecutableAmount = InvoiceTotal)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(TotalPaymentsOnAccount) and (number(TotalExecutableAmount) = number(InvoiceTotal - TotalPaymentsOnAccount)) or TotalExecutableAmount = InvoiceTotal</attribute>
              <ns1:text>[BIIRULE-T10-R017]-Amount due is the tax inclusive amount minus what has been prepaid.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w432aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//InvoicingPeriod" mode="w432aac13" priority="2">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w432aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac15">
          <comment>WARNING: Rule for context "//InvoicingPeriod" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//InvoicingPeriod</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//InvoicingPeriod</attribute>
          </ns1:fired-rule>
          <if test="not((EndDate and  StartDate) and not(number(translate(StartDate,'-','')) > number(translate(EndDate,'-',''))) or number(translate(StartDate,'-','')) = number(translate(EndDate,'-','')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(EndDate and  StartDate) and not(number(translate(StartDate,'-','')) &gt; number(translate(EndDate,'-',''))) or number(translate(StartDate,'-','')) = number(translate(EndDate,'-',''))</attribute>
              <ns1:text>[BIIRULE-T10-R001]-An invoice period end date MUST be later or equal to an invoice period start date</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w432aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//PaymentDetails/Installments" mode="w432aac13" priority="1">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w432aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac15">
          <comment>WARNING: Rule for context "//PaymentDetails/Installments" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//PaymentDetails/Installments</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//PaymentDetails/Installments</attribute>
          </ns1:fired-rule>
          <if test="not((InstallmentDueDate and preceding::InvoiceIssueData/IssueDate) and not(number(translate(InstallmentDueDate,'-','')) &lt; number(translate(preceding::InvoiceIssueData/IssueDate,'-',''))) or number(translate(InstallmentDueDate,'-','')) = number(translate(preceding::InvoiceIssueData/IssueDate,'-','')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">(InstallmentDueDate and preceding::InvoiceIssueData/IssueDate) and not(number(translate(InstallmentDueDate,'-','')) &lt; number(translate(preceding::InvoiceIssueData/IssueDate,'-',''))) or number(translate(InstallmentDueDate,'-','')) = number(translate(preceding::InvoiceIssueData/IssueDate,'-',''))</attribute>
              <ns1:text>[BIIRULE-T10-R006]-Payment means due date in an invoice SHOULD be later or equal than issue date.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(((PaymentMeans = '31') and (//AccountToBeCredited/IBAN or //AccountToBeCredited/AccountNumber)) or (PaymentMeans != '31'))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">((PaymentMeans = '31') and (//AccountToBeCredited/IBAN or //AccountToBeCredited/AccountNumber)) or (PaymentMeans != '31')</attribute>
              <ns1:text>[BIIRULE-T10-R007]-If payment means is funds transfer, invoice MUST have a financial account</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((//AccountToBeCredited/IBAN and //AccountToBeCredited/BIC) or not(//AccountToBeCredited/IBAN))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">(//AccountToBeCredited/IBAN and //AccountToBeCredited/BIC) or not(//AccountToBeCredited/IBAN)</attribute>
              <ns1:text>[BIIRULE-T10-R008]-If bank account is IBAN the bank identifier SHOULD also be provided.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(//PaymentMeans)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">//PaymentMeans</attribute>
              <ns1:text>[BIIRULE-T10-R044]-When specifying payment means, the invoice MUST specify the payment means code</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w432aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//TaxesOutputs" mode="w432aac13" priority="0">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w432aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac15">
          <comment>WARNING: Rule for context "//TaxesOutputs" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//TaxesOutputs</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w432aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//TaxesOutputs</attribute>
          </ns1:fired-rule>
          <if test="not(//TaxTypeCode)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">//TaxTypeCode</attribute>
              <ns1:text>[BIIRULE-T10-R049]-Every tax scheme MUST be defined through an identifier.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w432aac15')" />
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
