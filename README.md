# Dora
Auxiliar Contable basado en MS-Excel y XML DB


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

