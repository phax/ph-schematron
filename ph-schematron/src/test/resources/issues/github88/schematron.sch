<?xml version="1.0" encoding="utf-8"?>
<sch:schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" schemaVersion="ISO19757-3">
  <sch:ns prefix="cfdi" uri="http://www.sat.gob.mx/cfd/3" />
 
  <sch:pattern name="bla">
    <sch:rule context="/cfdi:Comprobante/cfdi:Conceptos/cfdi:Concepto/cfdi:Impuestos/cfdi:Traslados/cfdi:Traslado[@TipoFactor!='Exento']">
      <sch:let name="impuesto" value="@Impuesto"/>
      <sch:let name="tasaOCuota" value="@TasaOCuota"/>
      <sch:report flag="CFDI33195" test="count(/cfdi:Comprobante/cfdi:Impuestos/cfdi:Traslados/cfdi:Traslado[@Impuesto = $impuesto and @TasaOCuota = $tasaOCuota]) = 0">El campo Importe correspondiente a Traslado no es igual a la suma de los importes de los impuestos trasladados registrados en los conceptos donde el impuesto del concepto sea igual al campo impuesto de este elemento y la TasaOCuota del concepto sea igual al campo TasaOCuota de este elemento.</sch:report>
    </sch:rule>
  </sch:pattern>
</sch:schema>
 