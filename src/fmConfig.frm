VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} fmConfig 
   Caption         =   "Configuración"
   ClientHeight    =   4770
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   8475
   OleObjectBlob   =   "fmConfig.frx":0000
   StartUpPosition =   1  'Centrar en propietario
End
Attribute VB_Name = "fmConfig"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub CommandButton1_Click()
    Guardar
    Unload Me
End Sub

Private Sub CommandButton2_Click()
    Unload Me
End Sub

Private Sub Cargar()
    edFolder.Text = OpcionConfig("Folder")
    edDB.Text = OpcionConfig("db")
    edDBURL.Text = OpcionConfig("dburl")
    edStartDB.Text = OpcionConfig("startdb")
End Sub

Private Sub Guardar()
    Call CambiarOpcion("Folder", edFolder.Text)
    Call CambiarOpcion("db", edDB.Text)
    Call CambiarOpcion("dburl", edDBURL.Text)
    Call CambiarOpcion("startdb", edStartDB.Text)

End Sub

Private Sub UserForm_Initialize()
  Cargar
End Sub
