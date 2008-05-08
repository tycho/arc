VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "mswinsck.ocx"
Begin VB.Form frmMain 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Cobalt Server"
   ClientHeight    =   2475
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   2745
   Icon            =   "CobaltServ_frmMain.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2475
   ScaleWidth      =   2745
   StartUpPosition =   2  'CenterScreen
   Begin VB.CheckBox Check1 
      Caption         =   "Pay-to-play"
      Height          =   255
      Left            =   120
      TabIndex        =   11
      Top             =   1320
      Width           =   1215
   End
   Begin VB.Timer Timer1 
      Interval        =   7500
      Left            =   1560
      Top             =   2040
   End
   Begin MSWinsockLib.Winsock Socket1 
      Index           =   0
      Left            =   1800
      Top             =   960
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock Socket2 
      Index           =   0
      Left            =   1320
      Top             =   960
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.TextBox Text4 
      Enabled         =   0   'False
      Height          =   3975
      Left            =   360
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   9
      Top             =   5520
      Width           =   10215
   End
   Begin VB.CommandButton Command3 
      Caption         =   "Command3"
      Enabled         =   0   'False
      Height          =   375
      Left            =   960
      TabIndex        =   8
      Top             =   4920
      Width           =   1455
   End
   Begin VB.TextBox Text3 
      Height          =   285
      Left            =   120
      TabIndex        =   7
      Text            =   "cobalt.uplinklabs.net"
      Top             =   1680
      Width           =   2535
   End
   Begin VB.CommandButton Command2 
      Caption         =   "X"
      Height          =   375
      Left            =   2160
      TabIndex        =   5
      Top             =   2040
      Width           =   495
   End
   Begin VB.TextBox Text2 
      Height          =   285
      Left            =   1200
      TabIndex        =   4
      Text            =   "6001"
      Top             =   480
      Width           =   975
   End
   Begin VB.Timer Timer3 
      Enabled         =   0   'False
      Interval        =   500
      Left            =   2400
      Top             =   1800
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Left            =   1200
      TabIndex        =   1
      Text            =   "6000"
      Top             =   120
      Width           =   975
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Start"
      Height          =   375
      Left            =   120
      TabIndex        =   0
      Top             =   2040
      Width           =   975
   End
   Begin VB.Label Label4 
      Alignment       =   2  'Center
      BeginProperty Font 
         Name            =   "Courier New"
         Size            =   14.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1215
      Left            =   90
      TabIndex        =   10
      Top             =   720
      Visible         =   0   'False
      Width           =   2655
   End
   Begin VB.Label Label3 
      Caption         =   "enter in your internet IP for hosting games."
      Height          =   495
      Left            =   120
      TabIndex        =   6
      ToolTipText     =   "leave blank to use internal ip."
      Top             =   840
      Width           =   2535
   End
   Begin VB.Label Label2 
      Caption         =   "Register Port:"
      Height          =   255
      Left            =   120
      TabIndex        =   3
      Top             =   480
      Width           =   975
   End
   Begin VB.Label Label1 
      Caption         =   "Lobby Port:"
      Height          =   255
      Left            =   240
      TabIndex        =   2
      Top             =   120
      Width           =   855
   End
   Begin VB.Menu main 
      Caption         =   "Main"
      Visible         =   0   'False
      Begin VB.Menu pshow 
         Caption         =   "Show"
      End
      Begin VB.Menu div 
         Caption         =   "-"
      End
      Begin VB.Menu pexit 
         Caption         =   "Exit"
      End
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
Public DateStarted As String
Public DateNextReset As String

Public Function ViperX(IP As String) As Boolean
    On Error Resume Next
    Dim a() As String
    a = Split(IP, ".")
    If UBound(a) < 1 Then Exit Function
    If a(0) = 24 Then
        If a(1) = 59 Then
            ViperX = True
            Exit Function
        End If
    End If
    ViperX = False
End Function

Public Function GetDiffString(lngTime As Long) As String
    Dim Days As Long
    Dim Hours As Long
    Dim Minutes As Long
    Dim Seconds As Long
    Dim TmpTime As Long
    TmpTime = lngTime
    Days = TmpTime / 86400
    TmpTime = TmpTime Mod 86400
    Hours = TmpTime / 3600
    TmpTime = TmpTime Mod 3600
    Minutes = TmpTime / 60
    TmpTime = TmpTime Mod 60
    Seconds = TmpTime
    GetDiffString = Days & " days, " & Format$(Hours, "00") & " hours, " & Format$(Minutes, "00") & " minutes, and " & Format$(Seconds, "00") & " seconds."
End Function

Public Function PurgeExpiredBans() As Boolean
    Dim I As Long
    For I = 0 To UBound(Bans)
        If Bans(I).BanExpire <= Now Then
            Bans(I).BanName = vbNullString
            Bans(I).BannedBy = vbNullString
        End If
    Next
    For I = 0 To UBound(Bans2)
        If Bans2(I).BanExpire <= Now Then
            Bans2(I).BanIP = vbNullString
            Bans2(I).BannedBy = vbNullString
        End If
    Next
    For I = 0 To UBound(Bans3)
        If Bans3(I).BanExpire <= Now Then
            Bans3(I).BanHD = 0
            Bans3(I).BanName = vbNullString
            Bans3(I).BannedBy = vbNullString
        End If
    Next
    For I = 0 To UBound(Bans4)
        If Bans4(I).BanExpire <= Now Then
            Bans4(I).BanSysID = vbNullString
            Bans4(I).BannedBy = vbNullString
        End If
    Next
End Function

Public Function GetCount(rs As Recordset)
    On Error GoTo errors
    rs.MoveLast
    GetCount = rs.AbsolutePosition
    rs.MoveFirst
    Exit Function
errors:
    GetCount = 0
End Function

Private Sub Command1_Click()
    If Check1.Value = 1 Then
        g_PaymentRequired = 1
    End If
    InitSocket
    DateStarted = Now
    DateNextReset = DateAdd("d", 1, Now)
    Timer3.Enabled = True
    Command1.Enabled = False
    Check1.Enabled = False
    SaveSetting App.Title, "Preferences", "ServerIP", Text3.Text
End Sub

Private Sub Command2_Click()
    Dim I As Integer
    Timer3.Enabled = False
    Socket1(0).Close
    Socket2(0).Close
    For I = 0 To Socket1.UBound
        If Socket1(I).State = 7 Then
            RemovePlayer I
            Socket1(I).Close
        End If
    Next
    For I = 0 To Socket2.UBound
        If Socket2(I).State = 7 Then Socket2(I).Close
    Next
    Command1.Enabled = True
    Check1.Enabled = True
End Sub

Private Sub Command3_Click()
    Dim SQLString As String, rstmp As Recordset
    Dim I As Integer
    SQLString = "SELECT * FROM ACCOUNTS"
    Set rstmp = db.OpenRecordset(SQLString)
    Do While Not rstmp.EOF
        For I = 0 To 9
            Text4 = Text4 & rstmp.Fields(I) & "; "
        Next
        Text4 = Text4 & vbNewLine
        rstmp.MoveNext
    Loop
End Sub

Public Sub ShowControls(Show As Boolean)
    If Show = True Then
        Label1.Visible = True
        Label2.Visible = True
        Label3.Visible = True
        Label4.Visible = False
        Text1.Visible = True
        Text2.Visible = True
        Text3.Visible = True
        Command1.Visible = True
        Command2.Visible = True
        Check1.Visible = True
    Else
        Label1.Visible = False
        Label2.Visible = False
        Label3.Visible = False
        Label4.Visible = True
        Text1.Visible = False
        Text2.Visible = False
        Text3.Visible = False
        Command1.Visible = False
        Command2.Visible = False
        Check1.Visible = False
    End If
End Sub

Private Sub Form_Load()
    'On Error Resume Next
    Dim MyCommandLine As String, s As String, L As Long, Serial_Number As Long
    Text3.Text = GetSetting(App.Title, "Preferences", "ServerIP", Socket1(0).LocalIP)
    Serial_Number = GetDriveInfo("C:\")
    ReDim UserDat(0), ServerDat(0), svrPlayers(0), LoginQueue(0), SendBuff(0), Rooms(0)
    ReDim Gags(0), Bans(0), Bans2(0), Bans3(0), Bans4(0), VerifyName(0), VerifyPassword(0), VerifyID(0)
    Set Rooms(0) = New clsChatRoom
    Set UserDat(0) = New clsUserData
    UserDat(0).Nick = ServerName
    CreateRoom ServerName & " Lobby", "Cobalt"
    ARCmotd = InitMotd
    AdminARCmotd = InitAdminMotd
    MyCommandLine = Trim$(UCase$(Command()))
    s = AppPath & "accounts.mdb"
    If Dir(s) = vbNullString Then End
    Open s For Binary Access Read As #1
    Get #1, 63, L
    Close #1
    Set db = OpenDatabase(s, False, False)
    With sysIcon
        .cbSize = LenB(sysIcon)
        .hwnd = Me.hwnd
        .uFlags = NIF_DOALL
        .uCallbackMessage = WM_MOUSEMOVE
        .hIcon = Me.Icon
        .sTip = "Cobalt Server" & vbNullChar
    End With
    Shell_NotifyIcon NIM_ADD, sysIcon
    If Val(MyCommandLine) > 0 Then
        Text1 = MyCommandLine
        Command1_Click
        Me.Hide
    End If
    If Dir$(AppPath & "gags.dat") <> vbNullString Then
        Open AppPath & "gags.dat" For Binary Access Read As #1
        Get #1, , Gags()
        Close #1
    End If
    If Dir$(AppPath & "bans.dat") <> vbNullString Then
        Open AppPath & "bans.dat" For Binary Access Read As #1
        Get #1, , Bans()
        Close #1
    End If
    If Dir$(AppPath & "bans2.dat") <> vbNullString Then
        Open AppPath & "bans2.dat" For Binary Access Read As #1
        Get #1, , Bans2()
        Close #1
    End If
    If Dir$(AppPath & "bans3.dat") <> vbNullString Then
        Open AppPath & "bans3.dat" For Binary Access Read As #1
        Get #1, , Bans3()
        Close #1
    End If
    If Dir$(AppPath & "bans4.dat") <> vbNullString Then
        Open AppPath & "bans4.dat" For Binary Access Read As #1
        Get #1, , Bans4()
        Close #1
    End If
    InitKeys
    bEncPassword = EncPassword
    If CmpDate <> Date$ Then
        CmpDate = Date$
        ShowControls False
        Me.Show
        Me.Refresh
        DoEvents
        'PruneUsers 0
        resetDayStats
        ShowControls True
    End If
End Sub

Private Sub Form_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Dim ShellMsg As Long
    
    ShellMsg = X / 11
    Select Case X
    Case 7725
        Me.WindowState = vbNormal
        Me.Show
    Case 7755
        PopupMenu main
    End Select
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    If UnloadMode = 0 Then
        Cancel = 1
        Me.Hide
        Exit Sub
    End If
    Socket1(0).Close
    Socket2(0).Close
    Shell_NotifyIcon NIM_DELETE, sysIcon
    If Reset Then Shell AppPath & "\Cobaltsrv.exe " & Text1, vbHide
End Sub

Private Sub Form_Resize()
    If Me.WindowState = vbMinimized Then Me.Hide: Exit Sub
End Sub

Private Sub pexit_Click()
    Unload Me
End Sub

Private Sub pshow_Click()
    Me.Show
End Sub

Private Sub Socket1_Close(Index As Integer)
    RemovePlayer Index
    Socket1(Index).Close
End Sub

Private Sub Socket1_ConnectionRequest(Index As Integer, ByVal requestID As Long)
    Dim I As Integer, j As Integer, c As Integer
    DoEvents
    If IsBanned2(Socket1(Index).RemoteHostIP) Then
        For I = 1 To UBound(UserDat)
            If Not UserDat(I) Is Nothing Then
                If UserDat(I).Admin > 1 Then SendChat "&FF4400&" & UCase$(ServerName) & " PORT: [" & Socket1(Index).RemoteHostIP & "] connection blocked", 0, I: IPLog UCase$(ServerName) & " PORT: [" & Socket1(Index).RemoteHostIP & "] connection blocked"
            End If
        Next
        Exit Sub
    Else
        For I = 1 To UBound(UserDat)
            If Not UserDat(I) Is Nothing Then
                If UserDat(I).Admin > 1 Then SendChat "&FF4400&" & UCase$(ServerName) & " PORT: [" & Socket1(Index).RemoteHostIP & "] connection accepted", 0, I: IPLog UCase$(ServerName) & " PORT: [" & Socket1(Index).RemoteHostIP & "] connection accepted"
            End If
        Next
    End If
    If ViperX(Socket1(Index).RemoteHostIP) Then
        For I = 1 To UBound(UserDat)
            If Not UserDat(I) Is Nothing Then
                If UserDat(I).Admin > 4 Then SendChat "&FF4400&" & UCase$(ServerName) & " PORT: [" & Socket1(Index).RemoteHostIP & "] connection blocked: ViperX", 0, I: IPLog UCase$(ServerName) & " PORT: [" & Socket1(Index).RemoteHostIP & "] connection blocked: ViperX"
            End If
        Next
        Exit Sub
    End If
skip:
    If Index > 128 Then
        Socket1(Index).Close
        Exit Sub
    End If
    For I = 1 To Socket1.UBound
        If Not Socket1(I).State = 7 Then Exit For
    Next
    If I > Socket1.UBound Then Load Socket1(I)
    Socket1(I).Close
    Socket1(I).Accept requestID
    For j = 1 To Socket2.UBound
        If Socket2(j).State = 7 Then
            If Socket2(j).RemoteHostIP = Socket1(I).RemoteHostIP Then c = c + 1
        End If
    Next
    If c > 4 Then Socket1(I).Close '
End Sub

Function ArrayIsValid(TehArray() As Byte) As Boolean
    On Error GoTo errors
    Dim X As Long
    X = UBound(TehArray)
    ArrayIsValid = True
    Exit Function
errors:
    ArrayIsValid = False
End Function

Public Sub DebugLog(txt As String)
    Debug.Print txt
    Open AppPath & "cobaltsrv_log.txt" For Append As #1
    Print #1, txt
    Close #1
End Sub

Private Sub Socket1_DataArrival(Index As Integer, ByVal bytesTotal As Long)
    If Not DevEnv Then On Error GoTo ExitIt 'If someone sends a bad packet, it's probably intentional.
    If bytesTotal > 4096 Then GoTo ErrorManager 'overly large packets can crash the server
    Dim Data() As Byte, DataLength As Long
    Dim TmpBytArray() As Byte
    DataLength = bytesTotal - 1
    ReDim Data(DataLength) As Byte
    Socket1(Index).GetData Data(), vbArray + vbByte
    If UBound(Data) > 0 Then
        If Data(UBound(Data)) = 3 Then
            DataProcess Data, UBound(Data) + 1, Index
        End If
    End If
    Exit Sub
ErrorManager:
    Dim newCmd As Long
    Dim d2 As Date
    newCmd = 720
    If Val(newCmd) > 99999 Then newCmd = 99999
    d2 = DateAdd("n", Minute(Time), Date)
    d2 = DateAdd("h", Hour(Time), d2)
    d2 = DateAdd("s", Second(Time), d2)
    d2 = DateAdd("n", Val(newCmd), d2)
    Ban2 Socket1(Index).RemoteHostIP, d2, 0
    Socket1(Index).Close
    RemovePlayer Index
ExitIt:
End Sub

Private Sub Socket1_Error(Index As Integer, ByVal Number As Integer, Description As String, ByVal Scode As Long, ByVal Source As String, ByVal HelpFile As String, ByVal HelpContext As Long, CancelDisplay As Boolean)
    RemovePlayer Index
    Socket1(Index).Close
End Sub

Private Sub Socket2_Close(Index As Integer)
    RemoveServer Index
    Socket2(Index).Close
End Sub

Private Sub Socket2_ConnectionRequest(Index As Integer, ByVal requestID As Long)
    Dim I As Integer, j As Integer, c As Integer
    DoEvents
    If IsBanned2(Socket2(Index).RemoteHostIP) Then
        For I = 1 To UBound(UserDat)
            If Not UserDat(I) Is Nothing Then
                If UserDat(I).Admin > 1 Then SendChat "&FF4400&GAME PORT: [" & Socket2(Index).RemoteHostIP & "] connection blocked", 0, I
            End If
        Next
        Exit Sub
    Else
        For I = 1 To UBound(UserDat)
            If Not UserDat(I) Is Nothing Then
                If UserDat(I).Admin > 1 Then SendChat "&FF4400&GAME PORT: [" & Socket2(Index).RemoteHostIP & "] connection accepted", 0, I
            End If
        Next
    End If
    If ViperX(Socket2(Index).RemoteHostIP) Then
        For I = 1 To UBound(UserDat)
            If Not UserDat(I) Is Nothing Then
                If UserDat(I).Admin > 4 Then SendChat "&FF4400&" & UCase$(ServerName) & " PORT: [" & Socket1(Index).RemoteHostIP & "] connection blocked: ViperX", 0, I: IPLog UCase$(ServerName) & " PORT: [" & Socket1(Index).RemoteHostIP & "] connection blocked: ViperX"
            End If
        Next
        Exit Sub
    End If
skip:
    If Index > 128 Then
        Socket2(Index).Close
        Exit Sub
    End If
    
    For I = 1 To Socket2.UBound
        If Socket2(I).State = 7 Then
            If Socket2(I).RemoteHostIP = Socket2(Index).RemoteHostIP Then j = j + 1
        End If
    Next
    If j > 5 Then
        Socket2(Index).Close
        Exit Sub
    End If
    
    For I = 1 To Socket2.UBound
        If Not Socket2(I).State = 7 Then Exit For
    Next
    If I > Socket2.UBound Then Load Socket2(I)
    Socket2(I).Close
    Socket2(I).Accept requestID
    
    For j = 1 To Socket2.UBound
        If Socket2(j).State = 7 Then
            If Socket2(j).RemoteHostIP = Socket2(I).RemoteHostIP Then c = c + 1
        End If
    Next
    If c > 5 Then Socket2(I).Close
End Sub

Private Sub Socket2_DataArrival(Index As Integer, ByVal bytesTotal As Long)
    'This code is designed to avoid crashes at the time being. If bad packets
    'arrive, the person is immediately banned.
    
    'If someone sends a bad packet, it's probably intentional.
    On Error GoTo ErrorManager
    'overly large packets crash the server on occasion.
    If bytesTotal > 4096 Then GoTo ErrorManager
    'Create the data array
    Dim Data() As Byte
    'Size the array appropriately
    ReDim Data(bytesTotal - 1) As Byte
    'Get the data.
    DoEvents
    Socket2(Index).GetData Data(), vbByte + vbArray
    'Make sure the array has information in it.
    If UBound(Data) > 0 Then
        'Make sure the last byte is a 3. (verifies the packet as real)
        If Data(UBound(Data)) = 3 Then
            'Process the data.
            DataProcess2 Data, UBound(Data), Index
        End If
    End If
    Exit Sub
ErrorManager:
    Dim newCmd As Long
    Dim d2 As Date
    'Ban for 30 minutes (bad packets, >2KB packet)
    newCmd = 30
    If Val(newCmd) > 99999 Then newCmd = 99999
    d2 = DateAdd("n", Minute(Time), Date)
    d2 = DateAdd("h", Hour(Time), d2)
    d2 = DateAdd("s", Second(Time), d2)
    d2 = DateAdd("n", Val(newCmd), d2)
    'IP ban, prevents reconnecting
    Ban2 Socket2(Index).RemoteHostIP, d2, UCase$(ServerName)
    'Murder their connection
    Socket2(Index).Close
End Sub

Private Sub Text1_Change()
    Text2 = Val(Text1) + 1
End Sub

Private Sub Timer1_Timer()
    PurgeExpiredBans
    TestResetDayStats
End Sub

Private Sub TestResetDayStats()
    If DateNextReset <> vbNullString Then
        If DateDiff("s", DateTime.Now, DateNextReset) <= 0 Then
            DateNextReset = DateAdd("d", 1, Now)
            SendChat "The server is resetting daily statistics... Prepare for chat lag.", 0, -1
            resetDayStats
            SendChat "Daily statistics reset complete. Next reset in 24 hours.", 0, -1
        End If
    End If
End Sub

Private Sub Timer3_Timer()
    Dim I As Integer, d2 As Date, j As Integer, B As Byte, L As Long, bParm As String
    Static ticker As Long
    Dim oNewMsg() As Byte, lNewOffset As Long
    Dim lNewMsg As Byte
    On Error Resume Next
    If NewGTC - ticker > 60000 Then
        For I = 1 To UBound(ServerDat)
            If Not ServerDat(I) Is Nothing Then
                If ServerDat(I).IPHost <> vbNullString Then
                    lNewMsg = 0
                    lNewOffset = 0
                    ReDim oNewMsg(0)
                    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
                    SendTo2 oNewMsg, I
                End If
            End If
        Next
        ticker = NewGTC
        'InitSocket
    End If
    
    d2 = DateAdd("n", Minute(Time), Date)
    d2 = DateAdd("h", Hour(Time), d2)
    d2 = DateAdd("s", Second(Time), d2)
    d2 = DateAdd("n", Val(bParm), d2)
    
    For I = 0 To UBound(Gags)
        If Trim$(Gags(I).GagName) <> vbNullString Then
            If d2 > Gags(I).GagExpire Then
                '
                For j = 1 To UBound(UserDat)
                    If Not UserDat(j) Is Nothing Then
                        If LCase$(UserDat(j).Nick) = LCase$(Trim$(Gags(I).GagName)) Then
                            UserDat(j).gagged = False
                            lNewMsg = MSG_ICON
                            lNewOffset = 0
                            ReDim oNewMsg(0)
                            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
                            AddBufferData oNewMsg, VarPtr(j), LenB(j), lNewOffset
                            If UserDat(j).Encryption > 0 Then B = 19
                            If Rooms(UserDat(j).Room).IsAdmin(UserDat(j).Nick) Then B = 13
                            If UserDat(j).Admin > 0 Then B = 11 + UserDat(j).Admin
                            If UserDat(j).Mode = 1 Then B = 17
                            If UserDat(j).gagged Then B = 18
                            UserDat(j).Icon = B
                            AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
                            'dps.SendTo gLobbyID, oNewMsg, 0, DPNSEND_GUARANTEED Or DPNSEND_NOLOOPBACK
                            SendTo oNewMsg, -1
                        End If
                        
                        If Err.Number <> 0 Then RemovePlayer UserDat(I).Nick
                        Err.Clear
                    End If
                Next
                '
                Gags(I).GagName = vbNullString
            End If
        End If
    Next
    For I = 0 To UBound(Bans)
        If Trim$(Bans(I).BanName) <> vbNullString Then
            If d2 > Bans(I).BanExpire Then Bans(I).BanName = vbNullString
        End If
    Next
    For I = 0 To UBound(Bans2)
        If Trim$(Bans2(I).BanIP) <> vbNullString Then
            If d2 > Bans2(I).BanExpire Then Bans2(I).BanIP = vbNullString
        End If
    Next
    For I = 0 To UBound(Bans3)
        If Trim$(Bans3(I).BanHD) <> 0 Then
            If d2 > Bans3(I).BanExpire Then Bans3(I).BanHD = 0
        End If
    Next
    If CmpDate <> Date Then
        L = NewGTC
    End If
End Sub

Function InitSocket() As Boolean
    Port = Val(Text1)
    Port2 = Val(Text2)
    Socket1(0).LocalPort = Port
    Socket1(0).Listen
    Socket2(0).LocalPort = Port2
    Socket2(0).Listen
    InitSocket = True
End Function
