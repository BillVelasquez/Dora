module namespace cat="http://creativosdigitales.co/schema/catalogos";


declare function cat:cuenta( $db, $codigo ){
  let $cta := $db/Catalogo[@nombre="Cuentas"]/Entrada[Codigo=$codigo]
  return $cta
};


declare function cat:expandir-cuenta( $db, $cuenta ){
  let $cta-db := cat:cuenta( $db, $cuenta/Codigo/text() )
  let $clase := cat:cuenta( $db, substring($cuenta/Codigo,1,1) )
  let $grupo := cat:cuenta( $db, substring($cuenta/Codigo,1,2) )
  let $mayor := cat:cuenta( $db, substring($cuenta/Codigo,1,4) )

  return <Cuenta>
    <Clase>{ $clase/* }</Clase>
    <Grupo>{ $grupo/* }</Grupo>
    <Mayor>{ $mayor/* }</Mayor>
    <Cuenta>
      {$cuenta/Codigo,
      if (empty($cta-db) ) then $cuenta/Nombre else $cta-db/Nombre}
    </Cuenta>
  </Cuenta>
};

declare function cat:test($c){
let $db := collection("crd")
return cat:expandir-cuenta( $db, cat:cuenta($db, $c) )
};