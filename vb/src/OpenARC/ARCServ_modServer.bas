Attribute VB_Name = "modServer"
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
Public Declare Function RegCloseKey Lib "advapi32.dll" (ByVal hKey As Long) As Long
Public Declare Function RegOpenKey Lib "advapi32.dll" Alias "RegOpenKeyA" (ByVal hKey As Long, ByVal lpSubKey As String, phkResult As Long) As Long
Public Declare Function RegQueryValueEx Lib "advapi32.dll" Alias "RegQueryValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal lpReserved As Long, lpType As Long, lpData As Any, lpcbData As Long) As Long
Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationname As String, ByVal lpKeyName As Any, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long
Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationname As String, ByVal lpKeyName As Any, ByVal lpString As Any, ByVal lpFileName As String) As Long
Public Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (hpvDest As Any, hpvSource As Any, ByVal cbCopy As Long)
Declare Function GetTickCount Lib "kernel32" () As Long
Public Declare Function compress Lib "zlib.dll" (dest As Any, destLen As Any, src As Any, ByVal srcLen As Long) As Long
Public Declare Function uncompress Lib "zlib.dll" (dest As Any, destLen As Any, src As Any, ByVal srcLen As Long) As Long
Public Declare Function Shell_NotifyIcon Lib "shell32.dll" Alias "Shell_NotifyIconA" (ByVal dwMessage As Long, lpData As NOTIFYICONDATA) As Long
Public Declare Function GetVolumeInformation Lib "kernel32" Alias "GetVolumeInformationA" (ByVal lpRootPathName As String, ByVal lpVolumeNameBuffer As String, ByVal nVolumeNameSize As Long, lpVolumeSerial_Numberber As Long, lpMaximumComponentLength As Long, lpFileSystemFlags As Long, ByVal lpFileSystemNameBuffer As String, ByVal nFileSystemNameSize As Long) As Long
Type RECT
    left As Long
    top As Long
    right As Long
    bottom As Long
End Type
Declare Function IntersectRect Lib "user32" (lpDestRect As RECT, lpSrc1Rect As RECT, lpSrc2Rect As RECT) As Long

Public NotReset As Boolean

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
Public Const NIM_MODIFY = &H1
Public Const NIM_DELETE = &H2
Public Const NIF_MESSAGE = &H1
Public Const NIF_ICON = &H2
Public Const NIF_TIP = &H4
Public Const NIF_DOALL = NIF_MESSAGE Or NIF_ICON Or NIF_TIP
Public Const WM_MOUSEMOVE = &H200
Public Const WM_LBUTTONDBLCLK = &H203
Public Const WM_RBUTTONUP = &H205

Public Enum MSGTYPES
    MSG_NULL
    MSG_LOGIN
    MSG_PLAYERS
    MSG_ADDPLAYER
    MSG_REMOVEPLAYER
    MSG_GOTHEALTH
    MSG_CONNECTED
    MSG_SERVERMSG
    MSG_GAMELOGIN
    MSG_GAMEDATA
    MSG_GAMECHAT
    MSG_DIED
    MSG_NULLPLAYER
    MSG_POWERUP
    MSG_TEAM
    MSG_BOMB
    MSG_MISS
    MSG_LASER
    MSG_MINES
    MSG_GETFLAG
    MSG_DROPFLAG
    MSG_FLAGS
    MSG_PLAYING
    MSG_BOUNCY
    MSG_GAMESETTINGS
    MSG_PLAYERHOME
    MSG_SCORE
    MSG_MAP
    MSG_PLAYERSCORE
    MSG_ARMORLO
    MSG_SWITCH
    MSG_GETSWITCH
    MSG_PSPEED
    MSG_GAG
    MSG_MAPTRANSFER
    MSG_PING
    MSG_UPDATE
    MSG_NEWKEY
    MSG_FORCEPOS
    MSG_WEPSYNC
    MSG_WARPING
    MSG_UNIBALL
    MSG_TIMELIMIT
    MSG_ERROR
    MSG_UDPOK
    MSG_MODE
    MSG_UDPSTOP
    MSG_HEALTHFORCE
    MSG_DEVCHEAT ' TESTING ONLY
End Enum

Public Enum SVRTYPES
    SVR_COBALTID
    SVR_USERLOGIN
    SVR_ACCOUNT
    SVR_SIGNUP
    SVR_ADDUSER
    SVR_REMOVEUSER
    SVR_CHAT
    SVR_SERVERLOGIN
    SVR_ADDSERVER
    SVR_REMOVESERVER
    SVR_JOIN
    SVR_JOINED
    SVR_LEFT
    SVR_ICON
    SVR_PAGE
    SVR_PAGESTAT
    SVR_PROFILE
    SVR_PROFILEEDIT
    SVR_ZZZ
    SVR_ERROR
    SVR_OK
    SVR_UPDATE
    SVR_SVRADDPLAYER
    SVR_SVRREMOVEPLAYER
    SVR_MRB
    SVR_MODE
    SVR_PASSWORDPROTECTED
    SVR_STATS
    SVR_ENC
    SVR_CLEAR
    SVR_ADDROOM
    SVR_REMOVEROOM
    SVR_JOINROOM
    SVR_CREATEROOM
End Enum
'map header
Public Type HeadMap
    FormatID As Integer
    HeaderSize As Integer
    Version As Byte
    Width As Integer
    Height As Integer
    MaxPlayers As Byte
    HoldingTime As Byte
    NumTeams As Byte
    GameObjective As Byte
    LaserDamage As Byte
    SpecialDamage As Byte
    Recharge As Byte
    MissEnabled As Byte
    MortEnabled As Byte
    BouncyEnabled As Byte
    PowerupPosCount As Integer
    SimulPowerups As Byte
    SwitchCount As Byte
End Type
Public hFlagCounts() As Byte
Public hFlagPoleCounts() As Byte
Public hFlagPoleBases1() As Byte
Public hFlagPoleBases2() As Byte
Public hFlagPoleBases3() As Byte
Public hFlagPoleBases4() As Byte
Public Type hStrings
    hExtendedName As String
    hDescription As String
End Type
'exit map header
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

Public Type SendB
    Buff() As Byte
    Guaranteed As Boolean
    NotSent As Boolean
    pID As Integer
End Type
Public SendBuff() As SendB

Public Type UBALL
    Color As Byte
    BDelay As Single
    BSpeedX As Single
    BSpeedY As Single
    BMoveX As Integer
    BMoveY As Integer
    BLoopX As Single
    BLoopY As Single
    BallX As Integer
    BallY As Integer
    BallHits(4) As Long
    LastHit As Byte
    OldBallX As Integer
    OldBallY As Integer
    OldColor As Byte
    InHole As Byte
End Type
Public UniBall() As UBALL

Public Type LandMine
    Active As Boolean
    X As Integer
    y As Integer
    Who As Integer
    Color As Integer
    Tick As Long
End Type
Public Mines() As LandMine

Public Type Players
    Nick As String
    Banned As String
    Admin As Byte
    pong As Long
    smoking As Boolean
    Score As Integer
    Key As Byte
    CharX As Single
    CharY As Single
    Ship As Byte
    cMissile As Byte
    cBomb As Byte
    cBouncy As Byte
    cMines As Byte
    wBouncy As Single
    wBomb As Single
    wMissile As Single
    wMines As Single
    wEnergy As Single
    inpenTrig As Long
    inpen As Long
    SyncSet As Long
    activity As Long
    icon2 As Byte
    COBALTID As Long
    disablepm As Boolean
    serial As Long
    ID As Integer
    Icon As Integer
    Caps As Integer
    Duration As Long
    LoginCount As Byte
    LoginWait As Long
    Login As Boolean
    DevCheat As Byte
    UDPOK As Boolean
    PingTick As Long
    Ping As Long
    Frags As Integer
    Deaths As Integer
    KeyPacketHandle As Long
    gagged As Boolean
    playing As Boolean
    bPNT As Integer
    SendMap As Boolean
    SendMapTimer As Long
    die As Boolean
    WarpX As Integer
    WarpY As Integer
    WarpDone As Long
    Warped As Long
    Warping As Boolean
    WepSyncT As Long
    Flagging As Boolean
    FlagArray As Integer
    Flag As Integer
    WayPoint As Integer
    LastWayPoint As Integer
    AI As Boolean
    LastHit As Byte
    Health As Integer
    Tick As Long
    Degrees As Integer
    Direction As Byte
    Mode As Integer
    LastTeamSwitch As Long
End Type
Public PlayerDat() As Players

Public Type WayPoint
    X As Integer
    y As Integer
End Type
Public WayPoints() As WayPoint

Public Laser() As Boolean
Public LaserWho() As Integer
Public LaserTeam() As Integer
Public LaserX() As Integer
Public LaserY() As Integer
Public LaserDist() As Single
Public LaserAngle() As Single
Public LaserStopMve() As Integer
Public LaserHit() As Boolean

Public Bounce() As Boolean
Public BounceWho() As Integer
Public BounceTeam() As Integer
Public BounceX() As Integer
Public BounceY() As Integer
Public BounceDist() As Single
Public BounceTrav() As Single
Public BounceAngle() As Single
Public BounceStopMve() As Integer

Public Miss() As Boolean
Public MissWho() As Integer
Public MissTeam() As Integer
Public MissX() As Integer
Public MissY() As Integer
Public MissDist() As Single
Public MissAngle() As Single

Public Mortar() As Boolean
Public MortarWho() As Integer
Public MortarTeam() As Integer
Public MortarX() As Integer
Public MortarY() As Integer
Public MortarDest() As Single
Public MortarDist() As Single
Public MortarAngle() As Single
Public MortarSpeed() As Single

Public ShrapAngle() As Integer
Public ShrapDist() As Single
Public ShrapSpeed() As Single
Public ShrapTick() As Single
Public Explode() As Long, ExplodeX() As Integer, ExplodeY() As Integer, ExplodeWho() As Integer

Public HData As HeadMap, HDataNames As hStrings, Filename As String, FileLenB As Long
Public Exiting As Boolean, COBALTID As Long, Aver As Integer, BroadcastIP As String
Public Port As Long, Port2 As Long, Port3 As Long, UDPSocket As Long

Public g_CStrike As Boolean
Public gMyPlayerID As Long, gAllID As Long, RectsRet() As Integer, PSpeed As Integer, PBuffer As Integer
Public SMData() As Byte, HighestScore As Integer, HighestScoreWho As Integer
Public Animations() As Integer, AnimOffset() As Byte, Serial_Number As Long
Public Collision() As Integer, SourceX() As Integer, SourceY() As Integer, SourceTile(255, 255) As Integer
Public TeamScores(4) As Integer, Stopping As Boolean, TeamThatWON As Byte, ConnectionOK As Boolean
Public xtmp As Long, ytmp As Long, RetCollision() As Integer, RetAnimation() As Integer
Public LDamage(4) As Integer, SDamage(4) As Integer, SDamage2(4) As Integer, LDamage2(4) As Integer
Public FlagX(5) As Integer
Public FlagY(5) As Integer
Public Flag1() As Integer
Public Flag2() As Integer
Public Flag3() As Integer
Public Flag4() As Integer
Public Flag5() As Integer
Public FlagBase1() As Integer
Public FlagBase2() As Integer
Public FlagBase3() As Integer
Public FlagBase4() As Integer
Public FlagBase5() As Integer
Public Hold1() As Integer
Public Hold2() As Integer
Public Hold3() As Integer
Public Hold4() As Integer
Public Spawn1() As Integer
Public Spawn2() As Integer
Public Spawn3() As Integer
Public Spawn4() As Integer
Public FlagCarry1() As Integer
Public FlagCarry2() As Integer
Public FlagCarry3() As Integer
Public FlagCarry4() As Integer
Public FlagCarry5() As Integer
Public FlagReady1() As Long
Public FlagReady2() As Long
Public FlagReady3() As Long
Public FlagReady4() As Long
Public FlagReady5() As Long
Public FlagLast1() As Integer
Public FlagLast2() As Integer
Public FlagLast3() As Integer
Public FlagLast4() As Integer
Public FlagLast5() As Integer
Public Warp() As Integer
Public WarpOut() As Integer
Public PowerVal() As Byte
Public PowerX() As Integer
Public PowerY() As Integer
Public PowerTick() As Long
Public PowerEffect() As Byte
Public PowerLife() As Long

Public Switches() As Integer, SwitchIdle() As Long, SWEnable As Long
Public Switched() As Integer, SwitchWON As Integer, BallWON As Integer
Public FlagsHome1() As Boolean, LobbyLimit As Byte, PlayerLimit As Byte
Public FlagsHome2() As Boolean
Public FlagsHome3() As Boolean, SendMap As Integer, GetMap As Integer
Public FlagsHome4() As Boolean, Cheat As Integer
Public FlagsHome5() As Boolean, stamp55 As Long
Public FlagGame(5) As Boolean, AdminPass As String
Public MapPlay As String, FlagHeld() As Boolean

'Public LDamage(4) As Integer, SDamage(4) As Integer, SDamage2(4) As Integer, LDamage2(4) As Integer

Public CfgFile As String, AdminList() As String

Public g_ServerName As String, g_Locked As Boolean
Public g_Password As String, g_Port As Long
Public g_HoldTime As Byte, g_IdleTime As Single, g_MOTD As String
Public g_LaserDamage As Byte, g_SpecialDamage As Byte, g_RechargeRate As Byte
Public g_FlagReturn As Byte, g_TimeLimit As Single, TimeClock As Long, TimeTick As Long
Public g_UniBall As Byte, g_FlagWarp As Boolean, g_SmashARC As Byte, g_DeathMatch As Byte
Public g_Missiles As Byte, SpeedMiss(4) As Single
Public g_Grenades As Byte, SpeedMort(4) As Single
Public g_Bouncies As Byte, SpeedBoun(4) As Single
Public g_Mines As Byte
Public g_MaxPlayers As Byte, speed As Single
Public g_PowerUps As Byte
Public Const glClientSideEncryptionKey As Long = 159

Public Type RoughRect
    hTop As Byte
    hBottom As Byte
    hLeft As Byte
    hRight As Byte
End Type

Public Type BanIP
    Name As String
    IP As String
End Type
Public Bans() As BanIP

Public mlConnectAsync As Long, Closed As Boolean
Public RoughTile(4000) As RoughRect
Public Const PI = 3.14159265
Public Const Div180byPI As Double = 180 / PI
Public Const TwoPI As Double = PI * 2
Public Const DivBy360 As Double = 1 / 360
Public Const Div360MultPI As Double = DivBy360 * TwoPI

Private Type BuffSpace
    Data() As Byte
    DataLength As Long
End Type

Public BufferSpace() As BuffSpace

Dim b As Byte, tmp As String, L As Long, j As Integer, e As Integer
Dim LT As Long, LC As Boolean, LV As Long, enginetime As Long, BS As Single
Dim oNewMsg() As Byte, lNewOffSet As Long
Dim lNewMsg As Byte
Dim i As Integer, d As Long, bc As Byte, a As Integer, X As Integer, bpc As Byte
Dim PCount As Long, TimeEvents As Long
Public ErrorMSG As String
Public bDebugLog As Long

Public Const HKEY_CLASSES_ROOT = &H80000000
Public Const HKEY_CURRENT_USER = &H80000001
Public Const HKEY_LOCAL_MACHINE = &H80000002
Public Const HKEY_USERS = &H80000003
Public Const HKEY_CURRENT_CONFIG = &H80000005
Public Const HKEY_DYN_DATA = &H80000006
Public Const REG_SZ = 1 'Unicode nul terminated string
Public Const REG_BINARY = 3 'Free form binary
Public Const REG_DWORD = 4 '32-bit number
Public Const ERROR_SUCCESS = 0&

Public Const ABOVE_NORMAL_PRIORITY_CLASS = &H8000&
Public Const BELOW_NORMAL_PRIORITY_CLASS = &H4000&
Public Const HIGH_PRIORITY_CLASS = &H80&
Public Const IDLE_PRIORITY_CLASS = &H40&
Public Const NORMAL_PRIORITY_CLASS = &H20&
Public Const REALTIME_PRIORITY_CLASS = &H100&
Declare Function GetCurrentProcess _
    Lib "kernel32" _
    () As Long

Declare Function SetPriorityClass _
    Lib "kernel32" _
    (ByVal hProcess As Long, _
    ByVal dwPriorityClass As Long) As Long

Public Encryption As clsEncryption
Public EncPassword As String

Public Function NewGTC() As Long
    Dim C As Long
    C = GetTickCount
    If C < 0 Then
        C = C + 2147483647
    End If
    NewGTC = C
End Function

Public Function SetMyPriority(Priority As Long) As Boolean
    Dim hProcess As Long
    Dim nResult As Long
    hProcess = GetCurrentProcess
    nResult = SetPriorityClass(hProcess, Priority)
    If nResult = 0 Then
        SetMyPriority = False
    Else
        SetMyPriority = True
    End If
End Function

Public Sub FireLaser(Who As Byte, lx As Integer, ly As Integer, cx As Integer, cy As Integer)
    Dim j As Integer
    If PlayerDat(Who).Ship = 0 Then Exit Sub
    For j = 0 To UBound(Laser) + 1
        If j > UBound(Laser) Then
            ReDim Preserve Laser(j), LaserWho(j), LaserAngle(j), LaserDist(j), LaserX(j), LaserY(j), LaserStopMve(j), LaserTeam(j), LaserHit(j)
        End If
        If Not Laser(j) Then
            LaserWho(j) = Who
            LaserTeam(j) = PlayerDat(Who).Ship
            LaserStopMve(j) = -11
            If lx = 0 Then lx = 1
            If ly = 0 Then ly = 1
            LaserAngle(j) = Atn(ly / lx)
            LaserAngle(j) = LaserAngle(j) * Div180byPI
            If lx < 0 Then LaserAngle(j) = LaserAngle(j) + 180
            LaserDist(j) = 0
            LaserX(j) = cx + 16
            LaserY(j) = cy + 16
            Laser(j) = True
            Exit For
        End If
    Next
    'Exit Sub
    Dim oNewMsg() As Byte, lNewOffSet As Long
    Dim lNewMsg As Byte
    lNewMsg = MSG_LASER
    lNewOffSet = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
    AddBufferData oNewMsg, VarPtr(Who), LenB(Who), lNewOffSet
    AddBufferData oNewMsg, VarPtr(lx), LenB(lx), lNewOffSet
    AddBufferData oNewMsg, VarPtr(ly), LenB(ly), lNewOffSet
    AddBufferData oNewMsg, VarPtr(cx), LenB(cx), lNewOffSet
    AddBufferData oNewMsg, VarPtr(cy), LenB(cy), lNewOffSet
    SendTo oNewMsg, -2, False
End Sub

Public Sub FireBounce(Who As Byte, lx As Integer, ly As Integer, cx As Integer, cy As Integer)
    Dim oNewMsg() As Byte, lNewOffSet As Long
    Dim lNewMsg As Byte
    Dim j As Integer, LasrX As Integer, LasrY As Integer
    For j = 0 To UBound(Bounce) + 1
        If j > UBound(Bounce) Then
            ReDim Preserve Bounce(j), BounceWho(j), BounceAngle(j), BounceDist(j), BounceTrav(j), BounceX(j), BounceY(j), BounceTeam(j), BounceStopMve(j)
        End If
        If Not Bounce(j) Then
            If lx = 0 Then lx = 1
            If ly = 0 Then ly = 1
            BounceWho(j) = Who
            BounceTeam(j) = PlayerDat(Who).Ship
            BounceStopMve(j) = -11
            BounceAngle(j) = Atn(ly / lx)
            BounceAngle(j) = BounceAngle(j) * Div180byPI
            If lx < 0 Then BounceAngle(j) = BounceAngle(j) + 180
            BounceDist(j) = 0
            BounceTrav(j) = 0
            BounceX(j) = cx + 16
            BounceY(j) = cy + 16
            Bounce(j) = True
            Exit For
        End If
    Next
    lNewMsg = MSG_BOUNCY
    lNewOffSet = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
    AddBufferData oNewMsg, VarPtr(Who), LenB(Who), lNewOffSet
    AddBufferData oNewMsg, VarPtr(lx), LenB(lx), lNewOffSet
    AddBufferData oNewMsg, VarPtr(ly), LenB(ly), lNewOffSet
    AddBufferData oNewMsg, VarPtr(cx), LenB(cx), lNewOffSet
    AddBufferData oNewMsg, VarPtr(cy), LenB(cy), lNewOffSet
    SendTo oNewMsg, -2, True
End Sub

Sub FireMort(Who As Byte, lx As Integer, ly As Integer, cx As Integer, cy As Integer)
    Dim j As Integer, LasrX As Integer, LasrY As Integer
    For j = 0 To UBound(Mortar)
        If Not Mortar(j) Then Exit For
        If j = UBound(Mortar) Then
            j = j + 1
            ReDim Preserve Mortar(j), MortarWho(j), MortarX(j), MortarY(j), MortarDest(j), MortarDist(j)
            ReDim Preserve MortarAngle(j), MortarTeam(j), MortarSpeed(j), MortarTeam(j)
            j = j - 1
        End If
    Next
    If lx = 0 Then lx = 1
    If ly = 0 Then ly = 1
    MortarAngle(j) = Atn(ly / lx)
    MortarAngle(j) = MortarAngle(j) * Div180byPI
    If lx < 0 Then MortarAngle(j) = MortarAngle(j) + 180
    MortarDest(j) = Sqr(lx ^ 2 + ly ^ 2)
    MortarSpeed(j) = (MortarDest(j) * 0.0038) + ((477 - MortarDest(j)) * 0.001)
    MortarDist(j) = 0
    MortarX(j) = cx + 16
    MortarY(j) = cy + 16
    Mortar(j) = True
    MortarWho(j) = Who
    MortarTeam(j) = PlayerDat(Who).Ship
End Sub

Public Function SetMine(Who As Byte, Color As Byte, X As Integer, y As Integer) As Integer
    Dim i As Integer
    For i = 0 To UBound(Mines) + 1
        If i > UBound(Mines) Then ReDim Preserve Mines(i)
        If Mines(i).Color = 0 Then
            Mines(i).Who = Who
            Mines(i).Color = Color
            Mines(i).X = X
            Mines(i).y = y
            Mines(i).Tick = 0
            SetMine = i
            Exit For
        End If
    Next
End Function

Public Sub BombHit(X As Integer, y As Integer)
    Dim i As Integer, rBomb As RECT, rMine As RECT, rTemp As RECT
    With rBomb
        .left = X
        .top = y
        .right = .left + 5
        .bottom = .top + 5
    End With
    For i = 0 To UBound(Mines)
        If Mines(i).Color > 0 Then
            With rMine
                .left = Mines(i).X
                .top = Mines(i).y
                .right = .left + 8
                .bottom = .top + 8
            End With
            If IntersectRect(rTemp, rBomb, rMine) Then
                Mines(i).Active = True
                Mines(i).Tick = 0
            End If
        End If
    Next
End Sub

Public Sub AnimLaser(i As Integer)
    Dim rWeapon As RECT, rWho As RECT, rHit As RECT, rTemp As RECT, NewX As Integer, NewY As Integer, j As Integer
    Dim OldDist As Integer, d As Integer, e As Integer, pan As Integer
    Dim LasrX As Integer, LasrY As Integer, LasrX2 As Integer, LasrY2 As Integer, TmpDist As Integer
    OldDist = LaserDist(i)
    LaserDist(i) = LaserDist(i) + 6.5 * speed
    If Val(LaserDist(i)) > 30000 Then LaserDist(i) = 0
    TmpDist = LaserDist(i)
    If TmpDist > 500 Or LaserStopMve(i) <> -11 Then
        LaserStopMve(i) = -11
        Laser(i) = False: Exit Sub
    End If
    
    For d = OldDist To LaserDist(i)
        NewX = Cos(LaserAngle(i) * Div360MultPI) * d + LaserX(i)
        NewY = Sin(LaserAngle(i) * Div360MultPI) * d + LaserY(i)
        j = WeaponTouch(0, i, NewX, NewY, 0, True)
        If j <> 0 Then
            TmpDist = d - 1
            LaserStopMve(i) = d - 1
            'If j > 0 Then Stop
            Exit For
        End If
    Next
    
End Sub

Public Sub AnimBounce(i As Integer)
    Dim NewX As Integer, NewY As Integer, tmp As Integer, OldDist As Integer
    Dim d As Integer, e As Integer, j As Single
    Dim TmpDist As Integer
    OldDist = BounceDist(i)
    BounceDist(i) = BounceDist(i) + 8 * speed
    BounceTrav(i) = BounceTrav(i) + 8 * speed
    TmpDist = BounceDist(i)
    
    If BounceTrav(i) > 1000 And BounceStopMve(i) = -11 Then BounceStopMve(i) = OldDist
    
    If BounceStopMve(i) > -11 Then
        If TmpDist - BounceStopMve(i) > 90 Then
            BounceStopMve(i) = -11
            Bounce(i) = False: Exit Sub
        End If
        TmpDist = BounceStopMve(i)
    End If
    
    If BounceStopMve(i) = -11 Then
        e = BounceDist(i)
        d = OldDist + 1
        If d > e Then
            NewX = Cos(BounceAngle(i) * Div360MultPI) * d + BounceX(i)
            NewY = Sin(BounceAngle(i) * Div360MultPI) * d + BounceY(i)
        End If
        For d = d To e
            NewX = Cos(BounceAngle(i) * Div360MultPI) * d + BounceX(i)
            NewY = Sin(BounceAngle(i) * Div360MultPI) * d + BounceY(i)
            j = BounceAngle(i)
            tmp = WeaponTouch(3, i, NewX, NewY, j, True)
            If tmp > 0 Then
                TmpDist = d - 1
                BounceStopMve(i) = d - 1
                BounceDist(i) = BounceDist(i) + 8
                Exit For
            End If
        Next
    Else
        NewX = Cos(BounceAngle(i) * Div360MultPI) * (BounceStopMve(i)) + BounceX(i)
        NewY = Sin(BounceAngle(i) * Div360MultPI) * (BounceStopMve(i)) + BounceY(i)
    End If
End Sub

Public Sub Mortars(i As Integer)
    Dim rWeapon As RECT, rWho As RECT, rHit As RECT, rTemp As RECT
    Dim ExX As Integer, ExY As Integer, j As Integer, NewEx As Long, d As Integer, si As Single
    If MortarDist(i) <= MortarDest(i) Then
        MortarDist(i) = MortarDist(i) + MortarSpeed(i) * 1.5 * speed
        ExX = Cos(MortarAngle(i) * Div360MultPI) * MortarDist(i) + MortarX(i)
        ExY = Sin(MortarAngle(i) * Div360MultPI) * MortarDist(i) + MortarY(i)
        If MortarDist(i) > MortarDest(i) Then
            BombHit ExX, ExY
            ExplShrap MortarWho(i), ExX, ExY, 3.5, 700, 0, 12
            Mortar(i) = False
        End If
    End If
End Sub

Public Sub AnimUniBall(i As Integer)
    Dim Rx As Integer, Ry As Integer, rBuff As RECT
    Dim xt As Integer, yt As Integer, j As Integer, e As Integer
    Dim NewX As Integer, NewY As Integer, d As Integer, SgnX As Integer, SgnY As Integer
    Dim RatioX As Single, RatioY As Single
    Rx = 452
    Ry = 81
    
    NewX = UniBall(i).BallX
    NewY = UniBall(i).BallY
    If UniBall(i).BSpeedX > UniBall(i).BSpeedY And UniBall(i).BSpeedY > 0 Then RatioY = UniBall(i).BSpeedX / UniBall(i).BSpeedY
    If UniBall(i).BSpeedY > UniBall(i).BSpeedX And UniBall(i).BSpeedX > 0 Then RatioX = UniBall(i).BSpeedY / UniBall(i).BSpeedX
    If RatioX < 1 Then RatioX = 1
    If RatioY < 1 Then RatioY = 1
    If UniBall(i).BSpeedX > 0 Then UniBall(i).BSpeedX = UniBall(i).BSpeedX - (0.01 / RatioX) * speed
    If UniBall(i).BSpeedY > 0 Then UniBall(i).BSpeedY = UniBall(i).BSpeedY - (0.01 / RatioY) * speed
    If UniBall(i).BSpeedX < 0 Then UniBall(i).BSpeedX = 0
    If UniBall(i).BSpeedY < 0 Then UniBall(i).BSpeedY = 0
    
    UniBall(i).BLoopX = UniBall(i).BLoopX + (UniBall(i).BSpeedX * speed)
    For j = 1 To UniBall(i).BLoopX
        NewX = NewX + UniBall(i).BMoveX
        UniBall(i).BLoopX = UniBall(i).BLoopX - 1
    Next
    
    UniBall(i).BLoopY = UniBall(i).BLoopY + (UniBall(i).BSpeedY * speed)
    For j = 1 To UniBall(i).BLoopY
        NewY = NewY + UniBall(i).BMoveY
        UniBall(i).BLoopY = UniBall(i).BLoopY - 1
    Next
    
    
    SgnX = Sgn(NewX - UniBall(i).BallX)
    SgnY = Sgn(NewY - UniBall(i).BallY)
    
    
    If SgnX = 1 Then 'x positive testing
        For d = UniBall(i).BallX + 1 To NewX
            j = WeaponTouch(6, i, d, UniBall(i).BallY)
            If j = -7 Then
                Exit For
            End If
            If j = -6 Then
                UniBall(i).BMoveX = UniBall(i).BMoveX * -1
                NewX = d - 1
                Exit For
            End If
        Next
    End If
    
    If SgnX = -1 Then 'x negative testing
        For d = UniBall(i).BallX - 1 To NewX Step -1
            j = WeaponTouch(6, i, d, UniBall(i).BallY)
            If j = -6 Then
                UniBall(i).BMoveX = UniBall(i).BMoveX * -1
                NewX = d + 1
                Exit For
            End If
        Next
    End If
    
    If SgnY = 1 Then 'y positive testing
        For d = UniBall(i).BallY + 1 To NewY
            j = WeaponTouch(6, i, NewX, d)
            If j = -6 Then
                UniBall(i).BMoveY = UniBall(i).BMoveY * -1
                NewY = d - 1
                Exit For
            End If
        Next
    End If
    
    If SgnY = -1 Then 'y negative testing
        For d = UniBall(i).BallY - 1 To NewY Step -1
            j = WeaponTouch(6, i, NewX, d)
            If j = -6 Then
                UniBall(i).BMoveY = UniBall(i).BMoveY * -1
                NewY = d + 1
                Exit For
            End If
        Next
    End If
    j = WeaponTouch(6, i, NewX, NewY)
    If j = -7 Then Exit Sub
    
    UniBall(i).BallX = NewX
    UniBall(i).BallY = NewY
End Sub
Public Function CompressData(TheData() As Byte) As Long
    'Allocate memory for byte array
    Dim BufferSize As Long, OriginalSize As Long, Result As Long, CompressedSize As Long
    Dim TempBuffer() As Byte
    
    OriginalSize = UBound(TheData) + 1
    
    
    BufferSize = UBound(TheData) + 1
    BufferSize = BufferSize + (BufferSize * 0.01) + 12
    ReDim TempBuffer(BufferSize)
    
    'Compress byte array (data)
    Result = compress(TempBuffer(0), BufferSize, TheData(0), UBound(TheData) + 1)
    
    'Truncate to compressed size
    ReDim Preserve TheData(BufferSize - 1)
    CopyMemory TheData(0), TempBuffer(0), BufferSize
    
    'Cleanup
    Erase TempBuffer
    
    'Set properties if no error occurred
    If Result = 0 Then CompressedSize = UBound(TheData) + 1
    
    'Return error code (if any)
    CompressData = Result
    
End Function

Public Sub DebugLog(txt As String)
    'debug.print txt
    Open AppPath & "ARCServerDebugLog.txt" For Append As #1
    Print #1, txt
    Close #1
End Sub

Private Function WeaponTouch(Wep As Integer, WepIndex As Integer, WX As Integer, WY As Integer, Optional Ang As Single = 0, Optional hurt As Boolean = False) As Integer
    Dim rTemp As RECT, rWho As RECT, rBlock As RECT, i As Integer, j As Integer, SgnX As Integer, SgnY As Integer
    Dim C As Integer, d As Integer, e As Integer, F As Integer, G As Integer, h As Single, BS As Single
    Dim TestXY As Integer, b As Byte, NewX As Integer, NewY As Integer, NewsX As Integer, NewsY As Integer
    Dim PowerX As Integer, PowerY As Integer, b2 As Byte, tmp As String
    Dim oNewMsg() As Byte, lNewOffSet As Long
    Dim lNewMsg As Byte
    If Wep = 0 Then
        If WepIndex > -1 Then
            b = LaserWho(WepIndex)
        Else
            b = Abs(WepIndex)
        End If
        rWho.top = WY
        rWho.left = WX
        rWho.bottom = rWho.top + 1
        rWho.right = rWho.left + 1
        If WepIndex > -1 Then
            SgnX = WX - LaserX(WepIndex)
            SgnY = WY - LaserY(WepIndex)
        Else
            SgnX = WX - (PlayerDat(Abs(WepIndex)).CharX + 16)
            SgnY = WY - (PlayerDat(Abs(WepIndex)).CharY + 16)
        End If
        SgnX = Sgn(SgnX): SgnY = Sgn(SgnY)
    ElseIf Wep = 1 Then
        b = MissWho(WepIndex)
        rWho.top = WY
        rWho.left = WX
        rWho.bottom = rWho.top + 1
        rWho.right = rWho.left + 1
        SgnX = WX - MissX(WepIndex)
        SgnY = WY - MissY(WepIndex)
        SgnX = Sgn(SgnX): SgnY = Sgn(SgnY)
    ElseIf Wep = 3 Then
        rWho.top = WY
        rWho.left = WX
        rWho.bottom = rWho.top + 1
        rWho.right = rWho.left + 1
        b = BounceWho(WepIndex)
        SgnX = WX - BounceX(WepIndex)
        SgnY = WY - BounceY(WepIndex)
        SgnX = Sgn(SgnX): SgnY = Sgn(SgnY)
    ElseIf Wep = 4 Then
        b = ExplodeWho(WepIndex)
        rWho.top = WY
        rWho.left = WX
        rWho.bottom = rWho.top + 3
        rWho.right = rWho.left + 3
        SgnX = WX - ExplodeX(WepIndex)
        SgnY = WY - ExplodeY(WepIndex)
        SgnX = Sgn(SgnX): SgnY = Sgn(SgnY)
    ElseIf Wep = 6 Then
        rWho.top = WY
        rWho.left = WX
        rWho.bottom = rWho.top + 10
        rWho.right = rWho.left + 10
        SgnX = WX - UniBall(WepIndex).BallX
        SgnY = WY - UniBall(WepIndex).BallY
        SgnX = Sgn(SgnX): SgnY = Sgn(SgnY)
    End If
    j = 0
    For i = 1 To UBound(PlayerDat)
        If (i <> b) And Not PlayerDat(i).Mode = 1 And Wep <> 6 Then 'CAUTION: Added 7/17/05. Might be buggy?
            rBlock.top = PlayerDat(i).CharY + 2
            rBlock.left = PlayerDat(i).CharX + 2
            rBlock.bottom = rBlock.top + 28
            rBlock.right = rBlock.left + 28
            If PlayerDat(i).Ship > 0 And (PlayerDat(i).Ship <> PlayerDat(b).Ship Or PlayerDat(i).Ship = 5) Then
                If IntersectRect(rTemp, rWho, rBlock) Then
                    WeaponTouch = i
                    If hurt And PlayerDat(i).Health > 0 Then
                        If PlayerDat(i).Health > 60 Then PlayerDat(i).Health = 60
                        If Wep = 0 Then
                            PlayerDat(i).Health = PlayerDat(i).Health - LDamage(g_LaserDamage) 'Laser
                        ElseIf Wep = 1 Then
                            PlayerDat(i).Health = PlayerDat(i).Health - SDamage(g_SpecialDamage) 'Missile
                        ElseIf Wep = 2 Then
                            'Grenade shell causes no damage itself,
                            'it's the shrapnel which kills you.
                        ElseIf Wep = 3 Then
                            PlayerDat(i).Health = PlayerDat(i).Health - LDamage2(g_SpecialDamage) 'Bouncy laser
                        ElseIf PlayerDat(i).inpen = 0 And Wep = 4 Then 'When you're in the pen, grenades cannot harm you.
                            PlayerDat(i).Health = PlayerDat(i).Health - SDamage2(g_SpecialDamage) 'Grenade shrapnel
                        End If
                        lNewMsg = MSG_HEALTHFORCE
                        lNewOffSet = 0
                        ReDim oNewMsg(0)
                        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
                        AddBufferData oNewMsg, VarPtr(PlayerDat(i).Health), LenB(PlayerDat(i).Health), lNewOffSet
                        SendTo oNewMsg, i
                        If PlayerDat(i).Health < 18 Then
                            If Not PlayerDat(i).smoking Then
                                PlayerDat(i).smoking = True
                                lNewMsg = MSG_ARMORLO
                                lNewOffSet = 0
                                ReDim oNewMsg(0)
                                AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
                                b2 = i
                                AddBufferData oNewMsg, VarPtr(b2), LenB(b2), lNewOffSet
                                b2 = PlayerDat(i).smoking
                                AddBufferData oNewMsg, VarPtr(b2), LenB(b2), lNewOffSet
                                SendTo oNewMsg, -2
                            End If
                        End If
                        If PlayerDat(i).Health < 1 Then
                            PlayerDied CByte(i), b, Wep, WepIndex
                        End If
                        Exit Function 'CAUTION: _Possible_ buggy effects.
                    End If
                End If
            End If
        End If
    Next
    
    For i = 0 To UBound(UniBall)
        rBlock.top = UniBall(i).BallY
        rBlock.left = UniBall(i).BallX
        rBlock.bottom = rBlock.top + 10
        rBlock.right = rBlock.left + 10
        If IntersectRect(rTemp, rWho, rBlock) And PlayerDat(b).Ship <> UniBall(i).InHole Then
            WeaponTouch = -1
            If Wep = 0 Then
                PowerX = Cos(LaserAngle(WepIndex) * Div360MultPI) * 100
                PowerY = Sin(LaserAngle(WepIndex) * Div360MultPI) * 100
                
                UniBall(i).BSpeedX = UniBall(i).BSpeedX + (PowerX * 0.01 * UniBall(i).BMoveX)
                UniBall(i).BSpeedY = UniBall(i).BSpeedY + (PowerY * 0.01 * UniBall(i).BMoveY)
                If UniBall(i).BSpeedX < 0 Then
                    UniBall(i).BSpeedX = Abs(UniBall(i).BSpeedX)
                    UniBall(i).BMoveX = UniBall(i).BMoveX * -1
                End If
                If UniBall(i).BSpeedY < 0 Then
                    UniBall(i).BSpeedY = Abs(UniBall(i).BSpeedY)
                    UniBall(i).BMoveY = UniBall(i).BMoveY * -1
                End If
                lNewMsg = MSG_UNIBALL
                lNewOffSet = 0
                ReDim oNewMsg(0)
                AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
                AddBufferData oNewMsg, VarPtr(i), LenB(i), lNewOffSet
                b2 = UniBall(i).Color
                AddBufferData oNewMsg, VarPtr(b2), LenB(b2), lNewOffSet
                j = UniBall(i).BallX
                AddBufferData oNewMsg, VarPtr(j), LenB(j), lNewOffSet
                j = UniBall(i).BallY
                AddBufferData oNewMsg, VarPtr(j), LenB(j), lNewOffSet
                j = UniBall(i).BMoveX
                AddBufferData oNewMsg, VarPtr(j), LenB(j), lNewOffSet
                j = UniBall(i).BMoveY
                AddBufferData oNewMsg, VarPtr(j), LenB(j), lNewOffSet
                BS = UniBall(i).BSpeedX
                AddBufferData oNewMsg, VarPtr(BS), LenB(BS), lNewOffSet
                BS = UniBall(i).BSpeedY
                AddBufferData oNewMsg, VarPtr(BS), LenB(BS), lNewOffSet
                SendTo oNewMsg, -1, False
                
                UniBall(i).LastHit = b
                UniBall(i).BallHits(PlayerDat(b).Ship) = UniBall(i).BallHits(PlayerDat(b).Ship) + 1
                If UniBall(i).InHole > 0 Then
                    tmp = Choose(b2, "green", "red", "blue", "yellow", "not-a-team's")
                    Call sendmsg(MSG_GAMECHAT, Chr(PlayerDat(b).Ship) & PlayerDat(b).Nick & Chr(5) & " shot the " & Chr(b2) & tmp & Chr(5) & " ball free", -1)
                    UniBall(i).InHole = 0
                End If
            End If
        End If
    Next
    
    If Wep = 3 Then
        rWho.top = WY - 2
        rWho.left = WX - 2
        rWho.bottom = rWho.top + 4
        rWho.right = rWho.left + 4
    End If
    
    j = (WY And -16) / 16
    i = (WX And -16) / 16
    
    C = i - 1
    d = i + 1
    e = j - 1
    F = j + 1
    For j = e To F
        For i = C To d
            If j < 0 Or i < 0 Then GoTo out
            
            If j > 255 Or i > 255 Then GoTo out
            If SourceTile(j, i) > -1 Then
                rBlock.left = i * 16 + RoughTile(SourceTile(j, i)).hLeft
                rBlock.right = rBlock.left + 16 - RoughTile(SourceTile(j, i)).hLeft - RoughTile(SourceTile(j, i)).hRight
                rBlock.top = j * 16 + RoughTile(SourceTile(j, i)).hTop
                rBlock.bottom = rBlock.top + 16 - RoughTile(SourceTile(j, i)).hTop - RoughTile(SourceTile(j, i)).hBottom
            Else
                rBlock.left = i * 16
                rBlock.right = rBlock.left + 16
                rBlock.top = j * 16
                rBlock.bottom = rBlock.top + 16
            End If
            If IntersectRect(rTemp, rWho, rBlock) Then
                If Collision(j, i) > -1 And Collision(j, i) < 8 Then
                    If Wep = 0 Then 'Laser
                        If Collision(j, i) = 0 Or Collision(j, i) = 2 Then GoTo out
                        If SourceTile(j, i) = 425 Then If SgnY <> 1 Then WeaponTouch = -1: Exit Function
                        If SourceTile(j, i) = 424 Then If SgnX <> 1 Then WeaponTouch = -1: Exit Function
                        If SourceTile(j, i) = 422 Then If SgnX <> -1 Then WeaponTouch = -1: Exit Function
                        If SourceTile(j, i) = 303 Then If SgnX <> 1 Then WeaponTouch = -1: Exit Function
                        If SourceTile(j, i) = 301 Then If SgnX <> -1 Then WeaponTouch = -1: Exit Function
                        If SourceTile(j, i) = 225 Then If SgnY <> 1 Then WeaponTouch = -1: Exit Function
                        If SourceTile(j, i) = 345 Then If SgnY <> -1 Then WeaponTouch = -1: Exit Function
                        If SourceTile(j, i) = 388 Then If SgnY <> 1 Then WeaponTouch = -1: Exit Function
                        If SourceTile(j, i) = 308 Then If SgnY <> -1 Then WeaponTouch = -1: Exit Function
                        If Collision(j, i) = 4 Then If SgnY = 0 Or SgnY = -1 Then GoTo out
                        If Collision(j, i) = 5 Then If SgnY = 0 Or SgnY = 1 Then GoTo out
                        If Collision(j, i) = 6 Then If SgnX = 0 Or SgnX = -1 Then GoTo out
                        If Collision(j, i) = 7 Then If SgnX = 0 Or SgnX = 1 Then GoTo out
                        WeaponTouch = -1: Exit Function
                    ElseIf Wep = 1 Then 'Missile
                        If Collision(j, i) = 0 Or Collision(j, i) = 2 Then GoTo out
                        If SourceTile(j, i) = 425 Then If SgnY <> 1 Then WeaponTouch = -1: Exit Function
                        If SourceTile(j, i) = 424 Then If SgnX <> 1 Then WeaponTouch = -1: Exit Function
                        If SourceTile(j, i) = 422 Then If SgnX <> -1 Then WeaponTouch = -1: Exit Function
                        If SourceTile(j, i) = 303 Then If SgnX <> 1 Then WeaponTouch = -1: Exit Function
                        If SourceTile(j, i) = 301 Then If SgnX <> -1 Then WeaponTouch = -1: Exit Function
                        If SourceTile(j, i) = 225 Then If SgnY <> 1 Then WeaponTouch = -1: Exit Function
                        If SourceTile(j, i) = 345 Then If SgnY <> -1 Then WeaponTouch = -1: Exit Function
                        If SourceTile(j, i) = 388 Then If SgnY <> 1 Then WeaponTouch = -1: Exit Function
                        If SourceTile(j, i) = 308 Then If SgnY <> -1 Then WeaponTouch = -1: Exit Function
                        If Collision(j, i) = 4 Then If SgnY = 0 Or SgnY = -1 Then GoTo out
                        If Collision(j, i) = 5 Then If SgnY = 0 Or SgnY = 1 Then GoTo out
                        If Collision(j, i) = 6 Then If SgnX = 0 Or SgnX = -1 Then GoTo out
                        If Collision(j, i) = 7 Then If SgnX = 0 Or SgnX = 1 Then GoTo out
                        WeaponTouch = -1: Exit Function
                    ElseIf Wep = 3 Then 'Bouncies
                        If Collision(j, i) = 0 Or Collision(j, i) = 2 Then GoTo out
                        If SourceTile(j, i) = 425 Then If SgnY <> 1 Then GoTo detect
                        If SourceTile(j, i) = 424 Then If SgnX <> 1 Then GoTo detect
                        If SourceTile(j, i) = 422 Then If SgnX <> -1 Then GoTo detect
                        If SourceTile(j, i) = 303 Then If SgnX <> 1 Then GoTo detect
                        If SourceTile(j, i) = 301 Then If SgnX <> -1 Then GoTo detect
                        If SourceTile(j, i) = 225 Then If SgnY <> 1 Then GoTo detect
                        If SourceTile(j, i) = 345 Then If SgnY <> -1 Then GoTo detect
                        If SourceTile(j, i) = 388 Then If SgnY <> 1 Then GoTo detect
                        If SourceTile(j, i) = 308 Then If SgnY <> -1 Then GoTo detect
                        If Collision(j, i) = 4 Then If SgnY = 0 Or SgnY = -1 Then GoTo out
                        If Collision(j, i) = 5 Then If SgnY = 0 Or SgnY = 1 Then GoTo out
                        If Collision(j, i) = 6 Then If SgnX = 0 Or SgnX = -1 Then GoTo out
                        If Collision(j, i) = 7 Then If SgnX = 0 Or SgnX = 1 Then GoTo out
detect:
                        rWho.top = WY + SgnY
                        rWho.bottom = rWho.top + 1
                        If WX >= i * 16 And WY + SgnY >= j * 16 And WX <= i * 16 + 16 And WY + SgnY <= j * 16 + 16 Then WeaponTouch = 3: TestXY = 1
                        If TestXY = 0 Then
                            rWho.top = WY
                            rWho.left = WX + SgnX
                            rWho.bottom = rWho.top + 1
                            rWho.right = rWho.left + 1
                            If WX + SgnX >= i * 16 And WY >= j * 16 And WX + SgnX <= i * 16 + 16 And WY <= j * 16 + 16 Then WeaponTouch = 3: TestXY = 2
                        End If
                        If TestXY = 1 Then
                            If BounceAngle(WepIndex) < 1 Then
                                h = Abs(BounceAngle(WepIndex))
                            ElseIf BounceAngle(WepIndex) > 0 And BounceAngle(WepIndex) < 91 Then
                                h = BounceAngle(WepIndex) * -1
                            ElseIf BounceAngle(WepIndex) > 90 And BounceAngle(WepIndex) < 181 Then
                                h = 270 - (BounceAngle(WepIndex) - 90)
                            ElseIf BounceAngle(WepIndex) > 180 And BounceAngle(WepIndex) < 270 Then
                                h = 90 + (270 - BounceAngle(WepIndex))
                            End If
                            'WeaponTouch = -1
                            C = BounceWho(WepIndex)
                            ReBoun C, WX, WY, h, WepIndex
                            Exit Function
                        ElseIf TestXY = 2 Then
                            If BounceAngle(WepIndex) < 1 Then
                                h = 180 + Abs(BounceAngle(WepIndex))
                            ElseIf BounceAngle(WepIndex) > 0 And BounceAngle(WepIndex) < 91 Then
                                h = 180 - BounceAngle(WepIndex)
                            ElseIf BounceAngle(WepIndex) > 90 And BounceAngle(WepIndex) < 181 Then
                                h = 90 - (BounceAngle(WepIndex) - 90)
                            ElseIf BounceAngle(WepIndex) > 180 And BounceAngle(WepIndex) < 270 Then
                                h = -90 + (270 - BounceAngle(WepIndex))
                            End If ' test done
                            'WeaponTouch = -1
                            C = BounceWho(WepIndex)
                            ReBoun C, WX, WY, h, WepIndex
                            Exit Function
                        End If
                    ElseIf Wep = 2 Or Wep = 4 Then
                        If Animations(j, i) = -2 And Wep = 2 Then WeaponTouch = 3: GoTo out
                        If Collision(j, i) = 0 Or Collision(j, i) = 2 Then GoTo out
                        If SourceTile(j, i) = 425 Then If SgnY <> 1 Then WeaponTouch = -1: Exit Function
                        If SourceTile(j, i) = 424 Then If SgnX <> 1 Then WeaponTouch = -1: Exit Function
                        If SourceTile(j, i) = 422 Then If SgnX <> -1 Then WeaponTouch = -1: Exit Function
                        If SourceTile(j, i) = 303 Then If SgnX <> 1 Then WeaponTouch = -1: Exit Function
                        If SourceTile(j, i) = 301 Then If SgnX <> -1 Then WeaponTouch = -1: Exit Function
                        If SourceTile(j, i) = 225 Then If SgnY <> 1 Then WeaponTouch = -1: Exit Function
                        If SourceTile(j, i) = 345 Then If SgnY <> -1 Then WeaponTouch = -1: Exit Function
                        If SourceTile(j, i) = 388 Then If SgnY <> 1 Then WeaponTouch = -1: Exit Function
                        If SourceTile(j, i) = 308 Then If SgnY <> -1 Then WeaponTouch = -1: Exit Function
                        If Collision(j, i) = 4 Then If SgnY = 0 Or SgnY = -1 Then GoTo out
                        If Collision(j, i) = 5 Then If SgnY = 0 Or SgnY = 1 Then GoTo out
                        If Collision(j, i) = 6 Then If SgnX = 0 Or SgnX = -1 Then GoTo out
                        If Collision(j, i) = 7 Then If SgnX = 0 Or SgnX = 1 Then GoTo out
                        WeaponTouch = -1: Exit Function
                    ElseIf Wep = 6 Then
                        If Collision(j, i) = 0 Or Collision(j, i) = 3 Then GoTo out2
                        WeaponTouch = -6
                        Exit Function
                    End If
                End If
out2:
                If WepIndex <= UBound(UniBall) And WepIndex > -1 Then
                    If Wep = 6 And PlayerDat(UniBall(WepIndex).LastHit).Ship > 0 Then
                        
                        e = PlayerDat(UniBall(WepIndex).LastHit).Ship
                        Select Case UniBall(WepIndex).Color
                        Case 1
                            If e = 1 And Animations(j, i) = 28 Then G = 1
                            If e = 2 And Animations(j, i) = 32 Then G = 1
                            If e = 3 And Animations(j, i) = 40 Then G = 1
                            If e = 4 And Animations(j, i) = 58 Then G = 1
                        Case 2
                            If e = 2 And Animations(j, i) = 37 Then G = 1
                            If e = 1 And Animations(j, i) = 25 Then G = 1
                            If e = 3 And Animations(j, i) = 41 Then G = 1
                            If e = 4 And Animations(j, i) = 59 Then G = 1
                        Case 3
                            If e = 3 And Animations(j, i) = 46 Then G = 1
                            If e = 1 And Animations(j, i) = 26 Then G = 1
                            If e = 2 And Animations(j, i) = 34 Then G = 1
                            If e = 4 And Animations(j, i) = 60 Then G = 1
                        Case 4
                            If e = 4 And Animations(j, i) = 65 Then G = 1
                            If e = 1 And Animations(j, i) = 27 Then G = 1
                            If e = 2 And Animations(j, i) = 35 Then G = 1
                            If e = 3 And Animations(j, i) = 43 Then G = 1
                        Case 5
                            If e = 1 And Animations(j, i) = 128 Then G = 1
                            If e = 2 And Animations(j, i) = 129 Then G = 1
                            If e = 3 And Animations(j, i) = 130 Then G = 1
                            If e = 4 And Animations(j, i) = 131 Then G = 1
                        End Select
                        If G = 1 Then
                            For F = 0 To UBound(UniBall)
                                If UniBall(F).BallX = i * 16 + 3 And UniBall(F).BallY = j * 16 + 3 Then Exit Function
                            Next
                            UniBall(WepIndex).BallX = i * 16 + 3
                            UniBall(WepIndex).BallY = j * 16 + 3
                            UniBall(WepIndex).BSpeedX = 0
                            UniBall(WepIndex).BSpeedY = 0
                            i = WepIndex
                            lNewMsg = MSG_UNIBALL
                            lNewOffSet = 0
                            ReDim oNewMsg(0)
                            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
                            AddBufferData oNewMsg, VarPtr(i), LenB(i), lNewOffSet
                            b2 = UniBall(i).Color
                            AddBufferData oNewMsg, VarPtr(b2), LenB(b2), lNewOffSet
                            j = UniBall(i).BallX
                            AddBufferData oNewMsg, VarPtr(j), LenB(j), lNewOffSet
                            j = UniBall(i).BallY
                            AddBufferData oNewMsg, VarPtr(j), LenB(j), lNewOffSet
                            j = UniBall(i).BMoveX
                            AddBufferData oNewMsg, VarPtr(j), LenB(j), lNewOffSet
                            j = UniBall(i).BMoveY
                            AddBufferData oNewMsg, VarPtr(j), LenB(j), lNewOffSet
                            BS = UniBall(i).BSpeedX
                            AddBufferData oNewMsg, VarPtr(BS), LenB(BS), lNewOffSet
                            BS = UniBall(i).BSpeedY
                            AddBufferData oNewMsg, VarPtr(BS), LenB(BS), lNewOffSet
                            SendTo oNewMsg, -1, False
                            WeaponTouch = -7
                            If UniBall(WepIndex).InHole = 0 Then
                                UniBall(WepIndex).InHole = e
                                tmp = Choose(UniBall(WepIndex).Color, "green", "red", "blue", "yellow", "not-a-team's")
                                Call sendmsg(MSG_GAMECHAT, Chr(e) & PlayerDat(UniBall(WepIndex).LastHit).Nick & Chr(5) & " bravely, through much torment, shot the " & Chr(UniBall(WepIndex).Color) & tmp & Chr(5) & " ball to it's base", -1)
                            End If
                            Exit Function
                        End If
                    End If
                End If
            End If
out:
        Next
    Next
End Function

Sub LaunchUniball(Color As Byte, cx As Integer, cy As Integer)
    Dim j As Integer, LasrX As Integer, LasrY As Integer
    For j = 0 To UBound(UniBall) + 1
        If j > UBound(UniBall) Then
            ReDim Preserve UniBall(j)
        End If
        If UniBall(j).Color = 0 Then
            UniBall(j).Color = Color
            UniBall(j).InHole = Color
            UniBall(j).BallX = cx
            UniBall(j).BallY = cy
            UniBall(j).BLoopX = 0
            UniBall(j).BLoopY = 0
            UniBall(j).BMoveX = 1
            UniBall(j).BMoveY = 1
            UniBall(j).BSpeedX = 0
            UniBall(j).BSpeedY = 0
            UniBall(j).OldColor = Color
            UniBall(j).OldBallX = cx
            UniBall(j).OldBallY = cy
            Exit For
        End If
    Next
End Sub

Sub FragWin()
    Dim i As Byte, X As Integer
    Dim oNewMsg() As Byte, lNewOffSet As Long
    Dim lNewMsg As Byte
    
    For i = 1 To UBound(PlayerDat)
        If PlayerDat(i).Ship > 0 Then
            PlayerDat(i).Score = 0
            lNewMsg = MSG_PLAYERSCORE
            lNewOffSet = 0
            ReDim oNewMsg(0)
            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
            AddBufferData oNewMsg, VarPtr(i), LenB(i), lNewOffSet
            X = PlayerDat(i).Score
            AddBufferData oNewMsg, VarPtr(X), LenB(X), lNewOffSet
            SendTo oNewMsg, -1
            HoldingArea i
        End If
    Next
    lNewMsg = MSG_PLAYERHOME
    lNewOffSet = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
    AddBufferData oNewMsg, VarPtr(HighestScoreWho), LenB(HighestScoreWho), lNewOffSet
    SendTo oNewMsg, -1
    Call sendmsg(MSG_GAMECHAT, Chr(5) & PlayerDat(HighestScoreWho).Nick & " IS THE WINNER! ! !", -1)
    HighestScore = 0
    HighestScoreWho = 0
    For i = 0 To UBound(Mines)
        Mines(i).Color = 0
    Next
End Sub
Public Function DecompressData(TheData() As Byte, OrigSize As Long) As Long
    Dim Result As Long
    Dim OriginalSize As Long
    Dim CompressedSize As Long
    
    'Allocate memory for buffers
    Dim BufferSize As Long
    Dim TempBuffer() As Byte
    
    BufferSize = OrigSize
    BufferSize = BufferSize + (BufferSize * 0.01) + 12
    ReDim TempBuffer(BufferSize)
    
    'Decompress data
    Result = uncompress(TempBuffer(0), BufferSize, TheData(0), UBound(TheData) + 1)
    
    'Truncate buffer to compressed size
    ReDim Preserve TheData(BufferSize - 1)
    CopyMemory TheData(0), TempBuffer(0), BufferSize
    
    'Reset properties
    If Result = 0 Then
        CompressedSize = 0
        OriginalSize = 0
    End If
    
    'Return error code (if any)
    DecompressData = Result
    
End Function

Public Function AutoTeam(Who As Byte) As Integer
    Dim i As Integer, Team(4) As Integer, X As Integer
    'TEAMS:
    ' 1) Green
    ' 2) Red
    ' 3) Blue
    ' 4) Yellow
    ' 5) Deathmatch
    
    If g_DeathMatch > 0 Then
        AutoTeam = 5
        Exit Function
    End If
    
    For i = 1 To UBound(PlayerDat)
        X = PlayerDat(i).Ship
        'debug.print PlayerDat(i).Nick
        If X > 0 Then
            If X <> 5 And X <> 6 Then
                Team(X) = Team(X) + 1 'count number of players in each team
            End If
        End If
    Next
    
    'if there are less in team 2, and there is a team 2, send to T2.
    If Team(1) > Team(2) Then If HData.NumTeams > 1 Then GoTo T2
    'if there are less in team 3, and there is a team 3, send to T2.
    If Team(1) > Team(3) Then If HData.NumTeams > 2 Then GoTo T2
    'if there are less in team 4, and there is a team 4, send to T2.
    If Team(1) > Team(4) Then If HData.NumTeams > 3 Then GoTo T2
    AutoTeam = 1
    Exit Function
    '
T2:
    'if there are less in team 1, and there is a team 3, send to T3.
    If Team(2) > Team(1) Then If HData.NumTeams > 2 Then GoTo T3
    'if there are less in team 3, and there is a team 3, send to T3.
    If Team(2) > Team(3) Then If HData.NumTeams > 2 Then GoTo T3
    'if there are less in team 4, and there is a team 4, send to T3.
    If Team(2) > Team(4) Then If HData.NumTeams > 3 Then GoTo T3
    AutoTeam = 2
    Exit Function
    '
T3:
    If HData.NumTeams > 3 Then
        If Team(3) > Team(1) Or Team(3) > Team(2) Or Team(3) > Team(4) Then
            GoTo T4
        End If
    End If
    AutoTeam = 3
    Exit Function
    '
T4:
    If Team(4) > Team(1) Or Team(4) > Team(2) Or Team(4) > Team(3) Then
        GoTo t5
    End If
    AutoTeam = 4
    Exit Function
    '
t5:
    'all teams are full. add to team 1.
    AutoTeam = 1
End Function

Sub SendFlagDat(SndTo As Integer)
    Dim i As Integer, b As Byte, n As Integer
    Dim oNewMsg() As Byte, lNewOffSet As Long
    Dim lNewMsg As Byte
    
    For i = 1 To UBound(Flag1, 2)
        
        lNewMsg = MSG_FLAGS
        lNewOffSet = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
        b = 1
        AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
        b = i
        AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
        n = Flag1(0, i)
        AddBufferData oNewMsg, VarPtr(n), LenB(n), lNewOffSet
        n = Flag1(1, i)
        AddBufferData oNewMsg, VarPtr(n), LenB(n), lNewOffSet
        n = FlagCarry1(i)
        AddBufferData oNewMsg, VarPtr(n), LenB(n), lNewOffSet
        SendTo oNewMsg, CInt(SndTo)
    Next
    For i = 1 To UBound(Flag2, 2)
        lNewMsg = MSG_FLAGS
        lNewOffSet = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
        b = 2
        AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
        b = i
        AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
        n = Flag2(0, i)
        AddBufferData oNewMsg, VarPtr(n), LenB(n), lNewOffSet
        n = Flag2(1, i)
        AddBufferData oNewMsg, VarPtr(n), LenB(n), lNewOffSet
        n = FlagCarry2(i)
        AddBufferData oNewMsg, VarPtr(n), LenB(n), lNewOffSet
        SendTo oNewMsg, CInt(SndTo)
    Next
    For i = 1 To UBound(Flag3, 2)
        lNewMsg = MSG_FLAGS
        lNewOffSet = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
        b = 3
        AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
        b = i
        AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
        n = Flag3(0, i)
        AddBufferData oNewMsg, VarPtr(n), LenB(n), lNewOffSet
        n = Flag3(1, i)
        AddBufferData oNewMsg, VarPtr(n), LenB(n), lNewOffSet
        n = FlagCarry3(i)
        AddBufferData oNewMsg, VarPtr(n), LenB(n), lNewOffSet
        SendTo oNewMsg, CInt(SndTo)
    Next
    For i = 1 To UBound(Flag4, 2)
        lNewMsg = MSG_FLAGS
        lNewOffSet = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
        b = 4
        AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
        b = i
        AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
        n = Flag4(0, i)
        AddBufferData oNewMsg, VarPtr(n), LenB(n), lNewOffSet
        n = Flag4(1, i)
        AddBufferData oNewMsg, VarPtr(n), LenB(n), lNewOffSet
        n = FlagCarry4(i)
        AddBufferData oNewMsg, VarPtr(n), LenB(n), lNewOffSet
        SendTo oNewMsg, CInt(SndTo)
    Next
    For i = 1 To UBound(Flag5, 2)
        lNewMsg = MSG_FLAGS
        lNewOffSet = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
        b = 5
        AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
        b = i
        AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
        n = Flag5(0, i)
        AddBufferData oNewMsg, VarPtr(n), LenB(n), lNewOffSet
        n = Flag5(1, i)
        AddBufferData oNewMsg, VarPtr(n), LenB(n), lNewOffSet
        n = FlagCarry5(i)
        AddBufferData oNewMsg, VarPtr(n), LenB(n), lNewOffSet
        SendTo oNewMsg, CInt(SndTo)
    Next
    
End Sub
Sub SendSwitchDat(SndTo As Integer, Priorty As Boolean)
    Dim i As Integer, b As Byte, n As Integer
    Dim oNewMsg() As Byte, lNewOffSet As Long
    Dim lNewMsg As Byte
    For i = 1 To UBound(Switches, 2)
        If Switched(i) > 0 Or Priorty Then
            lNewMsg = MSG_SWITCH
            lNewOffSet = 0
            ReDim oNewMsg(0)
            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
            b = 0
            AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
            AddBufferData oNewMsg, VarPtr(i), LenB(i), lNewOffSet
            n = Switched(i)
            AddBufferData oNewMsg, VarPtr(n), LenB(n), lNewOffSet
            SendTo oNewMsg, CInt(SndTo)
        End If
    Next
End Sub

Public Function GetPN2(sName As String) As Byte
    Dim i As Byte
    For i = 1 To UBound(PlayerDat)
        If PlayerDat(i).Ship > 0 Then
            If LCase(PlayerDat(i).Nick) = LCase(sName) Then GetPN2 = i: Exit Function
        End If
    Next
End Function

Public Sub LoadMap(Optional LoadAll As Boolean = True)
    'On Error GoTo Errout
    Dim i As Integer, j As Integer, temp As String, C As Integer, d As Integer, R As Long, CountD As Long
    Dim Clsion() As Byte, Anims() As Byte, xt As Integer, yt As Integer, AnimsOffset() As Byte
    Dim MBytes() As Byte, SrcTile(131072) As Integer, TileVal(4255) As Byte
    ReDim hFlagPoleBases1(0), hFlagPoleBases2(0), hFlagPoleBases3(0), hFlagPoleBases4(0)
    ReDim Warp(9, 1, 0)
    ReDim WarpOut(9, 0)
    ReDim PowerVal(0), PowerX(0), PowerY(0), PowerTick(0), PowerEffect(0), PowerLife(0)
    ReDim SourceX(255, 255), SourceY(255, 255), Collision(255, 255), Animations(255, 255), AnimOffset(255, 255)
    ReDim FlagBase1(1, 0), FlagBase2(1, 0), FlagBase3(1, 0), FlagBase4(1, 0), FlagBase5(1, 0), Switches(1, 0)
    ReDim Hold1(1, 0), Hold2(1, 0), Hold3(1, 0), Hold4(1, 0), Spawn1(1, 0), Spawn2(1, 0), Spawn3(1, 0), Spawn4(1, 0)
    FileLenB = FileLen(Filename) - 1
    If FileLenB = -1 Then Exit Sub
    ReDim SMData(FileLenB)
    Open Filename For Binary As #1
    Get #1, , SMData
    Close #1
    Open Filename For Binary As #1
    Get #1, , HData
    If HData.FormatID <> 17016 Then
        Close #1
        Exit Sub
    End If
    ReDim hFlagCounts(HData.NumTeams - 1)
    ReDim hFlagPoleCounts(HData.NumTeams - 1)
    Get #1, , hFlagCounts()
    Get #1, , hFlagPoleCounts()
    For i = 0 To HData.NumTeams - 1
        If i = 0 Then
            If hFlagPoleCounts(i) > 0 Then
                ReDim hFlagPoleBases1(hFlagPoleCounts(i) - 1)
                Get #1, , hFlagPoleBases1()
            End If
        ElseIf i = 1 Then
            If hFlagPoleCounts(i) > 0 Then
                ReDim hFlagPoleBases2(hFlagPoleCounts(i) - 1)
                Get #1, , hFlagPoleBases2()
            End If
        ElseIf i = 2 Then
            If hFlagPoleCounts(i) > 0 Then
                ReDim hFlagPoleBases3(hFlagPoleCounts(i) - 1)
                Get #1, , hFlagPoleBases3()
            End If
        ElseIf i = 3 Then
            If hFlagPoleCounts(i) > 0 Then
                ReDim hFlagPoleBases4(hFlagPoleCounts(i) - 1)
                Get #1, , hFlagPoleBases4()
            End If
        End If
    Next
    Get #1, , HDataNames
    ReDim MBytes(131072) As Byte
    Get #1, Loc(1) + 2, MBytes()
    Close #1
    If Not LoadAll Then Exit Sub
    '
    Open AppPath & "attribs.dat" For Binary As #1
    Get #1, , i
    Get #1, , TileVal()
    Close #1
    Open AppPath & "rough.dat" For Binary As #1
    Get #1, , RoughTile()
    Close #1
    '
    i = 255
    j = 255
    DoEvents
    R = DecompressData(MBytes(), 131072)
    If R <> 0 Then GoTo ErrOut
    CopyMemory SrcTile(0), MBytes(0), 131072
    For C = 0 To i
        For d = 0 To j
            xt = (SrcTile(CountD) Mod 40) * 16
            yt = (SrcTile(CountD) - (SrcTile(CountD) Mod 40)) / 40 * 16
            SourceX(C, d) = xt
            SourceY(C, d) = yt
            If SrcTile(CountD) > -1 And SrcTile(CountD) <= UBound(TileVal) Then Collision(C, d) = TileVal(SrcTile(CountD))
            SourceTile(C, d) = SrcTile(CountD)
            Animations(C, d) = -1
            If MBytes(CountD * 2 + 1) > 127 Then
                Animations(C, d) = MBytes(CountD * 2)
                Collision(C, d) = TileVal(4000 + Animations(C, d))
                If Animations(C, d) = 158 Or (Animations(C, d) > 200 And Animations(C, d) < 256) Then AnimOffset(C, d) = MBytes(CountD * 2 + 1) - 128
                SourceX(C, d) = 352
                SourceY(C, d) = 0
            End If
            
            If SourceX(C, d) = 0 And SourceY(C, d) = 112 Then
                SourceX(C, d) = -1
                If Animations(C, d) = -1 Then
                    Collision(C, d) = 2: Animations(C, d) = -2
                End If
            End If
            
            CountD = CountD + 1
            If Animations(C, d) = 210 Then
                If AnimOffset(C, d) > UBound(WayPoints) Then ReDim Preserve WayPoints(AnimOffset(C, d))
                WayPoints(AnimOffset(C, d)).X = d * 16
                WayPoints(AnimOffset(C, d)).y = C * 16
            End If
            If Animations(C, d) = 28 Then
                If g_UniBall = 0 Then
                    ReDim Preserve FlagBase1(1, UBound(FlagBase1, 2) + 1)
                    FlagBase1(0, UBound(FlagBase1, 2)) = d * 16
                    FlagBase1(1, UBound(FlagBase1, 2)) = C * 16
                    FlagGame(1) = True
                End If
                If g_UniBall > 0 Then LaunchUniball 1, d * 16 + 3, C * 16 + 3
            ElseIf Animations(C, d) = 37 Then
                If g_UniBall = 0 Then
                    ReDim Preserve FlagBase2(1, UBound(FlagBase2, 2) + 1)
                    FlagBase2(0, UBound(FlagBase2, 2)) = d * 16
                    FlagBase2(1, UBound(FlagBase2, 2)) = C * 16
                    FlagGame(2) = True
                End If
                If g_UniBall > 0 Then LaunchUniball 2, d * 16 + 3, C * 16 + 3
            ElseIf Animations(C, d) = 46 Then
                If g_UniBall = 0 Then
                    ReDim Preserve FlagBase3(1, UBound(FlagBase3, 2) + 1)
                    FlagBase3(0, UBound(FlagBase3, 2)) = d * 16
                    FlagBase3(1, UBound(FlagBase3, 2)) = C * 16
                    FlagGame(3) = True
                End If
                If g_UniBall > 0 Then LaunchUniball 3, d * 16 + 3, C * 16 + 3
            ElseIf Animations(C, d) = 65 Then
                If g_UniBall = 0 Then
                    ReDim Preserve FlagBase4(1, UBound(FlagBase4, 2) + 1)
                    FlagBase4(0, UBound(FlagBase4, 2)) = d * 16
                    FlagBase4(1, UBound(FlagBase4, 2)) = C * 16
                    FlagGame(4) = True
                End If
                If g_UniBall > 0 Then LaunchUniball 4, d * 16 + 3, C * 16 + 3
            ElseIf Animations(C, d) = 140 Then
                If g_UniBall = 0 Then
                    ReDim Preserve FlagBase5(1, UBound(FlagBase5, 2) + 1)
                    FlagBase5(0, UBound(FlagBase5, 2)) = d * 16
                    FlagBase5(1, UBound(FlagBase5, 2)) = C * 16
                    FlagGame(5) = True
                End If
                If g_UniBall > 0 Then LaunchUniball 5, d * 16 + 3, C * 16 + 3
            ElseIf Animations(C, d) = 158 Or (Animations(C, d) > 243 And Animations(C, d) < 251) Then
                xt = (AnimOffset(C, d) - AnimOffset(C, d) Mod 10) / 10
                yt = AnimOffset(C, d) Mod 10
                ReDim Preserve Warp(9, 1, UBound(Warp, 3) + 1), WarpOut(9, UBound(WarpOut) + 1)
                Warp(yt, 0, UBound(Warp, 3)) = d * 16
                Warp(yt, 1, UBound(Warp, 3)) = C * 16
                WarpOut(yt, UBound(WarpOut, 2)) = xt
            ElseIf Animations(C, d) = 141 Or SourceTile(C, d) = 146 Then
                ReDim Preserve Hold1(1, UBound(Hold1, 2) + 1)
                Hold1(0, UBound(Hold1, 2)) = d * 16
                Hold1(1, UBound(Hold1, 2)) = C * 16
            ElseIf Animations(C, d) = 142 Or SourceTile(C, d) = 186 Then
                ReDim Preserve Hold2(1, UBound(Hold2, 2) + 1)
                Hold2(0, UBound(Hold2, 2)) = d * 16
                Hold2(1, UBound(Hold2, 2)) = C * 16
            ElseIf Animations(C, d) = 143 Or SourceTile(C, d) = 276 Then
                ReDim Preserve Hold3(1, UBound(Hold3, 2) + 1)
                Hold3(0, UBound(Hold3, 2)) = d * 16
                Hold3(1, UBound(Hold3, 2)) = C * 16
            ElseIf Animations(C, d) = 144 Or SourceTile(C, d) = 316 Then
                ReDim Preserve Hold4(1, UBound(Hold4, 2) + 1)
                Hold4(0, UBound(Hold4, 2)) = d * 16
                Hold4(1, UBound(Hold4, 2)) = C * 16
            ElseIf Animations(C, d) = 163 Or SourceTile(C, d) = 147 Or SourceTile(C, d) = 63 Then
                ReDim Preserve Spawn1(1, UBound(Spawn1, 2) + 1)
                Spawn1(0, UBound(Spawn1, 2)) = d * 16
                Spawn1(1, UBound(Spawn1, 2)) = C * 16
            ElseIf Animations(C, d) = 164 Or SourceTile(C, d) = 187 Or SourceTile(C, d) = 103 Then
                ReDim Preserve Spawn2(1, UBound(Spawn2, 2) + 1)
                Spawn2(0, UBound(Spawn2, 2)) = d * 16
                Spawn2(1, UBound(Spawn2, 2)) = C * 16
            ElseIf Animations(C, d) = 165 Or SourceTile(C, d) = 277 Or SourceTile(C, d) = 192 Then
                ReDim Preserve Spawn3(1, UBound(Spawn3, 2) + 1)
                Spawn3(0, UBound(Spawn3, 2)) = d * 16
                Spawn3(1, UBound(Spawn3, 2)) = C * 16
            ElseIf Animations(C, d) = 166 Or SourceTile(C, d) = 317 Or SourceTile(C, d) = 233 Then
                ReDim Preserve Spawn4(1, UBound(Spawn4, 2) + 1)
                Spawn4(0, UBound(Spawn4, 2)) = d * 16
                Spawn4(1, UBound(Spawn4, 2)) = C * 16
            ElseIf Animations(C, d) = 123 Then
                ReDim Preserve Switches(1, UBound(Switches, 2) + 1)
                Switches(0, UBound(Switches, 2)) = d * 16
                Switches(1, UBound(Switches, 2)) = C * 16
            ElseIf SourceTile(C, d) = 36 Or SourceTile(C, d) = 38 Or SourceTile(C, d) = 76 Or SourceTile(C, d) = 77 Then
                If g_PowerUps = 1 Then
                    i = UBound(PowerVal) + 1
                    ReDim Preserve PowerVal(i), PowerX(i), PowerY(i), PowerTick(i), PowerEffect(i), PowerLife(i)
                    PowerVal(i) = 5
                    PowerX(i) = d * 16
                    PowerY(i) = C * 16
                    PowerLife(i) = 0
                End If
            End If
skip:
        Next
    Next
    ReDim Flag1(1, UBound(FlagBase1, 2)), Flag2(1, UBound(FlagBase2, 2)), Flag3(1, UBound(FlagBase3, 2)), Flag4(1, UBound(FlagBase4, 2)), Flag5(1, UBound(FlagBase5, 2))
    ReDim SourceX(0, 0), SourceY(0, 0), MData(0)
    Exit Sub
ErrOut:
    MapPlay = ""
End Sub

Public Sub PlayerNull(X As Byte)
    Dim d As Integer, b As Byte
    Dim oNewMsg() As Byte, lNewOffSet As Long
    Dim lNewMsg As Byte
    If PlayerDat(X).playing Then GameNull X
    frmServer.txtLog.SelStart = Len(frmServer.txtLog.Text)
    frmServer.txtLog.SelText = vbNewLine & PlayerDat(X).Nick & " disconnected."
    If PlayerDat(X).playing Then
        lNewMsg = MSG_REMOVEPLAYER
        lNewOffSet = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
        AddBufferData oNewMsg, VarPtr(X), LenB(X), lNewOffSet
        SendTo oNewMsg, -1
    End If
    PlayerDat(X).activity = 0
    PlayerDat(X).Mode = 0
    PlayerDat(X).Ship = 0
    PlayerDat(X).Admin = 0
    PlayerDat(X).bPNT = 0
    PlayerDat(X).Caps = 0
    PlayerDat(X).cBomb = 0
    PlayerDat(X).cBouncy = 0
    PlayerDat(X).CharX = 0
    PlayerDat(X).CharY = 0
    PlayerDat(X).cMines = 0
    PlayerDat(X).DevCheat = 0
    PlayerDat(X).cMissile = 0
    PlayerDat(X).Deaths = 0
    PlayerDat(X).die = False
    PlayerDat(X).disablepm = False
    PlayerDat(X).Duration = 0
    PlayerDat(X).Flag = 0
    PlayerDat(X).FlagArray = 0
    PlayerDat(X).Flagging = False
    PlayerDat(X).Frags = 0
    PlayerDat(X).gagged = False
    PlayerDat(X).Icon = 0
    PlayerDat(X).icon2 = 0
    PlayerDat(X).ID = 0
    PlayerDat(X).inpen = 0
    PlayerDat(X).inpenTrig = 0
    PlayerDat(X).Key = 0
    PlayerDat(X).KeyPacketHandle = 0
    PlayerDat(X).Login = False
    PlayerDat(X).LoginCount = 0
    PlayerDat(X).LoginWait = 0
    PlayerDat(X).Nick = vbNullString
    PlayerDat(X).Ping = 0
    PlayerDat(X).PingTick = 0
    PlayerDat(X).playing = False
    PlayerDat(X).pong = 0
    PlayerDat(X).Score = 0
    PlayerDat(X).SendMap = False
    PlayerDat(X).serial = 0
    PlayerDat(X).Ship = 0
    PlayerDat(X).smoking = False
    PlayerDat(X).SyncSet = 0
    PlayerDat(X).COBALTID = 0
    PlayerDat(X).UDPOK = True
    PlayerDat(X).WarpDone = 0
    PlayerDat(X).Warped = 0
    PlayerDat(X).Warping = False
    PlayerDat(X).WarpX = 0
    PlayerDat(X).WarpY = 0
    PlayerDat(X).wBomb = 0
    PlayerDat(X).wBouncy = 0
    PlayerDat(X).wEnergy = 0
    PlayerDat(X).WepSyncT = 0
    PlayerDat(X).wMissile = 0
    PlayerDat(X).WayPoint = 0
    PlayerDat(X).Direction = 0
End Sub

Function fPlayerCount() As Integer
    On Error GoTo errors
    Dim i As Long
    Dim C As Integer
    For i = 0 To frmServer.Socket1.ubound
        If frmServer.Socket1(i).State = 7 Then C = C + 1
    Next
    If C = 0 And NotReset Then
        NewGame
        NotReset = False
    End If
    fPlayerCount = C
    Exit Function
errors:
    fPlayerCount = 0
End Function

Sub GameNull(X As Byte)
    Dim d As Integer
    Dim oNewMsg() As Byte, lNewOffSet As Long
    Dim lNewMsg As Byte
    d = PlayerDat(X).Flag
    If d > 0 Then DropFlag CInt(X)
    lNewMsg = MSG_NULLPLAYER
    lNewOffSet = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
    AddBufferData oNewMsg, VarPtr(X), LenB(X), lNewOffSet
    SendTo oNewMsg, -1
    Call sendmsg(MSG_GAMECHAT, Chr(PlayerDat(X).Ship) & PlayerDat(X).Nick & Chr(5) & " has left the game.", -1)
    PlayerDat(X).Ship = 0
End Sub

Public Sub Clean()
    frmServer.txtLog.SelStart = Len(frmServer.txtLog)
    frmServer.txtLog.SelText = vbNewLine & "Closing server..."
End Sub

Sub DropFlag(j As Byte)
    Dim i As Integer, e As Integer, b As Byte, I2 As Integer, ChatTxt1 As String
    Dim oNewMsg() As Byte, lNewOffSet As Long
    Dim lNewMsg As Byte
    i = PlayerDat(j).Flag
    If i = 0 Then Exit Sub
    e = PlayerDat(j).FlagArray
    ChatTxt1 = Choose(i, "green", "red", "blue", "yellow", "not-a-team's")
    Call sendmsg(MSG_GAMECHAT, Chr(PlayerDat(j).Ship) & PlayerDat(j).Nick & Chr(5) & " dropped the " & Chr(i) & ChatTxt1 & Chr(5) & " flag", -1)
    lNewMsg = MSG_DROPFLAG
    lNewOffSet = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
    b = 1
    AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
    b = j
    AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
    b = i
    AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
    b = e
    AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
    If i = 1 Then
        Flag1(0, e) = PlayerDat(j).CharX
        Flag1(1, e) = PlayerDat(j).CharY
        FlagLast1(e) = PlayerDat(FlagCarry1(e)).Ship
        FlagCarry1(e) = 0
        FlagReady1(e) = NewGTC
        I2 = Flag1(0, e)
        AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
        I2 = Flag1(1, e)
        AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
    ElseIf i = 2 Then
        Flag2(0, e) = PlayerDat(j).CharX
        Flag2(1, e) = PlayerDat(j).CharY
        FlagLast2(e) = PlayerDat(FlagCarry2(e)).Ship
        FlagCarry2(e) = 0
        FlagReady2(e) = NewGTC
        I2 = Flag2(0, e)
        AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
        I2 = Flag2(1, e)
        AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
    ElseIf i = 3 Then
        Flag3(0, e) = PlayerDat(j).CharX
        Flag3(1, e) = PlayerDat(j).CharY
        FlagLast3(e) = PlayerDat(FlagCarry3(e)).Ship
        FlagCarry3(e) = 0
        FlagReady3(e) = NewGTC
        I2 = Flag3(0, e)
        AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
        I2 = Flag3(1, e)
        AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
    ElseIf i = 4 Then
        Flag4(0, e) = PlayerDat(j).CharX
        Flag4(1, e) = PlayerDat(j).CharY
        FlagLast4(e) = PlayerDat(FlagCarry4(e)).Ship
        FlagCarry4(e) = 0
        FlagReady4(e) = NewGTC
        I2 = Flag4(0, e)
        AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
        I2 = Flag4(1, e)
        AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
    ElseIf i = 5 Then
        Flag5(0, e) = PlayerDat(j).CharX
        Flag5(1, e) = PlayerDat(j).CharY
        FlagLast5(e) = PlayerDat(FlagCarry5(e)).Ship
        FlagCarry5(e) = 0
        FlagReady5(e) = NewGTC
        I2 = Flag5(0, e)
        AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
        I2 = Flag5(1, e)
        AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
    End If
    PlayerDat(j).Flag = 0
    PlayerDat(j).FlagArray = 0
    SendTo oNewMsg, -1
End Sub

Public Function EncodePassword(sOldStr As String, ByVal lEncryptKey) As String
    Dim lCount As Long, sNew As String
    
    For lCount = 1 To Len(sOldStr)
        sNew = sNew & Chr$(Asc(Mid$(sOldStr, lCount, 1)) Xor lEncryptKey)
    Next
    EncodePassword = sNew
End Function

Public Sub sendmsg(cmd As Long, msg As String, SndTo As Integer)
    Dim oNewMsg() As Byte, lNewOffSet As Long
    Dim lNewMsg As Byte
    lNewMsg = cmd
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
    AddBufferString oNewMsg, msg, lNewOffSet
    SendTo oNewMsg, SndTo
End Sub

Public Sub sendmsgforce(cmd As Long, msg As String, SndTo As Integer, KillConnection As Boolean)
    Dim oNewMsg() As Byte, lNewOffSet As Long
    Dim lNewMsg As Byte
    lNewMsg = cmd
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
    AddBufferString oNewMsg, msg, lNewOffSet
    SendTo oNewMsg, SndTo
End Sub

Public Function SendTo(Buff() As Byte, pID As Integer, Optional Guaranteed As Boolean = True) As Integer
    Dim i As Long, b As Byte
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
    
    'If bDebugLog = 1 Then DebugLog Buff(0) & " " & NewGTC & " OUT..."
    If Guaranteed Then
        For i = 1 To frmServer.Socket1.ubound
            If frmServer.Socket1(i).State = 7 And i <= UBound(PlayerDat) Then
                If PlayerDat(i).Ship > 0 Then
                    If (pID = -2 And PlayerDat(i).playing) Or pID = -1 Or pID = i Then
                        'If bDebugLog = 1 Then DebugLog Buff(0) & " " & NewGTC & " OUT TCP :) (sent to " & frmServer.Socket1(i).RemoteHostIP & ")"
                        frmServer.Socket1(i).SendData SendBuffer
                    End If
                End If
            ElseIf frmServer.Socket1(i).State = 7 And Buff(0) = MSG_ERROR Then
                If pID = i Then
                    'If bDebugLog = 1 Then DebugLog Buff(0) & " " & NewGTC & " OUT TCP :) (sent to " & frmServer.Socket1(i).RemoteHostIP & ")"
                    frmServer.Socket1(i).SendData SendBuffer
                End If
            End If
        Next
    Else
        If Not LANBuild Or PeerBuild Or LenB(BroadcastIP) = 0 Or (pID <> -1 And pID <> -2) Then
            For i = 1 To frmServer.Socket1.ubound
                If frmServer.Socket1(i).State = 7 And i <= UBound(PlayerDat) Then
                    If PlayerDat(i).Ship > 0 Then
                        If (pID = -2 And PlayerDat(i).playing) Or pID = -1 Or pID = i Then
                            If PlayerDat(i).UDPOK Then
                                'If bDebugLog = 1 Then DebugLog Buff(0) & " " & NewGTC & " OUT UDP :) (sent to " & frmServer.Socket1(i).RemoteHostIP & ")"
                                frmServer.UDPArray(i).WriteBytes SendBuffer, UBound(SendBuffer) + 1
                            Else
                                'If bDebugLog = 1 Then DebugLog Buff(0) & " " & NewGTC & " OUT TCP :) (sent to " & frmServer.Socket1(i).RemoteHostIP & ")"
                                frmServer.Socket1(i).SendData SendBuffer
                            End If
                        End If
                    End If
                End If
            Next
        Else
            'If bDebugLog = 1 Then DebugLog Buff(0) & " " & NewGTC & " OUT UDP BROADCAST :)"
            frmServer.UDPBroadcast.WriteBytes SendBuffer, UBound(SendBuffer) + 1
        End If
    End If
    DoEvents
End Function

Public Sub SendTo2(Buff() As Byte, pID As Integer)
    Dim b As Byte
    ReDim Preserve Buff(UBound(Buff) + 1)
    b = 3
    CopyMemory Buff(UBound(Buff)), b, 1
    If frmRegister.Socket1.State = 7 Then
        frmRegister.Socket1.SendData Buff
    Else
        frmRegister.Socket1.Close
        frmRegister.RegisterAgain "Connection lost."
    End If
End Sub

Public Sub SendData()
    Dim oNewMsg() As Byte, lNewOffSet As Long
    Dim lNewMsg As Byte, i As Byte, cx As Integer, cy As Integer, X As Byte, Key As Byte, b As Byte
    Dim L As Long, L2 As Long, t1 As Integer, T2 As Integer, b2 As Byte, b3 As Byte
    lNewMsg = MSG_GAMEDATA
    lNewOffSet = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
    For i = 1 To UBound(PlayerDat)
        If PlayerDat(i).playing Then b = b + 1
    Next
    AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
    For i = 1 To UBound(PlayerDat)
        If PlayerDat(i).playing Then
            Key = PlayerDat(i).Key
            cx = PlayerDat(i).CharX
            cy = PlayerDat(i).CharY
            AddBufferData oNewMsg, VarPtr(i), LenB(i), lNewOffSet
            AddBufferData oNewMsg, VarPtr(Key), LenB(Key), lNewOffSet
            AddBufferData oNewMsg, VarPtr(cx), LenB(cx), lNewOffSet
            AddBufferData oNewMsg, VarPtr(cy), LenB(cy), lNewOffSet
        End If
    Next
    'For I = 1 To UBound(PlayerDat)
    '    If PlayerDat(I).playing Then SendTo oNewMsg, CInt(I), False
    'Next
    SendTo oNewMsg, -2, False
End Sub

Public Sub Kick(Plyr As String, Reason As String)
    Dim i As Integer, L As Long, tmp As String
    Dim oNewMsg() As Byte, lNewOffSet As Long
    Dim lNewMsg As Byte
    If LenB(Plyr) = 0 Then Exit Sub
    For i = 1 To UBound(PlayerDat)
        If LCase(PlayerDat(i).Nick) = LCase(Plyr) Then
            If i <= frmServer.Socket1.ubound Then
                lNewMsg = MSG_ERROR
                lNewOffSet = 0
                ReDim oNewMsg(0)
                AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
                tmp = Reason
                AddBufferString oNewMsg, tmp, lNewOffSet
                SendTo oNewMsg, i, True
                DoEvents
                frmServer.Socket1(i).Close
            End If
            If i <= UBound(PlayerDat) Then PlayerDat(i).die = True
        End If
    Next
End Sub

Public Sub LoadBot(FromPlayerName As String, Team As Byte)
    Dim pID As Byte, b As Byte
    Dim lMsg As Byte, lOffset As Long
    Dim oNewMsg() As Byte, lNewOffSet As Long
    Dim lNewMsg As Byte
    
    For pID = g_MaxPlayers + 1 To 200
        If pID > UBound(PlayerDat) Then ReDim Preserve PlayerDat(pID)
        If PlayerDat(pID).Ship = 0 Then
            If Team = 0 Then Team = AutoTeam(pID)
            PlayerDat(pID).Ship = Team
            PlayerDat(pID).ID = 4
            PlayerDat(pID).Nick = FromPlayerName
            PlayerDat(pID).activity = NewGTC
            PlayerDat(pID).UDPOK = True
            PlayerDat(pID).Login = True
            PlayerDat(pID).die = False
            PlayerDat(pID).playing = True
            PlayerDat(pID).Key = 9
            PlayerDat(pID).AI = True
            Exit For
        End If
    Next
    HoldingArea pID
    
    lNewMsg = MSG_PLAYERS
    lNewOffSet = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
    b = pID
    AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
    AddBufferString oNewMsg, FromPlayerName, lNewOffSet
    b = PlayerDat(pID).Ship
    AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
    i = PlayerDat(pID).Score
    AddBufferData oNewMsg, VarPtr(i), LenB(i), lNewOffSet
    b = PlayerDat(pID).Admin
    AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
    SendTo oNewMsg, -1
    
    If ConnectionOK Then
        lNewMsg = SVR_JOINED
        lNewOffSet = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
        AddBufferData oNewMsg, VarPtr(pID), LenB(pID), lNewOffSet
        AddBufferString oNewMsg, FromPlayerName, lNewOffSet
        SendTo2 oNewMsg, 0
    End If
    
    frmServer.txtLog.SelStart = Len(frmServer.txtLog)
    frmServer.txtLog.SelText = vbNewLine & FromPlayerName & " bot loaded."
End Sub

Function AppPath() As String
    Dim X As String
    If DevEnv Then
        X = App.Path & "\..\current\"
        AppPath = X
    Else
        X = App.Path
        If right$(X, 1) <> "\" Then X = X + "\"
        AppPath = X
    End If
End Function

Public Function DevEnv() As Boolean
    On Error GoTo teherrors
    Debug.Print 1 / 0
    DevEnv = False
    Exit Function
teherrors:
    DevEnv = True
End Function

Public Sub Pause(seconds As Long)
    Dim X As Long
    X = NewGTC
    Do Until NewGTC - X > seconds
        DoEvents
    Loop
End Sub

Public Sub writeini(Parent, child, context, file)
    file = Replace(file, """", "")
    Dim lpAppName As String, lpFileName As String, lpKeyName As String, lpString As String
    Dim U As Long
    lpAppName = Parent
    lpKeyName = child
    lpString = context
    lpFileName = file
    U = WritePrivateProfileString(lpAppName, lpKeyName, lpString, lpFileName)
    If U = 0 Then
        MsgBox "could not save settings.", vbCritical, "Error"
    End If
End Sub

Public Function readini(Parent, child, file) As String
    file = Replace(file, """", "")
    Dim X As Long, ReturnString As String, i As Integer, j As Integer, sfile As String
    Dim temp As String * 255
    Dim lpAppName As String, lpKeyName As String, lpDefault As String, lpFileName As String
    lpAppName = Parent
    lpKeyName = child
    lpDefault = file
    lpFileName = file
    X = GetPrivateProfileString(lpAppName, lpKeyName, lpDefault, temp, Len(temp), lpFileName)
    For i = 1 To Len(temp)
        If Asc(Mid$(temp, i, 1)) <> 0 Then
            ReturnString = ReturnString & Mid$(temp, i, 1)
        Else
            Exit For
        End If
    Next
    For i = 1 To Len(file)
        If Asc(Mid$(file, i, 1)) <> 0 Then
            sfile = sfile & Mid$(file, i, 1)
        Else
            Exit For
        End If
    Next
    If X <> 0 And ReturnString <> sfile Then
        readini = ReturnString
    Else
        readini = vbNullString
    End If
End Function
Public Sub CheckSwitches(Who As Byte, WhoX As Integer, WhoY As Integer)
    If NewGTC - SWEnable < 5000 Then Exit Sub
    If PlayerDat(Who).inpen > 0 Then Exit Sub
    Dim i As Integer, j As Integer, e As Integer, F As Integer, b As Byte
    Dim rTemp As RECT, rWho As RECT, rBlock As RECT, tmp As String
    Dim oNewMsg() As Byte, lNewOffSet As Long
    Dim lNewMsg As Byte
    rWho.top = WhoY + 1
    rWho.left = WhoX + 1
    rWho.bottom = rWho.top + 30
    rWho.right = rWho.left + 30
    For e = 1 To UBound(Switches, 2)
        rBlock.top = Switches(1, e)
        rBlock.left = Switches(0, e)
        rBlock.bottom = rBlock.top + 16
        rBlock.right = rBlock.left + 16
        If IntersectRect(rTemp, rWho, rBlock) Then Exit For
    Next
    If e = 0 Or e > UBound(Switches, 2) Then Exit Sub
    If NewGTC - SwitchIdle(e) < 500 Then Exit Sub
    If Switched(e) <> PlayerDat(Who).Ship Then  'MARK501
        SwitchIdle(e) = NewGTC
        Switched(e) = PlayerDat(Who).Ship: SwitchWON = 5
        Call sendmsg(MSG_GAMECHAT, Chr(PlayerDat(Who).Ship) & PlayerDat(Who).Nick & Chr(5) & " flipped switch.", -1)
        lNewMsg = MSG_SWITCH
        lNewOffSet = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
        b = 1
        AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
        AddBufferData oNewMsg, VarPtr(e), LenB(e), lNewOffSet
        i = PlayerDat(Who).Ship
        AddBufferData oNewMsg, VarPtr(i), LenB(i), lNewOffSet
        SendTo oNewMsg, -1
    End If
    '
    For e = 1 To UBound(Switches, 2)
        If Switched(e) <> PlayerDat(Who).Ship Then Exit Sub
    Next
    SwitchWON = PlayerDat(Who).Ship
    CheckWIN Who
End Sub
Function FindRectsRet(searchret As Integer) As Boolean
    Dim i As Integer
    For i = 1 To UBound(RectsRet)
        If RectsRet(i) = searchret Then FindRectsRet = True: Exit Function
    Next
End Function

Function ShipRects(Who As Byte, by As Integer, bx As Integer) As Boolean
    Dim i As Integer, rWho As RECT, rBlock As RECT, rTemp As RECT
    If SourceTile(by, bx) > -1 Then
        rBlock.left = bx * 16 + RoughTile(SourceTile(by, bx)).hLeft
        rBlock.right = rBlock.left + 16 - RoughTile(SourceTile(by, bx)).hLeft - RoughTile(SourceTile(by, bx)).hRight
        rBlock.top = by * 16 + RoughTile(SourceTile(by, bx)).hTop
        rBlock.bottom = rBlock.top + 16 - RoughTile(SourceTile(by, bx)).hTop - RoughTile(SourceTile(by, bx)).hBottom
    Else
        rBlock.left = bx * 16
        rBlock.right = rBlock.left + 16
        rBlock.top = by * 16
        rBlock.bottom = rBlock.top + 16
    End If
    '1
    With rWho
        .left = PlayerDat(Who).CharX + 12
        .right = .left + 4
        .top = PlayerDat(Who).CharY + 1
        .bottom = .top + 3
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then ReDim Preserve RectsRet(UBound(RectsRet) + 1): RectsRet(UBound(RectsRet)) = 101: ShipRects = True
    '2
    With rWho
        .left = PlayerDat(Who).CharX + 8
        .right = .left + 8
        .top = PlayerDat(Who).CharY + 4
        .bottom = .top + 4
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then ReDim Preserve RectsRet(UBound(RectsRet) + 1): RectsRet(UBound(RectsRet)) = 102: ShipRects = True
    '3
    With rWho
        .left = PlayerDat(Who).CharX + 4
        .right = .left + 12
        .top = PlayerDat(Who).CharY + 8
        .bottom = .top + 4
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then ReDim Preserve RectsRet(UBound(RectsRet) + 1): RectsRet(UBound(RectsRet)) = 103: ShipRects = True
    '
    '4
    With rWho
        .left = PlayerDat(Who).CharX + 1
        .right = .left + 15
        .top = PlayerDat(Who).CharY + 12
        .bottom = .top + 4
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then ReDim Preserve RectsRet(UBound(RectsRet) + 1): RectsRet(UBound(RectsRet)) = 104: ShipRects = True
    '5
    With rWho
        .left = PlayerDat(Who).CharX + 1
        .right = .left + 15
        .top = PlayerDat(Who).CharY + 16
        .bottom = .top + 4
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then ReDim Preserve RectsRet(UBound(RectsRet) + 1): RectsRet(UBound(RectsRet)) = 105: ShipRects = True
    '
    '6
    With rWho
        .left = PlayerDat(Who).CharX + 4
        .right = .left + 12
        .top = PlayerDat(Who).CharY + 20
        .bottom = .top + 4
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then ReDim Preserve RectsRet(UBound(RectsRet) + 1): RectsRet(UBound(RectsRet)) = 106: ShipRects = True
    '7
    With rWho
        .left = PlayerDat(Who).CharX + 8
        .right = .left + 8
        .top = PlayerDat(Who).CharY + 24
        .bottom = .top + 4
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then ReDim Preserve RectsRet(UBound(RectsRet) + 1): RectsRet(UBound(RectsRet)) = 107: ShipRects = True
    '8
    With rWho
        .left = PlayerDat(Who).CharX + 12
        .right = .left + 4
        .top = PlayerDat(Who).CharY + 28
        .bottom = .top + 3
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then ReDim Preserve RectsRet(UBound(RectsRet) + 1): RectsRet(UBound(RectsRet)) = 108: ShipRects = True
    '
    '
    '
    '9
    With rWho
        .left = PlayerDat(Who).CharX + 16
        .right = .left + 4
        .top = PlayerDat(Who).CharY + 1
        .bottom = .top + 3
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then ReDim Preserve RectsRet(UBound(RectsRet) + 1): RectsRet(UBound(RectsRet)) = 109: ShipRects = True
    '10
    With rWho
        .left = PlayerDat(Who).CharX + 16
        .right = .left + 8
        .top = PlayerDat(Who).CharY + 4
        .bottom = .top + 4
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then ReDim Preserve RectsRet(UBound(RectsRet) + 1): RectsRet(UBound(RectsRet)) = 110: ShipRects = True
    '11
    With rWho
        .left = PlayerDat(Who).CharX + 16
        .right = .left + 12
        .top = PlayerDat(Who).CharY + 8
        .bottom = .top + 4
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then ReDim Preserve RectsRet(UBound(RectsRet) + 1): RectsRet(UBound(RectsRet)) = 111: ShipRects = True
    '
    '12
    With rWho
        .left = PlayerDat(Who).CharX + 16
        .right = .left + 15
        .top = PlayerDat(Who).CharY + 12
        .bottom = .top + 4
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then ReDim Preserve RectsRet(UBound(RectsRet) + 1): RectsRet(UBound(RectsRet)) = 112: ShipRects = True
    '13
    With rWho
        .left = PlayerDat(Who).CharX + 16
        .right = .left + 15
        .top = PlayerDat(Who).CharY + 16
        .bottom = .top + 4
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then ReDim Preserve RectsRet(UBound(RectsRet) + 1): RectsRet(UBound(RectsRet)) = 113: ShipRects = True
    '
    '14
    With rWho
        .left = PlayerDat(Who).CharX + 16
        .right = .left + 12
        .top = PlayerDat(Who).CharY + 20
        .bottom = .top + 4
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then ReDim Preserve RectsRet(UBound(RectsRet) + 1): RectsRet(UBound(RectsRet)) = 114: ShipRects = True
    '15
    With rWho
        .left = PlayerDat(Who).CharX + 16
        .right = .left + 8
        .top = PlayerDat(Who).CharY + 24
        .bottom = .top + 4
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then ReDim Preserve RectsRet(UBound(RectsRet) + 1): RectsRet(UBound(RectsRet)) = 115: ShipRects = True
    '16
    With rWho
        .left = PlayerDat(Who).CharX + 16
        .right = .left + 4
        .top = PlayerDat(Who).CharY + 28
        .bottom = .top + 3
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then ReDim Preserve RectsRet(UBound(RectsRet) + 1): RectsRet(UBound(RectsRet)) = 116: ShipRects = True
    '17
    With rWho
        .left = PlayerDat(Who).CharX + 15
        .right = .left + 2
        .top = PlayerDat(Who).CharY + 15
        .bottom = .top + 2
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then ReDim Preserve RectsRet(UBound(RectsRet) + 1): RectsRet(UBound(RectsRet)) = 117: ShipRects = True
End Function

Sub touchObj(Who As Byte)
    Dim rTemp As RECT, rWho As RECT, rBlock As RECT, i As Integer, j As Integer, b As Byte
    Dim oNewMsg() As Byte, lNewOffSet As Long
    Dim lNewMsg As Byte
    rWho.top = PlayerDat(Who).CharY + 1
    rWho.left = PlayerDat(Who).CharX + 1
    rWho.bottom = rWho.top + 30
    rWho.right = rWho.left + 30
    For i = 1 To UBound(PowerVal)
        If PowerEffect(i) > 0 Then
            rBlock.top = PowerY(i)
            rBlock.left = PowerX(i)
            rBlock.bottom = rBlock.top + 24
            rBlock.right = rBlock.left + 24
            If IntersectRect(rTemp, rWho, rBlock) Then
                b = PowerVal(i)
                If b > 4 Then b = b - 4
                If b = 1 Then
                    lNewMsg = MSG_GOTHEALTH
                    lNewOffSet = 0
                    ReDim oNewMsg(0)
                    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
                    SendTo oNewMsg, CInt(Who)
                ElseIf b = 2 Then
                    If PlayerDat(Who).cMissile < 3 Then PlayerDat(Who).cMissile = PlayerDat(Who).cMissile + 1
                ElseIf b = 3 Then
                    If PlayerDat(Who).cBomb < 2 Then PlayerDat(Who).cBomb = PlayerDat(Who).cBomb + 1
                ElseIf b = 4 Then
                    If PlayerDat(Who).cBouncy < 3 Then PlayerDat(Who).cBouncy = PlayerDat(Who).cBouncy + 1
                End If
                lNewMsg = MSG_POWERUP
                lNewOffSet = 0
                ReDim oNewMsg(0)
                AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
                AddBufferData oNewMsg, VarPtr(i), LenB(i), lNewOffSet
                AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                b = 3
                AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                j = 0
                AddBufferData oNewMsg, VarPtr(j), LenB(j), lNewOffSet
                j = 0
                AddBufferData oNewMsg, VarPtr(j), LenB(j), lNewOffSet
                SendTo oNewMsg, CInt(Who)
                lNewOffSet = 0
                ReDim oNewMsg(0)
                AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
                AddBufferData oNewMsg, VarPtr(i), LenB(i), lNewOffSet
                AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                b = 0
                AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                j = 0
                AddBufferData oNewMsg, VarPtr(j), LenB(j), lNewOffSet
                j = 0
                AddBufferData oNewMsg, VarPtr(j), LenB(j), lNewOffSet
                SendTo oNewMsg, -1
                PowerTick(i) = NewGTC
                PowerEffect(i) = 0
                PowerLife(i) = 30000 + Int(Rnd * 30000)
            End If
        End If
    Next
End Sub
Sub flagObj(Who As Byte)
    Dim rTemp As RECT, rWho As RECT, rBlock As RECT
    Dim oNewMsg() As Byte, lNewOffSet As Long
    Dim lNewMsg As Byte
    Dim i As Integer, F As Integer, j As Integer, G As Integer, h As Long, hs As Integer, e As Integer, d As Integer, I2 As Integer
    Dim xt As Integer, yt As Integer, b As Byte
    rWho.top = PlayerDat(Who).CharY + 1
    rWho.left = PlayerDat(Who).CharX + 1
    rWho.bottom = rWho.top + 30
    rWho.right = rWho.left + 30
    
    For i = 1 To 5
        If PlayerDat(Who).inpen > 0 Then GoTo skipgot1
        If Not FlagGame(i) Then GoTo skipgot1
        If i = 1 Then F = UBound(Flag1, 2)
        If i = 2 Then F = UBound(Flag2, 2)
        If i = 3 Then F = UBound(Flag3, 2)
        If i = 4 Then F = UBound(Flag4, 2)
        If i = 5 Then F = UBound(Flag5, 2)
        For e = 1 To F
            If i = 1 Then
                rBlock.top = Flag1(1, e)
                rBlock.left = Flag1(0, e)
                G = FlagCarry1(e)
                h = FlagReady1(e)
                hs = FlagLast1(e)
                For j = 1 To 4
                    If FlagsHome1(j, e) Then Exit For
                Next
            ElseIf i = 2 Then
                rBlock.top = Flag2(1, e)
                rBlock.left = Flag2(0, e)
                G = FlagCarry2(e)
                h = FlagReady2(e)
                hs = FlagLast2(e)
                For j = 1 To 4
                    If FlagsHome2(j, e) Then Exit For
                Next
            ElseIf i = 3 Then
                rBlock.top = Flag3(1, e)
                rBlock.left = Flag3(0, e)
                G = FlagCarry3(e)
                h = FlagReady3(e)
                hs = FlagLast3(e)
                For j = 1 To 4
                    If FlagsHome3(j, e) Then Exit For
                Next
            ElseIf i = 4 Then
                rBlock.top = Flag4(1, e)
                rBlock.left = Flag4(0, e)
                G = FlagCarry4(e)
                h = FlagReady4(e)
                hs = FlagLast4(e)
                For j = 1 To 4
                    If FlagsHome4(j, e) Then Exit For
                Next
            ElseIf i = 5 Then
                rBlock.top = Flag5(1, e)
                rBlock.left = Flag5(0, e)
                G = FlagCarry5(e)
                h = FlagReady5(e)
                hs = FlagLast5(e)
                For j = 1 To 4
                    If FlagsHome5(j, e) Then Exit For
                Next
            End If
            rBlock.bottom = rBlock.top + 12
            rBlock.right = rBlock.left + 12
            If Not PlayerDat(Who).inpen Then
                If PlayerDat(Who).Flag = 0 Then
                    If PlayerDat(Who).Flagging Then
                        If G = 0 Then
                            If PlayerDat(Who).LastTeamSwitch + 2000 < NewGTC Then
                                If (NewGTC - h > 8000 Or PlayerDat(Who).Ship <> hs) Then
                                    If PlayerDat(Who).Ship = j Then GoTo skipgot
                                    If IntersectRect(rTemp, rWho, rBlock) Then
                                        d = PlayerDat(Who).Ship
                                        If i = d And g_FlagReturn Then
                                            ResetFlags i, e
                                            tmp = Choose(i, "green", "red", "blue", "yellow", "not-a-team's")
                                            lNewMsg = MSG_DROPFLAG
                                            lNewOffSet = 0
                                            ReDim oNewMsg(0)
                                            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
                                            b = 2
                                            AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                                            b = Who
                                            AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                                            b = i
                                            AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                                            b = e
                                            AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                                            If i = 1 Then
                                                I2 = Flag1(0, e)
                                                AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
                                                I2 = Flag1(1, e)
                                                AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
                                                FlagsHome1(j, e) = False
                                                FlagsHome1(1, e) = True
                                                FlagCarry1(e) = 0
                                            ElseIf i = 2 Then
                                                I2 = Flag2(0, e)
                                                AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
                                                I2 = Flag2(1, e)
                                                AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
                                                FlagsHome2(j, e) = False
                                                FlagsHome2(2, e) = True
                                                FlagCarry2(e) = 0
                                            ElseIf i = 3 Then
                                                I2 = Flag3(0, e)
                                                AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
                                                I2 = Flag3(1, e)
                                                AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
                                                FlagsHome3(j, e) = False
                                                FlagsHome3(3, e) = True
                                                FlagCarry3(e) = 0
                                            ElseIf i = 4 Then
                                                I2 = Flag4(0, e)
                                                AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
                                                I2 = Flag4(1, e)
                                                AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
                                                FlagsHome4(j, e) = False
                                                FlagsHome4(4, e) = True
                                                FlagCarry4(e) = 0
                                            ElseIf i = 5 Then
                                                I2 = Flag5(0, e)
                                                AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
                                                I2 = Flag5(1, e)
                                                AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
                                                FlagsHome5(j, e) = False
                                                FlagsHome5(5, e) = True
                                                FlagCarry5(e) = 0
                                            End If
                                            SendTo oNewMsg, -1
                                            Call sendmsg(MSG_GAMECHAT, Chr(PlayerDat(Who).Ship) & PlayerDat(Who).Nick & Chr(5) & " returns the " & Chr(i) & tmp & Chr(5) & " flag to it's base", -1)
                                            Exit Sub
                                        End If
                                        
                                        PlayerDat(Who).Flag = i
                                        PlayerDat(Who).FlagArray = e
                                        tmp = Choose(i, "green", "red", "blue", "yellow", "not-a-team's")
                                        If i = 1 Then
                                            FlagsHome1(j, e) = False
                                            FlagCarry1(e) = Who
                                            xt = Flag1(0, e)
                                            yt = Flag1(1, e)
                                            Flag1(0, e) = PlayerDat(Who).CharX + 10
                                            Flag1(1, e) = PlayerDat(Who).CharY + 10
                                        ElseIf i = 2 Then
                                            FlagsHome2(j, e) = False
                                            FlagCarry2(e) = Who
                                            xt = Flag2(0, e)
                                            yt = Flag2(1, e)
                                            Flag2(0, e) = PlayerDat(Who).CharX + 10
                                            Flag2(1, e) = PlayerDat(Who).CharY + 10
                                        ElseIf i = 3 Then
                                            FlagsHome3(j, e) = False
                                            FlagCarry3(e) = Who
                                            xt = Flag3(0, e)
                                            yt = Flag3(1, e)
                                            Flag3(0, e) = PlayerDat(Who).CharX + 10
                                            Flag3(1, e) = PlayerDat(Who).CharY + 10
                                        ElseIf i = 4 Then
                                            FlagsHome4(j, e) = False
                                            FlagCarry4(e) = Who
                                            xt = Flag4(0, e)
                                            yt = Flag4(1, e)
                                            Flag4(0, e) = PlayerDat(Who).CharX + 10
                                            Flag4(1, e) = PlayerDat(Who).CharY + 10
                                        ElseIf i = 5 Then
                                            FlagsHome5(j, e) = False
                                            FlagCarry5(e) = Who
                                            xt = Flag5(0, e)
                                            yt = Flag5(1, e)
                                            Flag5(0, e) = PlayerDat(Who).CharX + 10
                                            Flag5(1, e) = PlayerDat(Who).CharY + 10
                                        End If
                                        
                                        Call sendmsg(MSG_GAMECHAT, Chr(PlayerDat(Who).Ship) & PlayerDat(Who).Nick & Chr(5) & " grabs the " & Chr(i) & tmp & Chr(5) & " flag", -1)
                                        lNewMsg = MSG_GETFLAG
                                        lNewOffSet = 0
                                        ReDim oNewMsg(0)
                                        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
                                        b = Who
                                        AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                                        b = i
                                        AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                                        b = e
                                        AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                                        I2 = xt
                                        AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
                                        I2 = yt
                                        AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
                                        SendTo oNewMsg, -1
                                        Exit Sub
                                    End If
                                End If
                            End If
                        End If
                    End If
                End If
            End If
skipgot:
        Next
skipgot1:
    Next
End Sub

Sub WarpCheck(Who As Byte, ByVal j As Integer, ByVal i As Integer)
    Dim b As Byte, z As Integer, xt As Long, yt As Long
    Dim oNewMsg() As Byte, lNewOffSet As Long
    Dim lNewMsg As Byte
    '
    If Animations(j, i) = 158 Or (Animations(j, i) > 243 And Animations(j, i) < 251) And Not PlayerDat(Who).Warping And PlayerDat(Who).inpen = 0 Then
        If NewGTC - PlayerDat(Who).WarpDone < 3000 Then Exit Sub
        If PlayerDat(Who).Flag > 0 And Not g_FlagWarp Then Exit Sub
        xt = (AnimOffset(j, i) - AnimOffset(j, i) Mod 10) / 10
        yt = AnimOffset(j, i) Mod 10
        Randomize
        z = Int(UBound(WarpOut, 1) * Rnd + 1)
        PlayerDat(Who).WarpX = Warp(xt, 0, z)
        PlayerDat(Who).WarpY = Warp(xt, 1, z)
        PlayerDat(Who).Warping = True
        PlayerDat(Who).Key = 9
        PlayerDat(Who).CharX = i * 16 - 8
        PlayerDat(Who).CharY = j * 16 - 8
        PlayerDat(Who).Warped = NewGTC
        lNewMsg = MSG_WARPING
        lNewOffSet = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
        AddBufferData oNewMsg, VarPtr(Who), LenB(Who), lNewOffSet
        b = 1
        AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
        'dps.SendTo gAllID, oNewMsg, 0, DPNSEND_GUARANTEED Or DPNSEND_NOLOOPBACK Or DPNSEND_PRIORITY_HIGH
        SendTo oNewMsg, -1
        'touching = 12
        Exit Sub
    End If
    '
End Sub
Public Function touching(Who As Byte) As Integer
    Dim rTemp As RECT, rWho As RECT, rWho2 As RECT, rWho3 As RECT, rBlock As RECT, tmp As String, xt As Integer, yt As Integer, b As Byte, I2 As Integer
    Dim e As Integer, F As Integer, G As Integer, h As Long, L As Boolean, i As Integer, j As Integer, d As Integer
    Dim a As Integer, C As Integer, retarray As Integer
    Dim oNewMsg() As Byte, lNewOffSet As Long
    Dim lNewMsg As Byte
    ReDim RectsRet(0), RetCollision(0), RetAnimation(0)
    If PlayerDat(Who).Mode = 1 Then Exit Function
    If PlayerDat(Who).Ship > 0 Then
        With rWho
            .top = PlayerDat(Who).CharY + 1
            .left = PlayerDat(Who).CharX + 1
            .bottom = .top + 30
            .right = .left + 30
        End With
        With rWho2
            .top = PlayerDat(Who).CharY + 8
            .left = PlayerDat(Who).CharX + 8
            .bottom = .top + 8
            .right = .left + 8
        End With
        touchObj Who  ''''''''
        j = (PlayerDat(Who).CharY And -16) / 16
        i = (PlayerDat(Who).CharX And -16) / 16
        '
        a = j
        F = j + 2
        C = i
        d = i + 2
        
        For i = 0 To UBound(Mines)
            If Mines(i).Color > 0 Then
                If PlayerDat(Who).Ship = 0 Then
                    Mines(i).Color = 0
                Else
                    If Mines(i).Who = Who And Mines(i).Color <> PlayerDat(Who).Ship Then Mines(i).Color = 0
                    If Mines(i).Color > 0 And (Mines(i).Color <> PlayerDat(Who).Ship Or Mines(i).Color = 5 And Who <> Mines(i).Who) Then
                        With rBlock
                            .top = Mines(i).y
                            .left = Mines(i).X
                            .bottom = .top + 8
                            .right = .left + 8
                        End With
                        If IntersectRect(rTemp, rWho, rBlock) Then
                            Mines(i).Active = True
                        End If
                    End If
                End If
            End If
        Next
        
        For j = a To F
            For i = C To d
                If j < 0 Or i < 0 Then GoTo skip
                If j > 255 Or i > 255 Then GoTo skip
                With rBlock
                    .top = j * 16
                    .left = i * 16
                    .bottom = .top + 16
                    .right = .left + 16
                End With
                G = Collision(j, i)
                If G Then
                    If IntersectRect(rTemp, rWho, rBlock) Then
                        retarray = UBound(RectsRet)
                        If ShipRects(Who, j, i) Then
                            For e = 0 To UBound(RetCollision)
                                If RetCollision(e) = G Then Exit For
                            Next
                            If FindRectsRet(117) Then
                                If e > UBound(RetCollision) Then ReDim Preserve RetCollision(UBound(RetCollision) + 1): RetCollision(UBound(RetCollision)) = G
                            End If
                        End If
                        If G <> 1 And G <> 2 And Not (G > 3 And G < 8) Then ReDim Preserve RectsRet(retarray)
                    End If
                End If
                '
                G = Animations(j, i)
                If G > -1 And Not PlayerDat(Who).Warping Then
                    If IntersectRect(rTemp, rWho2, rBlock) Then WarpCheck Who, j, i
                End If
                If SourceTile(j, i) = 320 Then G = 139
                If G = 139 Then
                    With rWho3
                        .top = PlayerDat(Who).CharY + 15
                        .left = PlayerDat(Who).CharX + 15
                        .bottom = .top + 2
                        .right = .left + 2
                    End With
                    With rBlock
                        .top = j * 16
                        .left = i * 16
                        .bottom = .top + 16
                        .right = .left + 16
                    End With
                    If IntersectRect(rTemp, rWho3, rBlock) Then
                        For e = 0 To UBound(RetAnimation)
                            If RetAnimation(e) = G Then Exit For
                        Next
                        If e > UBound(RetAnimation) Then ReDim Preserve RetAnimation(UBound(RetAnimation) + 1): RetAnimation(UBound(RetAnimation)) = G
                    End If
                End If
skip:
            Next
        Next
        flagObj Who
        
        j = (rWho.top - (rWho.top Mod 16)) / 16 + 1
        i = (rWho.left - (rWho.left Mod 16)) / 16 + 1
        If j < 0 Or i < 0 Or j > 255 Or i > 255 Then Exit Function
        If PlayerDat(Who).Flag > 0 Then
            G = 0
            e = PlayerDat(Who).Ship
            Select Case PlayerDat(Who).Flag
            Case 1
                If PlayerDat(Who).Ship = 1 And Animations(j, i) = 28 Then G = 1
                If PlayerDat(Who).Ship = 2 And Animations(j, i) = 32 Then G = 1
                If PlayerDat(Who).Ship = 3 And Animations(j, i) = 40 Then G = 1
                If PlayerDat(Who).Ship = 4 And Animations(j, i) = 58 Then G = 1
            Case 2
                If PlayerDat(Who).Ship = 2 And Animations(j, i) = 37 Then G = 1
                If PlayerDat(Who).Ship = 1 And Animations(j, i) = 25 Then G = 1
                If PlayerDat(Who).Ship = 3 And Animations(j, i) = 41 Then G = 1
                If PlayerDat(Who).Ship = 4 And Animations(j, i) = 59 Then G = 1
            Case 3
                If PlayerDat(Who).Ship = 3 And Animations(j, i) = 46 Then G = 1
                If PlayerDat(Who).Ship = 1 And Animations(j, i) = 26 Then G = 1
                If PlayerDat(Who).Ship = 2 And Animations(j, i) = 34 Then G = 1
                If PlayerDat(Who).Ship = 4 And Animations(j, i) = 60 Then G = 1
            Case 4
                If PlayerDat(Who).Ship = 4 And Animations(j, i) = 65 Then G = 1
                If PlayerDat(Who).Ship = 1 And Animations(j, i) = 27 Then G = 1
                If PlayerDat(Who).Ship = 2 And Animations(j, i) = 35 Then G = 1
                If PlayerDat(Who).Ship = 3 And Animations(j, i) = 43 Then G = 1
            Case 5
                If PlayerDat(Who).Ship = 1 And Animations(j, i) = 128 Then G = 1
                If PlayerDat(Who).Ship = 2 And Animations(j, i) = 129 Then G = 1
                If PlayerDat(Who).Ship = 3 And Animations(j, i) = 130 Then G = 1
                If PlayerDat(Who).Ship = 4 And Animations(j, i) = 131 Then G = 1
            End Select
            If G = 1 Then
                G = PlayerDat(Who).Ship
                e = PlayerDat(Who).Flag
                F = PlayerDat(Who).FlagArray
                tmp = Choose(e, "green", "red", "blue", "yellow", "not-a-team's")
                If e = 1 Then
                    For d = 1 To UBound(Flag1, 2)
                        If Flag1(0, d) = i * 16 And Flag1(1, d) = j * 16 Then Exit Function
                    Next
                    FlagsHome1(G, F) = True
                    FlagCarry1(F) = 0
                    FlagReady1(F) = NewGTC
                ElseIf e = 2 Then
                    For d = 1 To UBound(Flag2, 2)
                        If Flag2(0, d) = i * 16 And Flag2(1, d) = j * 16 Then Exit Function
                    Next
                    FlagsHome2(G, F) = True
                    FlagCarry2(F) = 0
                    FlagReady2(F) = NewGTC
                ElseIf e = 3 Then
                    For d = 1 To UBound(Flag3, 2)
                        If Flag3(0, d) = i * 16 And Flag3(1, d) = j * 16 Then Exit Function
                    Next
                    FlagsHome3(G, F) = True
                    FlagCarry3(F) = 0
                    FlagReady3(F) = NewGTC
                ElseIf e = 4 Then
                    For d = 1 To UBound(Flag4, 2)
                        If Flag4(0, d) = i * 16 And Flag4(1, d) = j * 16 Then Exit Function
                    Next
                    FlagsHome4(G, F) = True
                    FlagCarry4(F) = 0
                    FlagReady4(F) = NewGTC
                ElseIf e = 5 Then
                    For d = 1 To UBound(Flag5, 2)
                        If Flag5(0, d) = i * 16 And Flag5(1, d) = j * 16 Then Exit Function
                    Next
                    FlagsHome5(G, F) = True
                    FlagCarry5(F) = 0
                    FlagReady5(F) = NewGTC
                End If
                PlayerDat(Who).Flag = 0
                Call sendmsg(MSG_GAMECHAT, Chr(PlayerDat(Who).Ship) & PlayerDat(Who).Nick & Chr(5) & " bravely, through much torment, brought the " & Chr(e) & tmp & Chr(5) & " flag to it's base", -1)
                lNewMsg = MSG_DROPFLAG
                lNewOffSet = 0
                ReDim oNewMsg(0)
                AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
                b = 2
                AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                b = Who
                AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                b = e
                AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                b = F
                AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                If e = 1 Then
                    Flag1(0, F) = i * 16
                    Flag1(1, F) = j * 16
                    I2 = Flag1(0, F)
                    AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
                    I2 = Flag1(1, F)
                    AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
                ElseIf e = 2 Then
                    Flag2(0, F) = i * 16
                    Flag2(1, F) = j * 16
                    I2 = Flag2(0, F)
                    AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
                    I2 = Flag2(1, F)
                    AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
                ElseIf e = 3 Then
                    Flag3(0, F) = i * 16
                    Flag3(1, F) = j * 16
                    I2 = Flag3(0, F)
                    AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
                    I2 = Flag3(1, F)
                    AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
                ElseIf e = 4 Then
                    Flag4(0, F) = i * 16
                    Flag4(1, F) = j * 16
                    I2 = Flag4(0, F)
                    AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
                    I2 = Flag4(1, F)
                    AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
                ElseIf e = 5 Then
                    Flag5(0, F) = i * 16
                    Flag5(1, F) = j * 16
                    I2 = Flag5(0, F)
                    AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
                    I2 = Flag5(1, F)
                    AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
                End If
                'dps.SendTo gAllID, oNewMsg, 0, DPNSEND_GUARANTEED Or DPNSEND_NOLOOPBACK Or DPNSEND_PRIORITY_HIGH
                SendTo oNewMsg, -1
            End If
        End If
    End If
End Function

Sub HoldingArea(Who As Byte)
    Dim i As Integer, s As Byte
    Dim oNewMsg() As Byte, lNewOffSet As Long
    Dim lNewMsg As Byte
    On Error GoTo penerr
    PlayerDat(Who).Health = 60
    s = PlayerDat(Who).Ship
    If s = 5 Then
        Randomize
        s = Int(Rnd * HData.NumTeams + 1)
    End If
    Randomize
    If s = 1 Then
        i = Int(Rnd * UBound(Hold1, 2)) + 1
        PlayerDat(Who).CharX = Hold1(0, i)
        PlayerDat(Who).CharY = Hold1(1, i)
    ElseIf s = 2 Then
        i = Int(Rnd * UBound(Hold2, 2)) + 1
        PlayerDat(Who).CharX = Hold2(0, i)
        PlayerDat(Who).CharY = Hold2(1, i)
    ElseIf s = 3 Then
        i = Int(Rnd * UBound(Hold3, 2)) + 1
        PlayerDat(Who).CharX = Hold3(0, i)
        PlayerDat(Who).CharY = Hold3(1, i)
    ElseIf s = 4 Then
        i = Int(Rnd * UBound(Hold4, 2)) + 1
        PlayerDat(Who).CharX = Hold4(0, i)
        PlayerDat(Who).CharY = Hold4(1, i)
    End If
    PlayerDat(Who).CharX = PlayerDat(Who).CharX - 8
    PlayerDat(Who).CharY = PlayerDat(Who).CharY - 8
    PlayerDat(Who).inpen = NewGTC
    PlayerDat(Who).Flagging = True
    PlayerDat(Who).cMissile = 0
    PlayerDat(Who).cBomb = 0
    PlayerDat(Who).cBouncy = 0
    PlayerDat(Who).wMissile = 0
    PlayerDat(Who).wBomb = 0
    PlayerDat(Who).wBouncy = 0
    PlayerDat(Who).smoking = False
    
    lNewMsg = MSG_FORCEPOS
    lNewOffSet = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
    AddBufferData oNewMsg, VarPtr(Who), LenB(Who), lNewOffSet
    s = 254 'send them to the pen
    AddBufferData oNewMsg, VarPtr(s), LenB(s), lNewOffSet
    i = PlayerDat(Who).CharX
    AddBufferData oNewMsg, VarPtr(i), LenB(i), lNewOffSet
    i = PlayerDat(Who).CharY
    AddBufferData oNewMsg, VarPtr(i), LenB(i), lNewOffSet
    'dps.SendTo gAllID, oNewMsg, 0, DPNSEND_NOLOOPBACK Or DPNSEND_GUARANTEED Or DPNSEND_PRIORITY_HIGH
    SendTo oNewMsg, -1
    Exit Sub
penerr:
    Beep
    frmServer.txtLog.SelStart = Len(frmServer.txtLog)
    frmServer.txtLog.SelText = vbNewLine & Err.Description & " maybe pen point not found for team" & s & PlayerDat(Who).Nick
End Sub
Public Sub NewGame()
    Dim i As Integer, j As Integer, b As Byte
    Dim oNewMsg() As Byte, lNewOffSet As Long
    Dim lNewMsg As Byte
    
    For b = 1 To UBound(PlayerDat)
        If PlayerDat(b).Ship > 0 And PlayerDat(b).Mode = 0 Then
            PlayerDat(b).Score = 0
            lNewMsg = MSG_PLAYERSCORE
            lNewOffSet = 0
            ReDim oNewMsg(0)
            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
            AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
            j = 0
            AddBufferData oNewMsg, VarPtr(j), LenB(j), lNewOffSet
            SendTo oNewMsg, -1
            DropFlag b
            HoldingArea b
        End If
    Next
    Erase TeamScores
    For i = 1 To 4
        lNewMsg = MSG_SCORE
        lNewOffSet = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
        AddBufferData oNewMsg, VarPtr(i), LenB(i), lNewOffSet
        AddBufferData oNewMsg, VarPtr(j), LenB(j), lNewOffSet
        SendTo oNewMsg, -1
    Next
    lNewMsg = MSG_PLAYERHOME
    lNewOffSet = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
    j = 5
    AddBufferData oNewMsg, VarPtr(j), LenB(j), lNewOffSet
    SendTo oNewMsg, -1
    SWEnable = NewGTC
    ResetFlags 6, 0
    SendFlagDat -1
    SendSwitchDat -1, True
    TimeClock = NewGTC
    TimeTick = g_TimeLimit * 60 - (NewGTC - TimeClock) * 0.001
    lNewMsg = MSG_TIMELIMIT
    lNewOffSet = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
    AddBufferData oNewMsg, VarPtr(TimeTick), LenB(TimeTick), lNewOffSet
    'dps.SendTo gAllID, oNewMsg, 0, DPNSEND_NOLOOPBACK Or DPNSEND_GUARANTEED Or DPNSEND_PRIORITY_HIGH
    SendTo oNewMsg, -1
    For i = 0 To UBound(UniBall)
        Erase UniBall(i).BallHits
        UniBall(i).LastHit = 0
        UniBall(i).Color = UniBall(i).OldColor
        UniBall(i).BallX = UniBall(i).OldBallX
        UniBall(i).BallY = UniBall(i).OldBallY
        UniBall(i).InHole = UniBall(i).Color
        UniBall(i).BSpeedX = 0
        UniBall(i).BSpeedY = 0
    Next
    For i = 0 To UBound(Mines)
        Mines(i).Color = 0
    Next
End Sub
Sub SpawnDat(Who As Byte) 'Put someone out of the pen
    Dim i As Integer, s As Integer, b As Byte
    Dim oNewMsg() As Byte, lNewOffSet As Long
    Dim lNewMsg As Byte
    On Error GoTo spwnerr
    s = PlayerDat(Who).Ship
    If s = 5 Then
        Randomize
        s = Int(Rnd * HData.NumTeams + 1)
    End If
    If s = 1 Then
        i = Int(Rnd * UBound(Spawn1, 2)) + 1
        PlayerDat(Who).CharX = Spawn1(0, i)
        PlayerDat(Who).CharY = Spawn1(1, i)
    ElseIf s = 2 Then
        i = Int(Rnd * UBound(Spawn2, 2)) + 1
        PlayerDat(Who).CharX = Spawn2(0, i)
        PlayerDat(Who).CharY = Spawn2(1, i)
    ElseIf s = 3 Then
        i = Int(Rnd * UBound(Spawn3, 2)) + 1
        PlayerDat(Who).CharX = Spawn3(0, i)
        PlayerDat(Who).CharY = Spawn3(1, i)
    ElseIf s = 4 Then
        i = Int(Rnd * UBound(Spawn4, 2)) + 1
        PlayerDat(Who).CharX = Spawn4(0, i)
        PlayerDat(Who).CharY = Spawn4(1, i)
    End If
    PlayerDat(Who).CharX = PlayerDat(Who).CharX - 8
    PlayerDat(Who).CharY = PlayerDat(Who).CharY - 8
    lNewMsg = MSG_FORCEPOS
    lNewOffSet = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
    AddBufferData oNewMsg, VarPtr(Who), LenB(Who), lNewOffSet
    b = 253 'get them out of the pen
    AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
    i = PlayerDat(Who).CharX
    AddBufferData oNewMsg, VarPtr(i), LenB(i), lNewOffSet
    i = PlayerDat(Who).CharY
    AddBufferData oNewMsg, VarPtr(i), LenB(i), lNewOffSet
    SendTo oNewMsg, -1
    PlayerDat(Who).inpen = 0
    Exit Sub
spwnerr:
    Beep
    frmServer.txtLog.SelStart = Len(frmServer.txtLog)
    frmServer.txtLog.SelText = vbNewLine & Err.Description & " maybe spawn point not found for team" & s & PlayerDat(Who).Nick
End Sub
Sub CheckBall()
    Dim i As Integer, j As Integer
    j = UniBall(0).InHole
    For i = 1 To UBound(UniBall)
        If j <> UniBall(i).InHole Then Exit Sub
    Next
    BallWON = j
End Sub

Public Sub CheckWIN(Who As Byte)
    Dim i As Integer, e As Integer, L As Boolean, tmp As String, j As Integer, b As Byte
    Dim oNewMsg() As Byte, lNewOffSet As Long
    Dim lNewMsg As Byte
    e = PlayerDat(Who).Ship
    If e = 10 Or e = 5 Then Exit Sub
    L = False
    If PlayerDat(Who).Mode = 1 Then Exit Sub
    For i = 1 To UBound(Flag1, 2)
        If Not FlagsHome1(e, i) Then Exit Sub
        If e <> 1 Then L = True
    Next
    
    For i = 1 To UBound(Flag2, 2)
        If Not FlagsHome2(e, i) Then Exit Sub
        If e <> 2 Then L = True
    Next
    
    For i = 1 To UBound(Flag3, 2)
        If Not FlagsHome3(e, i) Then Exit Sub
        If e <> 3 Then L = True
    Next
    
    For i = 1 To UBound(Flag4, 2)
        If Not FlagsHome4(e, i) Then Exit Sub
        If e <> 4 Then L = True
    Next
    
    For i = 1 To UBound(Flag5, 2)
        If Not FlagsHome5(e, i) Then Exit Sub
        If e <> 5 Then L = True
    Next
    If Not L And SwitchWON = 0 And BallWON = 0 Then Exit Sub
    If SwitchWON <> 0 Then If SwitchWON <> e Then Exit Sub
    If BallWON <> 0 Then If BallWON <> e Then Exit Sub
    TeamThatWON = e
    For b = 1 To UBound(PlayerDat)
        If PlayerDat(b).Ship > 0 Then
            If PlayerDat(b).Ship = e Then
                PlayerDat(b).Score = PlayerDat(b).Score + 2
                lNewMsg = MSG_PLAYERSCORE
                lNewOffSet = 0
                ReDim oNewMsg(0)
                AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
                AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                j = PlayerDat(b).Score
                AddBufferData oNewMsg, VarPtr(j), LenB(j), lNewOffSet
                'dps.SendTo gAllID, oNewMsg, 0, DPNSEND_GUARANTEED Or DPNSEND_NOLOOPBACK Or DPNSEND_PRIORITY_HIGH
                SendTo oNewMsg, -1
            Else
                PlayerDat(b).Score = PlayerDat(b).Score - 2
                If PlayerDat(b).Score < 0 Then PlayerDat(b).Score = 0
                lNewMsg = MSG_PLAYERSCORE
                lNewOffSet = 0
                ReDim oNewMsg(0)
                AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
                AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                j = PlayerDat(b).Score
                AddBufferData oNewMsg, VarPtr(j), LenB(j), lNewOffSet
                'dps.SendTo gAllID, oNewMsg, 0, DPNSEND_GUARANTEED Or DPNSEND_NOLOOPBACK Or DPNSEND_COMPLETEONPROCESS
                SendTo oNewMsg, -1
            End If
            If g_UniBall <> 2 Then HoldingArea b
        End If
    Next
    TeamScores(e) = TeamScores(e) + 1
    PlayerDat(Who).Caps = PlayerDat(Who).Caps + 1
    lNewMsg = MSG_SCORE
    lNewOffSet = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
    AddBufferData oNewMsg, VarPtr(e), LenB(e), lNewOffSet
    j = TeamScores(e)
    AddBufferData oNewMsg, VarPtr(j), LenB(j), lNewOffSet
    'dps.SendTo gAllID, oNewMsg, 0, DPNSEND_GUARANTEED Or DPNSEND_NOLOOPBACK Or DPNSEND_PRIORITY_HIGH
    SendTo oNewMsg, -1
    tmp = Choose(e, "GREEN", "RED", "BLUE", "YELLOW", "Neutral")
    Call sendmsg(MSG_GAMECHAT, Chr(e) & tmp & Chr(5) & " TEAM WINS ! ! !", -1)
    
    lNewMsg = MSG_PLAYERHOME
    lNewOffSet = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
    j = PlayerDat(Who).Ship
    AddBufferData oNewMsg, VarPtr(j), LenB(j), lNewOffSet
    'dps.SendTo gAllID, oNewMsg, 0, DPNSEND_GUARANTEED Or DPNSEND_NOLOOPBACK Or DPNSEND_PRIORITY_HIGH
    SendTo oNewMsg, -1
    SWEnable = NewGTC
    ResetFlags 6, 0
    SendFlagDat -1
    SendSwitchDat -1, True
    
    TimeClock = NewGTC
    TimeTick = g_TimeLimit * 60 - (NewGTC - TimeClock) * 0.001
    lNewMsg = MSG_TIMELIMIT
    lNewOffSet = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
    AddBufferData oNewMsg, VarPtr(TimeTick), LenB(TimeTick), lNewOffSet
    'dps.SendTo gAllID, oNewMsg, 0, DPNSEND_NOLOOPBACK Or DPNSEND_GUARANTEED Or DPNSEND_PRIORITY_HIGH
    SendTo oNewMsg, -1
    For i = 0 To UBound(UniBall)
        Erase UniBall(i).BallHits
        UniBall(i).LastHit = 0
        UniBall(i).Color = UniBall(i).OldColor
        UniBall(i).BallX = UniBall(i).OldBallX
        UniBall(i).BallY = UniBall(i).OldBallY
        UniBall(i).InHole = UniBall(i).Color
        UniBall(i).BSpeedX = 0
        UniBall(i).BSpeedY = 0
    Next
    For i = 0 To UBound(Mines)
        Mines(i).Color = 0
    Next
End Sub
Public Sub WepSync(Who As Byte)
    Static speed As Long, enginetime As Long
    speed = 0.0715 * (NewGTC - enginetime)
    enginetime = NewGTC
    If PlayerDat(Who).wEnergy < 60 Then PlayerDat(Who).wEnergy = PlayerDat(Who).wEnergy + speed * 0.2
    If PlayerDat(Who).wEnergy > 60 Then PlayerDat(Who).wEnergy = 60
    If PlayerDat(Who).DevCheat > 1 Then PlayerDat(Who).wEnergy = 60
    PlayerDat(Who).wEnergy = 60
    If PlayerDat(Who).inpen > 0 Then
        PlayerDat(Who).cMissile = 0
        PlayerDat(Who).cBomb = 0
        PlayerDat(Who).cBouncy = 0
        PlayerDat(Who).cMines = 0
        PlayerDat(Who).wMissile = 0
        PlayerDat(Who).wBomb = 0
        PlayerDat(Who).wBouncy = 0
        PlayerDat(Who).wMines = 0
        Exit Sub
    End If
    
    If PlayerDat(Who).cMissile < 3 And g_Missiles <> 0 Then
        If PlayerDat(Who).wMissile < 21 Then
            PlayerDat(Who).wMissile = PlayerDat(Who).wMissile + SpeedMiss(g_RechargeRate)
        Else
            PlayerDat(Who).cMissile = PlayerDat(Who).cMissile + 1
            PlayerDat(Who).wMissile = 0
        End If
        If PlayerDat(Who).DevCheat > 0 And Not PlayerDat(Who).DevCheat = 5 Then PlayerDat(Who).cMissile = 3
    End If
    
    If PlayerDat(Who).cBomb < 2 And g_Grenades <> 0 Then
        If PlayerDat(Who).wBomb < 21 Then
            PlayerDat(Who).wBomb = PlayerDat(Who).wBomb + SpeedMort(g_RechargeRate)
        Else
            PlayerDat(Who).cBomb = PlayerDat(Who).cBomb + 1
            PlayerDat(Who).wBomb = 0
        End If
        If PlayerDat(Who).DevCheat > 0 And Not PlayerDat(Who).DevCheat = 5 Then PlayerDat(Who).cBomb = 2
    End If
    
    If PlayerDat(Who).cBouncy < 3 And g_Bouncies <> 0 Then
        If PlayerDat(Who).wBouncy < 21 Then
            PlayerDat(Who).wBouncy = PlayerDat(Who).wBouncy + SpeedBoun(g_RechargeRate)
        Else
            PlayerDat(Who).cBouncy = PlayerDat(Who).cBouncy + 1
            PlayerDat(Who).wBouncy = 0
        End If
        If PlayerDat(Who).DevCheat > 0 And Not PlayerDat(Who).DevCheat = 5 Then PlayerDat(Who).cBouncy = 3
    End If
    
    If PlayerDat(Who).cMines < 3 And g_Mines <> 0 Then
        If PlayerDat(Who).wMines < 21 Then
            PlayerDat(Who).wMines = PlayerDat(Who).wMines + (SpeedMort(g_RechargeRate) * 5)
        Else
            PlayerDat(Who).cMines = PlayerDat(Who).cMines + 1
            PlayerDat(Who).wMines = 0
        End If
        If PlayerDat(Who).DevCheat > 0 And Not PlayerDat(Who).DevCheat = 5 Then PlayerDat(Who).cMines = 3
    End If
End Sub

Public Sub DimEm()
    ReDim Miss(0), MissWho(0), MissX(0), MissY(0), MissDist(0), MissAngle(0), MissTeam(0)
    ReDim UniBall(0), SendBuff(0), SendBuff(0).Buff(0), Mines(0), WayPoints(0)
    ReDim Laser(0), LaserWho(0), LaserAngle(0), LaserDist(0), laserTrav(0), LaserX(0), LaserY(0), LaserStopMve(0), LaserTeam(0), LaserHit(0)
    ReDim MortarY(0), MortarFrame(0), MortarDest(0), MortarDist(0), MortarAngle(0)
    ReDim MortarWho(0), MortarTeam(0), MortarSpeed(0), Mortar(0), MortarX(0), Bans(0), BounceStopMve(0)
    ReDim Explode(0), ExplodeWho(0), ExplodeX(0), ExplodeY(0), ExplodeWho(0), ShrapSpeed(0), ShrapTick(0), ShrapAngle(30, 0), ShrapDist(0)
    ReDim Bounce(0), BounceWho(0), BounceAngle(0), BounceDist(0), BounceTrav(0), BounceX(0), BounceY(0), BounceTeam(0)
    ReDim WarpOut0(0), WarpOut1(0), WarpOut2(0), WarpOut3(0), WarpOut4(0), WarpOut5(0), WarpOut6(0), WarpOut7(0), WarpOut8(0), WarpOut9(0)
End Sub

Public Function Ban(Name As String, IP As String) As String
    Dim i As Integer
    For i = 0 To UBound(Bans)
        If LCase(Bans(i).Name) = LCase(Name) And Name <> "" Then
            Bans(i).Name = "": Bans(i).IP = ""
            Ban = Name & " has been unbanned."
            Exit Function
        End If
    Next
    For i = 0 To UBound(Bans) + 1
        If i > UBound(Bans) Then ReDim Preserve Bans(i)
        If LenB(Bans(i).Name) = 0 Then
            Bans(i).Name = Name: Bans(i).IP = IP
            Ban = Name & " has been banned but could not IP ban because they are not in the game."
            If Bans(i).IP <> "" Then Ban = Name & " has been banned and IP banned."
            Exit Function
        End If
    Next
End Function

Public Function IsBanned(Name As String, IP As String) As Boolean
    Dim i As Integer
    For i = 0 To UBound(Bans)
        If (LCase$(Bans(i).Name) = LCase$(Name) Or Bans(i).IP = IP) And Name <> "" Then
            IsBanned = True
            Exit Function
        End If
    Next
End Function

Sub ResetFlags(retval As Integer, retarray As Integer)
    On Error GoTo errors
    Dim C As Integer, d As Integer, i As Integer, j As Integer
    i = 255
    j = 255
    
    If retval = 6 Then
        SwitchWON = 0
        BallWON = 0
        C = 2 * (UBound(Flag1, 2) + 1)
        CopyMemory Flag1(0, 0), FlagBase1(0, 0), C * 2
        C = 2 * (UBound(Flag2, 2) + 1)
        CopyMemory Flag2(0, 0), FlagBase2(0, 0), C * 2
        C = 2 * (UBound(Flag3, 2) + 1)
        CopyMemory Flag3(0, 0), FlagBase3(0, 0), C * 2
        C = 2 * (UBound(Flag4, 2) + 1)
        CopyMemory Flag4(0, 0), FlagBase4(0, 0), C * 2
        C = 2 * (UBound(Flag5, 2) + 1)
        CopyMemory Flag5(0, 0), FlagBase5(0, 0), C * 2
        ReDim Switched(UBound(Switches, 2)), SwitchIdle(UBound(Switches, 2))
        '
        ReDim FlagCarry1(UBound(Flag1, 2))
        ReDim FlagReady1(UBound(Flag1, 2))
        ReDim FlagLast1(UBound(Flag1, 2))
        ReDim FlagsHome1(5, UBound(Flag1, 2))
        For j = 1 To UBound(Flag1, 2)
            FlagsHome1(1, j) = True
        Next
        '
        ReDim FlagCarry2(UBound(Flag2, 2))
        ReDim FlagReady2(UBound(Flag2, 2))
        ReDim FlagLast2(UBound(Flag2, 2))
        ReDim FlagsHome2(5, UBound(Flag2, 2))
        For j = 1 To UBound(Flag2, 2)
            FlagsHome2(2, j) = True
        Next
        '
        ReDim FlagCarry3(UBound(Flag3, 2))
        ReDim FlagReady3(UBound(Flag3, 2))
        ReDim FlagLast3(UBound(Flag3, 2))
        ReDim FlagsHome3(5, UBound(Flag3, 2))
        For j = 1 To UBound(Flag3, 2)
            FlagsHome3(3, j) = True
        Next
        '
        ReDim FlagCarry4(UBound(Flag4, 2))
        ReDim FlagReady4(UBound(Flag4, 2))
        ReDim FlagLast4(UBound(Flag4, 2))
        ReDim FlagsHome4(5, UBound(Flag4, 2))
        For j = 1 To UBound(Flag4, 2)
            FlagsHome4(4, j) = True
        Next
        '
        ReDim FlagCarry5(UBound(Flag5, 2))
        ReDim FlagReady5(UBound(Flag5, 2))
        ReDim FlagLast5(UBound(Flag5, 2))
        ReDim FlagsHome5(5, UBound(Flag5, 2))
        For j = 1 To UBound(Flag5, 2)
            FlagsHome5(5, j) = True
        Next
        ReDim Switched(UBound(Switches, 2))
    End If
    If retval = 1 Then
        Flag1(0, retarray) = FlagBase1(0, retarray)
        Flag1(1, retarray) = FlagBase1(1, retarray)
    End If
    If retval = 2 Then
        Flag2(0, retarray) = FlagBase2(0, retarray)
        Flag2(1, retarray) = FlagBase2(1, retarray)
    End If
    If retval = 3 Then
        Flag3(0, retarray) = FlagBase3(0, retarray)
        Flag3(1, retarray) = FlagBase3(1, retarray)
    End If
    If retval = 4 Then
        Flag4(0, retarray) = FlagBase4(0, retarray)
        Flag4(1, retarray) = FlagBase4(1, retarray)
    End If
    If retval = 5 Then
        Flag5(0, retarray) = FlagBase5(0, retarray)
        Flag5(1, retarray) = FlagBase5(1, retarray)
    End If
    Exit Sub
errors:
    MsgBox "The map is corrupted. Please download a new copy, or use a different map.", vbExclamation, App.Title
    Stopping = True
    frmServer.Timer2.Enabled = True
End Sub

Public Sub PlayerDied(pID As Byte, b2 As Byte, Optional Wep As Integer = -1, Optional WepIndex As Integer = -1, Optional DoStats = True)
    Dim oNewMsg() As Byte, lNewOffSet As Long
    Dim lNewMsg As Byte
    Dim i As Integer
    PlayerDat(pID).smoking = False
    PlayerDat(pID).Key = 9
    DropFlag pID
    PlayerDat(pID).Flagging = False
    If DoStats Then
        If PlayerDat(pID).Score > 10 Then PlayerDat(pID).Score = PlayerDat(pID).Score - (PlayerDat(pID).Score - PlayerDat(pID).Score Mod 10) / 10
        lNewMsg = MSG_PLAYERSCORE
        lNewOffSet = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
        AddBufferData oNewMsg, VarPtr(pID), LenB(pID), lNewOffSet
        i = PlayerDat(pID).Score
        AddBufferData oNewMsg, VarPtr(i), LenB(i), lNewOffSet
        SendTo oNewMsg, -2
    End If
    If b2 < 0 Or b2 > UBound(PlayerDat) Then Exit Sub
    If PlayerDat(pID).Ship = 0 Then Exit Sub
    Call sendmsg(MSG_GAMECHAT, Chr(PlayerDat(b2).Ship) & PlayerDat(b2).Nick & Chr(5) & " destroyed " & Chr(PlayerDat(pID).Ship) & PlayerDat(pID).Nick, -2)
    
    lNewMsg = MSG_DIED
    lNewOffSet = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
    AddBufferData oNewMsg, VarPtr(pID), LenB(pID), lNewOffSet
    AddBufferData oNewMsg, VarPtr(Wep), LenB(Wep), lNewOffSet
    AddBufferData oNewMsg, VarPtr(WepIndex), LenB(WepIndex), lNewOffSet
    SendTo oNewMsg, -2
    PlayerDat(pID).inpenTrig = NewGTC
    lNewMsg = MSG_GOTHEALTH
    lNewOffSet = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
    SendTo oNewMsg, CInt(b2)
    PlayerDat(b2).Health = PlayerDat(b2).Health + 17
    If PlayerDat(b2).Health > 17 Then
        PlayerDat(b2).smoking = False
        lNewMsg = MSG_ARMORLO
        lNewOffSet = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
        b = b2
        AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
        b = PlayerDat(b2).smoking
        AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
        SendTo oNewMsg, -2, False
    End If
    If b2 <> pID Then
        If DoStats Then
            If PlayerDat(b2).Score < 65001 Then PlayerDat(b2).Score = PlayerDat(b2).Score + 1
            If PlayerDat(b2).Frags < 65001 Then PlayerDat(b2).Frags = PlayerDat(b2).Frags + 1
            If PlayerDat(pID).Deaths < 65001 Then PlayerDat(pID).Deaths = PlayerDat(pID).Deaths + 1
        End If
        PlayerDat(pID).cMissile = 0
        PlayerDat(pID).cBomb = 0
        PlayerDat(pID).cBouncy = 0
        PlayerDat(pID).wBomb = 0
        PlayerDat(pID).wBouncy = 0
        PlayerDat(pID).wMissile = 0
        PlayerDat(pID).WepSyncT = NewGTC
        
        If DoStats Then
            lNewMsg = MSG_PLAYERSCORE
            lNewOffSet = 0
            ReDim oNewMsg(0)
            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
            AddBufferData oNewMsg, VarPtr(b2), LenB(b2), lNewOffSet
            i = PlayerDat(b2).Score
            AddBufferData oNewMsg, VarPtr(i), LenB(i), lNewOffSet
            'dps.SendTo gAllID, oNewMsg, 0, DPNSEND_GUARANTEED Or DPNSEND_NOLOOPBACK Or DPNSEND_PRIORITY_HIGH
            SendTo oNewMsg, -2
        End If
    End If
    
    If g_DeathMatch > 0 Then
        If DoStats Then
            If PlayerDat(b2).Score > HighestScore Then
                HighestScore = PlayerDat(b2).Score
                If HighestScoreWho <> b2 Then
                    Call sendmsg(MSG_GAMECHAT, Chr(PlayerDat(b2).Ship) & PlayerDat(b2).Nick & Chr(5) & " has taken the lead!", -2)
                End If
                HighestScoreWho = b2
            End If
        End If
    End If
    If DoStats Then If HighestScore >= g_DeathMatch And g_DeathMatch <> 0 Then FragWin
End Sub

Public Function SendMine(pID As Byte, b As Byte, T3 As Integer, T4 As Integer)
    Dim oNewMsg() As Byte, lNewOffSet As Long
    Dim lNewMsg As Byte, i As Integer
    i = SetMine(pID, b, T3, T4)
    SendMine = i
    lNewMsg = MSG_MINES
    lNewOffSet = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
    AddBufferData oNewMsg, VarPtr(i), LenB(i), lNewOffSet
    AddBufferData oNewMsg, VarPtr(pID), LenB(pID), lNewOffSet
    AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
    AddBufferData oNewMsg, VarPtr(T3), LenB(T3), lNewOffSet
    AddBufferData oNewMsg, VarPtr(T4), LenB(T4), lNewOffSet
    SendTo oNewMsg, -2
End Function

Public Sub AutoPilot(b As Byte)
    Dim rTemp As RECT, rWho As RECT, rBlock As RECT, tmp As String, xt As Integer, yt As Integer
    Dim i As Integer, j As Integer, d As Integer, pangle As Single, X As Integer, y As Integer
    Dim NewX As Integer, NewY As Integer, pangle2 As Single, a As Integer
    Dim oNewMsg() As Byte, lNewOffSet As Long
    Dim lNewMsg As Byte
    Static PlayerNum As Integer
    ReDim RectsRet(0), RetCollision(0), RetAnimation(0)
    
    For i = PlayerNum To UBound(PlayerDat)
        If PlayerDat(i).Ship > 0 Then Exit For
    Next
    PlayerNum = i + 1
    If i >= UBound(PlayerDat) Then
        PlayerNum = 1
    End If
    If i > UBound(PlayerDat) Then i = 1
    
    'If PlayerNum > UBound(PlayerDat) Then PlayerNum = 0
    'i = 1
    If PlayerDat(i).Ship > 0 And PlayerDat(i).Ship <> PlayerDat(b).Ship And PlayerDat(i).Flagging Then
        If NewGTC - PlayerDat(i).Tick > 200 And 1 Then
            xt = PlayerDat(i).CharX + 16 - (PlayerDat(b).CharX + 16)
            yt = PlayerDat(i).CharY + 16 - (PlayerDat(b).CharY + 16)
            If Abs(xt) < 800 And Abs(yt) < 800 Then
                If xt = 0 Then xt = 1
                If yt = 0 Then yt = 1
                pangle = Atn(yt / xt)
                pangle = pangle * Div180byPI
                If xt < 0 Then pangle = pangle + 180
                PlayerDat(i).Tick = NewGTC
                
                If PlayerDat(b).Flagging Then
                    'j = Sqr(xt ^ 2 + yt ^ 2)
                    For d = 0 To 500
                        NewX = Cos(pangle * Div360MultPI) * d + (PlayerDat(b).CharX + 16)
                        NewY = Sin(pangle * Div360MultPI) * d + (PlayerDat(b).CharY + 16)
                        X = b * -1
                        j = WeaponTouch(0, X, NewX, NewY)
                        If j <> 0 Then
                            If j > 0 Then
                                FireLaser b, xt, yt, CInt(PlayerDat(b).CharX), CInt(PlayerDat(b).CharY)
                            End If
                            Exit For
                        End If
                    Next
                End If
                
                y = b * -1
                PlayerDat(b).Degrees = PlayerDat(b).Degrees + 20
                If PlayerDat(b).Degrees > 270 Then PlayerDat(b).Degrees = -90
                pangle2 = PlayerDat(b).Degrees
                xt = PlayerDat(b).CharX + 16
                yt = PlayerDat(b).CharY + 16
                If PlayerDat(b).Flagging Then
                    X = 3
                    For d = 16 To 800 Step 1
                        NewX = Cos(pangle2 * Div360MultPI) * X + xt
                        NewY = Sin(pangle2 * Div360MultPI) * X + yt
                        j = WeaponTouch(3, y, NewX, NewY, pangle2)
                        If j <> 0 Then
                            X = 0
                            xt = NewX
                            yt = NewY
                            If j > 0 Then
                                NewX = Cos(PlayerDat(b).Degrees * Div360MultPI) * 800
                                NewY = Sin(PlayerDat(b).Degrees * Div360MultPI) * 800
                                FireBounce b, NewX, NewY, CInt(PlayerDat(b).CharX), CInt(PlayerDat(b).CharY)
                                Exit For
                            End If
                        End If
                        X = X + 1
                    Next
                End If
                
            End If
        End If
    End If
    
    With rWho
        .top = PlayerDat(b).CharY + 1
        .left = PlayerDat(b).CharX + 1
        .bottom = .top + 30
        .right = .left + 30
    End With
    Exit Sub
    For i = 0 To UBound(WayPoints)
        With rBlock
            .top = WayPoints(i).y
            .left = WayPoints(i).X
            .bottom = .top + 16
            .right = .left + 16
        End With
        If IntersectRect(rTemp, rWho, rBlock) Then
            If i <> PlayerDat(b).LastWayPoint And i < UBound(WayPoints) Then
                PlayerDat(b).WayPoint = i
                PlayerDat(b).LastWayPoint = i
            End If
            If PlayerDat(b).WayPoint = i Then
                PlayerDat(b).WayPoint = PlayerDat(b).WayPoint + 1
                If PlayerDat(b).WayPoint > UBound(WayPoints) Then PlayerDat(b).WayPoint = 0
            End If
            Exit For
        End If
    Next
    i = WayPoints(PlayerDat(b).WayPoint).X - PlayerDat(b).CharX
    j = WayPoints(PlayerDat(b).WayPoint).y - PlayerDat(b).CharY
    If i = 0 Then i = 1
    If j = 0 Then j = 1
    pangle = Atn(j / i)
    pangle = pangle * Div180byPI
    If i < 0 Then pangle = pangle + 180
    If pangle > -21 And pangle < 23 Then PlayerDat(b).Key = 1
    If pangle > 22 And pangle < 67 Then PlayerDat(b).Key = 8
    If pangle > 66 And pangle < 111 Then PlayerDat(b).Key = 7
    If pangle > 112 And pangle < 157 Then PlayerDat(b).Key = 6
    If pangle > 156 And pangle < 202 Then PlayerDat(b).Key = 5
    If pangle > 201 And pangle < 247 Then PlayerDat(b).Key = 4
    If pangle > 246 Or (pangle < -67 And pangle > -91) Then PlayerDat(b).Key = 3
    If pangle > -67 And pangle < -22 Then PlayerDat(b).Key = 2
End Sub

Sub CharUpdate(i As Byte)
    Dim j As Integer, d As Integer, DiagMvSpd As Single, LastCX As Single, LastCY As Single, e As Integer, F As Integer
    Dim MvSpd As Single, sx As Single, sy As Single, chs As Single, MvSpd2 As Single
    MvSpd = speed * 1.1
    'If MvSpd > 1 Then Debug.Print MvSpd
    If PlayerDat(i).Flag > 0 Then MvSpd = MvSpd * 0.75
    If PlayerDat(i).DevCheat > 2 Then MvSpd = MvSpd * 3
    If PlayerDat(i).Mode > 0 Then MvSpd = MvSpd * 6
    DiagMvSpd = 0.7 * 1.1
    chs = MvSpd / (Int(MvSpd) + 1)
    If Val(MvSpd) > 100 Then Exit Sub
    For j = 0 To Int(MvSpd)
        LastCX = PlayerDat(i).CharX
        LastCY = PlayerDat(i).CharY
        If PlayerDat(i).Key = 1 Then
            PlayerDat(i).CharX = PlayerDat(i).CharX + chs
        ElseIf PlayerDat(i).Key = 2 Then
            PlayerDat(i).CharX = PlayerDat(i).CharX + chs * DiagMvSpd
            PlayerDat(i).CharY = PlayerDat(i).CharY - chs * DiagMvSpd
        ElseIf PlayerDat(i).Key = 3 Then
            PlayerDat(i).CharY = PlayerDat(i).CharY - chs
        ElseIf PlayerDat(i).Key = 4 Then
            PlayerDat(i).CharY = PlayerDat(i).CharY - chs * DiagMvSpd
            PlayerDat(i).CharX = PlayerDat(i).CharX - chs * DiagMvSpd
        ElseIf PlayerDat(i).Key = 5 Then
            PlayerDat(i).CharX = PlayerDat(i).CharX - chs
        ElseIf PlayerDat(i).Key = 6 Then
            PlayerDat(i).CharX = PlayerDat(i).CharX - chs * DiagMvSpd
            PlayerDat(i).CharY = PlayerDat(i).CharY + chs * DiagMvSpd
        ElseIf PlayerDat(i).Key = 7 Then
            PlayerDat(i).CharY = PlayerDat(i).CharY + chs
        ElseIf PlayerDat(i).Key = 8 Then
            PlayerDat(i).CharY = PlayerDat(i).CharY + chs * DiagMvSpd
            PlayerDat(i).CharX = PlayerDat(i).CharX + chs * DiagMvSpd
        End If
        Call touching(i)
        '
        For e = 1 To UBound(RetCollision)
            d = RetCollision(e)
            If d = 8 And (PlayerDat(i).DevCheat < 2 Or PlayerDat(i).DevCheat = 3 Or PlayerDat(i).DevCheat = 5) Then PlayerDat(i).CharY = PlayerDat(i).CharY - chs * 0.7
            If d = 9 And (PlayerDat(i).DevCheat < 2 Or PlayerDat(i).DevCheat = 3 Or PlayerDat(i).DevCheat = 5) Then PlayerDat(i).CharY = PlayerDat(i).CharY + chs * 0.7
            If d = 10 And (PlayerDat(i).DevCheat < 2 Or PlayerDat(i).DevCheat = 3 Or PlayerDat(i).DevCheat = 5) Then PlayerDat(i).CharX = PlayerDat(i).CharX - chs * 0.7
            If d = 11 And (PlayerDat(i).DevCheat < 2 Or PlayerDat(i).DevCheat = 3 Or PlayerDat(i).DevCheat = 5) Then PlayerDat(i).CharX = PlayerDat(i).CharX + chs * 0.7
        Next
        '
        For e = 1 To UBound(RetAnimation)
            If RetAnimation(e) = 139 Then
                If NewGTC - PlayerDat(i).inpen > g_HoldTime * 1000 Then
                    If Not g_Locked Then
                        If PlayerDat(i).inpen <> 0 Then SpawnDat i
                        Exit For
                    End If
                End If
            End If
        Next
        '
        If PlayerDat(i).DevCheat < 2 Or PlayerDat(i).DevCheat = 3 Or PlayerDat(i).DevCheat = 5 Then GoSub whatever
    Next
    Exit Sub
whatever:
    sx = PlayerDat(i).CharX
    sy = PlayerDat(i).CharY
    '
    d = touching(i)
    If UBound(RectsRet) > 0 Then
        PlayerDat(i).CharX = LastCX
        PlayerDat(i).CharY = LastCY
        If (FindRectsRet(104) And FindRectsRet(105)) Or (FindRectsRet(112) And FindRectsRet(113)) Then
            PlayerDat(i).CharY = sy
            Call touching(i)
            If UBound(RectsRet) > 0 Then PlayerDat(i).CharY = LastCY
            Return
        End If
        If (FindRectsRet(101) And FindRectsRet(109)) Or (FindRectsRet(108) And FindRectsRet(116)) Then
            PlayerDat(i).CharX = sx
            Call touching(i)
            If UBound(RectsRet) > 0 Then PlayerDat(i).CharX = LastCX
            Return
        End If
    End If
    For e = 1 To UBound(RectsRet)
        d = RectsRet(e)
        If d = 101 Then
            If sx - LastCX <> 0 Then PlayerDat(i).CharY = PlayerDat(i).CharY + chs * 0.4
            If sy - LastCY <> 0 Then PlayerDat(i).CharX = PlayerDat(i).CharX + chs * 0.4
        End If
        If d = 102 Then
            If sx - LastCX <> 0 Then PlayerDat(i).CharY = PlayerDat(i).CharY + chs * 0.4
            If sy - LastCY <> 0 Then PlayerDat(i).CharX = PlayerDat(i).CharX + chs * 0.4
        End If
        If d = 103 Then
            If sx - LastCX <> 0 Then PlayerDat(i).CharY = PlayerDat(i).CharY + chs * 0.4
            If sy - LastCY <> 0 Then PlayerDat(i).CharX = PlayerDat(i).CharX + chs * 0.4
        End If
        '
        If d = 104 Then
            If sx - LastCX <> 0 Then PlayerDat(i).CharY = PlayerDat(i).CharY + chs * 0.4
            If sy - LastCY <> 0 Then PlayerDat(i).CharX = PlayerDat(i).CharX + chs * 0.4
        End If
        If d = 105 Then
            If sx - LastCX <> 0 Then PlayerDat(i).CharY = PlayerDat(i).CharY - chs * 0.4
            If sy - LastCY <> 0 Then PlayerDat(i).CharX = PlayerDat(i).CharX + chs * 0.4
        End If
        '
        If d = 106 Then
            If sx - LastCX <> 0 Then PlayerDat(i).CharY = PlayerDat(i).CharY - chs * 0.4
            If sy - LastCY <> 0 Then PlayerDat(i).CharX = PlayerDat(i).CharX + chs * 0.4
        End If
        If d = 107 Then
            If sx - LastCX <> 0 Then PlayerDat(i).CharY = PlayerDat(i).CharY - chs * 0.4
            If sy - LastCY <> 0 Then PlayerDat(i).CharX = PlayerDat(i).CharX + chs * 0.4
        End If
        If d = 108 Then
            If sx - LastCX <> 0 Then PlayerDat(i).CharY = PlayerDat(i).CharY - chs * 0.4
            If sy - LastCY <> 0 Then PlayerDat(i).CharX = PlayerDat(i).CharX + chs * 0.4
        End If
        '
        If d = 109 Then
            If sx - LastCX <> 0 Then PlayerDat(i).CharY = PlayerDat(i).CharY + chs * 0.4
            If sy - LastCY <> 0 Then PlayerDat(i).CharX = PlayerDat(i).CharX - chs * 0.4
        End If
        If d = 110 Then
            If sx - LastCX <> 0 Then PlayerDat(i).CharY = PlayerDat(i).CharY + chs * 0.4
            If sy - LastCY <> 0 Then PlayerDat(i).CharX = PlayerDat(i).CharX - chs * 0.4
        End If
        If d = 111 Then
            If sx - LastCX <> 0 Then PlayerDat(i).CharY = PlayerDat(i).CharY + chs * 0.4
            If sy - LastCY <> 0 Then PlayerDat(i).CharX = PlayerDat(i).CharX - chs * 0.4
        End If
        If d = 112 Then
            If sx - LastCX <> 0 Then PlayerDat(i).CharY = PlayerDat(i).CharY + chs * 0.4
            If sy - LastCY <> 0 Then PlayerDat(i).CharX = PlayerDat(i).CharX - chs * 0.4
        End If
        '
        If d = 113 Then
            If sx - LastCX <> 0 Then PlayerDat(i).CharY = PlayerDat(i).CharY - chs * 0.4
            If sy - LastCY <> 0 Then PlayerDat(i).CharX = PlayerDat(i).CharX - chs * 0.4
        End If
        If d = 114 Then
            If sx - LastCX <> 0 Then PlayerDat(i).CharY = PlayerDat(i).CharY - chs * 0.4
            If sy - LastCY <> 0 Then PlayerDat(i).CharX = PlayerDat(i).CharX - chs * 0.4
        End If
        If d = 115 Then
            If sx - LastCX <> 0 Then PlayerDat(i).CharY = PlayerDat(i).CharY - chs * 0.4
            If sy - LastCY <> 0 Then PlayerDat(i).CharX = PlayerDat(i).CharX - chs * 0.4
        End If
        If d = 116 Then
            If sx - LastCX <> 0 Then PlayerDat(i).CharY = PlayerDat(i).CharY - chs * 0.4
            If sy - LastCY <> 0 Then PlayerDat(i).CharX = PlayerDat(i).CharX - chs * 0.4
        End If
    Next
    '
    Return
End Sub

Public Function GetDriveInfo(strDrive As String, iType As Integer)
    Dim Serial_Number As Long
    Dim Drive_Label As String
    Dim Fat_Type As String
    Dim Return_Value As Long
    Drive_Label = Space$(256)
    Fat_Type = Space$(256)
    Return_Value = GetVolumeInformation(strDrive, Drive_Label, Len(Drive_Label), Serial_Number, 0, 0, Fat_Type, Len(Fat_Type))
    GetDriveInfo = CStr(Serial_Number)
End Function

Public Sub AddBufferData(BufferData() As Byte, vPtr As Long, lLen As Integer, lOffset As Long)
    If lOffset = 0 Then ReDim BufferData(lLen + 1) Else ReDim Preserve BufferData(UBound(BufferData) + lLen + 2)
    CopyMemory BufferData(lOffset), lLen, 2
    lOffset = lOffset + 2
    CopyMemory BufferData(lOffset), ByVal vPtr, lLen
    lOffset = lOffset + lLen
End Sub

Public Function AddBufferString(BufferData() As Byte, ByVal tmp As String, lOffset As Long) As String
    Dim lLen As Integer, i As Integer
    If Encrypted Then tmp = Encryption.EncryptString(tmp, EncPassword)
    i = Len(tmp)
    If lOffset = 0 Then ReDim BufferData(i + 1) Else ReDim Preserve BufferData(UBound(BufferData) + i + 2)
    CopyMemory BufferData(lOffset), i, 2
    lOffset = lOffset + 2
    CopyMemory BufferData(lOffset), ByVal tmp, Len(tmp)
    lOffset = lOffset + Len(tmp)
End Function

Public Sub GetBufferData(BufferData() As Byte, vPtr As Long, lLen As Integer, lOffset As Long)
    'On Error Resume Next
    Dim i As Integer
    CopyMemory i, BufferData(lOffset), 2
    lOffset = lOffset + 2
    If i <> lLen Then Err.Raise 1, , "Sizes didn't match. Bugger." ' DELETE ME ?
    CopyMemory ByVal vPtr, BufferData(lOffset), lLen
    lOffset = lOffset + lLen
End Sub

Public Function GetBufferString(BufferData() As Byte, lOffset As Long) As String
    On Error GoTo errors
    Dim tmp As String, lLen As Integer
    CopyMemory lLen, BufferData(lOffset), 2
    lOffset = lOffset + 2
    tmp = String$(lLen, Chr(0))
    CopyMemory ByVal tmp, BufferData(lOffset), lLen
    lOffset = lOffset + lLen
    If Encrypted Then tmp = Encryption.DecryptString(tmp, EncPassword)
    GetBufferString = tmp
    Exit Function
errors:
    GetBufferString = "XDecryptFailure"
    Err.Clear
End Function

Private Function TestString(ByVal Data As String) As Boolean
    Dim b() As Byte
    ReDim b(Len(Data))
    CopyMemory b(0), ByVal Data, Len(Data)
    For i = 0 To UBound(b)
        If b(i) < 33 Or b(i) > 126 Then Exit Function
    Next
    TestString = True
End Function

Public Function MoveLoop()
    'On Local Error Resume Next
    Dim i As Integer
    
    TimeEvents = NewGTC
    '
    For i = 0 To UBound(Laser)
        If Laser(i) Then e = 1: AnimLaser i
    Next
    If e = 0 And i > 1 Then ReDim Laser(0)
    
    e = 0
    For i = 0 To UBound(Bounce)
        If Bounce(i) Then e = 1: AnimBounce i
    Next
    If e = 0 And i > 1 Then ReDim Bounce(0)
    
    e = 0
    For i = 0 To UBound(Miss)
        If Miss(i) Then e = 1: AnimMiss i
    Next
    If e = 0 And i > 1 Then ReDim Miss(0)
    
    e = 0
    For i = 0 To UBound(Mines)
        If Mines(i).Color > 0 Then
            If PlayerDat(Mines(i).Who).Ship <> Mines(i).Color Then
                Mines(i).Color = 0
                Mines(i).Tick = 0 'Delete mines planted by players who switched teams
            End If
        End If
        If Mines(i).Tick > 0 And Mines(i).Color > 0 Then
            If NewGTC - Mines(i).Tick > 500 Then
                BombHit Mines(i).X, Mines(i).y
                ExplShrap Mines(i).Who, Mines(i).X, Mines(i).y, 3.5, 700, 0, 12 'Shrapnel.
                Mines(i).Color = 0
            End If
        End If
    Next
    
    For i = 0 To UBound(ExplodeWho)
        If TimeEvents - Explode(i) < ShrapTick(i) Then
            If ExplodeWho(i) > 0 Then
                e = 1
                AnimShrapnel i
            End If
        Else
            ExplodeWho(i) = 0
        End If
    Next
    
    e = 0
    For i = 0 To UBound(Mortar)
        If Mortar(i) Then
            e = 1: Mortars i
        End If
    Next
    If e = 0 And i > 1 Then ReDim Mortar(0)
    For i = 0 To UBound(UniBall)
        If UniBall(i).Color > 0 Then AnimUniBall i
    Next
    e = 0 'no mines exist
    For i = 0 To UBound(Mines)
        If PlayerDat(Mines(i).Who).Ship <> Mines(i).Color Then Mines(i).Color = 0: Mines(i).Active = False: Mines(i).Tick = 0
        If Mines(i).Color > 0 Then 'if it exists
            e = 1 'mines exist
            If Mines(i).Active And Mines(i).Tick = 0 Then
                Mines(i).Active = False 'Deactivate after activation completes
                'Mines(I).Color = 0
                j = i * -1 - 1
                lNewMsg = MSG_MINES
                lNewOffSet = 0
                ReDim oNewMsg(0)
                AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
                AddBufferData oNewMsg, VarPtr(j), LenB(j), lNewOffSet
                Mines(i).Tick = NewGTC
                SendTo oNewMsg, -1
            End If
        End If
    Next
    If e = 0 And i > 1 Then ReDim Mines(0) 'Kill all old, used mines
    
    TimeTick = g_TimeLimit * 60 - (NewGTC - TimeClock) * 0.001
    If g_TimeLimit = 0 Then TimeTick = 0
    If TimeTick < 0 Then TimeTick = 0
    If TimeTick = 0 And g_TimeLimit > 0 Then NewGame
    
    For bc = 1 To UBound(PlayerDat)
        If PlayerDat(bc).Ship > 0 Then
            If Not PlayerDat(bc).Login Then
                If NewGTC - PlayerDat(bc).LoginWait > 1000 Then
                    PlayerDat(bc).LoginWait = NewGTC
                    If PlayerDat(bc).LoginCount > 6 Then PlayerDat(bc).UDPOK = False
                    If PlayerDat(bc).LoginCount > 10 Then
                        PlayerDat(bc).die = True
                    End If
                    PlayerDat(bc).LoginCount = PlayerDat(bc).LoginCount + 1
                    lNewMsg = MSG_MAP
                    lNewOffSet = 0
                    ReDim oNewMsg(0)
                    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
                    AddBufferString oNewMsg, MapPlay, lNewOffSet
                    SendTo oNewMsg, CInt(bc), False
                End If
            End If
            If PlayerDat(bc).SendMap And (NewGTC - PlayerDat(bc).SendMapTimer >= 0) Then
                If PlayerDat(bc).bPNT = -1 Then
                    frmServer.txtLog.SelStart = Len(frmServer.txtLog)
                    frmServer.txtLog.SelText = vbNewLine & "Transferring map to " & PlayerDat(bc).Nick
                    lNewMsg = MSG_MAPTRANSFER
                    lNewOffSet = 0
                    ReDim oNewMsg(0)
                    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
                    AddBufferData oNewMsg, VarPtr(FileLenB), LenB(FileLenB), lNewOffSet
                    SendTo oNewMsg, CInt(bc), True
                End If
                If PlayerDat(bc).bPNT > -1 Then
                    lNewMsg = MSG_MAPTRANSFER
                    lNewOffSet = 0
                    ReDim oNewMsg(0)
                    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
                    For a = 0 To 100
                        b = 4
                        If PlayerDat(bc).bPNT > FileLenB - 3 Then
                            b = FileLenB - PlayerDat(bc).bPNT + 1
                            If b < 0 Then b = 0
                        End If
                        d = 0
                        If b > 0 Then
                            CopyMemory d, SMData(PlayerDat(bc).bPNT), b
                        End If
                        PlayerDat(bc).bPNT = PlayerDat(bc).bPNT + 4
                        AddBufferData oNewMsg, VarPtr(d), LenB(d), lNewOffSet
                        If PlayerDat(bc).bPNT > FileLenB Then Exit For
                    Next
                    'Debug.Print UBound(oNewMsg)
                    'PlayerDat(bc).SendMapTimer = NewGTC + 75
                    PlayerDat(bc).SendMapTimer = 0
                    SendTo oNewMsg, CInt(bc), True
                Else
                    PlayerDat(bc).bPNT = 0
                End If
out:
                If PlayerDat(bc).bPNT > FileLenB Then PlayerDat(bc).SendMap = False
            End If
        End If
    Next
    '
    If NewGTC - LT > 10000 Then LC = True
    If NewGTC - PCount > PSpeed Then
        For bc = 1 To UBound(PlayerDat)
            If PlayerDat(bc).Ship > 0 Then
                
                If NewGTC - PlayerDat(bc).activity > g_IdleTime * 60000 And g_IdleTime > 0 Then
                    PlayerDat(bc).activity = NewGTC
                    Kick PlayerDat(bc).Nick, "Kicked: Inactivity (" & g_IdleTime & " minute limit)."
                    GoTo leave
                End If
                If Abs(PlayerDat(bc).CharX) > 32000 Or Abs(PlayerDat(bc).CharY) > 32000 Then
                    PlayerDat(bc).CharX = 0
                    PlayerDat(bc).CharY = 0
                    PlayerDat(bc).die = True
                    bpc = 6
                    GoTo out2
                End If
                Call CheckSwitches(bc, CInt(PlayerDat(bc).CharX), CInt(PlayerDat(bc).CharY))
                CheckBall
                '
                If LC Then
                    If ConnectionOK Then
                        lNewMsg = SVR_STATS
                        lNewOffSet = 0
                        ReDim oNewMsg(0)
                        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
                        AddBufferData oNewMsg, VarPtr(bc), LenB(bc), lNewOffSet
                        b = PlayerDat(bc).Ship
                        AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                        i = PlayerDat(bc).Frags
                        AddBufferData oNewMsg, VarPtr(i), LenB(i), lNewOffSet
                        i = PlayerDat(bc).Deaths
                        AddBufferData oNewMsg, VarPtr(i), LenB(i), lNewOffSet
                        i = PlayerDat(bc).Caps
                        AddBufferData oNewMsg, VarPtr(i), LenB(i), lNewOffSet
                        L = NewGTC - PlayerDat(bc).Duration
                        AddBufferData oNewMsg, VarPtr(L), LenB(L), lNewOffSet
                        SendTo2 oNewMsg, 0
                        
                        lNewMsg = SVR_MRB
                        lNewOffSet = 0
                        ReDim oNewMsg(0)
                        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
                        AddBufferData oNewMsg, VarPtr(bc), LenB(bc), lNewOffSet
                        i = PlayerDat(bc).Ping
                        AddBufferData oNewMsg, VarPtr(i), LenB(i), lNewOffSet
                        'dpc.Send oNewMsg, 0, DPNSEND_GUARANTEED
                        SendTo2 oNewMsg, 0
                    End If
                End If
                '
            End If
        Next
        If LC Then
            LT = NewGTC
            LC = False
        End If
        SendData
        'senddata2
        PCount = NewGTC
    End If
    '
    For bpc = 1 To UBound(PlayerDat)
        
        If PlayerDat(bpc).Ship > 0 Then
            
            If PlayerDat(bpc).inpenTrig > 0 Then
                If NewGTC - PlayerDat(bpc).inpenTrig > 2200 Then
                    PlayerDat(bpc).inpenTrig = 0
                    HoldingArea bpc
                End If
            End If
            If PlayerDat(bpc).AI And 0 Then AutoPilot bpc 'HUGE damage to server speed
            CharUpdate bpc
            Call touching(bpc)
            '
            If NewGTC - PlayerDat(bpc).WepSyncT > 2000 And PlayerDat(bpc).playing Then
                WepSync bpc
                lNewMsg = MSG_WEPSYNC
                lNewOffSet = 0
                ReDim oNewMsg(0)
                AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
                b = PlayerDat(bpc).cMissile
                AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                b = PlayerDat(bpc).cBomb
                AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                b = PlayerDat(bpc).cBouncy
                AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                b = PlayerDat(bpc).cMines
                AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                b = PlayerDat(bpc).wMissile
                AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                b = PlayerDat(bpc).wBomb
                AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                b = PlayerDat(bpc).wBouncy
                AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                b = PlayerDat(bpc).wEnergy
                AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                i = PlayerDat(bpc).Ping
                AddBufferData oNewMsg, VarPtr(i), LenB(i), lNewOffSet
                i = UBound(UniBall)
                AddBufferData oNewMsg, VarPtr(i), LenB(i), lNewOffSet
                '
                For j = 0 To UBound(UniBall)
                    b = UniBall(j).Color
                    AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                    If b > 0 Then
                        i = UniBall(j).BallX
                        AddBufferData oNewMsg, VarPtr(i), LenB(i), lNewOffSet
                        i = UniBall(j).BallY
                        AddBufferData oNewMsg, VarPtr(i), LenB(i), lNewOffSet
                    End If
                Next
                '
                'dps.SendTo PlayerDat(bpc).ID, oNewMsg, 0, DPNSEND_NOLOOPBACK Or DPNSEND_PRIORITY_HIGH
                SendTo oNewMsg, CInt(bpc), False
                
                PlayerDat(bpc).WepSyncT = NewGTC
                PlayerDat(bpc).PingTick = NewGTC
            End If
            '
            If PlayerDat(bpc).Warping Then
                If NewGTC - PlayerDat(bpc).Warped > 1400 Then
                    PlayerDat(bpc).WarpDone = NewGTC
                    PlayerDat(bpc).Warping = False
                    lNewMsg = MSG_FORCEPOS
                    lNewOffSet = 0
                    ReDim oNewMsg(0)
                    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
                    AddBufferData oNewMsg, VarPtr(bpc), LenB(bpc), lNewOffSet
                    b = 252 'warp them
                    AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                    X = PlayerDat(bpc).WarpX - 8
                    AddBufferData oNewMsg, VarPtr(X), LenB(X), lNewOffSet
                    X = PlayerDat(bpc).WarpY - 8
                    AddBufferData oNewMsg, VarPtr(X), LenB(X), lNewOffSet
                    'dps.SendTo gAllID, oNewMsg, 0, DPNSEND_NOLOOPBACK Or DPNSEND_GUARANTEED Or DPNSEND_PRIORITY_HIGH
                    SendTo oNewMsg, -1
                    lNewMsg = MSG_WARPING
                    lNewOffSet = 0
                    ReDim oNewMsg(0)
                    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
                    b = bpc
                    AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                    b = 0
                    AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                    'dps.SendTo gAllID, oNewMsg, 0, DPNSEND_GUARANTEED Or DPNSEND_NOLOOPBACK Or DPNSEND_PRIORITY_HIGH
                    SendTo oNewMsg, -1
                End If
            End If
            CheckWIN bpc
            '
out2:
            If PlayerDat(bpc).die Then
                PlayerNull bpc
                If ConnectionOK Then
                    lNewMsg = SVR_LEFT
                    lNewOffSet = 0
                    ReDim oNewMsg(0)
                    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
                    AddBufferData oNewMsg, VarPtr(bpc), LenB(bpc), lNewOffSet
                    SendTo2 oNewMsg, 0
                End If
                For b = 1 To UBound(PlayerDat)
                    If PlayerDat(b).Ship > 0 Then Exit For
                Next
            End If
        End If
    Next
    
    For i = 1 To UBound(PowerVal)
        Randomize
        If NewGTC - PowerTick(i) > PowerLife(i) - 6000 Then
            If (PowerEffect(i) = 2 Or PowerEffect(i) = 0) And NewGTC - PowerTick(i) < PowerLife(i) Then GoTo skip
            If PowerEffect(i) = 0 Then PowerVal(i) = 4 + Int(4 * Rnd)
            PowerEffect(i) = PowerEffect(i) + 1
            If PowerEffect(i) = 3 Then
                PowerEffect(i) = 0
                PowerLife(i) = 30000 + Int(Rnd * 30000)
                PowerTick(i) = NewGTC
            End If
            If PowerEffect(i) = 1 Then
                PowerLife(i) = 30000 + Int(Rnd * 30000)
                PowerTick(i) = NewGTC
            End If
            lNewMsg = MSG_POWERUP
            lNewOffSet = 0
            ReDim oNewMsg(0)
            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
            AddBufferData oNewMsg, VarPtr(i), LenB(i), lNewOffSet
            b = PowerVal(i)
            If b > 4 Then b = b - 4
            AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
            b = PowerEffect(i)
            AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
            j = PowerX(i)
            AddBufferData oNewMsg, VarPtr(j), LenB(j), lNewOffSet
            j = PowerY(i)
            AddBufferData oNewMsg, VarPtr(j), LenB(j), lNewOffSet
            SendTo oNewMsg, -1
        End If
skip:
    Next
leave:
    speed = 0.0715 * (NewGTC - enginetime)
    enginetime = NewGTC
End Function

Public Function GetSettingLong(ByVal hKey As Long, ByVal strPath As String, ByVal strValue As String, Optional Default As Long) As Long
    Dim lRegResult As Long
    Dim lValueType As Long
    Dim lBuffer As Long
    Dim lDataBufferSize As Long
    Dim hCurKey As Long
    'Set up default value
    If Not IsEmpty(Default) Then
        GetSettingLong = Default
    Else
        GetSettingLong = 0
    End If
    lRegResult = RegOpenKey(hKey, strPath, hCurKey)
    lDataBufferSize = 4 '4 bytes = 32 bits = long
    lRegResult = RegQueryValueEx(hCurKey, strValue, 0&, lValueType, lBuffer, lDataBufferSize)
    If lRegResult = ERROR_SUCCESS Then
        If lValueType = REG_DWORD Then
            GetSettingLong = lBuffer
        End If
    Else
        'there is a problem
    End If
    lRegResult = RegCloseKey(hCurKey)
End Function

Public Sub AnimShrapnel(i As Integer)
    Dim j As Integer, xt As Integer, yt As Integer, ShrapF As Integer, OldDist As Integer
    Dim d As Integer, R As Integer, X As Integer, tmp As Integer
    OldDist = ShrapDist(i)
    ShrapDist(i) = ShrapDist(i) + ShrapSpeed(i) * speed
    For j = 0 To 30
        d = ShrapAngle(j, i)
        If d <> 0 Then
            For R = OldDist To ShrapDist(i)
                xt = Cos(d * Div360MultPI) * R + ExplodeX(i)
                yt = Sin(d * Div360MultPI) * R + ExplodeY(i)
                tmp = WeaponTouch(4, i, xt, yt, , True)
                If tmp <> 0 Then
                    ShrapAngle(j, i) = 0
                    Exit For
                End If
            Next
            If ShrapAngle(j, i) = 0 Then GoTo out
out:
        End If
    Next
End Sub

Public Sub ExplShrap(Who As Integer, ExplX As Integer, ExplY As Integer, ExplSpeed As Single, ExplTick As Long, ExplStart As Integer, ExplPower As Integer)
    Dim i As Integer, d As Integer
    For i = 0 To UBound(ExplodeWho) + 1
        If i > UBound(ExplodeWho) Then
            ReDim Preserve Explode(i), ExplodeX(i), ExplodeY(i), ShrapSpeed(i), ShrapTick(i)
            ReDim Preserve ShrapAngle(30, i), ShrapDist(i), ExplodeWho(i)
            Exit For
        End If
    Next
    For d = 0 To 30 Step 1
        ShrapAngle(d, i) = -90 + d * ExplPower
    Next
    Explode(i) = NewGTC
    ShrapDist(i) = ExplStart
    ShrapSpeed(i) = ExplSpeed
    ShrapTick(i) = ExplTick
    ExplodeX(i) = ExplX
    ExplodeY(i) = ExplY
    ExplodeWho(i) = Who
End Sub

Public Sub ReBoun(Who As Integer, cx As Integer, cy As Integer, Ang As Single, Re As Integer)
    Dim j As Integer
    For j = 0 To UBound(Bounce) + 1
        If j > UBound(Bounce) Then
            ReDim Preserve Bounce(j), BounceWho(j), BounceAngle(j), BounceDist(j), BounceTrav(j), BounceX(j), BounceY(j), BounceTeam(j), BounceStopMve(j)
        End If
        If Not Bounce(j) Then
            BounceWho(j) = Who
            BounceTeam(j) = PlayerDat(Who).Ship
            BounceStopMve(j) = -11
            BounceAngle(j) = Ang
            BounceDist(j) = 0
            BounceTrav(j) = BounceTrav(Re)
            BounceX(j) = cx
            BounceY(j) = cy
            Bounce(j) = True
            Exit For
        End If
    Next
End Sub

Public Sub AnimMiss(i As Integer)
    Dim ExX As Integer, j As Integer, d As Integer, OldDist As Integer
    Dim LasrX As Integer, LasrY As Integer, LasrX2 As Integer, LasrY2 As Integer
    Dim NewX As Integer, NewY As Integer, I2 As Single
    Dim NewX2 As Integer, NewY2 As Integer
    OldDist = MissDist(i)
    MissDist(i) = MissDist(i) + 4.5 * speed
    If MissDist(i) > 500 Then Miss(i) = False
    For d = OldDist To MissDist(i)
        NewX = Cos(MissAngle(i) * Div360MultPI) * d + MissX(i)
        NewY = Sin(MissAngle(i) * Div360MultPI) * d + MissY(i)
        I2 = MissAngle(i)
        j = WeaponTouch(1, i, NewX, NewY, I2, True)
        If j > 0 Then Exit For
    Next
    If j <> 0 Then
        NewX = Cos(MissAngle(i) * Div360MultPI) * (d - 1) + MissX(i)
        NewY = Sin(MissAngle(i) * Div360MultPI) * (d - 1) + MissY(i)
        If j < 0 Then ExplShrap MissWho(i), NewX, NewY, 2.4, 150, 6, 24
        Miss(i) = False
    End If
End Sub

Public Sub FireMiss(Who As Byte, lx As Integer, ly As Integer, cx As Integer, cy As Integer)
    Dim j As Integer, LasrX As Integer, LasrY As Integer
    Dim lMsg As Byte
    Dim oNewMsg() As Byte, lNewOffSet As Long
    If PlayerDat(Who).wEnergy < 40 Or PlayerDat(Who).cMissile = 0 Or PlayerDat(Who).inpen > 0 Then Exit Sub
    For j = 0 To UBound(Miss) + 1
        If j > UBound(Miss) Then
            ReDim Preserve Miss(j), MissWho(j), MissAngle(j), MissDist(j), MissX(j), MissY(j), MissTeam(j)
        End If
        If Not Miss(j) Then
            If lx = 0 Then lx = 1
            If ly = 0 Then ly = 1
            MissAngle(j) = Atn(ly / lx)
            MissAngle(j) = MissAngle(j) * Div180byPI
            If lx < 0 Then MissAngle(j) = MissAngle(j) + 180
            MissDist(j) = 0
            MissX(j) = cx + 16
            MissY(j) = cy + 16
            Miss(j) = True
            MissWho(j) = Who
            MissTeam(j) = PlayerDat(Who).Ship
            PlayerDat(Who).wEnergy = PlayerDat(Who).wEnergy - 18
            PlayerDat(Who).cMissile = PlayerDat(Who).cMissile - 1
            lMsg = MSG_MISS
            lNewOffSet = 0
            ReDim oNewMsg(0)
            AddBufferData oNewMsg, VarPtr(lMsg), LenB(lMsg), lNewOffSet
            AddBufferData oNewMsg, VarPtr(Who), LenB(Who), lNewOffSet
            AddBufferData oNewMsg, VarPtr(lx), LenB(lx), lNewOffSet
            AddBufferData oNewMsg, VarPtr(ly), LenB(ly), lNewOffSet
            AddBufferData oNewMsg, VarPtr(cx), LenB(cx), lNewOffSet
            AddBufferData oNewMsg, VarPtr(cy), LenB(cy), lNewOffSet
            SendTo oNewMsg, -2
            Exit For
        End If
    Next
End Sub

'Very Fast String Comparison Function
'                    by Steven Noonan
'   - operates at 1.5 million operations per second with
'     two strings of different lengths (non-equal)
'   - operates at 417 thousand operations per second with
'     two strings that are identical (case variation included)
Public Function StringComp(sStringOne As String, sStringTwo As String) As Boolean
    Dim Result As Integer
    If LenB(sStringOne) <> LenB(sStringTwo) Then Exit Function
    Result = StrComp(sStringOne, sStringTwo, vbTextCompare)
    If Result = 0 Then
        StringComp = True
    Else
        StringComp = False
    End If
End Function

Public Function Scramble(strString As String) As String
    Dim i As Integer, even As String, odd As String
    For i% = 1 To Len(strString$)
        If i% Mod 2 = 0 Then
            even$ = even$ & Mid$(strString$, i%, 1)
        Else
            odd$ = odd$ & Mid$(strString$, i%, 1)
        End If
    Next i
    Scramble$ = even$ & odd$
End Function

Public Function Unscramble(strString As String) As String
    Dim X As Integer, evenint As Integer, oddint As Integer
    Dim even As String, odd As String, fin As String
    X% = Len(strString$)
    X% = Int(Len(strString$) / 2)
    even$ = Mid$(strString$, 1, X%)
    odd$ = Mid$(strString$, X% + 1)
    For X = 1 To Len(strString$)
        If X% Mod 2 = 0 Then
            evenint% = evenint% + 1
            fin$ = fin$ & Mid$(even$, evenint%, 1)
        Else
            oddint% = oddint% + 1
            fin$ = fin$ & Mid$(odd$, oddint%, 1)
        End If
    Next X%
    Unscramble$ = fin$
End Function
