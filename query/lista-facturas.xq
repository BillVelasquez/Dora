declare variable $db external := 'crd/2016';

let $docs := collection($db)

return
<Facturas>
{
for $f in $docs/Comprobante[Tipo='Facturas' and Fecha >= '2016-01-01']
 return <Factura>
    { ($f/Numero, $f/Fecha, $f/Tercero/Nombre, $f/Totales) }
  </Factura>
}
</Facturas>