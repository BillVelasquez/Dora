Attribute VB_Name = "moDocument"
Option Explicit

' Obtiene el Objeto XML correspondiente de un libro
Public Function GetXML(book As Workbook) As MSXML2.IXMLDOMDocument2
    Dim xml As String
    
    Call book.XmlMaps.Item(1).ExportXml(xml)
    
    Dim doc As New MSXML2.DOMDocument60
    doc.LoadXML (xml)
    Set GetXML = doc

End Function

' Funcion necesaria porque el ID interno de la hoja puede ser diferente del nombre que le pone el usuario
Private Function GetSheet(book As Workbook, name As String) As Worksheet
    Dim ws As Worksheet
    
    For Each ws In book.Worksheets
        If StrComp(name, ws.name, vbTextCompare) = 0 Then
            Set GetSheet = ws
            Exit Function
        End If
    Next
    
End Function

' Guarda un libro con el nombre correspondiente segun el numero junto con el XML y el PDF
Public Sub SaveDoc(book As Workbook)
    Dim doc As IXMLDOMDocument2
    
    Set doc = GetXML(book)
    
    Dim num As String
    Dim fecha As String
    Dim tipo As String
    
     ' Arma en el formato AAAA\MM\Tipo\###.*
     Dim rutabase As String
            
'            // Asegurar que exista la carpeta
' !!!PEND            Directory.CreateDirectory( rutabase );

    If doc.DocumentElement.BaseName = "Comprobante" Then
        num = doc.SelectSingleNode("/*/Numero").Text
        fecha = doc.SelectSingleNode("/*/Fecha").Text
        tipo = doc.SelectSingleNode("/*/Tipo").Text

    ' Ruta que se usa para le nombre de los archivos
        rutabase = RutaDoc(book)
        rutabase = rutabase & "\" & num
    Else
        ' otro tipo de documentos, p.ej Catalogos, usar nombre del archivo sin extension
        rutabase = Mid(book.FullName, 1, InStrRev(book.FullName, ".") - 1)
    End If

    ' Guardar en PDF
        
    Dim ws As Worksheet
    Set ws = GetSheet(book, "Documento")
    
    If ws Is Nothing Then
        Set ws = book.Sheets(1)
    End If
        
    
            Call ws.ExportAsFixedFormat(XlFixedFormatType.xlTypePDF, rutabase & ".pdf", _
                XlFixedFormatQuality.xlQualityStandard, True)

     ' Adjuntar PDF
     ' !!!!PEND!!!       AdjuntarArchivo(Path.GetFileName(rutabase + ".pdf"), "IMPRESION");

     '  Guardar
            If StrComp(book.FullName, rutabase + ".xlsx", vbTextCompare) = 0 Then
            ' ya tiene el nombre correcto
                book.Save
            Else
            ' se debe poner el nombre adecuado para el numero
                book.SaveAs (rutabase & ".xlsx")
            End If

            ' Guardar en XML
            Call book.XmlMaps.Item(1).Export(rutabase & ".xml", True)
    
    

End Sub



' Retorna la ruta en el disco donde debería quedar guardado el documento actual según su Tipo y Fecha
        
Public Function RutaDoc(book As Workbook) As String

    Dim doc As IXMLDOMDocument2
    Set doc = GetXML(book)

On Error GoTo catch

    Dim fecha As String
    fecha = doc.SelectSingleNode("/*/Fecha").Text
    
    Dim tipo As String
    tipo = doc.SelectSingleNode("/*/Tipo").Text
    
    ' Si no tiene estos elementos generará excepcion y si va a Catch (ej. Catalogos)
    
    Dim base As String
    base = RutaEmpresa()
    If base = "" Then
        ' Si no tiene configuración, toma la ruta del libro actual
        base = book.Path
        
        'Determinar si es un documento Modelo
        If InStr(base, "\Modelos", vbTextCompare) > 0 Then
            ' Retornar a la carpeta anterior
            base = Mid(base, 1, InStrRev(base, "\") - 1)
        End If
    End If

    RutaDoc = base & "\" & Left(fecha, 4) & "\" & Mid(fecha, 6, 2) & "\" & tipo
    
    Exit Function
    
catch:
    ' Si no tiene xml
    ' Usar la misma carpeta donde está el documento
    RutaDoc = book.Path
End Function


Public Function NumeroUltimo(book As Workbook, ByRef tipo As String) As String
    Dim doc As IXMLDOMDocument2
    
    Set doc = GetXML(book)

    Dim num As String
    Dim fecha As String
    
     ' Arma en el formato AAAA\MM\Tipo\###.*
     Dim rutabase As String
            
    If doc.DocumentElement.BaseName = "Comprobante" Then
        num = doc.SelectSingleNode("/*/Numero").Text
        fecha = doc.SelectSingleNode("/*/Fecha").Text
        tipo = doc.SelectSingleNode("/*/Tipo").Text

    ' Ruta que se usa para le nombre de los archivos
        rutabase = RutaEmpresa()
    Else
        ' otro tipo de documentos, p.ej Catalogos, no se pueden numerar
        NumeroUltimo = ""
        Exit Function
    End If

    Dim ultimo As String
    ultimo = EncontrarMayor(rutabase, tipo, Mid(fecha, 6, 2))
    
    NumeroUltimo = ultimo

End Function

' Numera el documento y le llena las propiedades
Public Sub CambiarNumero(book As Workbook, numero As String)
    Dim xpath As String
    xpath = "/ns1:Comprobante/Numero"
    
    Dim hoja As Worksheet
    Set hoja = book.Sheets("Documento")
    Dim param As Worksheet
    Set param = book.Sheets("Parametros")

    Dim c As Range
    
    Set c = BuscarXPath(hoja, xpath)
        
    If c Is Nothing Then
        ' Print xpath, " no encontrado"
        Exit Sub
    End If
    
    c.Value = numero

    ' Poner Fecha de Creación
    Dim d As Range
    Set d = BuscarXPath(param, "/ns1:Comprobante/ns1:Propiedades/Fecha_Creacion")
    
    If Not d Is Nothing Then
        ' Print "Fecha no encontrado"
        d.Value = Now()
    End If

    ' Poner Usuario Creador
    Set d = BuscarXPath(param, "/ns1:Comprobante/ns1:Propiedades/Usuario_Creacion")
    
    'If Not d Is Nothing Then
     '   d.Value = Environment.UserName;

      '          // Poner Usuario Actualizacion
       '         d = BuscarXPath(param, "/ns1:Comprobante/ns1:Propiedades/Usuario_Actualizacion");
        '        if (d != null)
         '           d.Value = Environment.UserName;

          '      // Poner UUID
           '     d = BuscarXPath(param, "/ns1:Comprobante/UUID");
            '    if (d != null)
             '       d.Value = Guid.NewGuid().ToString();

End Sub

            
Public Sub NumerarDoc(book As Workbook)
    Dim ultimo As String
    Dim tipo As String
    
    ultimo = NumeroUltimo(book, tipo)
    
    Dim nxt As String
    
    If ultimo = "" Then
        ' No hay un documento previo, usar el numero actual
        MsgBox ("No hay documentos anteriores del tipo " & tipo & _
                ". Se usará el número que se indique manualmente para este documento.")
    Else
        nxt = ""
        Dim pos As Integer
        pos = InStr(ultimo, "-")
        
        Dim numstr As String
        Dim num As Integer
        Dim fmt As String
        
        If pos > 0 Then
            ' Tiene prefijo XXX- antes del numero
            numstr = Mid(ultimo, pos + 1)
            num = CInt(numstr) + 1
            fmt = String(Len(numstr), "0")
            nxt = Left(ultimo, pos) & Format(num, fmt)
        Else
            ' Sin prefijo
            numstr = ultimo
            num = CInt(numstr) + 1
            fmt = String(Len(numstr), "0")
            nxt = Format(num, fmt)
        End If

        Call CambiarNumero(book, nxt)
    End If
End Sub

'Busca la celda que tiene asignada una expresión XPath
' <param name="ws">Hoja donde se va a buscar</param>
' <param name="xpath">XPath buscado</param>
' <returns>Objeto Range con la referencia a la celda o null si no se encontró ninguna en la hoja</returns>
Function BuscarXPath(ws As Worksheet, xpath As String) As Range
    On Error GoTo catch

    Dim c As Range
    
    For Each c In ws.UsedRange.Cells
        If Not c.xpath Is Nothing Then
            If (c.xpath.Value = xpath) Then
                Set BuscarXPath = c
                Exit Function
            End If
        End If
    Next
    
catch:

End Function

Function MaxDir(ruta As String) As String
    Dim dirs
    dirs = Dir(ruta, vbDirectory)
    
    Dim flag As Boolean
    flag = True
    
    Dim maxano As String
    maxano = ""
    
    ' Encontrar el mayor año
    While flag = True
       If dirs = "" Then
           flag = False
       Else
           If IsNumeric(dirs) And dirs > maxano Then
               maxano = dirs
           End If
           dirs = Dir
       End If
    Wend
    
    MaxDir = maxano
End Function


Function MaxFile(ruta As String) As String
    Dim dirs
    dirs = Dir(ruta)
    
    Dim flag As Boolean
    flag = True
    
    Dim maxano As String
    maxano = ""
    
    ' Encontrar el mayor año
    While flag = True
       If dirs = "" Then
           flag = False
       Else
           If dirs > maxano Then
               maxano = dirs
           End If
           dirs = Dir
       End If
    Wend
    
    MaxFile = maxano
End Function

Function EncontrarMayor(ruta As String, tipo As String, mes_actual As String) As String
    Dim maxaño As String
    
    maxaño = MaxDir(ruta & "\2*")
    If maxaño = "" Then
        Exit Function
    End If
 
    ' Obtener Mayor mes
    ' string[] meses = Directory.GetDirectories(maxaño); // Solo trae directorios que sean numeros
    Dim maxmes As String
    
    maxmes = MaxDir(ruta & "\" & maxaño & "\*.*")
    
    If maxmes = "" Then
        Exit Function
    End If
    

    ' Obtener mayor documento
    Dim MaxDoc As String
    
    While MaxDoc = ""
        MaxDoc = MaxFile(ruta & "\" & maxaño & "\" & maxmes + "\" + tipo + "\*.xml")
        If MaxDoc = "" Then
            ' Si no encuentra, busca en el mes anterior
            maxmes = Format(CInt(maxmes) - 1, "00")
        End If
        
        ' No hay ningun docto anterior
        If CInt(maxmes) = 0 Then
            Exit Function
        End If
    Wend
    
    
    '                    string[] docs = Directory.GetFiles(maxmes + "\\" + tipo, "*.xml"); // Solo trae archivos xml
    '                    result = Path.GetFileNameWithoutExtension(docs.Max());
 
 
    If MaxDoc = "" Then
        Exit Function
    End If
 
    Dim filename As String
'    filename = Mid(MaxDoc, InStrRev(MaxDoc, "\"))
    
    EncontrarMayor = Left(MaxDoc, InStrRev(MaxDoc, ".") - 1)
End Function
