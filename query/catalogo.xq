declare namespace functx = "http://www.functx.com";

declare variable $db external := 'crd';
declare variable $cat external := 'Tercero';


(: Funciones importadas de functx para evitar dependencias adicionales :)
declare function functx:distinct-deep 
  ( $nodes as node()* )  as node()* {

    for $seq in (1 to count($nodes))
    return $nodes[$seq][not(functx:is-node-in-sequence-deep-equal(
                          .,$nodes[position() < $seq]))]
 } ;

declare function functx:is-node-in-sequence-deep-equal 
  ( $node as node()? ,
    $seq as node()* )  as xs:boolean {

   some $nodeInSeq in $seq satisfies deep-equal($nodeInSeq,$node)
 } ;

(: Construye dinamicamente un catalogo a partir de los documentos en la DB :)
declare function local:dinamico( $docs, $cat ){

  let $entradas := functx:distinct-deep( $docs//Tercero )
  
  return 
  <Catalogo uri="{base-uri($docs/Catalogo[@nombre=$cat]/Entrada[1])}" id="{$cat}">
     {for $e in $entradas where count($e/*) > 1 order by $e/Nombre return 
     <Entrada uri="{base-uri($e)}">{
       $e/*  
     }
     </Entrada>
   
 }
  </Catalogo>  
};

(: Retorna un catalogo almacenado como un archivo maestro en la carpeta Catalogos :)
declare function local:maestro( $docs, $cat ){

  let $entradas :=  $docs/Catalogo[@nombre=$cat]/Entrada
  
  return 
  <Catalogo id="{$cat}" uri="{ base-uri($entradas[1]) }">
     {for $e  in $entradas order by $e/Codigo return $e}
  </Catalogo>  
};


let $docs := collection($db)
return 
if ( $cat="Tercero")  then local:dinamico( $docs, $cat ) else local:maestro( $docs, $cat ) 