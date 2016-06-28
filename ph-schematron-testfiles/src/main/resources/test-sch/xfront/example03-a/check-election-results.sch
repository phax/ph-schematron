<?xml version="1.0"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">

   <sch:pattern id="VoteCount">

      <sch:p>The election results must add up to 100%.</sch:p> 

      <sch:rule context="ResultsByPercentage">

         <sch:assert test="sum(Candidate) = 100">
             The sum of the election results must be 100
         </sch:assert>

      </sch:rule>

   </sch:pattern>

   <sch:pattern id="Checksum">

      <sch:p>The tenth digit of DocumentNumber is a checksum digit. The checksum digit
             must equal the sum of the preceding nine digits multiplied by their position, mod 9.</sch:p> 

      <sch:rule context="DocumentNumber">

         <sch:assert test="(
                             (number(substring(.,1,1)) * 1) +
                             (number(substring(.,2,1)) * 2) +
                             (number(substring(.,3,1)) * 3) +
                             (number(substring(.,4,1)) * 4) +
                             (number(substring(.,5,1)) * 5) +
                             (number(substring(.,6,1)) * 6) +
                             (number(substring(.,7,1)) * 7) +
                             (number(substring(.,8,1)) * 8) +
                             (number(substring(.,9,1)) * 9)
                           ) mod 9 = number(substring(.,10,1))
                           ">
             The checksum (i.e. the tenth digit) must equal the sum of the preceding nine digits multiplied by their position, mod 9. 
         </sch:assert>

      </sch:rule>

   </sch:pattern>

</sch:schema>