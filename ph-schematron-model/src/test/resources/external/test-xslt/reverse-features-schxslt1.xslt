<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform xmlns:error="https://doi.org/10.5281/zenodo.1495494#error"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:sch="http://purl.oclc.org/dsdl/schematron"
               xmlns:schxslt="https://doi.org/10.5281/zenodo.1495494"
               xmlns:schxslt-api="https://doi.org/10.5281/zenodo.1495494#api"
               xmlns:u="urn:test:u"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               version="2.0">
   <xsl:output indent="yes"/>
   <xsl:param name="gl" select="'global'"/>
   <xsl:variable name="pl" select="1"/>
   <xsl:param as="xs:string?" name="schxslt.validate.initial-document-uri"/>
   <xsl:template name="schxslt.validate">
      <xsl:apply-templates select="document($schxslt.validate.initial-document-uri)"/>
   </xsl:template>
   <xsl:template match="root()">
      <xsl:param as="xs:boolean"
                 name="schxslt.validate.recursive-call"
                 select="false()"/>
      <xsl:choose>
         <xsl:when test="not($schxslt.validate.recursive-call) and (normalize-space($schxslt.validate.initial-document-uri) != '')">
            <xsl:apply-templates select="document($schxslt.validate.initial-document-uri)">
               <xsl:with-param as="xs:boolean"
                               name="schxslt.validate.recursive-call"
                               select="true()"/>
            </xsl:apply-templates>
         </xsl:when>
         <xsl:otherwise>
            <xsl:variable as="element()?" name="metadata"/>
            <xsl:variable as="element(schxslt:report)" name="report">
               <schxslt:report>
                  <xsl:call-template name="w10aac11"/>
               </schxslt:report>
            </xsl:variable>
            <xsl:variable as="node()*" name="schxslt:report">
               <xsl:sequence select="$metadata"/>
               <xsl:for-each select="$report/schxslt:document">
                  <xsl:for-each select="schxslt:pattern">
                     <xsl:sequence select="node()"/>
                     <xsl:sequence select="../schxslt:rule[@pattern = current()/@id]/node()"/>
                  </xsl:for-each>
               </xsl:for-each>
            </xsl:variable>
            <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    schemaVersion="1.0"
                                    title="Probe schema">
               <svrl:ns-prefix-in-attribute-values prefix="u" uri="urn:test:u"/>
               <svrl:ns-prefix-in-attribute-values prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
               <xsl:sequence select="$schxslt:report"/>
            </svrl:schematron-output>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="text() | @*" mode="#all" priority="-10"/>
   <xsl:template match="/" mode="#all" priority="-10">
      <xsl:apply-templates mode="#current" select="node()"/>
   </xsl:template>
   <xsl:template match="*" mode="#all" priority="-10">
      <xsl:apply-templates mode="#current" select="@*"/>
      <xsl:apply-templates mode="#current" select="node()"/>
   </xsl:template>
   <xsl:template name="w10aac11">
      <schxslt:document>
         <schxslt:pattern id="w10aac11">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    id="pat1"
                                    name="First pattern">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="w10aac13">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <xsl:apply-templates mode="w10aac11" select="root()"/>
      </schxslt:document>
   </xsl:template>
   <xsl:template match="/root/item" mode="w10aac11" priority="1">
      <xsl:param as="xs:string*" name="schxslt:patterns-matched"/>
      <xsl:variable name="rl" select="@a"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'w10aac11']">
            <schxslt:rule pattern="w10aac11">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule R1 for context "/root/item" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="rf" id="R1">
                  <xsl:attribute name="context">/root/item</xsl:attribute>
                  <xsl:variable as="xs:anyURI?" name="documentUri" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param as="xs:string*"
                               name="schxslt:patterns-matched"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="w10aac11">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" flag="rf" id="R1">
                  <xsl:attribute name="context">/root/item</xsl:attribute>
                  <xsl:variable as="xs:anyURI?" name="documentUri" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@a = $rl and $pl = 1)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      flag="fatal"
                                      id="A-1"
                                      location="{schxslt:location(.)}"
                                      role="error"
                                      see="http://x">
                     <xsl:attribute name="test">@a = $rl and $pl = 1</xsl:attribute>
                     <svrl:diagnostic-reference diagnostic="d1">
                        <svrl:text id="d1">Diag <xsl:value-of select="@a"/>
                        </svrl:text>
                     </svrl:diagnostic-reference>
                     <svrl:text>Item <xsl:value-of select="name()"/> / <xsl:value-of select="@a"/> must <svrl:emph>match</svrl:emph>
                        <xsl:value-of select="$gl"/>
                     </svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="@b">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          id="R-1"
                                          location="{schxslt:location(.)}"
                                          role="warning">
                     <xsl:attribute name="test">@b</xsl:attribute>
                     <svrl:property-reference property="pr1">
                        <svrl:text>Prop <xsl:value-of select="@b"/>
                        </svrl:text>
                     </svrl:property-reference>
                     <svrl:text>Has b: <xsl:value-of select="@b"/>
                     </svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param as="xs:string*"
                               name="schxslt:patterns-matched"
                               select="($schxslt:patterns-matched, 'w10aac11')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/root" mode="w10aac11" priority="0">
      <xsl:param as="xs:string*" name="schxslt:patterns-matched"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'w10aac13']">
            <schxslt:rule pattern="w10aac13">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/root" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/root</xsl:attribute>
                  <xsl:variable as="xs:anyURI?" name="documentUri" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param as="xs:string*"
                               name="schxslt:patterns-matched"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="w10aac13">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/root</xsl:attribute>
                  <xsl:variable as="xs:anyURI?" name="documentUri" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(item)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">item</xsl:attribute>
                     <svrl:text>needs item</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param as="xs:string*"
                               name="schxslt:patterns-matched"
                               select="($schxslt:patterns-matched, 'w10aac13')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:function as="xs:string" name="schxslt:location">
      <xsl:param as="node()" name="node"/>
      <xsl:variable as="xs:string*" name="segments">
         <xsl:for-each select="($node/ancestor-or-self::node())">
            <xsl:variable name="position">
               <xsl:number level="single"/>
            </xsl:variable>
            <xsl:choose>
               <xsl:when test=". instance of element()">
                  <xsl:value-of select="concat('Q{', namespace-uri(.), '}', local-name(.), '[', $position, ']')"/>
               </xsl:when>
               <xsl:when test=". instance of attribute()">
                  <xsl:value-of select="concat('@Q{', namespace-uri(.), '}', local-name(.))"/>
               </xsl:when>
               <xsl:when test=". instance of processing-instruction()">
                  <xsl:value-of select="concat('processing-instruction(&#34;', name(.), '&#34;)[', $position, ']')"/>
               </xsl:when>
               <xsl:when test=". instance of comment()">
                  <xsl:value-of select="concat('comment()[', $position, ']')"/>
               </xsl:when>
               <xsl:when test=". instance of text()">
                  <xsl:value-of select="concat('text()[', $position, ']')"/>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="concat('/', string-join($segments, '/'))"/>
   </xsl:function>
</xsl:transform>
