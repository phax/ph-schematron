<sch:schema
xmlns:sch="http://purl.oclc.org/dsdl/schematron"
xmlns:rng="http://relaxng.org/ns/structure/1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
queryBinding="xslt2">

  <sch:diagnostics>
    <sch:diagnostic id="unique">Element <sch:name/> has xml:id "<sch:value-of select="@xml:id"/>" that is <sch:emph>not unique</sch:emph>.</sch:diagnostic>
  </sch:diagnostics>
  <sch:diagnostics>
    <sch:diagnostic id="unique-code">Element <sch:value-of select="name()"/> has pbs:code "<sch:value-of select="pbs:code"/>" that is <sch:emph>not unique</sch:emph> (in section "<sch:value-of select="ancestor::pbs:program/pbs:info/pbs:code"/>").</sch:diagnostic>
  </sch:diagnostics>
  <sch:diagnostics>
    <sch:diagnostic id="orphan-href">Element <sch:value-of select="name()"/> has @xlink:href "<sch:value-of select="@xlink:href"/>" that has <sch:emph>no</sch:emph> matching @xml:id.</sch:diagnostic>
  </sch:diagnostics>
  <sch:diagnostics>
    <sch:diagnostic id="all-or-none-streamlined">Element <sch:name/> has inconsistent streamlined restriction authority methods.</sch:diagnostic>
  </sch:diagnostics>
  <sch:diagnostics>
    <sch:diagnostic id="all-or-none-complex">Element <sch:name/> has inconsistent complex authority required authority methods.</sch:diagnostic>
  </sch:diagnostics>

  <sch:ns prefix="pbs" uri="http://schema.pbs.gov.au/"/>
  <sch:ns prefix="db" uri="http://docbook.org/ns/docbook"/>
  <sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
  <sch:ns prefix="dc" uri="http://purl.org/dc/elements/1.1/"/>
  <sch:ns prefix="dct" uri="http://purl.org/dc/terms/"/>
  <sch:ns prefix="rdf" uri="http://www.w3.org/1999/02/22-rdf-syntax-ns#"/>
  <sch:ns prefix="owl" uri="http://www.w3.org/2002/07/owl#"/>
  <sch:ns prefix="skos" uri="http://www.w3.org/2004/02/skos/core#"/>
  <sch:ns prefix="svg" uri="http://www.w3.org/2000/svg"/>

  <xsl:key name="root" match="*" use="@xml:id"/>
  <xsl:key name="concept" match="rdf:RDF//*" use="@rdf:about"/>
  <xsl:key name="groups" match="pbs:group" use="@xml:id"/>

  <xsl:key name="code" match="pbs:code[not(ancestor::pbs:previous|ancestor::rdf:RDF|ancestor::pbs:product-listing|ancestor::pbs:member-of|ancestor::pbs:ATC|ancestor::pbs:markup-band|pbs:pricing-model) and not(ancestor::*[ends-with(name(), '-reference')])]"
    use="concat(., @rdf:resource)"/>
  <xsl:key name="code.pl" match="pbs:code[not(ancestor::pbs:previous)][ancestor::pbs:product-listing]"
    use="concat(., @rdf:resource)"/>
  <xsl:key name="code.mem" match="pbs:code[not(ancestor::pbs:previous)][ancestor::pbs:member-of]"
    use="concat(., @rdf:resource)"/>
  <xsl:key name="code.atc" match="skos:prefLabel[parent::skos:Concept]"
    use="."/>

  <xsl:key name="dispensing-rule-fee" match="pbs:dispensing-rule" use="pbs:fees-list/pbs:fee-definition/@xml:id"/>
  <xsl:key name="dispensing-rule-markup" match="pbs:dispensing-rule" use="pbs:markups-list/pbs:markup-band/@xml:id"/>
  <xsl:key name="prescribing-rules" match="pbs:prescribing-rule" use="@xml:id"/>
  <xsl:key name="drugs" match="pbs:mp|pbs:mpuu|pbs:mpp|pbs:tp|pbs:tpuu|pbs:tpp|pbs:ctpp" use="@xml:id"/>
  <xsl:key name="drugs-by-code" match="pbs:mp|pbs:mpuu|pbs:mpp|pbs:tp|pbs:tpuu|pbs:tpp|pbs:ctpp" use="pbs:code"/>
  <xsl:key name="program" match="pbs:program" use="pbs:info/pbs:code"/>
  <xsl:key name="product-listing" match="pbs:product-listing" use="pbs:tpp-reference/@xlink:href"/>
  <xsl:key name="organisations" match="pbs:organisation" use="@xml:id"/>
  <xsl:key name="org-code" match="pbs:organisation[not(ancestor::pbs:previous)]" use="pbs:code"/>
  <xsl:key name="fee-definition" match="pbs:fee-definition" use="@xml:id"/>
  <xsl:key name="markup-band" match="pbs:markup-band" use="@xml:id"/>
  <xsl:key name="container-definition" match="pbs:container-definition" use="@xml:id"/>
  <xsl:key name="recovery-prices" match="pbs:recovery-prices" use="@xml:id"/>
  <xsl:key name="restriction" match="pbs:restriction[not(ancestor::pbs:previous)]" use="pbs:code"/>
  <xsl:key name="rwt-restriction" match="pbs:restriction" use="@xml:id"/>
  <xsl:key name="rwt-foreword" match="pbs:foreword" use="@xml:id"/>
  <xsl:key name="rwt-definition" match="pbs:definition" use="@xml:id"/>
  <xsl:key name="rwt-indication" match="pbs:indication" use="@xml:id"/>
  <xsl:key name="rwt-prescriber-instruction" match="pbs:prescriber-instruction" use="@xml:id"/>
  <xsl:key name="rwt-criteria" match="pbs:treatment|pbs:population|pbs:clinical" use="@xml:id"/>
  <xsl:key name="rwt-parameter" match="pbs:location|pbs:care-type|pbs:prescriber|pbs:age|pbs:sex|pbs:other|pbs:condition-parameter|pbs:treatment-parameter|pbs:patient" use="@xml:id"/>
  <xsl:key name="restriction-administrative-advice" match="pbs:administrative-advice"
	   use="@xml:id"/>

  <sch:pattern name="All Schematron Checks">

    <sch:rule context="@xlink:href">
      <sch:assert test="starts-with(., '#')">Hyperlink must be a relative URI fragment identifier. (@xlink:href="<sch:value-of select="."/>)</sch:assert>
      <sch:assert test="key('root', substring-after(., '#'))">Hyperlink must have a defined destination. (@xlink:href="<sch:value-of select="."/>")</sch:assert>
    </sch:rule>

    <sch:rule context="@rdf:resource">
      <!-- NB. SnoMED-CT terms are not defined in the PBS, so exclude them in this assertion -->
      <sch:assert test="key('concept', .) or starts-with(., 'http://snomed.info/sct/')"><sch:name/> must refer to a defined terminology concept. (@rdf:resource="<sch:value-of select="."/>)</sch:assert>
    </sch:rule>
    <sch:rule context="rdf:RDF/*[namespace-uri() != 'http://www.w3.org/1999/02/22-rdf-syntax-ns#' and
		       namespace-uri() != 'http://www.w3.org/2002/07/owl#' and
		       namespace-uri() != 'http://www.w3.org/2004/02/skos/core#']">
      <sch:assert test="key('concept', concat(namespace-uri(), local-name()))"><sch:name/> must have a defined terminology concept as its base type. (@rdf:about="<sch:value-of select="@rdf:about"/>)</sch:assert>
    </sch:rule>

    <sch:rule context="pbs:fee">
      <sch:assert test="starts-with(@xlink:href, '#')"><sch:name/> @xlink:href (="<sch:value-of select="@xlink:href"/>") must be a relative URI fragment identifier.</sch:assert>
      <sch:assert test="ancestor::pbs:previous or
			key('fee-definition', substring-after(@xlink:href, '#'))"><sch:name/> @xlink:href (="<sch:value-of select="@xlink:href"/>") must link to a PBS fee-definition.</sch:assert>
      <sch:assert test="ancestor::pbs:previous or
			generate-id(key('fee-definition', substring-after(@xlink:href, '#'))/ancestor::pbs:program) = generate-id(ancestor::pbs:program)"><sch:name/> for item <sch:value-of select='ancestor::pbs:prescribing-rule/pbs:code'/> (@xlink:href="<sch:value-of select="@xlink:href"/>") must link to a PBS fee-definition in the same program.</sch:assert>
      <!-- TODO: fee definition must be in the same dispensing rule -->
    </sch:rule>

    <sch:rule context="pbs:markup">
      <sch:assert test="starts-with(@xlink:href, '#')"><sch:name/> @xlink:href (="<sch:value-of select="@xlink:href"/>) must be a relative URI fragment identifier.
      </sch:assert>
      <!-- TO DO: should the markup-band be checked to make sure it is in the correct dispensing rule-->
      <sch:assert test="key('markup-band', substring-after(@xlink:href, '#'))"><sch:name/> @xlink:href (="<sch:value-of select="@xlink:href"/>") must link to a markup-band.
      </sch:assert>
    </sch:rule>

    <sch:rule context="pbs:container">
      <sch:assert test="starts-with(@xlink:href, '#')"><sch:name/> @xlink:href (="<sch:value-of select="@xlink:href"/>) must be a relative URI fragment identifier.
      </sch:assert>
      <!-- ZT TODO: check that hyperlink target is a pbs:container-definition -->
      <sch:assert test="key('container-definition', substring-after(@xlink:href, '#'))"><sch:name/> @xlink:href (="<sch:value-of select="@xlink:href"/>") must link to a pbs:container-definition.
      </sch:assert>
    </sch:rule>

    <sch:rule context="pbs:program">
      <sch:assert test="count(key('program', pbs:info/pbs:code)) = 1"><sch:name/> pbs:info/pbs:code (=<sch:value-of select="pbs:info/pbs:code"/>) must be unique</sch:assert>
    </sch:rule>

    <sch:rule context="pbs:prescribing-rule[not(ancestor::pbs:previous)]">
      <sch:assert test="count(key('prescribing-rules', @xml:id)) = 1" diagnostics="unique"><sch:name/> must be unique (@xml:id="<sch:value-of select="@xml:id"/>") (in section "<sch:value-of select="ancestor::pbs:program[1]/@xml:id"/>")</sch:assert>
    </sch:rule>

    <sch:rule context="pbs:prescribing-rule/pbs:solvent-rule/pbs:injectable/pbs:listing-reference">
      <sch:assert test="starts-with(@xlink:href, '#')"><sch:name/> @xlink:href (="<sch:value-of select="@xlink:href"/>") must be a relative URI fragment identifier.
      </sch:assert>
      <sch:assert test="key('root', substring-after(@xlink:href, '#'))/pbs:ready-prepared"><sch:name/> injectable (@xlink:href ="<sch:value-of select="@xlink:href"/>") must link to a ready-prepared item .
      </sch:assert>
      <!-- TODO: All benefit types for all prescriber types must match
      <sch:assert test="key('root', substring-after(@xlink:href, '#'))/@rdf:resource = ancestor::pbs:prescribing-rule/@rdf:resource"><sch:name/> injectable (@xml:id ="<sch:value-of select="ancestor::pbs:prescribing-rule/@xml:id"/>") restriction level mismatch.
      </sch:assert>-->
    </sch:rule>

    <sch:rule context="pbs:prescribing-rule/pbs:ready-prepared">
      <sch:assert test="count(pbs:maximum-prescribable) &lt;= 2"><sch:name/> may not have more than two pbs:maximum-prescribable child  elements.</sch:assert>
      <sch:assert test="count(pbs:maximum-prescribable) = 1 or
			(pbs:maximum-prescribable[1]/@rdf:resource = 'http://pbs.gov.au/reference/pack' and pbs:maximum-prescribable[2]/@rdf:resource = 'http://pbs.gov.au/reference/unit-of-use')"><sch:name/> pbs:maximum-prescribable must be in order 'pack' followed by 'unit-of-use'. In item <sch:value-of select="../pbs:code"/>.</sch:assert>
    </sch:rule>

    <sch:rule context="pbs:prescribing-rule-reference">
      <sch:assert test="starts-with(@xlink:href, '#')"><sch:name/> @xlink:href (="<sch:value-of select="@xlink:href"/>") must be a relative URI fragment identifier.
      </sch:assert>
      <sch:assert test="key('prescribing-rules', substring-after(@xlink:href, '#'))" diagnostics="orphan-href"><sch:name/> @xlink:href (="<sch:value-of select="@xlink:href"/>") must link to a listing.
      </sch:assert>
    </sch:rule>

    <sch:rule context="pbs:contribution[not(ancestor::pbs:previous)]">
      <sch:assert test="not(ancestor::pbs:program/pbs:info/pbs:pricing-model/@rdf:resource = 'http://schema.pbs.gov.au/pricing/ready-prepared-no-premium' or
			ancestor::pbs:program/pbs:info/pbs:pricing-model/@rdf:resource = 'http://schema.pbs.gov.au/pricing/ready-prepared-no-premium-no-charge')">
            <sch:name/> type "<sch:value-of select="@rdf:resource"/>" for item <sch:value-of select="ancestor::pbs:prescribing-rule/pbs:code"/> not permitted in pricing model <sch:value-of select="ancestor::pbs:program/pbs:info/pbs:pricing-model/pbs:code"/>.
      </sch:assert>
      <sch:assert test="not(ancestor::pbs:reimbursement)">
	<sch:name/> type "<sch:value-of select="@rdf:resource"/>" for item <sch:value-of select="ancestor::pbs:prescribing-rule/pbs:code"/> not permitted in reimbursement pricing.
      </sch:assert>
    </sch:rule>

    <!-- TODO: check that pricing model for program is compatible
    <sch:rule context="pbs:maximum-safety-net-value[not(ancestor::pbs:change)]">
      <sch:assert test="(parent::pbs:manufacturer/parent::pbs:product-listing and
			ancestor::pbs:program/pbs:info/pbs:pricing-model = 'http://pbs.gov.au/pricing/ready-prepared-no-premium') or
			ancestor::pbs:program/pbs:info/pbs:pricing-model = 'http://pbs.gov.au/pricing/extemporaneous'"><sch:name/> in incorrect context for item <sch:value-of select="ancestor::pbs:prescribing-rule/pbs:code"/> (<sch:value-of select="ancestor::pbs:program/pbs:info/pbs:code"/> program).</sch:assert>
			</sch:rule>
			-->

    <!-- TODO: fix this assertion
    <sch:rule context="pbs:price">
      <sch:assert test="ancestor::pbs:change or
			key('root', substring(pbs:dispensing-rule-reference/@xlink:href, 2))/self::pbs:dispensing-rule[generate-id(ancestor::pbs:program) = generate-id(current()/ancestor::pbs:program)]">Dispensing rule "<sch:value-of select="pbs:dispensing-rule-reference"/>" on <sch:name/> [id "<sch:value-of select='ancestor-or-self::*[@xml:id][1]/@xml:id'/>"] must be in corresponding pbs:dispensing-rules-list.</sch:assert>
    </sch:rule>
    -->

    <sch:rule context="pbs:extemporaneous-preparation">
      <sch:assert test="count(pbs:prescribing-rule/*) = 0 or
			pbs:prescribing-rule/*[not(self::pbs:ready-prepared|self::pbs:solvent-rule|self::pbs:infusible|self::pbs:extemporaneous-preparation|self::pbs:drug-tariff)]"><sch:name/> "<sch:value-of select='../pbs:code'/>" invalid child element: <sch:value-of select='name(pbs:prescribing-rule/*[self::pbs:ready-prepared|self::pbs:solvent-rule|self::pbs:infusible|self::pbs:extemporaneous-preparation|self::pbs:drug-tariff][1])'/></sch:assert>
    </sch:rule>

    <sch:rule context="*[self::pbs:mp|self::pbs:mpuu|self::pbs:mpp|self::pbs:tp|self::pbs:tpuu|self::pbs:tpp|self::pbs:ctpp][not(ancestor::pbs:previous)]">
      <sch:assert test="count(key('drugs', @xml:id)) = 1" diagnostics="unique">Drug concepts must be unique (@xml:id="<sch:value-of select="@xml:id"/>")</sch:assert>
      <sch:assert test="pbs:code[@rdf:resource = 'http://snomed.info/sct/911000144106' or @rdf:resource = 'http://snomed.info/sct/900062011000036108']" diagnostics="unique">Drug concepts must include AMT ID (@xml:id="<sch:value-of select="@xml:id"/>")</sch:assert>
      <!--
	  <sch:assert test="key('product-listings', concat('#', @xml:id)) and
	  key('organisations', substring-after(pbs:organisation-reference/@xlink:href, '#'))/pbs:code" diagnostics="unique">TPPs must have manufacturer code (@xml:id="<sch:value-of select="@xml:id"/>")</sch:assert>
	  -->
    </sch:rule>

    <sch:rule context="pbs:organisations-list/pbs:organisation[not(ancestor::pbs:previous)]">
      <sch:assert test="count(key('org-code', pbs:code)) = 1" diagnostics="unique"><sch:name/> must be unique (pbs:code="<sch:value-of select="pbs:code"/>") [<sch:value-of select="@xml:id"/>]</sch:assert>
    </sch:rule>

    <!-- TODO: review this -->
    <sch:rule context="pbs:group[not(ancestor::pbs:change)]">
      <sch:assert test="count(key('groups', @xml:id)) = 1" diagnostics="unique">
	Group definition must be unique (@xml:id="<sch:value-of select="@xml:id"/>").
      </sch:assert>
    </sch:rule>

    <sch:rule context="pbs:member-of">
      <sch:assert test="@rdf:resource != ''"><sch:name/> must refer to terminology concept</sch:assert>
      <!-- TODO: review
	  <sch:assert test="key('groups', substring-after(@xlink:href, '#'))"><sch:name/> @xlink:href (="<sch:value-of select="@xlink:href"/>") must link to a group.
      </sch:assert>
    </sch:rule>
    <sch:rule context="pbs:member-of[@xlink:href != ''][not(ancestor::pbs:previous)]">
      <sch:assert test="key('groups', substring-after(@xlink:href, '#'))[pbs:member-type = name(current()/../..)]"><sch:value-of select="name(../..)"/> (@xml:id="<sch:value-of select='../../@xml:id'/>") is incorrect type for group "<sch:value-of select="key('groups', substring-after(@xlink:href, '#'))/pbs:label"/>" (@xml:id="<sch:value-of select="key('groups', substring-after(@xlink:href, '#'))/@xml:id"/>").
      Expected member types: <sch:value-of select="key('groups', substring-after(@xlink:href, '#'))/pbs:member-type"/>.
      </sch:assert>-->
    </sch:rule>

    <sch:rule context="pbs:restriction[not(ancestor::pbs:previous)]">
      <sch:assert test="(pbs:code[@rdf:resource eq 'http://pbs.gov.au/code/restriction'] ne '') and (translate(pbs:code[@rdf:resource eq 'http://pbs.gov.au/code/restriction'], 'U0123456789', '') eq '')"><sch:name/> code "<sch:value-of select="pbs:code[@rdf:resource eq 'http://pbs.gov.au/code/restriction']"/>" is invalid.</sch:assert>
      <sch:assert test="count(key('restriction', pbs:code)) eq 1"><sch:name/> code "<sch:value-of select="pbs:code"/>" must be unique.</sch:assert>
    </sch:rule>
    <sch:rule context="pbs:definition|pbs:foreword|pbs:prescriber-instruction|pbs:administrative-advice|pbs:caution">
      <sch:assert test="(pbs:code ne '') and (translate(pbs:code, 'U0123456789', '') eq '')"><sch:name/> code "<sch:value-of select="pbs:code"/>" is invalid.
      </sch:assert>
    </sch:rule>

    <sch:rule context="pbs:prescribing-text-references-list/*">
      <sch:assert test="not(pbs:code = preceding-sibling::*/pbs:code)"><sch:value-of select="name(..)"/> must not have duplicate references to the same element (pbs:code="<sch:value-of select="pbs:code"/>" in item <sch:value-of select="ancestor::pbs:prescribing-rule/pbs:code"/>)</sch:assert>
    </sch:rule>

    <sch:rule context="*[local-name() != 'prescribing-text-references-list' and local-name() != 'restriction-references-list' and local-name() != 'parameter-reference' and local-name() != 'criteria-reference' and local-name() != 'drug-references-list' and local-name() != 'recovery-price-reference' and contains(name(), '-reference')]">
      <sch:assert test="starts-with(@xlink:href, '#')"><sch:name/> @xlink:href (="<sch:value-of select="@xlink:href"/>) must be a relative URI fragment identifier</sch:assert>
      <sch:assert test="key('root', substring-after(@xlink:href, '#'))"><sch:name/> @xlink:href (="<sch:value-of select="@xlink:href"/>") must be an internal hyperlink.
      </sch:assert>
      <sch:assert test="key('root', substring-after(@xlink:href, '#'))[name() = substring-before(name(current()), '-reference')]"><sch:name/> (="<sch:value-of select="@xlink:href"/>") must link to a <sch:value-of select="substring-before(name(), '-reference')"/> element</sch:assert>
    </sch:rule>
    <sch:rule context="pbs:criteria-reference">
      <sch:assert test="starts-with(@xlink:href, '#')"><sch:name/> @xlink:href (="<sch:value-of select="@xlink:href"/>) must be a relative URI fragment identifier</sch:assert>
      <sch:assert test="key('root', substring-after(@xlink:href, '#'))"><sch:name/> @xlink:href (="<sch:value-of select="@xlink:href"/>") must be an internal hyperlink.
      </sch:assert>
      <sch:assert test="key('root', substring-after(@xlink:href, '#'))[local-name() = 'population' or local-name() = 'clinical' or local-name() = 'treatment']"><sch:name/> (="<sch:value-of select="@xlink:href"/>") must link to a element</sch:assert>
    </sch:rule>

    <sch:rule context="pbs:parameter-reference">
      <sch:assert test="starts-with(@xlink:href, '#')"><sch:name/> @xlink:href (="<sch:value-of select="@xlink:href"/>) must be a relative URI fragment identifier</sch:assert>
      <sch:assert test="key('root', substring-after(@xlink:href, '#'))"><sch:name/> @xlink:href (="<sch:value-of select="@xlink:href"/>") must be an internal hyperlink.
      </sch:assert>
      <sch:assert test="key('root', substring-after(@xlink:href, '#'))[local-name() = 'location' or local-name() = 'care-type' or local-name() = 'prescriber' or local-name() = 'age' or local-name() = 'sex' or local-name() = 'other' or local-name() = 'condition-parameter' or local-name() = 'treatment-parameter' or local-name() = 'patient']"><sch:name/> (="<sch:value-of select="@xlink:href"/>") must link to a element</sch:assert>
    </sch:rule>

    <!--
    <sch:rule context="pbs:recovery-price-reference">
      <sch:assert test="starts-with(@xlink:href, '#')"><sch:name/> @xlink:href (="<sch:value-of select="@xlink:href"/>") must be a relative URI fragment identifier.
      </sch:assert>
      <sch:assert test="key('recovery-prices', substring-after(@xlink:href, '#'))"><sch:name/> (="<sch:value-of select="@xlink:href"/>") must link to a pbs:recovery-price element.
      </sch:assert>
    </sch:rule>

    <sch:rule context="pbs:mp-reference">
      <sch:assert test="starts-with(@xlink:href, '#')"><sch:name/> @xlink:href (="<sch:value-of select="@xlink:href"/>) must be a relative URI fragment identifier.
      </sch:assert>
      <sch:assert test="key('mps', substring-after(@xlink:href, '#'))"><sch:name/> (="<sch:value-of select="@xlink:href"/>") must link to a MP.
      </sch:assert>
    </sch:rule>

    <sch:rule context="pbs:mpp-reference">
      <sch:assert test="starts-with(@xlink:href, '#')"><sch:name/> @xlink:href (="<sch:value-of select="@xlink:href"/>) must be a relative URI fragment identifier.
      </sch:assert>
      <sch:assert test="key('mpps', substring-after(@xlink:href, '#'))"><sch:name/> (="<sch:value-of select="@xlink:href"/>") must link to an MPP.
      </sch:assert>
    </sch:rule>

    <sch:rule context="pbs:tpp-reference">
      <sch:assert test="starts-with(@xlink:href, '#')"><sch:name/> @xlink:href (="<sch:value-of select="@xlink:href"/>") must be a relative URI fragment identifier. In prescribing rule <sch:value-of select='ancestor::pbs:prescribing-rule/pbs:code'/>.
      </sch:assert>
      <sch:assert test="key('tpps', substring-after(@xlink:href, '#'))"><sch:name/> @xlink:href (="<sch:value-of select="@xlink:href"/>") must link to a TPP. In prescribing rule <sch:value-of select='ancestor::pbs:prescribing-rule/pbs:code'/>.
      </sch:assert>
    </sch:rule>

    <sch:rule context="pbs:organisation-reference">
      <sch:assert test="starts-with(@xlink:href, '#')"><sch:name/> @xlink:href (="<sch:value-of select="@xlink:href"/>") must be a relative URI fragment identifier.
      </sch:assert>
      <sch:assert test="key('organisations', substring-after(@xlink:href, '#'))"><sch:name/> @xlink:href (="<sch:value-of select="@xlink:href"/>") must link to a organisation.
      </sch:assert>
    </sch:rule>

    <sch:rule context="pbs:indication-reference">
      <sch:assert test="starts-with(@xlink:href, '#')"><sch:name/> @xlink:href (="<sch:value-of select="@xlink:href"/>) must be a relative URI fragment identifier</sch:assert>
      <sch:assert test="key('rwt-indication', substring-after(@xlink:href, '#'))"><sch:name/> (="<sch:value-of select="@xlink:href"/>") must link to a pbs:indication element</sch:assert>
    </sch:rule>

    <sch:rule context="pbs:prescriber-instruction-reference">
      <sch:assert test="starts-with(@xlink:href, '#')"><sch:name/> @xlink:href (="<sch:value-of select="@xlink:href"/>) must be a relative URI fragment identifier</sch:assert>
      <sch:assert test="key('rwt-prescriber-instruction', substring-after(@xlink:href, '#'))"><sch:name/> (="<sch:value-of select="@xlink:href"/>") must link to a pbs:prescriber-instruction element.
      </sch:assert>
    </sch:rule>

    <sch:rule context="pbs:criteria-reference">
      <sch:assert test="starts-with(@xlink:href, '#')"><sch:name/> @xlink:href (="<sch:value-of select="@xlink:href"/>) must be a relative URI fragment identifier</sch:assert>
      <sch:assert test="key('rwt-criteria', substring-after(@xlink:href, '#'))"><sch:name/> (="<sch:value-of select="@xlink:href"/>") must link to a criteria-type element</sch:assert>
    </sch:rule>

    <sch:rule context="pbs:parameter-reference">
      <sch:assert test="starts-with(@xlink:href, '#')"><sch:name/> @xlink:href (="<sch:value-of select="@xlink:href"/>) must be a relative URI fragment identifier</sch:assert>
      <sch:assert test="key('rwt-parameter', substring-after(@xlink:href, '#'))"><sch:name/> (="<sch:value-of select="@xlink:href"/>") must link to a parameter-type element</sch:assert>
    </sch:rule>
    -->

    <sch:rule context="pbs:code[not(ancestor::pbs:previous|ancestor::rdf:RDF|ancestor::pbs:product-listing|ancestor::pbs:member-of|ancestor::pbs:ATC|ancestor::pbs:markup-band|ancestor::pbs:pricing-model) and not(ancestor::*[ends-with(name(), '-reference')])]">
      <sch:assert test="string-length(.) != 0">Code must not be an empty value (in <sch:value-of select="name(..)"/> @xml:id="<sch:value-of select="ancestor-or-self::*[@xml:id][1]/@xml:id"/>")</sch:assert>
      <sch:assert test="not(contains(., ' '))">Code must not contain white space (in <sch:value-of select="name(..)"/> @xml:id="<sch:value-of select="ancestor-or-self::*[@xml:id][1]/@xml:id"/>")</sch:assert>
      <sch:assert test="count(key('code', concat(., @rdf:resource))) eq 1">Code must be unique within its type (in <sch:value-of select="name(..)"/> value="<sch:value-of select="."/>" type=<sch:value-of select="@rdf:resource"/> @xml:id="<sch:value-of select="ancestor-or-self::*[@xml:id][1]/@xml:id"/>")</sch:assert>
      <sch:assert test="@rdf:resource">Code missing terminology reference [1] (in <sch:value-of select="name(..)"/> @xml:id="<sch:value-of select="ancestor-or-self::*[@xml:id][1]/@xml:id"/>")</sch:assert>
      <sch:assert test="not(preceding-sibling::pbs:code[@rdf:resource eq current()/@rdf:resource])">More than one code in <sch:value-of select="name(..)"/> (@xml:id="<sch:value-of select="ancestor-or-self::*[@xml:id][1]/@xml:id"/>") has terminology concept <sch:value-of select="@rdf:resource"/></sch:assert>
    </sch:rule>
    <!-- markup-band and pricing-model codes must still comply with this rule -->
    <sch:rule context="pbs:code[not(ancestor::pbs:previous|ancestor::rdf:RDF|ancestor::pbs:product-listing|ancestor::pbs:ATC) and (ancestor::*[ends-with(name(), '-reference')] or ancestor::pbs:member-of)]">
      <sch:assert test="string-length(.) != 0">Code must not be an empty value (in <sch:value-of select="name(..)"/> @xml:id="<sch:value-of select="ancestor-or-self::*[@xml:id][1]/@xml:id"/>")</sch:assert>
      <sch:assert test="not(contains(., ' '))">Code must not contain white space (in <sch:value-of select="name(..)"/> @xml:id="<sch:value-of select="ancestor-or-self::*[@xml:id][1]/@xml:id"/>")</sch:assert>
    </sch:rule>

    <sch:rule context="pbs:code[not(ancestor::pbs:previous)][ancestor::pbs:product-listing][@rdf:resource eq 'http://pbs.gov.au/code/product-listing']">
      <sch:assert test="string-length(.) != 0">Code must not be an empty value (in <sch:value-of select="name(..)"/> @xml:id="<sch:value-of select="ancestor-or-self::*[@xml:id][1]/@xml:id"/>")</sch:assert>
      <sch:assert test="not(contains(., ' '))">Code must not contain white space (in <sch:value-of select="name(..)"/> @xml:id="<sch:value-of select="ancestor-or-self::*[@xml:id][1]/@xml:id"/>")</sch:assert>
      <sch:assert test="@rdf:resource">Code missing terminology reference [3] (in <sch:value-of select="name(..)"/> @xml:id="<sch:value-of select="ancestor-or-self::*[@xml:id][1]/@xml:id"/>")</sch:assert>
      <sch:assert test="count(key('code.pl', concat(., @rdf:resource))) eq 1">Code must be unique within its type (in <sch:value-of select="name(..)"/> value="<sch:value-of select="."/>" type=<sch:value-of select="@rdf:resource"/> @xml:id="<sch:value-of select="ancestor-or-self::*[@xml:id][1]/@xml:id"/>")</sch:assert>
    </sch:rule>

    <sch:rule context="pbs:code[not(ancestor::pbs:previous)][ancestor::pbs:product-listing][not(ancestor::pbs:member-of-list)][@rdf:resource ne 'http://pbs.gov.au/code/product-listing' and @rdf:resource ne 'http://pbs.gov.au/code/dispensing-rule']">
      <sch:assert test="string-length(.) != 0">Code must not be an empty value (in <sch:value-of select="name(..)"/> @xml:id="<sch:value-of select="ancestor-or-self::*[@xml:id][1]/@xml:id"/>")</sch:assert>
      <sch:assert test="not(contains(., ' '))">Code must not contain white space (in <sch:value-of select="name(..)"/> @xml:id="<sch:value-of select="ancestor-or-self::*[@xml:id][1]/@xml:id"/>")</sch:assert>
      <sch:assert test="@rdf:resource">Code missing terminology reference [4] (in <sch:value-of select="name(..)"/> @xml:id="<sch:value-of select="ancestor-or-self::*[@xml:id][1]/@xml:id"/>")</sch:assert>
      <sch:assert test="count(key('code', concat(., @rdf:resource))) eq 1">No target element found with matching code (in <sch:value-of select="name(..)"/> value="<sch:value-of select="."/>" type=<sch:value-of select="@rdf:resource"/> @xml:id="<sch:value-of select="ancestor-or-self::*[@xml:id][1]/@xml:id"/>")</sch:assert>
    </sch:rule>

    <sch:rule context="pbs:code[not(ancestor::pbs:previous)][ancestor::pbs:ATC]">
      <sch:assert test="string-length(.) != 0">Code must not be an empty value (in <sch:value-of select="name(..)"/> @xml:id="<sch:value-of select="ancestor-or-self::*[@xml:id][1]/@xml:id"/>")</sch:assert>
      <sch:assert test="not(contains(., ' '))">Code must not contain white space (in <sch:value-of select="name(..)"/> @xml:id="<sch:value-of select="ancestor-or-self::*[@xml:id][1]/@xml:id"/>")</sch:assert>
      <sch:assert test="@rdf:resource">Code missing terminology reference [5] (in <sch:value-of select="name(..)"/> @xml:id="<sch:value-of select="ancestor-or-self::*[@xml:id][1]/@xml:id"/>")</sch:assert>
      <sch:assert test="count(key('code.atc', .)) eq 1">No SKOS concept found with matching preferred label (in <sch:value-of select="name(..)"/> value="<sch:value-of select="."/>" type=<sch:value-of select="@rdf:resource"/> @xml:id="<sch:value-of select="ancestor-or-self::*[@xml:id][1]/@xml:id"/>")</sch:assert>
    </sch:rule>

    <sch:rule context="*[@rdf:about]">
      <sch:assert test="count(key('concept', @rdf:about)) = 1" diagnostics="unique">Semantic concepts must be unique (@rdf:about="<sch:value-of select="@rdf:about"/>")</sch:assert>
    </sch:rule>
  </sch:pattern>

</sch:schema>
