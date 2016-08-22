Attribute VB_Name = "moCatalog"


Sub testSelect()
    Dim r
    Set r = fmSelect.Seleccionar("Cuentas")
    If Not r Is Nothing Then
        MsgBox r.xml
    End If
End Sub


Function ObtenerCatalogo(catalogo As String) As MSXML2.IXMLDOMDocument2
    Dim doc As New DOMDocument60
    
    doc.async = False
    
    doc.Load ("http://localhost:8984/rest?run=catalogo.xq&db=crd&cat=" & catalogo)
    
    If doc.parseError.ErrorCode <> 0 Then
        ' Tenemos problemas
        Err.Raise doc.parseError.ErrorCode, "ObtenerCatalogo", doc.parseError.reason
        Exit Function
    End If
    
    Set ObtenerCatalogo = doc
End Function

' Invoca la ventana de seleccion en la celda actual
Public Sub SeleccionarActual(book As Workbook)
    Dim path As String
    Dim catalogo As String
    Dim base As String
    
    
    path = ActiveCell.xpath
    
    ' Obtener el padre de la celda seleccionada
    Dim ult, penult As Integer
    ult = InStrRev(path, "/")
    
    base = Left(path, ult - 1)
    
    penult = InStrRev(base, "/")
    catalogo = Mid(path, penult + 1, ult - penult - 1)
    
    Dim r As IXMLDOMNode
    
    Set r = fmSelect.Seleccionar(catalogo)
    
    If r Is Nothing Then Exit Sub
    
    ' Asignar Celdas retornadas
    Dim origen As IXMLDOMNode
    Dim destino As Range
    
    For Each origen In r.ChildNodes
        ' Buscar celda correspondiente en la fila actual
        Set destino = BuscarXPathRango(ActiveSheet.Rows(ActiveCell.Row), base & "/" & origen.BaseName)
        
        If destino Is Nothing Then
            ' si no lo encuentra, busca en toda la hoja
            Set destino = BuscarXPath(ActiveSheet, base & "/" & origen.BaseName)
        End If
        
        If Not destino Is Nothing Then
            destino.Value = origen.Text
        End If
        
    Next
    
End Sub
