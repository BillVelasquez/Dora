Attribute VB_Name = "moRibbon"
Option Explicit

Sub doraNumerar(control As IRibbonControl)
    Call NumerarDoc(ActiveWorkbook)
End Sub

Sub doraGuardar(control As IRibbonControl)
    Call SaveDoc(ActiveWorkbook)
End Sub

Sub doraConfiguracion(control As IRibbonControl)
    fmConfig.Show vbModal
End Sub

Sub doraInformes(control As IRibbonControl)
    Call GenerarDB(OpcionConfig("dburl"), OpcionConfig("Folder"), OpcionConfig("db"))
    Call ActualizarReportes(ActiveWorkbook)
End Sub

