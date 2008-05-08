VERSION 5.00
Object = "{33101C00-75C3-11CF-A8A0-444553540000}#1.0#0"; "cswsk32.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form frmMain 
   BorderStyle     =   1  'Fixed Single
   Caption         =   " OpenARC"
   ClientHeight    =   3255
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   3855
   Icon            =   "ARC_frmMain.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3255
   ScaleWidth      =   3855
   StartUpPosition =   2  'CenterScreen
   Visible         =   0   'False
   Begin SocketWrenchCtrl.Socket SocketUDPOUT 
      Left            =   2040
      Top             =   0
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
   Begin SocketWrenchCtrl.Socket SocketUDPIN 
      Left            =   1560
      Top             =   0
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
   Begin SocketWrenchCtrl.Socket SocketTCP 
      Left            =   1080
      Top             =   0
      _Version        =   65536
      _ExtentX        =   741
      _ExtentY        =   741
      _StockProps     =   0
      AutoResolve     =   -1  'True
      Backlog         =   5
      Binary          =   -1  'True
      Blocking        =   0   'False
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
      Timeout         =   4000
      Type            =   1
      Urgent          =   0   'False
   End
   Begin MSComDlg.CommonDialog XPTheme 
      Left            =   0
      Top             =   360
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.PictureBox Picture1 
      BorderStyle     =   0  'None
      Height          =   2715
      Left            =   240
      ScaleHeight     =   181
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   225
      TabIndex        =   1
      Top             =   360
      Width           =   3375
      Begin VB.ComboBox cboDevices 
         Height          =   315
         ItemData        =   "ARC_frmMain.frx":1042
         Left            =   960
         List            =   "ARC_frmMain.frx":1044
         Style           =   2  'Dropdown List
         TabIndex        =   16
         Top             =   1560
         Width           =   2415
      End
      Begin VB.CommandButton cmdOptions 
         Caption         =   "Options"
         Height          =   375
         Left            =   1080
         TabIndex        =   9
         Top             =   2280
         Visible         =   0   'False
         Width           =   1095
      End
      Begin VB.ComboBox cboResolution 
         Height          =   315
         ItemData        =   "ARC_frmMain.frx":1046
         Left            =   960
         List            =   "ARC_frmMain.frx":1048
         Style           =   2  'Dropdown List
         TabIndex        =   8
         Top             =   1920
         Width           =   1575
      End
      Begin VB.CommandButton cmdConnect 
         Caption         =   "Connect"
         Default         =   -1  'True
         Height          =   375
         Left            =   2280
         TabIndex        =   7
         Top             =   2280
         Width           =   1095
      End
      Begin VB.TextBox txtHZ 
         Alignment       =   1  'Right Justify
         Height          =   285
         Left            =   3000
         TabIndex        =   6
         Text            =   "0"
         ToolTipText     =   "Zero is the adapter default."
         Top             =   1920
         Width           =   375
      End
      Begin VB.TextBox txtPassword 
         Height          =   285
         IMEMode         =   3  'DISABLE
         Left            =   960
         PasswordChar    =   "*"
         TabIndex        =   5
         Top             =   1200
         Width           =   2415
      End
      Begin VB.TextBox txtPort 
         Height          =   285
         Left            =   960
         TabIndex        =   4
         Top             =   840
         Width           =   2415
      End
      Begin VB.TextBox txtServer 
         Height          =   285
         Left            =   960
         TabIndex        =   3
         Top             =   480
         Width           =   2415
      End
      Begin VB.TextBox txtUserName 
         Height          =   285
         Left            =   960
         TabIndex        =   2
         Top             =   120
         Width           =   2415
      End
      Begin VB.Label Label7 
         Alignment       =   1  'Right Justify
         Caption         =   "Device:"
         Height          =   255
         Left            =   0
         TabIndex        =   17
         Top             =   1560
         Width           =   855
      End
      Begin VB.Label Label6 
         Alignment       =   1  'Right Justify
         Caption         =   "Hz:"
         Height          =   255
         Left            =   2640
         TabIndex        =   15
         Top             =   1920
         Width           =   255
      End
      Begin VB.Label Label5 
         Alignment       =   1  'Right Justify
         Caption         =   "Resolution:"
         Height          =   255
         Left            =   0
         TabIndex        =   14
         Top             =   1920
         Width           =   855
      End
      Begin VB.Label Label4 
         Alignment       =   1  'Right Justify
         Caption         =   "Password:"
         Height          =   255
         Left            =   0
         TabIndex        =   13
         Top             =   1200
         Width           =   855
      End
      Begin VB.Label Label3 
         Alignment       =   1  'Right Justify
         Caption         =   "Port:"
         Height          =   255
         Left            =   0
         TabIndex        =   12
         Top             =   840
         Width           =   855
      End
      Begin VB.Label Label2 
         Alignment       =   1  'Right Justify
         Caption         =   "Server (IP):"
         Height          =   255
         Left            =   0
         TabIndex        =   11
         Top             =   480
         Width           =   855
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "User Name:"
         Height          =   255
         Left            =   0
         TabIndex        =   10
         Top             =   120
         Width           =   855
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "Connect"
      Height          =   3015
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   3615
   End
   Begin VB.Timer Timer2 
      Enabled         =   0   'False
      Interval        =   1
      Left            =   0
      Top             =   480
   End
   Begin VB.Timer Timer3 
      Enabled         =   0   'False
      Interval        =   1
      Left            =   600
      Top             =   0
   End
End
Attribute VB_Name = "frmMain"
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

Private Type Device
    GUID As String
    Description As String
End Type

Private Data() As Byte, LastDataIndex As Integer
Dim Devices() As Device

Private Sub cmdConnect_Click()
    If Len(txtUserName) < 3 Then
        MsgBox "The user name you entered is too short.", vbExclamation, ProjectName
        Exit Sub
    ElseIf Len(txtServer) < 3 Then
        MsgBox "The server name you entered is too short.", vbExclamation, ProjectName
        Exit Sub
    End If
    If Not FileExists(AppPath & "graphics\Farplane.bmp") _
        Or Not FileExists(AppPath & "graphics\extras.bmp") _
        Or Not FileExists(AppPath & "graphics\tuna.bmp") _
        Or Not FileExists(AppPath & "graphics\Tiles.bmp") Then
        RaiseCritical "Some of the graphics data is missing. Please reinstall OpenARC."
    End If

    Dim a() As String
    DefaultGUID = Devices(cboDevices.ListIndex).GUID
    Me.MousePointer = vbHourglass
    Hz = txtHZ
    HostAddy = txtServer
    Port = Val(txtPort)
    UserName = txtUserName
                                       'Resolutions are potentially insecure... Resource hacking/hexedit?
    a = Split(cboResolution.Text, "x") 'Example 1024x768, so it is split into 1024, 768.
    ResX = a(0) '1024
    ResY = a(1) '768
    Call writeini("Settings", "UserName", UserName, AppPath & "settings.ini")
    Call writeini("Settings", "Server", HostAddy, AppPath & "settings.ini")
    Call writeini("Settings", "Port", Port, AppPath & "settings.ini")
    Call writeini("Settings", "DefaultDevice", cboDevices.ListIndex, AppPath & "settings.ini")
    SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "res", cboResolution.ListIndex
    Call writeini("Settings", "Hz", Hz, AppPath & "settings.ini")
    Me.MousePointer = vbHourglass
    Me.Visible = False
    If Stopping Then Exit Sub
    If StartLog Then
        StartupLog "-------------------------------"
        StartupLog "- ENTERING STARTUP RUNLEVEL 1 -"
        StartupLog "-------------------------------"
        StartupLog "Analyzing systems..."
        StartupLog "Startup logging:  " & IIf(StartLog, "ENABLED", "DISABLED")
        StartupLog "Admin Build:      " & IIf(AdminBuild, "ENABLED", "DISABLED")
        StartupLog "Debug Build:      " & IIf(DebugBuild, "ENABLED", "DISABLED")
        StartupLog "Peer build:       " & IIf(PeerBuild, "ENABLED", "DISABLED")
        StartupLog "LAN build:        " & IIf(LANBuild, "ENABLED", "DISABLED")
        StartupLog "Advertisements:   " & IIf(Advertisements, "ENABLED", "DISABLED")
        StartupLog "Encryption:       " & IIf(Encrypted, "ENABLED", "DISABLED")
        StartupLog "Network protocol v" & modVersion.ClientVersion
        StartupLog "Server protocol v" & modVersion.ServerVersion
    End If
    cmdConnect.Caption = "Cancel"
    frmSplash.Timer1.Enabled = True
    frmSplash.Visible = True
End Sub

Private Sub cmdOptions_Click()
    frmConfig.Show 1
End Sub

Private Sub EnumDevices()
    Dim I As Integer
    Dim dx As DirectX7
    Set dx = New DirectX7
    Dim dd As DirectDraw7
    Set dd = dx.DirectDrawCreate("")
    Dim dde As DirectDrawEnum
    Set dde = dx.GetDDEnum
    Dim lReturn As Long
    lReturn = dde.GetCount
    ReDim Devices(lReturn - 1)
    For I = 1 To lReturn
        Devices(I - 1).GUID = dde.GetGuid(I)
        Devices(I - 1).Description = dde.GetDescription(I)
    Next
    For I = 0 To UBound(Devices)
        cboDevices.AddItem Devices(I).Description
    Next
    cboDevices.ListIndex = 0
End Sub

Private Sub Form_Load()
    If App.PrevInstance Then End
    EnumDevices
    Dim tmp As String, sc As Integer
    Set iLAttempts = New clsByte
    iLAttempts = 3
    Set DebugConsole = New clsByte
    DebugConsole = 0
    DeleteFile AppPath & "DebugLog.txt"
    DeleteFile AppPath & "blackbox.txt"
    ReDim Data(131072)
    Serial_Number = GetDriveInfo("C:\", 1)
    Me.Caption = ProjectName & " v" & App.Major & "." & Format$(App.Minor, "00") & "." & Format$(App.Revision, "0000")
    tmp = Command$
    Load frmSplash
    InitResolutions
    InitToolTips
    On Error Resume Next
    If StartLog Then
        frmDebug.Show
        frmDebug.Move 10, 10, frmDebug.Width, Screen.Height - (35 * Screen.TwipsPerPixelY)
        StartupLog "======================="
        StartupLog "=                     ="
        StartupLog "=    O p e n A R C    ="
        StartupLog "=                     ="
        StartupLog "=" & BuildType & "="
        StartupLog "=                     ="
        StartupLog "======================="
        StartupLog "v" & App.Major & "." & Format$(App.Minor, "00") & "." & Format$(App.Revision, "0000")
    End If
    txtUserName = readini("Settings", "UserName", AppPath & "settings.ini")
    txtServer = readini("Settings", "Server", AppPath & "settings.ini")
    txtPort = Val(readini("Settings", "Port", AppPath & "settings.ini"))
    cboDevices.ListIndex = Val(readini("Settings", "DefaultDevice", AppPath & "settings.ini"))
    sc = GetSettingLong(HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "res", 1)
    On Error GoTo 0
    If sc > 1 And DevBuild = 0 Then 'If the setting's too high and this is not an admin build...
        sc = 1
    End If
    cboResolution.ListIndex = sc
    If txtPort < 1024 Then txtPort = 22000
    If LenB(tmp) > 0 Then
        If Asc(Right$(tmp, 1)) = 255 Then
            txtPassword = InputBox("This game is password protected. Enter the password to play.", App.Title)
            If LenB(txtPassword) = 0 Then End
        End If
        Me.Hide
        cmdConnect_Click
    Else
        Me.Show
    End If
End Sub

Private Function CreateDir(Path As String)
    On Error Resume Next
    MkDir Path
End Function

Private Sub Form_Unload(Cancel As Integer)
    Unload frmSplash
    End
End Sub

Private Sub SocketTCP_Blocking(Status As Integer, Cancel As Integer)
    If Status = SOCKET_CONNECTING Then
        MakeAlwaysOnTop frmSplash, False
        If Len(ExitMSG) = 0 Then ExitMSG = "Connection attempt timed out."
        If StartLog Then
            StartupLog "Connection failure."
        End If
        RaiseError ExitMSG
    End If
End Sub

Private Sub SocketTCP_Connect()
    If StartLog Then
        StartupLog "Connection was successfully established."
        StartupLog "-------------------------------"
        StartupLog "- ENTERING STARTUP RUNLEVEL 3 -"
        StartupLog "-------------------------------"
    End If
    MakeAlwaysOnTop frmSplash, False
    SetLoadTitle "Initializing DirectX..."
    Pause2 500
    InitDirectX
End Sub

Private Sub Timer2_Timer()
    If LenB(ExitMSG) > 0 Then RaiseCritical ExitMSG
    SocketTCP.Disconnect
    SocketUDPOUT.Disconnect
    SocketUDPIN.Disconnect
    End
End Sub

Private Sub InitResolutions()
    With cboResolution
        .Clear
        .AddItem "640x480"
        .AddItem "800x600"
        If DevBuild = 1 Or DevEnv Then
            .AddItem "1024x600"
            .AddItem "1024x768"
            .AddItem "1152x864"
            .AddItem "1280x720"
            .AddItem "1280x768"
            .AddItem "1280x800"
            .AddItem "1280x960"
            .AddItem "1280x1024"
            .AddItem "1600x900"
            .AddItem "1600x1024"
            .AddItem "1600x1200"
            .AddItem "1680x1050"
            .AddItem "1920x1080"
            .AddItem "1920x1200"
            .AddItem "1920x1440"
            .AddItem "2048x1536"
        End If
    End With
End Sub

Private Sub InitToolTips()
    Me.txtUserName.ToolTipText = "Enter your " & ProjectName & " user name here."
    Me.txtPassword.ToolTipText = "If the " & ProjectName & " server requires a password, enter it here."
    Me.txtPort.ToolTipText = "Enter the appropriate port number here."
    Me.txtServer.ToolTipText = "Enter the IP (or hostname) of the server you want to connect to."
    Me.cboResolution.ToolTipText = "Select your resolution here."
End Sub

Private Sub SocketTCP_Disconnect()
    Stopping = True
    If Len(ExitMSG) = 0 Then ExitMSG = "Server connection closed."
    Timer2.Enabled = True
    SocketTCP.Disconnect
End Sub

Private Sub SocketTCP_LastError(ErrorCode As Integer, ErrorString As String, Response As Integer)
    If ErrorCode = WSAECONNABORTED Or ErrorCode = WSAETIMEDOUT Or ErrorCode = WSAECONNRESET Or ErrorCode = WSAECONNREFUSED Or ErrorCode = WSAEHOSTDOWN Or ErrorCode = WSAEHOSTUNREACH Or ErrorCode = WSANO_DATA Then
        If Len(ExitMSG) = 0 Then ExitMSG = ErrorString
        RaiseError ExitMSG
    End If
End Sub

Private Sub SocketTCP_Read(DataLength As Integer, IsUrgent As Integer)
    Dim I As Long, NewData() As Byte, DL As Integer, Stage As Integer
    ReDim NewData(16384)
    Do Until Stage >= DataLength
        DL = SocketTCP.ReadBytes(NewData(), 16384)
        Stage = Stage + DL
        If DL < 0 Or DL > 16384 Then Exit Sub 'Buffer overflow/underflow
        CopyMemory Data(LastDataIndex), NewData(0), DL
        LastDataIndex = LastDataIndex + DL
    Loop
    If Data(LastDataIndex - 1) = 3 Then
        DataProcess Data, LastDataIndex - 1
        LastDataIndex = 0
        ReDim Data(131072)
    End If
End Sub

Private Sub SocketTCP_Timeout(Status As Integer, Response As Integer)
    Stopping = True
    If Len(ExitMSG) = 0 Then ExitMSG = "Server timed out."
    Timer2.Enabled = True
End Sub

Private Sub SocketUDPIN_Read(DataLength As Integer, IsUrgent As Integer)
    Dim I As Long, NewData() As Byte, TempLen As Integer
    Dim Data() As Byte, DL As Integer
    ReDim NewData(16384)
    ReDim Data(16384)
    Do Until TempLen >= DataLength
        DL = SocketUDPIN.ReadBytes(NewData(), 16384)
        If DL < 0 Or DL > 16384 Then Exit Sub
        CopyMemory Data(TempLen), NewData(0), DL
        TempLen = TempLen + DL
    Loop
    If Data(TempLen - 1) = 3 Then
        DataProcess Data, TempLen - 1
    End If
End Sub

Private Sub Timer3_Timer()
    Dim lMsg As Byte
    Dim oNewMsg() As Byte, lNewOffSet As Long, I As Integer, tmp As String
    Static lCount As Integer
    Timer3.interval = 1000
    lCount = lCount + 1
    If lCount > 7 Then
        'NoUDP = True
        Timer3.Enabled = False
        ExitMSG = "Could not negotiate with the server. The server may be blocking UDP port: " & Port & ". Please contact the host and notify them. If they are properly configured then you will need to configure this port to allow UDP outgoing and incoming, or turn off your firewall."
        Timer2.Enabled = True
        Exit Sub
    End If
    lMsg = MSG_LOGIN
    AddBufferData oNewMsg, VarPtr(lMsg), LenB(lMsg), lNewOffSet
    I = ClientVersion
    AddBufferData oNewMsg, VarPtr(I), LenB(I), lNewOffSet
    AddBufferData oNewMsg, VarPtr(Serial_Number), LenB(Serial_Number), lNewOffSet
    tmp = txtPassword.Text
    If Len(tmp) = 0 Then tmp = Chr$(0)
    AddBufferString oNewMsg, tmp, lNewOffSet
    tmp = txtUserName.Text
    AddBufferString oNewMsg, tmp, lNewOffSet
    SendTo oNewMsg, False
End Sub

