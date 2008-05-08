VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmEdit 
   BackColor       =   &H00000000&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Edit Profile"
   ClientHeight    =   4635
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5955
   Icon            =   "Cobalt_frmEdit.frx":0000
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   ScaleHeight     =   4635
   ScaleWidth      =   5955
   StartUpPosition =   1  'CenterOwner
   Begin MSComctlLib.ImageList bg 
      Left            =   5280
      Top             =   2880
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   399
      ImageHeight     =   309
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   1
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmEdit.frx":0CCA
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.ImageList buttons 
      Left            =   5280
      Top             =   3480
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   58
      ImageHeight     =   22
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   6
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmEdit.frx":1614E
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmEdit.frx":170C2
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmEdit.frx":18036
            Key             =   ""
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmEdit.frx":18FAA
            Key             =   ""
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmEdit.frx":19F1E
            Key             =   ""
         EndProperty
         BeginProperty ListImage6 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmEdit.frx":1AE92
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin VB.PictureBox Picture2 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   330
      Left            =   4830
      ScaleHeight     =   330
      ScaleWidth      =   870
      TabIndex        =   8
      Top             =   4170
      Width           =   870
   End
   Begin VB.PictureBox Picture1 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   330
      Left            =   3885
      ScaleHeight     =   330
      ScaleWidth      =   870
      TabIndex        =   7
      Top             =   4170
      Width           =   870
   End
   Begin VB.TextBox ProfEdit 
      Appearance      =   0  'Flat
      BackColor       =   &H80000007&
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   1695
      Index           =   6
      Left            =   750
      MaxLength       =   255
      MultiLine       =   -1  'True
      TabIndex        =   6
      Top             =   2280
      Width           =   4815
   End
   Begin VB.TextBox ProfEdit 
      Appearance      =   0  'Flat
      BackColor       =   &H80000007&
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   270
      Index           =   5
      Left            =   2010
      MaxLength       =   84
      TabIndex        =   5
      Top             =   1830
      Width           =   3525
   End
   Begin VB.TextBox ProfEdit 
      Appearance      =   0  'Flat
      BackColor       =   &H80000007&
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   270
      Index           =   4
      Left            =   1995
      MaxLength       =   69
      TabIndex        =   4
      Top             =   1410
      Width           =   3525
   End
   Begin VB.TextBox ProfEdit 
      Appearance      =   0  'Flat
      BackColor       =   &H80000007&
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   270
      Index           =   3
      Left            =   4305
      MaxLength       =   19
      TabIndex        =   3
      Top             =   1005
      Width           =   1230
   End
   Begin VB.TextBox ProfEdit 
      Appearance      =   0  'Flat
      BackColor       =   &H80000007&
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   270
      Index           =   2
      Left            =   1995
      MaxLength       =   14
      TabIndex        =   2
      Top             =   1005
      Width           =   1230
   End
   Begin VB.TextBox ProfEdit 
      Appearance      =   0  'Flat
      BackColor       =   &H80000007&
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   270
      Index           =   1
      Left            =   2010
      MaxLength       =   54
      TabIndex        =   1
      Top             =   600
      Width           =   3525
   End
   Begin VB.TextBox ProfEdit 
      Appearance      =   0  'Flat
      BackColor       =   &H80000007&
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   270
      Index           =   0
      Left            =   2010
      MaxLength       =   39
      TabIndex        =   0
      Top             =   195
      Width           =   3525
   End
End
Attribute VB_Name = "frmEdit"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim Down As Boolean

Private Sub Form_Activate()
    On Error Resume Next
    Me.Width = 6045
    Me.Height = 5010
End Sub

Private Sub Form_Load()
    Me.Picture = bg.ListImages(1).Picture
    Picture1.Picture = buttons.ListImages(6).Picture
    Picture2.Picture = buttons.ListImages(3).Picture
    ProfEdit(0) = Trim(ProfileType.pAlias)
    ProfEdit(1) = Trim(ProfileType.pLocation)
    ProfEdit(2) = Trim(ProfileType.pBirthdate)
    ProfEdit(3) = Trim(ProfileType.pGender)
    ProfEdit(4) = Trim(ProfileType.pRelationship)
    ProfEdit(5) = Trim(ProfileType.pSite)
End Sub

Private Sub Picture1_Click()
    Dim lNewMsg As Byte, lOffset As Long, i As Integer, Txt As String
    Dim oNewMsg() As Byte, lNewOffSet As Long
    
    lNewMsg = MSG_PROFILEEDIT
    lNewOffSet = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
    i = 2
    AddBufferData oNewMsg, VarPtr(i), LenB(i), lNewOffSet
    ProfileType.pAlias = ProfEdit(0)
    ProfileType.pLocation = ProfEdit(1)
    ProfileType.pBirthdate = ProfEdit(2)
    ProfileType.pGender = ProfEdit(3)
    ProfileType.pRelationship = ProfEdit(4)
    ProfileType.pSite = ProfEdit(5)
    Txt = String$(255, Chr(0))
    CopyMemory ByVal Txt, ProfileType, 255
    AddBufferString oNewMsg, Txt, lNewOffSet
    Txt = Trim$(ProfEdit(6))
    If Txt = "" Then Txt = Chr(0)
    AddBufferString oNewMsg, Txt, lNewOffSet
    'dpc.Send oNewMsg, 0, DPNSEND_GUARANTEED
    SendTo oNewMsg, True
    Unload Me
End Sub

Private Sub Picture1_GotFocus()
    If Down Then Exit Sub
    Picture1.Picture = buttons.ListImages(5).Picture
End Sub
Private Sub Picture1_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode <> 13 Then Exit Sub
    Picture1.Picture = buttons.ListImages(4).Picture
End Sub
Private Sub Picture1_MouseDown(Button As Integer, Shift As Integer, x As Single, Y As Single)
    Down = True
    Picture1.Picture = buttons.ListImages(4).Picture
End Sub
Private Sub Picture1_MouseUp(Button As Integer, Shift As Integer, x As Single, Y As Single)
    Down = False
    Picture1.Picture = buttons.ListImages(5).Picture
End Sub
Private Sub Picture1_KeyUp(KeyCode As Integer, Shift As Integer)
    If KeyCode <> 13 Then Exit Sub
    Picture1.Picture = buttons.ListImages(5).Picture
End Sub
Private Sub Picture1_LostFocus()
    Picture1.Picture = buttons.ListImages(6).Picture
End Sub

Private Sub Picture2_Click()
    Unload Me
End Sub

Private Sub Picture2_GotFocus()
    If Down Then Exit Sub
    Picture2.Picture = buttons.ListImages(2).Picture
End Sub
Private Sub Picture2_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode <> 13 Then Exit Sub
    Picture2.Picture = buttons.ListImages(1).Picture
End Sub
Private Sub Picture2_MouseDown(Button As Integer, Shift As Integer, x As Single, Y As Single)
    Down = True
    Picture2.Picture = buttons.ListImages(1).Picture
End Sub
Private Sub Picture2_MouseUp(Button As Integer, Shift As Integer, x As Single, Y As Single)
    Down = False
    Picture2.Picture = buttons.ListImages(2).Picture
End Sub
Private Sub Picture2_KeyUp(KeyCode As Integer, Shift As Integer)
    If KeyCode <> 13 Then Exit Sub
    Picture2.Picture = buttons.ListImages(2).Picture
    Unload Me
End Sub
Private Sub Picture2_LostFocus()
    Picture2.Picture = buttons.ListImages(3).Picture
End Sub
