Attribute VB_Name = "moDatabase"
Option Explicit

Sub IniciarDB()

End Sub

Function DbURL() As String

End Function

Function DbCorriendo() As Boolean

End Function

Sub GenerarDB(url, ruta, nombre)
Dim body As String
    body = "<command xmlns='http://basex.org/rest'>" & _
            "<text>create db " & nombre & " " & ruta & "</text>" & _
            "<option name='chop' value='true'/>" & _
            "<option name='stripns' value='true'/>" & _
            "<option name='intparse' value='true'/>" & _
            "<option name='addarchives' value='false'/>" & _
            "<option name='autooptimize' value='true'/>" & _
            "</command>"

 ' Realiza la solicitud HTTP

    On Error Resume Next
    
    Dim oHttp
    Set oHttp = CreateObject("MSXML2.XMLHTTP")
    
    If Err.Number <> 0 Then
        Set oHttp = CreateObject("MSXML.XMLHTTPRequest")
           MsgBox "Error 0 has occured while creating a MSXML.XMLHTTPRequest object"
    End If

    On Error GoTo Catch

    If oHttp Is Nothing Then
        MsgBox "For some reason I wasn't able to make a MSXML2.XMLHTTP object"
        Exit Sub
    End If

    'Open the URL in browser object

    oHttp.Open "POST", url, False

    oHttp.send (body)

    Select Case oHttp.Status
        Case 200: Application.StatusBar = "La Base de Datos se encuentra actualizada"
        Case 400, 500: MsgBox oHttp.responseText
    Case Else
         MsgBox oHttp.responseText
    End Select
    Exit Sub
    
Catch:
    MsgBox "La base de datos no se encuentra en ejecución. Debe iniciarla primero"
    
End Sub

Sub AlmacenarDoc(url, ruta)

End Sub
