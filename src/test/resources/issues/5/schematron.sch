<?xml version="1.0" encoding="utf-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
    <sch:ns prefix="adrmsg" uri="http://www.eurocontrol.int/cfmu/b2b/ADRMessage"/>
    <sch:ns prefix="adr" uri="http://www.aixm.aero/schema/5.1/extensions/ADR"/>
    <sch:ns prefix="aixm" uri="http://www.opengis.net/gml/3.2"/>
    <sch:ns prefix="gml" uri="http://www.aixm.aero/schema/5.1"/>
    <sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
    <!-- Your constraints go here -->
    <sch:pattern id="doc.checks">
        <sch:rule id="This_is_rule_one_a"
            context = "//aixm:AirporHeliportTimeSlice">
            <sch:assert test="child::aixm:timeSlice">
                    Each AirportHeliport must have at least one ContactInformation.PostalAddress and
                    at least one ContactInformation.TelephoneContact.voice
            </sch:assert>
        </sch:rule>
        <sch:rule id="This_is_rule_one_b"
            context = "/">
            <sch:assert test="child::aixm:noddy">
                Noddies no here
            </sch:assert>
        </sch:rule>
        <sch:rule id="This_is_rule_one_c"
            context = "//aixm:AirporHeliportTimeSlice">
            <sch:assert test="parent::aixm:timeSlice">
                    Each AirportHeliport must have at least one ContactInformation.PostalAddress and
                    at least one ContactInformation.TelephoneContact.voice
            </sch:assert>
        </sch:rule>
        
    </sch:pattern>
</sch:schema>