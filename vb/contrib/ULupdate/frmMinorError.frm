VERSION 5.00
Begin VB.Form frmError 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Error"
   ClientHeight    =   2685
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   4605
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2685
   ScaleWidth      =   4605
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmdEnd 
      Caption         =   "&End Program"
      Height          =   495
      Left            =   2340
      TabIndex        =   3
      Top             =   2040
      Width           =   1575
   End
   Begin VB.CommandButton cmdIgnore 
      Caption         =   "&Ignore"
      Height          =   495
      Left            =   660
      TabIndex        =   2
      Top             =   2040
      Width           =   1575
   End
   Begin VB.Frame Frame1 
      Caption         =   "Message"
      Height          =   1695
      Left            =   720
      TabIndex        =   0
      Top             =   120
      Width           =   3735
      Begin VB.Label lblErrorMessage 
         Height          =   1335
         Left            =   120
         TabIndex        =   1
         Top             =   240
         Width           =   3495
      End
   End
   Begin VB.Image Image1 
      Height          =   465
      Left            =   120
      Picture         =   "frmMinorError.frx":0000
      Top             =   360
      Width           =   450
   End
End
Attribute VB_Name = "frmError"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Public Event UnloadSystem()

Private Sub cmdEnd_Click()
RaiseEvent UnloadSystem
End Sub

Private Sub cmdIgnore_Click()
Unload Me
End Sub

Private Sub Form_Load()
MakeAlwaysOnTop Me, True
End Sub
