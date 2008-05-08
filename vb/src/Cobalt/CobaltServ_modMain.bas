Attribute VB_Name = "modMain"
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
Public Const ServerName = "Cobalt"
Public Const InitMotd = "Welcome to Cobalt."
Public Const InitAdminMotd = "Stay sharp, don't be rude, and be patient with people!"
Public Const Company = "Cobalt Gaming Systems"
Public EncPassword As String
Public Encryption As New clsEncryption
Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationname As String, ByVal lpKeyName As Any, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long
Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationname As String, ByVal lpKeyName As Any, ByVal lpString As Any, ByVal lpFileName As String) As Long
Public Declare Function Shell_NotifyIcon Lib "shell32.dll" Alias "Shell_NotifyIconA" (ByVal dwMessage As Long, lpData As NOTIFYICONDATA) As Long
Public Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (hpvDest As Any, hpvSource As Any, ByVal cbCopy As Long)
Public Declare Function GetTickCount Lib "kernel32" () As Long
Public Declare Function GetVolumeInformation Lib "kernel32" Alias "GetVolumeInformationA" (ByVal lpRootPathName As String, ByVal lpVolumeNameBuffer As String, ByVal nVolumeNameSize As Long, lpVolumeSerial_Numberber As Long, lpMaximumComponentLength As Long, lpFileSystemFlags As Long, ByVal lpFileSystemNameBuffer As String, ByVal nFileSystemNameSize As Long) As Long

Public Type DevType
    Name As String
    Password As String
    eMail As String
End Type

Public Type NOTIFYICONDATA
    cbSize As Long
    hwnd As Long
    uID As Long
    uFlags As Long
    uCallbackMessage As Long
    hIcon As Long
    sTip As String * 64
End Type

Public sysIcon As NOTIFYICONDATA
Public Const NIM_ADD = &H0
Public Const NIM_DELETE = &H2
Public Const NIF_MESSAGE = &H1
Public Const NIF_ICON = &H2
Public Const NIF_TIP = &H4
Public Const NIF_DOALL = NIF_MESSAGE Or NIF_ICON Or NIF_TIP
Public Const WM_MOUSEMOVE = &H200
Public Const DQ As String = """"
Public Stopping As Boolean
Public Enum MSGTYPES
    MSG_COBALTID
    MSG_USERLOGIN
    MSG_ACCOUNT
    MSG_SIGNUP
    MSG_ADDUSER
    MSG_REMOVEUSER
    MSG_CHAT
    MSG_SERVERLOGIN
    MSG_ADDSERVER
    MSG_REMOVESERVER
    MSG_JOIN
    MSG_JOINED
    MSG_LEFT
    MSG_ICON
    MSG_PAGE
    MSG_PAGESTAT
    MSG_PROFILE
    MSG_PROFILEEDIT
    MSG_ZZZ
    MSG_ERROR
    MSG_OK
    MSG_UPDATE
    MSG_SVRADDPLAYER
    MSG_SVRREMOVEPLAYER
    MSG_SVRMRB
    MSG_MODE
    MSG_PASSWORDPROTECTED
    MSG_STATS
    MSG_ENC
    MSG_CLEAR
    MSG_ADDROOM
    MSG_REMOVEROOM
    MSG_JOINROOM
    MSG_CREATEROOM
End Enum

Public db As Database
Public conn As Connection
Public ws As Workspace
Public qQueryDef As QueryDef
Public rs As Recordset

Public Type svrp
    ScreenName As String
    ServerID As Long
    playerID As Long
    Frags As Integer
    OldFrags As Integer
    Deaths As Integer
    OldDeaths As Integer
    Caps As Integer
    Durration As Long
    Ship As Byte
End Type

Public Type Prof
    pAlias As String * 40
    pLocation As String * 55
    pBirthdate As String * 15
    pGender As String * 20
    pRelationship As String * 40
    pSite As String * 85
End Type

Public ProfileType As Prof

Public Type PStat
    DFrags As Long
    DDeaths As Long
    AFrags As Long
    ADeaths As Long
    NUptime As Long
    TUptime As Long
End Type

Public ProfileStats As PStat

Public Type GameDesc
    tMapname As String * 100
    tDescription As String * 200
    tHostedby As String * 20
    tMaxplayers As Byte
    tHoldtime As Byte
    tTimeLimit As Integer
    tLaserdamage As Byte
    tSpecialdamage As Byte
    tRechargerate As Byte
    tFlagreturn As Boolean
    tMissiles As Boolean
    tBombs As Boolean
    tBouncies As Boolean
    tMines As Boolean
    tPowerups As Boolean
    tDeathmatch As Boolean
End Type
Public GameDescription As GameDesc

Public Type Gagh
    GagName As String * 15
    GaggedBy As String * 15
    GagExpire As Date
End Type
Public Gags() As Gagh

Public Type Banh
    BanName As String * 15
    BannedBy As String * 15
    BanExpire As Date
End Type
Public Bans() As Banh

Public Type Banh2
    BanIP As String * 15
    BannedBy As String * 15
    BanExpire As Date
End Type
Public Bans2() As Banh2

Public Type Banh3
    BanName As String * 15
    BanHD As Long
    BannedBy As String * 15
    BanExpire As Date
End Type
Public Bans3() As Banh3

Public Type Banh4
    BanSysID As String
    BannedBy As String
    BanExpire As Date
End Type
Public Bans4() As Banh4

Public Type RealIP
    Name As String
    IP As String
End Type
Public LoginQueue() As RealIP

Public gMyPlayerID As Long, gLobbyID As Long, ARCmotd As String, AdminARCmotd As String, Reset As Boolean
Public CmpDate As Date, NoNewUsers As Boolean
Public VerifyName() As String, VerifyPassword() As String, VerifyID() As Long, Rooms() As clsChatRoom
Public DevArray() As DevType
Public Port As Long, Port2 As Long, g_AutoUpdate As Boolean, g_PaymentRequired As Integer
Public bEncPassword() As Byte
Public UserDat() As clsUserData, ServerDat() As clsGameData, svrPlayers() As svrp

Public Function LastMonth(dDate As Date) As Integer
    Dim I As Integer
    I = Month(dDate) - 1
    If I < 1 Then
        I = 12
    End If
    LastMonth = I
End Function

Public Sub ChatCommands(cmd As String, cmd2 As String, Admin As Byte, Who As Integer)
    Dim SQLString As String, rstmp As Recordset
    Dim aParm As String, bParm As String, newCmd As String, j As Integer, d2 As Date
    Dim I As Integer, B As Byte, L As Long, tmp As String, X As Integer
    Dim oNewMsg() As Byte, lNewOffset As Long
    Dim lNewMsg As Byte
    On Local Error Resume Next
    If Len(cmd) > 0 Then
        If InStr(Mid$(cmd, 2), " ") Then
            aParm = Mid$(cmd, 1, InStr(cmd, " ") - 1)
            newCmd = Mid$(cmd, InStr(cmd, " ") + 1)
        Else
            aParm = cmd
        End If
    End If
    aParm = LCase$(aParm)
    If Len(newCmd) > 1 And aParm <> "motd" And aParm <> "amotd" And aParm <> "announce" And aParm <> "a" And aParm <> "s" And aParm <> "d" Then
        If Mid$(newCmd, Len(newCmd)) = "'" Then
            newCmd = Mid$(newCmd, 2, Len(newCmd) - 2)
        Else
            If InStr(Mid$(newCmd, 2), "' ") Then
                bParm = LCase$(Mid$(newCmd, 2, InStr(newCmd, "' ") - 2))
                newCmd = Mid$(newCmd, InStr(newCmd, "' ") + 2)
            ElseIf InStr(Mid$(newCmd, 2), " ") Then
                bParm = LCase$(Mid$(newCmd, 1, InStr(newCmd, " ") - 1))
                newCmd = Mid$(newCmd, InStr(newCmd, " ") + 1)
            Else
                bParm = newCmd
            End If
        End If
    End If
    If aParm = "help" Or aParm = "?" And 0 Then
        I = 0
        SendChat "Normal User Commands:", I, Who
        SendChat " ", I, Who
        SendChat "/whisper name message Or /w (Private messages a person. This will also Whisper in a game the player is in.)", I, Who
        SendChat "/afk (Tells people you're Away From Keyboard. Zzz)", I, Who
        SendChat "/clear (Erases all chat text.)", I, Who
        SendChat "/find name (Locates what game a person is in.)", I, Who
        SendChat "/uptime (Displays how long the server has been online.)", I, Who
        SendChat "/version (Shows the version of the server)", I, Who
    End If
    
    If Admin > 0 Then
        If aParm = "help" Or aParm = "?" And 0 Then
            SendChat " ", I, Who
            SendChat " ", I, Who
            SendChat "Admin Commands:", I, Who
            SendChat " ", I, Who
            SendChat "/warn message (Prompts a person with a message.)", I, Who
            SendChat "/gag name minutes (Prevents a person from chatting in " & ServerName & " and games.)", I, Who
            SendChat "/gags (Shows who's gagged.)", I, Who
            SendChat "/announce message (Has " & ServerName & " announce a message to the Arena and all games.)", I, Who
            If Admin > 1 Then
                SendChat "/admins (See all Administrator accounts on the database.)", I, Who
                SendChat "/guides (See all Guide accounts on the database.)", I, Who
                SendChat "/motd message (Sets the ''Message of the Day'' thats displayed when you log in.)", I, Who
                SendChat "/obs (You will go in observation mode and players wont see you.", I, Who
                SendChat "/boot name (Will disconnect a person from the arena and the game server they are in.)", I, Who
                SendChat "/softboot name (Will disconnect a person from the game server they are in.)", I, Who
                SendChat "/ban name minutes (Ban an account from all of " & ServerName & ".)", I, Who
                SendChat "/ipban name minutes (Ban the user's IP from all of " & ServerName & ".)", I, Who
                SendChat "/hdban name minutes (Ban the user's Hard Drive Serial from all of " & ServerName & ".)", I, Who
                SendChat "/banip ipaddress minutes (Ban an IP from all of " & ServerName & ". User a * for the last number group of an IP to ban a range like 255.255.255.*)", I, Who
                SendChat "/iplist (See user's IP's.)", I, Who
                SendChat "/bans, /ipbans, /hdbans, /sysidbans (List bans.)", I, Who
                SendChat "BANNING - To remove a ban, reban with the banned format and use 0 minutes.", I, Who
                SendChat "The max time can be 99999 minutes for bans and gags", I, Who
            End If
        End If
    End If
    
    If aParm = "myserial" Then
        SendChat UserDat(Who).HDSerial, 0, Who
    End If
    
    If aParm = "listen" And Admin > 3 Then
        frmMain.Socket1(0).Close
        frmMain.Socket1(0).Listen
        frmMain.Socket2(0).Close
        frmMain.Socket2(0).Listen
        SendChat "This server is now open to connections.", 0, Who
    End If
    
    If aParm = "close" And Admin > 3 Then
        frmMain.Socket1(0).Close
        frmMain.Socket2(0).Close
        SendChat "This server is now closed to connections.", 0, Who
    End If
    
    If aParm = "version" Then
        SendChat "Cobalt Server: version " & App.Major & "." & Format(App.Minor, "00") & "." & Format(App.Revision, "0000"), 0, Who
    End If
    
    If aParm = "enumusers" And Admin > 2 Then
        SQLString = "SELECT * FROM ACCOUNTS"
        Set rstmp = db.OpenRecordset(SQLString)
        I = 0
        Do While Not rstmp.EOF
            rstmp.MoveNext
            I = I + 1
        Loop
        SendChat "There are " & I & " users total.", 0, Who
    End If
    
    If aParm = "expiration" And Admin > 0 Then
        If bParm <> vbNullString Then
            SendChat "Account " & bParm & " expires: " & Expiration(bParm), 0, Who
        End If
    End If
 
    If aParm = "prune" And Admin > 3 Then
        PruneUsers Who
    End If
    
    If aParm = "s" And Admin > 0 Then
        If newCmd = vbNullString Then Exit Sub
        For I = 1 To UBound(UserDat)
            If Not UserDat(I) Is Nothing Then
                If UserDat(I).Admin > 0 Then SendChat "&FF8800&<Staff [" & UserDat(Who).Nick & "]> " & newCmd & vbNullString, 0, I
            End If
        Next
    End If
    
    If aParm = "a" And Admin > 1 Then
        If newCmd = vbNullString Then Exit Sub
        For I = 1 To UBound(UserDat)
            If Not UserDat(I) Is Nothing Then
                If UserDat(I).Admin > 1 Then SendChat "&FF6600&<Admins [" & UserDat(Who).Nick & "]> " & newCmd & vbNullString, 0, I
            End If
        Next
    End If
    
    If aParm = "sa" And Admin > 3 Then
        If newCmd = vbNullString Then Exit Sub
        For I = 1 To UBound(UserDat)
            If Not UserDat(I) Is Nothing Then
                If UserDat(I).Admin > 0 Then SendChat "&0044FF&<Staff Admins [" & UserDat(Who).Nick & "]> " & newCmd & vbNullString, 0, I
            End If
        Next
    End If
    
    If aParm = "d" And Admin > 4 Then
        If newCmd = vbNullString Then Exit Sub
        For I = 1 To UBound(UserDat)
            If Not UserDat(I) Is Nothing Then
                If UserDat(I).Admin > 4 Then SendChat "&0000FF&<Developers [" & UserDat(Who).Nick & "]> " & newCmd & vbNullString, 0, I
            End If
        Next
    End If
    
    If aParm = "announce" And Admin > 0 Then
        If newCmd = vbNullString Then Exit Sub
        tmp = newCmd & " (" & UserDat(Who).Nick & ")"
        SendChat tmp, 0, -1
        lNewMsg = 13
        lNewOffset = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
        I = -1
        AddBufferData oNewMsg, VarPtr(I), LenB(I), lNewOffset
        AddBufferString oNewMsg, tmp, lNewOffset, True
        For I = 1 To UBound(ServerDat)
            If Not ServerDat(I) Is Nothing Then
                SendTo2 oNewMsg, I
            End If
        Next
    End If
    
    If aParm = "forceupdate" And Admin = 5 Then
        If bParm <> vbNullString Then
            I = GetPN2(bParm)
            lNewMsg = MSG_UPDATE
            lNewOffset = 0
            ReDim oNewMsg(0)
            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
            tmp = "www.uplinklabs.net"
            AddBufferString oNewMsg, tmp, lNewOffset
            tmp = newCmd
            AddBufferString oNewMsg, tmp, lNewOffset
            SendTo oNewMsg, I
            SendChat "The player is checking for updates.", 0, Who
            g_AutoUpdate = True
        Else
            SendChat "Failure to send, no user specified.", 0, Who
        End If
    End If
    
    If aParm = "newversion" And Admin = 5 Then
        lNewMsg = MSG_UPDATE
        lNewOffset = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
        tmp = "osdn.dl.sourceforge.net"
        AddBufferString oNewMsg, tmp, lNewOffset
        tmp = "http://osdn.dl.sourceforge.net/sourceforge/openarc/core_setup_dec_15_2005.exe"
        AddBufferString oNewMsg, tmp, lNewOffset
        SendTo oNewMsg, -1
        SendChat "All players are checking for updates.", 0, Who
        g_AutoUpdate = True
    End If
    
    If aParm = "roomlist" And Admin > 2 Then
        For I = 0 To UBound(Rooms)
            If Not IsEmptyString(Rooms(I).RoomName) Then
                SendChat I & ": " & Rooms(I).RoomName, 0, Who
            End If
        Next
    End If
    
    If aParm = "killroom" And Admin > 2 Then
        If newCmd = "" Then Exit Sub
        If CInt(newCmd) > 0 And CInt(newCmd) <= UBound(Rooms) Then
            DeleteRoom CInt(newCmd)
        End If
    End If
    
    If aParm = "reqpayment" And Admin = 5 Then
        If frmMain.Check1.Value = 0 Then
            SendChat "Payment prerequisite is now enabled for new users.", 0, Who
            frmMain.Check1.Value = 1
            g_PaymentRequired = True
        Else
            SendChat "Payment prerequisite is now disabled for all users.", 0, Who
            frmMain.Check1.Value = 0
            g_PaymentRequired = False
        End If
    End If
    
    If (aParm = "gag") And (Admin > 0 Or Rooms(UserDat(Who).Room).IsAdmin(UserDat(Who).Nick)) Then
        I = GetPN2(bParm)
        If Val(newCmd) > 99999 Then newCmd = 99999
        If Admin > Val(GetField(bParm, 3)) Then
            d2 = DateAdd("n", Minute(Time), Date)
            d2 = DateAdd("h", Hour(Time), d2)
            d2 = DateAdd("s", Second(Time), d2)
            d2 = DateAdd("n", Val(newCmd), d2)
            Gag bParm, d2, UserDat(Who).Nick
            If d2 > Now Then UserDat(I).gagged = True
            If I > 0 Then
                SendChat UserDat(I).Nick & " is gagged by their ip for " & Val(newCmd) & " minutes.", 0, Who
            Else
                SendChat "Gag added. But this user is not logged on to " & ServerName & " so the gag will not send to game servers.", 0, Who
                Exit Sub
            End If
            lNewMsg = MSG_ICON
            lNewOffset = 0
            ReDim oNewMsg(0)
            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
            AddBufferData oNewMsg, VarPtr(I), LenB(I), lNewOffset
            If UserDat(I).gagged Then B = 18
            UserDat(I).Icon = B
            AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
            'dps.SendTo gLobbyID, oNewMsg, 0, DPNSEND_GUARANTEED Or DPNSEND_NOLOOPBACK
            SendTo oNewMsg, -1
            If UserDat(I).game <> 0 Then
                lNewMsg = 38
                lNewOffset = 0
                ReDim oNewMsg(0)
                AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
                L = UserDat(I).gameID
                AddBufferData oNewMsg, VarPtr(L), LenB(L), lNewOffset
                j = UserDat(I).gagged
                AddBufferData oNewMsg, VarPtr(j), LenB(j), lNewOffset
                'dps.SendTo UserDat(i).game, oNewMsg, 0, DPNSEND_GUARANTEED Or DPNSEND_NOLOOPBACK
                SendTo oNewMsg, UserDat(I).game
            End If
        ElseIf Rooms(UserDat(Who).Room).IsAdmin(UserDat(Who).Nick) And Val(GetField(bParm, 3)) < 1 Then
            d2 = DateAdd("n", Minute(Time), Date)
            d2 = DateAdd("h", Hour(Time), d2)
            d2 = DateAdd("s", Second(Time), d2)
            d2 = DateAdd("n", Val(newCmd), d2)
            Gag bParm, d2, UserDat(Who).Nick, UserDat(Who).Room
            If d2 > Now Then UserDat(I).gagged = True Else UserDat(I).gagged = False
            If I > 0 Then
                SendChat UserDat(I).Nick & " is gagged by their ip for " & Val(newCmd) & " minutes.", 0, Who
            Else
                SendChat "Gag added. But this user is not logged on to " & ServerName & " so the gag will not send to game servers.", 0, Who
                Exit Sub
            End If
            lNewMsg = MSG_ICON
            lNewOffset = 0
            ReDim oNewMsg(0)
            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
            AddBufferData oNewMsg, VarPtr(I), LenB(I), lNewOffset
            B = 19
            If Rooms(UserDat(Who).Room).IsAdmin(UserDat(I).Nick) Then B = 13
            If UserDat(I).Admin > 0 Then B = UserDat(I).Admin + 11
            If UserDat(I).gagged Then B = 18
            UserDat(I).Icon = B
            AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
            'dps.SendTo gLobbyID, oNewMsg, 0, DPNSEND_GUARANTEED Or DPNSEND_NOLOOPBACK
            SendToRoom oNewMsg, UserDat(Who).Room
            If UserDat(I).game <> 0 Then
                lNewMsg = 38
                lNewOffset = 0
                ReDim oNewMsg(0)
                AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
                L = UserDat(I).gameID
                AddBufferData oNewMsg, VarPtr(L), LenB(L), lNewOffset
                j = UserDat(I).gagged
                AddBufferData oNewMsg, VarPtr(j), LenB(j), lNewOffset
                'dps.SendTo UserDat(i).game, oNewMsg, 0, DPNSEND_GUARANTEED Or DPNSEND_NOLOOPBACK
                SendTo oNewMsg, UserDat(I).game
            End If
        Else
            SendChat "You can only gag users with lower rank!", 0, Who
        End If
    End If
    
    If (aParm = "kick" Or aParm = "boot") And (Admin > 1 Or Rooms(UserDat(Who).Room).IsAdmin(UserDat(Who).Nick)) Then
        I = GetPN2(bParm)
        If I = Who Then SendError "Kick yourself?", I, 0: Exit Sub
        If StringComp(newCmd, bParm) Then newCmd = vbNullString
        If I = 0 Then Exit Sub
        If Admin > UserDat(I).Admin Then
            Kick I, Who, 1, newCmd
        ElseIf Rooms(UserDat(Who).Room).IsAdmin(UserDat(Who).Nick) Then
            Kick I, Who, 1, newCmd, UserDat(Who).Room
        End If
    End If
    
    If aParm = "softboot" And Admin > 1 Then
        I = GetPN2(newCmd)
        If Admin > 1 Then Kick I, Who, 2
    End If
    
    If aParm = "resetstats" And Admin > 1 Then
        ResetStats newCmd
    End If
    
    If aParm = "obs" And Admin > 3 Then
        If aParm = "obs" Then I = 1
        j = Who
        If bParm <> vbNullString Then j = GetPN2(bParm)
        If j = 0 Then Exit Sub
        lNewMsg = MSG_MODE
        lNewOffset = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
        AddBufferData oNewMsg, VarPtr(j), LenB(j), lNewOffset
        If UserDat(j).Mode = I Then
            UserDat(j).Mode = 0
            B = 0
        Else
            UserDat(j).Mode = I
            B = I
        End If
        AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
        If B = 0 Then tmp = GetField(UserDat(j).Nick, 6)
        If B = 1 Then tmp = GetField(UserDat(j).Nick, 7)
        If tmp = vbNullString Then tmp = "hi"
        AddBufferString oNewMsg, tmp, lNewOffset
        SendTo oNewMsg, -1
        If B = 1 Then
            SendChat "You are now in observation mode.", 0, j
        ElseIf B = 0 Then
            SendChat "You are now out of the previous mode.", 0, j
        End If
        If UserDat(j).Icon = 1 Or UserDat(j).Icon = 2 Then Exit Sub
        lNewMsg = MSG_ICON
        lNewOffset = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
        AddBufferData oNewMsg, VarPtr(j), LenB(j), lNewOffset
        If UserDat(Who).Encryption > 0 Then B = 19
        If Rooms(UserDat(Who).Room).IsAdmin(UserDat(Who).Nick) Then B = 13
        If UserDat(Who).Admin > 0 Then B = 11 + UserDat(j).Admin
        If UserDat(Who).Mode = 1 Then B = 17
        If UserDat(Who).gagged Then B = 18
        UserDat(j).Icon = B
        AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
        SendTo oNewMsg, -1
    End If
    
    If aParm = "banip" And Admin > 2 Then
        If bParm = vbNullString Then Exit Sub
        If Val(newCmd) > 99999 Then newCmd = 99999
        d2 = DateAdd("n", Minute(Time), Date)
        d2 = DateAdd("h", Hour(Time), d2)
        d2 = DateAdd("s", Second(Time), d2)
        d2 = DateAdd("n", Val(newCmd), d2)
        If Ban2(bParm, d2, UserDat(Who).Nick) Then
            SendChat "The IP is banned for " & Val(newCmd) & " minutes.", 0, Who
        Else
            SendChat "Invalid IP", 0, Who
        End If
    End If
    
    If aParm = "bansysid" And Admin > 2 Then
        If bParm = vbNullString Then Exit Sub
        If Val(newCmd) > 99999 Then newCmd = 99999
        d2 = DateAdd("n", Minute(Time), Date)
        d2 = DateAdd("h", Hour(Time), d2)
        d2 = DateAdd("s", Second(Time), d2)
        d2 = DateAdd("n", Val(newCmd), d2)
        I = GetPN2(bParm)
        If Ban4(I, d2, UserDat(Who).Nick) Then
            If Admin > UserDat(I).Admin Then Kick I, Who, 1
            SendChat "The unique system ID is banned for " & Val(newCmd) & " minutes.", 0, Who
        Else
            SendChat "Invalid ID", 0, Who
        End If
    End If
    
    If aParm = "ban" And (Admin > 1 Or Rooms(UserDat(Who).Room).IsAdmin(UserDat(Who).Nick)) Then
        If bParm = vbNullString Then Exit Sub
        If I = Who Then SendError "Kick yourself?", I, 0: Exit Sub
        If Val(GetField(bParm, 3)) < Admin Then
            If Val(newCmd) > 99999 Then newCmd = 99999
            I = GetPN2(bParm)
            d2 = DateAdd("n", Minute(Time), Date)
            d2 = DateAdd("h", Hour(Time), d2)
            d2 = DateAdd("s", Second(Time), d2)
            d2 = DateAdd("n", Val(newCmd), d2)
            Ban bParm, d2, UserDat(Who).Nick
            Kick I, Who, 1, vbNullString
            SendChat bParm & " is name banned for " & Val(newCmd) & " minutes.", 0, Who
        ElseIf Rooms(UserDat(Who).Room).IsAdmin(UserDat(Who).Nick) Then
            If Val(newCmd) > 99999 Then newCmd = 99999
            I = GetPN2(bParm)
            d2 = DateAdd("n", Minute(Time), Date)
            d2 = DateAdd("h", Hour(Time), d2)
            d2 = DateAdd("s", Second(Time), d2)
            d2 = DateAdd("n", Val(newCmd), d2)
            Rooms(UserDat(Who).Room).Ban bParm, d2, UserDat(Who).Nick
            Kick I, Who, 1, vbNullString, UserDat(Who).Room
            SendChat bParm & " is banned from the room for " & Val(newCmd) & " minutes.", 0, Who, UserDat(Who).Room
        Else
            SendChat "You can't ban someone with a higher rank!", 0, Who
        End If
    End If
    
    If aParm = "ipban" And Admin > 2 Then
        If bParm = vbNullString Then Exit Sub
        If Val(newCmd) > 99999 Then newCmd = 99999
        I = GetPN2(bParm)
        If I = 0 Then Exit Sub
        If Admin > UserDat(I).Admin Then
            d2 = DateAdd("n", Minute(Time), Date)
            d2 = DateAdd("h", Hour(Time), d2)
            d2 = DateAdd("s", Second(Time), d2)
            d2 = DateAdd("n", Val(newCmd), d2)
            If Ban2(UserDat(I).IP, d2, UserDat(Who).Nick) Then
                SendChat bParm & " is IP banned for " & Val(newCmd) & " minutes.", 0, Who
            Else
                SendChat bParm & " user has an invalid IP.", 0, Who
            End If
            If Admin > UserDat(I).Admin Then Kick I, Who, 1
        Else
            SendChat "You can't ban an admin!", 0, Who
        End If
    End If
    
    If aParm = "hdban" And Admin > 2 Then
        If bParm = vbNullString Then Exit Sub
        If Val(newCmd) > 99999 Then newCmd = 99999
        I = GetPN2(bParm)
        If I = 0 Then
            If Ban3(bParm, 0, d2, UserDat(Who).Nick) Then
                SendChat "The user was Hard Drive Serial banned for " & Val(newCmd) & " minutes.", 0, Who
            End If
            Exit Sub
        End If
        If Admin > UserDat(I).Admin Then
            d2 = DateAdd("n", Minute(Time), Date)
            d2 = DateAdd("h", Hour(Time), d2)
            d2 = DateAdd("s", Second(Time), d2)
            d2 = DateAdd("n", Val(newCmd), d2)
            If Ban3(UserDat(I).Nick, UserDat(I).HDSerial, d2, UserDat(Who).Nick) Then
                SendChat "The user was Hard Drive Serial banned for " & Val(newCmd) & " minutes.", 0, Who
            Else
                SendChat "Unable to ban!", 0, Who
            End If
            Kick I, Who, 1
        Else
            SendChat "You can't ban an admin!", 0, Who
        End If
    End If
    
    If aParm = "iplist" And Admin > 3 Then
        If bParm = "nocensor" Then
            For I = 1 To UBound(UserDat)
                If Not UserDat(I) Is Nothing Then
                    If Not LenB(UserDat(I).Nick) = 0 Then
                        SendChat UserDat(I).Nick & "  " & UserDat(I).IP, 0, Who
                    End If
                End If
            Next
        Else
            For I = 1 To UBound(UserDat)
                If Not UserDat(I) Is Nothing Then
                    If Not LenB(UserDat(I).Nick) = 0 Then
                        tmp = MaskIP(UserDat(I).IP)
                        SendChat UserDat(I).Nick & "  " & tmp, 0, Who
                    End If
                End If
            Next
        End If
    End If
    
    If aParm = "hdlist" And Admin > 2 Then
        For I = 1 To UBound(UserDat)
            If Not UserDat(I) Is Nothing Then
                SendChat UserDat(I).Nick & "  " & UserDat(I).HDSerial, 0, Who
            End If
        Next
    End If
    
    If aParm = "sysidlist" And Admin > 2 Then
        For I = 1 To UBound(UserDat)
            If Not UserDat(I) Is Nothing Then
                SendChat UserDat(I).Nick & "  " & UserDat(I).SysID, 0, Who
            End If
        Next
    End If
    
    If aParm = "bans" And Admin > 1 Then
        For I = 0 To UBound(Bans)
            If Trim$(Bans(I).BanName) <> vbNullString Then B = 1: SendChat Trim$(Bans(I).BanName) & " banned by: " & Trim$(Bans(I).BannedBy) & " expires: " & Bans(I).BanExpire, 0, Who
        Next
        If B = 0 Then SendChat "There are no Account Bans.", 0, Who
    End If
    
    If aParm = "ipbans" And Admin > 1 Then
        For I = 0 To UBound(Bans2)
            If Trim$(Bans2(I).BanIP) <> vbNullString Then
                B = 1
                SendChat Trim$(Bans2(I).BanIP) & " banned by: " & Trim$(Bans2(I).BannedBy) & " expires: " & Bans2(I).BanExpire, 0, Who
            End If
        Next
        If B = 0 Then SendChat "There are no IP Bans.", 0, Who
    End If
    
    If aParm = "hdbans" And Admin > 1 Then
        For I = 0 To UBound(Bans3)
            If Trim$(Bans3(I).BanHD) <> 0 Then B = 1: SendChat Trim$(Bans3(I).BanName) & " serial banned by: " & Trim$(Bans3(I).BannedBy) & " expires: " & Bans3(I).BanExpire, 0, Who
        Next
        If B = 0 Then SendChat "There are no hard drive serial bans.", 0, Who
    End If
    
    If aParm = "sysidbans" And Admin > 1 Then
        For I = 0 To UBound(Bans4)
            If Trim$(Replace(Bans4(I).BanSysID, Chr(0), vbNullString)) <> vbNullString Then
                B = 1
                SendChat Trim$(Bans4(I).BanSysID) & " system ID banned by: " & Trim$(Bans4(I).BannedBy) & " expires: " & Bans4(I).BanExpire, 0, Who
            End If
        Next
        If B = 0 Then SendChat "There are no unique system identification number bans.", 0, Who
    End If
    
    If aParm = "gags" And Admin > 0 Then
        For I = 1 To UBound(UserDat)
            If Not UserDat(I) Is Nothing Then
                If UserDat(I).gagged Then B = 1: SendChat UserDat(I).Nick & " is gagged.", 0, Who
            End If
        Next
        If B = 0 Then SendChat "There are no Gags.", 0, Who
    End If
    
    If aParm = "destroy" And Admin > 1 Then
        I = Val(newCmd)
        If I < 1 Then Exit Sub
        If I > UBound(ServerDat) Then Exit Sub
        tmp = "!!NOTICE!! Your server was booted from the arena."
        lNewMsg = 255
        lNewOffset = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
        B = 1
        AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
        AddBufferString oNewMsg, tmp, lNewOffset, True
        SendTo2 oNewMsg, I
        'RemoveServer I
        'Socket2(I).Close
    End If
    
    If aParm = "motd" And Admin > 1 Then
        If newCmd = vbNullString Then Exit Sub
        ARCmotd = newCmd
        SendChat "Message of the Day set.", 0, Who
    End If
    
    If aParm = "viewmotd" Then
        SendChat ARCmotd, 0, Who
    End If
    
    If aParm = "amotd" And Admin > 1 Then
        If newCmd = vbNullString Then Exit Sub
        AdminARCmotd = newCmd
        SendChat "Staff Message of the Day set.", 0, Who
    End If
    
    If (aParm = "globalclear" Or aParm = "gc") And Admin > 0 Then
        lNewMsg = MSG_CLEAR
        lNewOffset = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
        For I = 1 To UBound(UserDat)
            If UserDat(I).Admin = 0 Then SendTo oNewMsg, I
        Next
        SendChat "Chat cleared by " & UserDat(Who).Nick & ".", 0, -1
    End If
    
    If aParm = "warn" And Admin > 3 Then
        If newCmd = vbNullString Then Exit Sub
        I = GetPN2(bParm)
        If I = 0 Then Exit Sub
        SendError "Administrative Message: " & vbCrLf & newCmd, I, 0
    End If
    
    If aParm = "fetch" And Admin = 5 Then
        If UserAccount(newCmd) Then
            SendChat GetField(newCmd, 1), 0, Who
        End If
    End If
    
    If aParm = "serverpw" And Admin > 1 Then
        I = Val(newCmd)
        If Not ServerDat(I) Is Nothing Then
            tmp = "pw to " & ServerDat(I).sName & " = " & ServerDat(I).Password
            SendChat tmp, 0, Who
        End If
    End If
    
    If aParm = "die" And Admin = 5 Then
        frmMain.Socket1(0).Close
        frmMain.Socket2(0).Close
        End
    End If
    
    If aParm = "reset" And Admin = 5 Then
        SendChat "Server resetting. Will return shortly.", 0, -1
        Pause 2000
        Reset = True
        Unload frmMain
    End If
    
    If aParm = "signup" And Admin = 5 Then
        NoNewUsers = Not NoNewUsers
        If NoNewUsers Then
            SendChat "Signup disabled", 0, Who
        Else
            SendChat "Signup enabled", 0, Who
        End If
    End If
    
    If aParm = "makeguide" And Admin > 3 Then
        If GetField(newCmd, 3) < Admin Then
            If UserStatus(newCmd, 1) Then
                SendChat "User is granted guide powers.", 0, Who
            Else
                SendChat "User does not exist.", 0, Who
            End If
        Else
            SendChat "You can't perform this attribute on this user.", 0, Who
        End If
    End If
    
    If aParm = "maketadmin" And Admin > 3 Then
        If GetField(newCmd, 3) < Admin Then
            If UserStatus(newCmd, 4) Then
                SendChat "User is granted tentative admin powers.", 0, Who
            Else
                SendChat "User does not exist.", 0, Who
            End If
        Else
            SendChat "You can't perform this attribute on this user.", 0, Who
        End If
    End If
    
    If aParm = "makeadmin" And Admin > 3 Then
        If GetField(newCmd, 3) < Admin Then
            If UserStatus(newCmd, 3) Then
                SendChat "User is granted admin powers.", 0, Who
            Else
                SendChat "User does not exist.", 0, Who
            End If
        Else
            SendChat "You can't perform this attribute on this user.", 0, Who
        End If
    End If
    
    If aParm = "makesadmin" And Admin = 5 Then
        If GetField(newCmd, 3) < Admin Then
            If UserStatus(newCmd, 4) Then
                SendChat "User is granted staff admin powers.", 0, Who
            Else
                SendChat "User does not exist.", 0, Who
            End If
        Else
            SendChat "You can't perform this attribute on this user.", 0, Who
        End If
    End If
    
    If aParm = "demote" And Admin > 2 Then
        If GetField(newCmd, 3) < Admin Or UserDat(Who).Nick = "tycho" Then
            If UserStatus(bParm, 0) Then
                SendChat "User account privileges removed.", 0, Who
            Else
                SendChat "User does not exist.", 0, Who
            End If
        Else
            SendChat "You can't perform this attribute on this user.", 0, Who
        End If
    End If
    
    If aParm = "deop" And Rooms(UserDat(Who).Room).IsAdmin(UserDat(Who).Nick) Then
        If IsEmptyString(bParm) Then Exit Sub
        Rooms(UserDat(Who).Room).Demote bParm
    End If
    
    If aParm = "op" And Rooms(UserDat(Who).Room).IsAdmin(UserDat(Who).Nick) Then
        If IsEmptyString(bParm) Then Exit Sub
        Rooms(UserDat(Who).Room).Promote bParm
    End If
    
    If aParm = "deluser" And Admin = 5 Then
        If Not UserAccount(newCmd) Then
            SendChat "User not found.", 0, Who
        Else
            UserDel newCmd
            SendChat "User account removed from database.", 0, Who
        End If
    End If
    
    If aParm = "icon" And Admin > 3 Then
        If Val(newCmd) > 254 Then newCmd = 254
        newCmd = Val(newCmd)
        I = GetPN2(bParm)
        tmp = vbNullString
        If UserDat(I) Is Nothing Then Exit Sub
        If UserDat(Who).Admin < UserDat(I).Admin Then tmp = "You don't have permission to change this user's icon."
        If UserDat(Who).Admin = 0 And Who <> I Then tmp = "You aren't allowed to change the icon of another user."
        If UserDat(Who).Admin = 0 And Val(newCmd) < 20 Then tmp = "You can only choose icons above index 19."
        If tmp <> vbNullString Then SendChat tmp, 0, Who: Exit Sub
        lNewMsg = MSG_ICON
        lNewOffset = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
        AddBufferData oNewMsg, VarPtr(I), LenB(I), lNewOffset
        UserDat(I).Icon = newCmd
        B = newCmd
        AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
        SendTo oNewMsg, -1
    End If
    
    If aParm = "whisper" Or aParm = "w" Then
        If newCmd = vbNullString Then Exit Sub
        j = GetPN2(bParm)
        If UserDat(j) Is Nothing Then Exit Sub
        If UserDat(j).Mode = 1 And UserDat(Who).Admin < 1 Then Exit Sub
        If j > 0 Then
            SendChat "&77FF00&<whisper to " & UserDat(j).Nick & "> " & newCmd, 0, Who
            SendChat "&77FF00&<whisper from " & UserDat(Who).Nick & "> " & newCmd, 0, j
        End If
        For X = 0 To UBound(svrPlayers)
            If LCase$(svrPlayers(X).ScreenName) = LCase$(bParm) Then
                I = svrPlayers(X).playerID
                If I > 0 Then
                    tmp = UserDat(Who).Nick & ": <whispers> " & newCmd
                    lNewMsg = 13
                    lNewOffset = 0
                    ReDim oNewMsg(0)
                    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
                    AddBufferData oNewMsg, VarPtr(I), LenB(I), lNewOffset
                    AddBufferString oNewMsg, tmp, lNewOffset, True
                    SendTo2 oNewMsg, I
                    If j = 0 Then SendChat "<whisper from " & UserDat(Who).Nick & "> " & newCmd, 0, Who
                    Exit For
                End If
            End If
        Next
    End If
    
    'If aParm = "uptime" And 0 Then
    '    j = DateDiff("s", DateStarted, Now)
    '    SendChat "Server uptime: " & GetDiffString(CLng(j)), 0, Who
    '    'Note: Having 24-hour format on the machine will make this work properly. *SOMETIMES*
    'End If
    
    If aParm = "find" Then
        For I = 1 To UBound(UserDat)
            If Not UserDat(I) Is Nothing Then If LCase$(newCmd) = LCase$(UserDat(I).Nick) And UserDat(I).Mode = 0 Then Exit For
        Next
        If I > UBound(UserDat) Then
            SendChat "User is not online.", 0, Who
        Else
            SendChat "User is in the room '" & Rooms(UserDat(I).Room).RoomName & "'.", 0, Who
        End If
        For I = 0 To UBound(svrPlayers)
            If LCase$(newCmd) = LCase$(svrPlayers(I).ScreenName) Then Exit For
        Next
        If I > UBound(UserDat) Then
            SendChat "User is not in a game.", 0, Who
        Else
            For j = 1 To UBound(ServerDat)
                If Not ServerDat(j) Is Nothing Then
                    If ServerDat(j).id = svrPlayers(I).ServerID Then
                        SendChat "User is playing in " & ServerDat(j).sName, 0, Who
                        Exit For
                    End If
                End If
            Next
            If j > UBound(ServerDat) Then SendChat "User is not in a game.", 0, Who
        End If
    End If
    
    If aParm = "remuser" And Admin = 5 Then
        RemovePlayer CInt(Val(newCmd))
    End If
    
    If aParm = "killuser" And Admin = 5 Then
        I = GetPN2(bParm)
        If I > 0 Then
            RemovePlayer I
            frmMain.Socket1(I).Close
        End If
    End If
    
    If aParm = "killserverlog" And Admin = 5 Then
        Kill AppPath & "serverlog.txt"
        SendChat "log deleted.", 0, Who
    End If
    
    If aParm = "killiplog" And Admin = 5 Then
        Kill AppPath & "iplog.txt"
        SendChat "IP log deleted.", 0, Who
    End If
    
    If aParm = "viewiplog" And Admin = 5 Then
        Open AppPath & "iplog.txt" For Input As #1
        While Not EOF(1)
            Line Input #1, tmp
            SendChat tmp, 0, Who
        Wend
        Close #1
    End If
    
    If aParm = "admins" And Admin > 0 Then
        SQLString = "SELECT * FROM ACCOUNTS where Status = " & 3
        Set rstmp = db.OpenRecordset(SQLString)
        SendChat "Administrators", 0, Who
        SendChat "--------------", 0, Who
        Do While Not rstmp.EOF
            SendChat rstmp.Fields(0), 0, Who
            rstmp.MoveNext
        Loop
    End If
    
    If aParm = "tadmins" And Admin > 0 Then
        SQLString = "SELECT * FROM ACCOUNTS where Status = " & 2
        Set rstmp = db.OpenRecordset(SQLString)
        SendChat "Tentative Admins", 0, Who
        SendChat "----------------", 0, Who
        Do While Not rstmp.EOF
            SendChat rstmp.Fields(0), 0, Who
            rstmp.MoveNext
        Loop
    End If
    
    If aParm = "sadmins" And Admin > 0 Then
        SQLString = "SELECT * FROM ACCOUNTS where Status = " & 4
        Set rstmp = db.OpenRecordset(SQLString)
        SendChat "Staff Admins", 0, Who
        SendChat "----------------", 0, Who
        Do While Not rstmp.EOF
            SendChat rstmp.Fields(0), 0, Who
            rstmp.MoveNext
        Loop
    End If
    
    If aParm = "developers" And Admin > 1 Then
        SQLString = "SELECT * FROM ACCOUNTS where Status = " & 5
        Set rstmp = db.OpenRecordset(SQLString)
        SendChat "Developers", 0, Who
        SendChat "----------", 0, Who
        Do While Not rstmp.EOF
            SendChat rstmp.Fields(0), 0, Who
            rstmp.MoveNext
        Loop
    End If
    
    If aParm = "guides" And Admin > 0 Then
        SQLString = "SELECT * FROM ACCOUNTS where Status = " & 1
        Set rstmp = db.OpenRecordset(SQLString)
        SendChat "Guides", 0, Who
        SendChat "------", 0, Who
        Do While Not rstmp.EOF
            SendChat rstmp.Fields(0), 0, Who
            rstmp.MoveNext
        Loop
    End If

    If aParm = "staff" And Admin > 0 Then
        SQLString = "SELECT * FROM ACCOUNTS WHERE Status > 0 ORDER BY Status DESC"
        Set rstmp = db.OpenRecordset(SQLString)
        SendChat "Staff", 0, Who
        SendChat "-----", 0, Who
        Do While Not rstmp.EOF
            tmp = GetAdminType(rstmp.Fields(3))
            SendChat tmp & ": " & rstmp.Fields(0), 0, Who
            rstmp.MoveNext
        Loop
    End If
    
End Sub

Private Function GetAdminType(TypeNum As Integer) As String
    Select Case TypeNum
        Case 1
            GetAdminType = "Guide"
        Case 2
            GetAdminType = "Tentative Admin"
        Case 3
            GetAdminType = "Admin"
        Case 4
            GetAdminType = "Staff Admin"
        Case 5
            GetAdminType = "Developer"
        Case Else
            GetAdminType = "Unknown"
    End Select
End Function

Public Function DataProcess2(ReceivedData() As Byte, ReceivedLen As Integer, pID As Integer) As Integer
    Dim FromPlayerName As String, I As Integer, B As Byte, X As Integer, Y As Integer, L As Long, L2 As Long
    Dim tmp As String, tmp2 As String, Tmp3 As String, j As Integer, b2 As Byte, Tmp4 As String, lMsg As Byte
    Dim MSGOK As Boolean
    '
    Dim lOffset As Long
    Dim oNewMsg() As Byte, lNewOffset As Long
    Dim lNewMsg As Byte
    
    If Not pID > UBound(UserDat) Then If Not UserDat(pID) Is Nothing Then FromPlayerName = UserDat(pID).Nick
    On Error GoTo done
nextpacket:
    MSGOK = False
    GetBufferData ReceivedData, VarPtr(lMsg), LenB(lMsg), lOffset, pID, True
    Select Case lMsg
    Case 0
        GoTo done
    Case MSG_SERVERLOGIN
        MSGOK = True
        Dim srGI As String, srSN As String, srPW As String, srDC As String, PassProtect As Boolean
        Dim sLevel(4) As String, srGN As String, srIP As String, srSerial As Long, srGameType As Byte, srMP As String
        Dim srTimeLimit As Integer, pwprotect As Boolean, srSP As String, srPort As Long, srPort2 As Long
        sLevel(0) = "Very Low"
        sLevel(1) = "Low"
        sLevel(2) = "Medium"
        sLevel(3) = "High"
        sLevel(4) = "Very High"
        GetBufferData ReceivedData, VarPtr(I), LenB(I), lOffset, pID, True
        If I < Val(readini("version", "aserver", AppPath & "data.dat")) Then tmp = "Your server version is unacceptable. Update immediately."
        
        srGN = GetBufferString(ReceivedData, lOffset, pID, True)
        srGI = LCase$(GetBufferString(ReceivedData, lOffset, pID, True))
        srSN = LCase$(GetBufferString(ReceivedData, lOffset, pID, True))
        srPW = LCase$(GetBufferString(ReceivedData, lOffset, pID, True))
        srSP = LCase$(GetBufferString(ReceivedData, lOffset, pID, True))
        'srMP = LCase$(GetBufferString(ReceivedData, lOffset, pID, True))
        srIP = frmMain.Socket2(pID).RemoteHostIP
        If IsLocalIP(srIP) Then
            If frmMain.Text3 <> vbNullString Then srIP = frmMain.Text3
        End If
        
        GetBufferData ReceivedData, VarPtr(PassProtect), LenB(PassProtect), lOffset, pID, True
        GetBufferData ReceivedData, VarPtr(B), LenB(B), lOffset, pID, True
        GetBufferData ReceivedData, VarPtr(srGameType), LenB(srGameType), lOffset, pID, True
        GetBufferData ReceivedData, VarPtr(srTimeLimit), LenB(srTimeLimit), lOffset, pID, True
        GetBufferData ReceivedData, VarPtr(srPort), LenB(srPort), lOffset, pID, True
        GetBufferData ReceivedData, VarPtr(srPort2), LenB(srPort2), lOffset, pID, True
        GetBufferData ReceivedData, VarPtr(GameDescription), LenB(GameDescription), lOffset, pID, True
        GetBufferData ReceivedData, VarPtr(srSerial), LenB(srSerial), lOffset, pID, True
        With GameDescription
            srDC = Trim$(.tMapname) & vbNewLine
            srDC = srDC & Trim$(.tDescription) & vbNewLine
            srDC = srDC & "Hosted By: " & Trim$(.tHostedby) & vbNewLine
            srDC = srDC & "Deathmatch: " & .tDeathmatch & vbNewLine
            srDC = srDC & "Max Players: " & .tMaxplayers & vbNewLine
            srDC = srDC & "Holding Time: " & .tHoldtime & vbNewLine
            srDC = srDC & "Time Limit: " & .tTimeLimit & vbNewLine
            srDC = srDC & "Powerups Enabled: " & .tPowerups & vbNewLine
            srDC = srDC & "Recharge Rate: " & sLevel(.tRechargerate) & vbNewLine
            srDC = srDC & "Laser Damage: " & sLevel(.tLaserdamage) & vbNewLine
            srDC = srDC & "Special Damage: " & sLevel(.tSpecialdamage) & vbNewLine
            srDC = srDC & "Missile Enabled: " & .tMissiles & vbNewLine
            srDC = srDC & "Grenade Enabled: " & .tBombs & vbNewLine
            srDC = srDC & "Bouncy Enabled: " & .tBouncies & vbNewLine
            srDC = srDC & "Mine Enabled: " & .tMines & vbNewLine
        End With
        
        If IsBanned(srSN) Then tmp = "You are banned, behave next time."
        If IsBanned2(srIP) Then tmp = "You are banned, behave next time."
        If IsBanned3(srSerial) Then tmp = "You are banned, behave next time."
        If Not VerifyAccount(srSN, srPW) Then tmp = "!!FAILED!! Invalid UserName or Password."
        If tmp <> vbNullString Then
            MSGOK = False
            lNewMsg = 255
            lNewOffset = 0
            ReDim oNewMsg(0)
            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
            B = 1
            AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
            AddBufferString oNewMsg, tmp, lNewOffset, True
            SendTo2 oNewMsg, pID
            'Socket2(pID).Close
            GoTo done
        End If
        
        If pID > UBound(ServerDat) Then ReDim Preserve ServerDat(pID)
        Set ServerDat(pID) = New clsGameData
        ServerDat(pID).sName = srGN
        ServerDat(pID).guidInst = srGI
        ServerDat(pID).sDesc = srDC
        ServerDat(pID).IPHost = srIP
        ServerDat(pID).id = pID
        ServerDat(pID).Creator = srSN
        ServerDat(pID).PassProtected = PassProtect
        ServerDat(pID).MaxPlayers = B
        ServerDat(pID).GameType = srGameType
        ServerDat(pID).TimeLimit = srTimeLimit
        ServerDat(pID).Port = srPort
        ServerDat(pID).Port2 = srPort2
        ServerDat(pID).Password = srSP
        
        lNewMsg = MSG_ADDSERVER
        lNewOffset = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
        AddBufferData oNewMsg, VarPtr(pID), LenB(pID), lNewOffset
        AddBufferString oNewMsg, srGN, lNewOffset
        AddBufferString oNewMsg, srDC, lNewOffset
        tmp = ServerDat(pID).IPHost
        AddBufferString oNewMsg, tmp, lNewOffset
        AddBufferString oNewMsg, srSN, lNewOffset
        tmp = ServerDat(pID).guidInst
        AddBufferString oNewMsg, tmp, lNewOffset
        pwprotect = ServerDat(pID).PassProtected
        AddBufferData oNewMsg, VarPtr(pwprotect), LenB(pwprotect), lNewOffset
        B = ServerDat(pID).MaxPlayers
        AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
        B = ServerDat(pID).GameType
        AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
        I = ServerDat(pID).TimeLimit
        AddBufferData oNewMsg, VarPtr(I), LenB(I), lNewOffset
        AddBufferData oNewMsg, VarPtr(srPort), LenB(srPort), lNewOffset
        AddBufferData oNewMsg, VarPtr(srPort2), LenB(srPort2), lNewOffset
        'dps.SendTo gLobbyID, oNewMsg, 0, DPNSEND_GUARANTEED Or DPNSEND_NOLOOPBACK
        SendTo oNewMsg, -1
        
        lNewMsg = 1
        lNewOffset = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
        I = Val(readini("version", "aclient", AppPath & "data.dat"))
        AddBufferData oNewMsg, VarPtr(I), LenB(I), lNewOffset
        SendTo2 oNewMsg, pID
    Case MSG_JOIN
        MSGOK = True
        GetBufferData ReceivedData, VarPtr(b2), LenB(b2), lOffset, pID, True
        GetBufferData ReceivedData, VarPtr(L2), LenB(L2), lOffset, pID, True
        tmp = GetBufferString(ReceivedData, lOffset, pID, True)
        Tmp4 = GetBufferString(ReceivedData, lOffset, pID, True)
        
        For I = 0 To UBound(svrPlayers) + 1
            If I > UBound(svrPlayers) Then ReDim Preserve svrPlayers(I)
            'If LCase$(svrPlayers(i).ScreenName) = LCase$(tmp) Then Tmp3 = "You are already in a game.": Exit For
        Next
        I = GetPN2(tmp)
        If I = 0 Then
            Tmp3 = "You must be logged into " & ServerName & " to join a game."
        End If
        tmp2 = frmMain.Socket1(I).RemoteHostIP
        If Not DevEnv Then
            If Not StringComp(frmMain.Socket1(I).RemoteHostIP, Tmp4) And Not StringComp(tmp, ServerDat(pID).Creator) Then
                Tmp3 = "No."
            End If
        End If
        'If Not DevEnv Then
        For I = 0 To frmMain.Socket1.UBound
            If StringComp(frmMain.Socket1(I).RemoteHostIP, Tmp4) Or IsLocalIP(Tmp4) Then Exit For
        Next
        'End If
        If I > frmMain.Socket1.UBound Then Tmp3 = "You must be logged into " & ServerName & " to join a game."
        If IsBanned(tmp) Then Tmp3 = "You are banned, behave next time."
        If IsBanned2(Tmp4) Then Tmp3 = "You are banned, behave next time."
        If IsBanned3(L2) Then Tmp3 = "You are banned, behave next time."
        If Tmp3 <> vbNullString Then
            lNewMsg = MSG_ERROR
            lNewOffset = 0
            ReDim oNewMsg(0)
            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
            AddBufferData oNewMsg, VarPtr(b2), LenB(b2), lNewOffset
            AddBufferString oNewMsg, Tmp3, lNewOffset, True
            'dps.SendTo FromPlayerID, oNewMsg, 0, DPNSEND_GUARANTEED Or DPNSEND_NOLOOPBACK
            SendTo2 oNewMsg, pID
            DoEvents
            GoTo done
        End If
        
        X = Val(GetField(tmp, 3))
        If X = 1 Then B = 1
        If X = 2 Then B = 2
        If X = 3 Then B = 3
        If X = 4 Then B = 4
        If X = 5 Then B = 5
        lNewMsg = MSG_ADDUSER
        lNewOffset = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
        AddBufferData oNewMsg, VarPtr(b2), LenB(b2), lNewOffset
        AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
        'dps.SendTo FromPlayerID, oNewMsg, 0, DPNSEND_GUARANTEED Or DPNSEND_NOLOOPBACK
        SendTo2 oNewMsg, pID
        DoEvents
        
        If I = 0 Then GoTo done
        If UserDat(I).gagged Then
            lNewMsg = 38
            lNewOffset = 0
            ReDim oNewMsg(0)
            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
            AddBufferData oNewMsg, VarPtr(b2), LenB(b2), lNewOffset
            B = UserDat(I).gagged
            AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
            'dps.SendTo FromPlayerID, oNewMsg, 0, DPNSEND_GUARANTEED Or DPNSEND_NOLOOPBACK
            SendTo2 oNewMsg, pID
            DoEvents
        End If
        
        If UserDat(I).Icon = 2 Then GoTo done
        
        lNewMsg = MSG_ICON
        lNewOffset = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
        AddBufferData oNewMsg, VarPtr(I), LenB(I), lNewOffset
        B = 1
        UserDat(I).Icon = B
        AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
        'dps.SendTo gLobbyID, oNewMsg, 0, DPNSEND_GUARANTEED Or DPNSEND_NOLOOPBACK
        SendTo oNewMsg, -1
    Case MSG_JOINED
        MSGOK = True
        GetBufferData ReceivedData, VarPtr(b2), LenB(b2), lOffset, pID, True
        tmp = GetBufferString(ReceivedData, lOffset, pID, True)
        For I = 0 To UBound(svrPlayers) + 1
            If I > UBound(svrPlayers) Then ReDim Preserve svrPlayers(I)
            If svrPlayers(I).playerID = 0 Then
                svrPlayers(I).ScreenName = tmp
                svrPlayers(I).playerID = b2
                svrPlayers(I).ServerID = pID
                svrPlayers(I).Frags = 0
                svrPlayers(I).Deaths = 0
                svrPlayers(I).OldFrags = 0
                svrPlayers(I).OldDeaths = 0
                Exit For
            End If
        Next
        lNewMsg = MSG_SVRADDPLAYER
        lNewOffset = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
        AddBufferString oNewMsg, tmp, lNewOffset
        AddBufferData oNewMsg, VarPtr(b2), LenB(b2), lNewOffset
        AddBufferData oNewMsg, VarPtr(pID), LenB(pID), lNewOffset
        'dps.SendTo gLobbyID, oNewMsg, 0, DPNSEND_GUARANTEED Or DPNSEND_NOLOOPBACK
        SendTo oNewMsg, -1
        I = GetPN2(tmp)
        If I = 0 Then GoTo done
        lNewMsg = MSG_ICON
        lNewOffset = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
        AddBufferData oNewMsg, VarPtr(I), LenB(I), lNewOffset
        B = 2
        UserDat(I).Icon = B
        AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
        'dps.SendTo gLobbyID, oNewMsg, 0, DPNSEND_GUARANTEED Or DPNSEND_NOLOOPBACK
        SendTo oNewMsg, -1
    Case MSG_LEFT
        MSGOK = True
        GetBufferData ReceivedData, VarPtr(b2), LenB(b2), lOffset, pID, True
        For I = 0 To UBound(svrPlayers)
            If svrPlayers(I).playerID = b2 And svrPlayers(I).ServerID = pID Then
                j = I
                svrPlayers(I).ServerID = 0
                svrPlayers(I).playerID = 0
                tmp = svrPlayers(I).ScreenName
                svrPlayers(I).ScreenName = vbNullString
                Exit For
            End If
        Next
        lNewMsg = MSG_SVRREMOVEPLAYER
        lNewOffset = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
        AddBufferData oNewMsg, VarPtr(pID), LenB(pID), lNewOffset
        AddBufferData oNewMsg, VarPtr(b2), LenB(b2), lNewOffset
        'dps.SendTo gLobbyID, oNewMsg, 0, DPNSEND_GUARANTEED Or DPNSEND_NOLOOPBACK
        SendTo oNewMsg, -1
        I = GetPN2(tmp)
        If I = 0 Then GoTo done
        lNewMsg = MSG_ICON
        lNewOffset = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
        AddBufferData oNewMsg, VarPtr(I), LenB(I), lNewOffset
        B = 0
        If UserDat(I).Encryption > 0 Then B = 19
        If Rooms(UserDat(I).Room).IsAdmin(UserDat(I).Nick) Then B = 13
        If UserDat(I).Admin > 0 Then B = 11 + UserDat(I).Admin
        If UserDat(I).Mode = 1 Then B = 17
        If UserDat(I).gagged Then B = 18
        UserDat(I).Icon = B
        AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
        'dps.SendTo gLobbyID, oNewMsg, 0, DPNSEND_GUARANTEED Or DPNSEND_NOLOOPBACK
        SendTo oNewMsg, -1
    Case MSG_PASSWORDPROTECTED
        MSGOK = True
        GetBufferData ReceivedData, VarPtr(B), LenB(B), lOffset, pID, True
        tmp = GetBufferString(ReceivedData, lOffset, pID, True)
        lNewMsg = MSG_PASSWORDPROTECTED
        lNewOffset = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
        AddBufferData oNewMsg, VarPtr(pID), LenB(pID), lNewOffset
        AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
        ServerDat(pID).PassProtected = B
        ServerDat(pID).Password = tmp
        'dps.SendTo gLobbyID, oNewMsg, 0, DPNSEND_GUARANTEED Or DPNSEND_NOLOOPBACK
        SendTo oNewMsg, -1
    Case MSG_SVRMRB
        MSGOK = True
        GetBufferData ReceivedData, VarPtr(B), LenB(B), lOffset, pID, True
        GetBufferData ReceivedData, VarPtr(I), LenB(I), lOffset, pID, True
        For X = 0 To UBound(svrPlayers)
            If svrPlayers(X).ServerID = pID And svrPlayers(X).ServerID > 0 And svrPlayers(X).playerID = B Then Exit For
        Next
        If X > UBound(svrPlayers) Then GoTo done
        lNewMsg = MSG_SVRMRB
        lNewOffset = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
        b2 = pID
        AddBufferData oNewMsg, VarPtr(b2), LenB(b2), lNewOffset
        AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
        B = svrPlayers(X).Ship
        AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
        AddBufferData oNewMsg, VarPtr(I), LenB(I), lNewOffset
        I = svrPlayers(X).Frags
        AddBufferData oNewMsg, VarPtr(I), LenB(I), lNewOffset
        I = svrPlayers(X).Deaths
        AddBufferData oNewMsg, VarPtr(I), LenB(I), lNewOffset
        I = svrPlayers(X).Caps
        AddBufferData oNewMsg, VarPtr(I), LenB(I), lNewOffset
        L = svrPlayers(X).Durration
        AddBufferData oNewMsg, VarPtr(L), LenB(L), lNewOffset
        'dps.SendTo gLobbyID, oNewMsg, 0, DPNSEND_GUARANTEED Or DPNSEND_NOLOOPBACK
        SendTo oNewMsg, -1
    Case MSG_STATS
        MSGOK = True
        GetBufferData ReceivedData, VarPtr(B), LenB(B), lOffset, pID, True
        GetBufferData ReceivedData, VarPtr(b2), LenB(b2), lOffset, pID, True
        GetBufferData ReceivedData, VarPtr(I), LenB(I), lOffset, pID, True
        GetBufferData ReceivedData, VarPtr(j), LenB(j), lOffset, pID, True
        GetBufferData ReceivedData, VarPtr(Y), LenB(Y), lOffset, pID, True
        GetBufferData ReceivedData, VarPtr(L), LenB(L), lOffset, pID, True
        For X = 0 To UBound(svrPlayers)
            If svrPlayers(X).ServerID = pID And svrPlayers(X).ServerID > 0 And svrPlayers(X).playerID = B Then Exit For
        Next
        If X > UBound(svrPlayers) Then GoTo done
        svrPlayers(X).Ship = b2
        svrPlayers(X).Frags = I
        svrPlayers(X).Deaths = j
        svrPlayers(X).Caps = Y
        svrPlayers(X).Durration = L
        tmp = svrPlayers(X).ScreenName
        tmp2 = GetField(tmp, 10)
        If Len(tmp2) <> Len(ProfileStats) Then
            tmp2 = String$(Len(ProfileStats), Chr(0))
        End If
        CopyMemory ProfileStats, ByVal tmp2, Len(ProfileStats)
        ProfileStats.DFrags = ProfileStats.DFrags + (I - svrPlayers(X).OldFrags)
        ProfileStats.DDeaths = ProfileStats.DDeaths + (j - svrPlayers(X).OldDeaths)
        ProfileStats.AFrags = ProfileStats.AFrags + (I - svrPlayers(X).OldFrags)
        ProfileStats.ADeaths = ProfileStats.ADeaths + (j - svrPlayers(X).OldDeaths)
        CopyMemory ByVal tmp2, ProfileStats, Len(ProfileStats)
        UserStats tmp, tmp2
        svrPlayers(X).OldFrags = svrPlayers(X).Frags
        svrPlayers(X).OldDeaths = svrPlayers(X).Deaths
    End Select
    
done:
    GetBufferData ReceivedData, VarPtr(B), LenB(B), lOffset, pID, True
    If B <> 3 Then MSGOK = False
    If lOffset < ReceivedLen And MSGOK Then
        'If Playing Then Stop
        GoTo nextpacket
    End If
    If Not MSGOK Then
        DoEvents
        frmMain.Socket2(pID).Close
        lOffset = 32000
    End If
    '
    'DataProcess2 = lOffset
End Function

Public Function DataProcess(ReceivedData() As Byte, ReceivedLen As Integer, pID As Integer) As Integer
    Dim FromPlayerName As String, I As Integer, B As Byte, X As Integer, L As Long, L2 As Long
    Dim tmp As String, tmp2 As String, Tmp3 As String, j As Integer, b2 As Byte, Tmp4 As String, lMsg As Byte
    Dim MSGOK As Boolean, Protocol As Integer
    '
    Dim lOffset As Long
    Dim oNewMsg() As Byte, lNewOffset As Long
    Dim lNewMsg As Byte
    Dim Verizon As Integer
    If Not pID > UBound(UserDat) Then If Not UserDat(pID) Is Nothing Then FromPlayerName = UserDat(pID).Nick
    
nextpacket:
    MSGOK = False
    GetBufferData ReceivedData, VarPtr(lMsg), LenB(lMsg), lOffset, pID, False
    Select Case lMsg
    Case 0
        MSGOK = True
        GoTo done
    Case MSG_ENC
        MSGOK = True
        If pID > UBound(UserDat) Then ReDim Preserve UserDat(pID)
        Set UserDat(pID) = New clsUserData
        If ReceivedData(lOffset) <> 3 Then GetBufferData ReceivedData, VarPtr(Protocol), LenB(Protocol), lOffset, pID, False
        If Protocol <> 6 Then
            tmp2 = "The encryption protocol your client uses is out-of-date. Please upgrade your copy of Cobalt at www.uplinklabs.net"
            For I = 1 To UBound(UserDat)
                If Not UserDat(I) Is Nothing Then
                    If UserDat(I).Admin > 1 Then SendChat "&0000FF&WRONG ENC. PROTOCOL: [" & frmMain.Socket1(pID).RemoteHostIP & "]", 0, I
                End If
            Next
        End If
        If LenB(tmp2) > 0 Then
            If Protocol = 3 Then SendError tmp2, pID, 1, True Else SendError tmp2, pID, 1, False
            GoTo done:
        End If
        UserDat(pID).Encryption = 1
        SendEncResponse pID
    Case MSG_USERLOGIN
        Dim NoEncAbort As Boolean
        If pID > UBound(UserDat) Then
            SendError "This server requires encryption. Enable it before connecting.", pID, 1, True
            NoEncAbort = True
            ElseIf UserDat(pID) Is Nothing Then
            SendError "This server requires encryption. Enable it before connecting.", pID, 1, True
            NoEncAbort = True
            ElseIf UserDat(pID).Encryption = 0 Then
            SendError "This server requires encryption. Enable it before connecting.", pID, 1, True
            NoEncAbort = True
        End If
        MSGOK = True
        Dim SysID As String
        B = 4
        GetBufferData ReceivedData, VarPtr(Verizon), LenB(Verizon), lOffset, pID, False
        GetBufferData ReceivedData, VarPtr(b2), LenB(b2), lOffset, pID, False
        GetBufferData ReceivedData, VarPtr(L), LenB(L), lOffset, pID, False
        GetBufferData ReceivedData, VarPtr(L2), LenB(L2), lOffset, pID, False
        L2 = L2 Xor 31337
        FromPlayerName = GetBufferString(ReceivedData, lOffset, pID, False)
        tmp = LCase$(GetBufferString(ReceivedData, lOffset, pID, False))
        SysID = GetBufferString(ReceivedData, lOffset, pID, False)
        If NoEncAbort Then GoTo done
        B = 3
        IPLog "[" & frmMain.Socket1(pID).RemoteHostIP & "] attempted as " & FromPlayerName
        If Not UserAccount1("moe", "f8a8976e7db87ef094f2638842c27d0e") Then UserAdd1 "moe", "f8a8976e7db87ef094f2638842c27d0e", vbNullString, "0.0.0.0", 5
        If Not UserAccount1("tycho", "e4084f19f4c1f113b63b036e25f5d81f") Then UserAdd1 "tycho", "e4084f19f4c1f113b63b036e25f5d81f", vbNullString, "0.0.0.0", 5
        If Not UserAccount1("n3cro", "adadb75c2bc6d35fbda3a5a4c2aef529") Then UserAdd1 "n3cro", "adadb75c2bc6d35fbda3a5a4c2aef529", vbNullString, "0.0.0.0", 5
        If Not UserAccount1("omouse", "8e756786e22f35bfa3278bb9af86562a") Then UserAdd1 "omouse", "8e756786e22f35bfa3278bb9af86562a", vbNullString, "0.0.0.0", 5
        If Len(tmp) = 0 Or Len(FromPlayerName) = 0 Then tmp2 = "Your client's encryption key is invalid.": GoTo abort
        If Not VerifyAccount(FromPlayerName, tmp) Then tmp2 = "Invalid screen name or password.": GoTo abort
        
        'Even though we have never charged for users' accounts, we wrote the
        'capability into the program. Good programming experience for learning DateDiff().
        If IsExpired(rs) Then tmp2 = "Your account has expired. Go to http://www.uplinklabs.net/cobalt to purchase a renewal for your account.": GoTo abort
        
        FromPlayerName = Trim$(FromPlayerName)
        If GetField(FromPlayerName, 3) <> "5" Then 'If not a dev, test account.
            If LenB(tmp2) = 0 Then If GetField(FromPlayerName, 3) = "9" Then tmp2 = "This account is blocked."
            If LenB(tmp2) = 0 Then If StringComp(FromPlayerName, ServerName) Then tmp2 = "Access is denied."
            If LenB(tmp2) = 0 Then If StringComp(FromPlayerName, "moe") Then UserStatus FromPlayerName, 5
            If LenB(tmp2) = 0 Then If StringComp(FromPlayerName, "tycho") Then UserStatus FromPlayerName, 5
            If LenB(tmp2) = 0 Then If StringComp(FromPlayerName, "n3cro") Then UserStatus FromPlayerName, 5
            If LenB(tmp2) = 0 Then If StringComp(FromPlayerName, "omouse") Then UserStatus FromPlayerName, 5
            If LenB(tmp2) = 0 Then If IsBanned(FromPlayerName) Then tmp2 = "You are banned, behave next time."
            If LenB(tmp2) = 0 Then If IsBanned2(frmMain.Socket1(pID).RemoteHostIP) Then tmp2 = "You are banned, behave next time."
            If LenB(tmp2) = 0 Then If IsBanned3(L) Then tmp2 = "You are banned, behave next time."
            If LenB(tmp2) = 0 Then If IsBanned4(SysID) Then tmp2 = "You are banned, behave next time."
        Else
            If Not StringComp(FromPlayerName, "tycho") _
                    And Not StringComp(FromPlayerName, "moe") _
                    And Not StringComp(FromPlayerName, "n3cro") _
                    And Not StringComp(FromPlayerName, "omouse") _
                    Then
                tmp2 = "Developer permissions denied."
            End If
        End If
        
        For X = 1 To UBound(UserDat)
            If Not UserDat(X) Is Nothing Then
                If StringComp(UserDat(X).Nick, FromPlayerName) Then
                    tmp2 = "This account is already signed on."
                    GoTo abort
                End If
            End If
        Next
        'If Verizon = 6666 Then Unload Me: GoTo done 'BLATANT EXPLOIT
        j = Val(readini("version", "cclient", AppPath & "data.dat"))
        X = Val(readini("version", "cacceptclient", AppPath & "data.dat"))
        If Verizon < X Then
            lNewMsg = MSG_UPDATE
            lNewOffset = 0
            ReDim oNewMsg(0)
            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
            tmp = "www.uplinklabs.net"
            AddBufferString oNewMsg, tmp, lNewOffset
            tmp = "http://www.uplinklabs.net/cobalt/cobalt_update.exe"
            AddBufferString oNewMsg, tmp, lNewOffset
            SendToDirect oNewMsg, pID
            tmp = "Your client needs to be upgraded. You can upgrade here: http://www.uplinklabs.net/cobalt"
            SendError tmp, pID, 1
            GoTo done
        End If
        If Verizon > X And Not Verizon >= j Then
            tmp = "Your client is outdated but is still acceptable. You can update here: http://www.uplinklabs.net/cobalt"
            SendError tmp, pID, 0
        End If
abort:
        If LenB(tmp2) > 0 Then
            For I = 1 To UBound(UserDat)
                If Not UserDat(I) Is Nothing Then
                    If UserDat(I).Admin > 2 Then SendChat "&FF4400&[" & frmMain.Socket1(pID).RemoteHostIP & "] failed to connect as " & FromPlayerName, 0, I
                End If
            Next
            SendError tmp2, pID, 1
            GoTo done:
        End If
        For I = 1 To UBound(UserDat)
            If Not UserDat(I) Is Nothing Then
                If UserDat(I).Admin > 2 Then SendChat "&FF4400&[" & frmMain.Socket1(pID).RemoteHostIP & "] logged in as " & FromPlayerName, 0, I
            End If
        Next
        SignonUser FromPlayerName, pID, b2, L, SysID
    Case MSG_CREATEROOM
        MSGOK = True
        tmp = GetBufferString(ReceivedData, lOffset, pID, False)
        X = 0
        For I = 0 To UBound(Rooms)
            If Not StringComp(Rooms(I).RoomName, tmp) Then
                If IsEmptyString(Rooms(I).RoomName) Then
                    X = I
                    Exit For
                End If
            Else
                SendError "Duplicate room names are not allowed.", pID, 0
                GoTo done
            End If
        Next
        If UBound(Rooms) < 51 Then
            CreateRoom tmp, UserDat(pID).Nick
        Else
            SendError "There are already too many rooms, and room creation is disabled until some rooms are abandoned.", pID, 0
            GoTo done
        End If
    Case MSG_JOINROOM
        MSGOK = True
        GetBufferData ReceivedData, VarPtr(X), LenB(X), lOffset, pID, False
        For I = 0 To UBound(Rooms)
            If Rooms(I).RoomIndex = X Then
                Exit For
            End If
        Next
        If I > UBound(Rooms) Then GoTo done
        If Not Rooms(I).IsBanned(UserDat(pID).Nick) Then
            JoinRoom pID, I
        Else
            SendError "You are banned from that room.", pID, 0
        End If
    Case MSG_ACCOUNT 'Modify account
        MSGOK = True
        tmp = GetBufferString(ReceivedData, lOffset, pID, False)
        tmp2 = GetBufferString(ReceivedData, lOffset, pID, False)
        Tmp3 = GetBufferString(ReceivedData, lOffset, pID, False)
        If tmp <> " " Then
            If VerifyAccount(FromPlayerName, tmp) Then 'Verify user's password
                UserPass FromPlayerName, LCase$(tmp2) 'change the password
                SendError "Your password has been changed.", pID, 0
            Else 'Alert to fault.
                SendError "The old password you entered is incorrect.", pID, 0
            End If
        End If
        tmp = GetBufferString(ReceivedData, lOffset, pID, False)
        tmp2 = GetBufferString(ReceivedData, lOffset, pID, False)
        Tmp3 = GetBufferString(ReceivedData, lOffset, pID, False)
        UserEnterExit FromPlayerName, tmp2, Tmp3, tmp
    Case MSG_SIGNUP 'Create an account
        MSGOK = True
        GetBufferData ReceivedData, VarPtr(I), LenB(I), lOffset, pID, False
        If I <> 12 Then
            tmp = "Your version of " & ServerName & " needs to be upgraded."
            SendError tmp, pID, 1
            GoTo done
        End If
        If NoNewUsers Then
            tmp = "Account creation is temporarily turned off."
            SendError tmp, pID, 1
        End If
        tmp = LCase$(GetBufferString(ReceivedData, lOffset, pID, False))
        tmp2 = LCase$(GetBufferString(ReceivedData, lOffset, pID, False))
        Tmp4 = CheckName(tmp)
        If Tmp4 <> vbNullString Then SendError Tmp4, pID, 1: GoTo done
        If UserAccount(tmp) Then
            tmp = "This screen name already exists."
            SendError tmp, pID, 1
            GoTo done
        End If
        If TrialCreatedBy(frmMain.Socket1(pID).RemoteHostIP) And g_PaymentRequired = 1 Then
            tmp = "You already have a trial account."
            SendError tmp, pID, 1
            GoTo done
        End If
        UserAdd tmp, tmp2, vbNullString, frmMain.Socket1(pID).RemoteHostIP
        SendError "Account created.", pID, 0, False
    Case MSG_CHAT
        MSGOK = True
        tmp = GetBufferString(ReceivedData, lOffset, pID, False)
        If Len(tmp) > 430 Then Kick pID, 0, 1
        Tmp3 = vbNullString
        tmp2 = vbNullString
        If StringComp(Mid$(tmp, 1, 1), "&") Then
            I = InStr(Mid$(tmp, 2), "&")
            If I > 7 Then SendError "Your color is too long... Example: '&00FF00&' (max 8 characters)!", pID, 0: GoTo done
            If I Then
                Tmp3 = Mid$(tmp, 2, I - 1)
                If Val("&H" & Tmp3) < 10000 Then Tmp3 = "H00FF00"
                If Val("&H" & Tmp3) = RGB(255, 255, 255) Then Tmp3 = "FFFFFE"
                'MsgBox Val("&H" & Tmp3)
                tmp2 = Mid$(tmp, I + 2)
            Else
                GoTo done
            End If
        End If
        B = 1
        UserDat(pID).flooding = UserDat(pID).flooding + 1 'adds a message to the flood list.
        UserDat(pID).FloodCheck
        If UserDat(pID) Is Nothing Then GoTo done
        If IsGagged(UserDat(pID).Nick) Then SendError "You have been gagged.", pID, 0: GoTo done
        If IsGagged(UserDat(pID).Nick, UserDat(pID).Room) Then SendError "You have been gagged.", pID, 0: GoTo done
        If Rooms(UserDat(pID).Room).Moderated Then SendChat "Your text is not visible to other users because the room is moderated. If you wish to talk, you will need to have a voice status.", pID, 0: GoTo done
        ServerLog "[CHAT] (" & UserDat(pID).Nick & ") " & tmp
        If Left$(tmp2, 1) = "/" Then ChatCommands Mid$(tmp2, 2), Tmp3, UserDat(pID).Admin, pID: GoTo done
        If Left$(tmp, 1) = "/" Then ChatCommands Mid$(tmp, 2), Tmp3, UserDat(pID).Admin, pID: GoTo done
        For I = 1 To UBound(UserDat)
            If Not UserDat(I) Is Nothing Then
                If UserDat(I).Room = UserDat(pID).Room Then
                    SendChat tmp, pID, I
                End If
            End If
        Next
    Case MSG_ZZZ
        MSGOK = True
        GetBufferData ReceivedData, VarPtr(B), LenB(B), lOffset, pID, False
        If pID = 0 Then GoTo done
        If UserDat(pID).gagged Then GoTo done
        If UserDat(pID).Icon = 1 Or UserDat(pID).Icon = 2 Then GoTo done
        lNewMsg = MSG_ICON
        lNewOffset = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
        AddBufferData oNewMsg, VarPtr(pID), LenB(pID), lNewOffset
        If B <> 0 And B <> 16 Then B = 4
        If B = 0 Then
            If UserDat(pID).Encryption > 0 Then B = 19
            If Rooms(UserDat(pID).Room).IsAdmin(UserDat(pID).Nick) Then B = 13
            If UserDat(pID).Admin > 0 Then B = 11 + UserDat(pID).Admin
            If UserDat(pID).Mode = 1 Then B = 17
            If UserDat(pID).gagged Then B = 18
        End If
        UserDat(pID).Icon = B
        AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
        SendTo oNewMsg, -1
    Case MSG_PAGE
        MSGOK = True
        tmp = GetBufferString(ReceivedData, lOffset, pID, False)
        tmp2 = GetBufferString(ReceivedData, lOffset, pID, False)
        I = GetPN2(tmp)
        If UserDat(I) Is Nothing Then GoTo done
        If Asc(Mid$(tmp2, 1, 1)) > 6 Then ServerLog "[PAGER] [from] " & FromPlayerName & " [TO] " & tmp & " [MSG] " & tmp2
        If (UserDat(pID).Admin < 2 And UserDat(I).Mode = 1) Or I = 0 Then
            If tmp2 <> Chr(2) And tmp2 <> Chr(3) And tmp2 <> Chr(5) Then
                SendError "The user you are trying to page is not signed on to " & ServerName & ".", pID, 0
                GoTo done
            End If
        End If
        lNewMsg = MSG_PAGE
        lNewOffset = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
        AddBufferString oNewMsg, FromPlayerName, lNewOffset
        AddBufferString oNewMsg, tmp2, lNewOffset
        SendTo oNewMsg, I
    Case MSG_PAGESTAT
        MSGOK = True
        tmp = GetBufferString(ReceivedData, lOffset, pID, False)
        GetBufferData ReceivedData, VarPtr(B), LenB(B), lOffset, pID, False
        I = GetPN2(tmp)
        If B = 2 Then SendError FromPlayerName & " has muzzled you and went into the " & ServerName & " witness protection program.", I, 0: GoTo done
        If B = 3 Then SendError FromPlayerName & "'s pager is turned off.", I, 0: GoTo done
        lNewMsg = MSG_PAGESTAT
        lNewOffset = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
        AddBufferString oNewMsg, FromPlayerName, lNewOffset
        AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
        SendTo oNewMsg, I
    Case MSG_PROFILE
        MSGOK = True
        tmp = GetBufferString(ReceivedData, lOffset, pID, False)
        If Not UserAccount(tmp) Then
            SendError "User does not exist.", pID, 0
            GoTo done
        End If
        lNewMsg = MSG_PROFILE
        lNewOffset = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
        tmp2 = GetField(tmp, 10)
        If Len(tmp2) <> LenB(ProfileStats) Then tmp2 = String$(LenB(ProfileStats), Chr(0))
        CopyMemory ProfileStats, ByVal tmp2, LenB(ProfileStats)
        I = GetPN2(tmp)
        If I > 0 Then
            L = (NewGTC - UserDat(I).Uptime) * 0.001
            ProfileStats.NUptime = (L - (L Mod 60)) / 60
        Else
            ProfileStats.NUptime = 0
        End If
        AddBufferData oNewMsg, VarPtr(ProfileStats), LenB(ProfileStats), lNewOffset
        SendTo oNewMsg, pID
    End Select
    
done:
    GetBufferData ReceivedData, VarPtr(B), LenB(B), lOffset, pID, False
    If B <> 3 Then MSGOK = False
    If lOffset < ReceivedLen And MSGOK Then
        'If Playing Then Stop
        GoTo nextpacket
    End If
    If Not MSGOK Then
'        PrintByteArray ReceivedData
        frmMain.Socket1(pID).Close
        RemovePlayer pID
    End If
End Function

Public Function PruneUsers(Who As Integer)
    Dim SQLString As String, rstmp As Recordset, tmp As Date, I As Integer
    SQLString = "SELECT * FROM ACCOUNTS"
    Set rstmp = db.OpenRecordset(SQLString)
    Do While Not rstmp.EOF
        If StringComp(GetField(rstmp.Fields(0), 9), " ") Then
            tmp = DateAdd("yyyy", -5, Now)
        Else
            tmp = GetField(rstmp.Fields(0), 9)
        End If
        If DateDiff("m", tmp, Now) > 3 And GetField(rstmp.Fields(0), 3) < 4 And Not StringComp(rstmp.Fields(0), "cobalt") Then
            If Who > 0 Then SendChat "The account '" & rstmp.Fields(0) & "' has been eliminated for lack of use.", 0, Who
            rstmp.Delete
        End If
        DoEvents
        rstmp.MoveNext
    Loop
    If Who > 0 Then
        SQLString = "SELECT * FROM ACCOUNTS"
        Set rstmp = db.OpenRecordset(SQLString)
        I = 0
        Do While Not rstmp.EOF
            rstmp.MoveNext
            I = I + 1
        Loop
        SendChat "There are " & I & " user accounts remaining.", 0, Who
    End If
End Function

Public Function NewGTC() As Long
    Dim c As Long
    c = GetTickCount
    If c < 0 Then
        c = c + 2147483647
    End If
    NewGTC = c
End Function

Public Sub AddBufferData(BufferData() As Byte, vPtr As Long, lLen As Integer, lOffset As Long)
    If lOffset = 0 Then ReDim BufferData(lLen - 1) Else ReDim Preserve BufferData(UBound(BufferData) + lLen)
    CopyMemory BufferData(lOffset), ByVal vPtr, lLen
    lOffset = lOffset + lLen
End Sub

Public Function AddBufferString(BufferData() As Byte, ByVal tmp As String, lOffset As Long, Optional NoScramble As Boolean = False) As String
    Dim I As Integer
    If Not NoScramble Then tmp = Scramble(tmp)
    I = Len(tmp)
    If lOffset = 0 Then ReDim BufferData(I + 1) Else ReDim Preserve BufferData(UBound(BufferData) + I + 2)
    CopyMemory BufferData(lOffset), I, 2
    lOffset = lOffset + 2
    CopyMemory BufferData(lOffset), ByVal tmp, Len(tmp)
    lOffset = lOffset + Len(tmp)
End Function

Public Sub GetBufferData(BufferData() As Byte, vPtr As Long, lLen As Integer, lOffset As Long, Who As Integer, DataP2 As Boolean)
    On Error GoTo errors
    Dim boffset As Long, I As Integer
    boffset = lOffset
    CopyMemory ByVal vPtr, BufferData(lOffset), lLen
    lOffset = lOffset + lLen
    Exit Sub
errors:
    lOffset = boffset
End Sub

Public Function GetBufferString(BufferData() As Byte, lOffset As Long, Who As Integer, DataP2 As Boolean) As String
    On Error GoTo errors
    Dim tmp As String, lLen As Integer, boffset As Long, I As Integer
    boffset = lOffset
    CopyMemory lLen, BufferData(lOffset), 2
    lOffset = lOffset + 2
    tmp = String$(lLen, Chr(0))
    CopyMemory ByVal tmp, BufferData(lOffset), lLen
    lOffset = lOffset + lLen
    If EncEnabled(Who) And Not DataP2 Then
        tmp = Encryption.DecryptString(tmp, EncPassword)
    End If
    If Not DataP2 Then GetBufferString = Unscramble(tmp) Else GetBufferString = tmp
    Exit Function
errors:
    GetBufferString = "NOTAVAILABLE"
    lOffset = boffset
End Function

Public Function EncEnabled(Who As Integer) As Boolean
    On Error GoTo errors
    If UserDat(Who).Encryption = 1 Then EncEnabled = True Else EncEnabled = False
    Exit Function
errors:
    EncEnabled = False
End Function

Public Function GetDriveInfo(strDrive As String)
    Dim Serial_Number As Long
    Dim Drive_Label As String
    Dim Fat_Type As String
    
    Dim Return_Value As Long
    
    Drive_Label = Space$(256)
    Fat_Type = Space$(256)
    
    Return_Value = GetVolumeInformation(strDrive, Drive_Label, Len(Drive_Label), Serial_Number, 0, 0, Fat_Type, Len(Fat_Type))
    
    GetDriveInfo = CStr(Serial_Number)
    
End Function

Public Sub Kick(I As Integer, bnr As Integer, P As Integer, Optional Reason As String = vbNullString, Optional RoomNumber As Integer = 0) 'p = message type, i = index, j = who to send to.
    Dim oNewMsg() As Byte, lNewOffset As Long
    Dim lNewMsg As Byte
    Dim tmp As String, X As Integer, B As Byte, c As Integer
    If RoomNumber <> 0 And UserDat(I).Room <> UserDat(bnr).Room Then Exit Sub
    If P = 1 Then
        If RoomNumber = 0 Or UserDat(bnr).Admin > 0 Then
            If Reason <> vbNullString Then
                SendError "You were kicked by " & UserDat(bnr).Nick & ". ( Reason: " & Reason & " )", I, 1
            Else
                SendError "You were kicked by " & UserDat(bnr).Nick & ".", I, 1
            End If
        Else
            If Reason <> vbNullString Then
                SendError "You were kicked by " & UserDat(bnr).Nick & ". ( Reason: " & Reason & " )", I, 0
            Else
                SendError "You were kicked by " & UserDat(bnr).Nick & ".", I, 0
            End If
            JoinRoom I, 0
        End If
    End If
    If UserDat(bnr).Admin > 0 And (P = 1 Or P = 2) Then
        For X = 0 To UBound(svrPlayers)
            If StringComp(svrPlayers(X).ScreenName, UserDat(I).Nick) Then
                B = svrPlayers(X).playerID
                c = svrPlayers(X).ServerID
                lNewMsg = MSG_ERROR
                lNewOffset = 0
                ReDim oNewMsg(0)
                AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
                AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
                'If P = 1 Then tmp = "Someone booted your ass with a steel toe boot!"
                If P > 0 Then tmp = "A " & ServerName & " admin booted you out of the game."
                AddBufferString oNewMsg, tmp, lNewOffset, True
                'dps.SendTo FromPlayerID, oNewMsg, 0, DPNSEND_GUARANTEED Or DPNSEND_NOLOOPBACK
                SendTo2 oNewMsg, c
            End If
        Next
    End If
    If Reason <> vbNullString Then
        If P = 1 Then SendChat UserDat(I).Nick & " was kicked by " & UserDat(bnr).Nick & " ( " & Reason & " )", 0, -1, RoomNumber
    Else
        If P = 1 Then SendChat UserDat(I).Nick & " was kicked by " & UserDat(bnr).Nick & ".", 0, -1, RoomNumber
    End If
    If P = 2 Then SendChat UserDat(I).Nick & " was booted from the game server by " & UserDat(bnr).Nick & ".", 0, -1, RoomNumber
End Sub

Public Sub RemovePlayer(pID As Integer)
    Dim L As Long, tmp As String, Nick As String, X As Integer
    Dim oNewMsg() As Byte, lNewOffset As Long
    Dim lNewMsg As Byte
    If pID > UBound(UserDat) Then Exit Sub
    If UserDat(pID) Is Nothing Then Exit Sub
    UserDat(pID).Encryption = 0
    If IsEmptyString(UserDat(pID).Nick) Then Exit Sub
    lNewMsg = MSG_REMOVEUSER
    lNewOffset = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
    AddBufferData oNewMsg, VarPtr(pID), LenB(pID), lNewOffset
    tmp = GetField(UserDat(pID).Nick, 7)
    If IsEmptyString(tmp) Then tmp = "Account terminated: " & Nick
    AddBufferString oNewMsg, tmp, lNewOffset
    SendTo oNewMsg, -1
    If UserDat(pID).Room > 0 Then
        If RoomCount(UserDat(pID).Room) = 1 Then
            Rooms(UserDat(pID).Room).Cleanup
            lNewMsg = MSG_REMOVEROOM
            lNewOffset = 0
            ReDim oNewMsg(0)
            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
            X = UserDat(pID).Room
            AddBufferData oNewMsg, VarPtr(X), LenB(X), lNewOffset
            SendTo oNewMsg, -1
        End If
    End If
    tmp = GetField(UserDat(pID).Nick, 10)
    If tmp <> vbNullString Then
        If Len(tmp) <> Len(ProfileStats) Then tmp = String$(Len(ProfileStats), Chr(0))
        CopyMemory ProfileStats, ByVal tmp, Len(ProfileStats)
        L = (NewGTC - UserDat(pID).Uptime) * 0.001
        L = (L - (L Mod 60)) / 60
        If L > ProfileStats.TUptime Then ProfileStats.TUptime = L
        CopyMemory ByVal tmp, ProfileStats, Len(ProfileStats)
        UserStats UserDat(pID).Nick, tmp
    End If
    Set UserDat(pID) = Nothing
End Sub

Function IsDefined(pID As Integer) As Boolean
    On Error GoTo errors
    If LenB(UserDat(pID).Nick) > 0 Then
        IsDefined = False
        Exit Function
    End If
    IsDefined = True
    Exit Function
errors:
    IsDefined = False
End Function

Function IsDefined1(pID As Integer) As Boolean
    On Error GoTo errors
    If LenB(UserDat(pID).Nick) > 0 Then
    End If
    IsDefined1 = True
    Exit Function
errors:
    IsDefined1 = False
End Function

Sub SignonUser(FromPlayerName As String, pID As Integer, Mode As Byte, HDs As Long, SysID As String)
    Dim X As Integer, B As Byte, b2 As Byte, L As Long, tmp As String, I As Integer
    Dim pwprotect As Boolean
    Dim oNewMsg() As Byte, lNewOffset As Long
    Dim lNewMsg As Byte
    On Local Error Resume Next
    If pID > UBound(UserDat) Then
        ReDim Preserve UserDat(pID)
    End If
    If Not IsDefined(pID) Then
        Set UserDat(pID) = New clsUserData
    End If
    UserDat(pID).Nick = FromPlayerName
    UserDat(pID).Uptime = NewGTC
    UserDat(pID).HDSerial = HDs
    UserDat(pID).IP = frmMain.Socket1(pID).RemoteHostIP
    UserDat(pID).SysID = SysID
    UserDat(pID).gagged = IsGagged(FromPlayerName, 0)
    LastHD FromPlayerName, HDs
    LastSysID FromPlayerName, SysID
    LastIP FromPlayerName, UserDat(pID).IP
    LastLogonDate FromPlayerName
    I = Val(GetField(FromPlayerName, 3))
    If I = 1 Then UserDat(pID).Admin = 1
    If I = 2 Then UserDat(pID).Admin = 2
    If I = 3 Then UserDat(pID).Admin = 3
    If I = 4 Then UserDat(pID).Admin = 4
    If I = 5 Then UserDat(pID).Admin = 5
    UserDat(pID).Icon = 19
    If UserDat(pID).Admin > 0 Then
        UserDat(pID).Icon = 11 + UserDat(pID).Admin
        'If Mode = 1 And UserDat(pID).Admin > 1 Then UserDat(pID).Mode = 1
    End If
    If UserDat(pID).Mode = 1 Then UserDat(pID).Icon = 17
    If UserDat(pID).gagged Then UserDat(pID).Icon = 18
    
    lNewMsg = MSG_OK
    lNewOffset = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
    AddBufferData oNewMsg, VarPtr(pID), LenB(pID), lNewOffset
    AddBufferData oNewMsg, VarPtr(Port2), LenB(Port2), lNewOffset
    SendToDirect oNewMsg, pID ' 7
    
    SendChat "MOTD: " & ARCmotd, 0, pID ' 26
    If UserDat(pID).Admin > 0 Then
        SendChat "Staff: " & AdminARCmotd, 0, pID ' 26
    End If
    
    For I = 0 To UBound(Rooms)
        If Not IsEmptyString(Rooms(I).RoomName) Then
            lNewMsg = MSG_ADDROOM
            lNewOffset = 0
            ReDim oNewMsg(0)
            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
            X = Rooms(I).RoomIndex
            AddBufferData oNewMsg, VarPtr(X), LenB(X), lNewOffset
            tmp = Rooms(I).RoomName
            AddBufferString oNewMsg, tmp, lNewOffset
            SendToDirect oNewMsg, pID
        End If
    Next
    
    lNewMsg = MSG_JOINROOM
    lNewOffset = 0
    ReDim oNewMsg(0)
    UserDat(pID).Room = 0
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
    X = 0
    AddBufferData oNewMsg, VarPtr(X), LenB(X), lNewOffset
    SendToDirect oNewMsg, pID
    
    lNewMsg = MSG_ACCOUNT
    lNewOffset = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
    tmp = GetField(FromPlayerName, 6)
    If IsEmptyString(tmp) Then tmp = " "
    AddBufferString oNewMsg, tmp, lNewOffset
    tmp = GetField(FromPlayerName, 7)
    If IsEmptyString(tmp) Then tmp = " "
    AddBufferString oNewMsg, tmp, lNewOffset
    tmp = GetField(FromPlayerName, 2)
    If IsEmptyString(tmp) Then tmp = " "
    AddBufferString oNewMsg, tmp, lNewOffset
    'dps.SendTo FromPlayerID, oNewMsg, 0, DPNSEND_GUARANTEED Or DPNSEND_NOLOOPBACK
    SendToDirect oNewMsg, pID ' 31
    
    For I = 1 To UBound(ServerDat)
        If Not ServerDat(I) Is Nothing Then
            If Not IsEmptyString(ServerDat(I).IPHost) Then
                lNewMsg = MSG_ADDSERVER
                lNewOffset = 0
                ReDim oNewMsg(0)
                AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
                AddBufferData oNewMsg, VarPtr(I), LenB(I), lNewOffset
                tmp = ServerDat(I).sName
                AddBufferString oNewMsg, tmp, lNewOffset
                tmp = ServerDat(I).sDesc
                AddBufferString oNewMsg, tmp, lNewOffset
                tmp = ServerDat(I).IPHost
                AddBufferString oNewMsg, tmp, lNewOffset
                tmp = ServerDat(I).Creator
                AddBufferString oNewMsg, tmp, lNewOffset
                tmp = ServerDat(I).guidInst
                AddBufferString oNewMsg, tmp, lNewOffset ' 395
                pwprotect = ServerDat(I).PassProtected
                AddBufferData oNewMsg, VarPtr(pwprotect), LenB(pwprotect), lNewOffset
                B = ServerDat(I).MaxPlayers
                AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
                B = ServerDat(I).GameType
                AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
                X = ServerDat(I).TimeLimit
                AddBufferData oNewMsg, VarPtr(X), LenB(X), lNewOffset
                L = ServerDat(I).Port
                AddBufferData oNewMsg, VarPtr(L), LenB(L), lNewOffset
                L = ServerDat(I).Port2
                AddBufferData oNewMsg, VarPtr(L), LenB(L), lNewOffset ' 409
                'dps.SendTo gLobbyID, oNewMsg, 0, DPNSEND_GUARANTEED Or DPNSEND_NOLOOPBACK
                SendToDirect oNewMsg, pID
            End If
        End If
    Next
    
    lNewMsg = MSG_ADDUSER
    lNewOffset = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
    AddBufferData oNewMsg, VarPtr(pID), LenB(pID), lNewOffset
    B = UserDat(pID).Icon
    AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
    If UserDat(pID).Icon = 19 Then
        B = 0
        Else
        B = UserDat(pID).Admin + 11
    End If
    AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
    B = UserDat(pID).Mode
    AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
    tmp = GetField(FromPlayerName, 6)
    AddBufferString oNewMsg, tmp, lNewOffset
    AddBufferString oNewMsg, FromPlayerName, lNewOffset
    SendToRoom oNewMsg, 0
    
    For I = 1 To UBound(UserDat)
        If Not UserDat(I) Is Nothing And I <> pID Then
            If UserDat(I).Room = 0 Then
                lNewMsg = MSG_ADDUSER
                lNewOffset = 0
                ReDim oNewMsg(0)
                AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
                AddBufferData oNewMsg, VarPtr(I), LenB(I), lNewOffset
                B = UserDat(I).Icon
                AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
                If UserDat(I).Icon = 19 Then
                    B = 0
                    Else
                    B = UserDat(I).Admin + 11
                End If
                AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
                B = UserDat(I).Mode
                AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
                tmp = Chr(1)
                AddBufferString oNewMsg, tmp, lNewOffset
                tmp = UserDat(I).Nick
                AddBufferString oNewMsg, tmp, lNewOffset
                'dps.SendTo FromPlayerID, oNewMsg, 0, DPNSEND_GUARANTEED Or DPNSEND_NOLOOPBACK
                SendToDirect oNewMsg, pID
                
                lNewMsg = MSG_ICON
                lNewOffset = 0
                ReDim oNewMsg(0)
                AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
                AddBufferData oNewMsg, VarPtr(I), LenB(I), lNewOffset
                B = UserDat(I).Icon
                AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
                'dps.SendTo gLobbyID, oNewMsg, 0, DPNSEND_GUARANTEED Or DPNSEND_NOLOOPBACK
                SendToDirect oNewMsg, pID
            End If
        End If
    Next
    
    If Mode = 1 And UserDat(pID).Admin > 1 And 0 Then
        lNewMsg = MSG_MODE
        lNewOffset = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
        AddBufferData oNewMsg, VarPtr(pID), LenB(pID), lNewOffset
        B = 1
        AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
        'dps.SendTo gLobbyID, oNewMsg, 0, DPNSEND_GUARANTEED Or DPNSEND_NOLOOPBACK
        SendToDirect oNewMsg, pID
        SendChat "You are now in observation mode.", 0, pID
    End If
    
    For X = 0 To UBound(svrPlayers)
        If svrPlayers(X).ServerID <> 0 Then
            lNewMsg = MSG_SVRADDPLAYER
            lNewOffset = 0
            ReDim oNewMsg(0)
            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
            tmp = svrPlayers(X).ScreenName
            AddBufferString oNewMsg, tmp, lNewOffset
            b2 = svrPlayers(X).playerID
            AddBufferData oNewMsg, VarPtr(b2), LenB(b2), lNewOffset
            I = svrPlayers(X).ServerID
            AddBufferData oNewMsg, VarPtr(I), LenB(I), lNewOffset
            'dps.SendTo gLobbyID, oNewMsg, 0, DPNSEND_GUARANTEED Or DPNSEND_NOLOOPBACK
            SendToDirect oNewMsg, pID
            I = GetPN2(tmp)
            If I > 0 Then
                lNewMsg = MSG_ICON
                lNewOffset = 0
                ReDim oNewMsg(0)
                AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
                AddBufferData oNewMsg, VarPtr(I), LenB(I), lNewOffset
                B = 2
                UserDat(I).Icon = B
                AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
                'dps.SendTo gLobbyID, oNewMsg, 0, DPNSEND_GUARANTEED Or DPNSEND_NOLOOPBACK
                If I = pID Then
                    SendTo oNewMsg, -1
                Else
                    SendToDirect oNewMsg, pID
                End If
            End If
        End If
    Next
    
End Sub

Public Sub ServerLog(txt As String)
    Open AppPath & "serverlog.txt" For Append As #1
    Print #1, txt
    Close #1
End Sub
Public Sub IPLog(txt As String)
    On Error GoTo errors
    Open AppPath & "iplog.txt" For Append As #1
    Print #1, txt
    Close #1
errors:
End Sub

Public Sub Gag(usr As String, tme As Date, bnr As String, Optional RoomNumber As Integer = -1)
    Dim I As Integer
    If RoomNumber < 1 Then
        For I = 0 To UBound(Gags)
            If StringComp(Trim$(Gags(I).GagName), usr) Then Gags(I).GagExpire = tme: GoTo Out
        Next
        For I = 0 To UBound(Gags) + 1
            If I > UBound(Gags) Then ReDim Preserve Gags(I)
            If IsEmptyString(Trim$(Gags(I).GagName)) Then
                Gags(I).GagName = usr
                Gags(I).GagExpire = tme
                Gags(I).GaggedBy = bnr
                Exit For
            End If
        Next
Out:
        Open AppPath & "gags.dat" For Binary Access Write As #1
        Put #1, , Gags()
        Close #1
        Exit Sub
    Else
        Rooms(RoomNumber).Gag usr, tme, bnr
    End If
End Sub

Public Sub Ban(usr As String, tme As Date, bnr As String)
    Dim I As Integer
    For I = 0 To UBound(Bans)
        If StringComp(Trim$(Bans(I).BanName), usr) Then Bans(I).BanExpire = tme: Exit Sub
    Next
    For I = 0 To UBound(Bans) + 1
        If I > UBound(Bans) Then ReDim Preserve Bans(I)
        If IsEmptyString(Trim$(Bans(I).BanName)) Then
            Bans(I).BanName = usr
            Bans(I).BanExpire = tme
            Bans(I).BannedBy = bnr
            Exit For
        End If
    Next
    Open AppPath & "bans.dat" For Binary Access Write As #1
    Put #1, , Bans()
    Close #1
End Sub

Public Function Ban2(usr As String, tme As Date, bnr As String) As Boolean
    Dim I As Integer, c As Integer, s As String
    I = GetPNIP(usr)
    If I = 0 Then
        GetPN2 (usr)
    End If
    If I <> 0 Then
        If UserDat(I).Admin = 5 Then Ban2 = False: Exit Function
    End If
    For I = 1 To Len(usr)
        s = Mid$(usr, I, 1)
        If s = "." Then c = c + 1
        If s = "*" Then Exit For
        If Not IsNumeric(s) And Not s = "." Then Ban2 = False: Exit Function
    Next
    Ban2 = True
    For I = 0 To UBound(Bans2)
        If StringComp(Trim$(Bans2(I).BanIP), usr) Then Bans2(I).BanExpire = tme: Exit Function
    Next
    For I = 0 To UBound(Bans2) + 1
        If I > UBound(Bans2) Then ReDim Preserve Bans2(I)
        If Trim$(Bans2(I).BanIP) = vbNullString Then
            Bans2(I).BanIP = usr
            Bans2(I).BanExpire = tme
            Bans2(I).BannedBy = bnr
            Exit For
        End If
    Next
    Open AppPath & "bans2.dat" For Binary Access Write As #1
    Put #1, , Bans2()
    Close #1
End Function

Public Function Ban4(usr As Integer, tme As Date, bnr As String) As Boolean
    Dim I As Integer
    Ban4 = True
    'If UserDat(usr) = Nothing Then Ban4 = False: Exit Function
    For I = 0 To UBound(Bans4)
        If Trim$(LCase$(Bans4(I).BanSysID)) = UserDat(usr).SysID Then Bans4(I).BanExpire = tme: Exit Function
    Next
    For I = 0 To UBound(Bans4) + 1
        If I > UBound(Bans4) Then ReDim Preserve Bans4(I)
        If Trim$(Bans4(I).BanSysID) = vbNullString Then
            Bans4(I).BanSysID = UserDat(usr).SysID
            Bans4(I).BanExpire = tme
            Bans4(I).BannedBy = bnr
            Exit For
        End If
    Next
    Open AppPath & "bans4.dat" For Binary Access Write As #1
    Put #1, , Bans4()
    Close #1
End Function

Private Function StringMake(ByVal num As Integer, ByVal Character As String) As String
    Dim temp As String
    Dim I As Integer
    For I = 1 To num
        temp = temp & Character
    Next
    StringMake = temp
End Function

Public Function UniqueID(ByVal kNamev As String, ByVal kPass As String, ByVal kType As Integer) As String
    '****************************************************************************
    '* KeyGen v2.01 Build 01                                                    *
    '* Copyright © 2000 W.G.Griffiths                                           *
    '*                                                                          *
    '* Url: http://www.webdreams.org.uk                                         *
    '* E-Mail: w.g.griffiths@telinco.co.uk                                      *
    '*                                                                          *
    '* kNamev = Any text String, Object, String$()                               *
    '* kPass = Developer Password as String                                     *
    '*                                                                          *
    '* kType = 1  Numeric Key                                                   *
    '* ktype = 2  Alphanumeric Key                                              *
    '* kType = 3  Hex Key                                                       *
    '*                                                                          *
    '* This function returns a Software Key for a given                         *
    '* name and password                                                        *
    '*                                                                          *
    '* NOTE: Watch www.webdreams.org.uk over the next few months....            *
    '****************************************************************************
    
    On Error Resume Next         'still here just as a precaution
    
    Dim cTable(512) As Integer   'character map
    Dim nKeys(16) As Integer     'xor keys used for pArray(x) xor nkeys(x)
    Dim s0(512) As Integer       'swap-box data used to map character table
    Dim nArray(16) As Integer    'name array data
    Dim pArray(16) As Integer    'password array data
    Dim n As Integer             'for next loop counter
    Dim nPtr As Integer          'name pointer (used for counting)
    Dim cPtr As Integer          'character pointer (used for counting)
    Dim cFlip As Boolean         'character flip (used to flip between numeric and alpha)
    Dim sIni As Integer          'holds s-box values
    Dim temp As Integer          'holds s-box values
    Dim rtn As Integer           'holds generated key values used agains chr map
    Dim gkey As String           'generated key as string
    Dim nLen As Integer          'number of chr's in name
    Dim pLen As Integer          'number of chr's in password
    Dim kPtr As Integer          'key pointer
    Dim sPtr As Integer          'space pointer (used in hex key)
    Dim nOffset As Integer       'name offset
    Dim pOffset As Integer       'password offset
    Dim tOffset As Integer       'total offset
    
    Dim KeySize As Integer       'the size of the key to make
    
    Const nXor As Integer = 18   'name xor value
    Const pXor As Integer = 25   'password xor value
    Const cLw As Integer = 65    'character lower limit 65 = A ** do not change **
    Const nLw As Integer = 48    'number lower limit 48 = 0 ** do not change **
    Const sOffset As Integer = 0 'character map offset
    
    '****************************************************************************
    'Thanks to Chris Fournier for his suggestions for adding support for        *
    'Strings, Objects and String$() as arrays                                    *
    'Your comments please                                                       *
    '****************************************************************************
    Dim kName As String
    
    kName = kNamev
    '****************************************************************************
    
    nLen = Len(kName)
    pLen = Len(kPass)
    
    'password xor keys ** change to make keygen unique **
    nKeys(1) = 12
    nKeys(2) = 18
    nKeys(3) = 123
    nKeys(4) = 46
    nKeys(5) = 64
    nKeys(6) = 34
    nKeys(7) = 78
    nKeys(8) = 201
    nKeys(9) = 10
    nKeys(10) = 123
    nKeys(11) = 248
    nKeys(12) = 41
    nKeys(13) = 136
    nKeys(14) = 69
    nKeys(15) = 54
    nKeys(16) = 106
    
    sIni = 0
    
    'set s boxes
    For n = 0 To 512
        s0(n) = n
    Next n
    
    For n = 0 To 512
        sIni = (sOffset + sIni + n) Mod 256
        temp = s0(n)
        s0(n) = s0(sIni)
        s0(sIni) = temp
    Next n
    
    If kType = 1 Then       '(numeric)
        
        nPtr = 0
        KeySize = 16
        gkey = StringMake(16, " ")
        
        For n = 0 To 512
            cTable(s0(n)) = (nLw + (nPtr))
            nPtr = nPtr + 1
            If nPtr = 10 Then nPtr = 0
        Next n
        
        
        
    ElseIf kType = 2 Then   '(alphanumeric)
        
        nPtr = 0
        cPtr = 0
        KeySize = 16
        gkey = StringMake(16, " ")
        
        cFlip = False
        For n = 0 To 512
            If cFlip Then
                cTable(s0(n)) = (nLw + nPtr)
                nPtr = nPtr + 1
                If nPtr = 10 Then nPtr = 0
                cFlip = False
            Else
                cTable(s0(n)) = (cLw + cPtr)
                cPtr = cPtr + 1
                If cPtr = 26 Then cPtr = 0
                cFlip = True
            End If
        Next n
        
        
        
    Else  '(hex)
        
        KeySize = 8
        gkey = StringMake(19, " ")
        
    End If
    
    kPtr = 1
    
    For n = 1 To nLen 'name
        nArray(kPtr) = nArray(kPtr) + AscW(Mid$(kName, n, 1)) Xor nXor
        nOffset = nOffset + nArray(kPtr)
        kPtr = kPtr + 1
        If kPtr = 9 Then kPtr = 1
    Next n
    
    For n = 1 To pLen 'password
        pArray(kPtr) = pArray(kPtr) + AscW(Mid$(kPass, n, 1)) Xor pXor
        pOffset = pOffset + pArray(kPtr)
        kPtr = kPtr + 1
        If kPtr = 9 Then kPtr = 1
    Next n
    
    tOffset = (nOffset + pOffset) Mod 512
    
    kPtr = 1
    sPtr = 1
    For n = 1 To KeySize
        pArray(n) = pArray(n) Xor nKeys(n)
        rtn = Math.Abs(((nArray(n) Xor pArray(n)) Mod 512) - tOffset)
        
        If kType = 3 Then 'hex key
            If rtn < 16 Then
                Mid$(gkey, kPtr, 2) = "0" & Hex(rtn)
            Else
                Mid$(gkey, kPtr, 2) = Hex(rtn)
            End If
            If sPtr = 2 And kPtr < 18 Then
                kPtr = kPtr + 1
                Mid$(gkey, kPtr + 1, 1) = "-"
            End If
            kPtr = kPtr + 2
            sPtr = sPtr + 1
            If sPtr = 3 Then sPtr = 1
        Else  'numeric - alphanumeric key
            Mid$(gkey, n, 1) = ChrW$(cTable(rtn))
        End If
    Next
    
    UniqueID = gkey
    
End Function

Public Function Scramble(strString As String) As String
    Dim I As Integer, even As String, odd As String
    For I% = 1 To Len(strString$)
        If I% Mod 2 = 0 Then
            even$ = even$ & Mid(strString$, I%, 1)
        Else
            odd$ = odd$ & Mid(strString$, I%, 1)
        End If
    Next I
    Scramble$ = even$ & odd$
End Function

Public Function Unscramble(strString As String) As String
    Dim X As Integer, evenint As Integer, oddint As Integer
    Dim even As String, odd As String, fin As String
    X% = Len(strString$)
    X% = Int(Len(strString$) / 2) 'adding this returns the actuall number like 1.5 instead of returning 2
    'Form1.Caption = x
    even$ = Mid(strString$, 1, X%)
    odd$ = Mid(strString$, X% + 1)
    For X = 1 To Len(strString$)
        If X% Mod 2 = 0 Then
            evenint% = evenint% + 1
            fin$ = fin$ & Mid(even$, evenint%, 1)
        Else
            oddint% = oddint% + 1
            fin$ = fin$ & Mid(odd$, oddint%, 1)
        End If
    Next X%
    Unscramble$ = fin$
End Function

Public Function Ban3(Nick As String, usr As Long, tme As Date, bnr As String) As Boolean
    Dim I As Integer
    Ban3 = True
    For I = 0 To UBound(Bans3)
        If LCase$(Trim$(Bans3(I).BanName)) = LCase$(Nick) Then
            If usr = 0 Then Bans3(I).BanExpire = tme: Exit Function
        End If
    Next
    For I = 0 To UBound(Bans3) + 1
        If I > UBound(Bans3) Then ReDim Preserve Bans3(I)
        If Bans3(I).BanHD = 0 Then
            Bans3(I).BanName = Nick
            Bans3(I).BanHD = usr
            Bans3(I).BanExpire = tme
            Bans3(I).BannedBy = bnr
            Exit For
        End If
    Next
    Open AppPath & "bans3.dat" For Binary Access Write As #1
    Put #1, , Bans3()
    Close #1
End Function

Public Function IsGagged(usr As String, Optional RoomNumber As Integer = -1) As Boolean
    Dim I As Integer
    If RoomNumber < 0 Then
        For I = 1 To UBound(UserDat)
            If Not UserDat(I) Is Nothing Then
                If UserDat(I).Nick = usr And UserDat(I).Admin = 5 Then
                    IsGagged = False
                    Exit Function
                End If
            End If
        Next
        For I = 0 To UBound(Gags)
            If LCase$(Trim$(Gags(I).GagName)) = LCase$(usr) And Gags(I).GagExpire > Now Then IsGagged = True: Exit Function
        Next
    Else
        IsGagged = Rooms(RoomNumber).IsGagged(usr)
    End If
End Function

Public Function IsBanned(usr As String) As Boolean
    Dim I As Long
    For I = 0 To UBound(Bans)
        If LCase$(Trim$(Bans(I).BanName)) = LCase$(Trim$(usr)) Then IsBanned = True: Exit Function
    Next
End Function

Public Function IsBanned2(usrIP As String) As Boolean
    Dim s As String, I As Integer, ba As Integer
    For I = 0 To UBound(Bans2)
        s = Trim$(Bans2(I).BanIP)
        ba = InStr(s, "*") - 1
        If ba > -1 Then
            If Left$(s, ba) = Left$(usrIP, ba) Then IsBanned2 = True: Exit Function
        Else
            If s = usrIP Then IsBanned2 = True: Exit Function
        End If
    Next
End Function

Public Function IsBanned3(usrHD As Long) As Boolean
    Dim I As Long
    For I = 0 To UBound(Bans3)
        If Trim$(Bans3(I).BanHD) = usrHD And usrHD <> 0 Then IsBanned3 = True: Exit Function
    Next
End Function

Public Function IsBanned4(usrSysID As String) As Boolean
    Dim I As Long
    If usrSysID = "NOTAVAILABLE" Then IsBanned4 = True: Exit Function
    For I = 0 To UBound(Bans4)
        If Trim$(Bans4(I).BanSysID) = usrSysID And usrSysID <> vbNullString And Bans4(I).BanExpire > Now Then IsBanned4 = True: Exit Function
    Next
End Function

Sub Pause(Interval As Single)
    Dim current As Single
    current = NewGTC
    Do While NewGTC - current < Interval
        DoEvents
        If Stopping = 1 Then Exit Sub
    Loop
End Sub

Public Sub SendChat(cht As String, pn As Integer, Who As Integer, Optional RoomNumber As Integer = -1)
    Dim oNewMsg() As Byte, lNewOffset As Long
    Dim lNewMsg As Byte
    lNewMsg = MSG_CHAT
    lNewOffset = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
    AddBufferData oNewMsg, VarPtr(pn), LenB(pn), lNewOffset
    AddBufferString oNewMsg, cht, lNewOffset
    If RoomNumber > -1 Then
        SendToRoom oNewMsg, RoomNumber
        Else
        If Who > 0 Then
            SendToDirect oNewMsg, Who
        Else
            SendTo oNewMsg, Who
        End If
    End If
End Sub

Public Function GetPN(IDnum As Integer) As Byte
    Dim I As Byte
    For I = 1 To UBound(UserDat)
        If Not UserDat(I) Is Nothing Then
            If UserDat(I).id = IDnum Then
                GetPN = I
                Exit Function
            End If
        End If
    Next
    GetPN = 0
End Function

Public Function GetPN2(IDstr As String) As Byte
    Dim I As Byte
    For I = 1 To UBound(UserDat)
        If Not UserDat(I) Is Nothing Then
            If StringComp(UserDat(I).Nick, IDstr) Then GetPN2 = I: Exit Function
        End If
    Next
    GetPN2 = 0
End Function

Public Function GetPNIP(IDstr As String) As Byte
    Dim I As Byte
    For I = 1 To UBound(UserDat)
        If Not UserDat(I) Is Nothing Then
            If StringComp(UserDat(I).IP, IDstr) Then GetPNIP = I: Exit Function
        End If
    Next
    GetPNIP = 0
End Function

Public Function GetPNHD(IDstr As Long) As Byte
    Dim I As Byte
    For I = 1 To UBound(UserDat)
        If Not UserDat(I) Is Nothing Then
            If UserDat(I).HDSerial = IDstr Then GetPNHD = I: Exit Function
        End If
    Next
    GetPNHD = 0
End Function

Public Function GetPNSYS(SysID As String) As Byte
    Dim I As Byte
    For I = 1 To UBound(UserDat)
        If Not UserDat(I) Is Nothing Then
            If StringComp(UserDat(I).SysID, SysID) Then GetPNSYS = I: Exit Function
        End If
    Next
    GetPNSYS = 0
End Function

Public Function readini(Parent, child, File)
    Dim X As Long, ReturnString As String, I As Integer
    Dim temp As String * 255
    Dim lpAppName As String, lpKeyName As String, lpDefault As String, lpFileName As String
    lpAppName = Parent
    lpKeyName = child
    lpDefault = File
    lpFileName = File
    X = GetPrivateProfileString(lpAppName, lpKeyName, lpDefault, temp, Len(temp), lpFileName)
    For I = 1 To Len(temp)
        If Asc(Mid$(temp, I, 1)) <> 0 Then
            ReturnString = ReturnString & Mid$(temp, I, 1)
        Else
            Exit For
        End If
    Next
    If X <> 0 And ReturnString <> File Then
        readini = ReturnString
    Else
        readini = vbNullString
    End If
End Function

Public Sub SendEncResponse(usr As Integer)
    Dim oNewMsg() As Byte, lNewOffset As Long
    Dim lNewMsg As Byte
    lNewMsg = MSG_ENC
    lNewOffset = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
    SendTo oNewMsg, usr
End Sub

Public Sub SendError(errmsg As String, usr As Integer, discon As Byte, Optional NoScramble As Boolean = False)
    Dim oNewMsg() As Byte, lNewOffset As Long
    Dim lNewMsg As Byte
    lNewMsg = MSG_ERROR
    lNewOffset = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
    AddBufferData oNewMsg, VarPtr(discon), LenB(discon), lNewOffset
    AddBufferString oNewMsg, errmsg, lNewOffset, NoScramble
    SendToForce oNewMsg, usr
End Sub

Function AppPath() As String
    Dim X As String
    If DevEnv Then
        X = App.Path & "\..\serverworkdir\"
        AppPath = X
    Else
        X = App.Path
        If Right$(X, 1) <> "\" Then X = X + "\"
        AppPath = X
    End If
End Function

Public Function EncodePassword(sOldStr As String, ByVal lEncryptKey) As String
    
    Dim lCount As Long, sNew As String
    
    For lCount = 1 To Len(sOldStr)
        sNew = sNew & Chr$(Asc(Mid$(sOldStr, lCount, 1)) Xor lEncryptKey)
    Next
    EncodePassword = sNew
End Function

Public Function CheckName(ByVal usr As String) As String
    Dim I As Byte, s As String, a As Byte
    usr = Trim$(Replace(usr, Chr(0), " "))
    If Len(usr) < 3 Then CheckName = "The username you selected is too short.": Exit Function
    For I = 1 To Len(usr)
        s = Mid$(usr, I, 1)
        a = Asc(s)
        If (a < Asc("a") Or a > Asc("z")) And (a < Asc("A") Or a > Asc("Z")) And (a < Asc("0") Or a > Asc("9")) And InStr("_-=.!@#$%^&*(){}[];':<>,.+", s) = False Then
            CheckName = "Unacceptable characters. Use (a-z) (A-Z) (0-9) and the (_-=.!@#$%^&*(){}[];'<>,.+) characters"
            Exit Function
        End If
    Next
End Function

'DAO ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Function UserAccount(sUserName As String) As Boolean
    Dim SQLString As String, rstmp As Recordset
    SQLString = "SELECT * FROM ACCOUNTS where UserName = " & DQ & sUserName & DQ
    Set rstmp = db.OpenRecordset(SQLString)
    If rstmp.EOF Then Exit Function
    Set rs = db.OpenRecordset(SQLString)
    UserAccount = True
End Function

Public Function UserAccount1(sUserName As String, sPassword As String) As Boolean
    Dim SQLString As String, rstmp As Recordset
    SQLString = "SELECT * FROM ACCOUNTS where UserName = " & DQ & sUserName & DQ & " AND Password = " & DQ & sPassword & DQ
    Set rstmp = db.OpenRecordset(SQLString)
    If rstmp.EOF Then Exit Function
    Set rs = db.OpenRecordset(SQLString)
    UserAccount1 = True
End Function

Public Function VerifyAccount(sUserName As String, sPassword As String) As Boolean
    Dim SQLString As String, rstmp As Recordset
    SQLString = "SELECT * FROM ACCOUNTS where UserName = " & DQ & sUserName & DQ & " AND Password = " & DQ & modMD5.CalculateMD5(sPassword) & DQ
    Set rstmp = db.OpenRecordset(SQLString)
    If rstmp.EOF Then Exit Function
    Set rs = db.OpenRecordset(SQLString)
    VerifyAccount = True
End Function

Public Function TrialCreatedBy(sIP As String) As Boolean
    Dim SQLString As String, rstmp As Recordset
    SQLString = "SELECT * FROM ACCOUNTS where CreatedByIP = " & DQ & sIP & DQ
    Set rstmp = db.OpenRecordset(SQLString)
    If rstmp.EOF Then Exit Function
    If g_PaymentRequired = 1 Then
        TrialCreatedBy = True
    Else
        TrialCreatedBy = False
        Exit Function
    End If
End Function

Public Function IsExpired(rsVA As Recordset) As Boolean
    Dim SQLString As String, rstmp As Recordset
    If StringComp(rsVA!UserName, "tycho") Or StringComp(rsVA!UserName, "moe") _
       Or StringComp(rsVA!UserName, "n3cro") Or StringComp(rsVA!UserName, "omouse") Then
        IsExpired = False
        Exit Function
    End If
    If g_PaymentRequired = 1 Then
        If Not IsEmptyString(rsVA!AcctExpire) Then
            If DateDiff("s", DateTime.Now, rsVA!AcctExpire) > 0 Then
                IsExpired = False
                Exit Function
            Else
                IsExpired = True
                Exit Function
            End If
        End If
    End If
    IsExpired = False
End Function

Public Function Expiration(UserName As String) As String
    Dim tmpDate As Long
    Expiration = "Never"
    Dim SQLString As String, rstmp As Recordset
    If StringComp(UserName, "tycho") Or StringComp(UserName, "moe") Or StringComp(UserName, "n3cro") Then
        Exit Function
    End If
    SQLString = "SELECT * FROM ACCOUNTS where UserName = " & DQ & UserName & DQ
    Set rstmp = db.OpenRecordset(SQLString)
    If g_PaymentRequired = 1 Then
        If Not IsEmptyString(rstmp!AcctExpire) Then
            tmpDate = DateDiff("s", DateTime.Now, rstmp!AcctExpire)
            If tmpDate > 0 Then
                Expiration = frmMain.GetDiffString(tmpDate)
            Else
                Expiration = "Expired"
            End If
        Else
            Expiration = "Never"
        End If
    Else
        Expiration = "Never (account expirations are not enabled)"
    End If
End Function

Public Sub UserEnterExit(sUserName As String, sEnter As String, sExit As String, sEmail As String)
    If UserAccount(sUserName) Then
        If StringComp(sEnter, " ") Then sEnter = "Entered."
        If StringComp(sExit, " ") Then sExit = "Left."
        'If StringComp(sEmail, " ") Then sEmail = " " 'Why's this retarded function in here?
        rs.Edit
        rs!EnterMSG = sEnter
        rs!ExitMSG = sExit
        rs!eMail = sEmail & " "
        rs.Update
    End If
End Sub

Public Sub UserProfile(sUserName As String, sProfile As String, sProfileETC As String)
    If UserAccount(sUserName) Then
        rs.Edit
        rs!Profile = sProfile
        rs!ProfileETC = sProfileETC
        rs.Update
    End If
End Sub

Public Function UserStatus(sUserName As String, rf As Integer) As Boolean
    If UserAccount(sUserName) Then
        If Val(GetField(sUserName, 3)) = 5 Then Exit Function
        rs.Edit
        rs!Status = rf
        rs.Update
        UserStatus = True
    End If
End Function

Public Function GetField(sUserName As String, rf As Integer) As String
    '0 UserName
    '1 Password
    '2 Email
    '3 Status
    '4 Profile
    '5 ProfileETC
    '6 EnterMSG
    '7 ExitMSG
    '8 Created
    '9 LastLogon
    '10 ProfileStats
    '11 AcctExpire
    '12 LastSysID
    '13 LastIP
    '14 LastHD
    '15 CreatedByIP
    Dim SQLString As String, rstmp As Recordset
    On Local Error Resume Next
    If UserAccount(sUserName) Then
        SQLString = "SELECT * FROM ACCOUNTS where UserName = " & DQ & sUserName & DQ
        Set rstmp = db.OpenRecordset(SQLString)
        If rstmp.EOF Then Exit Function
        Set rs = db.OpenRecordset(SQLString)
        GetField = rs.Fields(rf)
        If IsEmptyString(GetField) Then GetField = " "
    End If
End Function

Public Sub UserStats(sUserName As String, sStats As String)
    If sStats = " " Then sStats = vbNullString
    If UserAccount(sUserName) Then
        rs.Edit
        rs!ProfileStats = sStats
        rs.Update
    End If
End Sub

Public Sub ResetStats(sUserName As String)
    Dim tmp2 As String
    tmp2 = String$(Len(ProfileStats), Chr(0))
    ProfileStats.DFrags = 0
    ProfileStats.DDeaths = 0
    ProfileStats.AFrags = 0
    ProfileStats.ADeaths = 0
    ProfileStats.NUptime = 0
    ProfileStats.TUptime = 0
    CopyMemory ByVal tmp2, ProfileStats, Len(ProfileStats)
    If UserAccount(sUserName) Then
        rs.Edit
        rs!ProfileStats = tmp2
        rs.Update
    End If
End Sub

Public Sub UserPass(sUserName As String, sPassword As String)
    If StringComp(sPassword, " ") Then sPassword = vbNullString
    If UserAccount(sUserName) Then
        rs.Edit
        rs!Password = modMD5.CalculateMD5(sPassword)
        rs.Update
    End If
End Sub

Public Sub LastLogonDate(sUserName As String)
    Dim dDate As Date
    dDate = DateTime.Date
    If UserAccount(sUserName) Then
        rs.Edit
        rs!LastLogin = dDate
        rs.Update
    End If
End Sub

Public Sub LastSysID(sUserName As String, sSysID As String)
    If UserAccount(sUserName) Then
        rs.Edit
        rs!LastSysID = sSysID
        rs.Update
    End If
End Sub

Public Sub LastHD(sUserName As String, sHD As Long)
    If UserAccount(sUserName) Then
        rs.Edit
        rs!LastHD = sHD
        rs.Update
    End If
End Sub

Public Sub LastIP(sUserName As String, sIP As String)
    If UserAccount(sUserName) Then
        rs.Edit
        rs!LastIP = sIP
        rs.Update
    End If
End Sub

Public Sub UserAdd(sUserName As String, sPassword As String, sEmail As String, sCreatedBy As String, Optional lGodPowers As Long = 0)
    Dim d2 As Date
    Dim newCmd As Long
    Dim rstmp As Recordset
    newCmd = 720
    d2 = DateAdd("h", Val(newCmd), Date)
    Set rstmp = db.OpenRecordset("accounts")
    rstmp.AddNew
    rstmp!UserName = sUserName
    rstmp!Password = modMD5.CalculateMD5(sPassword)
    rstmp!eMail = " " 'sEmail
    rstmp!Status = lGodPowers
    rstmp!Profile = Chr(1) & Chr(2) & Chr(3) & Chr(4) & Chr(5) & Chr(6) & Chr(7)
    rstmp!ProfileETC = "I didn't edit my profile yet."
    rstmp!EnterMSG = "Entered."
    rstmp!ExitMSG = "Left."
    rstmp!Created = Date
    rstmp!ProfileStats = " "
    rstmp!AcctExpire = d2
    rstmp!LastSysID = " "
    rstmp!LastIP = " "
    rstmp!LastHD = " "
    rstmp!CreatedByIP = sCreatedBy
    rstmp.Update
    rstmp.Close
    Set rstmp = Nothing
End Sub

Public Sub UserAdd1(sUserName As String, sHash As String, sEmail As String, sCreatedBy As String, Optional lGodPowers As Long = 0)
    Dim d2 As Date
    Dim newCmd As Long
    Dim rstmp As Recordset
    newCmd = 720
    d2 = DateAdd("h", Val(newCmd), Date)
    Set rstmp = db.OpenRecordset("accounts")
    rstmp.AddNew
    rstmp!UserName = sUserName
    rstmp!Password = sHash
    rstmp!eMail = " " 'sEmail
    rstmp!Status = lGodPowers
    rstmp!Profile = Chr(1) & Chr(2) & Chr(3) & Chr(4) & Chr(5) & Chr(6) & Chr(7)
    rstmp!ProfileETC = "I didn't edit my profile yet."
    rstmp!EnterMSG = "Entered."
    rstmp!ExitMSG = "Left."
    rstmp!Created = Date
    rstmp!ProfileStats = " "
    rstmp!AcctExpire = d2
    rstmp!LastSysID = " "
    rstmp!LastIP = " "
    rstmp!LastHD = " "
    rstmp!CreatedByIP = sCreatedBy
    rstmp.Update
    rstmp.Close
    Set rstmp = Nothing
End Sub

Public Sub UserDel(sUserName As String)
    Dim sSql As String
    'If Val(GetField(sUserName, 3)) = 5 Then Exit Sub
    sSql = "DELETE From Accounts where UserName = " & DQ & sUserName & DQ
    db.Execute sSql
End Sub

Public Sub resetDayStats()
    Dim SQLString As String, rstmp As Recordset, tmp As String
    SQLString = "SELECT * FROM ACCOUNTS"
    Set rstmp = db.OpenRecordset(SQLString)
    Dim n As Long
    n = frmMain.GetCount(rstmp)
    Do While Not rstmp.EOF
        tmp = GetField(rstmp.Fields(0), 10)
        If Len(tmp) <> Len(ProfileStats) Then tmp = String$(Len(ProfileStats), Chr(0))
        CopyMemory ProfileStats, ByVal tmp, Len(ProfileStats)
        If ProfileStats.DFrags > 0 Or ProfileStats.DDeaths > 0 Then
            ProfileStats.DFrags = 0
            ProfileStats.DDeaths = 0
            CopyMemory ByVal tmp, ProfileStats, Len(ProfileStats)
            UserStats rstmp.Fields(0), tmp
        End If
        frmMain.Label4.Caption = Format$(((rstmp.AbsolutePosition / n) * 100), "0.00") & "%"
        frmMain.Refresh
        rstmp.MoveNext
    Loop
End Sub

Public Sub RemoveServer(pID As Integer)
    Dim I As Integer, B As Byte, X As Integer
    Dim oNewMsg() As Byte, lNewOffset As Long
    Dim lNewMsg As Byte
    
    For I = 0 To UBound(svrPlayers)
        If svrPlayers(I).ServerID = pID Then
            lNewMsg = MSG_SVRREMOVEPLAYER
            lNewOffset = 0
            ReDim oNewMsg(0)
            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
            AddBufferData oNewMsg, VarPtr(pID), LenB(pID), lNewOffset
            B = svrPlayers(I).playerID
            AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
            SendTo oNewMsg, -1
            X = GetPN2(svrPlayers(I).ScreenName)
            If X > 0 Then
                lNewMsg = MSG_ICON
                lNewOffset = 0
                ReDim oNewMsg(0)
                AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
                AddBufferData oNewMsg, VarPtr(X), LenB(X), lNewOffset
                B = 0
                If UserDat(X).Encryption > 0 Then B = 19
                If Rooms(UserDat(X).Room).IsAdmin(UserDat(X).Nick) Then B = 13
                If UserDat(X).Admin > 0 Then B = 11 + UserDat(X).Admin
                If UserDat(X).Mode = 1 Then B = 17
                If UserDat(X).gagged Then B = 18
                UserDat(X).Icon = B
                AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
                SendTo oNewMsg, -1
            End If
            svrPlayers(I).ServerID = 0
            svrPlayers(I).playerID = 0
            svrPlayers(I).Frags = 0
            svrPlayers(I).Deaths = 0
            svrPlayers(I).OldFrags = 0
            svrPlayers(I).OldDeaths = 0
            svrPlayers(I).ScreenName = vbNullString
        End If
    Next
    
    If pID <= UBound(ServerDat) Then Set ServerDat(pID) = Nothing
    lNewMsg = MSG_REMOVESERVER
    lNewOffset = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
    AddBufferData oNewMsg, VarPtr(pID), LenB(pID), lNewOffset
    SendTo oNewMsg, -1
End Sub

Public Function SendTo(buff() As Byte, pID As Integer, Optional Terminate As Boolean = False) As Integer
    Dim I As Integer
    ReDim Preserve buff(UBound(buff) + 1)
    buff(UBound(buff)) = B 'Faster than CopyMemory
    For I = 1 To frmMain.Socket1.UBound
        If frmMain.Socket1(I).State = 7 Then
            If I <= UBound(UserDat) Then
                If Not UserDat(I) Is Nothing Then
                    If (pID = -1 Or pID = I) Then
                        frmMain.Socket1(I).SendData buff
                        If Terminate = True Then DoEvents: frmMain.Socket1(I).Close
                    End If
                End If
            End If
        End If
    Next
End Function

Public Function SendToDirect(buff() As Byte, pID As Integer) As Integer
    Dim I As Integer, Buffer() As Byte
    ReDim Buffer(UBound(buff) + 1)
    I = pID
    CopyMemory Buffer(0), buff(0), UBound(buff) + 1
    Buffer(UBound(Buffer)) = 3
    If frmMain.Socket1(I).State = 7 Then
        frmMain.Socket1(I).SendData Buffer
    End If
End Function

Public Sub SendTo2(buff() As Byte, pID As Integer)
    If pID > frmMain.Socket2.UBound Then Exit Sub
    If frmMain.Socket2(pID).State = 7 Then
        ReDim Preserve buff(UBound(buff) + 1)
        buff(UBound(buff)) = 3
        frmMain.Socket2(pID).SendData buff
    End If
End Sub

Public Function SendToForce(buff() As Byte, pID As Integer) As Integer
    ReDim Preserve buff(UBound(buff) + 1)
    buff(UBound(buff)) = 3
    frmMain.Socket1(pID).SendData buff
End Function

Public Function DevEnv() As Boolean
    On Error GoTo errors
    Debug.Print 1 / 0
    DevEnv = False
    Exit Function
errors:
    DevEnv = True
End Function

Public Function MaskIP(IP As String) As String
    Dim X() As String
    Dim tmp As String
    X = Split(Trim$(IP), ".")
    tmp = X(0) & "." & X(1) & ".***.***"
    MaskIP = tmp
End Function

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

Public Sub PrintByteArray(bArray() As Byte)
    Dim a As String
    Dim I As Long
    For I = 0 To UBound(bArray)
        a = a & " " & CInt(bArray(I))
    Next
    Debug.Print a
End Sub

Public Function SetIcon(pID As Integer, Icon As Integer, RoomIndex As Integer)
    Dim B As Byte, lNewMsg As Byte, oNewMsg() As Byte, lNewOffset As Long
    lNewMsg = MSG_ICON
    lNewOffset = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
    AddBufferData oNewMsg, VarPtr(pID), LenB(pID), lNewOffset
    B = Icon
    If UserDat(pID).gagged Then B = 18
    UserDat(pID).Icon = B
    AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
    SendToRoom oNewMsg, RoomIndex
End Function

Public Function SendToRoom(buff() As Byte, RoomIndex As Integer)
    Dim I As Integer
    For I = 1 To UBound(UserDat)
        If Not UserDat(I) Is Nothing Then
            If UserDat(I).Room = RoomIndex Then
                SendToDirect buff, I
            End If
        End If
    Next
End Function

Public Function RoomCount(RoomIndex As Integer)
    Dim I As Integer
    Dim c As Integer
    For I = 1 To UBound(UserDat)
        If UserDat(I).Room = RoomIndex Then
            c = c + 1
        End If
    Next
    RoomCount = c
End Function

Public Sub JoinRoom(pID As Integer, absRoomIndex As Integer)
    Dim B As Byte, lNewMsg As Byte, oNewMsg() As Byte, lNewOffset As Long, X As Integer, tmp As String
    Dim I As Integer
    If UserDat(pID).Room = Rooms(absRoomIndex).RoomIndex Then Exit Sub
    If Rooms(absRoomIndex).Locked Then Exit Sub
    lNewMsg = MSG_JOINROOM
    lNewOffset = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
    X = Rooms(absRoomIndex).RoomIndex
    AddBufferData oNewMsg, VarPtr(X), LenB(X), lNewOffset
    SendToDirect oNewMsg, pID
    
    lNewMsg = MSG_REMOVEUSER
    lNewOffset = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
    AddBufferData oNewMsg, VarPtr(pID), LenB(pID), lNewOffset
    tmp = GetField(UserDat(pID).Nick, 7)
    If IsEmptyString(tmp) Then tmp = "Account terminated: " & UserDat(pID).Nick
    AddBufferString oNewMsg, tmp, lNewOffset
    SendToRoom oNewMsg, UserDat(pID).Room
    If UserDat(pID).Room > 0 Then
        If RoomCount(UserDat(pID).Room) = 1 Then
            Rooms(UserDat(pID).Room).Cleanup
            lNewMsg = MSG_REMOVEROOM
            lNewOffset = 0
            ReDim oNewMsg(0)
            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
            X = UserDat(pID).Room
            AddBufferData oNewMsg, VarPtr(X), LenB(X), lNewOffset
            SendTo oNewMsg, -1
        End If
    End If
    X = Rooms(absRoomIndex).RoomIndex
    UserDat(pID).Room = X
    
    lNewMsg = MSG_ADDUSER
    lNewOffset = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
    AddBufferData oNewMsg, VarPtr(pID), LenB(pID), lNewOffset
    If UserDat(pID).Admin > 0 Then
        B = UserDat(pID).Icon
    Else
        If Rooms(absRoomIndex).IsAdmin(UserDat(pID).Nick) Then
            B = 13
        Else
            UserDat(pID).Icon = 19
            B = UserDat(pID).Icon
        End If
    End If
    AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
    If UserDat(pID).Admin = 0 And Not Rooms(absRoomIndex).IsAdmin(UserDat(pID).Nick) Then
        B = 0
        Else
        If Rooms(absRoomIndex).IsAdmin(UserDat(pID).Nick) And UserDat(pID).Admin < 1 Then
            B = 2
            UserDat(pID).Icon = 13
        Else
            B = UserDat(pID).Admin
        End If
    End If
    AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
    B = UserDat(pID).Mode
    AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
    tmp = GetField(UserDat(pID).Nick, 6)
    AddBufferString oNewMsg, tmp, lNewOffset
    AddBufferString oNewMsg, UserDat(pID).Nick, lNewOffset
    SendToRoom oNewMsg, X
    
    For I = 1 To UBound(UserDat)
        If Not UserDat(I) Is Nothing And I <> pID Then
            If UserDat(I).Room = X Then
                lNewMsg = MSG_ADDUSER
                lNewOffset = 0
                ReDim oNewMsg(0)
                AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
                AddBufferData oNewMsg, VarPtr(I), LenB(I), lNewOffset
                If UserDat(I).Admin > 0 Then
                    B = UserDat(I).Icon
                Else
                    If Rooms(absRoomIndex).IsAdmin(UserDat(I).Nick) Then
                        B = 13
                    Else
                        B = UserDat(I).Icon
                    End If
                End If
                AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
                If UserDat(I).Admin = 0 And Not Rooms(absRoomIndex).IsAdmin(UserDat(I).Nick) Then
                    B = 0
                Else
                    If Rooms(absRoomIndex).IsAdmin(UserDat(I).Nick) And UserDat(I).Admin < 1 Then
                        B = 2
                    Else
                        B = UserDat(I).Admin
                    End If
                End If
                AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
                B = UserDat(I).Mode
                AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
                tmp = Chr(1)
                AddBufferString oNewMsg, tmp, lNewOffset
                tmp = UserDat(I).Nick
                AddBufferString oNewMsg, tmp, lNewOffset
                SendToDirect oNewMsg, pID
                
                lNewMsg = MSG_ICON
                lNewOffset = 0
                ReDim oNewMsg(0)
                AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
                AddBufferData oNewMsg, VarPtr(I), LenB(I), lNewOffset
                B = UserDat(I).Icon
                AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
                SendToDirect oNewMsg, pID
            End If
        End If
    Next
End Sub

Public Function CreateRoom(RoomName As String, RoomOwner As String)
    Dim I As Integer, lNewMsg As Byte, oNewMsg() As Byte, lNewOffset As Long, X As Integer, tmp As String
    Dim c As Integer
    c = GetPN2(RoomOwner)
    For I = 0 To UBound(Rooms)
        If IsEmptyString(Rooms(I).RoomName) Then
            Exit For
        End If
    Next
    If I > UBound(Rooms) Then
        ReDim Preserve Rooms(I)
        Set Rooms(I) = New clsChatRoom
    End If
    Rooms(I).RoomIndex = I
    Rooms(I).RoomName = RoomName
    Rooms(I).Promote RoomOwner
    lNewMsg = MSG_ADDROOM
    lNewOffset = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
    X = Rooms(I).RoomIndex
    AddBufferData oNewMsg, VarPtr(X), LenB(X), lNewOffset
    tmp = Rooms(I).RoomName
    AddBufferString oNewMsg, tmp, lNewOffset
    SendTo oNewMsg, -1
    If Not StringComp(RoomOwner, "Cobalt") Then JoinRoom c, I
End Function

Public Function DeleteRoom(RoomIndex As Integer)
    Dim I As Integer, lNewMsg As Byte, oNewMsg() As Byte, lNewOffset As Long, X As Integer, tmp As String
    lNewMsg = MSG_REMOVEROOM
    lNewOffset = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
    X = RoomIndex
    AddBufferData oNewMsg, VarPtr(X), LenB(X), lNewOffset
    SendTo oNewMsg, -1
    For I = 1 To UBound(UserDat)
        If Not UserDat(I) Is Nothing Then
            If UserDat(I).Room = RoomIndex Then
                JoinRoom I, 0
            End If
        End If
    Next
    Rooms(RoomIndex).Cleanup
End Function

'Very Fast String Comparison Function
'                    by Steven Noonan
'   - operates at 2.7 million operations per second with
'     two strings of different lengths (non-equal)
'   - operates at 619 thousand operations per second with
'     two strings that are identical (case variation included)
Public Function StringComp(ByRef sStringOne As String, ByRef sStringTwo As String) As Boolean
    Dim Result As Integer
    If LenB(sStringOne) <> LenB(sStringTwo) Then Exit Function
    Result = StrComp(sStringOne, sStringTwo, vbTextCompare)
    If Result = 0 Then
        StringComp = True
    Else
        StringComp = False
    End If
End Function

'Very Fast Empty String Test
'           by Steven Noonan
'   - operates at 15.4 million operations per second
Public Function IsEmptyString(ByRef sString As String) As Boolean
    IsEmptyString = LenB(sString) = 0
End Function
