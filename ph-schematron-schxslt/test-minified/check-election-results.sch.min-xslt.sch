<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">

   <pattern id="VoteCount">

      <p>The election results must add up to 100%.</p> 

      <rule context="ResultsByPercentage">

         <assert test="sum(Candidate) = 100">
             The sum of the election results must be 100
         </assert>

      </rule>

   </pattern>

   <pattern id="Checksum">

      <p>The tenth digit of DocumentNumber is a checksum digit. The checksum digit
             must equal the sum of the preceding nine digits multiplied by their position, mod 9.</p> 

      <rule context="DocumentNumber">

         <assert test="(                              (number(substring(.,1,1)) * 1) +                              (number(substring(.,2,1)) * 2) +                              (number(substring(.,3,1)) * 3) +                              (number(substring(.,4,1)) * 4) +                              (number(substring(.,5,1)) * 5) +                              (number(substring(.,6,1)) * 6) +                              (number(substring(.,7,1)) * 7) +                              (number(substring(.,8,1)) * 8) +                              (number(substring(.,9,1)) * 9)                            ) mod 9 = number(substring(.,10,1))                            ">
             The checksum (i.e. the tenth digit) must equal the sum of the preceding nine digits multiplied by their position, mod 9. 
         </assert>

      </rule>

   </pattern>

</schema>
