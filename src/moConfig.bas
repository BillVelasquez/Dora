Attribute VB_Name = "moConfig"
Option Explicit

Const ClaveEmpresaActual = "SOFTWARE\dora\actual"

' Tomado de http://vba-corner.livejournal.com/3054.html

'sets the registry key i_RegKey to the
'value i_Value with type i_Type
'if i_Type is omitted, the value will be saved as string
'if i_RegKey wasn't found, a new registry key will be created
Sub RegKeySave(i_RegKey As String, _
               i_Value As String, _
      Optional i_Type As String = "REG_SZ")
Dim myWS As Object

  'access Windows scripting
  Set myWS = CreateObject("WScript.Shell")
  'write registry key
  myWS.RegWrite i_RegKey, i_Value, i_Type

End Sub

'reads the value for the registry key i_RegKey
'if the key cannot be found, the return value is ""
Function RegKeyRead(i_RegKey As String) As String
Dim myWS As Object

  On Error Resume Next
  'access Windows scripting
  Set myWS = CreateObject("WScript.Shell")
  'read key from registry
  RegKeyRead = myWS.RegRead(i_RegKey)
End Function

Function RutaEmpresa() As String
   RutaEmpresa = RegKeyRead("HKEY_CURRENT_USER\" & ClaveEmpresaActual & "\Folder")
End Function

' Obtiene el valor de una opción de configuración
Function OpcionConfig(opcion As String) As String
   OpcionConfig = RegKeyRead("HKEY_CURRENT_USER\" & ClaveEmpresaActual & "\" & opcion)
End Function

' Obtiene el valor de una opción de configuración
Function CambiarOpcion(opcion As String, Valor As String) As String
   Call RegKeySave("HKEY_CURRENT_USER\" & ClaveEmpresaActual & "\" & opcion, Valor)
End Function

