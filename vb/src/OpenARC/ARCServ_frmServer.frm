VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "mswinsck.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "{33101C00-75C3-11CF-A8A0-444553540000}#1.0#0"; "cswsk32.ocx"
Begin VB.Form frmServer 
   BorderStyle     =   1  'Fixed Single
   ClientHeight    =   2445
   ClientLeft      =   45
   ClientTop       =   735
   ClientWidth     =   4035
   Icon            =   "ARCServ_frmServer.frx":0000
   LinkTopic       =   "frmServer"
   MaxButton       =   0   'False
   ScaleHeight     =   163
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   269
   StartUpPosition =   2  'CenterScreen
   Begin SocketWrenchCtrl.Socket UDPBroadcast 
      Left            =   0
      Top             =   960
      _Version        =   65536
      _ExtentX        =   741
      _ExtentY        =   741
      _StockProps     =   0
      AutoResolve     =   -1  'True
      Backlog         =   5
      Binary          =   -1  'True
      Blocking        =   -1  'True
      Broadcast       =   0   'False
      BufferSize      =   0
      HostAddress     =   ""
      HostFile        =   ""
      HostName        =   ""
      InLine          =   0   'False
      Interval        =   0
      KeepAlive       =   0   'False
      Library         =   ""
      Linger          =   0
      LocalPort       =   0
      LocalService    =   ""
      Protocol        =   0
      RemotePort      =   0
      RemoteService   =   ""
      ReuseAddress    =   0   'False
      Route           =   -1  'True
      Timeout         =   0
      Type            =   1
      Urgent          =   0   'False
   End
   Begin SocketWrenchCtrl.Socket UDPArray 
      Index           =   0
      Left            =   480
      Top             =   480
      _Version        =   65536
      _ExtentX        =   741
      _ExtentY        =   741
      _StockProps     =   0
      AutoResolve     =   -1  'True
      Backlog         =   5
      Binary          =   -1  'True
      Blocking        =   -1  'True
      Broadcast       =   0   'False
      BufferSize      =   0
      HostAddress     =   ""
      HostFile        =   ""
      HostName        =   ""
      InLine          =   0   'False
      Interval        =   0
      KeepAlive       =   0   'False
      Library         =   ""
      Linger          =   0
      LocalPort       =   0
      LocalService    =   ""
      Protocol        =   0
      RemotePort      =   0
      RemoteService   =   ""
      ReuseAddress    =   0   'False
      Route           =   -1  'True
      Timeout         =   0
      Type            =   1
      Urgent          =   0   'False
   End
   Begin SocketWrenchCtrl.Socket UDP 
      Left            =   0
      Top             =   480
      _Version        =   65536
      _ExtentX        =   741
      _ExtentY        =   741
      _StockProps     =   0
      AutoResolve     =   -1  'True
      Backlog         =   5
      Binary          =   -1  'True
      Blocking        =   -1  'True
      Broadcast       =   0   'False
      BufferSize      =   0
      HostAddress     =   ""
      HostFile        =   ""
      HostName        =   ""
      InLine          =   0   'False
      Interval        =   0
      KeepAlive       =   0   'False
      Library         =   ""
      Linger          =   0
      LocalPort       =   0
      LocalService    =   ""
      Protocol        =   0
      RemotePort      =   0
      RemoteService   =   ""
      ReuseAddress    =   0   'False
      Route           =   -1  'True
      Timeout         =   0
      Type            =   1
      Urgent          =   0   'False
   End
   Begin MSWinsockLib.Winsock Socket1 
      Index           =   0
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   1800
      Top             =   1080
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.TextBox txtLog 
      BeginProperty Font 
         Name            =   "Terminal"
         Size            =   6
         Charset         =   255
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   2100
      Left            =   30
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   0
      Top             =   30
      Width           =   3975
   End
   Begin VB.Timer Timer2 
      Enabled         =   0   'False
      Interval        =   1
      Left            =   2760
      Top             =   1440
   End
   Begin VB.Timer Timer1 
      Enabled         =   0   'False
      Interval        =   1
      Left            =   2640
      Top             =   1320
   End
   Begin VB.Timer Timer3 
      Interval        =   5000
      Left            =   2520
      Top             =   1200
   End
   Begin MSWinsockLib.Winsock Socket4 
      Index           =   0
      Left            =   480
      Tag             =   "Ping"
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.Label lblStats 
      AutoSize        =   -1  'True
      Caption         =   "Server is OFFLINE"
      Height          =   195
      Left            =   30
      TabIndex        =   1
      Top             =   2190
      Width           =   1320
   End
   Begin VB.Menu mnuxServer 
      Caption         =   "&Server"
      Begin VB.Menu mnuConfig 
         Caption         =   "&Configuration"
      End
      Begin VB.Menu mnuxS1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuListenIP 
         Caption         =   "&Listening IP"
         Begin VB.Menu mnuIP 
            Caption         =   "<none>"
            Enabled         =   0   'False
            Index           =   0
         End
         Begin VB.Menu mnuIP 
            Caption         =   "<none>"
            Enabled         =   0   'False
            Index           =   1
            Visible         =   0   'False
         End
         Begin VB.Menu mnuIP 
            Caption         =   "<none>"
            Enabled         =   0   'False
            Index           =   2
            Visible         =   0   'False
         End
         Begin VB.Menu mnuIP 
            Caption         =   "<none>"
            Enabled         =   0   'False
            Index           =   3
            Visible         =   0   'False
         End
         Begin VB.Menu mnuIP 
            Caption         =   "<none>"
            Enabled         =   0   'False
            Index           =   4
            Visible         =   0   'False
         End
         Begin VB.Menu mnuIP 
            Caption         =   "<none>"
            Enabled         =   0   'False
            Index           =   5
            Visible         =   0   'False
         End
         Begin VB.Menu mnuIP 
            Caption         =   "<none>"
            Enabled         =   0   'False
            Index           =   6
            Visible         =   0   'False
         End
         Begin VB.Menu mnuIP 
            Caption         =   "<none>"
            Enabled         =   0   'False
            Index           =   7
            Visible         =   0   'False
         End
         Begin VB.Menu mnuIP 
            Caption         =   "<none>"
            Enabled         =   0   'False
            Index           =   8
            Visible         =   0   'False
         End
         Begin VB.Menu mnuIP 
            Caption         =   "<none>"
            Enabled         =   0   'False
            Index           =   9
            Visible         =   0   'False
         End
         Begin VB.Menu mnuIP 
            Caption         =   "<none>"
            Enabled         =   0   'False
            Index           =   10
            Visible         =   0   'False
         End
      End
      Begin VB.Menu mnuxS4 
         Caption         =   "-"
      End
      Begin VB.Menu mnuStart 
         Caption         =   "&Start"
      End
      Begin VB.Menu mnuStop 
         Caption         =   "St&op"
      End
      Begin VB.Menu mnuxS2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuRegister 
         Caption         =   "&Register"
      End
      Begin VB.Menu mnuxS3 
         Caption         =   "-"
      End
      Begin VB.Menu mnuExit 
         Caption         =   "E&xit"
      End
   End
   Begin VB.Menu mnuxHlp 
      Caption         =   "&Help"
      Begin VB.Menu mnuAbout 
         Caption         =   "&About"
      End
   End
End
Attribute VB_Name = "frmServer"
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
Option Compare Text
Dim j As Long

Private Sub mnuConfig_Click()
    frmConfig.Show 1
End Sub

Private Sub mnuAbout_Click()
    frmAbout.Show 1
End Sub

Private Sub mnuExit_Click()
    Socket1(0).Close
    Socket4(0).Close
    UDPBroadcast.Disconnect
    UDPBroadcast.Cleanup
    UDP.Cleanup
    Shell_NotifyIcon NIM_DELETE, sysIcon
    End
End Sub

Private Sub mnuIP_Click(Index As Integer)
    Dim i As Long
    For i = 0 To mnuIP.UBound
        mnuIP(i).Checked = False
    Next
    mnuIP(Index).Checked = True
End Sub

Private Sub mnuStart_Click()
    If LenB(Dir(Filename)) = 0 Or LenB(Filename) = 0 Then MsgBox "Please select a map or load a configuration file with a preselected map.", vbExclamation, App.Title: Exit Sub
    ReDim Preserve PlayerDat(0)
    Erase Collision
    DimEm
    DoEvents
    txtLog.SelStart = Len(txtLog)
    txtLog.SelText = vbNewLine & "Loading " & MapPlay & " into memory..."
    LoadMap
    txtLog.SelStart = Len(txtLog)
    txtLog.SelText = vbNewLine & "Initialising Sockets..."
    If Not InitSocket Then Exit Sub
    mnuConfig.Enabled = False
    mnuStart.Enabled = False
    mnuStop.Enabled = True
    Stopping = False
    HighestScore = 0
    HighestScoreWho = 0
    txtLog.SelStart = Len(txtLog)
    txtLog.SelText = vbNewLine & "Preparing Game..."
    ResetFlags 6, 0
    Timer1.Enabled = True
    If Not LANBuild And Not PeerBuild Then
        frmRegister.Show 1
        frmRegister.cmdRegister.Enabled = True
        frmRegister.cmdUnregister.Enabled = False
    End If
    TimeClock = NewGTC
    txtLog.SelText = vbNewLine & "Server ready!"
End Sub

Public Function IsLocalIP(IP As String) As Boolean
    Dim SplitIP() As String
    SplitIP = Split(IP, ".")
    If SplitIP(0) = 10 Then IsLocalIP = True: Exit Function
    If SplitIP(0) = 172 Then
        If SplitIP(1) > 15 And SplitIP(1) < 32 Then IsLocalIP = True: Exit Function
    End If
    If SplitIP(0) = 127 Then IsLocalIP = True: Exit Function
    If SplitIP(0) = 192 Then
        If SplitIP(1) = 168 Then IsLocalIP = True: Exit Function
    End If
End Function

Public Function GetBroadcast(IP As String, subnet As String) As String
    Dim a() As String
    Dim b() As String
    Dim i As Long
    Dim C As String
    a = Split(IP, ".")
    b = Split(subnet, ".")
    'get net id
    C = CInt(CInt(a(0)) And CInt(b(0))) & "." & CInt(CInt(a(1)) And CInt(b(1))) & "." & CInt(CInt(a(2)) And CInt(b(2))) & "." & CInt(CInt(a(3)) And CInt(b(3)))
    a = Split(C, ".")
    For i = 0 To 3
        b(i) = 255 - b(i)
    Next
    'get broadcast
    C = CInt(CInt(a(0)) Or CInt(b(0))) & "." & CInt(CInt(a(1)) Or CInt(b(1))) & "." & CInt(CInt(a(2)) Or CInt(b(2))) & "." & CInt(CInt(a(3)) Or CInt(b(3)))
    GetBroadcast = C
End Function

Function InitSocket() As Boolean
    Dim i As Long
    On Error GoTo errored
    
    'TCP 22000
    txtLog.SelText = vbNewLine & "TCP " & Port & "..."
    If LANBuild Then
        For i = 0 To mnuIP.UBound
            If mnuIP(i).Checked = True Then
                BroadcastIP = GetBroadcast(mnuIP(i).Caption, ConvertAddressToString(IP_Addr(i).dwMask))
                Exit For
            ElseIf i = 4 Then
                MsgBox "You need to select a listening IP from the menu first!", vbCritical, ProjectName
                Err.Raise vbObjectError, vbNull, "Couldn't find listening IP!"
            End If
        Next
    End If
    Socket1(0).Protocol = sckTCPProtocol
    Socket1(0).LocalPort = Port
    Socket1(0).Listen
    txtLog.SelText = vbNewLine & "Success."
    
    'TCP 22100
    txtLog.SelText = vbNewLine & "TCP " & Port2 & "..."
    Socket4(0).LocalPort = Port2
    Socket4(0).Close
    Socket4(0).Listen
    txtLog.SelText = vbNewLine & "Success."
    
    'UDP 22000
    txtLog.SelText = vbNewLine & "UDP " & Port & "..."
    UDP.AddressFamily = AF_INET
    UDP.Binary = True
    UDP.Blocking = False
    UDP.Protocol = IPPROTO_IP
    UDP.SocketType = SOCK_DGRAM
    UDP.LocalPort = Port
    UDP.Action = SOCKET_OPEN
    UDP.TraceFile = AppPath & "Errors.txt"
    UDP.TraceFlags = 1
    txtLog.SelText = vbNewLine & "Success."
    
    If LANBuild And BroadcastIP <> "" Then
        txtLog.SelText = vbNewLine & "UDP broadcast (" & BroadcastIP & ")..."
        UDPBroadcast.AddressFamily = AF_INET
        UDPBroadcast.Binary = True
        UDPBroadcast.Blocking = False
        UDPBroadcast.Protocol = IPPROTO_IP
        UDPBroadcast.SocketType = SOCK_DGRAM
        UDPBroadcast.HostAddress = BroadcastIP
        UDPBroadcast.RemotePort = Port3
        UDPBroadcast.Broadcast = True
        UDPBroadcast.Action = SOCKET_OPEN
        txtLog.SelText = vbNewLine & "Success."
    End If
    
    InitKeys
    If Encrypted Then Set Encryption = New clsEncryption
    
    InitSocket = True
    Exit Function
errored:
    txtLog.SelText = vbNewLine & "Failed (" & Err.Description & ")"
    UDP.Cleanup
    UDPBroadcast.Disconnect
    UDPBroadcast.Cleanup
    Socket1(0).Close
    Socket4(0).Close
End Function

Private Sub mnuStop_Click()
    If Not LANBuild And Not PeerBuild Then
        frmRegister.Timer1.Enabled = False
        frmRegister.cmdUnregister_Click
    End If
    Stopping = True
End Sub

Public Sub SetMap()
    Erase Collision
    LoadMap
    If LenB(MapPlay) = 0 Then
        MapPlay = vbNullString
        Me.Caption = App.Title & " v" & App.Major & "." & App.Minor & "." & Format$(App.Revision, "0000") & " - invalid map!"
        Exit Sub
    End If
    Erase TeamScores
    ResetFlags 6, 0
    Me.Caption = App.Title & " v" & App.Major & "." & App.Minor & "." & Format$(App.Revision, "0000") & " - " & MapPlay
End Sub

Private Sub mnuRegister_Click()
    frmRegister.Show 1
End Sub

Private Sub Form_Activate()
    txtLog.SelStart = Len(txtLog)
    Aver = 1
    gAllID = -1
End Sub

Private Sub CalcBroadcast()
    Dim i As Long
    EnumerateIPs
    For i = 0 To UBound(IP_Addr)
        mnuIP(i).Caption = ConvertAddressToString(IP_Addr(i).dwAddr)
        mnuIP(i).Enabled = True
        mnuIP(i).Visible = True
    Next
    For i = 0 To mnuIP.UBound
        If StringComp(mnuIP(i).Caption, "0.0.0.0") Or StringComp(mnuIP(i).Caption, "127.0.0.1") Then
            mnuIP(i).Enabled = False
            mnuIP(i).Visible = False
        End If
    Next
End Sub


Private Sub Form_Load()
    Dim TmpMainText As String
    Me.Caption = ProjectName & " Game Server v" & App.Major & "." & Format$(App.Minor, "00") & "." & Format$(App.Revision, "0000")
    LDamage(0) = 3
    LDamage(1) = 5
    LDamage(2) = 7
    LDamage(3) = 14
    LDamage(4) = 18
    LDamage2(0) = 3
    LDamage2(1) = 7
    LDamage2(2) = 12
    LDamage2(3) = 15
    LDamage2(4) = 20
    SDamage(0) = 8
    SDamage(1) = 13
    SDamage(2) = 16
    SDamage(3) = 35
    SDamage(4) = 45
    SDamage2(0) = 2.25 '9
    SDamage2(1) = 3.25 '13
    SDamage2(2) = 4.25 '17
    SDamage2(3) = 7 '28
    SDamage2(4) = 9.25 '39
    TmpMainText = App.CompanyName & vbCrLf
    TmpMainText = TmpMainText & ProjectName & " Game Server v" & App.Major & "." & App.Minor & "." & Format$(App.Revision, "0000")
    If LANBuild Or PeerBuild Then mnuRegister.Enabled = False
    If LANBuild Then CalcBroadcast
    If Not LANBuild Or PeerBuild Then
        mnuListenIP.Visible = False
        mnuxS4.Visible = False
    End If
    If GetSettingLong(HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "DebugLog", 0) = 1 Then
        bDebugLog = 1
    End If
    If LANBuild Or PeerBuild Or AdminBuild Or DebugBuild Then TmpMainText = TmpMainText & vbCrLf & "--------------------------------------"
    If LANBuild Then TmpMainText = TmpMainText & vbCrLf & "LAN Build. For internal use only."
    If PeerBuild Then TmpMainText = TmpMainText & vbCrLf & "P2P Build. For testing purposes only."
    If AdminBuild Then TmpMainText = TmpMainText & vbCrLf & "Admin Build. For internal use only."
    If DebugBuild Then TmpMainText = TmpMainText & vbCrLf & "Debug Build. For testing purposes only."
    If bDebugLog = 1 Then TmpMainText = TmpMainText & vbCrLf & "Debug packet logging enabled."
    TmpMainText = TmpMainText & vbCrLf & "--------------------------------------"
    txtLog.Text = TmpMainText
    SetMyPriority ABOVE_NORMAL_PRIORITY_CLASS
    Dim b As Byte
    ReDim PlayerDat(0), BufferSpace(128)
    PlayerDat(0).Nick = "Joseph Stalin" 'For /coldwar. It's fun, try it.
    PlayerDat(0).Ship = 5
    For b = 0 To 128
        ReDim BufferSpace(b).Data(0)
    Next
    ReDim AdminList(0)
    Closed = True
    Serial_Number = GetDriveInfo("c:\", 1)
    SpeedMiss(0) = 0.247
    SpeedMiss(1) = 0.512
    SpeedMiss(2) = 1
    SpeedMiss(3) = 1.9
    SpeedMiss(4) = 3
    SpeedMort(0) = 0.247
    SpeedMort(1) = 0.247
    SpeedMort(2) = 0.5
    SpeedMort(3) = 1.312
    SpeedMort(4) = 1.9
    SpeedBoun(0) = 0.247
    SpeedBoun(1) = 0.75
    SpeedBoun(2) = 1.312
    SpeedBoun(3) = 2.1
    SpeedBoun(4) = 4.2
    PSpeed = 130
    PBuffer = 3
    Port = 22000
    Port2 = 22100
    With sysIcon
        .cbSize = LenB(sysIcon)
        .hwnd = Me.hwnd
        .uFlags = NIF_DOALL
        .uCallbackMessage = WM_MOUSEMOVE
        .hIcon = Me.Icon
        .sTip = ProjectName & " Game Server" & vbNullChar
    End With
    Shell_NotifyIcon NIM_ADD, sysIcon
    If Command$ <> vbNullString Then
        Me.Show
        Me.Refresh
        Load frmConfig
        frmConfig.Visible = False
        frmConfig.LoadConfig Command$
        Unload frmConfig
    End If
End Sub

Private Sub Form_MouseMove(Button As Integer, Shift As Integer, X As Single, y As Single)
    Dim ShellMsg As Long
    
    ShellMsg = X / 11
    Select Case X
    Case WM_LBUTTONDBLCLK
        If frmConfig.Visible = False Then
            Me.WindowState = vbNormal
            Me.Show
        End If
        DoEvents
        txtLog.SelStart = Len(txtLog)
    End Select
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    Shell_NotifyIcon NIM_DELETE, sysIcon
End Sub

Private Sub Form_Resize()
    If Me.WindowState = vbMinimized Then Me.Hide: Exit Sub
End Sub

Private Sub Form_Unload(Cancel As Integer)
    End
End Sub

Private Sub PrintByteArray(bArray() As Byte)
    Dim a As String
    Dim i As Long
    For i = 0 To UBound(bArray)
        a = a & " " & CInt(bArray(i))
    Next
    DebugLog a
End Sub

Private Sub Socket1_Close(Index As Integer)
    Dim i As Integer
    i = Index
    If i = 0 Then Exit Sub
    If i <= UBound(PlayerDat) Then
        PlayerDat(i).die = True
    End If
    Socket1(i).Close
End Sub

Private Sub Socket1_ConnectionRequest(Index As Integer, ByVal requestID As Long)
    Dim i As Integer, j As Integer
    'On Error Resume Next
    For i = 1 To Socket1.UBound
        If Not Socket1(i).State = 7 Then Exit For
    Next i
    If i > 64 Then Exit Sub
    If i > Socket1.UBound Then
        Load Socket1(i)
        Load UDPArray(i)
    End If
    
    Socket1(i).Close
    Socket1(i).Protocol = sckTCPProtocol
    Socket1(i).Accept requestID
    
    
    frmServer.txtLog.SelStart = Len(frmServer.txtLog)
    frmServer.txtLog.SelText = vbNewLine & Socket1(i).RemoteHostIP & " connected."
    
    UDPArray(i).Disconnect
    UDPArray(i).AutoResolve = False
    UDPArray(i).AddressFamily = AF_INET
    UDPArray(i).Binary = True
    UDPArray(i).Blocking = False
    UDPArray(i).Protocol = IPPROTO_IP
    UDPArray(i).SocketType = SOCK_DGRAM
    UDPArray(i).HostName = Socket1(i).RemoteHostIP
    UDPArray(i).RemotePort = Port3
    UDPArray(i).Action = SOCKET_OPEN
End Sub

Private Sub Socket1_DataArrival(Index As Integer, ByVal bytesTotal As Long)
    Dim Data() As Byte, NewData() As Byte, TempLen As Integer, DL As Integer, MaxLength As Integer, timeLimit As Long
    Do While True
    
        'Reset some variables for the loop
        TempLen = 0
        MaxLength = 0
        ReDim NewData(0)
        ReDim Data(0)
        
        timeLimit = NewGTC + 5000
        Socket1(Index).GetData MaxLength, vbInteger, LenB(MaxLength)
        If MaxLength = 0 Then Exit Do
        If MaxLength < 1 Or MaxLength > 16384 Then
            'If bDebugLog = 1 Then DebugLog "Invalid packet size. Dropped and client ejected."
            Socket1(Index).Close
        End If
        ReDim Data(MaxLength + 1)
        Do Until TempLen >= MaxLength
            Socket1(Index).GetData NewData, vbByte Or vbArray, MaxLength
            If UBound(NewData) < 1 Then
                DoEvents
                If NewGTC > timeLimit Then
                    'If bDebugLog = 1 Then DebugLog "Took too long for data to arrive. Bugging out."
                    Socket1(Index).Close
                    Exit Sub
                End If
                GoTo continue
            End If
            If UBound(NewData) + 1 + TempLen > UBound(Data) Then
                'If bDebugLog = 1 Then DebugLog "LARGE PACKET, POSSIBLE FLOOD ATTACK!"
                Exit Sub
            End If
            CopyMemory Data(TempLen), NewData(0), UBound(NewData) + 1
            TempLen = TempLen + UBound(NewData) + 1
            ReDim NewData(0)
continue:
        Loop
        If TempLen > 1 Then
            If Data(TempLen - 1) = 3 Then
                'If bDebugLog = 1 Then DebugLog Data(0) & " " & NewGTC & " IN TCP :) (" & TempLen & " bytes)"
                DataProcess Data, TempLen - 1, CByte(Index)
            'Else
                'If bDebugLog = 1 Then DebugLog Data(0) & " " & NewGTC & " IN TCP :( ErrorMark 201"
            End If
        End If
    Loop
End Sub

Private Sub Socket1_Error(Index As Integer, ByVal Number As Integer, Description As String, ByVal Scode As Long, ByVal Source As String, ByVal HelpFile As String, ByVal HelpContext As Long, CancelDisplay As Boolean)
    Dim i As Integer
    i = Index
    If i = 0 Then Exit Sub
    If i <= UBound(PlayerDat) Then
        PlayerDat(i).die = True
    End If
    Socket1(i).Close
End Sub

Private Sub Socket4_ConnectionRequest(Index As Integer, ByVal requestID As Long)
    Dim i As Integer
    On Error Resume Next
    If IsBanned("!", Socket4(Index).RemoteHostIP) Then
        Exit Sub
    End If
    For i = 1 To Socket4.UBound
        If Not Socket4(i).State = 7 Then Exit For
    Next i
    If i > 64 Then Exit Sub
    If i > Socket4.UBound Then
        Load Socket4(i)
    End If
    Socket4(i).Close
    Socket4(i).Accept requestID
End Sub

Private Sub Socket4_DataArrival(Index As Integer, ByVal bytesTotal As Long)
    Socket4(Index).Close
End Sub

Private Sub Timer3_Timer()
    Dim tmp As String
    If Socket4(0).State <> 2 Then Exit Sub
    tmp = "Server is ONLINE, Players: " & fPlayerCount
    If lblStats.Caption <> tmp Then lblStats.Caption = tmp
End Sub

Private Sub UDP_Read(DataLength As Integer, IsUrgent As Integer)
    Dim i As Long, NewData() As Byte, b As Byte, DL As Integer
    Dim timeLimit As Long, TempLen As Integer, MaxLength As Integer
    Dim tmpAddress As String, lNewMsg As Byte, lNewOffSet As Long, oNewMsg() As Byte
    
    UDPSocket = NewGTC
    timeLimit = NewGTC + 2000
    
    If DataLength < 1 Or DataLength > 16384 Then
        If bDebugLog = 1 Then DebugLog "UDP: Invalid received size. Dropped."
    End If
    
    ReDim NewData(DataLength)
    
    DL = UDP.ReadBytes(NewData(), UBound(NewData) + 1)
    If DL = -1 Then Exit Sub
    
    CopyMemory ByVal VarPtr(MaxLength), NewData(0), LenB(MaxLength)
    
    If MaxLength < 1 Or MaxLength > 16384 Then
        If bDebugLog = 1 Then DebugLog "UDP: Invalid packet size. Dropped."
    End If
    
    CopyMemory NewData(0), NewData(2), UBound(NewData) - (LenB(MaxLength) - 1)
    
    ReDim Preserve NewData(UBound(NewData) - LenB(MaxLength))
    
    DL = DL - LenB(MaxLength)
    
    tmpAddress = UDP.PeerAddress
    For b = 1 To Socket1.UBound 'Loop through all sockets
        If Socket1(b).State = 7 Then 'Connected?
            If Socket1(b).RemoteHostIP = tmpAddress Then i = i + 1 'match found
        End If
    Next
    If i > 1 Then
        lNewMsg = MSG_UDPSTOP
        lNewOffSet = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
        For b = 1 To Socket1.UBound
            If Socket1(b).State = 7 Then
                If UBound(PlayerDat) < b Then
                    Socket1(b).Close
                    Exit For
                End If
                If Socket1(b).RemoteHostIP = tmpAddress And PlayerDat(b).UDPOK = True Then
                    PlayerDat(b).UDPOK = False
                    SendTo oNewMsg, CInt(b)
                End If
            End If
        Next
    End If
    If DL > 0 Then
        For b = 1 To Socket1.UBound
            If Socket1(b).RemoteHostIP = UDP.PeerAddress Then Exit For
        Next
        If b > Socket1.UBound Then Exit Sub
        If NewData(DL - 1) = 3 Then
            'If bDebugLog = 1 Then DebugLog NewData(0) & " " & NewGTC & " IN UDP :)"
            DataProcess NewData, DL - 1, b
        Else
            If bDebugLog = 1 Then DebugLog NewData(0) & " " & NewGTC & " IN UDP :( NewData(DL - 1) = " & CInt(NewData(DL - 1))
        End If
    Else
        'If bDebugLog = 1 Then DebugLog NewData(0) & " " & NewGTC & " IN UDP :( DL <= 1"
    End If
    'nexttry:
    'Loop
End Sub

Private Sub Socket4_Close(Index As Integer)
    Dim i As Integer, L As Long
    Dim lMsg As Byte, lOffset As Long
    Dim oNewMsg() As Byte, lNewOffSet As Long
    Dim lNewMsg As Byte
    On Error Resume Next
    If Index = 0 Then Exit Sub
    Socket4(Index).Close
End Sub


Private Sub txtLog_Change()
    If Len(txtLog) > 60000 Then
        txtLog = Mid$(txtLog, 10000)
    End If
    txtLog.SelStart = Len(txtLog)
End Sub

Private Sub Timer1_Timer()
    Timer1.Enabled = False
    If Not LANBuild And Not PeerBuild Then
        txtLog.SelStart = Len(txtLog)
        txtLog.SelText = vbNewLine & "Server started." & vbCrLf & "Please register with Cobalt."
    End If
    j = -1
    Timer2.Enabled = True
    lblStats.Caption = "Server is ONLINE, Players: 0"
End Sub

Sub ReadSock()
    Dim i As Long, Data() As Byte, DataLength As Integer
    On Error Resume Next
    If NewGTC - UDPSocket > 5000 Then
        UDPSocket = NewGTC
        UDP.Cleanup
        UDP.AddressFamily = AF_INET
        UDP.Binary = True
        UDP.Blocking = False
        UDP.Protocol = IPPROTO_IP
        UDP.SocketType = SOCK_DGRAM
        UDP.LocalPort = Port
        UDP.Action = SOCKET_OPEN
    End If
End Sub

Private Sub Timer2_Timer()
    Dim i As Integer, j As Integer, X As Integer
    Static LoginTick As Long
    
    ReadSock
    MoveLoop
    
    If Stopping Then
        Timer2.Enabled = False
        mlConnectAsync = 0
        For i = 0 To Socket1.UBound
            Socket1(i).Close
        Next
        For i = 0 To Socket4.UBound
            Socket4(i).Close
        Next
        UDP.Cleanup
        UDPBroadcast.Disconnect
        UDPBroadcast.Cleanup
        frmServer.lblStats.Caption = "Server is OFFLINE"
        If Not LANBuild And Not PeerBuild Then frmRegister.Socket1.Close
        mnuConfig.Enabled = True
        mnuStart.Enabled = True
        mnuStop.Enabled = False
        txtLog.SelStart = Len(txtLog)
        If Not LANBuild And Not PeerBuild Then txtLog.SelText = vbNewLine & "Server unregistered." Else txtLog.SelText = vbNewLine & "Server stopped."
    End If
End Sub

Sub ChatCommands(cmd As String, ByVal Admin As Byte, ByVal Who As Byte)
    Dim aParm As String, bParm As String, cParm As String, newCmd As String, j As Integer
    Dim i As Integer, b As Byte, L As Long, tmp As String, b2 As Byte
    Dim oNewMsg() As Byte, lNewOffSet As Long
    Dim lNewMsg As Byte
    Dim X() As String
    X = Split(LCase$(cmd), " ")
    If Len(cmd) > 0 Then
        aParm = X(0)
        If UBound(X) > 0 Then
            bParm = X(1)
            If UBound(X) > 1 Then
                newCmd = Mid$(cmd, Len(X(0)) + Len(X(1)) + 3, Len(cmd) - (Len(X(0)) + Len(X(1)) + 2))
            End If
        End If
    Else
        aParm = cmd
    End If
    
    'If aParm = "die" And PlayerDat(Who).Mode <> 1 Then
    '    I = GetPN2(bParm)
    '    If I = 0 Then
    '        PlayerDied Who, Who
    '    End If
    'End If
    
    If Admin > 0 Then 'ADMINISTRATIVE COMMANDS------------------------------------------------------------------------+
        
        If StringComp(aParm, "ai") And Admin = 5 Then
            i = GetPN2(bParm)
            If i > UBound(PlayerDat) Then ReDim Preserve PlayerDat(i)
            If i = 0 Then Exit Sub
            If PlayerDat(i).AI Then
                PlayerDat(i).AI = False
            Else
                PlayerDat(i).AI = True
            End If
        End If
        
        If StringComp(aParm, "motd") Then
            g_MOTD = Mid$(cmd, InStr(1, cmd, " ") + 1, Len(cmd) - InStr(1, cmd, " "))
            sendmsg MSG_GAMECHAT, Chr(5) & "Message of the Day set.", CInt(Who)
        End If
        
        If StringComp(aParm, "killai") And 0 Then
            For i = 1 To UBound(PlayerDat)
                PlayerDat(i).AI = False
            Next
        End If
        
        If StringComp(aParm, "mute") Then
            i = GetPN2(bParm)
            If i = 0 Then Exit Sub
            If PlayerDat(i).gagged Then
                PlayerDat(i).gagged = False
                sendmsg MSG_GAMECHAT, Chr(5) & PlayerDat(i).Nick & " is unmuted.", CInt(Who)
            Else
                PlayerDat(i).gagged = True
                sendmsg MSG_GAMECHAT, Chr(5) & PlayerDat(i).Nick & " is muted.", CInt(Who)
            End If
        End If
        
        If StringComp(aParm, "unmute") Then
            i = GetPN2(bParm)
            If i = 0 Then Exit Sub
            PlayerDat(i).gagged = False
            sendmsg MSG_GAMECHAT, Chr(5) & PlayerDat(i).Nick & " is unmuted.", CInt(Who)
        End If
        
        If (StringComp(aParm, "kick") Or StringComp(aParm, "boot")) And Admin > 1 Then
            If bParm <> "" Then
                If newCmd <> "" Then
                    Kick bParm, newCmd
                Else
                    Kick bParm, "Booted by game admin!"
                End If
            End If
        End If
        
        If StringComp(aParm, "die") And Admin = 5 And 0 Then
            i = GetPN2(bParm)
            If i = 0 Then i = Who
            PlayerDied CByte(i), Who
        End If
        
        If StringComp(aParm, "killteam") And Admin = 5 And 0 Then
            j = Choose2(bParm)
            For i = 1 To UBound(PlayerDat)
                If PlayerDat(i).Ship = j Then
                    PlayerDied CInt(i), Who
                End If
            Next
        End If
        
        If StringComp(aParm, "coldwar") And Admin > 3 Then 'Great fun
            b = GetPN2(bParm)
            For i = 1 To UBound(PlayerDat)
                PlayerDied CInt(i), b, -1, -1, False
            Next
        End If
        
        If StringComp(aParm, "ban") And Admin > 1 Then
            i = GetPN2(bParm)
            If i > 0 Then
                tmp = Socket1(i).RemoteHostIP
                Kick bParm, "Banned by game admin!"
            End If
            sendmsg MSG_GAMECHAT, Chr(5) & Ban(bParm, tmp), CInt(Who)
        End If
        
        If StringComp(aParm, "code") Then
            i = GetPN2(bParm)
            If i = 0 Then Exit Sub
            If Not IsNumeric(newCmd) Then Exit Sub
            PlayerDat(i).DevCheat = CByte(newCmd)
            lNewMsg = MSG_DEVCHEAT
            lNewOffSet = 0
            ReDim oNewMsg(0)
            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
            If Not IsNumeric(newCmd) Then Exit Sub
            If CInt(newCmd) > 255 Then newCmd = 255
            If CInt(newCmd) < 0 Then newCmd = 0
            b = i
            AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
            b = CByte(newCmd)
            AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
            SendTo oNewMsg, -1, True
            sendmsg MSG_GAMECHAT, Chr(5) & "Cheat mode for " & PlayerDat(i).Nick & " is set to " & CStr(newCmd), CInt(Who)
        End If
        
        If StringComp(aParm, "bans") And Admin > 1 Then
            For i = 1 To UBound(Bans)
                If Len(Bans(i).Name) <> 0 Then
                    sendmsg MSG_GAMECHAT, Chr(5) & Bans(i).Name & " is banned.", CInt(Who)
                End If
            Next
        End If
        
        If StringComp(aParm, "clearbans") And Admin > 1 Then
            ReDim Bans(0)
            sendmsg MSG_GAMECHAT, Chr(5) & " bans cleared.", CInt(Who)
        End If
        
        If StringComp(aParm, "playpass") And Admin > 1 Then
            g_Password = bParm
            For i = 1 To UBound(PlayerDat)
                If PlayerDat(i).Ship > 0 Then
                    If Len(bParm) < 16 Then
                        If PlayerDat(i).Admin > 0 Then Call sendmsg(MSG_GAMECHAT, Chr(5) & "playpass changed to: " & Chr(2) & bParm, i)
                    Else
                        Call sendmsg(MSG_GAMECHAT, Chr(5) & "playpass is too long. no more then 15 character.", i)
                        Exit Sub
                    End If
                End If
            Next
            If LenB(g_Password) = 0 Then b = 0 Else b = 1
            lNewMsg = SVR_PASSWORDPROTECTED
            lNewOffSet = 0
            ReDim oNewMsg(0)
            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
            AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
            If LenB(g_Password) = 0 Then tmp = Chr(0) Else tmp = g_Password
            AddBufferString oNewMsg, tmp, lNewOffSet
            SendTo2 oNewMsg, 0
        End If
        
        If StringComp(aParm, "reset") Then
            sendmsg MSG_GAMECHAT, Chr(5) & "Game reset by " & PlayerDat(Who).Nick, -1
            GoSub ResetGAME
        End If
        
        If StringComp(aParm, "lock") And Not g_Locked Then
            sendmsg MSG_GAMECHAT, Chr(5) & "Game locked by " & PlayerDat(Who).Nick, -1
            g_Locked = True
            GoSub LockGAME
        End If
        
        If StringComp(aParm, "unlock") And g_Locked Then
            sendmsg MSG_GAMECHAT, Chr(5) & "Game unlocked by " & PlayerDat(Who).Nick, -1
            g_Locked = False
        End If
        
        If StringComp(aParm, "bot") And Admin = 5 And 0 Then
            If LenB(bParm) = 0 Then Exit Sub
            If Not IsNumeric(newCmd) Then Exit Sub
            If CByte(newCmd) > 200 Or CByte(newCmd) < 0 Then Exit Sub
            b = CByte(newCmd)
            If b < 0 Or b > 5 Then Exit Sub
            LoadBot bParm, b
        End If
        
        If StringComp(aParm, "sync") Then
            If Not IsNumeric(bParm) Then Exit Sub
            i = CInt(bParm)
            If i < 10 Then sendmsg MSG_GAMECHAT, Chr(5) & "Game sync too low of a value.", CInt(Who): Exit Sub
            PSpeed = i
            lNewMsg = MSG_PSPEED
            lNewOffSet = 0
            ReDim oNewMsg(0)
            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
            AddBufferData oNewMsg, VarPtr(PSpeed), LenB(PSpeed), lNewOffSet
            SendTo oNewMsg, -1
            sendmsg MSG_GAMECHAT, Chr(5) & "Game sync set to " & PSpeed & "ms.", CInt(Who)
        End If
        
        If StringComp(aParm, "buffer") Or StringComp(aParm, "buffers") Then
            If Not IsNumeric(bParm) Then Exit Sub
            i = Val(bParm)
            PBuffer = i
            lNewMsg = MSG_PSPEED
            lNewOffSet = 0
            ReDim oNewMsg(0)
            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
            AddBufferData oNewMsg, VarPtr(PSpeed), LenB(PSpeed), lNewOffSet
            SendTo oNewMsg, -1
            sendmsg MSG_GAMECHAT, Chr(5) & "Buffers set to " & PBuffer, CInt(Who)
        End If
        
        If StringComp(aParm, "obs") Then
            Dim Ship As Byte
            Dim Nick As String
            If bParm <> "" Then
                i = GetPN2(bParm)
            Else
                i = Who
            End If
            Ship = PlayerDat(i).Ship
            Nick = PlayerDat(i).Nick
            If PlayerDat(i).Flag > 0 Then
                DropFlag CByte(i)
                PlayerDat(i).Flagging = False
                sendmsg MSG_GAMECHAT, Chr(5) & "Observation mode has forced you to drop your flag.", i
            End If
            If PlayerDat(i).Mode = 0 Then
                PlayerDat(i).Mode = 1
            Else
                PlayerDat(i).Mode = 0
            End If
            lNewMsg = MSG_MODE
            lNewOffSet = 0
            ReDim oNewMsg(0)
            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
            b = i
            AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
            b = PlayerDat(i).Mode
            AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
            SendTo oNewMsg, -1
            PlayerDat(i).Score = 0
            PlayerDat(i).Key = 9
            lNewMsg = MSG_PLAYERSCORE
            lNewOffSet = 0
            ReDim oNewMsg(0)
            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
            b = i
            AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
            j = 0
            AddBufferData oNewMsg, VarPtr(j), LenB(j), lNewOffSet
            SendTo oNewMsg, -2
            If PlayerDat(i).Mode = 0 Then
                PlayerDat(i).Ship = 4
                b2 = AutoTeam(CByte(i))
                If g_DeathMatch = 1 Then GoTo skip
                lNewMsg = MSG_TEAM
                lNewOffSet = 0
                ReDim oNewMsg(0)
                AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
                b = i
                AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                AddBufferData oNewMsg, VarPtr(b2), LenB(b2), lNewOffSet
                PlayerDat(i).Ship = b2
                SendTo oNewMsg, -2
                DropFlag CByte(i)
                PlayerDat(i).Flagging = False
skip:
                PlayerDat(i).inpenTrig = NewGTC
                tmp = Choose(b2, "green", "red", "blue", "yellow", "not-a-team")
                sendmsg MSG_GAMECHAT, Chr(5) & PlayerDat(i).Nick & " has left observation mode and has joined the " & Chr(PlayerDat(i).Ship) & tmp & Chr(5) & " team.", -1
            Else
                PlayerDat(i).Ship = 5
                sendmsg MSG_GAMECHAT, Chr(Ship) & Nick & Chr(5) & " has entered observation mode.", -2
            End If
        End If
    End If
    Exit Sub
ResetGAME:
    NewGame
    Return
LockGAME:
    For b = 1 To UBound(PlayerDat)
        If PlayerDat(b).Ship > 0 Then
            PlayerDat(b).Score = 0
            DropFlag b
            HoldingArea b
        End If
    Next
    lNewMsg = MSG_PLAYERHOME
    lNewOffSet = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
    j = 5
    AddBufferData oNewMsg, VarPtr(j), LenB(j), lNewOffSet
    SendTo oNewMsg, -1
    SWEnable = NewGTC
    Return
End Sub

Function DataProcess(ReceivedData() As Byte, ReceivedLen As Integer, pID As Byte) As Integer
    Dim tmp As String, Tmp2 As String, FromPlayerName As String
    Dim MsgSize As Long, msg As String
    Dim MsgType As Long, L As Long, L2 As Long
    Dim strPlayer As String
    Dim ChatTxt1 As String, ChatTxt2 As String, ChatTxt3 As String
    Dim MsgCount As Long, I2 As Integer
    Dim MsgData() As Byte, b As Byte, b2 As Byte, b3 As Byte
    Dim X As Integer, t1 As Integer, T2 As Integer, T3 As Integer, T4 As Integer
    Dim j As Integer, d As Integer, e As Integer
    Dim lMsg As Byte, lOffset As Long
    Dim oNewMsg() As Byte, lNewOffSet As Long
    Dim lNewMsg As Byte
    Dim sChatMsg As String, sFromMsg As String
    If Not pID > UBound(PlayerDat) Then If PlayerDat(pID).Ship > 0 Then FromPlayerName = PlayerDat(pID).Nick
nextpacket:
    'lOffset = lOffset + 2 'skip the size info for now
    GetBufferData ReceivedData, VarPtr(lMsg), LenB(lMsg), lOffset
    If lMsg <> MSG_LOGIN And pID > UBound(PlayerDat) Then GoTo skipdone
    Select Case lMsg
    Case 0
        GoTo done
    Case MSG_LOGIN
        GetBufferData ReceivedData, VarPtr(j), LenB(j), lOffset
        GetBufferData ReceivedData, VarPtr(L), LenB(L), lOffset
        Tmp2 = GetBufferString(ReceivedData, lOffset)
        FromPlayerName = GetBufferString(ReceivedData, lOffset)
        If StringComp(Tmp2, "XDecryptFailure") Or StringComp(FromPlayerName, "XDecryptFailure") Then
            tmp = "XDecryptFailure"
        End If
        If Not ConnectionOK And Not LANBuild And Not PeerBuild Then tmp = "Access denied; Cobalt inaccessible."
        If j < ClientVersion Then tmp = "Your version of OpenARC is outdated. Update at http://openarc.sourceforge.net!"
        If LCase(Tmp2) <> LCase(g_Password) And g_Password <> vbNullString Then tmp = "Invalid password."
        I2 = 0
        If LenB(tmp) = 0 Then
            For X = 1 To UBound(PlayerDat)
                If LCase(PlayerDat(X).Nick) = LCase(FromPlayerName) And PlayerDat(X).Ship > 0 Then
                    tmp = "You are still in this game."
                End If
                If PlayerDat(X).Ship > 0 Then I2 = I2 + 1
            Next
        End If
        
        If I2 >= g_MaxPlayers Then tmp = "The server is full."
        
        Tmp2 = tmp
        
        If pID <= UBound(PlayerDat) Then If PlayerDat(pID).Ship > 0 Then GoTo done
        If Tmp2 <> "" Then
            txtLog.SelStart = Len(txtLog)
            txtLog.SelText = vbNewLine & FromPlayerName & " " & Tmp2
            sendmsgforce MSG_ERROR, Tmp2, CInt(pID), True
            GoTo done
        End If
        
        If pID > UBound(PlayerDat) Then ReDim Preserve PlayerDat(pID)
        PlayerDat(pID).Ship = 5
        PlayerDat(pID).pong = 0
        PlayerDat(pID).Nick = FromPlayerName
        PlayerDat(pID).serial = L
        PlayerDat(pID).activity = NewGTC
        PlayerDat(pID).UDPOK = True
        PlayerDat(pID).Login = True
        PlayerDat(pID).DevCheat = Cheat
        PlayerDat(pID).Duration = NewGTC
        PlayerDat(pID).die = False
        PlayerDat(pID).Health = 60
        PlayerDat(pID).AI = False
        
        I2 = 0
        For b = 1 To Socket1.UBound
            If Socket1(b).State = 7 Then
                If Socket1(b).RemoteHostIP = Socket1(pID).RemoteHostIP Then I2 = I2 + 1
            End If
        Next
        txtLog.SelStart = Len(txtLog)
        txtLog.SelText = vbNewLine & FromPlayerName & " is logging in."
        
        If LANBuild Or PeerBuild Then
            'LAN Games
            For X = 0 To UBound(AdminList)
                If LCase(AdminList(X)) = LCase(PlayerDat(pID).Nick) Then PlayerDat(pID).Admin = 2: Exit For
            Next
            'If PlayerDat(pID).serial = 209289732 Then PlayerDat(pID).Admin = 5
            ' TODO: COMMENT THE FOLLOWING LINE AND UNCOMMENT ABOVE
            PlayerDat(pID).Admin = 5
            lNewMsg = MSG_LOGIN
            lNewOffSet = 0
            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
            SendTo oNewMsg, CInt(pID), True
        Else
            'Cobalt games
            lNewMsg = SVR_JOIN
            lNewOffSet = 0
            ReDim oNewMsg(0)
            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
            AddBufferData oNewMsg, VarPtr(pID), LenB(pID), lNewOffSet
            AddBufferData oNewMsg, VarPtr(L), LenB(L), lNewOffSet
            AddBufferString oNewMsg, FromPlayerName, lNewOffSet
            tmp = Socket1(pID).RemoteHostIP
            AddBufferString oNewMsg, tmp, lNewOffSet
            SendTo2 oNewMsg, 0
        End If
        NotReset = True
    Case MSG_UPDATE
        If Not g_CStrike Then
            PlayerDat(pID).Ship = AutoTeam(pID)
        Else
            PlayerDat(pID).Ship = 5
            PlayerDat(pID).Mode = 1
        End If
        PlayerDat(pID).Duration = NewGTC
        lNewMsg = MSG_PLAYERS
        lNewOffSet = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
        b = pID
        AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
        AddBufferString oNewMsg, FromPlayerName, lNewOffSet
        b = PlayerDat(pID).Ship
        AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
        I2 = PlayerDat(pID).Score
        AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
        b = PlayerDat(pID).Admin
        AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
        b = PlayerDat(pID).DevCheat
        AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
        SendTo oNewMsg, -1
        If PlayerDat(pID).Mode = 1 Then
            lNewMsg = MSG_MODE
            lNewOffSet = 0
            ReDim oNewMsg(0)
            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
            AddBufferData oNewMsg, VarPtr(pID), LenB(pID), lNewOffSet
            b2 = PlayerDat(pID).Mode
            AddBufferData oNewMsg, VarPtr(b2), LenB(b2), lNewOffSet
            SendTo oNewMsg, -1
        End If
        '
        For j = 1 To 4
            lNewMsg = MSG_SCORE
            lNewOffSet = 0
            ReDim oNewMsg(0)
            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
            AddBufferData oNewMsg, VarPtr(j), LenB(j), lNewOffSet
            I2 = TeamScores(j)
            AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
            SendTo oNewMsg, CInt(pID)
            DoEvents
        Next
        
        lNewMsg = MSG_GAMESETTINGS
        lNewOffSet = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
        AddBufferData oNewMsg, VarPtr(g_LaserDamage), LenB(b), lNewOffSet
        AddBufferData oNewMsg, VarPtr(g_SpecialDamage), LenB(b), lNewOffSet
        AddBufferData oNewMsg, VarPtr(g_RechargeRate), LenB(b), lNewOffSet
        AddBufferData oNewMsg, VarPtr(g_Mines), LenB(b), lNewOffSet
        AddBufferData oNewMsg, VarPtr(g_HoldTime), LenB(b), lNewOffSet
        SendTo oNewMsg, CInt(pID)
        
        lNewMsg = MSG_PSPEED
        lNewOffSet = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
        AddBufferData oNewMsg, VarPtr(PSpeed), LenB(PSpeed), lNewOffSet
        SendTo oNewMsg, CInt(pID)

        For I2 = 0 To UBound(Mines)
            If Mines(I2).Color > 0 Then
                j = I2 'mine-specific identifier
                b = Mines(I2).Who
                b2 = Mines(I2).Color
                T3 = Mines(I2).X
                T4 = Mines(I2).y
                lNewMsg = MSG_MINES
                lNewOffSet = 0
                ReDim oNewMsg(0)
                AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
                AddBufferData oNewMsg, VarPtr(j), LenB(j), lNewOffSet
                AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                AddBufferData oNewMsg, VarPtr(b2), LenB(b2), lNewOffSet
                AddBufferData oNewMsg, VarPtr(T3), LenB(T3), lNewOffSet
                AddBufferData oNewMsg, VarPtr(T4), LenB(T4), lNewOffSet
                SendTo oNewMsg, CInt(pID)
            End If
        Next
        '
        For b = 1 To UBound(PlayerDat)
            If PlayerDat(b).Ship > 0 Then
                lNewMsg = MSG_PLAYERS
                lNewOffSet = 0
                ReDim oNewMsg(0)
                AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
                AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                tmp = PlayerDat(b).Nick
                AddBufferString oNewMsg, tmp, lNewOffSet
                b2 = PlayerDat(b).Ship
                AddBufferData oNewMsg, VarPtr(b2), LenB(b2), lNewOffSet
                I2 = PlayerDat(b).Score
                AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
                b2 = PlayerDat(b).Admin
                AddBufferData oNewMsg, VarPtr(b2), LenB(b2), lNewOffSet
                b2 = PlayerDat(b).DevCheat
                AddBufferData oNewMsg, VarPtr(b2), LenB(b2), lNewOffSet
                SendTo oNewMsg, CInt(pID)
                lNewMsg = MSG_MODE
                lNewOffSet = 0
                ReDim oNewMsg(0)
                AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
                AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                b2 = PlayerDat(b).Mode
                AddBufferData oNewMsg, VarPtr(b2), LenB(b2), lNewOffSet
                SendTo oNewMsg, CInt(pID)
                
                If PlayerDat(b).smoking = True Then
                    lNewMsg = MSG_ARMORLO
                    lNewOffSet = 0
                    ReDim oNewMsg(0)
                    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
                    AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                    b2 = PlayerDat(b).smoking
                    AddBufferData oNewMsg, VarPtr(b2), LenB(b2), lNewOffSet
                    SendTo oNewMsg, CInt(pID)
                End If
                
            End If
        Next
        
        '
        b = pID
        SendFlagDat CInt(pID)
        SendSwitchDat CInt(pID), False
        Call sendmsg(MSG_GAMECHAT, Chr(PlayerDat(b).Ship) & FromPlayerName & Chr(5) & " is entering the game.", -1)
        If Not PlayerDat(b).UDPOK Then
            If Socket1(pID).RemoteHostIP <> Socket1(0).LocalIP Then
                Call sendmsg(MSG_GAMECHAT, Chr(5) & "*", CInt(b))
                Call sendmsg(MSG_GAMECHAT, Chr(5) & "*", CInt(b))
                Call sendmsg(MSG_GAMECHAT, Chr(5) & "*", CInt(b))
                Call sendmsg(MSG_GAMECHAT, Chr(5) & "Warning: the server was unable to negotiate UDP sends to your UDP port " & Port3 & ". Please open this port to allow incoming and outgoing data or else you will LAG.", CInt(b))
            End If
        End If
        If Len(Trim$(g_MOTD)) <> 0 And g_MOTD <> "0" Then Call sendmsg(MSG_GAMECHAT, Chr(5) & "Message of the Day: " & g_MOTD, CInt(b))
        lNewMsg = MSG_CONNECTED
        lNewOffSet = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
        AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
        SendTo oNewMsg, CInt(pID)
        PlayerDat(b).playing = True
    Case MSG_MAP
        If PlayerDat(pID).ID <> 2 Then PlayerDat(pID).ID = 1
        PlayerDat(pID).Login = False
    Case MSG_GAMELOGIN
        GetBufferData ReceivedData, VarPtr(L), LenB(L), lOffset
        GetBufferData ReceivedData, VarPtr(L2), LenB(L2), lOffset
        PlayerDat(pID).Login = True
        If L <> HData.Version Or L2 <> FileLen(Filename) Then
            PlayerDat(pID).bPNT = -1
            PlayerDat(pID).SendMapTimer = NewGTC + 300
            PlayerDat(pID).SendMap = True: GoTo done
        End If
        lNewMsg = MSG_GAMELOGIN
        lNewOffSet = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
        SendTo oNewMsg, CInt(pID)
    Case MSG_GAMEDATA
        If PlayerDat(pID).Ship = 0 Then GoTo done
        If PlayerDat(pID).Warping Then GoTo done
        GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
        GetBufferData ReceivedData, VarPtr(T2), LenB(T2), lOffset
        GetBufferData ReceivedData, VarPtr(T3), LenB(T3), lOffset
        If T2 = 0 And T3 = 0 Then GoTo done
        If NewGTC - PlayerDat(pID).SyncSet > 1000 Then
            PlayerDat(pID).SyncSet = NewGTC
            PlayerDat(pID).CharX = T2
            PlayerDat(pID).CharY = T3
            PlayerDat(pID).Direction = b
        End If
        If PlayerDat(pID).Key <> b Then
            PlayerDat(pID).activity = NewGTC
            PlayerDat(pID).Key = b
            PlayerDat(pID).Flagging = True
            PlayerDat(pID).CharX = T2
            PlayerDat(pID).CharY = T3
            PlayerDat(pID).Direction = b
        End If
    Case MSG_NEWKEY
        GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
        If UBound(PlayerDat) < b Then GoTo done
        If PlayerDat(pID).Ship = 0 Then GoTo done
        PlayerDat(pID).Key = b
        lNewMsg = MSG_NEWKEY
        lNewOffSet = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
        AddBufferData oNewMsg, VarPtr(pID), LenB(pID), lNewOffSet
        AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
        SendTo oNewMsg, -2, False
    Case MSG_GAMECHAT
        strPlayer = GetBufferString(ReceivedData, lOffset)
        If PlayerDat(pID).Ship = 0 Then GoTo done
        PlayerDat(pID).activity = NewGTC
        If PlayerDat(pID).gagged Then
            Call sendmsg(MSG_GAMECHAT, Chr(5) & "You are muted.", CInt(pID))
            If PlayerDat(pID).Admin = 0 Then GoTo done
        End If
        If left$(strPlayer, 1) = "/" Then ChatCommands Mid$(strPlayer, 2), PlayerDat(pID).Admin, pID: GoTo done
        X = PlayerDat(pID).Ship
        If Mid$(strPlayer, 1, 1) = ";" Then
            strPlayer = Chr(X) & FromPlayerName & " (TO TEAM> " & Mid$(strPlayer, 2)
            For I2 = 1 To UBound(PlayerDat)
                If PlayerDat(pID).Ship > 0 Then
                    If X = PlayerDat(I2).Ship Then Call sendmsg(MSG_GAMECHAT, strPlayer, I2)
                End If
            Next
            GoTo done
        End If
        strPlayer = Chr(X) & FromPlayerName & ": " & strPlayer
        Call sendmsg(MSG_GAMECHAT, strPlayer, -1)
    Case MSG_TEAM
        GetBufferData ReceivedData, VarPtr(b2), LenB(b2), lOffset
        If g_DeathMatch > 0 Then GoTo done
        If b2 < 1 Or b2 > 4 Then GoTo done
        If PlayerDat(pID).Warping Then GoTo done
        If PlayerDat(pID).Ship = b2 Then GoTo done
        PlayerDat(pID).Score = 0
        PlayerDat(pID).Key = 9
        lNewMsg = MSG_PLAYERSCORE
        lNewOffSet = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
        AddBufferData oNewMsg, VarPtr(pID), LenB(pID), lNewOffSet
        I2 = 0
        AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
        SendTo oNewMsg, -2
        DropFlag pID
        PlayerDat(pID).Flagging = False
        PlayerDat(pID).LastTeamSwitch = NewGTC
        lNewMsg = MSG_TEAM
        lNewOffSet = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
        AddBufferData oNewMsg, VarPtr(pID), LenB(pID), lNewOffSet
        AddBufferData oNewMsg, VarPtr(b2), LenB(b2), lNewOffSet
        SendTo oNewMsg, -2
        If PlayerDat(pID).Mode = 1 Then
            PlayerDat(pID).Mode = 0
            lNewMsg = MSG_MODE
            lNewOffSet = 0
            ReDim oNewMsg(0)
            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
            b = pID
            AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
            b = 0
            AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
            SendTo oNewMsg, -1
            sendmsg MSG_GAMECHAT, Chr(PlayerDat(pID).Ship) & PlayerDat(pID).Nick & Chr(5) & " has left observation mode.", -2
        End If 'MARK501
        tmp = Choose(b2, "green", "red", "blue", "yellow", "not-a-team")
        Call sendmsg(MSG_GAMECHAT, Chr(PlayerDat(pID).Ship) & FromPlayerName & Chr(5) & " switched to " & Chr(b2) & tmp & " team", -2)
        PlayerDat(pID).Ship = b2
        PlayerDat(pID).inpenTrig = NewGTC
    Case MSG_BOMB
        GetBufferData ReceivedData, VarPtr(t1), LenB(t1), lOffset
        GetBufferData ReceivedData, VarPtr(T2), LenB(T2), lOffset
        GetBufferData ReceivedData, VarPtr(T3), LenB(T3), lOffset
        GetBufferData ReceivedData, VarPtr(T4), LenB(T4), lOffset
        FireMort pID, t1, T2, T3, T4
        If PlayerDat(pID).wEnergy < 26 Then GoTo done
        If PlayerDat(pID).DevCheat < 2 Then PlayerDat(pID).wEnergy = PlayerDat(pID).wEnergy - 26
        If PlayerDat(pID).cBomb > 0 Then
            If PlayerDat(pID).DevCheat < 2 Or PlayerDat(pID).DevCheat = 5 Then PlayerDat(pID).cBomb = PlayerDat(pID).cBomb - 1
            lNewMsg = MSG_BOMB
            lNewOffSet = 0
            ReDim oNewMsg(0)
            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
            AddBufferData oNewMsg, VarPtr(pID), LenB(pID), lNewOffSet
            AddBufferData oNewMsg, VarPtr(t1), LenB(t1), lNewOffSet
            AddBufferData oNewMsg, VarPtr(T2), LenB(T2), lNewOffSet
            AddBufferData oNewMsg, VarPtr(T3), LenB(T3), lNewOffSet
            AddBufferData oNewMsg, VarPtr(T4), LenB(T4), lNewOffSet
            SendTo oNewMsg, -2
        End If
    Case MSG_LASER
        GetBufferData ReceivedData, VarPtr(t1), LenB(t1), lOffset
        GetBufferData ReceivedData, VarPtr(T2), LenB(T2), lOffset
        GetBufferData ReceivedData, VarPtr(T3), LenB(T3), lOffset
        GetBufferData ReceivedData, VarPtr(T4), LenB(T4), lOffset
        If PlayerDat(pID).Ship = 0 Then GoTo done
        If PlayerDat(pID).wEnergy < 12 Then GoTo done
        If PlayerDat(pID).DevCheat < 2 Or PlayerDat(pID).DevCheat = 5 Then PlayerDat(pID).wEnergy = PlayerDat(pID).wEnergy - 12
        FireLaser pID, t1, T2, T3, T4
    Case MSG_BOUNCY
        GetBufferData ReceivedData, VarPtr(t1), LenB(t1), lOffset
        GetBufferData ReceivedData, VarPtr(T2), LenB(T2), lOffset
        GetBufferData ReceivedData, VarPtr(T3), LenB(T3), lOffset
        GetBufferData ReceivedData, VarPtr(T4), LenB(T4), lOffset
        If PlayerDat(pID).wEnergy < 12 Then GoTo done
        If PlayerDat(pID).DevCheat < 2 Then PlayerDat(pID).wEnergy = PlayerDat(pID).wEnergy - 12
        If PlayerDat(pID).cBouncy > 0 Then
            If PlayerDat(pID).DevCheat < 2 Or PlayerDat(pID).DevCheat = 5 Then PlayerDat(pID).cBouncy = PlayerDat(pID).cBouncy - 1
            FireBounce pID, t1, T2, T3, T4
        End If
    Case MSG_MISS
        GetBufferData ReceivedData, VarPtr(t1), LenB(t1), lOffset
        GetBufferData ReceivedData, VarPtr(T2), LenB(T2), lOffset
        GetBufferData ReceivedData, VarPtr(T3), LenB(T3), lOffset
        GetBufferData ReceivedData, VarPtr(T4), LenB(T4), lOffset
        If PlayerDat(pID).Ship = 0 Then GoTo done
        If PlayerDat(pID).wEnergy < 18 Then GoTo done
        If PlayerDat(pID).cMissile > 0 Then
            FireMiss pID, t1, T2, T3, T4
        End If
    Case MSG_MINES
        GetBufferData ReceivedData, VarPtr(T3), LenB(T3), lOffset
        GetBufferData ReceivedData, VarPtr(T4), LenB(T4), lOffset
        If PlayerDat(pID).Ship = 0 Then GoTo done
        If PlayerDat(pID).wEnergy < 18 Then GoTo done
        If PlayerDat(pID).DevCheat < 2 Then PlayerDat(pID).wEnergy = PlayerDat(pID).wEnergy - 18
        If PlayerDat(pID).cMines > 0 Then
            If PlayerDat(pID).DevCheat < 2 Or PlayerDat(pID).DevCheat = 5 Then PlayerDat(pID).cMines = PlayerDat(pID).cMines - 1
            b = PlayerDat(pID).Ship
            SendMine pID, b, T3, T4
        End If
    Case MSG_DROPFLAG
        DropFlag pID
    Case MSG_GETSWITCH
        For I2 = 1 To UBound(PowerVal)
            If PowerEffect(I2) > 0 Then
                lNewMsg = MSG_POWERUP
                lNewOffSet = 0
                ReDim oNewMsg(0)
                AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
                AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
                b = PowerVal(I2)
                If b > 4 Then b = b - 4
                AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                b = PowerEffect(I2)
                AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                j = PowerX(I2)
                AddBufferData oNewMsg, VarPtr(j), LenB(j), lNewOffSet
                j = PowerY(I2)
                AddBufferData oNewMsg, VarPtr(j), LenB(j), lNewOffSet
                SendTo oNewMsg, CInt(pID)
            End If
        Next
        lNewMsg = MSG_TIMELIMIT
        lNewOffSet = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
        AddBufferData oNewMsg, VarPtr(TimeTick), LenB(TimeTick), lNewOffSet
        SendTo oNewMsg, CInt(pID)
        
        lNewMsg = MSG_PLAYING
        lNewOffSet = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
        SendTo oNewMsg, CInt(pID)
        '
        HoldingArea CByte(pID)
        PlayerDat(pID).playing = True
        If g_DeathMatch > 0 Then
            Call sendmsg(MSG_GAMECHAT, Chr(5) & "***", CInt(pID))
            Call sendmsg(MSG_GAMECHAT, Chr(5) & "Deathmatch mode: first to " & g_DeathMatch, CInt(pID))
        End If
        
        frmServer.txtLog.SelStart = Len(frmServer.txtLog)
        frmServer.txtLog.SelText = vbNewLine & FromPlayerName & " successfully joined the game."
        If ConnectionOK Then
            lNewMsg = SVR_JOINED
            lNewOffSet = 0
            ReDim oNewMsg(0)
            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
            AddBufferData oNewMsg, VarPtr(pID), LenB(pID), lNewOffSet
            AddBufferString oNewMsg, FromPlayerName, lNewOffSet
            SendTo2 oNewMsg, 0
        End If
    Case MSG_PING
        PlayerDat(pID).Ping = NewGTC - PlayerDat(pID).PingTick
        If PlayerDat(pID).Ping > 32000 Then PlayerDat(pID).Ping = 32000
    Case MSG_UDPOK
        PlayerDat(pID).UDPOK = True
    End Select
done:
    GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
    If b <> 3 Then
        If bDebugLog Then DebugLog "BadPacket @ " & NewGTC & " " & lMsg
        Exit Function
    End If
    If lOffset < ReceivedLen Then
        'Stop
        GoTo nextpacket
    End If
skipdone:
End Function

Private Function Choose2(Text As String) As Integer
    On Error GoTo trytext
    Dim i As Integer
    i = CInt(Text)
trytext:
    Err.Clear
    On Error GoTo 0
    Select Case LCase$(Text)
        Case "green"
            Choose2 = 0
        Case "red"
            Choose2 = 1
        Case "blue"
            Choose2 = 2
        Case "yellow"
            Choose2 = 3
        Case Else
            Choose2 = 0
    End Select
End Function

