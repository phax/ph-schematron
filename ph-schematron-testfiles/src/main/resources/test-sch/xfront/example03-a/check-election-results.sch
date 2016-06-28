<?xml version="1.0"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">

   <sch:pattern name="Vote Count">

      <sch:p>The election results must add up to 100%.</sch:p> 

      <sch:rule context="ResultsByPercentage">

         <sch:assert test="sum(Candidate) = 100">
             The sum of the election results must be 100
         </sch:assert>

      </sch:rule>

   </sch:pattern>

   <sch:pattern name="Checksum">

      <sch:p>The tenth digit of DocumentNumber is a checksum digit. The checksum digit
             must equal the sum of the preceding nine digits multiplied by their position, mod 9.</sch:p> 

      <sch:rule context="DocumentNumber">

         <sch:assert test="(
                             (substring(.,1,1) * 1) +
                             (substring(.,2,1) * 2) +
                             (substring(.,3,1) * 3) +
                             (substring(.,4,1) * 4) +
                             (substring(.,5,1) * 5) +
                             (substring(.,6,1) * 6) +
                             (substring(.,7,1) * 7) +
                             (substring(.,8,1) * 8) +
                             (substring(.,9,1) * 9)
                           ) mod 9 = substring(.,10,1)
                           ">
             The checksum (i.e. the tenth digit) must equal the sum of the preceding nine digits multiplied by their position, mod 9. 
         </sch:assert>

      </sch:rule>

   </sch:pattern>

</sch:schema>