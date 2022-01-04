<?xml version="1.0"?>
<!--

    Copyright (C) 2014-2022 Philip Helger (www.helger.com)
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
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">

   <sch:ns uri="http://www.example.org"
           prefix="ex" />

   <sch:pattern name="Security Classification Policy">

      <sch:p>A Para's classification value cannot be more sensitive 
         than the Document's classification value.</sch:p> 

      <sch:rule context="ex:Para[@classification='top-secret']">

         <sch:assert test="/ex:Document/@classification='top-secret'">
             If there is a Para labeled "top-secret" then the Document  
             should be labeled top-secret
         </sch:assert>

      </sch:rule>

      <sch:rule context="ex:Para[@classification='secret']">

         <sch:assert test="(/ex:Document/@classification='top-secret') or
                           (/ex:Document/@classification='secret')">
             If there is a Para labeled "secret" then the Document  
             should be labeled either secret or top-secret
         </sch:assert>

      </sch:rule>

      <sch:rule context="ex:Para[@classification='confidential']">

         <sch:assert test="(/ex:Document/@classification='top-secret') or
                           (/ex:Document/@classification='secret') or 
                           (/ex:Document/@classification='confidential')">
             If there is a Para labeled "confidential" then the Document  
             should be labeled either confidential, secret or top-secret
         </sch:assert>

      </sch:rule>

   </sch:pattern>

</sch:schema>