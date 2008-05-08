VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmLate 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Bandwidth"
   ClientHeight    =   4650
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   3960
   BeginProperty Font 
      Name            =   "Arial"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "Cobalt_frmLatency.frx":0000
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   ScaleHeight     =   4650
   ScaleWidth      =   3960
   StartUpPosition =   1  'CenterOwner
   Begin MSComctlLib.ImageList buttons 
      Left            =   3360
      Top             =   600
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   58
      ImageHeight     =   22
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   7
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmLatency.frx":0CCA
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmLatency.frx":1C3E
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmLatency.frx":2BB2
            Key             =   ""
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmLatency.frx":3B26
            Key             =   ""
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmLatency.frx":4A9A
            Key             =   ""
         EndProperty
         BeginProperty ListImage6 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmLatency.frx":5A0E
            Key             =   ""
         EndProperty
         BeginProperty ListImage7 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmLatency.frx":6982
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin VB.Timer Timer1 
      Interval        =   1000
      Left            =   240
      Top             =   4080
   End
   Begin VB.TextBox Text3 
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   510
      Locked          =   -1  'True
      TabIndex        =   4
      Top             =   3060
      Width           =   3015
   End
   Begin VB.TextBox Text2 
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   510
      Locked          =   -1  'True
      TabIndex        =   3
      Top             =   2385
      Width           =   3015
   End
   Begin VB.TextBox Text1 
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   510
      Locked          =   -1  'True
      TabIndex        =   2
      Top             =   1680
      Width           =   3015
   End
   Begin VB.PictureBox Picture2 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   330
      Left            =   2850
      ScaleHeight     =   330
      ScaleWidth      =   870
      TabIndex        =   1
      Top             =   4200
      Width           =   870
   End
   Begin VB.PictureBox Picture1 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   330
      Left            =   1920
      ScaleHeight     =   330
      ScaleWidth      =   870
      TabIndex        =   0
      Top             =   4200
      Width           =   870
   End
   Begin MSComctlLib.ImageList bg 
      Left            =   3360
      Top             =   0
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   264
      ImageHeight     =   310
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   1
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmLatency.frx":78F6
            Key             =   ""
         EndProperty
      EndProperty
   End
End
Attribute VB_Name = "frmLate"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim Down As Boolean, BSummary(4) As String

Private Sub Form_Activate()
    On Error Resume Next
    Me.Width = 4050
    Me.Height = 5025
End Sub

Private Sub Form_Load()
    On Error Resume Next
    BSummary(0) = "Excellent - Little or no lag"
    BSummary(1) = "Good - Minor lag"
    BSummary(2) = "Ok - Some lag jumps"
    BSummary(3) = "Forget it - Uselessly laggy!"
    BSummary(4) = "Server unreachable!"
    If SrvBwidth > 0 Then
        Text1 = ServerDat(SrvBwidth).sName
        Text3 = ServerDat(SrvBwidth).Creator
        Text2 = ServerDat(SrvBwidth).latency & " ms. " & BSummary(ServerDat(SrvBwidth).MrB)
        If Bwidth = 0 Then PlayWAV "excellent.wav", False
        If Bwidth = 3 Then PlayWAV "forgetit.wav", False
    End If
    Me.Picture = bg.ListImages(1).Picture
    Picture1.Picture = buttons.ListImages(3).Picture
    Picture2.Picture = buttons.ListImages(7).Picture
    'If frmMain.WindowState <> vbNormal Then frmMain.WindowState = vbNormal
End Sub

Private Sub Picture2_Click()
    Unload Me
End Sub
Private Sub Picture2_GotFocus()
    If Down Then Exit Sub
    Picture2.Picture = buttons.ListImages(6).Picture
End Sub
Private Sub Picture2_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode <> 13 Then Exit Sub
    Picture2.Picture = buttons.ListImages(5).Picture
End Sub
Private Sub Picture2_MouseDown(Button As Integer, Shift As Integer, x As Single, Y As Single)
    Down = True
    Picture2.Picture = buttons.ListImages(5).Picture
End Sub
Private Sub Picture2_MouseUp(Button As Integer, Shift As Integer, x As Single, Y As Single)
    Down = False
    Picture2.Picture = buttons.ListImages(6).Picture
End Sub
Private Sub Picture2_KeyUp(KeyCode As Integer, Shift As Integer)
    If KeyCode <> 13 Then Exit Sub
    Picture2.Picture = buttons.ListImages(6).Picture
    Unload Me
End Sub
Private Sub Picture2_LostFocus()
    Picture2.Picture = buttons.ListImages(7).Picture
End Sub

Private Sub Picture1_Click()
    frmMain.MrB SrvBwidth
End Sub
Private Sub Picture1_GotFocus()
    If Down Then Exit Sub
    Picture1.Picture = buttons.ListImages(2).Picture
End Sub
Private Sub Picture1_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode <> 13 Then Exit Sub
    Picture1.Picture = buttons.ListImages(1).Picture
End Sub
Private Sub Picture1_MouseDown(Button As Integer, Shift As Integer, x As Single, Y As Single)
    Down = True
    Picture1.Picture = buttons.ListImages(1).Picture
End Sub
Private Sub Picture1_MouseUp(Button As Integer, Shift As Integer, x As Single, Y As Single)
    Down = False
    Picture1.Picture = buttons.ListImages(2).Picture
End Sub
Private Sub Picture1_KeyUp(KeyCode As Integer, Shift As Integer)
    If KeyCode <> 13 Then Exit Sub
    Picture1.Picture = buttons.ListImages(2).Picture
End Sub
Private Sub Picture1_LostFocus()
    Picture1.Picture = buttons.ListImages(3).Picture
End Sub

Private Sub Timer1_Timer()
    Dim x As Integer
    On Error Resume Next
    If UBound(ServerDat) = 0 Then Exit Sub
    If SrvBwidth = 0 Then Exit Sub
    If ServerDat(SrvBwidth) Is Nothing Then Exit Sub
    Text1 = ServerDat(SrvBwidth).sName
    Text3 = ServerDat(SrvBwidth).Creator
    Text2 = ServerDat(SrvBwidth).latency & " ms. " & BSummary(ServerDat(SrvBwidth).MrB)
End Sub
