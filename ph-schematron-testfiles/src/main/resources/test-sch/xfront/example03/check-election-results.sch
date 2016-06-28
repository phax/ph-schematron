<?xml version="1.0"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">

   <sch:pattern id="VoteCount">

      <sch:p>The election results must add up to 100%.</sch:p> 

      <sch:rule context="ElectionResultsByPercentage">

         <sch:assert test="sum(Candidate) = 100">
             The sum of the election results must be 100
         </sch:assert>

      </sch:rule>

   </sch:pattern>

</sch:schema>