<?xml version="1.0" encoding="UTF-8"?>
<!--

    Copyright (C) 2014-2026 Philip Helger (www.helger.com)
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
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <title>Abstract pattern</title>
  <ns prefix="ex" uri="urn:example" />
  <pattern abstract="true" id="has-attr">
    <rule context="$element">
      <assert test="@$attr">The element has no $attr.</assert>
    </rule>
  </pattern>
  <pattern is-a="has-attr" id="order-id">
    <param name="element" value="ex:order" />
    <param name="attr" value="id" />
  </pattern>
  <pattern id="empty" />
</schema>
