<schema  xmlns="http://purl.oclc.org/dsdl/schematron" >
     <pattern>
          <rule context="AAA">
               <assert test="BBB"><name /> element is missing.</assert>
               <assert test="@name">AAA misses attribute name.</assert>
          </rule>
     </pattern>
</schema>