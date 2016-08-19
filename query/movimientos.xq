import module namespace cat="http://creativosdigitales.co/schema/catalogos";

declare variable $db external := 'crd/2015';
declare variable $cc external := '20';


declare function local:asientos( $docs, $catalogos ){

<Asientos>
{
   for $doc in $docs/Comprobante return 
       for $a in $doc/*/Asiento
       return
      <Asiento>
        {$doc/Fecha}  
        <Año>{ year-from-date($doc/Fecha) }</Año>
        <Mes>{ month-from-date($doc/Fecha) }</Mes>
        {$doc/Tipo}
        {$doc/Numero}
        {$doc/Nota}
        <Codigo_Costos>{$doc/Centro_de_Costos/Codigo/text()}</Codigo_Costos>
        <Nombre_CCostos>{$doc/Centro_de_Costos/Nombre/text()}</Nombre_CCostos>
        <Nombre_Proyecto>{$doc/Proyecto/Nombre/text()}</Nombre_Proyecto>
        {$a/Libro}
        
        {
        let $cuenta := cat:expandir-cuenta( $catalogos, $a/Cuenta )
        
        return 
      ( <Codigo_Cuenta>{$a/Cuenta/Codigo/text()}</Codigo_Cuenta>,
        <Nombre_Cuenta>{$cuenta/Cuenta/Nombre/text()}</Nombre_Cuenta>,
        <Codigo_Clase>{$cuenta/Clase/Codigo/text()}</Codigo_Clase>,
        <Nombre_Clase>{$cuenta/Clase/concat(Codigo/text(), ' - ', Nombre/text() ) }</Nombre_Clase>,
        <Codigo_Grupo>{$cuenta/Grupo/Codigo/text()}</Codigo_Grupo>,
        <Nombre_Grupo>{$cuenta/Grupo/concat(Codigo/text(), ' - ', Nombre/text() )}</Nombre_Grupo>,
        <Codigo_Mayor>{$cuenta/Mayor/Codigo/text()}</Codigo_Mayor>,
        <Nombre_Mayor>{$cuenta/Mayor/concat(Codigo/text(), ' - ', Nombre/text() ) }</Nombre_Mayor>)
      }
        <Codigo_Tercero>{$a/Tercero/Codigo/text()}</Codigo_Tercero>
        <Nombre_Tercero>{$a/Tercero/Nombre/text()}</Nombre_Tercero>
        {
          let $naturaleza := if( not( exists($a/Debitos)) or $a/Debitos = '' or number($a/Debitos) = 0 ) then -1 else 1 
          let $valores := (
            <Debitos>{ if( $naturaleza = -1 ) then 0 else number($a/Debitos/text()) }</Debitos>,
            <Creditos>{ if( $naturaleza = 1 ) then 0 else number($a/Creditos/text()) }</Creditos>
          )
          let $neto := 
          <Neto>{ try{ sum($valores) * $naturaleza } catch * {0} }</Neto>
          return ( <Naturaleza>{$naturaleza}</Naturaleza>, $valores, $neto )
        }
        <Archivo>{$a/base-uri()}</Archivo>
      </Asiento>
}
</Asientos>
};

let $catalogos :=   collection('crd/catalogos')
let $docs := collection($db)

let $asientos := local:asientos( $docs, $catalogos )
 return $asientos
 
 (: /*[Numero='200-00083']
 
 return distinct-values($a/Asiento/Fecha)  :)
