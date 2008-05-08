VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "mswinsck.ocx"
Begin VB.Form frmSettings 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Server Settings"
   ClientHeight    =   1935
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4590
   Icon            =   "Cobalt_frmSettings.frx":0000
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1935
   ScaleWidth      =   4590
   StartUpPosition =   1  'CenterOwner
   Begin MSWinsockLib.Winsock Winsock2 
      Left            =   600
      Top             =   1560
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSComctlLib.ImageList bg 
      Left            =   1560
      Top             =   1560
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   306
      ImageHeight     =   129
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   1
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmSettings.frx":0CCA
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin VB.ComboBox Combo1 
      BackColor       =   &H00000000&
      ForeColor       =   &H0000FF00&
      Height          =   315
      Left            =   120
      Style           =   2  'Dropdown List
      TabIndex        =   5
      Top             =   360
      Width           =   4335
   End
   Begin VB.TextBox Text3 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   220
      Left            =   3600
      Locked          =   -1  'True
      TabIndex        =   4
      Top             =   1080
      Width           =   855
   End
   Begin VB.TextBox Text2 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   220
      Left            =   2640
      Locked          =   -1  'True
      TabIndex        =   3
      Top             =   1080
      Width           =   735
   End
   Begin VB.TextBox Text1 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   220
      Left            =   120
      Locked          =   -1  'True
      TabIndex        =   2
      Top             =   1080
      Width           =   2295
   End
   Begin MSWinsockLib.Winsock Winsock1 
      Left            =   120
      Top             =   1560
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.PictureBox Picture2 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   330
      Left            =   3600
      ScaleHeight     =   330
      ScaleWidth      =   870
      TabIndex        =   1
      Top             =   1470
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
      Left            =   2685
      ScaleHeight     =   330
      ScaleWidth      =   870
      TabIndex        =   0
      Top             =   1470
      Width           =   870
   End
   Begin MSComctlLib.ImageList buttons 
      Left            =   1440
      Top             =   1560
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
            Picture         =   "Cobalt_frmSettings.frx":4A20
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmSettings.frx":5994
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmSettings.frx":6908
            Key             =   ""
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmSettings.frx":787C
            Key             =   ""
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmSettings.frx":87F0
            Key             =   ""
         EndProperty
         BeginProperty ListImage6 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmSettings.frx":9764
            Key             =   ""
         EndProperty
      EndProperty
   End
End
Attribute VB_Name = "frmSettings"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Type tServer
    Host As String
    port As Integer
    Description As String
    Status As Boolean
End Type
Private Servers() As tServer
Dim StillProcessing As Boolean
Dim Host As String
Dim Testing As Boolean
Dim TestingResult As Boolean
Dim Result As Integer
Dim Down As Boolean
Dim file As String
Dim MirrorList As String
Private WithEvents TimeoutTimer As clsCTimer
Attribute TimeoutTimer.VB_VarHelpID = -1
Private WithEvents TimeoutTimer1 As clsCTimer
Attribute TimeoutTimer1.VB_VarHelpID = -1

Private Sub Combo1_Click()
    Combo1.ToolTipText = Servers(Combo1.ListIndex).Description
    Text1.Text = Servers(Combo1.ListIndex).Host
    Text2.Text = Servers(Combo1.ListIndex).port
    If Servers(Combo1.ListIndex).Status = True Then
        Text3.ForeColor = vbGreen
        Text3.Text = "ONLINE"
    Else
        Text3.ForeColor = vbRed
        Text3.Text = "OFFLINE"
    End If
End Sub

Function DSplit(What As String, Delimeter1 As String, Delimeter2 As String) As String
    On Error GoTo errors
    Dim a
    Dim B
    a = Split(What, Delimeter1)
    B = Split(a(1), Delimeter2)
    DSplit = B(0)
    Exit Function
errors:
    DSplit = ""
End Function

Function GetLineType(Line As String) As Integer
    Dim a
    a = DSplit(Line, "<", ">")
    Select Case LCase$(a)
    Case "?xml version=""""1.0"""" ?"
        GetLineType = 0
    Case "cobalt"
        GetLineType = 1
    Case "version"
        GetLineType = 2
    Case "servers"
        GetLineType = 3
    Case "serverlist"
        GetLineType = 4
    Case "server"
        GetLineType = 5
    Case "ip"
        GetLineType = 6
    Case "port"
        GetLineType = 7
    Case "desc"
        GetLineType = 8
    Case "/server"
        GetLineType = 9
    Case "/serverlist"
        GetLineType = 10
    Case "/cobalt"
        GetLineType = 11
    Case Else
        GetLineType = -1
    End Select
End Function

Function GetLine(CobaltXML As String, LineNum As Integer) As String
    Dim a() As String
    a = Split(CobaltXML, vbCrLf)
    GetLine = a(LineNum)
End Function

Function LineCount(CobaltXML As String) As Integer
    Dim a() As String
    a = Split(CobaltXML, vbCrLf)
    LineCount = UBound(a)
End Function

Sub AddServersToList(CobaltXML As String, Combo As ComboBox)
    Dim LC As Integer
    Dim i As Integer
    Dim LT As Integer
    Dim Line As String
    Dim CurServer As Integer
    Dim Server As String
    Dim port As String
    Dim Desc As String
    Combo.Clear
    If Trim$(Replace(CobaltXML, Chr(13), "")) = "" Then Exit Sub
    LC = LineCount(CobaltXML)
    For i = 0 To LC
        LT = GetLineType(GetLine(CobaltXML, CInt(i)))
        Line = GetLine(CobaltXML, CInt(i))
        Select Case LT
        Case 3
            ReDim Preserve Servers(Val(DSplit(Line, "<servers>", "</servers>")))
        Case 6
            Server = DSplit(Line, "<ip>", "</ip>")
        Case 7
            port = DSplit(Line, "<port>", "</port>")
        Case 8
            Desc = DSplit(Line, "<desc>", "</desc>")
        End Select
        If Server <> "" And port <> "" And Desc <> "" Then
            Servers(CurServer).Host = Server
            Servers(CurServer).port = port
            Servers(CurServer).Description = Desc
            Servers(CurServer).Status = TestServer(Server, CInt(port))
            Server = ""
            port = ""
            Desc = ""
            CurServer = CurServer + 1
        End If
    Next
    For i = 0 To UBound(Servers)
        Combo.AddItem Servers(i).Host
    Next
    Combo.ListIndex = 0
End Sub

Function GetUpdateList(URL As String)
    StillProcessing = True
    Dim i() As String
    i = Split(URL, "/")
    Winsock1.Close
    Winsock1.RemoteHost = i(2)
    Host = i(2)
    Winsock1.RemotePort = 80
    file = GetFileP(URL)
    TimeoutTimer1.Interval = 3000
    Winsock1.Connect
    TimeoutTimer1.Enable
End Function

Function GetFileP(URL As String) As String
    Dim i() As String
    Dim B As Integer
    Dim tmp As String
    i = Split((URL), "/")
    For B = 3 To UBound(i)
        tmp = tmp & "/" & i(B)
    Next
    GetFileP = tmp
End Function

Private Sub Form_Load()
    Set TimeoutTimer1 = New clsCTimer
    Set TimeoutTimer = New clsCTimer
    Dim x As Long
    Me.Picture = bg.ListImages(1).Picture
    Picture1.Picture = buttons.ListImages(3).Picture
    Picture2.Picture = buttons.ListImages(6).Picture
    If Not DevEnv Or 1 Then
        ErrorMSG = "Cobalt will now download the list of Cobalt servers. This make take up to one minute."
        DoEvents
        frmErrorbox.Show 1
        MirrorList = GetUpdateList("http://www.uplinklabs.net/mirrorlist.xml")
        Do While StillProcessing = True
            DoEvents
        Loop
        If Result = 404 Then
            ErrorMSG = "Failed to download the current list. Using the default list."
            frmErrorbox.Show 1
        Else
            AddServersToList MirrorList, Combo1
        End If
    Else
        ReDim Servers(0)
        Servers(0).Host = Winsock1.LocalIP
        Servers(0).port = 6000
        Servers(0).Description = "Default server"
        Servers(0).Status = TestServer(Servers(0).Host, Servers(0).port)
        Combo1.AddItem Winsock1.LocalIP
        Combo1.ListIndex = 0
    End If
    If Combo1.ListCount = 0 Then
        ReDim Servers(0)
        Servers(0).Host = "cobalt.uplinklabs.net"
        Servers(0).port = 6001
        Servers(0).Description = "Default server"
        Servers(0).Status = TestServer(Servers(0).Host, Servers(0).port)
        Combo1.AddItem "cobalt.uplinklabs.net"
        Combo1.ListIndex = 0
    End If
    Text2 = port
    If port = 0 Then Text2 = 6001
    On Error Resume Next
    Combo1.ListIndex = readini("Settings", "Listindex", AppPath & "Cobalt.ini", 0)
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    Set TimeoutTimer = Nothing
End Sub

Private Sub Picture1_Click()
    On Error Resume Next
    If Servers(Combo1.ListIndex).Status = True Then
        SaveIP
        Me.Hide
        frmSignOn.Show
    Else
        ErrorMSG = "The server you selected is offline."
        frmErrorbox.Show 1
    End If
End Sub
Sub SaveIP()
    HostAddy = Trim(Text1)
    port = Val(Text2)
    Call writeini("Settings", "Server", HostAddy, AppPath & "Cobalt.ini")
    Call writeini("Settings", "Port", port, AppPath & "Cobalt.ini")
    Call writeini("Settings", "Listindex", Combo1.ListIndex, AppPath & "Cobalt.ini")
    'Unload Me
End Sub
Private Sub Picture2_Click()
    frmSignOn.Show
    Unload Me
End Sub

Private Sub Text1_GotFocus()
    Text1.SelStart = 0
    Text1.SelLength = Len(Text1)
End Sub

Private Sub Text1_KeyPress(KeyAscii As Integer)
    If KeyAscii = 13 Then
        KeyAscii = 0
    End If
End Sub

Private Sub Text1_KeyUp(KeyCode As Integer, Shift As Integer)
    If KeyCode = 13 Then
        Picture1_Click
        KeyCode = 0
    End If
End Sub

Private Sub Text2_GotFocus()
    Text2.SelStart = 0
    Text2.SelLength = Len(Text2.Text)
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
    Picture1_Click
End Sub
Private Sub Picture1_LostFocus()
    Picture1.Picture = buttons.ListImages(3).Picture
End Sub

Private Sub Picture2_GotFocus()
    If Down Then Exit Sub
    Picture2.Picture = buttons.ListImages(5).Picture
End Sub
Private Sub Picture2_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode <> 13 Then Exit Sub
    Picture2.Picture = buttons.ListImages(4).Picture
End Sub
Private Sub Picture2_MouseDown(Button As Integer, Shift As Integer, x As Single, Y As Single)
    Down = True
    Picture2.Picture = buttons.ListImages(4).Picture
End Sub
Private Sub Picture2_MouseUp(Button As Integer, Shift As Integer, x As Single, Y As Single)
    Down = False
    Picture2.Picture = buttons.ListImages(5).Picture
End Sub
Private Sub Picture2_KeyUp(KeyCode As Integer, Shift As Integer)
    If KeyCode <> 13 Then Exit Sub
    Picture2.Picture = buttons.ListImages(5).Picture
    Picture2_Click
End Sub
Private Sub Picture2_LostFocus()
    Picture2.Picture = buttons.ListImages(6).Picture
End Sub

Private Sub TimeoutTimer_Timer()
    TimeoutTimer.Disable
    Winsock2.Close
    TestingResult = False
    Testing = False
End Sub

Private Sub TimeoutTimer1_Timer()
    TimeoutTimer1.Disable
    Winsock1.Close
    Result = 404
    StillProcessing = False
End Sub

Private Sub Winsock1_Connect()
    Dim Header As String
    TimeoutTimer1.Disable
    Header = Header & "GET " & file & " HTTP/1.1" & vbCrLf
    Header = Header & "Host: " & Host & vbCrLf
    Header = Header & "User-Agent: Cobalt\" & App.Major & "." & Format(App.Minor, "00") & "." & Format(App.Revision, "0000") & vbCrLf
    Header = Header & "Accept: text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5" & vbCrLf
    Header = Header & "Keep-Alive: 300" & vbCrLf
    Header = Header & "Connection: keep-alive" & vbCrLf
    Winsock1.SendData Header & vbCrLf 'sends the header
End Sub

Private Sub Winsock1_DataArrival(ByVal bytesTotal As Long)
    Dim a As String
    Dim c As Integer
    Dim capture As Boolean
    Dim x() As String
    Winsock1.GetData a, vbString, bytesTotal
    Dim B
    B = InStr(1, a, "<?xml")
    If B = 0 And LCase(Left$(a, 5)) <> "<?xml" Then Exit Sub
    If LCase(Mid$(a, B, 5)) = "<?xml" Then
        capture = True
        MirrorList = Mid$(a, B, Len(a) - B)
        'Debug.Print MirrorList
        Result = 200
        StillProcessing = False
        Exit Sub
    ElseIf UCase(Left$(a, 4)) = "HTTP" Then
        Result = Mid(a, 10, 3)
    Else
        Result = 404
    End If
    If Result = 404 Then StillProcessing = False: Exit Sub
    x = Split(a, vbCrLf)
    MirrorList = ""
    For c = 0 To UBound(x)
        'Debug.Print x(c)
        If capture = True Then
            MirrorList = MirrorList & x(c) & vbCrLf
        End If
        If Trim$(x(c)) = "" Then
            capture = True
        End If
    Next
    'StillProcessing = False
End Sub

Private Sub Winsock1_Error(ByVal Number As Integer, Description As String, ByVal Scode As Long, ByVal Source As String, ByVal HelpFile As String, ByVal HelpContext As Long, CancelDisplay As Boolean)
    Result = 404
    StillProcessing = False
End Sub

Function TestServer(Server As String, port As Integer) As Integer
    Testing = True
    Winsock2.RemoteHost = Server
    Winsock2.RemotePort = port
    Winsock2.Connect
    TimeoutTimer.Interval = 6000
    TimeoutTimer.Enable
    Do While Testing
        DoEvents
    Loop
    TestServer = TestingResult
End Function

Private Sub Winsock2_Connect()
    TimeoutTimer.Disable
    Winsock2.Close
    TestingResult = True
    Testing = False
End Sub

Private Sub Winsock2_Error(ByVal Number As Integer, Description As String, ByVal Scode As Long, ByVal Source As String, ByVal HelpFile As String, ByVal HelpContext As Long, CancelDisplay As Boolean)
    TimeoutTimer.Disable
    Winsock2.Close
    TestingResult = False
    Testing = False
End Sub
