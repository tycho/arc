VERSION 5.00
Object = "{48E59290-9880-11CF-9754-00AA00C00908}#1.0#0"; "MSINET.OCX"
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "mswinsck.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Begin VB.Form frmLogin 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Connect to Server"
   ClientHeight    =   4140
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   4785
   ControlBox      =   0   'False
   Icon            =   "Cobalt_frmLogin.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   276
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   319
   StartUpPosition =   2  'CenterScreen
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   4200
      Top             =   2400
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "Cancel"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   3480
      Picture         =   "Cobalt_frmLogin.frx":1042
      TabIndex        =   6
      Top             =   3120
      Width           =   1215
   End
   Begin VB.CheckBox Check1 
      Caption         =   "Remember my password"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   1680
      TabIndex        =   5
      Top             =   2400
      Width           =   2235
   End
   Begin VB.ComboBox cmbUserName 
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   1680
      TabIndex        =   0
      Top             =   1320
      Width           =   2775
   End
   Begin MSWinsockLib.Winsock sckTest 
      Left            =   3600
      Top             =   360
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin InetCtlsObjects.Inet inServerList 
      Left            =   4080
      Top             =   120
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
   End
   Begin VB.ComboBox cmbServers 
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   1680
      Style           =   2  'Dropdown List
      TabIndex        =   2
      Top             =   2040
      Width           =   2775
   End
   Begin VB.TextBox txtPassword 
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      IMEMode         =   3  'DISABLE
      Left            =   1680
      PasswordChar    =   "*"
      TabIndex        =   1
      Top             =   1680
      Width           =   2775
   End
   Begin VB.CommandButton cmdConnect 
      Caption         =   "Connect"
      Default         =   -1  'True
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   2160
      Picture         =   "Cobalt_frmLogin.frx":33AE
      TabIndex        =   3
      Top             =   3120
      Width           =   1215
   End
   Begin VB.CommandButton cmdNewUser 
      Caption         =   "New User"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   120
      Picture         =   "Cobalt_frmLogin.frx":571A
      TabIndex        =   4
      Top             =   3120
      Width           =   1215
   End
   Begin VB.Label lblWelcome 
      BackStyle       =   0  'Transparent
      Caption         =   "Welcome to CFront. If you do not already have an account, you can click the New User button to create one now."
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   120
      TabIndex        =   10
      Top             =   3600
      Width           =   4575
   End
   Begin VB.Line Line1 
      BorderColor     =   &H00808080&
      BorderStyle     =   6  'Inside Solid
      Index           =   1
      X1              =   8
      X2              =   310.667
      Y1              =   200
      Y2              =   200
   End
   Begin VB.Label lblInfo 
      BackStyle       =   0  'Transparent
      Caption         =   "&User:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   195
      Index           =   0
      Left            =   360
      TabIndex        =   9
      Top             =   1350
      Width           =   1215
   End
   Begin VB.Label lblInfo 
      BackStyle       =   0  'Transparent
      Caption         =   "&Password:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   195
      Index           =   1
      Left            =   360
      TabIndex        =   8
      Top             =   1725
      Width           =   1170
   End
   Begin VB.Label lblInfo 
      BackStyle       =   0  'Transparent
      Caption         =   "Server:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   195
      Index           =   2
      Left            =   360
      TabIndex        =   7
      Top             =   2100
      Width           =   1170
   End
   Begin VB.Image Image1 
      Height          =   900
      Left            =   0
      Picture         =   "Cobalt_frmLogin.frx":7A86
      Top             =   0
      Width           =   4800
   End
   Begin VB.Line Line1 
      BorderColor     =   &H00FFFFFF&
      BorderWidth     =   2
      Index           =   0
      X1              =   9
      X2              =   310.667
      Y1              =   201
      Y2              =   201
   End
End
Attribute VB_Name = "frmLogin"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'*******************************************************************'
'                           OpenARC                                 '
'                     Cobalt Gaming Systems                         '
' This program is free software; you can redistribute it and/or     '
' modify it under the terms of the GNU General Public License       '
' as published by the Free Software Foundation; either version 2    '
' of the License, or (at your option) any later version.            '
'                                                                   '
' This program is distributed in the hope that it will be useful,   '
' but WITHOUT ANY WARRANTY; without even the implied warranty of    '
' MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the      '
' GNU General Public License for more details.                      '
'                                                                   '
' You should have received a copy of the GNU General Public License '
' along with this program; if not, write to the Free Software       '
' Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.         '
'                                                                   '
'            Copyright © Uplink Laboratories 2003-2005              '
'*******************************************************************'

Option Explicit
Private Type tServer
    Host As String
    port As Integer
    Description As String
    Status As Boolean
End Type
Dim Testing As Boolean
Dim TestingResult As Boolean
Dim ServersLoaded As Boolean
Private WithEvents TimeoutTimer As clsCTimer
Attribute TimeoutTimer.VB_VarHelpID = -1
Private Servers() As tServer
Public AutoUpdate As prjUpdate.clsULupdate

Private Sub cmbServers_Click()
    If ServersLoaded Then
        writeini "Settings", "ServerIndex", cmbServers.ListIndex, AppPath & "Cobalt.ini"
    End If
End Sub

Private Sub cmbUserName_Click()
    If LoginPasswords(cmbUserName.ListIndex) <> vbNullString Then
        Check1.Value = 1: txtPassword = LoginPasswords(cmbUserName.ListIndex)
    Else
        Check1.Value = 0: txtPassword = vbNullString
    End If
End Sub

Private Sub cmdCancel_Click()
    End
End Sub

Private Sub cmdConnect_Click()
    EnableEncryption = False
    SigningUp = False
    port = Servers(cmbServers.ListIndex).port
    HostAddy = Servers(cmbServers.ListIndex).Host
    DisEnable True
    SetupLogin
End Sub

Private Sub cmdNewUser_Click()
    EnableEncryption = False
    NewUser = True
    SigningUp = True
    port = Servers(cmbServers.ListIndex).port
    HostAddy = Servers(cmbServers.ListIndex).Host
    Connect
End Sub

Public Sub ShowNewUser()
    frmNewUser.Show 1
End Sub

Private Sub Form_Load()
    Dim i As Long
    Load frmMain
    frmMain.sckMain.AddressFamily = AF_INET
    frmMain.sckMain.Protocol = IPPROTO_IP
    frmMain.sckMain.SocketType = SOCK_STREAM
    frmMain.sckMain.LocalPort = IPPORT_ANY
    frmMain.sckMain.Binary = True
    frmMain.sckMain.BufferSize = 16384
    frmMain.sckMain.Blocking = False
    frmMain.sckMain.AutoResolve = False
    'Me.Caption = ProjectName & " Login"
    Me.Visible = False
    Set TimeoutTimer = New clsCTimer
    GetServerList
    
    HostAddy = readini("Settings", "Server", AppPath & "Cobalt.ini", "cobalt.uplinklabs.net")
    LoadSN
    If LoginNames(0) <> vbNullString Then
        For i = 0 To UBound(LoginNames)
            If LoginNames(i) = UserName Then Exit For
        Next
        If i <= UBound(LoginNames) Then txtPassword = LoginPasswords(i)
    End If
    For i = 0 To UBound(LoginNames)
        If LoginNames(i) <> vbNullString Then
            cmbUserName.AddItem LoginNames(i)
            If LCase(LoginNames(i)) = LCase(UserName) Then cmbUserName.ListIndex = i
        End If
    Next
End Sub

Private Sub LoadSN()
    Dim i As Integer, tmp As String
    UserName = GetSettingString(HKEY_CURRENT_USER, "SOFTWARE\Cobalt\Login\", "current")
    GetAllKeys HKEY_CURRENT_USER, "SOFTWARE\Cobalt\Login"
    ReDim LoginPasswords(UBound(LoginNames))
    For i = 0 To UBound(LoginNames)
        If LoginNames(i) <> vbNullString Then
            tmp = GetSettingString(HKEY_CURRENT_USER, "SOFTWARE\Cobalt\Login\" & LoginNames(i), "password")
            If tmp <> vbNullString Then LoginPasswords(i) = Unscramble(tmp)
        End If
    Next
End Sub

Private Sub GetServerList()
    Dim Content As String
    Content = inServerList.OpenURL("http://openarc.sourceforge.net/mirrorlist.xml")
    If Len(Content) < 10 Then   'or devenv
        If Not DevEnv Then
            ReDim Servers(0)
            Servers(0).Description = "Default Cobalt Server"
            Servers(0).Host = "cobalt.uplinklabs.net"
            Servers(0).port = 6000
            Servers(0).Status = True
            cmbServers.AddItem Servers(0).Description
        Else
            ReDim Servers(1)
            Servers(0).Description = "Default Cobalt Server"
            Servers(0).Host = "64.113.25.160"
            Servers(0).port = 6000
            Servers(0).Status = True
            Servers(1).Description = "Internal Cobalt Server"
            Servers(1).Host = "127.0.0.1"
            Servers(1).port = 6000
            Servers(1).Status = True
            cmbServers.AddItem Servers(0).Description
            cmbServers.AddItem Servers(1).Description
        End If
        cmbServers.ListIndex = readini("Settings", "ServerIndex", AppPath & "Cobalt.ini", 0)
    Else
        AddServersToList Content, Me.cmbServers
    End If
    ServersLoaded = True
    Unload frmSplash
    Me.Show
End Sub

Private Function DSplit(What As String, Delimeter1 As String, Delimeter2 As String) As String
    On Error GoTo errors
    Dim a
    Dim B
    a = Split(What, Delimeter1)
    B = Split(a(1), Delimeter2)
    DSplit = B(0)
    Exit Function
errors:
    DSplit = vbNullString
End Function


Function GetLineType(Line As String) As Integer
    Dim a
    a = DSplit(Line, "<", ">")
    Select Case LCase$(a)
    Case "?xml version=vbnullstringvbnullstring1.0vbnullstringvbnullstring ?"
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
    If UBound(a) = 0 Then
      a = Split(CobaltXML, vbCr)
    End If
    If UBound(a) = 0 Then
      a = Split(CobaltXML, vbLf)
    End If
    GetLine = a(LineNum)
End Function

Function LineCount(CobaltXML As String) As Integer
    Dim a() As String
    a = Split(CobaltXML, vbCrLf)
    If UBound(a) = 0 Then
      a = Split(CobaltXML, vbCr)
    End If
    If UBound(a) = 0 Then
      a = Split(CobaltXML, vbLf)
    End If
    LineCount = UBound(a)
End Function

Sub AddServersToList(CobaltXML As String, Combo As ComboBox)
    Dim LC As Integer
    Dim i As Long
    Dim LT As Integer
    Dim Line As String
    Dim CurServer As Integer
    Dim Server As String
    Dim port As String
    Dim Desc As String
    Combo.Clear
    If Trim$(Replace(CobaltXML, Chr(13), vbNullString)) = vbNullString Then Exit Sub
    LC = LineCount(CobaltXML)
    frmSplash.LoadCap "Parsing server list..."
    For i = 0 To LC
        LT = GetLineType(GetLine(CobaltXML, CInt(i)))
        Line = GetLine(CobaltXML, CInt(i))
        Select Case LT
        Case 6
            Server = DSplit(Line, "<ip>", "</ip>")
        Case 7
            port = DSplit(Line, "<port>", "</port>")
        Case 8
            Desc = DSplit(Line, "<desc>", "</desc>")
        End Select
        If Server <> vbNullString And port <> vbNullString And Desc <> vbNullString Then
            ReDim Preserve Servers(CurServer)
            Servers(CurServer).Host = Server
            Servers(CurServer).port = port
            frmSplash.LoadCap "Testing servers..."
            Servers(CurServer).Status = TestServer(Server, CInt(port))
            Servers(CurServer).Description = Desc & IIf(Servers(CurServer).Status, "", " (unavailable)")
            Server = vbNullString
            port = vbNullString
            Desc = vbNullString
            CurServer = CurServer + 1
        End If
    Next
    For i = 0 To UBound(Servers)
        Combo.AddItem Servers(i).Description
    Next
    On Error GoTo errord
    Combo.ListIndex = readini("Settings", "ServerIndex", AppPath & "Cobalt.ini", 0)
errord:
    If Err.Number <> 0 Then
        Combo.ListIndex = 0
    End If
End Sub

Function TestServer(Server As String, port As Integer) As Integer
    Testing = True
    sckTest.RemoteHost = Server
    sckTest.RemotePort = port
    sckTest.Connect
    TimeoutTimer.Interval = 6000
    TimeoutTimer.Enable
    Do While Testing
        DoEvents
    Loop
    TestServer = TestingResult
End Function

Private Sub Form_Unload(Cancel As Integer)
    If Me.Visible And Not frmMain.Visible Then
        End
    End If
End Sub

Private Sub sckTest_Close()
    TimeoutTimer.Disable
    sckTest.Close
    TestingResult = False
    Testing = False
End Sub

Private Sub sckTest_Connect()
    TimeoutTimer.Disable
    sckTest.Close
    TestingResult = True
    Testing = False
End Sub

Private Sub sckTest_Error(ByVal Number As Integer, Description As String, ByVal Scode As Long, ByVal Source As String, ByVal HelpFile As String, ByVal HelpContext As Long, CancelDisplay As Boolean)
    TimeoutTimer.Disable
    sckTest.Close
    TestingResult = False
    Testing = False
End Sub

Private Sub TimeoutTimer_Timer()
    TimeoutTimer.Disable
    sckTest.Close
    TestingResult = False
    Testing = False
End Sub
