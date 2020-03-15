<pattern xmlns="http://purl.oclc.org/dsdl/schematron" abstract="true" id="condition">
  <rule context="$Amount_due">
    <assert test="$BR-CO-25" flag="fatal" id="BR-CO-25">[BR-CO-25]-In case the Amount due for payment (BT-115) is positive, either the Payment due date (BT-9) or the Payment terms (BT-20) shall be present.</assert>
  </rule>
  <rule context="$Invoice ">
    <assert test="$BR-AA-01" flag="fatal" id="BR-AA-01">[BR-AA-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is “Lower rate” shall contain in the VATBReakdown (BG-23) at least one VAT category code (BT-118) equal with "Lower rate".</assert>
    <assert test="$BR-S-01" flag="fatal" id="BR-S-01">[BR-S-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is “Standard rated” shall contain in the VATBReakdown (BG-23) at least one VAT category code (BT-118) equal with "Standard rated".</assert>
    <assert test="$BR-E-01" flag="fatal" id="BR-E-01">[BR-E-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is “Exempt from VAT” shall contain exactly one VATBReakdown (BG-23) with the VAT category code (BT-118) equal to "Exempt from VAT".</assert>
    <assert test="$BR-CO-15" flag="fatal" id="BR-CO-15">[BR-CO-15]-Invoice total amount with VAT (BT-112) = Invoice total amount without VAT (BT-109) + Invoice total VAT amount (BT-110).</assert>
  </rule>
  <rule context="$Invoice_Line ">
    <assert test="$BR-28" flag="fatal" id="BR-28">[BR-28]-The Item gross price (BT-148) shall NOT be negative.</assert>
  </rule>
  <rule context="$Payee">
    <assert test="$BR-17" flag="fatal" id="BR-17">[BR-17]-The Payee name (BT-59) shall be provided in the Invoice, if the Payee (BG-10) is different from the Seller (BG-4)</assert>
    <assert test="$UBL-SR-19" flag="warning" id="UBL-SR-19">[UBL-SR-19]-Payee name shall occur maximum once, if the Payee is different from the Seller</assert>
    <assert test="$UBL-SR-20" flag="warning" id="UBL-SR-20">[UBL-SR-20]-Payee identifier shall occur maximum once, if the Payee is different from the Seller</assert>
    <assert test="$UBL-SR-21" flag="warning" id="UBL-SR-21">[UBL-SR-21]-Payee legal registration identifier shall occur maximum once, if the Payee is different from the Seller</assert>
  </rule>
  <rule context="$Tax_Total">
    <assert test="$BR-CO-14" flag="fatal" id="BR-CO-14">[BR-CO-14]-Invoice total VAT amount (BT-110) = Σ VAT category tax amount (BT-117).</assert>
  </rule>
  <rule context="$Document_totals ">
    <assert test="$BR-CO-10" flag="fatal" id="BR-CO-10">[BR-CO-10]-Sum of Invoice line net amount (BT-106) = Σ Invoice line net amount (BT-131).</assert>
    <assert test="$BR-CO-11" flag="fatal" id="BR-CO-11">[BR-CO-11]-Sum of allowances on document level (BT-107) = Σ Document level allowance amount (BT-92).</assert>
    <assert test="$BR-CO-12" flag="fatal" id="BR-CO-12">[BR-CO-12]-Sum of charges on document level (BT-108) = Σ Document level charge amount (BT-99).</assert>
    <assert test="$BR-CO-13" flag="fatal" id="BR-CO-13">[BR-CO-13]-Invoice total amount without VAT (BT-109) = Σ Invoice line net amount (BT-131) - Sum of allowances on document level (BT-107) + Sum of charges on document level (BT-108).</assert>
    <assert test="$BR-CO-16" flag="fatal" id="BR-CO-16">[BR-CO-16]-Amount due for payment (BT-115) = Invoice total amount with VAT (BT-112) -Paid amount (BT-113) +Rounding amount (BT-114).</assert>
  </rule>
  <rule context="$VAT_breakdown ">
    <assert test="$BR-CO-17" flag="fatal" id="BR-CO-17">[BR-CO-17]-VAT category tax amount (BT-117) = VAT category taxable amount (BT-116) x (VAT category rate (BT-119) / 100), rounded to two decimals.</assert>
  </rule>
  <rule context="$VATAA">
    <assert test="$BR-AA-08" flag="fatal" id="BR-AA-08">[BR-AA-08]-For each different value of VAT category rate (BT-119) where the VAT category code (BT-118) is "Lower rate", the VAT category taxable amount (BT-116) in a VATBReakdown (BG-23) shall equal the sum of Invoice line net amounts (BT-131) plus the sum of document level charge amounts (BT-99) minus the sum of document level allowance amounts (BT-92) where the VAT category code (BT-151, BT-102, BT-95) is “Lower rate” and the VAT rate (BT-152, BT-103, BT-96) equals the VAT category rate (BT-119).</assert>
    <assert test="$BR-AA-09" flag="fatal" id="BR-AA-09">[BR-AA-09]-The VAT category tax amount (BT-117) in a VATBReakdown (BG-23) where VAT category code (BT-118) is "Lower rate" shall equal the VAT category taxable amount (BT-116) multiplied by the VAT category rate (BT-119).</assert>
    <assert test="$BR-CIUS-PT-12" flag="fatal" id="BR-CIUS-PT-12">[BR-CIUS-PT-12]-A VATBReakdown (BG-23) with VAT Category code (BT-118) "Lower rate" the VAT category rate (BT-119) shall be greater than zero.</assert>
  </rule>
  <rule context="$VATAA_Allowance">
    <assert test="$BR-AA-06" flag="fatal" id="BR-AA-06">[BR-AA-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Lower rate" the Document level allowance VAT rate (BT-96) shall be greater than zero.</assert>
  </rule>
  <rule context="$VATAA_Charge">
    <assert test="$BR-AA-07" flag="fatal" id="BR-AA-07">[BR-AA-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Lower rate" the Document level charge VAT rate (BT-103) shall be greater than zero.  </assert>
  </rule>
  <rule context="$VATS">
    <assert test="$BR-S-08" flag="fatal" id="BR-S-08">[BR-S-08]-For each different value of VAT category rate (BT-119) where the VAT category code (BT-118) is "Standard rated", the VAT category taxable amount (BT-116) in a VATBReakdown (BG-23) shall equal the sum of Invoice line net amounts (BT-131) plus the sum of document level charge amounts (BT-99) minus the sum of document level allowance amounts (BT-92) where the VAT category code (BT-151, BT-102, BT-95) is “Standard rated” and the VAT rate (BT-152, BT-103, BT-96) equals the VAT category rate (BT-119).</assert>
    <assert test="$BR-S-09" flag="fatal" id="BR-S-09">[BR-S-09]-The VAT category tax amount (BT-117) in a VATBReakdown (BG-23) where VAT category code (BT-118) is "Standard rated" shall equal the VAT category taxable amount (BT-116) multiplied by the VAT category rate (BT-119).</assert>
    <assert test="$BR-CIUS-PT-14" flag="fatal" id="BR-CIUS-PT-14">[BR-CIUS-PT-14]-A VATBReakdown (BG-23) with VAT Category code (BT-118) "Standard rate" the VAT category rate (BT-119) shall be greater than zero.</assert>
  </rule>
  <rule context="$VATS_Allowance">
    <assert test="$BR-S-06" flag="fatal" id="BR-S-06">[BR-S-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Standard rated" the Document level allowance VAT rate (BT-96) shall be greater than zero.</assert>
  </rule>
  <rule context="$VATS_Charge">
    <assert test="$BR-S-07" flag="fatal" id="BR-S-07">[BR-S-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Standard rated" the Document level charge VAT rate (BT-103) shall be greater than zero.  </assert>
  </rule>
  <rule context="$VATE">
    <assert test="$BR-E-08" flag="fatal" id="BR-E-08">[BR-E-08]-In a VATBReakdown (BG-23) where the VAT category code (BT-118) is "Exempt from VAT" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are “Exempt from VAT".</assert>
    <assert test="$BR-E-09" flag="fatal" id="BR-E-09">[BR-E-09]-The VAT category tax amount (BT-117) In a VATBReakdown (BG-23) where the VAT category code (BT-118) equals "Exempt from VAT" shall equal 0 (zero).</assert>
    <assert test="$BR-CIUS-PT-16" flag="fatal" id="BR-CIUS-PT-16">[BR-CIUS-PT-16]-A VATBReakdown (BG-23) with VAT Category code (BT-118) "Exempt from VAT" the VAT category rate (BT-119) shall be 0 (zero).</assert>
  </rule>
  <rule context="$VATE_Allowance">
    <assert test="$BR-E-06" flag="fatal" id="BR-E-06">[BR-E-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Exempt from VAT", the Document level allowance VAT rate (BT-96) shall be 0 (zero).</assert>
  </rule>
  <rule context="$VATE_Charge">
    <assert test="$BR-E-07" flag="fatal" id="BR-E-07">[BR-E-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Exempt from VAT", the Document level charge VAT rate (BT-103) shall be 0 (zero).    </assert>
  </rule>
  <rule context="$Invoice_Line ">
    <assert test="$BR-27" flag="fatal" id="BR-27">[BR-27]-The Item net price (BT-146) shall NOT be negative.</assert>
    <assert test="$BR-CO-04" flag="fatal" id="BR-CO-04">[BR-CO-04]-Each Invoice line (BG-25) shall be categorized with an Invoiced item VAT category code (BT-151).</assert>
  </rule>
  <rule context="$VATAA_Line">
    <assert test="$BR-AA-05" flag="fatal" id="BR-AA-05">[BR-AA-05]-In a Line VAT Information (BG-30) where the Invoiced item VAT category code (BT-151) is "Lower rate" the Invoiced item VAT rate (BT-152) shall be greater than zero.</assert>
  </rule>
  <rule context="$VATS_Line">
    <assert test="$BR-S-05" flag="fatal" id="BR-S-05">[BR-S-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Standard rated" the Invoiced item VAT rate (BT-152) shall be greater than zero.    </assert>
  </rule>
  <rule context="$VATE_Line">
    <assert test="$BR-E-05" flag="fatal" id="BR-E-05">[BR-E-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Exempt from VAT", the Invoiced item VAT rate (BT-152) shall be 0 (zero).    </assert>
  </rule>
</pattern>
