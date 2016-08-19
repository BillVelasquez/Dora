# Dora
Auxiliar Contable basado en MS-Excel y XML DB


Copyright (c) 2015 Creativos Digitales S:A.S.
Distribución libre bajo la Licencia LGPL

Docusfera es un sistema que le permite llevar su contabilidad de manera fácil 
usando Microsoft Office, a la vez que asegura orden y control sobre su información.

##Principios

Cada documento contable se diligencia como un documento en Excel, a partir del cuál
Docusfera genera automáticamente una versión en PDF y otra en XML.

La versión PDF le permite llevar un archivo digital y evitar la impresión de copias
de los documentos, así como enviarlo por correo electrónico o publicarlo fáacilmente
en Internet.

El formato XML es un estándar para el almacenamiento de información, independientemente
de la presentación. Mediante los datos almacenados en los archivos XML y la base de 
datos gratuita BaseX, es posible crear los informes contables en el módulo de informes
de Docusfera.

##Ventajas

La arquitectura de Docusfera le hace estar por encima de otros sistemas contables por 
varias razones:

###Sencillez
Para comenzar a usar Docusfera solo se necesita tener Microsoft Excel instalado y un 
archivo con el logotipo de su empresa.

No hay complejas bases de datos que deban instalarse y administrarse, sino que la 
información se maneja de manera natural en forma de archivos en el disco duro.

###Trabajo en grupo
Docusfera le permite compartir los datos con su contador mediante sistemas de archivos
en la nube, como DropBox, OneDrive o Google Drive - entre otros - de manera que el trabajo
que ambos realizan se sincroniza automáticamente.

Igualmente mediante estos servicios tendrá acceso a los documentos que componen su 
contabilidad desde otros equipos, vía Web o desde dispositivos móviles.

###Ahorro de Papel
Al guardar una copia de cada documento en PDF, puede llevar un archivo electrónico y
evitar la impresión innecesaria de sus documentos e inclusive compartirlos de manera 
electrónica con sus clientes y proveedores.

###Facilidad de Uso
Para usar Docusfera solo se necesitan nociones básicas de Excel. Pero entre mayor sea
su conocimiento de esta hoja de cálculo, mayor será el provecho que le saque a Docusfera.

###Flexibilidad
Con Docusfera no necesitará de un programador para adaptarlo el sistema a sus necesidades,
la mayor parte de su funcionalidad está construida como libros de Excel, sin macros, solo
fórmulas básicas, de modo que usted mismo puede adaptar la apariencia y la funcionalidad a 
sus necesidades.

Adicionalmente, es software libre, de modo que usted tiene acceso no solo a ver el código
fuente, sino también a modificarlo si lo requiere.


##Organización

Los datos de la empresa se almacenan en un carpeta principal y varias subcarpetas. 
En adelante nos referiremos a esta como la "Carpeta de la Empresa"

Lo recomendable es que la carpeta de la empresa esté ubicada dentro de las carpetas 
del servicio de archivos en la nube de su preferencia (OneDrive, Google Drive, Dropbox, etc)
de modo que pueda compartir su contenido con su contador o trabajar desde otros
computadores.

Cuando se instala Docusfera, crea dos carpetas especiales dentro de la carpeta de la 
empresa:

* Carpeta Modelos
Esta Carpeta contiene las plantillas de los documentos contables. Si bien el instalador
incluye algunos modelos aplicables a todo tipo de empresa, usted puede crear los suyos
propios modificando la apariencia, formulación o cualquier otra característica según las
necesidades de su empresa. Incluso puede crear subcarpetas para organizar los modelos.

* Carpeta Consultas
Esta carpeta contiene el codigo fuente de las consultas que se hacen mediante la base de
datos BaseX.

Usted puede modificar las existentes si lo requiere o crear las suyas propias.

* Documentos 

Dentro de la carpeta de la empresa, se crea una carpeta por cada año y dentro de cada año
una carpeta por cada mes. La creación de estas carpetas se hace automáticamente al guardar
cada documento con la opción Guardar del complemento de Docusfera.

Uso por primera vez
===================
Una vez determinada la carpeta de la empresa, y copiadas las carpetas Modelos y Consultas, 
el primer paso es configurar los documentos modelo para que tomen la identidad corporativa
de la empresa (Logotipo, Razón social, nit, telefonos, etc).

Para hacerlo, ingrese a la opción "Configurar Modelos" en la pestaña Docusfera de la cinta
de opciones de Excel.

Allí deberá indicar:
- Datos de la empresa: Nit, Digito de Verificacion, Regimen Tributario, Razon Social, Telefonos,
Direccion, Ciudad, Departamente, email
- Carpeta de la Empresa: Ingrese la ruta completa donde estableció la carpeta de la empresa
- Logotipo: Seleccione el archivo que contiene el logotipo de la empresa. Las dimensiones de 
este archivo no deberán superar los 100 pixeles de alto por 300 de largo, a riesgo de alterar
la apariencia de los documentos.

Al seleccionar el botón "Iniciar", se aplicará su logotipo y datos de la empresa a cada libro de 
Excel en la carpeta "Modelos" y quedarán listos para comenzar a ser usados.

Operación
=========

Para asentar documentos contables, siga estos pasos:

1. Abra el documento Modelo (en la carpeta Modelos) según el tipo de comprobante contable que
desee crear.
2. Seleccione la opción "Numerar" en la cinta de opciones de Docusfera. Esto le asignara el 
siguiente consecutivo según el tipo de documento elegido. Si no hay ninguno creado previamente
le aparecerá un mensaje de advertencia y usted deberá escribir manualmente el numero del 
documento.
3. Diligencie los datos del documento
4. Guarde el documento usando el botón "Guardar" en la cinta de opciones de Docusfera. No use
el botón Guardar de Excel, porque lo que hará es sobreescribir el documento modelo en lugar
de contabilizar el documento que digitó.


## Configuracion de BaseX

Para que BaseX HTTP encuentre las consultas, debe establecerse la variable RESTPATH en el archivo de configuración  .basex

RESTPATH = C:\Dora\query

Donde C:\Dora\query es la ruta donde se encuentran los archivos de consulta .xq

Varias de las consultas dependen del modulo XQuery catalogos.xqm que debe ser registrado en el repositorio de BaseX para poderse usar mediante la interfaz REST

Para instalar el modulo ejecute el siguiente comando en BaseX:

REPO INSTALL C:\Dora\query\catalogos.xqm

Donde C:\Dora\query es la ruta donde están copiadas las consultas XQuery

A fin de que las consultas no pidan usuario y contraseña cuando se piden via HTTP, se deben guardar el usuario y contraseña del administrador de la base de datos (o un usuario de solo consulta) en el archivo de configuración .basex

USER = admin
PASSWORD = admin

