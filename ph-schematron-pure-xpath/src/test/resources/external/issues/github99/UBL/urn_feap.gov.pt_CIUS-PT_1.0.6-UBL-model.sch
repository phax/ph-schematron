<pattern xmlns="http://purl.oclc.org/dsdl/schematron" is-a="model" id="UBL-model">
  <param name="BR-CIUS-PT-01" value="exists(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID)"/>
  <param name="BR-CIUS-PT-02" value="(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID) = 'VAT'"/>
  <param name="BR-CIUS-PT-03" value="exists(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID)"/>
  <param name="BR-CIUS-PT-04" value="(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID) = 'VAT'"/>
  <param name="BR-CIUS-PT-05" value="exists(cbc:StreetName)"/>
  <param name="BR-CIUS-PT-06" value="exists(cbc:CityName)"/>
  <param name="BR-CIUS-PT-07" value="exists(cbc:PostalZone)"/>
  <param name="BR-CIUS-PT-08" value="exists(cac:TaxCategory/cac:TaxScheme/cbc:ID)"/>
  <param name="BR-CIUS-PT-09" value="exists(cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:ID)"/>
  <param name="BR-CIUS-PT-10" value="exists(cac:LegalMonetaryTotal)"/>
  <param name="BR-CIUS-PT-11" value="exists(cac:TaxTotal/cbc:TaxAmount)"/>
  <param name="BR-CIUS-PT-13" value="not(starts-with(normalize-space(.),'#TAXEXEMPTIONREASONCODE@CLASSIFIEDTAXCATEGORY#')) and not(starts-with(normalize-space(.),'#TAXEXEMPTIONREASON@CLASSIFIEDTAXCATEGORY#'))"/>
  <param name="BR-CIUS-PT-15" value="not(starts-with(normalize-space(.),'#TAXEXEMPTIONREASONCODE@CLASSIFIEDTAXCATEGORY#')) and not(starts-with(normalize-space(.),'#TAXEXEMPTIONREASON@CLASSIFIEDTAXCATEGORY#'))"/>
  <param name="BR-CIUS-PT-17" value="$cnt17.1 &gt; 0 or $cnt17.2 &gt; 0"/>
  <param name="BR-CIUS-PT-18" value="(cac:ClassifiedTaxCategory/cbc:ID) = 'E' and not(cac:AdditionalItemProperty)"/>
  <param name="BR-CIUS-PT-19" value="exists(cac:TaxCategory/cac:TaxScheme/cbc:ID)"/>
  <param name="BR-CIUS-PT-20" value="exists(cac:TaxCategory/cac:TaxScheme/cbc:ID)"/>
  <param name="BR-CIUS-PT-21" value="exists(cbc:StreetName)"/>
  <param name="BR-CIUS-PT-22" value="exists(cbc:CityName)"/>
  <param name="BR-CIUS-PT-23" value="exists(cbc:PostalZone)"/>
  <param name="BR-CIUS-PT-24" value="exists(cbc:ID) or exists(cbc:SalesOrderID)"/>
  <param name="BR-CIUS-PT-25" value="exists(//cn:CreditNote) and not(cac:BillingReference)"/>
  <param name="BR-CIUS-PT-26" value="exists(cbc:ID)"/>
  <param name="BR-CIUS-PT-27" value="exists(cbc:ID)"/>
  <param name="BR-CIUS-PT-28" value="exists(cbc:ID)"/>
  <param name="BR-CIUS-PT-29" value="exists(cbc:ID)"/>
  <param name="BR-CIUS-PT-30" value="exists(cac:Attachment) and (not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject) and not(cac:Attachment/cac:ExternalReference/cbc:URI))"/>
  <param name="BR-CIUS-PT-32" value="exists(cac:PartyName) and not(cac:PartyName/cbc:Name)"/>
  <param name="BR-CIUS-PT-33" value="exists(cbc:ID)"/>
  <param name="BR-CIUS-PT-34" value="exists(cac:Party/cac:PartyIdentification) and not(cac:Party/cac:PartyIdentification/cbc:ID)"/>
  <param name="BR-CIUS-PT-35" value="exists(cac:Party/cac:PartyName) and not(cac:Party/cac:PartyName/cbc:Name)"/>
  <param name="BR-CIUS-PT-36" value="exists(cac:Party/cac:Contact) and (not(cac:Party/cac:Contact/cbc:Name) and not(cac:Party/cac:Contact/cbc:Telephone) and not(cac:Party/cac:Contact/cbc:ElectronicMail))"/>
  <param name="BR-CIUS-PT-37" value="exists(cac:AddressLine) and not(cac:AddressLine/cbc:Line)"/>
  <param name="BR-CIUS-PT-38" value="exists(cac:Party/cac:PartyIdentification) and not(cac:Party/cac:PartyIdentification/cbc:ID)"/>
  <param name="BR-CIUS-PT-39" value="exists(cac:Party/cac:PartyName) and not(cac:Party/cac:PartyName/cbc:Name)"/>
  <param name="BR-CIUS-PT-40" value="exists(cac:Party/cac:Contact) and (not(cac:Party/cac:Contact/cbc:Name) and not(cac:Party/cac:Contact/cbc:Telephone) and not(cac:Party/cac:Contact/cbc:ElectronicMail))"/>
  <param name="BR-CIUS-PT-41" value="exists(cac:AddressLine) and not(cac:AddressLine/cbc:Line)"/>
  <param name="BR-CIUS-PT-42" value="exists(cac:PartyIdentification) and not(cac:PartyIdentification/cbc:ID)"/>
  <param name="BR-CIUS-PT-43" value="exists(cac:PartyLegalEntity) and not(cac:PartyLegalEntity/cbc:CompanyID)"/>
  <param name="BR-CIUS-PT-44" value="exists(cac:AddressLine) and not(cac:AddressLine/cbc:Line)"/>
  <param name="BR-CIUS-PT-45" value="exists(cac:AddressLine) and not(cac:AddressLine/cbc:Line)"/>
  <param name="BR-CIUS-PT-46" value="(exists(cac:DeliveryParty) and not(cac:DeliveryParty/cac:PartyName)) or (exists(cac:DeliveryParty/cac:PartyName) and not(cac:DeliveryParty/cac:PartyName/cbc:Name))"/>
  <param name="BR-CIUS-PT-47" value="exists(cac:PayeeFinancialAccount) and (not(cac:PayeeFinancialAccount/cbc:ID) and not(cac:PayeeFinancialAccount/cbc:Name) and not(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID))"/>
  <param name="BR-CIUS-PT-48" value="exists(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch) and not(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID)"/>
  <param name="BR-CIUS-PT-49" value="exists(cac:PaymentMandate) and (not(cac:PaymentMandate/cbc:ID) and not(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID))"/>
  <param name="BR-CIUS-PT-50" value="exists(cac:PaymentMandate/cac:PayerFinancialAccount) and not(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID)"/>
  <param name="BR-CIUS-PT-51" value="exists(cac:OrderLineReference) and not(cac:OrderLineReference/cbc:LineID)"/>
  <param name="BR-CIUS-PT-52" value="exists(cac:DocumentReference) and not(cac:DocumentReference/cbc:ID)"/>
  <param name="BR-CIUS-PT-53" value="exists(cac:BuyersItemIdentification) and not(cac:BuyersItemIdentification/cbc:ID)"/>
  <param name="BR-CIUS-PT-54" value="exists(cac:SellersItemIdentification) and not(cac:SellersItemIdentification/cbc:ID)"/>
  <param name="BR-CIUS-PT-55" value="exists(cac:StandardItemIdentification) and not(cac:StandardItemIdentification/cbc:ID)"/>
  <param name="BR-CIUS-PT-56" value="exists(cac:OriginCountry) and not(cac:OriginCountry/cbc:IdentificationCode)"/>
  <param name="BR-CIUS-PT-57" value="exists(cac:CommodityClassification) and not(cac:CommodityClassification/cbc:ItemClassificationCode)"/>
  <param name="BR-CIUS-PT-58" value="not(cac:AllowanceCharge[cbc:ChargeIndicator='true'])"/>
  <param name="BR-CIUS-PT-59" value="exists(cac:AllowanceCharge[cbc:ChargeIndicator='false']) and not(cac:AllowanceCharge/cbc:Amount)"/>
  <param name="BR-CIUS-PT-60" value="exists(cac:CardAccount) and (not(cac:CardAccount/cbc:PrimaryAccountNumberID) or not(cac:CardAccount/cbc:NetworkID))"/>
  <param name="BR-CIUS-PT-61" value="exists(cbc:Note)"/>
  <param name="BR-CIUS-PT-62" value="exists(//cac:AllowanceCharge[cbc:ChargeIndicator='false']) and not(cbc:AllowanceTotalAmount)"/>
  <param name="BR-CIUS-PT-63" value="exists(//cac:AllowanceCharge[cbc:ChargeIndicator='true']) and not(cbc:ChargeTotalAmount)"/>
  <param name="BR-CIUS-PT-64" value="exists(cbc:ActualDeliveryDate) or exists(cac:DeliveryParty) or exists(cac:DeliveryLocation/cbc:ID) or exists(cac:DeliveryLocation/cac:Address)"/>
  <param name="BR-CIUS-PT-65" value="((cbc:InvoiceTypeCode = '383' or cbc:InvoiceTypeCode = 'ND') and not(cac:BillingReference))"/>
  <param name="BR-CIUS-PT-66" value="exists(cac:Delivery/cac:DeliveryLocation/cac:Address)"/>
  
  <param name="BR-01" value="exists(cbc:CustomizationID)"/>
  <param name="BR-02" value="exists(cbc:ID)"/>
  <param name="BR-03" value="exists(cbc:IssueDate)"/>
  <param name="BR-04" value="exists(cbc:InvoiceTypeCode) or exists(cbc:CreditNoteTypeCode)"/>
  <param name="BR-05" value="exists(cbc:DocumentCurrencyCode)"/>
  <param name="BR-06" value="exists(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName)"/>
  <param name="BR-07" value="exists(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName)"/>
  <param name="BR-08" value="exists(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress)"/>
  <param name="BR-09" value="exists(cac:Country/cbc:IdentificationCode)"/>
  <param name="BR-10" value="exists(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress)"/>
  <param name="BR-11" value="exists(cac:Country/cbc:IdentificationCode)"/>
  <param name="BR-12" value="exists(cbc:LineExtensionAmount)"/>
  <param name="BR-13" value="exists(cbc:TaxExclusiveAmount)"/>
  <param name="BR-14" value="exists(cbc:TaxInclusiveAmount)"/>
  <param name="BR-15" value="exists(cbc:PayableAmount)"/>
  <param name="BR-16" value="exists(cac:InvoiceLine) or exists(cac:CreditNoteLine)"/>
  <param name="BR-18" value="exists(cac:PartyName/cbc:Name)"/>
  <param name="BR-19" value="exists(cac:PostalAddress)"/>
  <param name="BR-20" value="exists(cac:Country/cbc:IdentificationCode)"/>
  <param name="BR-21" value="exists(cbc:ID)"/>
  <param name="BR-22" value="exists(cbc:InvoicedQuantity) or exists(cbc:CreditedQuantity)"/>
  <param name="BR-23" value="(exists(cbc:InvoicedQuantity) and not(cbc:InvoicedQuantity/@unitCode)) or (exists(cbc:CreditedQuantity) and not(cbc:CreditedQuantity/@unitCode))"/>
  <param name="BR-24" value="exists(cbc:LineExtensionAmount)"/>
  <param name="BR-25" value="exists(cac:Item/cbc:Name)"/>
  <param name="BR-26" value="exists(cac:Price/cbc:PriceAmount)"/>
  <param name="BR-29" value="(exists(cbc:EndDate) and exists(cbc:StartDate) and (cbc:EndDate) &gt;= (cbc:StartDate)) or not(exists(cbc:StartDate)) or not(exists(cbc:EndDate))"/>
  <param name="BR-30" value="(exists(cbc:EndDate) and exists(cbc:StartDate) and (cbc:EndDate) &gt;= (cbc:StartDate)) or not(exists(cbc:StartDate)) or not(exists(cbc:EndDate))"/>
  <param name="BR-31" value="exists(cbc:Amount) "/>
  <param name="BR-32" value="exists(cac:TaxCategory/cbc:ID)"/>
  <param name="BR-33" value="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)"/>
  <param name="BR-36" value="exists(cbc:Amount)"/>
  <param name="BR-37" value="exists(cac:TaxCategory/cbc:ID)"/>
  <param name="BR-38" value="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)"/>
  <param name="BR-41" value="exists(cbc:Amount)"/>
  <param name="BR-42" value="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)"/>
  <param name="BR-43" value="exists(cbc:Amount)"/>
  <param name="BR-44" value="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)"/>
  <param name="BR-45" value="exists(cbc:TaxableAmount)"/>
  <param name="BR-46" value="exists(cbc:TaxAmount)"/>
  <param name="BR-47" value="exists(cac:TaxCategory/cbc:ID)"/>
  <param name="BR-48" value="exists(cac:TaxCategory/cbc:Percent)"/>
  <param name="BR-49" value="exists(cbc:PaymentMeansCode)"/>
  <param name="BR-50" value="exists(cbc:ID)"/>
  <param name="BR-52" value="exists(cbc:ID)"/>
  <param name="BR-54" value="exists(cbc:Name) and exists(cbc:Value)"/>
  <param name="BR-55" value="exists(cac:InvoiceDocumentReference/cbc:ID)"/>
  <param name="BR-56" value="exists(cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID)"/>
  <param name="BR-57" value="exists(cac:Country/cbc:IdentificationCode)"/>
  <param name="BR-61" value="(exists(cac:PayeeFinancialAccount/cbc:ID) and ((normalize-space(cbc:PaymentMeansCode) = '30') or (normalize-space(cbc:PaymentMeansCode) = '58') )) or ((normalize-space(cbc:PaymentMeansCode) != '30') and (normalize-space(cbc:PaymentMeansCode) != '58'))"/>
  <param name="BR-62" value="exists(@schemeID)"/>
  <param name="BR-63" value="exists(@schemeID)"/>
  <param name="BR-64" value="exists(@schemeID)"/>
  <param name="BR-65" value="exists(@listID)"/>
  
  <param name="BR-CO-03" value="(exists(cbc:TaxPointDate) and not(cac:InvoicePeriod/cbc:DescriptionCode)) or (not(cbc:TaxPointDate) and exists(cac:InvoicePeriod/cbc:DescriptionCode)) or (not(cbc:TaxPointDate) and not(cac:InvoicePeriod/cbc:DescriptionCode))"/>
  <param name="BR-CO-07" value="true()"/>
  <param name="BR-CO-08" value="true()"/>
  <param name="BR-CO-18" value="exists(cac:TaxTotal/cac:TaxSubtotal)"/>
  <param name="BR-CO-19" value="exists(cbc:StartDate) or exists(cbc:EndDate)"/>
  <param name="BR-CO-20" value="exists(cbc:StartDate) or exists(cbc:EndDate)"/>
  <param name="BR-CO-21" value="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)"/>
  <param name="BR-CO-22" value="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)"/>
  <param name="BR-CO-23" value="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)"/>
  <param name="BR-CO-24" value="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)"/>
  <param name="BR-CO-26" value="exists(cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(cac:Party/cac:PartyIdentification/cbc:ID) or exists(cac:Party/cac:PartyLegalEntity/cbc:CompanyID)"/>
  
  <param name="BR-AA-02" value="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'AA']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'AA']))"/>
  <param name="BR-AA-03" value="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='false']/cac:TaxCategory[normalize-space(cbc:ID)='AA']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='false']/cac:TaxCategory[normalize-space(cbc:ID)='AA']))"/>
  <param name="BR-AA-04" value="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='true']/cac:TaxCategory[normalize-space(cbc:ID)='AA']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='true']/cac:TaxCategory[normalize-space(cbc:ID)='AA']))"/>
  <param name="BR-AA-10" value="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)"/>
  
  <param name="BR-S-02" value="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S']))"/>
  <param name="BR-S-03" value="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='false']/cac:TaxCategory[normalize-space(cbc:ID)='S']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='false']/cac:TaxCategory[normalize-space(cbc:ID)='S']))"/>
  <param name="BR-S-04" value="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='true']/cac:TaxCategory[normalize-space(cbc:ID)='S']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='true']/cac:TaxCategory[normalize-space(cbc:ID)='S']))"/>
  <param name="BR-S-10" value="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)"/>
  
  <param name="BR-E-02" value="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E']))"/>
  <param name="BR-E-03" value="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='false']/cac:TaxCategory[normalize-space(cbc:ID)='E']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='false']/cac:TaxCategory[normalize-space(cbc:ID)='E']))"/>
  <param name="BR-E-04" value="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='true']/cac:TaxCategory[normalize-space(cbc:ID)='E']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='true']/cac:TaxCategory[normalize-space(cbc:ID)='E']))"/>
  <param name="BR-E-10" value="exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode)"/>
  
  <param name="Invoice_Period " value="cac:InvoicePeriod"/>
  <param name="Order_Reference" value="cac:OrderReference"/>
  <param name="Despatch_Document_Reference" value="cac:DespatchDocumentReference"/>
  <param name="Receipt_Document_Reference" value="cac:ReceiptDocumentReference"/>
  <param name="Originator_Document_Reference" value="cac:OriginatorDocumentReference"/>
  <param name="Contract_Document_Reference" value="cac:ContractDocumentReference"/>
  <param name="Project_Reference" value="cac:ProjectReference"/>
  <param name="Document_totals " value="cac:LegalMonetaryTotal"/>
  <param name="Payee_Financial_Account" value="cac:PaymentMeans[cbc:PaymentMeansCode='30' or cbc:PaymentMeansCode='58']/cac:PayeeFinancialAccount"/>
  <param name="Payee" value="cac:PayeeParty"/>
  <param name="Tax_Representative_postal_address" value="cac:TaxRepresentativeParty/cac:PostalAddress"/>
  <param name="Tax_Representative" value="cac:TaxRepresentativeParty"/>
  <param name="Seller_electronic_address" value="cac:AccountingSupplierParty/cac:Party/cbc:EndpointID"/>
  <param name="Seller_postal_address" value="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress"/>
  <param name="Seller" value="cac:AccountingSupplierParty"/>
  <param name="Invoice_Line " value="cac:InvoiceLine | cac:CreditNoteLine"/>
  <param name="Invoice_Line_Period " value="cac:InvoiceLine/cac:InvoicePeriod | cac:CreditNoteLine/cac:InvoicePeriod"/>
  <param name="Document_level_allowances " value="//ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = 'false'] | //cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = 'false']"/>
  <param name="Document_level_charges " value="//ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = 'true'] | //cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = 'true']"/>
  <param name="Invoice_line_allowances " value="//cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = 'false'] | //cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = 'false']"/>
  <param name="Invoice_line_charges " value="//cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = 'true'] | //cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = 'true']"/>
  <param name="Invoice_Line_Item" value="cac:InvoiceLine/cac:Item | cac:CreditNoteLine/cac:Item"/>
  <param name="Invoice_Line_Price" value="cac:InvoiceLine/cac:Price | cac:CreditNoteLine/cac:Price"/>
  <param name="VAT_breakdown " value="cac:TaxTotal/cac:TaxSubtotal"/>
  <param name="Payment_instructions " value="cac:PaymentMeans"/>
  <param name="Payment_terms" value="cac:PaymentTerms"/>
  <param name="Additional_supporting_documents " value="cac:AdditionalDocumentReference"/>
  <param name="Item_attributes " value="//cac:AdditionalItemProperty"/>
  <param name="Preceding_Invoice" value="cac:BillingReference"/>
  <param name="VATAA_AdditionalLine" value="cac:InvoiceLine/cac:Item[cac:ClassifiedTaxCategory/cbc:ID = 'AA']/cac:AdditionalItemProperty/cbc:Name | cac:CreditNoteLine/cac:Item[cac:ClassifiedTaxCategory/cbc:ID = 'AA']/cac:AdditionalItemProperty/cbc:Name"/>
  <param name="VATAA" value="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'AA']"/>
  <param name="VATS_AdditionalLine" value="cac:InvoiceLine/cac:Item[cac:ClassifiedTaxCategory/cbc:ID = 'S']/cac:AdditionalItemProperty/cbc:Name | cac:CreditNoteLine/cac:Item[cac:ClassifiedTaxCategory/cbc:ID = 'S']/cac:AdditionalItemProperty/cbc:Name"/>
  <param name="VATS" value="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S']"/>
  <param name="VATE_AdditionalLine" value="cac:InvoiceLine/cac:Item[cac:ClassifiedTaxCategory/cbc:ID = 'E']/cac:AdditionalItemProperty/cbc:Name | cac:CreditNoteLine/cac:Item[cac:ClassifiedTaxCategory/cbc:ID = 'E']/cac:AdditionalItemProperty/cbc:Name"/>
  <param name="VATE" value="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E']"/>
  <param name="Invoice " value="//ubl:Invoice | //cn:CreditNote"/>
  <param name="Buyer_postal_address" value="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress"/>
  <param name="Deliver_to_address" value="cac:Delivery/cac:DeliveryLocation/cac:Address"/>
  <param name="Delivery" value="cac:Delivery"/>
  <param name="Buyer_electronic_address" value="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID"/>
  <param name="Buyer" value="cac:AccountingCustomerParty"/>
  <param name="Item_standard_identifier" value="cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:ID | cac:CreditNoteLine/cac:Item/cac:StandardItemIdentification/cbc:ID"/>
  <param name="Item_classification_identifier" value="cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode | cac:CreditNoteLine/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode "/>
  <param name="Note" value="//ubl:Invoice/cbc:Note | //cn:CreditNote/cbc:Note"/>
</pattern>
