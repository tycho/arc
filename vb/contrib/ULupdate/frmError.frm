VERSION 5.00
Begin VB.Form frmCriticalError 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Critical Error"
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
   Begin VB.Frame Frame1 
      Caption         =   "Message"
      Height          =   1695
      Left            =   720
      TabIndex        =   2
      Top             =   120
      Width           =   3735
      Begin VB.Label lblErrorMessage 
         Height          =   1335
         Left            =   120
         TabIndex        =   3
         Top             =   240
         Width           =   3495
      End
   End
   Begin VB.CommandButton cmdEndProgram 
      Caption         =   "&End Program"
      Height          =   495
      Left            =   2340
      TabIndex        =   1
      Top             =   2040
      Width           =   1575
   End
   Begin VB.CommandButton cmdSendReport 
      Caption         =   "&Ignore"
      Enabled         =   0   'False
      Height          =   495
      Left            =   660
      TabIndex        =   0
      Top             =   2040
      Width           =   1575
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   120
      Picture         =   "frmError.frx":0000
      Top             =   360
      Width           =   480
   End
End
Attribute VB_Name = "frmCriticalError"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Public Event UnloadSystem()

Private Sub cmdEndProgram_Click()
RaiseEvent UnloadSystem
End Sub

Private Sub Form_Load()
MakeAlwaysOnTop Me, True
End Sub

