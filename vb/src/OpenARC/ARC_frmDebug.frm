VERSION 5.00
Begin VB.Form frmDebug 
   BackColor       =   &H00000000&
   Caption         =   "OpenARC Debug Log"
   ClientHeight    =   4950
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6615
   ControlBox      =   0   'False
   Icon            =   "ARC_frmDebug.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   330
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   441
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txtInput 
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "Terminal"
         Size            =   6
         Charset         =   255
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   195
      Left            =   120
      TabIndex        =   0
      Top             =   4680
      Width           =   6375
   End
   Begin VB.TextBox txtDebug 
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "Courier New"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   4755
      Left            =   60
      MultiLine       =   -1  'True
      TabIndex        =   1
      Top             =   60
      Width           =   6495
   End
End
Attribute VB_Name = "frmDebug"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private TTop As Integer
Private TLeft As Integer
Private THDiff As Integer
Private TWDiff As Integer

Private ILeft As Integer
Private ITDiff As Integer
Private IWDiff As Integer

Private Sub Form_Load()
    TTop = txtDebug.Top
    TLeft = txtDebug.Left
    THDiff = Me.ScaleHeight - txtDebug.Height
    TWDiff = Me.ScaleWidth - txtDebug.Width
    
    ILeft = txtInput.Left
    ITDiff = Me.ScaleHeight - txtInput.Top
    IWDiff = Me.ScaleWidth - txtInput.Width
End Sub

Private Sub Form_Resize()
    txtDebug.Move TLeft, TTop, Me.ScaleWidth - TWDiff, Me.ScaleHeight - THDiff
    txtInput.Move ILeft, Me.ScaleHeight - ITDiff, Me.ScaleWidth - IWDiff
End Sub

Private Sub txtDebug_GotFocus()
    txtInput.SetFocus
    txtInput.SelStart = Len(txtInput)
End Sub

Public Sub AddText(Text As String)
    txtDebug.SelStart = Len(txtDebug.Text)
    txtDebug.SelLength = 0
    txtDebug.SelText = Text & vbCrLf
End Sub

Private Sub txtInput_KeyDown(KeyCode As Integer, Shift As Integer)
    If Len(Trim$(txtInput)) <> 0 Then
        If KeyCode = 13 Then
            Dim cmdlist() As String, I As Integer
            cmdlist = Split(txtInput.Text, " && ")
            AddText " > " & txtInput.Text
            For I = 0 To UBound(cmdlist)
                ProcessCommand cmdlist(I)
            Next
            txtInput = vbNullString
        End If
    End If
End Sub

Private Sub txtInput_KeyPress(KeyAscii As Integer)
    If KeyAscii = 13 Then KeyAscii = 0
End Sub
