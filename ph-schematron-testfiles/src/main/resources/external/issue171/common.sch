<?xml version="1.0" encoding="UTF-8"?>

<pattern xmlns="http://purl.oclc.org/dsdl/schematron"
  id="global-variable-pattern">

  <!-- This pattern solely serves for declaring global variables (in XSLT speak) -->
  <!--<let name="EFORMS-DE-MAJOR-MINOR-VERSION" value="'1.0'"/>
    <let name="EFORMS-DE-ID" value="concat('eforms-de-', $EFORMS-DE-MAJOR-MINOR-VERSION )"/>-->

  <let name="EMAIL-REGEX"
    value="'^[a-zA-Z0-9!#\$%&amp;&quot;*+/=?^_`{|}~-]+(\.[a-zA-Z0-9!#\$%&amp;&quot;*+/=?^_`{|}~-]+)*@([a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$'" />


</pattern>
