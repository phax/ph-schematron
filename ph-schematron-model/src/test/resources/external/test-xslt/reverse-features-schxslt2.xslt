<?xml version="1.0" encoding="UTF-8"?>
<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform"
            xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
            xmlns:u="urn:test:u"
            xmlns:xs="http://www.w3.org/2001/XMLSchema"
            expand-text="false"
            version="3.0">
   <variable as="Q{http://www.w3.org/2001/XMLSchema}string"
             name="Q{http://dmaus.name/ns/2023/schxslt}phase"
             select="'#ALL'"/>
   <param name="gl" select="'global'"/>
   <mode use-accumulators=""/>
   <mode name="Q{http://dmaus.name/ns/2023/schxslt}validate"
         on-no-match="shallow-skip"
         use-accumulators=""/>
   <mode name="group.d20e15"
         on-no-match="shallow-skip"
         streamable="false"
         use-accumulators=""/>
   <template match="* | root()" mode="group.d20e15" priority="-10">
      <apply-templates mode="#current" select="@*"/>
      <apply-templates mode="#current" select="node()"/>
   </template>
   <variable name="pl" select="1"/>
   <template match="/root/item" mode="group.d20e15" priority="1">
      <param as="Q{http://www.w3.org/2001/XMLSchema}string*"
             name="Q{http://dmaus.name/ns/2023/schxslt}pattern"
             select="()"/>
      <variable as="node()"
                name="Q{http://dmaus.name/ns/2023/schxslt}rule-context"
                select="."/>
      <choose>
         <when test="'d20e15' = $Q{http://dmaus.name/ns/2023/schxslt}pattern">
            <svrl:suppressed-rule context="/root/item" flag="rf" id="R1">
               <if test="(document-uri(.), base-uri(root()))[1]">
                  <attribute name="document" select="(document-uri(.), base-uri(root()))[1]"/>
               </if>
            </svrl:suppressed-rule>
            <next-match/>
         </when>
         <otherwise>
            <svrl:fired-rule context="/root/item" flag="rf" id="R1">
               <if test="(document-uri(.), base-uri(root()))[1]">
                  <attribute name="document" select="(document-uri(.), base-uri(root()))[1]"/>
               </if>
            </svrl:fired-rule>
            <variable as="map(Q{http://www.w3.org/2001/XMLSchema}string, Q{http://www.w3.org/2001/XMLSchema}integer)"
                      name="Q{http://dmaus.name/ns/2023/schxslt}severity">
               <map>
                  <map-entry key="'d20e26'">
                     <variable as="Q{http://www.w3.org/2001/XMLSchema}string"
                               name="severity"
                               select="'fatal'"/>
                     <sequence select="Q{http://dmaus.name/ns/2023/schxslt}numeric-severity($severity)"/>
                  </map-entry>
                  <map-entry key="'d20e37'">
                     <variable as="Q{http://www.w3.org/2001/XMLSchema}string"
                               name="severity"
                               select="'fatal'"/>
                     <sequence select="Q{http://dmaus.name/ns/2023/schxslt}numeric-severity($severity)"/>
                  </map-entry>
               </map>
            </variable>
            <for-each select=".">
               <variable name="rl" select="@a"/>
               <choose>
                  <when test="Q{http://www.w3.org/2005/xpath-functions/map}get($Q{http://dmaus.name/ns/2023/schxslt}severity, 'd20e26') ge Q{http://dmaus.name/ns/2023/schxslt}numeric-severity('info')">
                     <if test="not(@a = $rl and $pl = 1)">
                        <variable as="element(svrl:failed-assert)" name="failed-assert">
                           <svrl:failed-assert flag="fatal"
                                               id="A-1"
                                               patternId="pat1"
                                               role="error"
                                               ruleId="R1"
                                               test="@a = $rl and $pl = 1">
                              <where-populated>
                                 <attribute name="location"
                                            select="path($Q{http://dmaus.name/ns/2023/schxslt}rule-context)"/>
                              </where-populated>
                              <svrl:diagnostic-reference diagnostic="d1">
                                 <svrl:text>Diag <for-each select=".[1]">
                                       <value-of select="@a"/>
                                    </for-each>
                                 </svrl:text>
                              </svrl:diagnostic-reference>
                              <svrl:text see="http://x">Item <value-of select="name(.)"/> / <for-each select=".[1]">
                                    <value-of select="@a"/>
                                 </for-each> must <svrl:emph>match</svrl:emph>
                                 <for-each select=".[1]">
                                    <value-of select="$gl"/>
                                 </for-each>
                              </svrl:text>
                           </svrl:failed-assert>
                        </variable>
                        <sequence select="$failed-assert"/>
                     </if>
                  </when>
                  <otherwise>
                     <svrl:skipped-assert flag="fatal"
                                          id="A-1"
                                          patternId="pat1"
                                          role="error"
                                          ruleId="R1"
                                          severityThreshold="info"
                                          test="@a = $rl and $pl = 1">
                        <where-populated>
                           <attribute name="location"
                                      select="path($Q{http://dmaus.name/ns/2023/schxslt}rule-context)"/>
                        </where-populated>
                     </svrl:skipped-assert>
                  </otherwise>
               </choose>
               <choose>
                  <when test="Q{http://www.w3.org/2005/xpath-functions/map}get($Q{http://dmaus.name/ns/2023/schxslt}severity, 'd20e37') ge Q{http://dmaus.name/ns/2023/schxslt}numeric-severity('info')">
                     <if test="@b">
                        <variable as="element(svrl:successful-report)" name="successful-report">
                           <svrl:successful-report id="R-1"
                                                   patternId="pat1"
                                                   role="warning"
                                                   ruleId="R1"
                                                   test="@b">
                              <where-populated>
                                 <attribute name="location"
                                            select="path($Q{http://dmaus.name/ns/2023/schxslt}rule-context)"/>
                              </where-populated>
                              <svrl:property-reference property="pr1">
                                 <svrl:text>Prop <for-each select=".[1]">
                                       <value-of select="@b"/>
                                    </for-each>
                                 </svrl:text>
                              </svrl:property-reference>
                              <svrl:text>Has b: <for-each select=".[1]">
                                    <value-of select="@b"/>
                                 </for-each>
                              </svrl:text>
                           </svrl:successful-report>
                        </variable>
                        <sequence select="$successful-report"/>
                     </if>
                  </when>
                  <otherwise>
                     <svrl:skipped-report id="R-1"
                                          patternId="pat1"
                                          role="warning"
                                          ruleId="R1"
                                          severityThreshold="info"
                                          test="@b">
                        <where-populated>
                           <attribute name="location"
                                      select="path($Q{http://dmaus.name/ns/2023/schxslt}rule-context)"/>
                        </where-populated>
                     </svrl:skipped-report>
                  </otherwise>
               </choose>
            </for-each>
            <next-match>
               <with-param as="Q{http://www.w3.org/2001/XMLSchema}string*"
                           name="Q{http://dmaus.name/ns/2023/schxslt}pattern"
                           select="('d20e15', $Q{http://dmaus.name/ns/2023/schxslt}pattern)"/>
            </next-match>
         </otherwise>
      </choose>
   </template>
   <template match="/root" mode="group.d20e15" priority="0">
      <param as="Q{http://www.w3.org/2001/XMLSchema}string*"
             name="Q{http://dmaus.name/ns/2023/schxslt}pattern"
             select="()"/>
      <variable as="node()"
                name="Q{http://dmaus.name/ns/2023/schxslt}rule-context"
                select="."/>
      <choose>
         <when test="'d20e51' = $Q{http://dmaus.name/ns/2023/schxslt}pattern">
            <svrl:suppressed-rule context="/root">
               <if test="(document-uri(.), base-uri(root()))[1]">
                  <attribute name="document" select="(document-uri(.), base-uri(root()))[1]"/>
               </if>
            </svrl:suppressed-rule>
            <next-match/>
         </when>
         <otherwise>
            <svrl:fired-rule context="/root">
               <if test="(document-uri(.), base-uri(root()))[1]">
                  <attribute name="document" select="(document-uri(.), base-uri(root()))[1]"/>
               </if>
            </svrl:fired-rule>
            <variable as="map(Q{http://www.w3.org/2001/XMLSchema}string, Q{http://www.w3.org/2001/XMLSchema}integer)"
                      name="Q{http://dmaus.name/ns/2023/schxslt}severity">
               <map>
                  <map-entry key="'d20e55'">
                     <variable as="Q{http://www.w3.org/2001/XMLSchema}string"
                               name="severity"
                               select="'fatal'"/>
                     <sequence select="Q{http://dmaus.name/ns/2023/schxslt}numeric-severity($severity)"/>
                  </map-entry>
               </map>
            </variable>
            <for-each select=".">
               <choose>
                  <when test="Q{http://www.w3.org/2005/xpath-functions/map}get($Q{http://dmaus.name/ns/2023/schxslt}severity, 'd20e55') ge Q{http://dmaus.name/ns/2023/schxslt}numeric-severity('info')">
                     <if test="not(item)">
                        <variable as="element(svrl:failed-assert)" name="failed-assert">
                           <svrl:failed-assert test="item">
                              <where-populated>
                                 <attribute name="location"
                                            select="path($Q{http://dmaus.name/ns/2023/schxslt}rule-context)"/>
                              </where-populated>
                              <svrl:text>needs item</svrl:text>
                           </svrl:failed-assert>
                        </variable>
                        <sequence select="$failed-assert"/>
                     </if>
                  </when>
                  <otherwise>
                     <svrl:skipped-assert severityThreshold="info" test="item">
                        <where-populated>
                           <attribute name="location"
                                      select="path($Q{http://dmaus.name/ns/2023/schxslt}rule-context)"/>
                        </where-populated>
                     </svrl:skipped-assert>
                  </otherwise>
               </choose>
            </for-each>
            <next-match>
               <with-param as="Q{http://www.w3.org/2001/XMLSchema}string*"
                           name="Q{http://dmaus.name/ns/2023/schxslt}pattern"
                           select="('d20e51', $Q{http://dmaus.name/ns/2023/schxslt}pattern)"/>
            </next-match>
         </otherwise>
      </choose>
   </template>
   <template as="element(svrl:schematron-output)" match="root()">
      <svrl:schematron-output phase="#ALL" schemaVersion="1.0" title="Probe schema">
         <svrl:ns-prefix-in-attribute-values prefix="u" uri="urn:test:u"/>
         <svrl:ns-prefix-in-attribute-values prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
         <!--SchXslt2 1.11.2-->
         <try>
            <apply-templates mode="Q{http://dmaus.name/ns/2023/schxslt}validate" select="."/>
            <catch>
               <svrl:error code="{$Q{http://www.w3.org/2005/xqt-errors}code}">
                  <if test="(document-uri(.), base-uri(root()))[1]">
                     <attribute name="document" select="(document-uri(.), base-uri(root()))[1]"/>
                  </if>
                  <if test="$Q{http://www.w3.org/2005/xqt-errors}line-number">
                     <attribute name="line-number"
                                select="$Q{http://www.w3.org/2005/xqt-errors}line-number"/>
                  </if>
                  <if test="$Q{http://www.w3.org/2005/xqt-errors}column-number">
                     <attribute name="column-number"
                                select="$Q{http://www.w3.org/2005/xqt-errors}column-number"/>
                  </if>
                  <if test="$Q{http://www.w3.org/2005/xqt-errors}description">
                     <value-of select="$Q{http://www.w3.org/2005/xqt-errors}description"/>
                  </if>
               </svrl:error>
               <variable as="Q{http://www.w3.org/2001/XMLSchema}string+"
                         expand-text="yes"
                         name="message">
                    Running the ISO Schematron validation failed with a dynamic error.
                    Error code: {$Q{http://www.w3.org/2005/xqt-errors}code} Reason: {$Q{http://www.w3.org/2005/xqt-errors}description}
                  </variable>
               <message error-code="Q{{http://dmaus.name/ns/2023/schxslt}}ValidationError"
                        terminate="yes">
                  <text/>
                  <value-of select="normalize-space(string-join($message))"/>
               </message>
            </catch>
         </try>
      </svrl:schematron-output>
   </template>
   <template as="element()*"
             match="root()"
             mode="Q{http://dmaus.name/ns/2023/schxslt}validate">
      <svrl:active-pattern id="pat1">
         <attribute name="name">First pattern</attribute>
      </svrl:active-pattern>
      <svrl:active-pattern/>
      <apply-templates mode="group.d20e15" select="root()"/>
   </template>
   <function as="Q{http://www.w3.org/2001/XMLSchema}integer"
             name="Q{http://dmaus.name/ns/2023/schxslt}numeric-severity">
      <param as="Q{http://www.w3.org/2001/XMLSchema}string" name="severity"/>
      <sequence select="(index-of(('info', 'warning', 'error', 'fatal'), $severity), 4)[1]"/>
   </function>
</stylesheet>
