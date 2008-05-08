VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmProfile 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Profile"
   ClientHeight    =   4575
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5940
   BeginProperty Font 
      Name            =   "Arial"
      Size            =   9
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   ForeColor       =   &H00000000&
   Icon            =   "Cobalt_frmProfile.frx":0000
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   ScaleHeight     =   4575
   ScaleWidth      =   5940
   StartUpPosition =   1  'CenterOwner
   Begin MSComctlLib.ImageList buttons 
      Left            =   3240
      Top             =   2040
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   58
      ImageHeight     =   22
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   3
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmProfile.frx":0CCA
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmProfile.frx":1C3E
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmProfile.frx":2BB2
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.ImageList bg 
      Left            =   2640
      Top             =   2040
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   396
      ImageHeight     =   305
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   1
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmProfile.frx":3B26
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.ListView ListView1 
      Height          =   1560
      Left            =   285
      TabIndex        =   3
      Top             =   660
      Width           =   1245
      _ExtentX        =   2196
      _ExtentY        =   2752
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      HideColumnHeaders=   -1  'True
      _Version        =   393217
      ForeColor       =   65280
      BackColor       =   0
      Appearance      =   0
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Arial"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      NumItems        =   0
   End
   Begin VB.CheckBox Check1 
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
      ForeColor       =   &H80000008&
      Height          =   165
      Left            =   330
      TabIndex        =   2
      Top             =   3210
      Width           =   195
   End
   Begin VB.PictureBox Picture1 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   330
      Left            =   4845
      ScaleHeight     =   330
      ScaleWidth      =   870
      TabIndex        =   1
      Top             =   4155
      Width           =   870
   End
   Begin VB.TextBox Text1 
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      ForeColor       =   &H0000FF00&
      Height          =   3225
      Left            =   1905
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   0
      Top             =   720
      Width           =   3690
   End
End
Attribute VB_Name = "frmProfile"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim Down As Boolean
Public ProfName As String

Private Sub Check1_Click()
    If Check1.Value = IsMuzzled(ProfName) * -1 Then Exit Sub
    frmMain.MuzzleThem ProfName
    Check1.Value = IsMuzzled(ProfName) * -1
End Sub

Private Sub Form_Activate()
    On Error Resume Next
    Me.Width = 6030
    Me.Height = 4950
End Sub

Private Sub Form_Load()
    ListView1.ColumnHeaders.Add , , "Stats", ListView1.Width - 300
    ListView1.View = lvwReport
    Me.Picture = bg.ListImages(1).Picture
    Picture1.Picture = buttons.ListImages(3).Picture
    If Trim(ProfileType.pAlias) <> "" Then Text1 = "alias: " & Trim(ProfileType.pAlias)
    If Trim(ProfileType.pLocation) <> "" Then Text1 = Text1 & vbNewLine & "location: " & Trim(ProfileType.pLocation)
    If Trim(ProfileType.pBirthdate) <> "" Then Text1 = Text1 & vbNewLine & "birthdate: " & Trim(ProfileType.pBirthdate)
    If Trim(ProfileType.pGender) <> "" Then Text1 = Text1 & vbNewLine & "gender: " & Trim(ProfileType.pGender)
    If Trim(ProfileType.pRelationship) <> "" Then Text1 = Text1 & vbNewLine & "relationship status: " & Trim(ProfileType.pRelationship)
    If Trim(ProfileType.pSite) <> "" Then Text1 = Text1 & vbNewLine & "favorite web site: " & Trim(ProfileType.pSite)
    StatsFill
End Sub

Private Sub Picture1_Click()
    Unload Me
End Sub

Private Sub Picture1_GotFocus()
    If Down Then Exit Sub
    Picture1.Picture = buttons.ListImages(2).Picture
End Sub
Private Sub Picture1_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode <> 13 Then Exit Sub
    Picture1.Picture = buttons.ListImages(1).Picture
End Sub

Private Sub Picture1_KeyPress(KeyAscii As Integer)
    If KeyAscii = 13 Then KeyAscii = 0
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
    KeyCode = 0
    Unload Me
End Sub
Private Sub Picture1_LostFocus()
    Picture1.Picture = buttons.ListImages(3).Picture
End Sub

Public Sub StatsFill()
    Dim itmX As ListItem
    
    Set itmX = ListView1.ListItems.Add()
    itmX.Text = "Day Frags"
    Set itmX = ListView1.ListItems.Add()
    itmX.ForeColor = RGB(255, 255, 254)
    itmX.Bold = True
    itmX.Text = ProfileStats.DFrags
    '
    Set itmX = ListView1.ListItems.Add()
    itmX.Text = "Day Deaths"
    Set itmX = ListView1.ListItems.Add()
    itmX.ForeColor = RGB(255, 255, 254)
    itmX.Bold = True
    itmX.Text = ProfileStats.DDeaths
    '
    Set itmX = ListView1.ListItems.Add()
    itmX.Text = "-------------------"
    Set itmX = ListView1.ListItems.Add()
    itmX.Text = "All Frags"
    Set itmX = ListView1.ListItems.Add()
    itmX.ForeColor = RGB(255, 255, 254)
    itmX.Bold = True
    itmX.Text = ProfileStats.AFrags
    '
    Set itmX = ListView1.ListItems.Add()
    itmX.Text = "All Deaths"
    Set itmX = ListView1.ListItems.Add()
    itmX.ForeColor = RGB(255, 255, 254)
    itmX.Bold = True
    itmX.Text = ProfileStats.ADeaths
    '
    Set itmX = ListView1.ListItems.Add()
    itmX.Text = "-------------------"
    Set itmX = ListView1.ListItems.Add()
    itmX.Text = "Now Uptime"
    Set itmX = ListView1.ListItems.Add()
    itmX.ForeColor = RGB(255, 255, 254)
    itmX.Bold = True
    itmX.Text = ProfileStats.NUptime
    '
    Set itmX = ListView1.ListItems.Add()
    itmX.Text = "Top Uptime"
    Set itmX = ListView1.ListItems.Add()
    itmX.ForeColor = RGB(255, 255, 254)
    itmX.Bold = True
    itmX.Text = ProfileStats.TUptime
End Sub
