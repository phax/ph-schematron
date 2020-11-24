<schema  xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
     <pattern>
          <rule context="AAA">
               <assert test="BBB"><name /> element is <dir>missing</dir>.</assert>
               <report test="BBB"><name /> element is <emph>present</emph>.</report>
               <assert test="@name"><name /> misses attribute <span class="any">name</span>.</assert>
               <report test="@name"><name /> contains attribute name with value <value-of select="@name" />.</report>
          </rule>
     </pattern>
     <pattern>
          <rule context="AAA">
               <report test="BBB">BBB element is present.</report>
               <report test="@name"><name /> contains attribute name with value <value-of select="@name" />.</report>
          </rule>
     </pattern>
     <pattern>
          <rule context="AAA">
               <assert test="BBB">BBB element is missing.</assert>
               <assert test="@name"><name /> misses attribute name.</assert>
          </rule>
     </pattern>
</schema>