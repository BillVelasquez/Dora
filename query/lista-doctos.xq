declare variable $db external := 'crd/2015';
declare variable $cc external := '20';
<Asientos>
{
   for $doc in collection($db)/Comprobante  order by $doc/Numero
   
   return 
      <Docto>
        {$doc/Fecha}  
        {$doc/Tipo}
        {$doc/Numero}
        {$doc/Nota}
      </Docto>
}
</Asientos>

