VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} fmSelect 
   Caption         =   "Seleccionar del Catálogo"
   ClientHeight    =   5340
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   8220
   OleObjectBlob   =   "fmSelect.frx":0000
   StartUpPosition =   1  'Centrar en propietario
End
Attribute VB_Name = "fmSelect"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim CatalogoActual As String
Dim Seleccion As String
Dim entradas As IXMLDOMDocument2



Public Function Seleccionar(catalogo As String) As IXMLDOMNode
    CargarCatalogo (catalogo)
    Me.Show vbModal
         
    Set Seleccionar = SeleccionActual()
End Function

Sub CargarCatalogo(catalogo As String)
    lbEntradas.Clear
    
    On Error GoTo Catch
    
    Set entradas = ObtenerCatalogo(catalogo)
    
    Dim actual As IXMLDOMNode
    Dim i As Long
    
    For Each actual In entradas.DocumentElement.ChildNodes
        If actual.ChildNodes.Length >= 2 Then
            
            lbEntradas.AddItem (actual.ChildNodes(0).Text)
            lbEntradas.Column(1, lbEntradas.ListCount - 1) = actual.ChildNodes(1).Text
        End If
    Next
    
    Exit Sub
    
Catch:
    MsgBox Err.Description
End Sub

Function SeleccionActual() As IXMLDOMNode
    If Seleccion <> "" Then
      Set SeleccionActual = entradas.SelectSingleNode("//Entrada[Codigo='" & Seleccion & "']")
    End If
    
End Function


Private Sub btAceptar_Click()
    Seleccion = lbEntradas.Column(0, lbEntradas.ListIndex)
    Hide
End Sub

Private Sub btCancelar_Click()
    Seleccion = ""
    Unload Me
End Sub


Private Sub txtBuscar_Change()
    Dim SearchCriteria, i
    Dim n As Long
    
    SearchCriteria = Me.txtBuscar.Value
    n = lbEntradas.ListCount
    
    For i = 0 To n - 1
        If InStr(1, lbEntradas.Column(1, i), SearchCriteria, vbTextCompare) > 0 Then
            lbEntradas.ListIndex = i
            Exit For
        End If
    Next i
End Sub

Private Sub txtBuscar_Enter()
    txtBuscar.Text = ""
    txtBuscar.ForeColor = vbBlack
    
End Sub
