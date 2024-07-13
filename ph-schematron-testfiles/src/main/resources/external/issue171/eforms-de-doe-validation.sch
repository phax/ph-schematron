<?xml version="1.0" encoding="UTF-8"?>

<pattern xmlns="http://purl.oclc.org/dsdl/schematron"
  id="doe-validation-pattern">

  <!-- This pattern solely serves for rules which can only used shortly before sending DoE and in DoE itself -->

<rule context="$ROOT-NODE">

<let name="CURRENT-DATE-TIME" value="current-dateTime()" />
<let name="CURRENT-DATE" value="current-date()" />


<assert test="$BT-05-DATE ge $CURRENT-DATE - xs:dayTimeDuration('P1D')">Date of BT-05=<value-of select="$BT-05-DATE"/> must be less than 1 day in the past. Current date=<value-of select="$CURRENT-DATE"/>. Difference=<value-of select="$CURRENT-DATE - $BT-05-DATE"/></assert>


<assert test="$BT-05-DATE le $CURRENT-DATE + xs:dayTimeDuration('P1D')">Date of BT-05=<value-of select="$BT-05-DATE"/> must be less than 1 day in the future. Current date=<value-of select="$CURRENT-DATE"/>. Difference=<value-of select="$CURRENT-DATE + xs:dayTimeDuration('P1D')"/></assert>


</rule>


</pattern>
