Attribute VB_Name = "modNetwork"
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

Public Enum MSGTYPES
    MSG_NULL '0
    MSG_LOGIN '1
    MSG_PLAYERS '2
    MSG_ADDPLAYER '3
    MSG_REMOVEPLAYER '4
    MSG_GOTHEALTH '5
    MSG_CONNECTED '6
    MSG_SERVERMSG '7
    MSG_GAMELOGIN '8
    MSG_GAMEDATA '9
    MSG_GAMECHAT '10
    MSG_DIED '11
    MSG_NULLPLAYER '12
    MSG_POWERUP '13
    MSG_TEAM '14
    MSG_BOMB '15
    MSG_MISS '16
    MSG_LASER '17
    MSG_MINES '18
    MSG_GETFLAG '19
    MSG_DROPFLAG '20
    MSG_FLAGS '21
    MSG_PLAYING '22
    MSG_BOUNCY '23
    MSG_GAMESETTINGS '24
    MSG_PLAYERHOME '25
    MSG_SCORE '26
    MSG_MAP '27
    MSG_PLAYERSCORE '28
    MSG_ARMORLO '29
    MSG_SWITCH '30
    MSG_GETSWITCH '31
    MSG_PSPEED '32
    MSG_GAG '33
    MSG_MAPTRANSFER '34
    MSG_PING '35
    MSG_UPDATE '36
    MSG_NEWKEY '37
    MSG_FORCEPOS '38
    MSG_WEPSYNC '39
    MSG_WARPING '40
    MSG_UNIBALL '41
    MSG_TIMELIMIT '42
    MSG_ERROR '43
    MSG_UDPOK '44
    MSG_MODE '45
    MSG_UDPSTOP '46
    MSG_HEALTHFORCE '47
    MSG_DEVCHEAT '48 -- only for development testing.
End Enum

Public EncPassword As String

Public NoUDP As Boolean

Public Sub AddBufferData(BufferData() As Byte, vPtr As Long, lLen As Integer, lOffset As Long)
    If lOffset = 0 Then ReDim BufferData(lLen + 1) Else ReDim Preserve BufferData(UBound(BufferData) + lLen + 2)
    CopyMemory BufferData(lOffset), lLen, 2
    lOffset = lOffset + 2
    CopyMemory BufferData(lOffset), ByVal vPtr, lLen
    lOffset = lOffset + lLen
End Sub

Public Function AddBufferString(BufferData() As Byte, ByVal tmp As String, lOffset As Long) As String
    Dim I As Integer
    If Encrypted Then tmp = Encryption.EncryptString(tmp, EncPassword)
    I = Len(tmp)
    If lOffset = 0 Then ReDim BufferData(I + 1) Else ReDim Preserve BufferData(UBound(BufferData) + I + 2)
    CopyMemory BufferData(lOffset), I, 2
    lOffset = lOffset + 2
    CopyMemory BufferData(lOffset), ByVal tmp, Len(tmp)
    lOffset = lOffset + Len(tmp)
End Function

Public Sub GetBufferData(BufferData() As Byte, vPtr As Long, lLen As Integer, lOffset As Long)
    'On Error Resume Next
    Dim I As Integer
    CopyMemory I, BufferData(lOffset), 2
    lOffset = lOffset + 2
    If I <> lLen Then Err.Raise 1, , "Sizes didn't match. Bugger." ' DELETE ME ?
    CopyMemory ByVal vPtr, BufferData(lOffset), lLen
    lOffset = lOffset + lLen
End Sub

Public Sub GetBufferData_Old(BufferData() As Byte, vPtr As Long, lLen As Integer, lOffset As Long)
    CopyMemory ByVal vPtr, BufferData(lOffset), lLen
    lOffset = lOffset + lLen
End Sub

Public Function GetBufferString(BufferData() As Byte, lOffset As Long) As String
    On Error GoTo errors
    Dim tmp As String, lLen As Integer
    CopyMemory lLen, BufferData(lOffset), 2
    If lLen > 512 Or lLen < 1 Then DebugLog "Abnormal string length detected at" & NewGTC & ". (" & lLen & ")"
    lOffset = lOffset + 2
    tmp = String$(lLen, Chr$(0))
    CopyMemory ByVal tmp, BufferData(lOffset), lLen
    lOffset = lOffset + lLen
    If Encrypted Then tmp = Encryption.DecryptString(tmp, EncPassword)
    GetBufferString = tmp
    Exit Function
errors:
    GetBufferString = "XDecryptFailure"
    Err.Clear
End Function

Public Sub SendTo(Buff() As Byte, Optional Guaranteed As Boolean = True)
    Dim b As Byte
    Dim Size As Integer
    
    Size = 1
    b = 3
    
    ReDim Preserve Buff(UBound(Buff) + 3)
    CopyMemory Buff(UBound(Buff) - 2), Size, 2
    CopyMemory Buff(UBound(Buff)), b, 1
    
    ReDim SendBuffer(UBound(Buff) + 2) As Byte
    Size = UBound(Buff) + 1
    CopyMemory SendBuffer(0), Size, 2
    CopyMemory SendBuffer(2), Buff(0), UBound(Buff) + 1
    
    If bDebugLog = 1 Then DebugLog Buff(0) & " " & NewGTC & " OUT"
    If Guaranteed Or NoUDP Then
        If bDebugLog = 1 Then DebugLog Buff(0) & " " & NewGTC & " OUT TCP :)"
        frmMain.SocketTCP.WriteBytes SendBuffer, UBound(SendBuffer) + 1
    End If
    If Not Guaranteed And Not NoUDP Then
        If bDebugLog = 1 Then DebugLog Buff(0) & " " & NewGTC & " OUT UDP :)"
        frmMain.SocketUDPOUT.WriteBytes SendBuffer, UBound(SendBuffer) + 1
    End If
End Sub


Public Sub InitSocket()
    If StartLog Then
        StartupLog "Initializing sockets..."
    End If
    If Not DevEnv Then On Error GoTo errormanager
    If StartLog Then
        StartupLog "Binding UDP " & Port + 5 & " (in)..."
    End If
    frmMain.SocketUDPIN.AddressFamily = AF_INET
    frmMain.SocketUDPIN.Binary = True
    frmMain.SocketUDPIN.Blocking = False
    frmMain.SocketUDPIN.Protocol = IPPROTO_IP
    frmMain.SocketUDPIN.SocketType = SOCK_DGRAM
    frmMain.SocketUDPIN.LocalPort = Port + 5
    frmMain.SocketUDPIN.Action = SOCKET_OPEN
    If StartLog Then
        StartupLog "Complete."
    End If
    
    If StartLog Then
        StartupLog "Binding UDP " & Port & " (out)..."
    End If
    frmMain.SocketUDPOUT.AddressFamily = AF_INET
    frmMain.SocketUDPOUT.Binary = True
    frmMain.SocketUDPOUT.Blocking = False
    frmMain.SocketUDPOUT.Protocol = IPPROTO_IP
    frmMain.SocketUDPOUT.SocketType = SOCK_DGRAM
    frmMain.SocketUDPOUT.HostName = HostAddy
    frmMain.SocketUDPOUT.RemotePort = Port
    frmMain.SocketUDPOUT.Action = SOCKET_OPEN
    If StartLog Then
        StartupLog "Complete."
    End If
    
    If StartLog Then
        StartupLog "Connecting to " & HostAddy & ":" & Port & " (out)..."
    End If
    frmMain.SocketTCP.AddressFamily = AF_INET
    frmMain.SocketTCP.Protocol = IPPROTO_IP
    frmMain.SocketTCP.SocketType = SOCK_STREAM
    frmMain.SocketTCP.LocalPort = IPPORT_ANY
    frmMain.SocketTCP.Binary = True
    frmMain.SocketTCP.BufferSize = 512
    frmMain.SocketTCP.Blocking = False
    frmMain.SocketTCP.AutoResolve = False
    frmMain.SocketTCP.HostName = HostAddy
    frmMain.SocketTCP.RemoteService = Port
    frmMain.SocketTCP.Connect
    Exit Sub
errormanager:
    RaiseCritical "Socket initialization failed: " & vbNewLine & Err.Number & " " & Err.Description & " " & Err.Source
End Sub

Function DataProcess(ReceivedData() As Byte, ReceivedLen As Long) As Integer
    If Not DevEnv Then On Error GoTo ErrorTrap
    Dim BS As Single
    Dim MsgType As Byte, strPlayer As String, L As Long, L2 As Long
    Dim X As Integer, b As Byte
    Dim tmp As String
    Dim j As Integer, d As Integer, e As Integer, a As Integer, C As Integer, sc As Integer, iFreeFile As Integer
    Dim xt As Integer, yt As Integer, b2 As Byte
    Dim T1 As Byte, T2 As Byte, T3 As Integer, T4 As Integer
    Dim lMsg As Byte
    Dim oNewMsg() As Byte, lNewOffSet As Long
    Dim lOffset As Long
nextpacket:
    lOffset = lOffset + 2
    GetBufferData ReceivedData, VarPtr(MsgType), LenB(MsgType), lOffset
    If bDebugLog = 1 Then DebugLog MsgType & " " & NewGTC & " processing."
    Select Case MsgType
        Case 0
            GoTo done
        Case MSG_LOGIN
            If Playing Then GoTo done
            If Not frmMain.Timer3.Enabled Then GoTo done
            frmMain.Timer3.Enabled = False
            frmMain.Hide
            frmDisplay.Timer1.Enabled = True
        Case MSG_PLAYING
            Playing = True
            If Players(MeNum).Ship = 5 Then
                MenuMenu = 2
            End If
            Players(MeNum).animX = 9
            If EnableSound Then dsWelcome.Play DSBPLAY_DEFAULT
        Case MSG_CONNECTED
            GetBufferData ReceivedData, VarPtr(MeNum), LenB(MeNum), lOffset
            lNewOffSet = 0
            ReDim oNewMsg(0)
            SetLoadTitle "Logging in..."
            StartupTime = NewGTC
            lMsg = MSG_GETSWITCH
            AddBufferData oNewMsg, VarPtr(lMsg), LenB(lMsg), lNewOffSet
            SendTo oNewMsg
        Case MSG_REMOVEPLAYER
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            If Not Playing Then GoTo done
            If b = MeNum Then GoTo done
            Players(b).Nick = vbNullString
            Players(b).charX = 0
            Players(b).charY = 0
        Case MSG_PLAYERS
            SetLoadTitle "Receiving player list..."
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            If b > UBound(Players) Then ReDim Preserve Players(b)
            Players(b).Nick = GetBufferString(ReceivedData, lOffset)
            GetBufferData ReceivedData, VarPtr(b2), LenB(b2), lOffset
            Players(b).Ship = b2
            If Players(b).Ship = 10 Then
                Players(b).Invisible = True
            End If
            GetBufferData ReceivedData, VarPtr(sc), LenB(sc), lOffset
            Players(b).Score = sc
            GetBufferData ReceivedData, VarPtr(b2), LenB(b2), lOffset
            Players(b).Admin = b2
            GetBufferData ReceivedData, VarPtr(b2), LenB(b2), lOffset
            Players(b).DevCheat = b2
        Case MSG_SERVERMSG
            strPlayer = GetBufferString(ReceivedData, lOffset)
            MsgBox strPlayer, vbExclamation, "Server Message"
        Case MSG_GAMELOGIN
            SetLoadTitle "Loading map..."
            LoadMap
            'RefreshMap
            If Stopping Then
                Unload frmMain
                Unload frmSplash
                Exit Function
            End If
            lNewOffSet = 0
            ReDim oNewMsg(0)
            SetLoadTitle "Receiving server info..."
            lMsg = MSG_UPDATE
            AddBufferData oNewMsg, VarPtr(lMsg), LenB(lMsg), lNewOffSet
            SendTo oNewMsg
        Case MSG_GAMEDATA
            Dim playercount As Byte
            GetBufferData ReceivedData, VarPtr(playercount), LenB(playercount), lOffset
            For sc = 1 To playercount
                GetBufferData ReceivedData, VarPtr(T1), LenB(T1), lOffset
                If T1 > UBound(Players) Then GoTo skip
                If LenB(Players(T1).Nick) = 0 Then GoTo skip
                GetBufferData ReceivedData, VarPtr(T2), LenB(T2), lOffset
                GetBufferData ReceivedData, VarPtr(T3), LenB(T3), lOffset
                GetBufferData ReceivedData, VarPtr(T4), LenB(T4), lOffset
                If T1 <> MeNum Then
                    Players(T1).KeyIs = T2
                    If Players(T1).Invisible Then
                        Players(T1).KeyIs = 9
                    Else
                        Players(T1).KeyIs = T2
                    End If
                    If NewGTC > Players(T1).NextSync Then
                        Players(T1).charX = T3
                        Players(T1).charY = T4
                        Players(T1).NextSync = NewGTC + 1500
                    End If
                End If
skip:
            Next
        Case MSG_HEALTHFORCE
            GetBufferData ReceivedData, VarPtr(T3), LenB(T3), lOffset
            If T3 < 0 Then T3 = 0
            Health = T3
        Case MSG_NEWKEY
            GetBufferData ReceivedData, VarPtr(b2), LenB(b2), lOffset
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            If Not Playing Then GoTo done
            If b2 <> MeNum Then
                Players(b2).KeyIs = b
                Players(b2).NextSync = 0
            End If
        Case MSG_GAMECHAT
            strPlayer = GetBufferString(ReceivedData, lOffset)
            tmp = vbNullString
            If InStr(strPlayer, ":") Then
                tmp = Mid$(strPlayer, 2, InStr(strPlayer, ":") - 2)
                If IsIgnored(tmp) Then GoTo done
            End If
            If InStr(strPlayer, "(TO TEAM>") Then
                tmp = Mid$(strPlayer, 2, InStr(strPlayer, "(TO TEAM>") - 3)
                If IsIgnored(tmp) Then GoTo done
            End If
            If StartLog Then
                StartupLog "GAME CHAT: " & strPlayer
            End If
            GameChat strPlayer
        Case MSG_NULLPLAYER
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            If b > UBound(Players) Then GoTo done
            Players(b).charX = 0
            Players(b).charY = 0
            Players(b).Score = 0
            Players(b).Ship = 0
            Players(b).Nick = vbNullString
        Case MSG_TEAM
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            GetBufferData ReceivedData, VarPtr(b2), LenB(b2), lOffset
            If Not Playing Then GoTo done
            Players(b).KeyIs = 9
            If Players(b).Invisible <> True And Players(b).Mode <> 1 Then
                Players(b).Invisible = True
                PopShip newCInt(Players(b).charX) + 16, newCInt(Players(b).charY) + 16
                T3 = Players(b).charX - MeX
                T4 = Players(b).charY - MeY
                If T3 > -50 And T4 > -50 And T3 < ResX + 50 And T4 < ResY + 50 Then SndPop T3 - CenterX, T4 - CenterY
            Else
                Players(b).Invisible = True
            End If
            Players(b).Ship = b2
        Case MSG_LASER
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            GetBufferData ReceivedData, VarPtr(X), LenB(X), lOffset
            GetBufferData ReceivedData, VarPtr(j), LenB(j), lOffset
            GetBufferData ReceivedData, VarPtr(T3), LenB(T3), lOffset
            GetBufferData ReceivedData, VarPtr(T4), LenB(T4), lOffset
            If Not Playing Then GoTo done
            If b <> MeNum Then FireLaser b, X, j, T3, T4
        Case MSG_MISS
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            GetBufferData ReceivedData, VarPtr(X), LenB(X), lOffset
            GetBufferData ReceivedData, VarPtr(j), LenB(j), lOffset
            GetBufferData ReceivedData, VarPtr(T3), LenB(T3), lOffset
            GetBufferData ReceivedData, VarPtr(T4), LenB(T4), lOffset
            If Not Playing Then GoTo done
            If b <> MeNum Then FireMiss b, X, j, T3, T4
        Case MSG_BOMB
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            GetBufferData ReceivedData, VarPtr(X), LenB(X), lOffset
            GetBufferData ReceivedData, VarPtr(j), LenB(j), lOffset
            GetBufferData ReceivedData, VarPtr(T3), LenB(T3), lOffset
            GetBufferData ReceivedData, VarPtr(T4), LenB(T4), lOffset
            If Not Playing Then GoTo done
            If b <> MeNum Then FireMort b, X, j, T3, T4
        Case MSG_BOUNCY
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            GetBufferData ReceivedData, VarPtr(X), LenB(X), lOffset
            GetBufferData ReceivedData, VarPtr(j), LenB(j), lOffset
            GetBufferData ReceivedData, VarPtr(T3), LenB(T3), lOffset
            GetBufferData ReceivedData, VarPtr(T4), LenB(T4), lOffset
            If Not Playing Then GoTo done
            If b <> MeNum Then FireBounce b, X, j, T3, T4
        Case MSG_MINES
            'SetLoadTitle"Receiving mine locations..."
            GetBufferData ReceivedData, VarPtr(sc), LenB(sc), lOffset 'Mine ID
            If sc < 0 Then 'detonates the mine when someone goes over it
                sc = Abs(sc) - 1
                If sc <= UBound(Mines) Then
                    For j = 0 To UBound(Mines)
                        If Mines(j).Idx = sc And Mines(j).Color > 0 Then
                            T3 = Mines(j).X
                            T4 = Mines(j).y
                            If T3 - MeX > -60 And T4 - MeY > -60 And T3 - MeX < ResX + 60 And T4 - MeY < ResY + 60 Then
                                SndMine T3 - MeX - CenterX, T4 - MeY - CenterY
                            End If
                            Mines(j).Tick = NewGTC
                        End If
                    Next
                End If
                GoTo done
            End If
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset 'Who?
            GetBufferData ReceivedData, VarPtr(b2), LenB(b2), lOffset 'Color
            GetBufferData ReceivedData, VarPtr(T3), LenB(T3), lOffset 'X
            GetBufferData ReceivedData, VarPtr(T4), LenB(T4), lOffset 'Y
            SetMine newCInt(sc), b, b2, T3, T4
        Case MSG_GETFLAG
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            X = b 'who
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            j = b 'flag Color
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            sc = b 'flag array
            GetBufferData ReceivedData, VarPtr(xt), LenB(xt), lOffset
            GetBufferData ReceivedData, VarPtr(yt), LenB(yt), lOffset
            If Not Playing Then GoTo done
            Players(X).FlagID = sc
            If j = 1 Then
                FlagCarry1(sc) = X
                Players(X).FlagWho = j
            ElseIf j = 2 Then
                FlagCarry2(sc) = X
                Players(X).FlagWho = j
            ElseIf j = 3 Then
                FlagCarry3(sc) = X
                Players(X).FlagWho = j
            ElseIf j = 4 Then
                FlagCarry4(sc) = X
                Players(X).FlagWho = j
            ElseIf j = 5 Then
                FlagCarry5(sc) = X
                Players(X).FlagWho = j
            End If
            xt = xt \ 16
            yt = yt \ 16
            On Error GoTo done
            If j = 1 And Animations(yt, xt) = 28 Then Animations(yt, xt) = 24
            If j = 2 And Animations(yt, xt) = 29 Then Animations(yt, xt) = 25
            If j = 3 And Animations(yt, xt) = 30 Then Animations(yt, xt) = 26
            If j = 4 And Animations(yt, xt) = 31 Then Animations(yt, xt) = 27
            If j = 5 And Animations(yt, xt) = 132 Then Animations(yt, xt) = 128
            If j = 1 And Animations(yt, xt) = 36 Then Animations(yt, xt) = 32
            If j = 2 And Animations(yt, xt) = 37 Then Animations(yt, xt) = 33
            If j = 3 And Animations(yt, xt) = 38 Then Animations(yt, xt) = 34
            If j = 4 And Animations(yt, xt) = 39 Then Animations(yt, xt) = 35
            If j = 5 And Animations(yt, xt) = 133 Then Animations(yt, xt) = 129
            If j = 1 And Animations(yt, xt) = 44 Then Animations(yt, xt) = 40
            If j = 2 And Animations(yt, xt) = 45 Then Animations(yt, xt) = 41
            If j = 3 And Animations(yt, xt) = 46 Then Animations(yt, xt) = 42
            If j = 4 And Animations(yt, xt) = 47 Then Animations(yt, xt) = 43
            If j = 5 And Animations(yt, xt) = 134 Then Animations(yt, xt) = 130
            If j = 1 And Animations(yt, xt) = 62 Then Animations(yt, xt) = 58
            If j = 2 And Animations(yt, xt) = 63 Then Animations(yt, xt) = 59
            If j = 3 And Animations(yt, xt) = 64 Then Animations(yt, xt) = 60
            If j = 4 And Animations(yt, xt) = 65 Then Animations(yt, xt) = 61
            If j = 5 And Animations(yt, xt) = 135 Then Animations(yt, xt) = 131
            If j = 5 And Animations(yt, xt) = 132 Then Animations(yt, xt) = 128
            If j = 5 And Animations(yt, xt) = 133 Then Animations(yt, xt) = 129
            If j = 5 And Animations(yt, xt) = 134 Then Animations(yt, xt) = 130
            If j = 5 And Animations(yt, xt) = 135 Then Animations(yt, xt) = 131
            If j = 5 And Animations(yt, xt) = 140 Then Animations(yt, xt) = 136
            d = UBound(Captured) + 1
            ReDim Preserve Captured(d)
            ReDim Preserve FlagCap(d)
            ReDim Preserve WhoTeam(d)
            ReDim Preserve FlagStatus(d)
            FlagStatus(d) = 1
            Captured(d) = True
            FlagCap(d) = j
            WhoTeam(d) = Players(X).Ship
        Case MSG_DROPFLAG
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            e = b 'drop type
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            X = b 'who
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            sc = b 'flag Color
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            d = b 'flag array
            GetBufferData ReceivedData, VarPtr(T3), LenB(T3), lOffset
            GetBufferData ReceivedData, VarPtr(T4), LenB(T4), lOffset

            If Not Playing Then GoTo done
            '
            If sc = 1 Then
                xt = Flag1(0, d)
                yt = Flag1(1, d)
            ElseIf sc = 2 Then
                xt = Flag2(0, d)
                yt = Flag2(1, d)
            ElseIf sc = 3 Then
                xt = Flag3(0, d)
                yt = Flag3(1, d)
            ElseIf sc = 4 Then
                xt = Flag4(0, d)
                yt = Flag4(1, d)
            ElseIf sc = 5 Then
                xt = Flag5(0, d)
                yt = Flag5(1, d)
            End If
            If xt Mod 16 = 0 And yt Mod 16 = 0 Then
                xt = xt \ 16
                yt = yt \ 16
                If sc = 1 And Animations(yt, xt) = 28 Then Animations(yt, xt) = 24
                If sc = 2 And Animations(yt, xt) = 29 Then Animations(yt, xt) = 25
                If sc = 3 And Animations(yt, xt) = 30 Then Animations(yt, xt) = 26
                If sc = 4 And Animations(yt, xt) = 31 Then Animations(yt, xt) = 27
                If sc = 5 And Animations(yt, xt) = 132 Then Animations(yt, xt) = 128
                If sc = 1 And Animations(yt, xt) = 36 Then Animations(yt, xt) = 32
                If sc = 2 And Animations(yt, xt) = 37 Then Animations(yt, xt) = 33
                If sc = 3 And Animations(yt, xt) = 38 Then Animations(yt, xt) = 34
                If sc = 4 And Animations(yt, xt) = 39 Then Animations(yt, xt) = 35
                If sc = 5 And Animations(yt, xt) = 133 Then Animations(yt, xt) = 129
                If sc = 1 And Animations(yt, xt) = 44 Then Animations(yt, xt) = 40
                If sc = 2 And Animations(yt, xt) = 45 Then Animations(yt, xt) = 41
                If sc = 3 And Animations(yt, xt) = 46 Then Animations(yt, xt) = 42
                If sc = 4 And Animations(yt, xt) = 47 Then Animations(yt, xt) = 43
                If sc = 5 And Animations(yt, xt) = 134 Then Animations(yt, xt) = 130
                If sc = 1 And Animations(yt, xt) = 62 Then Animations(yt, xt) = 58
                If sc = 2 And Animations(yt, xt) = 63 Then Animations(yt, xt) = 59
                If sc = 3 And Animations(yt, xt) = 64 Then Animations(yt, xt) = 60
                If sc = 4 And Animations(yt, xt) = 65 Then Animations(yt, xt) = 61
                If sc = 5 And Animations(yt, xt) = 135 Then Animations(yt, xt) = 131
                If sc = 5 And Animations(yt, xt) = 140 Then Animations(yt, xt) = 136
            End If
            '
            xt = T3
            yt = T4
            If e <> 2 Then SndDropFlag
            If e = 2 Then
                xt = xt \ 16
                yt = yt \ 16
                If Players(X).Ship = 1 And sc = 1 And Animations(yt, xt) = 24 Then Animations(yt, xt) = 28
                If Players(X).Ship = 1 And sc = 2 And Animations(yt, xt) = 25 Then Animations(yt, xt) = 29
                If Players(X).Ship = 1 And sc = 3 And Animations(yt, xt) = 26 Then Animations(yt, xt) = 30
                If Players(X).Ship = 1 And sc = 4 And Animations(yt, xt) = 27 Then Animations(yt, xt) = 31
                If Players(X).Ship = 1 And sc = 5 And Animations(yt, xt) = 128 Then Animations(yt, xt) = 132
                If Players(X).Ship = 2 And sc = 1 And Animations(yt, xt) = 32 Then Animations(yt, xt) = 36
                If Players(X).Ship = 2 And sc = 2 And Animations(yt, xt) = 33 Then Animations(yt, xt) = 37
                If Players(X).Ship = 2 And sc = 3 And Animations(yt, xt) = 34 Then Animations(yt, xt) = 38
                If Players(X).Ship = 2 And sc = 4 And Animations(yt, xt) = 35 Then Animations(yt, xt) = 39
                If Players(X).Ship = 2 And sc = 5 And Animations(yt, xt) = 129 Then Animations(yt, xt) = 133
                If Players(X).Ship = 3 And sc = 1 And Animations(yt, xt) = 40 Then Animations(yt, xt) = 44
                If Players(X).Ship = 3 And sc = 2 And Animations(yt, xt) = 41 Then Animations(yt, xt) = 45
                If Players(X).Ship = 3 And sc = 3 And Animations(yt, xt) = 42 Then Animations(yt, xt) = 46
                If Players(X).Ship = 3 And sc = 4 And Animations(yt, xt) = 43 Then Animations(yt, xt) = 47
                If Players(X).Ship = 3 And sc = 5 And Animations(yt, xt) = 130 Then Animations(yt, xt) = 134
                If Players(X).Ship = 4 And sc = 1 And Animations(yt, xt) = 58 Then Animations(yt, xt) = 62
                If Players(X).Ship = 4 And sc = 2 And Animations(yt, xt) = 59 Then Animations(yt, xt) = 63
                If Players(X).Ship = 4 And sc = 3 And Animations(yt, xt) = 60 Then Animations(yt, xt) = 64
                If Players(X).Ship = 4 And sc = 4 And Animations(yt, xt) = 61 Then Animations(yt, xt) = 65
                If Players(X).Ship = 4 And sc = 5 And Animations(yt, xt) = 131 Then Animations(yt, xt) = 135
                If Players(X).Ship = 5 And sc = 5 And Animations(yt, xt) = 136 Then Animations(yt, xt) = 140
                xt = xt * 16
                yt = yt * 16
            End If
            If sc = 1 Then
                FlagCarry1(d) = 0
                Flag1(0, d) = xt
                Flag1(1, d) = yt
            ElseIf sc = 2 Then
                FlagCarry2(d) = 0
                Flag2(0, d) = xt
                Flag2(1, d) = yt
            ElseIf sc = 3 Then
                FlagCarry3(d) = 0
                Flag3(0, d) = xt
                Flag3(1, d) = yt
            ElseIf sc = 4 Then
                FlagCarry4(d) = 0
                Flag4(0, d) = xt
                Flag4(1, d) = yt
            ElseIf sc = 5 Then
                FlagCarry5(d) = 0
                Flag5(0, d) = xt
                Flag5(1, d) = yt
            End If
            Players(X).FlagWho = 0
            Players(X).FlagID = 0
            If e <> 2 Then
                FlagBlinkT(sc - 1, d) = NewGTC
                FlagBlinking(sc - 1, d) = NewGTC
                GoTo done
            End If
            d = UBound(Captured) + 1
            ReDim Preserve Captured(d)
            ReDim Preserve FlagCap(d)
            ReDim Preserve WhoTeam(d)
            ReDim Preserve FlagStatus(d)
            FlagStatus(d) = 2
            Captured(d) = True
            FlagCap(d) = sc
            WhoTeam(d) = Players(X).Ship
        Case MSG_FLAGS
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            X = b 'Color
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            a = b 'flag numb
            GetBufferData ReceivedData, VarPtr(sc), LenB(sc), lOffset 'flag x
            GetBufferData ReceivedData, VarPtr(C), LenB(C), lOffset 'flag y
            GetBufferData ReceivedData, VarPtr(j), LenB(j), lOffset 'flag carry
            xt = sc \ 16: yt = C \ 16
            If yt > UBound(Animations, 1) Or xt > UBound(Animations, 1) Then GoTo done
            If X = 1 And Animations(yt, xt) = 24 Then Animations(yt, xt) = 28
            If X = 2 And Animations(yt, xt) = 25 Then Animations(yt, xt) = 29
            If X = 3 And Animations(yt, xt) = 26 Then Animations(yt, xt) = 30
            If X = 4 And Animations(yt, xt) = 27 Then Animations(yt, xt) = 31
            If X = 5 And Animations(yt, xt) = 128 Then Animations(yt, xt) = 132
            If X = 1 And Animations(yt, xt) = 32 Then Animations(yt, xt) = 36
            If X = 2 And Animations(yt, xt) = 33 Then Animations(yt, xt) = 37
            If X = 3 And Animations(yt, xt) = 34 Then Animations(yt, xt) = 38
            If X = 4 And Animations(yt, xt) = 35 Then Animations(yt, xt) = 39
            If X = 5 And Animations(yt, xt) = 129 Then Animations(yt, xt) = 133
            If X = 1 And Animations(yt, xt) = 40 Then Animations(yt, xt) = 44
            If X = 2 And Animations(yt, xt) = 41 Then Animations(yt, xt) = 45
            If X = 3 And Animations(yt, xt) = 42 Then Animations(yt, xt) = 46
            If X = 4 And Animations(yt, xt) = 43 Then Animations(yt, xt) = 47
            If X = 5 And Animations(yt, xt) = 130 Then Animations(yt, xt) = 134
            If X = 1 And Animations(yt, xt) = 58 Then Animations(yt, xt) = 62
            If X = 2 And Animations(yt, xt) = 59 Then Animations(yt, xt) = 63
            If X = 3 And Animations(yt, xt) = 60 Then Animations(yt, xt) = 64
            If X = 4 And Animations(yt, xt) = 61 Then Animations(yt, xt) = 65
            'If X = 5 And Animations(yt, xt) = 128 Then Animations(yt, xt) = 135
            'If X = 5 And Animations(yt, xt) = 129 Then Animations(yt, xt) = 135
            'If X = 5 And Animations(yt, xt) = 130 Then Animations(yt, xt) = 135
            If X = 5 And Animations(yt, xt) = 131 Then Animations(yt, xt) = 135
            If X = 5 And Animations(yt, xt) = 136 Then Animations(yt, xt) = 140
            If a > UBound(FlagBlinkT, 2) Then ReDim FlagBlinkT(4, a), FlagBlink(4, a), FlagBlinking(4, a)
            Players(j).FlagWho = X
            Players(j).FlagID = a
            If X = 1 Then
                If a > UBound(Flag1, 2) Then
                    ReDim Preserve Flag1(1, a), FlagCarry1(a)
                End If
                xt = Flag1(0, a) \ 16: yt = Flag1(1, a) \ 16
                If Animations(yt, xt) = 36 Then Animations(yt, xt) = 32
                If Animations(yt, xt) = 44 Then Animations(yt, xt) = 40
                If Animations(yt, xt) = 62 Then Animations(yt, xt) = 58
                Flag1(0, a) = sc
                Flag1(1, a) = C
                FlagCarry1(a) = j
            ElseIf X = 2 Then
                If a > UBound(Flag2, 2) Then
                    ReDim Preserve Flag2(1, a), FlagCarry2(a)
                End If
                xt = Flag2(0, a) \ 16: yt = Flag2(1, a) \ 16
                If Animations(yt, xt) = 29 Then Animations(yt, xt) = 25
                If Animations(yt, xt) = 45 Then Animations(yt, xt) = 41
                If Animations(yt, xt) = 63 Then Animations(yt, xt) = 59
                Flag2(0, a) = sc
                Flag2(1, a) = C
                FlagCarry2(a) = j
            ElseIf X = 3 Then
                If a > UBound(Flag3, 2) Then
                    ReDim Preserve Flag3(1, a), FlagCarry3(a)
                End If
                xt = Flag3(0, a) \ 16: yt = Flag3(1, a) \ 16
                If Animations(yt, xt) = 30 Then Animations(yt, xt) = 26
                If Animations(yt, xt) = 38 Then Animations(yt, xt) = 34
                If Animations(yt, xt) = 64 Then Animations(yt, xt) = 60
                Flag3(0, a) = sc
                Flag3(1, a) = C
                FlagCarry3(a) = j
            ElseIf X = 4 Then
                If a > UBound(Flag4, 2) Then
                    ReDim Preserve Flag4(1, a), FlagCarry4(a)
                End If
                xt = Flag4(0, a) \ 16: yt = Flag4(1, a) \ 16
                If Animations(yt, xt) = 31 Then Animations(yt, xt) = 27
                If Animations(yt, xt) = 39 Then Animations(yt, xt) = 35
                If Animations(yt, xt) = 47 Then Animations(yt, xt) = 43
                Flag4(0, a) = sc
                Flag4(1, a) = C
                FlagCarry4(a) = j
            ElseIf X = 5 Then
                If a > UBound(Flag5, 2) Then
                    ReDim Preserve Flag5(1, a), FlagCarry5(a)
                End If
                xt = Flag5(0, a) \ 16: yt = Flag5(1, a) \ 16
                If Animations(yt, xt) = 132 Then Animations(yt, xt) = 128
                If Animations(yt, xt) = 133 Then Animations(yt, xt) = 129
                If Animations(yt, xt) = 134 Then Animations(yt, xt) = 130
                If Animations(yt, xt) = 135 Then Animations(yt, xt) = 131
                Flag5(0, a) = sc
                Flag5(1, a) = C
                FlagCarry5(a) = j
            End If
        Case MSG_DIED
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            GetBufferData ReceivedData, VarPtr(C), LenB(C), lOffset
            GetBufferData ReceivedData, VarPtr(e), LenB(e), lOffset
            If b = MeNum And Players(MeNum).Invisible = True Then GoTo done
            If b > UBound(Players) Then GoTo done
            If Not Playing Then GoTo done
            PopShip newCInt(Players(b).charX) + 16, newCInt(Players(b).charY) + 16
            Players(b).KeyIs = 9
            Players(b).Invisible = True
            If Players(b).MoveX > -50 And Players(b).MoveY > -50 And Players(b).MoveX < ResX + 50 And Players(b).MoveY < ResY + 50 Then SndPop (Players(b).charX - MeX) - CenterX, (Players(b).charY - MeY) - CenterY
            If C = -1 Then GoTo done 'Weapon didn't destroy them.
            If StartLog Then
                StartupLog "NOTICE: Player '" & Players(b).Nick & "' killed by a " & Choose(C, "laser", "missile", "grenade", "bouncy laser") & " at " & Players(b).charX & "," & Players(b).charY & "."
            End If
            If C = 0 Then 'Lasers
                Laser(e) = False
            ElseIf C = 1 Then 'Missiles
                Miss(e) = False
            ElseIf C = 2 Then 'Grenade shell
                'Grenade shells don't need to be marked false. They can explode on their own without ill effects.
            ElseIf C = 3 Then 'Bouncies
                Bounce(e) = False
            End If
        Case MSG_GAMESETTINGS
            SetLoadTitle "Receiving game settings..."
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            WepRge.LaserDamage = b
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            WepRge.SpecialDamage = b
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            WepRge.RechargeRate = b
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            WepRge.Mines = b
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            WepRge.HldTme = Val(CLng(b) * 1000)
        Case MSG_PLAYERHOME
            GetBufferData ReceivedData, VarPtr(X), LenB(X), lOffset
            d = UBound(Captured) + 1
            ReDim Preserve Captured(d)
            ReDim Preserve FlagCap(d)
            ReDim Preserve WhoTeam(d)
            ReDim Preserve FlagStatus(d)
            FlagStatus(d) = 3
            Captured(d) = True
            FlagCap(d) = X
            WhoTeam(d) = X
            For sc = 0 To UBound(Mines)
                Mines(sc).Color = 0: Mines(sc).Tick = 0
            Next
            If X = Players(MeNum).Ship Then
                If EnableSound Then dsWin.Play DSBPLAY_DEFAULT
            Else
                If EnableSound Then dsLose.Play DSBPLAY_DEFAULT
            End If
        Case MSG_SCORE
            SetLoadTitle "Receiving score data..."
            GetBufferData ReceivedData, VarPtr(X), LenB(X), lOffset
            If X > 4 Or X < 0 Then GetBufferData ReceivedData, VarPtr(X), LenB(X), lOffset: GoTo done
            GetBufferData ReceivedData, VarPtr(TeamScores(X)), LenB(TeamScores(X)), lOffset
        Case MSG_MAP
            If LenB(MapPlay) > 0 Then GoTo done
            SetLoadTitle "Negotiating map..."
            tmp = GetBufferString(ReceivedData, lOffset)
            If DevEnv Or DebugBuild Then MapName = tmp
            MapPlay = AppPath & "maps\" & tmp
            If LenB(Dir(MapPlay)) <> 0 And LenB(MapPlay) <> 0 Then
                L2 = FileLen(MapPlay)
                iFreeFile = FreeFile
                Open MapPlay For Binary As #iFreeFile
                Get #iFreeFile, , HData
                Close #iFreeFile
            End If
            lNewOffSet = 0
            ReDim oNewMsg(0)
            lMsg = MSG_GAMELOGIN
            AddBufferData oNewMsg, VarPtr(lMsg), LenB(lMsg), lNewOffSet
            L = HData.Version
            AddBufferData oNewMsg, VarPtr(L), LenB(L), lNewOffSet
            AddBufferData oNewMsg, VarPtr(L2), LenB(L2), lNewOffSet
            SendTo oNewMsg
        Case MSG_GOTHEALTH
            If Players(MeNum).Invisible Then GoTo done
            b = Health
            b = b + 15
            If b > 60 Then b = 60
            Health = b
            If Players(MeNum).ArmCrt And Health > 17 Then
                Players(MeNum).ArmCrt = False
            End If
        Case MSG_PLAYERSCORE
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            GetBufferData ReceivedData, VarPtr(sc), LenB(sc), lOffset
            If Not Playing Then GoTo done
            Players(b).Score = sc
        Case MSG_ARMORLO
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            X = b
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            If Not Playing Then GoTo done
            Players(X).ArmCrt = b
            If X = MeNum Then
                If Players(MeNum).ArmCrt Then
                    On Local Error Resume Next
                    If EnableSound Then dsArmCrit.Play DSBPLAY_DEFAULT
                    Players(MeNum).ArmCrt = True
                End If
            End If
        Case MSG_SWITCH
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            sc = b
            GetBufferData ReceivedData, VarPtr(X), LenB(X), lOffset
            GetBufferData ReceivedData, VarPtr(j), LenB(j), lOffset

            xt = Switches(0, X) \ 16
            yt = Switches(1, X) \ 16
            If j = 0 Then Animations(yt, xt) = 123
            If j = 1 Then Animations(yt, xt) = 124
            If j = 2 Then Animations(yt, xt) = 125
            If j = 3 Then Animations(yt, xt) = 126
            If j = 4 Then Animations(yt, xt) = 127
            If sc = 1 Then
                d = UBound(Captured) + 1
                ReDim Preserve Captured(d)
                ReDim Preserve FlagCap(d)
                ReDim Preserve WhoTeam(d)
                ReDim Preserve FlagStatus(d)
                FlagStatus(d) = 4
                Captured(d) = True
                FlagCap(d) = 0
                WhoTeam(d) = j
            End If
        Case MSG_PSPEED
            GetBufferData ReceivedData, VarPtr(PSpeed), LenB(PSpeed), lOffset
        Case MSG_MAPTRANSFER
            LoadBool = True
            SetLoadTitle "Receiving map..."
            If UBound(RMData) = 0 Then
                GetBufferData ReceivedData, VarPtr(L), LenB(L), lOffset
                ReDim RMData(L)
                If LenB(Dir$(MapPlay)) <> 0 Then Kill MapPlay
                GoTo done
            End If
            For j = 0 To 100
                sc = 4
                If RMCount > UBound(RMData) - 3 Then
                    sc = UBound(RMData) - RMCount + 1
                    If sc < 0 Then GoTo done
                End If
                GetBufferData ReceivedData, VarPtr(L), LenB(L), lOffset
                CopyMemory RMData(RMCount), L, sc
                RMCount = RMCount + 4
                If RMCount > UBound(RMData) Then Exit For
            Next
            If RMCount > UBound(RMData) Then
                tmp = LCase$(Dir(AppPath & "maps", vbDirectory))
                If LenB(tmp) = 0 Then MkDir AppPath & "maps"
                iFreeFile = FreeFile
                Open MapPlay For Binary As #iFreeFile
                Put #iFreeFile, , RMData()
                Close #iFreeFile
                Open MapPlay For Binary As #iFreeFile
                Get #iFreeFile, , HData
                Close #iFreeFile
                'DoEvents
                LoadBool = False
                ReDim RMData(0)
                RMCount = 0
                lNewOffSet = 0
                ReDim oNewMsg(0)
                lMsg = MSG_GAMELOGIN
                AddBufferData oNewMsg, VarPtr(lMsg), LenB(lMsg), lNewOffSet
                L = HData.Version
                L2 = FileLen(MapPlay)
                AddBufferData oNewMsg, VarPtr(L), LenB(L), lNewOffSet
                AddBufferData oNewMsg, VarPtr(L2), LenB(L2), lNewOffSet
                SendTo oNewMsg
            End If
        Case MSG_FORCEPOS
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            GetBufferData ReceivedData, VarPtr(b2), LenB(b2), lOffset
            GetBufferData ReceivedData, VarPtr(xt), LenB(xt), lOffset
            GetBufferData ReceivedData, VarPtr(yt), LenB(yt), lOffset
            CopyMemory MoveBuffer(MoveBufferPtr), b2, 1
            MoveBufferPtr = MoveBufferPtr + 1
            CopyMemory MoveBuffer(MoveBufferPtr), b, 1
            MoveBufferPtr = MoveBufferPtr + 1
            b = 9
            CopyMemory MoveBuffer(MoveBufferPtr), b, 1
            MoveBufferPtr = MoveBufferPtr + 1
            CopyMemory MoveBuffer(MoveBufferPtr), xt, 2
            MoveBufferPtr = MoveBufferPtr + 2
            CopyMemory MoveBuffer(MoveBufferPtr), yt, 2
            MoveBufferPtr = MoveBufferPtr + 2
            MoveCounter = MoveCounter + 1
        Case MSG_DEVCHEAT
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            GetBufferData ReceivedData, VarPtr(b2), LenB(b2), lOffset
            Players(b).DevCheat = b2
        Case MSG_WEPSYNC
            Static MissOld As Byte, MortarOld As Byte, BounceOld As Byte, MineOld As Byte
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            If MissOld <> b Then
                If b > MissOld Then SpecialSnd 1, True
                MissAmmo = b
                MissOld = b
            End If
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            If MortarOld <> b Then
                If b > MortarOld Then SpecialSnd 2, True
                MortarAmmo = b
                MortarOld = b
            End If
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            If BounceOld <> b Then
                If b > BounceOld Then SpecialSnd 3, True
                BounceAmmo = b
                BounceOld = b
            End If
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            If MineOld <> b Then MineAmmo = b: MineOld = b
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            MissBar = b
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            MortarBar = b
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            BounceBar = b
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            If b < WepRecharge Then
                WepRecharge = b
            End If
            GetBufferData ReceivedData, VarPtr(sc), LenB(sc), lOffset
            PingTime = sc
            If PingTime > HighPing Then HighPing = PingTime
            GetBufferData ReceivedData, VarPtr(sc), LenB(sc), lOffset
            For j = 0 To sc
                GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
                If j > UBound(UniBall) Then ReDim Preserve UniBall(j)
                UniBall(j).Color = b
                If b > 0 Then
                    GetBufferData ReceivedData, VarPtr(sc), LenB(sc), lOffset
                    UniBall(j).BallX = sc
                    GetBufferData ReceivedData, VarPtr(sc), LenB(sc), lOffset
                    UniBall(j).BallY = sc
                End If
            Next
            lMsg = MSG_PING
            lNewOffSet = 0
            ReDim oNewMsg(0)
            AddBufferData oNewMsg, VarPtr(lMsg), LenB(lMsg), lNewOffSet
            SendTo oNewMsg, False
        Case MSG_WARPING
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            GetBufferData ReceivedData, VarPtr(b2), LenB(b2), lOffset
            If Not Playing Then GoTo done
            If b2 = 1 Then
                Players(b).Warping = True: Players(b).Warped = NewGTC: Players(MeNum).KeyIs = 9
                If Players(b).MoveX > -50 And Players(b).MoveY > -50 And Players(b).MoveX < ResX + 50 And Players(b).MoveY < ResY + 50 Then SndWarp (Players(b).charX - MeX) - CenterX, (Players(b).charY - MeY) - CenterY
            End If
            If b2 = 0 Then Players(b).Warping = False
        Case MSG_POWERUP
            GetBufferData ReceivedData, VarPtr(sc), LenB(sc), lOffset ' server index
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset ' kind of power up
            GetBufferData ReceivedData, VarPtr(b2), LenB(b2), lOffset ' effect
            GetBufferData ReceivedData, VarPtr(T3), LenB(T3), lOffset ' x
            GetBufferData ReceivedData, VarPtr(T4), LenB(T4), lOffset ' y
            If b2 = 3 Then SndGotPup
            If b2 = 1 Then
                CreatePowerup b, newCInt(sc), T3, T4
                GoTo done
            Else
                For j = 0 To UBound(PowerUp)
                    If PowerIndex(j) = sc Then
                        PowerEffect(j) = b2
                        If b2 = 0 Then PowerUp(j) = 0
                        GoTo done
                    End If
                Next
            End If
        Case MSG_MODE
            GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
            GetBufferData ReceivedData, VarPtr(b2), LenB(b2), lOffset
            Players(b).Mode = b2
            If b2 = 1 And b <> MeNum Then
                Players(b).Ship = 5
                Players(b).Invisible = True
            ElseIf b2 = 1 And b = MeNum Then
                Players(b).Ship = 5
                Players(b).Invisible = False
            End If
        Case MSG_UDPSTOP
            NoUDP = True
        Case MSG_UNIBALL
            GetBufferData ReceivedData, VarPtr(sc), LenB(sc), lOffset
            If sc <= UBound(UniBall) Then
                GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
                UniBall(sc).Color = b
                GetBufferData ReceivedData, VarPtr(j), LenB(j), lOffset
                UniBall(sc).BallX = j
                GetBufferData ReceivedData, VarPtr(j), LenB(j), lOffset
                UniBall(sc).BallY = j
                GetBufferData ReceivedData, VarPtr(j), LenB(j), lOffset
                UniBall(sc).BMoveX = j
                GetBufferData ReceivedData, VarPtr(j), LenB(j), lOffset
                UniBall(sc).BMoveY = j
                GetBufferData ReceivedData, VarPtr(BS), LenB(BS), lOffset
                UniBall(sc).BSpeedX = BS
                If BS = 0 Then UniBall(sc).BLoopX = 0
                GetBufferData ReceivedData, VarPtr(BS), LenB(BS), lOffset
                UniBall(sc).BSpeedY = BS
                If BS = 0 Then UniBall(sc).BLoopY = 0
            End If
        Case MSG_TIMELIMIT
            GetBufferData ReceivedData, VarPtr(TimeLimit), LenB(TimeLimit), lOffset
            TimeLimit = TimeLimit
            TimeClock = NewGTC
            TimeTick = TimeLimit
        Case MSG_ERROR
            ExitMSG = GetBufferString(ReceivedData, lOffset)
            frmMain.Timer2.Enabled = True
        Case MSG_UDPOK
            lMsg = MSG_UDPOK
            lNewOffSet = 0
            AddBufferData oNewMsg, VarPtr(lMsg), LenB(lMsg), lNewOffSet
            SendTo oNewMsg
    End Select

done:
    If bDebugLog = 1 Then DebugLog MsgType & " " & NewGTC & " processed."
    GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
    If b <> 3 Then
        If bDebugLog = 1 Then DebugLog "3 expected, got " & b & " -- lost tail packet? (" & MsgType & ")"
        Debug.Print b & " " & MsgType
        Exit Function
    End If
    If lOffset < ReceivedLen Then
        GoTo nextpacket
    End If

    Exit Function

ErrorTrap:
    RaiseCritical "Packet data error! (Line #" & Erl & ". " & DQ & Err.Number & " " & Err.Description & DQ & ")"

End Function

Public Sub SendData(cmd As Long, Key As Byte, cx As Integer, cy As Integer)
    On Local Error Resume Next
    Dim lMsg As Byte
    Dim oNewMsg() As Byte, lNewOffSet As Long
    If Players(MeNum).Invisible Then Exit Sub
    lNewOffSet = 0
    ReDim oNewMsg(0)
    lMsg = cmd
    AddBufferData oNewMsg, VarPtr(lMsg), LenB(lMsg), lNewOffSet
    AddBufferData oNewMsg, VarPtr(Key), LenB(Key), lNewOffSet
    AddBufferData oNewMsg, VarPtr(cx), LenB(cx), lNewOffSet
    AddBufferData oNewMsg, VarPtr(cy), LenB(cy), lNewOffSet
    SendTo oNewMsg, False
End Sub

Public Sub SENDNewKey()
    On Local Error Resume Next
    Dim lMsg As Byte, b As Byte
    Dim oNewMsg() As Byte, lNewOffSet As Long
    If LastKey = Players(MeNum).KeyIs Then Exit Sub
    LastKey = Players(MeNum).KeyIs
    lMsg = MSG_NEWKEY
    lNewOffSet = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lMsg), LenB(lMsg), lNewOffSet
    b = Players(MeNum).KeyIs
    AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
    SendTo oNewMsg, False
End Sub
