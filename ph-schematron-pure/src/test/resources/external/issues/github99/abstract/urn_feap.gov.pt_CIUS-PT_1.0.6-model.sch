<pattern xmlns="http://purl.oclc.org/dsdl/schematron" abstract="true" id="model">
  <rule context="$Additional_supporting_documents ">
    <assert test="$BR-52" flag="fatal" id="BR-52">[BR-52]-Each Additional supporting document (BG-24) shall contain a Supporting document reference (BT-122).</assert>
    <report test="$BR-CIUS-PT-30" flag="fatal" id="BR-CIUS-PT-30">[BR-CIUS-PT-30]-If Additional Supporting Documents (BG-24) is used, the External document location (BT-124) or the Attached document (BT-125) shall be filled, or both.</report>
  </rule>
  <rule context="$Buyer">
    <report test="$BR-CIUS-PT-38" flag="fatal" id="BR-CIUS-PT-38">[BR-CIUS-PT-38]-The Buyer identifier (BT-46) shall be filled.</report>
    <report test="$BR-CIUS-PT-39" flag="fatal" id="BR-CIUS-PT-39">[BR-CIUS-PT-39]-The Buyer trading name (BT-45) shall be filled.</report>
    <report test="$BR-CIUS-PT-40" flag="fatal" id="BR-CIUS-PT-40">[BR-CIUS-PT-40]-The Buyer contact point (BT-56) or the Buyer contact telephone number (BT-57) or the Buyer contact email address (BT-58) shall be filled.</report>
  </rule>
  <rule context="$Buyer_electronic_address">
    <assert test="$BR-63" flag="fatal" id="BR-63">[BR-63]-The Buyer electronic address (BT-49) shall have a Scheme identifier.    </assert>
  </rule>
  <rule context="$Buyer_postal_address">
    <assert test="$BR-11" flag="fatal" id="BR-11">[BR-11]-The Buyer postal address shall contain a Buyer country code (BT-55).</assert>
    <report test="$BR-CIUS-PT-41" flag="fatal" id="BR-CIUS-PT-41">[BR-CIUS-PT-41]-The Buyer address line 3 (BT-163) shall be filled.</report>
  </rule>
  <rule context="$Contract_Document_Reference">
    <assert test="$BR-CIUS-PT-29" flag="fatal" id="BR-CIUS-PT-29">[BR-CIUS-PT-29]-The Contract reference (BT-12) shall be filled.</assert>
  </rule>
  <rule context="$Delivery">
    <report test="$BR-CIUS-PT-46" flag="fatal" id="BR-CIUS-PT-46">[BR-CIUS-PT-46]-The Deliver to party name (BT-70) shall be filled.</report>
    <assert test="$BR-CIUS-PT-64" flag="fatal" id="BR-CIUS-PT-64">[BR-CIUS-PT-64]-The Actual delivery date (BT-72)  or the Deliver to location identifier (BT-71) or the Deliver to Address (BG-15) or the Deliver to party name (BT-70) shall be filled.</assert>
  </rule>
  <rule context="$Deliver_to_address">
    <assert test="$BR-CIUS-PT-21" flag="fatal" id="BR-CIUS-PT-21">[BR-CIUS-PT-21]-Each Deliver to address (BG-15) shall contain a Seller address line 1 (BT-75).</assert>
    <assert test="$BR-CIUS-PT-22" flag="fatal" id="BR-CIUS-PT-22">[BR-CIUS-PT-22]-Each Deliver to address (BG-15) shall contain a Seller city (BT-77).</assert>
    <assert test="$BR-CIUS-PT-23" flag="fatal" id="BR-CIUS-PT-23">[BR-CIUS-PT-23]-Each Deliver to address (BG-15) shall contain a Seller post code (BT-78).</assert>
    <assert test="$BR-57" flag="fatal" id="BR-57">[BR-57]-Each Deliver to address (BG-15) shall contain a Deliver to country code (BT-80).</assert>
    <report test="$BR-CIUS-PT-45" flag="fatal" id="BR-CIUS-PT-45">[BR-CIUS-PT-45]-The Deliver to address line 3 (BT-165) shall be filled.</report>
  </rule>
  <rule context="$Despatch_Document_Reference">
    <assert test="$BR-CIUS-PT-26" flag="fatal" id="BR-CIUS-PT-26">[BR-CIUS-PT-26]-The Despatch advice reference (BT-16) shall be filled.</assert>
  </rule>
  <rule context="$Document_level_allowances ">
    <assert test="$BR-31" flag="fatal" id="BR-31">[BR-31]-Each Document level allowance (BG-20) shall have a Document level allowance amount (BT-92).</assert>
    <assert test="$BR-32" flag="fatal" id="BR-32">[BR-32]-Each Document level allowance (BG-20) shall have a Document level allowance VAT category code (BT-95).</assert>
    <assert test="$BR-33" flag="fatal" id="BR-33">[BR-33]-Each Document level allowance (BG-20) shall have a Document level allowance reason (BT-97) or a Document level allowance reason code (BT-98).</assert>
    <assert test="$BR-CO-21" flag="fatal" id="BR-CO-21">[BR-CO-21]-Each Document level allowance (BG-20) shall contain a Document level allowance reason (BT-97) or a Document level allowance reason code (BT-98), or both.</assert>
    <assert test="$BR-CIUS-PT-19" flag="fatal" id="BR-CIUS-PT-19">[BR-CIUS-PT-19]-Each Document level allowance (BG-20) shall have a tax scheme.</assert>
  </rule>
  <rule context="$Document_level_charges ">
    <assert test="$BR-36" flag="fatal" id="BR-36">[BR-36]-Each Document level charge (BG-21) shall have a Document level charge amount (BT-99).</assert>
    <assert test="$BR-37" flag="fatal" id="BR-37">[BR-37]-Each Document level charge (BG-21) shall have a Document level charge VAT category code (BT-102).</assert>
    <assert test="$BR-38" flag="fatal" id="BR-38">[BR-38]-Each Document level charge (BG-21) shall have a Document level charge reason (BT-104) or a Document level charge reason code (BT-105).    </assert>
    <assert test="$BR-CO-22" flag="fatal" id="BR-CO-22">[BR-CO-22]-Each Document level charge (BG-21) shall contain a Document level charge reason (BT-104) or a Document level charge reason code (BT-105), or both.</assert>
    <assert test="$BR-CIUS-PT-20" flag="fatal" id="BR-CIUS-PT-20">[BR-CIUS-PT-20]-Each Document level charge (BG-21) shall have a tax scheme.</assert>
  </rule>
  <rule context="$Document_totals ">
    <assert test="$BR-12" flag="fatal" id="BR-12">[BR-12]-An Invoice shall have the Sum of Invoice line net amount (BT-106).</assert>
    <assert test="$BR-13" flag="fatal" id="BR-13">[BR-13]-An Invoice shall have the Invoice total amount without VAT (BT-109).</assert>
    <assert test="$BR-14" flag="fatal" id="BR-14">[BR-14]-An Invoice shall have the Invoice total amount with VAT (BT-112).</assert>
    <assert test="$BR-15" flag="fatal" id="BR-15">[BR-15]-An Invoice shall have the Amount due for payment (BT-115).</assert>
    <report test="$BR-CIUS-PT-62" flag="fatal" id="BR-CIUS-PT-62">[BR-CIUS-PT-62]-If Document Level Allowances (BG-20) is used, the Sum of allowances on document level (BT-107) shall be filled.</report>
    <report test="$BR-CIUS-PT-63" flag="fatal" id="BR-CIUS-PT-63">[BR-CIUS-PT-63]-If Document Level Charges (BG-21) is used, the Sum of charges on document level (BT-108) shall be filled.</report>
  </rule>
  <rule context="$Invoice ">
    <assert test="$BR-01" flag="fatal" id="BR-01">[BR-01]-An Invoice shall have a Specification identifier (BT-24).   </assert>
    <assert test="$BR-02" flag="fatal" id="BR-02">[BR-02]-An Invoice shall have an Invoice number (BT-1).</assert>
    <assert test="$BR-03" flag="fatal" id="BR-03">[BR-03]-An Invoice shall have an Invoice issue date (BT-2).</assert>
    <assert test="$BR-04" flag="fatal" id="BR-04">[BR-04]-An Invoice shall have an Invoice type code (BT-3).</assert>
    <assert test="$BR-05" flag="fatal" id="BR-05">[BR-05]-An Invoice shall have an Invoice currency code (BT-5).</assert>
    <assert test="$BR-06" flag="fatal" id="BR-06">[BR-06]-An Invoice shall contain the Seller name (BT-27).</assert>
    <assert test="$BR-CIUS-PT-01" flag="fatal" id="BR-CIUS-PT-01">[BR-CIUS-PT-01]-An Invoice shall contain the Seller VAT identifier (BT-31).</assert>
    <assert test="$BR-CIUS-PT-02" flag="fatal" id="BR-CIUS-PT-02">[BR-CIUS-PT-02]-An Invoice shall contain the Seller VAT tax scheme (VAT).</assert>
    <assert test="$BR-07" flag="fatal" id="BR-07">[BR-07]-An Invoice shall contain the Buyer name (BT-44).</assert>
    <assert test="$BR-CIUS-PT-03" flag="fatal" id="BR-CIUS-PT-03">[BR-CIUS-PT-03]-An Invoice shall contain the Buyer VAT identifier (BT-48).</assert>
    <assert test="$BR-CIUS-PT-04" flag="fatal" id="BR-CIUS-PT-04">[BR-CIUS-PT-04]-An Invoice shall contain the Buyer VAT tax scheme (VAT).</assert>
    <assert test="$BR-08" flag="fatal" id="BR-08">[BR-08]-An Invoice shall contain the Seller postal address (BG-5). </assert>
    <assert test="$BR-10" flag="fatal" id="BR-10">[BR-10]-An Invoice shall contain the Buyer postal address (BG-8).</assert>
    <assert test="$BR-16" flag="fatal" id="BR-16">[BR-16]-An Invoice shall have at least one Invoice line (BG-25)</assert>
    <assert test="$BR-CIUS-PT-10" flag="fatal" id="BR-CIUS-PT-10">[BR-CIUS-PT-10]-An Invoice shall contain the Document Totals (BG-22).</assert>
    <assert test="$BR-CIUS-PT-11" flag="fatal" id="BR-CIUS-PT-11">[BR-CIUS-PT-11]-An Invoice shall contain the Total VAT amount (BT-110).</assert>
    <report test="$BR-CIUS-PT-25" flag="fatal" id="BR-CIUS-PT-25">[BR-CIUS-PT-25]-A Credit Note shall contain the Preceding Invoice Reference (BG-3).</report>
    <assert test="$BR-CO-03" flag="fatal" id="BR-CO-03">[BR-CO-03]-Value added tax point date (BT-7) and Value added tax point date code (BT-8) are mutually exclusive.</assert>
    <assert test="$BR-CO-18" flag="fatal" id="BR-CO-18">[BR-CO-18]-An Invoice shall at least have one VATBReakdown group (BG-23).</assert>
    <assert test="$BR-AA-02" flag="fatal" id="BR-AA-02">[BR-AA-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is “Lower rate” shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
    <assert test="$BR-AA-03" flag="fatal" id="BR-AA-03">[BR-AA-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is “Lower rate” shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
    <assert test="$BR-AA-04" flag="fatal" id="BR-AA-04">[BR-AA-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is “Lower rate” shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
    <assert test="$BR-S-02" flag="fatal" id="BR-S-02">[BR-S-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is “Standard rated” shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
    <assert test="$BR-S-03" flag="fatal" id="BR-S-03">[BR-S-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is “Standard rated” shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
    <assert test="$BR-S-04" flag="fatal" id="BR-S-04">[BR-S-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is “Standard rated” shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
    <assert test="$BR-E-02" flag="fatal" id="BR-E-02">[BR-E-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is “Exempt from VAT” shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
    <assert test="$BR-E-03" flag="fatal" id="BR-E-03">[BR-E-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is “Exempt from VAT” shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
    <assert test="$BR-E-04" flag="fatal" id="BR-E-04">[BR-E-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is “Exempt from VAT” shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
	<report test="$BR-CIUS-PT-65" flag="fatal" id="BR-CIUS-PT-65">[BR-CIUS-PT-65]-An Invoice with type code equal to 383 or ND shall contain the Preceding Invoice Reference (BG-3).</report>
    <assert test="$BR-CIUS-PT-66" flag="fatal" id="BR-CIUS-PT-66">[BR-CIUS-PT-66]-An Invoice shall at least have one Deliver to address group (BG-15).</assert>
  </rule>
  <rule context="$Invoice_Line ">
    <assert test="$BR-21" flag="fatal" id="BR-21">[BR-21]-Each Invoice line (BG-25) shall have an Invoice line identifier (BT-126).</assert>
    <assert test="$BR-22" flag="fatal" id="BR-22">[BR-22]-Each Invoice line (BG-25) shall have an Invoiced quantity (BT-129).</assert>
    <report test="$BR-23" flag="fatal" id="BR-23">[BR-23]-An Invoice line (BG-25) shall have an Invoiced quantity unit of measure code (BT-130).</report>
    <assert test="$BR-24" flag="fatal" id="BR-24">[BR-24]-Each Invoice line (BG-25) shall have an Invoice line net amount (BT-131).</assert>
    <assert test="$BR-25" flag="fatal" id="BR-25">[BR-25]-Each Invoice line (BG-25) shall contain the Item name (BT-153).</assert>
    <assert test="$BR-26" flag="fatal" id="BR-26">[BR-26]-Each Invoice line (BG-25) shall contain the Item net price (BT-146).</assert>
    <assert test="$BR-CIUS-PT-09" flag="fatal" id="BR-CIUS-PT-09">[BR-CIUS-PT-09]-Each Invoice line (BG-25) shall have a tax scheme.</assert>
    <report test="$BR-CIUS-PT-51" flag="fatal" id="BR-CIUS-PT-51">[BR-CIUS-PT-51]-The Referenced purchase order line reference (BT-132) shall be filled.</report>
    <report test="$BR-CIUS-PT-52" flag="fatal" id="BR-CIUS-PT-52">[BR-CIUS-PT-52]-The Invoice line object identifier (BT-128) shall be filled.</report>
  </rule>
  <rule context="$Invoice_line_allowances ">
    <assert test="$BR-41" flag="fatal" id="BR-41">[BR-41]-Each Invoice line allowance (BG-27) shall have an Invoice line allowance amount (BT-136).</assert>
    <assert test="$BR-42" flag="fatal" id="BR-42">[BR-42]-Each Invoice line allowance (BG-27) shall have an Invoice line allowance reason (BT-139) or an Invoice line allowance reason code (BT-140).</assert>
    <assert test="$BR-CO-07" flag="fatal" id="BR-CO-07">[BR-CO-07]-Invoice line allowance reason code (BT-140) and Invoice line allowance reason (BT-139) shall indicate the same type of allowance reason.</assert>
    <assert test="$BR-CO-23" flag="fatal" id="BR-CO-23">[BR-CO-23]-Each Invoice line allowance (BG-27) shall contain an Invoice line allowance reason (BT-139) or an Invoice line allowance reason code (BT-140), or both.</assert>
  </rule>
  <rule context="$Invoice_line_charges ">
    <assert test="$BR-43" flag="fatal" id="BR-43">[BR-43]-Each Invoice line charge (BG-28) shall have an Invoice line charge amount (BT-141).</assert>
    <assert test="$BR-44" flag="fatal" id="BR-44">[BR-44]-Each Invoice line charge shall have an Invoice line charge reason or an invoice line allowance reason code. </assert>
    <assert test="$BR-CO-08" flag="fatal" id="BR-CO-08">[BR-CO-08]-Invoice line charge reason code (BT-145) and Invoice line charge reason (BT144) shall indicate the same type of charge reason.</assert>
    <assert test="$BR-CO-24" flag="fatal" id="BR-CO-24">[BR-CO-24]-Each Invoice line charge (BG-28) shall contain an Invoice line charge reason (BT-144) or an Invoice line charge reason code (BT-145), or both.</assert>
  </rule>
  <rule context="$Invoice_Line_Item">
    <report test="$BR-CIUS-PT-53" flag="fatal" id="BR-CIUS-PT-53">[BR-CIUS-PT-53]-The Item Buyer's identifier (BT-156) shall be filled.</report>
    <report test="$BR-CIUS-PT-54" flag="fatal" id="BR-CIUS-PT-54">[BR-CIUS-PT-54]-The Item Seller's identifier (BT-155) shall be filled.</report>
    <report test="$BR-CIUS-PT-55" flag="fatal" id="BR-CIUS-PT-55">[BR-CIUS-PT-55]-The Item standard identifier (BT-157) shall be filled.</report>
    <report test="$BR-CIUS-PT-56" flag="fatal" id="BR-CIUS-PT-56">[BR-CIUS-PT-56]-The Item country of origin (BT-159) shall be filled.</report>
    <report test="$BR-CIUS-PT-57" flag="fatal" id="BR-CIUS-PT-57">[BR-CIUS-PT-57]-The Item classification identifier (BT-158) shall be filled.</report>
    <report test="$BR-CIUS-PT-18" flag="fatal" id="BR-CIUS-PT-18">[BR-CIUS-PT-18]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Exempt from VAT" shall have a VAT exemption reason code (BT-160) or VAT exemption reason text (BT-160).</report>
  </rule>
  <rule context="$Invoice_Line_Period ">
    <assert test="$BR-30" flag="fatal" id="BR-30">[BR-30]-If both Invoice line period start date (BT-134) and Invoice line period end date (BT-135) are given then the Invoice line period end date (BT-135) shall be later or equal to the Invoice line period start date (BT-134).</assert>
    <assert test="$BR-CO-20" flag="fatal" id="BR-CO-20">[BR-CO-20]-If Invoice line period (BG-26) is used, the Invoice line period start date (BT-134) or the Invoice line period end date (BT-135) shall be filled, or both.</assert>
  </rule>
  <rule context="$Invoice_Line_Price">
    <assert test="$BR-CIUS-PT-58" flag="fatal" id="BR-CIUS-PT-58">[BR-CIUS-PT-58]-The Item price charge are not allowed at the Price Details (BG-29).</assert>
    <report test="$BR-CIUS-PT-59" flag="fatal" id="BR-CIUS-PT-59">[BR-CIUS-PT-59]-The Item price discount (BT-147) shall be filled.</report>
  </rule>
  <rule context="$Invoice_Period ">
    <assert test="$BR-29" flag="fatal" id="BR-29">[BR-29]-If both Invoicing period start date (BT-73) and Invoicing period end date (BT-74) are given then the Invoicing period end date (BT-74) shall be later or equal to the Invoicing period start date (BT-73).</assert>
    <assert test="$BR-CO-19" flag="fatal" id="BR-CO-19">[BR-CO-19]-If Invoicing period (BG-14) is used, the Invoicing period start date (BT-73) or the Invoicing period end date (BT-74) shall be filled, or both.</assert>
  </rule>
  <rule context="$Item_attributes ">
    <assert test="$BR-54" flag="fatal" id="BR-54">[BR-54]-Each Item attribute (BG-32) shall contain an Item attribute name (BT-160) and an Item attribute value (BT-161).</assert>
  </rule>
  <rule context="$Item_classification_identifier">
    <assert test="$BR-65" flag="fatal" id="BR-65">[BR-65]-The Item classification identifier (BT-158) shall have a Scheme identifier.</assert>
  </rule>
  <rule context="$Item_standard_identifier">
    <assert test="$BR-64" flag="fatal" id="BR-64">[BR-64]-The Item standard identifier (BT-157) shall have a Scheme identifier.</assert>
  </rule>
  <rule context="$Order_Reference">
    <assert test="$BR-CIUS-PT-24" flag="fatal" id="BR-CIUS-PT-24">[BR-CIUS-PT-24]-The Purchase order reference (BT-13) or the Sales order reference (BT-14) shall be filled, or both.</assert>
  </rule>
  <rule context="$Originator_Document_Reference">
    <assert test="$BR-CIUS-PT-28" flag="fatal" id="BR-CIUS-PT-28">[BR-CIUS-PT-28]-The Tender or lot reference (BT-17) shall be filled.</assert>
  </rule>
  <rule context="$Payee">
    <report test="$BR-CIUS-PT-32" flag="fatal" id="BR-CIUS-PT-32">[BR-CIUS-PT-32]-The Payee name (BT-59) shall be filled.</report>
    <report test="$BR-CIUS-PT-42" flag="fatal" id="BR-CIUS-PT-42">[BR-CIUS-PT-42]-The Payee identifier (BT-60) or the Bank assigned creditor identifier (BT-90) shall be filled.</report>
    <report test="$BR-CIUS-PT-43" flag="fatal" id="BR-CIUS-PT-43">[BR-CIUS-PT-43]-The Payee legal registration identifier (BT-61) shall be filled.</report>
  </rule>
  <rule context="$Payee_Financial_Account">
    <assert test="$BR-50" flag="fatal" id="BR-50">[BR-50]-A Payment account identifier (BT-84) shall be present if Credit transfer (BG-17) information is provided in the Invoice.</assert>
  </rule>
  <rule context="$Payment_instructions ">
    <assert test="$BR-49" flag="fatal" id="BR-49">[BR-49]-A Payment instruction (BG-16) shall specify the Payment means type code (BT-81).</assert>
    <assert test="$BR-61" flag="fatal" id="BR-61">[BR-61]-If the Payment means type code (BT-81) means SEPA credit transfer, Local credit transfer or Non-SEPA international credit transfer, the Payment account identifier (BT-84) shall be present.</assert>
    <report test="$BR-CIUS-PT-47" flag="fatal" id="BR-CIUS-PT-47">[BR-CIUS-PT-47]-The Payment account identifier (BT-84) or the Payment account name (BT-85) or the Payment service provider identifier (BT-86) shall be filled.</report>
    <report test="$BR-CIUS-PT-48" flag="fatal" id="BR-CIUS-PT-48">[BR-CIUS-PT-48]-The Payment service provider identifier (BT-86) shall be filled.</report>
    <report test="$BR-CIUS-PT-49" flag="fatal" id="BR-CIUS-PT-49">[BR-CIUS-PT-49]-The Mandate reference identifier (BT-89) or the Debited account identifier (BT-91) shall be filled.</report>
    <report test="$BR-CIUS-PT-50" flag="fatal" id="BR-CIUS-PT-50">[BR-CIUS-PT-50]-The Debited account identifier (BT-91) shall be filled.</report>
    <report test="$BR-CIUS-PT-60" flag="fatal" id="BR-CIUS-PT-60">[BR-CIUS-PT-60]-The Payment card primary account number (BT-87) and the card Network identifier shall be filled.</report>
  </rule>
  <rule context="$Payment_terms">
    <assert test="$BR-CIUS-PT-61" flag="fatal" id="BR-CIUS-PT-61">[BR-CIUS-PT-61]-The Payment terms (BT-20) shall be filled.</assert>
  </rule>
  <rule context="$Preceding_Invoice">
    <assert test="$BR-55" flag="fatal" id="BR-55">[BR-55]-Each Preceding Invoice reference (BG-3) shall contain a Preceding Invoice reference (BT-25).</assert>
  </rule>
  <rule context="$Project_Reference">
    <assert test="$BR-CIUS-PT-33" flag="fatal" id="BR-CIUS-PT-33">[BR-CIUS-PT-33]-The Project reference (BT-11) shall be filled.</assert>
  </rule>
  <rule context="$Receipt_Document_Reference">
    <assert test="$BR-CIUS-PT-27" flag="fatal" id="BR-CIUS-PT-27">[BR-CIUS-PT-27]-The Receiving advice reference (BT-15) shall be filled.</assert>
  </rule>
  <rule context="$Seller">
    <assert test="$BR-CO-26" flag="fatal" id="BR-CO-26">[BR-CO-26]-In order for the buyer to automatically identify a supplier, the Seller identifier (BT-29), the Seller legal registration identifier (BT-30) and/or the Seller VAT identifier (BT-31) shall be present.  </assert>
    <report test="$BR-CIUS-PT-34" flag="fatal" id="BR-CIUS-PT-34">[BR-CIUS-PT-34]-The Seller identifier (BT-29) or the Bank assigned creditor identifier (BT-90) shall be filled.</report>
    <report test="$BR-CIUS-PT-35" flag="fatal" id="BR-CIUS-PT-35">[BR-CIUS-PT-35]-The Seller trading name (BT-28) shall be filled.</report>
    <report test="$BR-CIUS-PT-36" flag="fatal" id="BR-CIUS-PT-36">[BR-CIUS-PT-36]-The Seller contact point (BT-41) or the Seller contact telephone number (BT-42) or the Seller contact email address (BT-43) shall be filled.</report>
  </rule>
  <rule context="$Seller_electronic_address">
    <assert test="$BR-62" flag="fatal" id="BR-62">[BR-62]-The Seller electronic address (BT-34) shall have a Scheme identifier.</assert>
  </rule>
  <rule context="$Seller_postal_address">
    <assert test="$BR-CIUS-PT-05" flag="fatal" id="BR-CIUS-PT-05">[BR-CIUS-PT-05]-The Seller postal address (BG-5) shall contain a Seller address line 1 (BT-35).</assert>
    <assert test="$BR-CIUS-PT-06" flag="fatal" id="BR-CIUS-PT-06">[BR-CIUS-PT-06]-The Seller postal address (BG-5) shall contain a Seller city (BT-37).</assert>
    <assert test="$BR-CIUS-PT-07" flag="fatal" id="BR-CIUS-PT-07">[BR-CIUS-PT-07]-The Seller postal address (BG-5) shall contain a Seller post code (BT-38).</assert>
    <assert test="$BR-09" flag="fatal" id="BR-09">[BR-09]-The Seller postal address (BG-5) shall contain a Seller country code (BT-40).</assert>
    <report test="$BR-CIUS-PT-37" flag="fatal" id="BR-CIUS-PT-37">[BR-CIUS-PT-37]-The Seller address line 3 (BT-162) shall be filled.</report>
  </rule>
  <rule context="$Tax_Representative">
    <assert test="$BR-18" flag="fatal" id="BR-18">[BR-18]-The Seller tax representative name (BT-62) shall be provided in the Invoice, if the Seller (BG-4) has a Seller tax representative party (BG-11)</assert>
    <assert test="$BR-19" flag="fatal" id="BR-19">[BR-19]-The Seller tax representative postal address (BG-12) shall be provided in the Invoice, if the Seller (BG-4) has a Seller tax representative party (BG-11).</assert>
    <assert test="$BR-56" flag="fatal" id="BR-56">[BR-56]-Each Seller tax representative party (BG-11) shall have a Seller tax representative VAT identifier (BT-63).    </assert>
  </rule>
  <rule context="$Tax_Representative_postal_address">
    <assert test="$BR-20" flag="fatal" id="BR-20">[BR-20]-The Seller tax representative postal address (BG-12) shall contain a Tax representative country code (BT-69), if the Seller (BG-4) has a Seller tax representative party (BG-11).</assert>
    <report test="$BR-CIUS-PT-44" flag="fatal" id="BR-CIUS-PT-44">[BR-CIUS-PT-44]-The Tax representative address line 3 (BT-164) shall be filled.</report>
  </rule>
  <rule context="$VAT_breakdown ">
    <assert test="$BR-45" flag="fatal" id="BR-45">[BR-45]-Each VATBReakdown (BG-23) shall have a VAT category taxable amount (BT-116).</assert>
    <assert test="$BR-46" flag="fatal" id="BR-46">[BR-46]-Each VATBReakdown (BG-23) shall have a VAT category tax amount (BT-117).</assert>
    <assert test="$BR-47" flag="fatal" id="BR-47">[BR-47]-Each VATBReakdown (BG-23) shall be defined through a VAT category code (BT-118).</assert>
    <assert test="$BR-48" flag="fatal" id="BR-48">[BR-48]-Each VATBReakdown (BG-23) shall have a VAT category rate (BT-119).</assert>
    <assert test="$BR-CIUS-PT-08" flag="fatal" id="BR-CIUS-PT-08">[BR-CIUS-PT-08]-Each VATBReakdown (BG-23) shall have a tax scheme.</assert>
  </rule>
  <rule context="$VATAA">
    <assert test="$BR-AA-10" flag="fatal" id="BR-AA-10">[BR-AA-10]-A VATBReakdown (BG-23) with VAT Category code (BT-118) "Lower rate" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).    </assert>
  </rule>
  <rule context="$VATAA_AdditionalLine">
    <assert test="$BR-CIUS-PT-13" flag="fatal" id="BR-CIUS-PT-13">[BR-CIUS-PT-13]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Lower rate" shall not have a VAT exemption reason code (BT-160) or VAT exemption reason text (BT-160).</assert>
  </rule>
  <rule context="$VATS">
    <assert test="$BR-S-10" flag="fatal" id="BR-S-10">[BR-S-10]-A VATBReakdown (BG-23) with VAT Category code (BT-118) "Standard rate" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).</assert>
  </rule>
  <rule context="$VATS_AdditionalLine">
    <assert test="$BR-CIUS-PT-15" flag="fatal" id="BR-CIUS-PT-15">[BR-CIUS-PT-15]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Standard rated" shall not have a VAT exemption reason code (BT-160) or VAT exemption reason text (BT-160).</assert>
  </rule>
  <rule context="$VATE">
    <assert test="$BR-E-10" flag="fatal" id="BR-E-10">[BR-E-10]-A VATBReakdown (BG-23) with VAT Category code (BT-118) "Exempt from VAT" shall have a VAT exemption reason code (BT-121) or a VAT exemption reason text (BT-120).</assert>
  </rule>
  <rule context="$VATE_AdditionalLine">
    <let name="cnt17.1" value="count(filter(ancestor::cac:InvoiceLine/cac:Item[cac:ClassifiedTaxCategory/cbc:ID = 'E']/cac:AdditionalItemProperty/cbc:Name | ancestor::cac:CreditNoteLine/cac:Item[cac:ClassifiedTaxCategory/cbc:ID = 'E']/cac:AdditionalItemProperty/cbc:Name,function($a){matches($a,'^(#(TAXEXEMPTIONREASONCODE@CLASSIFIEDTAXCATEGORY)#)$')}))"/>
    <let name="cnt17.2" value="count(filter(ancestor::cac:InvoiceLine/cac:Item[cac:ClassifiedTaxCategory/cbc:ID = 'E']/cac:AdditionalItemProperty/cbc:Name | ancestor::cac:CreditNoteLine/cac:Item[cac:ClassifiedTaxCategory/cbc:ID = 'E']/cac:AdditionalItemProperty/cbc:Name,function($a){matches($a,'^(#(TAXEXEMPTIONREASON@CLASSIFIEDTAXCATEGORY)#)$')}))"/>
    <assert test="$BR-CIUS-PT-17" flag="fatal" id="BR-CIUS-PT-17">[BR-CIUS-PT-17]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Exempt from VAT" shall have a VAT exemption reason code (BT-160) or VAT exemption reason text (BT-160).</assert>
  </rule>
</pattern>
