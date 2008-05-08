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

Option Explicit
Public Enum MSGTYPES
    MSG_COBALTID '0
    MSG_USERLOGIN '1
    MSG_ACCOUNT '2
    MSG_SIGNUP '3
    MSG_ADDUSER '4
    MSG_REMOVEUSER '5
    MSG_CHAT '6
    MSG_SERVERLOGIN '7
    MSG_ADDSERVER '8
    MSG_REMOVESERVER '9
    MSG_JOIN '10
    MSG_JOINED '11
    MSG_LEFT '12, unused.
    MSG_ICON '13
    MSG_PAGE '14
    MSG_PAGESTAT '14
    MSG_PROFILE '16
    MSG_PROFILEEDIT '17
    MSG_ZZZ '18
    MSG_ERROR '19
    MSG_OK '20
    MSG_UPDATE '21
    MSG_SVRADDPLAYER '22
    MSG_SVRREMOVEPLAYER '23
    MSG_SVRMRB '24
    MSG_MODE '25
    MSG_PASSWORDPROTECTED '26
    MSG_STATS '27
    MSG_ENC '28
    MSG_CLEAR '29
    MSG_ADDROOM '30
    MSG_REMOVEROOM '31
    MSG_JOINROOM '32
    MSG_CREATEROOM '33
End Enum

Public Sub SetupLogin()
    UserName = frmLogin.cmbUserName.Text
    Password = frmLogin.txtPassword.Text
    ErrorMSG = vbNullString
    If port = 0 And LenB(HostAddy) = 0 Then
        port = 6000
        HostAddy = "cobalt.uplinklabs.net"
    ElseIf port = 0 Or LenB(HostAddy) = 0 Then
        ErrorMSG = "Select a Cobalt server first!"
    End If
    If Password = vbNullString Then ErrorMSG = "Enter your password first."
    If UserName = vbNullString Then ErrorMSG = "Enter your username first."
    If ErrorMSG <> vbNullString Then
        RaiseInfo ErrorMSG
        Exit Sub
    End If
    Sleeping = False
    NewUser = False
    If InStr(UserName, "*") Or InStr(UserName, " ") Then
        If InStr(UserName, "*") Then LoginKey = 1
        If InStr(UserName, " ") Then LoginKey = 128
        UserName = Mid$(UserName, 1, Len(UserName) - 1)
    End If
    Connect
End Sub

Public Sub Connect()
    frmMain.lvUsers.ListItems.Clear
    frmMain.lvGames.ListItems.Clear
    frmMain.lvUsers.ForeColor = vbBlue
    frmMain.sckMain.Disconnect
    frmMain.sckMain.Cleanup
    frmMain.sckMain.HostName = HostAddy
    frmMain.sckMain.RemoteService = port
    'frmMain.sckMain.RemotePort = Port
    frmMain.sckMain.Connect
End Sub

Public Sub SendEncSig()
    Dim lNewMsg As Byte
    Dim oNewMsg() As Byte, lNewOffset As Long
    Dim i As Integer
    lNewMsg = MSG_ENC
    lNewOffset = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
    i = Protocol
    AddBufferData oNewMsg, VarPtr(i), LenB(i), lNewOffset
    SendTo oNewMsg
    EnableEncryption = True
End Sub

Public Sub SendTo(buff() As Byte)
    Dim B As Byte
    ReDim Preserve buff(UBound(buff) + 1)
    B = 3
    CopyMemory buff(UBound(buff)), B, 1
    frmMain.sckMain.WriteBytes buff, UBound(buff) + 1
End Sub

Public Sub AddBufferData(BufferData() As Byte, vPtr As Long, lLen As Integer, lOffset As Long)
    If lOffset = 0 Then ReDim BufferData(lLen - 1) Else ReDim Preserve BufferData(UBound(BufferData) + lLen)
    CopyMemory BufferData(lOffset), ByVal vPtr, lLen
    lOffset = lOffset + lLen
End Sub

Public Function AddBufferString(BufferData() As Byte, ByVal tmp As String, lOffset As Long, Optional NoMess As Boolean) As String
    Dim lLen As Integer, i As Integer
    tmp = Scramble(tmp)
    If Not NoMess Then
        If EnableEncryption Then tmp = Encryption.EncryptString(tmp, EncPassword)
    End If
    i = Len(tmp)
    If lOffset = 0 Then ReDim BufferData(i + 1) Else ReDim Preserve BufferData(UBound(BufferData) + i + 2)
    CopyMemory BufferData(lOffset), i, 2
    lOffset = lOffset + 2
    CopyMemory BufferData(lOffset), ByVal tmp, Len(tmp)
    lOffset = lOffset + Len(tmp)
End Function

Public Sub GetBufferData(BufferData() As Byte, vPtr As Long, lLen As Integer, lOffset As Long)
    CopyMemory ByVal vPtr, BufferData(lOffset), lLen
    lOffset = lOffset + lLen
End Sub

Public Function GetBufferString(BufferData() As Byte, lOffset As Long) As String
    Dim tmp As String, lLen As Integer
    CopyMemory lLen, BufferData(lOffset), 2
    lOffset = lOffset + 2
    tmp = String$(lLen, Chr(0))
    CopyMemory ByVal tmp, BufferData(lOffset), lLen
    lOffset = lOffset + lLen
    GetBufferString = Unscramble(tmp)
End Function

Function DataProcess(ReceivedData() As Byte, ReceivedLen As Long, pID As Byte) As Integer
    Dim i As Integer, j As Integer, X As Integer, B As Byte, tmp As String, Tmp2 As String, Tmp3 As String
    Dim l As Long, l2 As Long, b2 As Byte, b3 As Byte, T1 As Integer, T2 As Integer, T3 As Integer
    
    Dim lMsg As Byte, lOffset As Long
    Dim oNewMsg() As Byte, lNewOffset As Long
    Dim lNewMsg As Byte
    
    If Not DevEnv Then On Error Resume Next
nextpacket:
    GetBufferData ReceivedData, VarPtr(lMsg), LenB(lMsg), lOffset
'    Debug.Print lMsg
    Select Case lMsg
    Case MSG_CLEAR
        frmMain.txtInChat.Text = vbNullString
    Case MSG_ENC
        EnableEncryption = 1
        sendUserinfo
    Case MSG_COBALTID
        GetBufferData ReceivedData, VarPtr(COBALTID), LenB(COBALTID), lOffset
    Case MSG_ADDUSER
        GetBufferData ReceivedData, VarPtr(i), LenB(i), lOffset
        GetBufferData ReceivedData, VarPtr(B), LenB(B), lOffset
        X = B
        GetBufferData ReceivedData, VarPtr(B), LenB(B), lOffset
        j = B
        GetBufferData ReceivedData, VarPtr(B), LenB(B), lOffset
        Tmp2 = GetBufferString(ReceivedData, lOffset)
        tmp = GetBufferString(ReceivedData, lOffset)
        If LenB(Trim$(tmp)) = 0 Then
            GoTo done
        End If
        If i > UBound(UserDat) Then ReDim Preserve UserDat(i)
        If X > frmMain.ilIcons.ListImages.Count Then X = 0
        Set UserDat(i) = New clsUserData
        UserDat(i).Nick = tmp
        UserDat(i).Admin = j
        UserDat(i).Mode = B
        UserDat(i).icon = X
        If IsMuzzled(tmp) Then If UserDat(i).Admin > Admin Then MuzzleThem tmp
        If tmp = UserName Then Admin = j
        'If j > Admin Then Admin = j
        
        If UserDat(i).Mode = 1 And Admin < 4 Then GoTo done
        If tmp = UserName Then
            If j > 0 Then frmMain.admin2.Visible = True Else frmMain.admin2.Visible = False
            If j > 1 Then
                frmMain.mnudstrgme.Visible = True
                frmMain.mnugetpw.Visible = True
            Else
                frmMain.mnudstrgme.Visible = False
                frmMain.mnugetpw.Visible = False
            End If
            'If j = 3 Then Text2.ForeColor = RGB(0, 150, 255) Else Text2.ForeColor = vbGreen
            If j > 1 Then
                frmMain.mnuban.Visible = True
                frmMain.boot.Visible = True
                frmMain.admin2.Caption = "Admin"
            Else
                frmMain.mnuban.Visible = False
                frmMain.boot.Visible = False
                frmMain.admin2.Caption = "Guide"
            End If
            If j > 2 Then
                frmMain.mnuListIP.Visible = True
                frmMain.mnuBanSysID.Visible = True
                frmMain.warn.Visible = True
                frmMain.mnuipban.Visible = True
                frmMain.mnuhdban.Visible = True
                frmMain.mnuList.Visible = True
            Else
                frmMain.mnuListIP.Visible = False
                frmMain.warn.Visible = False
                frmMain.mnuBanSysID.Visible = False
                frmMain.mnuipban.Visible = False
                frmMain.mnuhdban.Visible = False
                frmMain.mnuList.Visible = False
            End If
        End If
        If Tmp2 <> Chr(1) Then
            If Not NoEnterLeave Then AddChat "Cobalt", Tmp2 & " (" & LCase$(tmp) & ": entered)"
        End If
        DoEvents
        AddUser i
    Case MSG_REMOVEUSER
        GetBufferData ReceivedData, VarPtr(i), LenB(i), lOffset
        tmp = GetBufferString(ReceivedData, lOffset)
        If i > UBound(UserDat) Then GoTo done
        If UserDat(i) Is Nothing Then GoTo done
        
        If i < 1 Then GoTo done
        If Not (UserDat(i).Mode = 1 And Admin < 5) Then
            For X = 1 To frmMain.lvUsers.ListItems.Count
                If frmMain.lvUsers.ListItems(X).Key = "P" & i Then
                    If Not NoEnterLeave Then AddChat "Cobalt", tmp & " (" & LCase$(frmMain.lvUsers.ListItems(X).Text) & ": left)"
                    If PagerStat(1) Then
                        For j = 1 To frmPager.lvPages.ListItems.Count
                            If LCase$(frmPager.lvPages.ListItems(j).Text) = LCase$(frmMain.lvUsers.ListItems(X).Text) Then Exit For
                        Next
                        If Not j > frmPager.lvPages.ListItems.Count Then frmPager.lvPages.ListItems(j).SmallIcon = 2
                        frmPager.lvPages.Refresh
                    End If
                    frmMain.lvUsers.ListItems.Remove X: Exit For
                End If
            Next
        End If
        If i <= UBound(UserDat) Then Set UserDat(i) = Nothing
        DoEvents
        frmMain.lvUsers.Refresh
    Case MSG_CHAT
        GetBufferData ReceivedData, VarPtr(i), LenB(i), lOffset
        tmp = GetBufferString(ReceivedData, lOffset)
        Tmp2 = "invalid user"
        If i <= UBound(UserDat) Then
            If Not UserDat(i) Is Nothing Then
                If IsMuzzled(UserDat(i).Nick) Then GoTo done
                Tmp2 = UserDat(i).Nick
            End If
        End If
        If NoBadWords > 0 Then BadWords tmp
        Tmp3 = vbNullString
        l = AddChat(Tmp2, tmp, Tmp3)
    Case MSG_ADDROOM
        GetBufferData ReceivedData, VarPtr(X), LenB(X), lOffset
        tmp = GetBufferString(ReceivedData, lOffset)
        CreateRoom tmp, X
    Case MSG_JOINROOM
        GetBufferData ReceivedData, VarPtr(X), LenB(X), lOffset
        For i = 0 To UBound(Rooms)
            If Rooms(i).RoomIndex = X Then
                Exit For
            End If
        Next
        If i > UBound(Rooms) Then GoTo done
        JoinRoom i
    Case MSG_REMOVEROOM
        GetBufferData ReceivedData, VarPtr(X), LenB(X), lOffset
        For i = 0 To UBound(Rooms)
            If Rooms(i).RoomIndex = X Then
                Exit For
            End If
        Next
        If i > UBound(Rooms) Then GoTo done
        RemoveRoom i
    Case MSG_CREATEROOM
    
    Case MSG_ADDSERVER
        Dim srDesc As String, srIPHost As String, srCreator As String, PassProtect As Boolean
        Dim srName As String, srPort As Long, srPort2 As Long
        GetBufferData ReceivedData, VarPtr(X), LenB(X), lOffset
        srName = GetBufferString(ReceivedData, lOffset)
        srDesc = GetBufferString(ReceivedData, lOffset)
        srIPHost = GetBufferString(ReceivedData, lOffset)
        srCreator = GetBufferString(ReceivedData, lOffset)
        tmp = GetBufferString(ReceivedData, lOffset)
        GetBufferData ReceivedData, VarPtr(PassProtect), LenB(PassProtect), lOffset
        GetBufferData ReceivedData, VarPtr(B), LenB(B), lOffset
        GetBufferData ReceivedData, VarPtr(b2), LenB(b2), lOffset
        GetBufferData ReceivedData, VarPtr(i), LenB(i), lOffset
        GetBufferData ReceivedData, VarPtr(srPort), LenB(srPort), lOffset
        GetBufferData ReceivedData, VarPtr(srPort2), LenB(srPort2), lOffset
        If X > UBound(ServerDat) Then ReDim Preserve ServerDat(X)
        Set ServerDat(X) = New clsGameData
        ServerDat(X).sName = srName
        ServerDat(X).sDesc = srDesc
        ServerDat(X).ID = X
        ServerDat(X).Creator = srCreator
        ServerDat(X).ip = srIPHost
        ServerDat(X).port = srPort
        ServerDat(X).Port2 = srPort2
        ServerDat(X).PassProtected = PassProtect
        ServerDat(X).MaxPlayers = B
        ServerDat(X).GameType = b2
        ServerDat(X).TimeLimit = i
        If Not DevEnv Then On Error Resume Next
        If ServerDat(X).PassProtected Then
            frmMain.lvGames.ListItems.Add , "S" & X, ServerDat(X).sName, , 0
        Else
            If ServerDat(X).GameType = 0 Then frmMain.lvGames.ListItems.Add , "S" & X, ServerDat(X).sName, , 9
            If ServerDat(X).GameType = 1 Then frmMain.lvGames.ListItems.Add , "S" & X, ServerDat(X).sName, , 9
        End If
        SrvIcons X
        '
        If X > 0 Then
            If frmMain.sckGamePing.UBound < X Then
                Load frmMain.sckGamePing(X)
            End If
        End If
        MrB X
        frmMain.tmrUpdate.Enabled = True
    Case MSG_REMOVESERVER
        GetBufferData ReceivedData, VarPtr(j), LenB(j), lOffset
        If X > 0 Then Unload frmMain.sckGamePing(X)
        For i = 1 To frmMain.lvGames.ListItems.Count
            X = Mid$(frmMain.lvGames.ListItems.Item(i).Key, 2)
            If X = j Then
                If frmMain.lvGames.SelectedItem.Key = frmMain.lvGames.ListItems.Item(i).Key Then
                    frmMain.txtGameDescription = vbNullString
                    frmMain.lvGameUsers.ListItems.Clear
                End If
                frmMain.lvGames.ListItems.Remove i
                Exit For
            End If
        Next
        If j <= UBound(ServerDat) Then Set ServerDat(j) = Nothing
        PingRefresh
    Case MSG_ICON
        GetBufferData ReceivedData, VarPtr(i), LenB(i), lOffset
        GetBufferData ReceivedData, VarPtr(B), LenB(B), lOffset
        If i > UBound(UserDat) Then GoTo done
        If UserDat(i) Is Nothing Then GoTo done
        UserDat(i).icon = B
        If IsMuzzled(UserDat(i).Nick) Then GoTo done
        If B = 18 And Admin = 0 Then GoTo done
        For X = 1 To frmMain.lvUsers.ListItems.Count
            If frmMain.lvUsers.ListItems(X).Text = UserDat(i).Nick Then
                frmMain.lvUsers.ListItems.Item(X).SmallIcon = B
                DoEvents
                frmMain.lvUsers.Refresh
            End If
        Next
    Case MSG_SVRMRB
        GetBufferData ReceivedData, VarPtr(B), LenB(B), lOffset
        GetBufferData ReceivedData, VarPtr(b2), LenB(b2), lOffset
        GetBufferData ReceivedData, VarPtr(b3), LenB(b3), lOffset
        GetBufferData ReceivedData, VarPtr(i), LenB(i), lOffset
        GetBufferData ReceivedData, VarPtr(T1), LenB(T1), lOffset
        GetBufferData ReceivedData, VarPtr(T2), LenB(T2), lOffset
        GetBufferData ReceivedData, VarPtr(T3), LenB(T3), lOffset
        GetBufferData ReceivedData, VarPtr(l), LenB(l), lOffset
        For j = 0 To UBound(svrPlayers)
            If svrPlayers(j).ServerID = B And svrPlayers(j).playerID = b2 Then
                svrPlayers(j).Ship = b3
                svrPlayers(j).Ping = i
                svrPlayers(j).Frags = T1
                svrPlayers(j).Deaths = T2
                svrPlayers(j).Caps = T3
                svrPlayers(j).Time = l
                Exit For
            End If
        Next
        RefreshPlayers
    Case MSG_ERROR
        GetBufferData ReceivedData, VarPtr(B), LenB(B), lOffset
        ErrorMSG = GetBufferString(ReceivedData, lOffset)
        If B = 1 Then
            frmMain.sckMain.Disconnect
            frmMain.sckMain.Cleanup
            frmMain.lvUsers.ListItems.Clear
            frmMain.lvGames.ListItems.Clear
            frmMain.lvGameUsers.ListItems.Clear
            frmMain.txtGameDescription.Text = vbNullString
            frmMain.lblRoom.Caption = "You are not in a room because you are not connected."
            RaiseError ErrorMSG
            EnableEncryption = False
            Else
            RaiseInfo ErrorMSG
        End If
    Case MSG_OK
        CTime = -1
        frmMain.OKCLient
        GetBufferData ReceivedData, VarPtr(MeNum), LenB(MeNum), lOffset
        GetBufferData ReceivedData, VarPtr(Port2), LenB(Port2), lOffset
        SaveSettingString HKEY_CURRENT_USER, "SOFTWARE\Cobalt\Login", "current", UserName
        tmp = Scramble(LCase$(Password))
        If frmLogin.Check1.Value = 1 Then
            SaveSettingString HKEY_CURRENT_USER, "SOFTWARE\Cobalt\Login\" & UserName, "password", tmp
        Else
            SaveSettingString HKEY_CURRENT_USER, "SOFTWARE\Cobalt\Login\" & UserName, "password", vbNullString
        End If
        frmLogin.Visible = False
        ZZZTick = NewGTC
        frmMain.tmrUpdate.Enabled = True
        frmMain.cmdPager.Enabled = True
        frmMain.txtChat.Enabled = True
        frmMain.cmdSend.Enabled = True
        uptime = Timer
        LoadMuzzle
        If Sleeping Then
            MeSleep 1
        End If
        If Not frmMain.Visible Then frmMain.Show
    Case MSG_UPDATE
        RHost = GetBufferString(ReceivedData, lOffset)
        RURL = GetBufferString(ReceivedData, lOffset)
        Set frmLogin.AutoUpdate = New clsULupdate
        frmLogin.AutoUpdate.ForceUpdateDL RURL
    Case MSG_SVRADDPLAYER
        tmp = GetBufferString(ReceivedData, lOffset)
        GetBufferData ReceivedData, VarPtr(B), LenB(B), lOffset
        GetBufferData ReceivedData, VarPtr(X), LenB(X), lOffset
        For i = 0 To UBound(svrPlayers) + 1
            If i > UBound(svrPlayers) Then ReDim Preserve svrPlayers(i)
            If svrPlayers(i).playerID = 0 Then
                svrPlayers(i).ScreenName = tmp
                svrPlayers(i).playerID = B
                svrPlayers(i).ServerID = X
                Exit For
            End If
        Next
        RefreshPlayers
    Case MSG_SVRREMOVEPLAYER
        GetBufferData ReceivedData, VarPtr(j), LenB(j), lOffset
        GetBufferData ReceivedData, VarPtr(B), LenB(B), lOffset
        For i = 0 To UBound(svrPlayers)
            If svrPlayers(i).ServerID = j And svrPlayers(i).playerID = B Then
                svrPlayers(i).ServerID = 0
                svrPlayers(i).playerID = 0
                svrPlayers(i).ScreenName = vbNullString
                Exit For
            End If
        Next
        RefreshPlayers
        SrvIcons j
    Case MSG_PAGE
        tmp = GetBufferString(ReceivedData, lOffset)
        Tmp2 = GetBufferString(ReceivedData, lOffset)
        If Tmp2 = Chr(1) Then
            Tmp2 = "Has paged you at: " & Time & " " & Date
            lNewMsg = MSG_PAGESTAT
            lNewOffset = 0
            ReDim oNewMsg(0)
            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
            If IsMuzzled(tmp) Then B = 2 Else B = 1
            AddBufferString oNewMsg, tmp, lNewOffset
            If B = 2 Then
                AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
            ElseIf B = 1 Then
                If NoPager Then B = 3
                AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
            End If
            SendTo oNewMsg
            If NoPager Then GoTo done
            If PagerStat(1) Then SendPage tmp, Chr(3)
        ElseIf Tmp2 = Chr(2) Then
            If Not PagerStat(1) Then GoTo done
            For i = 1 To frmPager.lvPages.ListItems.Count
                If LCase$(frmPager.lvPages.ListItems(i).Text) = LCase$(tmp) Then Exit For
            Next
            If Not i > frmPager.lvPages.ListItems.Count Then frmPager.lvPages.ListItems(i).SmallIcon = 2
            frmPager.lvPages.Refresh
            Tmp2 = "Has ended page at: " & Time & " " & Date
            GoTo done
        ElseIf Tmp2 = Chr(3) Then
            If Not PagerStat(1) Then GoTo done
            For i = 1 To frmPager.lvPages.ListItems.Count
                If LCase$(frmPager.lvPages.ListItems(i).Text) = LCase$(tmp) Then Exit For
            Next
            If Not i > frmPager.lvPages.ListItems.Count Then
                'frmPager.lvPages.ListItems(I).SmallIcon = 3
                frmPager.lvPages.Refresh
            End If
            SendPage tmp, Chr(4)
            GoTo done
        ElseIf Tmp2 = Chr(4) Then
            If Not PagerStat(1) Then GoTo done
            For i = 1 To frmPager.lvPages.ListItems.Count
                If LCase$(frmPager.lvPages.ListItems(i).Text) = LCase$(tmp) Then Exit For
            Next
            If Not i > frmPager.lvPages.ListItems.Count Then
                'frmPager.lvPages.ListItems(I).SmallIcon = 3
                frmPager.lvPages.Refresh
            End If
            GoTo done
        ElseIf Tmp2 = Chr(5) Then
            If Not PagerStat(1) Then GoTo done
            For i = 1 To frmPager.lvPages.ListItems.Count
                If LCase$(frmPager.lvPages.ListItems(i).Text) = LCase$(tmp) Then Exit For
            Next
            If Not i > frmPager.lvPages.ListItems.Count Then frmPager.lvPages.ListItems(i).SmallIcon = 2 Else GoTo done
            For i = 0 To UBound(PagerMSG)
                If LCase$(PagerMSG(i).PName(0)) = LCase$(tmp) Then Exit For
            Next
            ReDim Preserve PagerMSG(i).PName(UBound(PagerMSG(i).PName) + 1)
            PagerMSG(i).PName(UBound(PagerMSG(i).PName)) = "[END]"
            frmPager.lvPages.Refresh
            Tmp2 = "Has ended page at: " & Time & " " & Date
            ErrorMSG = tmp & " has dismissed you."
            RaiseInfo ErrorMSG
            GoTo done
        End If
        If NoBadWords > 0 Then BadWords Tmp2
        For i = 0 To UBound(PagerMSG)
            If LCase$(PagerMSG(i).PName(0)) = LCase$(tmp) Then
                j = UBound(PagerMSG(i).Pages) + 1
                ReDim Preserve PagerMSG(i).PName(j)
                ReDim Preserve PagerMSG(i).Pages(j)
                If PagerStat(1) Then
                    If frmPager.PagerIndex = i Then
                        frmPager.AddChat tmp, Tmp2
                    Else
                        PlayWAV "ringin.wav", False
                        For X = 1 To frmPager.lvPages.ListItems.Count
                            If LCase$(frmPager.lvPages.ListItems(X).Text) = LCase$(tmp) Then Exit For
                        Next
                        If Not X > frmPager.lvPages.ListItems.Count Then frmPager.lvPages.ListItems(X).SmallIcon = 1
                        frmPager.lvPages.Refresh
                    End If
                End If
                PagerMSG(i).PName(j) = tmp
                PagerMSG(i).Pages(j) = Tmp2
                GoTo done
            End If
        Next
        For i = 0 To UBound(PagerMSG) + 1
            If i > UBound(PagerMSG) Then
                ReDim Preserve PagerMSG(i)
                ReDim Preserve PagerMSG(i).PName(0)
                ReDim Preserve PagerMSG(i).Pages(0)
            End If
            If PagerMSG(i).PName(0) = vbNullString Then
                If B = 2 Then GoTo done
                If PagerStat(1) Then
                    If Tmp2 <> Chr(1) Then SendPage tmp, Chr(3)
                    frmPager.lvPages.ListItems.Add , , tmp, 0, 0
                    If frmPager.PagerIndex = i Then
                        frmPager.AddChat tmp, Tmp2
                    Else
                        PlayWAV "ringin.wav", False
                        For j = 1 To frmPager.lvPages.ListItems.Count
                            If LCase$(frmPager.lvPages.ListItems(j).Text) = LCase$(tmp) Then Exit For
                        Next
                        If Not j > frmPager.lvPages.ListItems.Count Then frmPager.lvPages.ListItems(j).SmallIcon = 1
                        frmPager.lvPages.Refresh
                    End If
                End If
                PagerMSG(i).PName(0) = tmp
                PagerMSG(i).Pages(0) = Tmp2
                GoTo done
            End If
        Next
    Case MSG_PAGESTAT
        tmp = GetBufferString(ReceivedData, lOffset)
        GetBufferData ReceivedData, VarPtr(B), LenB(B), lOffset
        For i = 0 To UBound(PagerMSG)
            If LCase$(PagerMSG(i).PName(0)) = LCase$(tmp) Then GoTo done
        Next
        If B = 1 Then
            For i = 0 To UBound(PagerMSG) + 1
                If i > UBound(PagerMSG) Then
                    ReDim Preserve PagerMSG(i)
                    ReDim Preserve PagerMSG(i).PName(0)
                    ReDim Preserve PagerMSG(i).Pages(0)
                End If
                If PagerMSG(i).PName(0) = vbNullString Then
                    PagerMSG(i).PName(0) = tmp
                    PagerMSG(i).Pages(0) = "Accepting pages."
                    If Not PagerStat(1) Then
                        frmPager.Show
                    Else
                        frmPager.lvPages.ListItems.Add , , tmp, 0, 0
                        If frmPager.PagerIndex = i Then frmPager.AddChat tmp, PagerMSG(i).Pages(0) Else PlayWAV "ringin.wav", False
                        frmPager.lvPages.ListItems(1).Selected = True
                    End If
                    GoTo done
                End If
            Next
        End If
    Case MSG_PROFILE
        tmp = String(255, Chr(0))
        CopyMemory ProfileType, ByVal tmp, 255
        GetBufferData ReceivedData, VarPtr(ProfileStats), LenB(ProfileStats), lOffset
        ShowStats
    Case MSG_ACCOUNT
        EnterMSG = GetBufferString(ReceivedData, lOffset)
        ExitMSG = GetBufferString(ReceivedData, lOffset)
        Email = GetBufferString(ReceivedData, lOffset)
        If EnterMSG = " " Then EnterMSG = vbNullString
        If ExitMSG = " " Then ExitMSG = vbNullString
        If Email = " " Then Email = vbNullString
    Case MSG_MODE
        GetBufferData ReceivedData, VarPtr(i), LenB(i), lOffset
        GetBufferData ReceivedData, VarPtr(B), LenB(B), lOffset
        tmp = GetBufferString(ReceivedData, lOffset)
        If i > UBound(UserDat) Then GoTo done
        If UserDat(i) Is Nothing Then GoTo done
        
        '
        j = 0
        For X = 1 To frmMain.lvUsers.ListItems.Count
            If frmMain.lvUsers.ListItems(X).Text = UserDat(i).Nick Then Exit For
        Next
        If X > frmMain.lvUsers.ListItems.Count Then j = 1
        '
        If B = 1 Then
            If Admin < 4 Then
                frmMain.lvUsers.ListItems.Remove X
                If Not NoEnterLeave Then AddChat "Cobalt", tmp & " (" & LCase$(UserDat(i).Nick) & ": left)"
            Else
                'frmMain.lvUsers.ListItems(X).ForeColor = RGB(155, 155, 155)
            End If
        ElseIf B = 2 Then
            If Admin < 5 Then
                frmMain.lvUsers.ListItems.Remove X
                If Not NoEnterLeave Then AddChat "Cobalt", tmp & " (" & LCase$(UserDat(i).Nick) & ": left)"
            Else
                frmMain.lvUsers.ListItems(X).ForeColor = RGB(155, 155, 155)
            End If
        End If
        
        If UserDat(i).Mode > 0 And B = 0 Then
            If Admin < 2 And j Then
                UserDat(i).Mode = B
                AddUser i
                If Not NoEnterLeave Then AddChat "Cobalt", tmp & " (" & LCase$(UserDat(i).Nick) & ": entered)"
            Else
                If UserDat(i).Admin > 0 Then
                    frmMain.lvUsers.ListItems(X).ForeColor = vbRed
                    Else
                    frmMain.lvUsers.ListItems(X).ForeColor = vbBlack
                End If
            End If
        End If
        
        If B = 2 Then frmMain.lvUsers.ListItems(X).ForeColor = vbRed
        
        If UserDat(i).Mode >= 0 And B = 0 Then
            If Not j Then frmMain.lvUsers.ListItems(X).ForeColor = vbBlack
        End If
        
        UserDat(i).Mode = B
        frmMain.lvUsers.Refresh
    Case MSG_PASSWORDPROTECTED
        GetBufferData ReceivedData, VarPtr(i), LenB(i), lOffset
        GetBufferData ReceivedData, VarPtr(B), LenB(B), lOffset
        If Not ServerDat(i) Is Nothing Then
            ServerDat(i).PassProtected = B
            If i = Mid$(frmMain.lvGames.SelectedItem.Key, 2) Then RefreshPlayers
        End If
    End Select
    
done:
    GetBufferData ReceivedData, VarPtr(B), LenB(B), lOffset
    If B <> 3 Then
        Exit Function
    End If
    If lOffset < ReceivedLen Then
        GoTo nextpacket
    End If
End Function

Public Sub sendUserinfo()
    Dim lNewMsg As Byte, lOffset As Long
    Dim oNewMsg() As Byte, lNewOffset As Long
    Dim i As Integer, l As Long
    lNewMsg = MSG_USERLOGIN
    lNewOffset = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
    i = iVersion
    AddBufferData oNewMsg, VarPtr(i), LenB(i), lNewOffset
    AddBufferData oNewMsg, VarPtr(LoginKey), LenB(LoginKey), lNewOffset
    AddBufferData oNewMsg, VarPtr(Serial_Number), LenB(Serial_Number), lNewOffset
    l = Serial_Number Xor 28551
    AddBufferData oNewMsg, VarPtr(l), LenB(l), lNewOffset
    AddBufferString oNewMsg, UserName, lNewOffset
    AddBufferString oNewMsg, Password, lNewOffset
    AddBufferString oNewMsg, UniqueID, lNewOffset
    SendTo oNewMsg
End Sub

Public Sub MrB(Index As Integer)
    On Error Resume Next
    Dim oNewMsg() As Byte, lNewOffset As Long
    Dim lNewMsg As Byte
    Dim i As Integer, j As Integer, p As Integer, l As Long, a As Integer
    Static pings As Integer
    i = Index
    If ServerDat(i) Is Nothing Then Exit Sub
    frmMain.sckGamePing(i).Disconnect
    If frmMain.sckGamePing(i).State = 0 Then
        frmMain.sckGamePing(i).AddressFamily = AF_INET
        frmMain.sckGamePing(i).Protocol = IPPROTO_IP
        frmMain.sckGamePing(i).SocketType = SOCK_STREAM
        frmMain.sckGamePing(i).LocalPort = IPPORT_ANY
        frmMain.sckGamePing(i).Binary = True
        frmMain.sckGamePing(i).BufferSize = 16384
        frmMain.sckGamePing(i).Blocking = False
        frmMain.sckGamePing(i).AutoResolve = False
        frmMain.sckGamePing(i).HostName = ServerDat(i).ip
        frmMain.sckGamePing(i).RemoteService = ServerDat(i).Port2
        ServerDat(i).pingStart = NewGTC
        frmMain.sckGamePing(i).Connect
    End If
End Sub

'automatic AFK
Public Sub MeSleep(bT As Byte)
    Dim lNewMsg As Byte, lOffset As Long
    Dim oNewMsg() As Byte, lNewOffset As Long
    If bT = 0 Then Sleeping = False
    lNewMsg = MSG_ZZZ
    lNewOffset = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
    AddBufferData oNewMsg, VarPtr(bT), LenB(bT), lNewOffset
    SendTo oNewMsg
End Sub

'Pages the user with 'txt'
Public Sub SendPage(sn As String, Txt As String)
    On Error Resume Next
    If sn = vbNullString Or Txt = vbNullString Then Exit Sub
    Dim lNewMsg As Byte, lOffset As Long
    Dim oNewMsg() As Byte, lNewOffset As Long
    lNewMsg = MSG_PAGE
    lNewOffset = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
    AddBufferString oNewMsg, sn, lNewOffset
    AddBufferString oNewMsg, Txt, lNewOffset
    SendTo oNewMsg
    'PlayWAV "ringout.wav", False
End Sub

Public Sub ChatSend(Txt As String)
    'On Error Resume Next
    Dim B As Byte
    If LCase(Txt) = "/codeon" Then
        ColorCodes = True
        SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\Cobalt", "ColorCodes", ColorCodes
        Exit Sub
    End If
    If LCase(Txt) = "/clear" Then frmMain.txtInChat.Text = vbNullString: Txt = vbNullString: Exit Sub
    If LCase(Txt) = "/afk" Then
        Sleeping = True
        MeSleep 1
        Txt = vbNullString: Exit Sub
    End If
    If Txt = vbNullString Then Exit Sub
    If ChatColor <> vbNullString And Not NoColor Then Txt = "&" & ChatColor & "&" & Txt
    ZZZTick = NewGTC
    If Sleeping Then MeSleep 0
    Dim lNewMsg As Byte, lOffset As Long
    Dim oNewMsg() As Byte, lNewOffset As Long
    lNewMsg = MSG_CHAT
    lNewOffset = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
    AddBufferString oNewMsg, Txt, lNewOffset
    SendTo oNewMsg
    Txt = vbNullString
    If Admin = 0 Then frmMain.ChatPause.Enabled = True
End Sub
