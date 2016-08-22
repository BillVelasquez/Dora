Attribute VB_Name = "moReport"
Public Sub ActualizarReportes(book As Workbook)
    Call ActualizarListados(book)
    Call ActualizarTablas(book)
    
End Sub

Sub ActualizarListados(book As Workbook)
    Dim ws As Worksheet
    Dim qt As ListObject
    
    On Error GoTo Catch
    
    For Each ws In book.Worksheets
        For Each qt In ws.ListObjects
        
            If qt.SourceType = xlSrcXml Then
                qt.XmlMap.DataBinding.Refresh
            End If
        Next
    Next
    
    Exit Sub
    
Catch:
    MsgBox Err.Description
    
End Sub

Sub ActualizarTablas(book As Workbook)
    Dim pc As PivotCache
    
    ' On Error Resume Next
    
    For Each pc In book.PivotCaches
        pc.Refresh
    Next
End Sub
