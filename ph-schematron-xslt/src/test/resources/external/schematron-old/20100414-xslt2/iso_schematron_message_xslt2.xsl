<?xml version="1.0" ?><?xar XSLT?>
<!--

    Copyright (C) 2014-2023 Philip Helger (www.helger.com)
    philip[at]helger[dot]com

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

            http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

-->
<!-- Schematron message -->

<xsl:stylesheet
   version="2.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias">

<xsl:import href="iso_schematron_skeleton_for_saxon.xsl"/>

<xsl:template name="process-prolog">
   <axsl:output method="text" />
</xsl:template>

<!-- use default rule for process-root:  copy contens / ignore title -->
<!-- use default rule for process-pattern: ignore name and see -->
<!-- use default rule for process-name:  output name -->
<!-- use default rule for process-assert and process-report:
     call process-message -->

<xsl:template name="process-message">
   <xsl:param name="pattern" />
   <xsl:param name="role" />
   <axsl:message>
      <xsl:apply-templates mode="text"  
      /> (<xsl:value-of select="$pattern" />
      <xsl:if test="$role"> / <xsl:value-of select="$role" />
      </xsl:if>)</axsl:message>
</xsl:template>

</xsl:stylesheet>