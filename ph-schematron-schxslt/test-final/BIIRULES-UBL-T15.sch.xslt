<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<transform xmlns="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <ns0:Description xmlns:ns0="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
    <ns1:creator xmlns:ns1="http://purl.org/dc/terms/">
      <ns1:Agent>
        <ns2:prefLabel xmlns:ns2="http://www.w3.org/2004/02/skos/core#">SchXslt/1.9.4 SAXON/HE 11.4</ns2:prefLabel>
        <ns2:schxslt.compile.typed-variables xmlns:ns2="https://doi.org/10.5281/zenodo.1495494#">true</ns2:schxslt.compile.typed-variables>
      </ns1:Agent>
    </ns1:creator>
    <ns1:created xmlns:ns1="http://purl.org/dc/terms/">2022-11-17T08:43:07.835+01:00</ns1:created>
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
            <ns1:created>2022-11-17T08:43:07.835+01:00</ns1:created>
          </ns2:Description>
        </ns1:source>
      </ns0:metadata>
    </variable>
    <variable as="element(schxslt:report)" name="report">
      <ns0:report xmlns:ns0="https://doi.org/10.5281/zenodo.1495494">
        <call-template name="w581aac13" />
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
    <ns0:schematron-output xmlns:ns0="http://purl.oclc.org/dsdl/svrl" title="BIIRULES T15 bound to UBL">
      <ns0:ns-prefix-in-attribute-values prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
      <ns0:ns-prefix-in-attribute-values prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
      <ns0:ns-prefix-in-attribute-values prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" />
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
  <template name="w581aac13">
    <ns0:document xmlns:ns0="https://doi.org/10.5281/zenodo.1495494">
      <ns0:pattern id="w581aac13">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl" id="Codes-T15" name="Codes-T15">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w581aac15">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl" id="UBL-T15" name="UBL-T15">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <apply-templates mode="w581aac13" select="root()" />
    </ns0:document>
  </template>
  <template match="cbc:DocumentCurrencyCode" mode="w581aac13" priority="21">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w581aac13']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac13">
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
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac13">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cbc:DocumentCurrencyCode</attribute>
          </ns1:fired-rule>
          <if test="not(contains('�AED�AFN�ALL�AMD�ANG�AOA�ARS�AUD�AWG�AZN�BAM�BBD�BDT�BGN�BHD�BIF�BMD�BND�BOB�BOV�BRL�BSD�BTN�BWP�BYR�BZD�CAD�CDF�CHE�CHF�CHW�CLF�CLP�CNY�COP�COU�CRC�CUP�CVE�CZK�DJF�DKK�DOP�DZD�EEK�EGP�ERN�ETB�EUR�FJD�FKP�GBP�GEL�GHS�GIP�GMD�GNF�GTQ�GWP�GYD�HKD�HNL�HRK�HTG�HUF�IDR�ILS�INR�IQD�IRR�ISK�JMD�JOD�JPY�KES�KGS�KHR�KMF�KPW�KRW�KWD�KYD�KZT�LAK�LBP�LKR�LRD�LSL�LTL�LVL�LYD�MAD�MDL�MGA�MKD�MMK�MNT�MOP�MRO�MUR�MVR�MWK�MXN�MXV�MYR�MZN�NAD�NGN�NIO�NOK�NPR�NZD�OMR�PAB�PEN�PGK�PHP�PKR�PLN�PYG�QAR�RON�RSD�RUB�RWF�SAR�SBD�SCR�SDG�SEK�SGD�SHP�SKK�SLL�SOS�SRD�STD�SVC�SYP�SZL�THB�TJS�TMM�TND�TOP�TRY�TTD�TWD�TZS�UAH�UGX�USD�USN�USS�UYI�UYU�UZS�VEF�VND�VUV�WST�XAF�XAG�XAU�XBA�XBB�XBC�XBD�XCD�XDR�XFU�XOF�XPD�XPF�XTS�XXX�YER�ZAR�ZMK�ZWD�ZWR�',concat('�',.,'�')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">contains('�AED�AFN�ALL�AMD�ANG�AOA�ARS�AUD�AWG�AZN�BAM�BBD�BDT�BGN�BHD�BIF�BMD�BND�BOB�BOV�BRL�BSD�BTN�BWP�BYR�BZD�CAD�CDF�CHE�CHF�CHW�CLF�CLP�CNY�COP�COU�CRC�CUP�CVE�CZK�DJF�DKK�DOP�DZD�EEK�EGP�ERN�ETB�EUR�FJD�FKP�GBP�GEL�GHS�GIP�GMD�GNF�GTQ�GWP�GYD�HKD�HNL�HRK�HTG�HUF�IDR�ILS�INR�IQD�IRR�ISK�JMD�JOD�JPY�KES�KGS�KHR�KMF�KPW�KRW�KWD�KYD�KZT�LAK�LBP�LKR�LRD�LSL�LTL�LVL�LYD�MAD�MDL�MGA�MKD�MMK�MNT�MOP�MRO�MUR�MVR�MWK�MXN�MXV�MYR�MZN�NAD�NGN�NIO�NOK�NPR�NZD�OMR�PAB�PEN�PGK�PHP�PKR�PLN�PYG�QAR�RON�RSD�RUB�RWF�SAR�SBD�SCR�SDG�SEK�SGD�SHP�SKK�SLL�SOS�SRD�STD�SVC�SYP�SZL�THB�TJS�TMM�TND�TOP�TRY�TTD�TWD�TZS�UAH�UGX�USD�USN�USS�UYI�UYU�UZS�VEF�VND�VUV�WST�XAF�XAG�XAU�XBA�XBB�XBC�XBD�XCD�XDR�XFU�XOF�XPD�XPF�XTS�XXX�YER�ZAR�ZMK�ZWD�ZWR�',concat('�',.,'�'))</attribute>
              <ns1:text>[CL-015-002]-DocumentCurrencyCode MUST be coded using ISO code list 4217</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w581aac13')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="@currencyID" mode="w581aac13" priority="20">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w581aac13']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac13">
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
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac13">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">@currencyID</attribute>
          </ns1:fired-rule>
          <if test="not(contains('�AED�AFN�ALL�AMD�ANG�AOA�ARS�AUD�AWG�AZN�BAM�BBD�BDT�BGN�BHD�BIF�BMD�BND�BOB�BOV�BRL�BSD�BTN�BWP�BYR�BZD�CAD�CDF�CHE�CHF�CHW�CLF�CLP�CNY�COP�COU�CRC�CUP�CVE�CZK�DJF�DKK�DOP�DZD�EEK�EGP�ERN�ETB�EUR�FJD�FKP�GBP�GEL�GHS�GIP�GMD�GNF�GTQ�GWP�GYD�HKD�HNL�HRK�HTG�HUF�IDR�ILS�INR�IQD�IRR�ISK�JMD�JOD�JPY�KES�KGS�KHR�KMF�KPW�KRW�KWD�KYD�KZT�LAK�LBP�LKR�LRD�LSL�LTL�LVL�LYD�MAD�MDL�MGA�MKD�MMK�MNT�MOP�MRO�MUR�MVR�MWK�MXN�MXV�MYR�MZN�NAD�NGN�NIO�NOK�NPR�NZD�OMR�PAB�PEN�PGK�PHP�PKR�PLN�PYG�QAR�RON�RSD�RUB�RWF�SAR�SBD�SCR�SDG�SEK�SGD�SHP�SKK�SLL�SOS�SRD�STD�SVC�SYP�SZL�THB�TJS�TMM�TND�TOP�TRY�TTD�TWD�TZS�UAH�UGX�USD�USN�USS�UYI�UYU�UZS�VEF�VND�VUV�WST�XAF�XAG�XAU�XBA�XBB�XBC�XBD�XCD�XDR�XFU�XOF�XPD�XPF�XTS�XXX�YER�ZAR�ZMK�ZWD�ZWR�',concat('�',.,'�')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">contains('�AED�AFN�ALL�AMD�ANG�AOA�ARS�AUD�AWG�AZN�BAM�BBD�BDT�BGN�BHD�BIF�BMD�BND�BOB�BOV�BRL�BSD�BTN�BWP�BYR�BZD�CAD�CDF�CHE�CHF�CHW�CLF�CLP�CNY�COP�COU�CRC�CUP�CVE�CZK�DJF�DKK�DOP�DZD�EEK�EGP�ERN�ETB�EUR�FJD�FKP�GBP�GEL�GHS�GIP�GMD�GNF�GTQ�GWP�GYD�HKD�HNL�HRK�HTG�HUF�IDR�ILS�INR�IQD�IRR�ISK�JMD�JOD�JPY�KES�KGS�KHR�KMF�KPW�KRW�KWD�KYD�KZT�LAK�LBP�LKR�LRD�LSL�LTL�LVL�LYD�MAD�MDL�MGA�MKD�MMK�MNT�MOP�MRO�MUR�MVR�MWK�MXN�MXV�MYR�MZN�NAD�NGN�NIO�NOK�NPR�NZD�OMR�PAB�PEN�PGK�PHP�PKR�PLN�PYG�QAR�RON�RSD�RUB�RWF�SAR�SBD�SCR�SDG�SEK�SGD�SHP�SKK�SLL�SOS�SRD�STD�SVC�SYP�SZL�THB�TJS�TMM�TND�TOP�TRY�TTD�TWD�TZS�UAH�UGX�USD�USN�USS�UYI�UYU�UZS�VEF�VND�VUV�WST�XAF�XAG�XAU�XBA�XBB�XBC�XBD�XCD�XDR�XFU�XOF�XPD�XPF�XTS�XXX�YER�ZAR�ZMK�ZWD�ZWR�',concat('�',.,'�'))</attribute>
              <ns1:text>[CL-015-003]-currencyID MUST be coded using ISO code list 4217</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w581aac13')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="cac:Country//cbc:IdentificationCode" mode="w581aac13" priority="19">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w581aac13']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac13">
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
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac13">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:Country//cbc:IdentificationCode</attribute>
          </ns1:fired-rule>
          <if test="not(contains('�AD�AE�AF�AG�AI�AL�AM�AN�AO�AQ�AR�AS�AT�AU�AW�AX�AZ�BA�BB�BD�BE�BF�BG�BH�BI�BJ�BL�BM�BN�BO�BR�BS�BT�BV�BW�BY�BZ�CA�CC�CD�CF�CG�CH�CI�CK�CL�CM�CN�CO�CR�CU�CV�CX�CY�CZ�DE�DJ�DK�DM�DO�DZ�EC�EE�EG�EH�ER�ES�ET�FI�FJ�FK�FM�FO�FR�GA�GB�GD�GE�GF�GG�GH�GI�GL�GM�GN�GP�GQ�GR�GS�GT�GU�GW�GY�HK�HM�HN�HR�HT�HU�ID�IE�IL�IM�IN�IO�IQ�IR�IS�IT�JE�JM�JO�JP�KE�KG�KH�KI�KM�KN�KP�KR�KW�KY�KZ�LA�LB�LC�LI�LK�LR�LS�LT�LU�LV�LY�MA�MC�MD�ME�MF�MG�MH�MK�ML�MM�MN�MO�MP�MQ�MR�MS�MT�MU�MV�MW�MX�MY�MZ�NA�NC�NE�NF�NG�NI�NL�NO�NP�NR�NU�NZ�OM�PA�PE�PF�PG�PH�PK�PL�PM�PN�PR�PS�PT�PW�PY�QA�RO�RS�RU�RW�SA�SB�SC�SD�SE�SG�SH�SI�SJ�SK�SL�SM�SN�SO�SR�ST�SV�SY�SZ�TC�TD�TF�TG�TH�TJ�TK�TL�TM�TN�TO�TR�TT�TV�TW�TZ�UA�UG�UM�US�UY�UZ�VA�VC�VE�VG�VI�VN�VU�WF�WS�YE�YT�ZA�ZM�ZW�',concat('�',.,'�')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">contains('�AD�AE�AF�AG�AI�AL�AM�AN�AO�AQ�AR�AS�AT�AU�AW�AX�AZ�BA�BB�BD�BE�BF�BG�BH�BI�BJ�BL�BM�BN�BO�BR�BS�BT�BV�BW�BY�BZ�CA�CC�CD�CF�CG�CH�CI�CK�CL�CM�CN�CO�CR�CU�CV�CX�CY�CZ�DE�DJ�DK�DM�DO�DZ�EC�EE�EG�EH�ER�ES�ET�FI�FJ�FK�FM�FO�FR�GA�GB�GD�GE�GF�GG�GH�GI�GL�GM�GN�GP�GQ�GR�GS�GT�GU�GW�GY�HK�HM�HN�HR�HT�HU�ID�IE�IL�IM�IN�IO�IQ�IR�IS�IT�JE�JM�JO�JP�KE�KG�KH�KI�KM�KN�KP�KR�KW�KY�KZ�LA�LB�LC�LI�LK�LR�LS�LT�LU�LV�LY�MA�MC�MD�ME�MF�MG�MH�MK�ML�MM�MN�MO�MP�MQ�MR�MS�MT�MU�MV�MW�MX�MY�MZ�NA�NC�NE�NF�NG�NI�NL�NO�NP�NR�NU�NZ�OM�PA�PE�PF�PG�PH�PK�PL�PM�PN�PR�PS�PT�PW�PY�QA�RO�RS�RU�RW�SA�SB�SC�SD�SE�SG�SH�SI�SJ�SK�SL�SM�SN�SO�SR�ST�SV�SY�SZ�TC�TD�TF�TG�TH�TJ�TK�TL�TM�TN�TO�TR�TT�TV�TW�TZ�UA�UG�UM�US�UY�UZ�VA�VC�VE�VG�VI�VN�VU�WF�WS�YE�YT�ZA�ZM�ZW�',concat('�',.,'�'))</attribute>
              <ns1:text>[CL-015-004]-Country codes in an invoice MUST be coded using ISO code list 3166-1</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w581aac13')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="cac:TaxScheme//cbc:ID" mode="w581aac13" priority="18">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w581aac13']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac13">
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
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac13">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:TaxScheme//cbc:ID</attribute>
          </ns1:fired-rule>
          <if test="not(contains('�AAA�AAB�AAC�AAD�AAE�AAF�AAG�AAH�AAI�AAJ�AAK�AAL�ADD�BOL�CAP�CAR�COC�CST�CUD�CVD�ENV�EXC�EXP�FET�FRE�GCN�GST�ILL�IMP�IND�LAC�LCN�LDP�LOC�LST�MCA�MCD�OTH�PDB�PDC�PRF�SCN�SSS�STT�SUP�SUR�SWT�TAC�TOT�TOX�TTA�VAD�VAT�',concat('�',.,'�')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">contains('�AAA�AAB�AAC�AAD�AAE�AAF�AAG�AAH�AAI�AAJ�AAK�AAL�ADD�BOL�CAP�CAR�COC�CST�CUD�CVD�ENV�EXC�EXP�FET�FRE�GCN�GST�ILL�IMP�IND�LAC�LCN�LDP�LOC�LST�MCA�MCD�OTH�PDB�PDC�PRF�SCN�SSS�STT�SUP�SUR�SWT�TAC�TOT�TOX�TTA�VAD�VAT�',concat('�',.,'�'))</attribute>
              <ns1:text>[CL-015-005]-Invoice tax schemes MUST be coded using UN/ECE 5153 code list</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w581aac13')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="cac:PaymentMeans//cbc:PaymentMeansCode" mode="w581aac13" priority="17">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w581aac13']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac13">
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
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac13">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:PaymentMeans//cbc:PaymentMeansCode</attribute>
          </ns1:fired-rule>
          <if test="not(contains('�1�10�11�12�13�14�15�16�17�18�19�2�20�21�22�23�24�25�26�27�28�29�3�30�31�32�33�34�35�36�37�38�39�4�40�41�42�43�44�45�46�47�48�49�5�50�51�52�53�6�60�61�62�63�64�65�66�67�7�70�74�75�76�77�78�8�9�91�92�93�94�95�96�97�',concat('�',.,'�')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">contains('�1�10�11�12�13�14�15�16�17�18�19�2�20�21�22�23�24�25�26�27�28�29�3�30�31�32�33�34�35�36�37�38�39�4�40�41�42�43�44�45�46�47�48�49�5�50�51�52�53�6�60�61�62�63�64�65�66�67�7�70�74�75�76�77�78�8�9�91�92�93�94�95�96�97�',concat('�',.,'�'))</attribute>
              <ns1:text>[CL-015-006]-Payment means in an invoice MUST be coded using CEFACT code list 4461</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w581aac13')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="cac:TaxCategory//cbc:ID" mode="w581aac13" priority="16">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w581aac13']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac13">
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
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac13">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:TaxCategory//cbc:ID</attribute>
          </ns1:fired-rule>
          <if test="not(contains('�A�AA�AB�AC�AD�AE�B�C�E�G�H�O�S�Z�',concat('�',.,'�')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">contains('�A�AA�AB�AC�AD�AE�B�C�E�G�H�O�S�Z�',concat('�',.,'�'))</attribute>
              <ns1:text>[CL-015-007]-Invoice tax categories MUST be coded using UN/ECE 5305 code list</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w581aac13')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:AccountingCustomerParty" mode="w581aac13" priority="15">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w581aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac15">
          <comment>WARNING: Rule for context "//cac:AccountingCustomerParty" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:AccountingCustomerParty</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:AccountingCustomerParty</attribute>
          </ns1:fired-rule>
          <if test="not((cac:Party/cac:PostalAddress/cbc:CityName and cac:Party/cac:PostalAddress/cbc:PostalZone) or (cac:Party/cac:PostalAddress/cbc:ID))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">(cac:Party/cac:PostalAddress/cbc:CityName and cac:Party/cac:PostalAddress/cbc:PostalZone) or (cac:Party/cac:PostalAddress/cbc:ID)</attribute>
              <ns1:text>[BIIRULE-T15-R004]-A customer address in an invoice SHOULD contain at least city and zip code or have an address identifier.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID) and (cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and  ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) or ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) != (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID='VAT' and starts-with(cac:Party/cac:PartyTaxScheme/cbc:CompanyID,cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)))) or not((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID)) or not((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) or not((preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID) and (cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and  ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) or ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) != (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID='VAT' and starts-with(cac:Party/cac:PartyTaxScheme/cbc:CompanyID,cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)))) or not((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID)) or not((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) or not((preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))</attribute>
              <ns1:text>[BIIRULE-T15-R005]-In cross border trade the VAT identifier for the customer should be prefixed with country code.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w581aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:TaxCategory" mode="w581aac13" priority="14">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w581aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac15">
          <comment>WARNING: Rule for context "//cac:TaxCategory" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:TaxCategory</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:TaxCategory</attribute>
          </ns1:fired-rule>
          <if test="not(cbc:ID)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">cbc:ID</attribute>
              <ns1:text>[BIIRULE-T15-R049]-Every tax category MUST be defined through an identifier.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w581aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:AdditionalDocumentReference" mode="w581aac13" priority="13">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w581aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac15">
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
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:AdditionalDocumentReference</attribute>
          </ns1:fired-rule>
          <if test="not(cbc:ID)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">cbc:ID</attribute>
              <ns1:text>[BIIRULE-T15-R038]-For any document referred in an invoice, A corrective invoice MUST specify the document identifier.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(cbc:ID)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">cbc:ID</attribute>
              <ns1:text>[BIIRULE-T15-R046]-Any reference to a document MUST specify the document identifier.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w581aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:InvoiceLine/cac:Price/cbc:PriceAmount" mode="w581aac13" priority="12">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w581aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac15">
          <comment>WARNING: Rule for context "//cac:InvoiceLine/cac:Price/cbc:PriceAmount" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:InvoiceLine/cac:Price/cbc:PriceAmount</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:InvoiceLine/cac:Price/cbc:PriceAmount</attribute>
          </ns1:fired-rule>
          <if test="not(number(.) >=0)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">number(.) &gt;=0</attribute>
              <ns1:text>[BIIRULE-T15-R022]-Prices of items MUST NOT be negative.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w581aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/ubl:Invoice" mode="w581aac13" priority="11">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w581aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac15">
          <comment>WARNING: Rule for context "/ubl:Invoice" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/ubl:Invoice</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/ubl:Invoice</attribute>
          </ns1:fired-rule>
          <if test="not((cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID) or (cac:BillingReference/cac:CreditNoteDocumentReferene/cbc:ID))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID) or (cac:BillingReference/cac:CreditNoteDocumentReferene/cbc:ID)</attribute>
              <ns1:text>[BIIRULE-T15-R023]-A corrective invoice MUST have a reference to an invoice. </ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cbc:IssueDate))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:IssueDate)</attribute>
              <ns1:text>[BIIRULE-T15-R024]-A corrective invoice MUST have the date of issue.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cbc:ID))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:ID)</attribute>
              <ns1:text>[BIIRULE-T15-R025]-A corrective invoice MUST have an invoice number.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name)</attribute>
              <ns1:text>[BIIRULE-T15-R027]-A corrective invoice MUST contain the full name of the supplier.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name)</attribute>
              <ns1:text>[BIIRULE-T15-R028]-A corrective invoice MUST contain the full name of the customer.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount) and (sum(cac:TaxTotal//cac:TaxSubtotal/cbc:TaxableAmount) = number(cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount))) or not((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT'])))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount) and (sum(cac:TaxTotal//cac:TaxSubtotal/cbc:TaxableAmount) = number(cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount))) or not((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']))</attribute>
              <ns1:text>[BIIRULE-T15-R029]-If the VAT total amount in an invoice exists then the sum of taxable amount in sub categories MUST equal the sum of invoice tax exclusive amount.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cbc:UBLVersionID))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:UBLVersionID)</attribute>
              <ns1:text>[BIIRULE-T15-R030]-A corrective invoice MUST have a syntax identifier.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cbc:CustomizationID))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:CustomizationID)</attribute>
              <ns1:text>[BIIRULE-T15-R031]-A corrective invoice MUST have a customization identifier.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cbc:ProfileID))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:ProfileID)</attribute>
              <ns1:text>[BIIRULE-T15-R032]-A corrective invoice MUST have a profile identifier.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cac:InvoiceLine))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cac:InvoiceLine)</attribute>
              <ns1:text>[BIIRULE-T15-R034]-A corrective invoice MUST specify at least one line item.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cbc:DocumentCurrencyCode))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:DocumentCurrencyCode)</attribute>
              <ns1:text>[BIIRULE-T15-R035]-A corrective invoice MUST have a currency code for the document.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cac:OrderReference/cbc:ID) or not(cac:OrderReference))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cac:OrderReference/cbc:ID) or not(cac:OrderReference)</attribute>
              <ns1:text>[BIIRULE-T15-R036]-Any reference to an order MUST specify the order identifier.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cac:ContractDocumentReference/cbc:ID) or not(cac:ContractDocumentReference))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cac:ContractDocumentReference/cbc:ID) or not(cac:ContractDocumentReference)</attribute>
              <ns1:text>[BIIRULE-T15-R037]-Any reference to a contract MUST specify the contract identifier.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cac:LegalMonetaryTotal/cbc:PayableAmount))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cac:LegalMonetaryTotal/cbc:PayableAmount)</attribute>
              <ns1:text>[BIIRULE-T15-R039]-A corrective invoice MUST specify the total payable amount.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount)</attribute>
              <ns1:text>[BIIRULE-T15-R040]-A corrective invoice MUST specify the total amount with taxes included.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount)</attribute>
              <ns1:text>[BIIRULE-T15-R043]-A corrective invoice MUST specify the total amount without taxes.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cac:LegalMonetaryTotal/cbc:LineExtensionAmount))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cac:LegalMonetaryTotal/cbc:LineExtensionAmount)</attribute>
              <ns1:text>[BIIRULE-T15-R044]-A corrective invoice MUST specify the sum of the line amounts.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(cac:TaxTotal)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">cac:TaxTotal</attribute>
              <ns1:text>[BIIRULE-T15-R053]-A corrective invoice MUST contain tax information</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w581aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:Country" mode="w581aac13" priority="10">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w581aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac15">
          <comment>WARNING: Rule for context "//cac:Country" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:Country</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:Country</attribute>
          </ns1:fired-rule>
          <if test="not((cbc:IdentificationCode))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:IdentificationCode)</attribute>
              <ns1:text>[BIIRULE-T15-R041]-Country in an address MUST be specified using the country code.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w581aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal" mode="w581aac13" priority="9">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w581aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac15">
          <comment>WARNING: Rule for context "/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal</attribute>
          </ns1:fired-rule>
          <if test="not(boolean(self::node()[cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxableAmount) or (cac:TaxCategory/cac:TaxScheme/cbc:ID != 'VAT'))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">boolean(self::node()[cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxableAmount) or (cac:TaxCategory/cac:TaxScheme/cbc:ID != 'VAT')</attribute>
              <ns1:text>[BIIRULE-T15-R047]-A corrective invoice MUST specify the taxable amount per tax subtotal.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(boolean(self::node()[cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount) or (cac:TaxCategory/cac:TaxScheme/cbc:ID != 'VAT'))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">boolean(self::node()[cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount) or (cac:TaxCategory/cac:TaxScheme/cbc:ID != 'VAT')</attribute>
              <ns1:text>[BIIRULE-T15-R048]-A corrective invoice MUST specify the tax amount per tax subtotal.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w581aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:InvoiceLine" mode="w581aac13" priority="8">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w581aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac15">
          <comment>WARNING: Rule for context "//cac:InvoiceLine" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:InvoiceLine</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:InvoiceLine</attribute>
          </ns1:fired-rule>
          <if test="not(not(cbc:InvoicedQuantity) or not(cac:Price/cbc:PriceAmount) or (not(cac:Price/cbc:BaseQuantity) and  number(cbc:LineExtensionAmount) = (round(number(cac:Price/cbc:PriceAmount) *number(cbc:InvoicedQuantity) * 10 * 10) div 100) + ( round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) *10 * 10) div 100 ) - ( round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100 ) ) or ((cac:Price/cbc:BaseQuantity) and  number(cbc:LineExtensionAmount) = (round((number(cac:Price/cbc:PriceAmount) div number(cac:Price/cbc:BaseQuantity) * number(cbc:InvoicedQuantity)) * 10 * 10) div 100)+ (round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) * 10 * 10) div 100 ) -(round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100)))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">not(cbc:InvoicedQuantity) or not(cac:Price/cbc:PriceAmount) or (not(cac:Price/cbc:BaseQuantity) and  number(cbc:LineExtensionAmount) = (round(number(cac:Price/cbc:PriceAmount) *number(cbc:InvoicedQuantity) * 10 * 10) div 100) + ( round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) *10 * 10) div 100 ) - ( round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100 ) ) or ((cac:Price/cbc:BaseQuantity) and  number(cbc:LineExtensionAmount) = (round((number(cac:Price/cbc:PriceAmount) div number(cac:Price/cbc:BaseQuantity) * number(cbc:InvoicedQuantity)) * 10 * 10) div 100)+ (round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) * 10 * 10) div 100 ) -(round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100))</attribute>
              <ns1:text>[BIIRULE-T15-R018]-Invoice line amount MUST be equal to the price amount multiplied by the quantity plus charges minus allowances at line level</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cac:Item/cbc:Name))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cac:Item/cbc:Name)</attribute>
              <ns1:text>[BIIRULE-T15-R026]-Each corrective invoice line MUST contain the product/service name</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(cbc:ID)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">cbc:ID</attribute>
              <ns1:text>[BIIRULE-T15-R033]-Corrective Invoice lines MUST have a line identifier.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(cbc:LineExtensionAmount)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">cbc:LineExtensionAmount</attribute>
              <ns1:text>[BIIRULE-T15-R051]-Corrective Invoice lines MUST have a line total amount.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(cac:Price/cbc:PriceAmount)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">cac:Price/cbc:PriceAmount</attribute>
              <ns1:text>[BIIRULE-T15-R052]-Corrective Invoice lines MUST contain the item price</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w581aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/ubl:Invoice/cac:TaxTotal" mode="w581aac13" priority="7">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w581aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac15">
          <comment>WARNING: Rule for context "/ubl:Invoice/cac:TaxTotal" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/ubl:Invoice/cac:TaxTotal</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/ubl:Invoice/cac:TaxTotal</attribute>
          </ns1:fired-rule>
          <if test="not(count(cac:TaxSubtotal/*/*/cbc:ID) = count(cac:TaxSubtotal/*/*/cbc:ID[. = 'VAT']) or count(cac:TaxSubtotal/*/*/cbc:ID[. = 'VAT']) = 0)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">count(cac:TaxSubtotal/*/*/cbc:ID) = count(cac:TaxSubtotal/*/*/cbc:ID[. = 'VAT']) or count(cac:TaxSubtotal/*/*/cbc:ID[. = 'VAT']) = 0</attribute>
              <ns1:text>[BIIRULE-T15-R009]-An invoice MUST have a tax total refering to a single tax scheme</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(number(cbc:TaxAmount) = number(round(sum(cac:TaxSubtotal/cbc:TaxAmount)  * 10 * 10) div 100))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">number(cbc:TaxAmount) = number(round(sum(cac:TaxSubtotal/cbc:TaxAmount)  * 10 * 10) div 100)</attribute>
              <ns1:text>[BIIRULE-T15-R010]-Each tax total MUST equal the sum of the subcategory amounts.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w581aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:PartyLegalEntity" mode="w581aac13" priority="6">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w581aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac15">
          <comment>WARNING: Rule for context "//cac:PartyLegalEntity" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:PartyLegalEntity</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:PartyLegalEntity</attribute>
          </ns1:fired-rule>
          <if test="not((cbc:CompanyID))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:CompanyID)</attribute>
              <ns1:text>[BIIRULE-T15-R042]-Company identifier MUST be specified when describing a company legal entity.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w581aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:AccountingSupplierParty" mode="w581aac13" priority="5">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w581aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac15">
          <comment>WARNING: Rule for context "//cac:AccountingSupplierParty" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:AccountingSupplierParty</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:AccountingSupplierParty</attribute>
          </ns1:fired-rule>
          <if test="not((cac:Party/cac:PostalAddress/cbc:CityName and cac:Party/cac:PostalAddress/cbc:PostalZone) or (cac:Party/cac:PostalAddress/cbc:ID))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">(cac:Party/cac:PostalAddress/cbc:CityName and cac:Party/cac:PostalAddress/cbc:PostalZone) or (cac:Party/cac:PostalAddress/cbc:ID)</attribute>
              <ns1:text>[BIIRULE-T15-R002]-A supplier address in an invoice SHOULD contain at least the city name and a zip code or have an address identifier.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID) and (cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) or ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) != (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID='VAT' and starts-with(cac:Party/cac:PartyTaxScheme/cbc:CompanyID,cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)))) or not((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID)) or not((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) or not((following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID) and (cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) or ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) != (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID='VAT' and starts-with(cac:Party/cac:PartyTaxScheme/cbc:CompanyID,cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)))) or not((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID)) or not((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) or not((following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))</attribute>
              <ns1:text>[BIIRULE-T15-R003]-In cross border trade the VAT identifier for the supplier should be prefixed with country code.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w581aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:Item" mode="w581aac13" priority="4">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w581aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac15">
          <comment>WARNING: Rule for context "//cac:Item" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:Item</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:Item</attribute>
          </ns1:fired-rule>
          <if test="not(string-length(string(cbc:Name)) &lt;= 50)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">string-length(string(cbc:Name)) &lt;= 50</attribute>
              <ns1:text>[BIIRULE-T15-R019]-Product names SHOULD NOT exceed 50 characters long</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not((cac:StandardItemIdentification)) or (cac:StandardItemIdentification/cbc:ID/@schemeID))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not((cac:StandardItemIdentification)) or (cac:StandardItemIdentification/cbc:ID/@schemeID)</attribute>
              <ns1:text>[BIIRULE-T15-R020]-If standard identifiers are provided within an item description, an Scheme Identifier SHOULD be provided (e.g. GTIN)</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not((cac:CommodityClassification)) or (cac:CommodityClassification/cbc:ItemClassificationCode/@listID))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not((cac:CommodityClassification)) or (cac:CommodityClassification/cbc:ItemClassificationCode/@listID)</attribute>
              <ns1:text>[BIIRULE-T15-R021]-Classification codes within an item description SHOULD use a standard scheme for codes (e.g. CPV or UNSPSC)</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w581aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:LegalMonetaryTotal" mode="w581aac13" priority="3">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w581aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac15">
          <comment>WARNING: Rule for context "//cac:LegalMonetaryTotal" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:LegalMonetaryTotal</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:LegalMonetaryTotal</attribute>
          </ns1:fired-rule>
          <if test="not(number(cbc:LineExtensionAmount) = number(round(sum(//cac:InvoiceLine/cbc:LineExtensionAmount) * 10 * 10) div 100))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">number(cbc:LineExtensionAmount) = number(round(sum(//cac:InvoiceLine/cbc:LineExtensionAmount) * 10 * 10) div 100)</attribute>
              <ns1:text>[BIIRULE-T15-R011]-Invoice total line extension amount MUST equal the sum of the line totals</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(((cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (number(cbc:TaxExclusiveAmount) = round((number(cbc:LineExtensionAmount) + number(cbc:ChargeTotalAmount) - number(cbc:AllowanceTotalAmount)) * 10 * 10) div 100 ))  or (not(cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (number(cbc:TaxExclusiveAmount) = round((number(cbc:LineExtensionAmount) - number(cbc:AllowanceTotalAmount)) * 10 * 10 ) div 100)) or ((cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (number(cbc:TaxExclusiveAmount) = round((number(cbc:LineExtensionAmount) + number(cbc:ChargeTotalAmount)) * 10 * 10 ) div 100)) or (not(cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (number(cbc:TaxExclusiveAmount) = number(cbc:LineExtensionAmount))))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">((cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (number(cbc:TaxExclusiveAmount) = round((number(cbc:LineExtensionAmount) + number(cbc:ChargeTotalAmount) - number(cbc:AllowanceTotalAmount)) * 10 * 10) div 100 ))  or (not(cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (number(cbc:TaxExclusiveAmount) = round((number(cbc:LineExtensionAmount) - number(cbc:AllowanceTotalAmount)) * 10 * 10 ) div 100)) or ((cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (number(cbc:TaxExclusiveAmount) = round((number(cbc:LineExtensionAmount) + number(cbc:ChargeTotalAmount)) * 10 * 10 ) div 100)) or (not(cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (number(cbc:TaxExclusiveAmount) = number(cbc:LineExtensionAmount)))</attribute>
              <ns1:text>[BIIRULE-T15-R012]-An invoice tax exclusive amount MUST equal the sum of lines plus allowances and charges on header level.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(((cbc:PayableRoundingAmount) and (number(cbc:TaxInclusiveAmount) = (round((number(cbc:TaxExclusiveAmount) + number(sum(/ubl:Invoice/cac:TaxTotal/cbc:TaxAmount)) + number(cbc:PayableRoundingAmount)) *10 * 10) div 100))) or (number(cbc:TaxInclusiveAmount) = round(( number(cbc:TaxExclusiveAmount) + number(sum(/ubl:Invoice/cac:TaxTotal/cbc:TaxAmount))) * 10 * 10) div 100))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">((cbc:PayableRoundingAmount) and (number(cbc:TaxInclusiveAmount) = (round((number(cbc:TaxExclusiveAmount) + number(sum(/ubl:Invoice/cac:TaxTotal/cbc:TaxAmount)) + number(cbc:PayableRoundingAmount)) *10 * 10) div 100))) or (number(cbc:TaxInclusiveAmount) = round(( number(cbc:TaxExclusiveAmount) + number(sum(/ubl:Invoice/cac:TaxTotal/cbc:TaxAmount))) * 10 * 10) div 100)</attribute>
              <ns1:text>[BIIRULE-T15-R013]-An invoice tax inclusive amount MUST equal the tax exclusive amount plus all tax total amounts and the rounding amount.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(number(cbc:TaxInclusiveAmount) >= 0)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">number(cbc:TaxInclusiveAmount) &gt;= 0</attribute>
              <ns1:text>[BIIRULE-T15-R014]-Tax inclusive amount in an invoice MUST NOT be negative</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cbc:AllowanceTotalAmount) and number(cbc:AllowanceTotalAmount) = (round(sum(/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator=&quot;false&quot;]/cbc:Amount) * 10 * 10) div 100) or not(cbc:AllowanceTotalAmount))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:AllowanceTotalAmount) and number(cbc:AllowanceTotalAmount) = (round(sum(/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator="false"]/cbc:Amount) * 10 * 10) div 100) or not(cbc:AllowanceTotalAmount)</attribute>
              <ns1:text>[BIIRULE-T15-R015]-Total allowance it MUST be equal to the sum of allowances at document level</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cbc:ChargeTotalAmount) and number(cbc:ChargeTotalAmount) = (round(sum(/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator=&quot;true&quot;]/cbc:Amount)  * 10 * 10) div 100) or not(cbc:ChargeTotalAmount))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:ChargeTotalAmount) and number(cbc:ChargeTotalAmount) = (round(sum(/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator="true"]/cbc:Amount)  * 10 * 10) div 100) or not(cbc:ChargeTotalAmount)</attribute>
              <ns1:text>[BIIRULE-T15-R016]-Total charges it MUST be equal to the sum of document level charges.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cbc:PrepaidAmount) and (number(cbc:PayableAmount) = (round((cbc:TaxInclusiveAmount - cbc:PrepaidAmount) * 10 * 10) div 100)) or number(cbc:PayableAmount) = number(cbc:TaxInclusiveAmount))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:PrepaidAmount) and (number(cbc:PayableAmount) = (round((cbc:TaxInclusiveAmount - cbc:PrepaidAmount) * 10 * 10) div 100)) or number(cbc:PayableAmount) = number(cbc:TaxInclusiveAmount)</attribute>
              <ns1:text>[BIIRULE-T15-R017]-Amount due is the tax inclusive amount minus what has been prepaid.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w581aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:InvoicePeriod" mode="w581aac13" priority="2">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w581aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac15">
          <comment>WARNING: Rule for context "//cac:InvoicePeriod" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:InvoicePeriod</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:InvoicePeriod</attribute>
          </ns1:fired-rule>
          <if test="not((cbc:StartDate and cbc:EndDate) and (number(translate(cbc:StartDate,'-','')) &lt;= number(translate(cbc:EndDate,'-',''))))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:StartDate and cbc:EndDate) and (number(translate(cbc:StartDate,'-','')) &lt;= number(translate(cbc:EndDate,'-','')))</attribute>
              <ns1:text>[BIIRULE-T15-R001]-A corrective invoice period end date MUST be later or equal to an invoice period start date</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w581aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:PaymentMeans" mode="w581aac13" priority="1">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w581aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac15">
          <comment>WARNING: Rule for context "//cac:PaymentMeans" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:PaymentMeans</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:PaymentMeans</attribute>
          </ns1:fired-rule>
          <if test="not((cbc:PaymentDueDate and /ubl:Invoice/cbc:IssueDate) and (number(translate(cbc:PaymentDueDate,'-','')) >= number(translate(/ubl:Invoice/cbc:IssueDate,'-',''))) or (not(cbc:PaymentDueDate)))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:PaymentDueDate and /ubl:Invoice/cbc:IssueDate) and (number(translate(cbc:PaymentDueDate,'-','')) &gt;= number(translate(/ubl:Invoice/cbc:IssueDate,'-',''))) or (not(cbc:PaymentDueDate))</attribute>
              <ns1:text>[BIIRULE-T15-R006]-Payment means due date in an invoice SHOULD be later or equal than issue date.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cbc:PaymentMeansCode = '31') and //cac:PayeeFinancialAccount/cbc:ID or (cbc:PaymentMeansCode != '31'))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:PaymentMeansCode = '31') and //cac:PayeeFinancialAccount/cbc:ID or (cbc:PaymentMeansCode != '31')</attribute>
              <ns1:text>[BIIRULE-T15-R007]-If payment means is funds transfer, invoice MUST have a financial account</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cac:PayeeFinancialAccount/cbc:ID/@schemeID and (cac:PayeeFinancialAccount/cbc:ID/@schemeID = 'IBAN') and cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID) or (cac:PayeeFinancialAccount/cbc:ID/@schemeID != 'IBAN') or (not(cac:PayeeFinancialAccount/cbc:ID/@schemeID)))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">(cac:PayeeFinancialAccount/cbc:ID/@schemeID and (cac:PayeeFinancialAccount/cbc:ID/@schemeID = 'IBAN') and cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID) or (cac:PayeeFinancialAccount/cbc:ID/@schemeID != 'IBAN') or (not(cac:PayeeFinancialAccount/cbc:ID/@schemeID))</attribute>
              <ns1:text>[BIIRULE-T15-R008]-If bank account is IBAN the BIC code SHOULD also be provided.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PaymentMeans) or (cac:PaymentMeans/cbc:PaymentMeansCode))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PaymentMeans) or (cac:PaymentMeans/cbc:PaymentMeansCode)</attribute>
              <ns1:text>[BIIRULE-T15-R045]-When specifying payment means, A corrective invoice MUST specify the payment coded.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w581aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:TaxScheme" mode="w581aac13" priority="0">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w581aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac15">
          <comment>WARNING: Rule for context "//cac:TaxScheme" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:TaxScheme</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w581aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:TaxScheme</attribute>
          </ns1:fired-rule>
          <if test="not(cbc:ID)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">cbc:ID</attribute>
              <ns1:text>[BIIRULE-T15-R050]-Every tax scheme MUST be defined through an identifier.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w581aac15')" />
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
