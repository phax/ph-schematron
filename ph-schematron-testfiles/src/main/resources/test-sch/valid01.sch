<schema  xmlns="http://purl.oclc.org/dsdl/schematron" >
     <pattern>
          <rule context="AAA">
               <assert test="BBB"><name /> element is missing.</assert>
               <report test="BBB"><name /> element is present.</report>
               <assert test="@name">AAA misses attribute name.</assert>
               <report test="@name">AAA contains attribute name.</report>
          </rule>
     </pattern>
     <pattern>
          <rule context="AAA">
               <report test="BBB">BBB element is present.</report>
               <report test="@name">AAA contains attribute name.</report>
          </rule>
     </pattern>
     <pattern>
          <rule context="AAA">
               <assert test="BBB">BBB element is missing.</assert>
               <assert test="@name">AAA misses attribute name.</assert>
          </rule>
     </pattern>
</schema>