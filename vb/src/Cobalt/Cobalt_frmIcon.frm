VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmIcon 
   BackColor       =   &H00000000&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Set icon"
   ClientHeight    =   855
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   2130
   Icon            =   "Cobalt_frmIcon.frx":0000
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   855
   ScaleWidth      =   2130
   StartUpPosition =   3  'Windows Default
   Begin MSComctlLib.ImageCombo ImageCombo1 
      Height          =   330
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   1695
      _ExtentX        =   2990
      _ExtentY        =   582
      _Version        =   393216
      ForeColor       =   65280
      BackColor       =   0
      Text            =   "Player icon"
   End
End
Attribute VB_Name = "frmIcon"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
    Set ImageCombo1.ImageList = frmMain.ImageList1
    Dim i As Integer
    For i = 1 To frmMain.ImageList1.ListImages.Count
        ImageCombo1.ComboItems.Add , , i, i
    Next
End Sub

Private Sub ImageCombo1_Click()
    SetIcon = ImageCombo1.SelectedItem.Index
End Sub
