Attribute VB_Name = "modGame"
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

Declare Function SetWindowPos Lib "user32" (ByVal hwnd As Long, ByVal hWndInsertAfter As Long, ByVal X As Long, ByVal y As Long, ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long) As Long

Public curFreq As Currency
Public curStart As Currency
Public curEnd As Currency

Public Type RoughRect
    hTop As Byte
    hBottom As Byte
    hLeft As Byte
    hRight As Byte
End Type

Public EnableSound As Boolean, cfgm As Boolean, cfgk As Boolean, cfgwv As Boolean
Public cfgm2 As Boolean, DebugShow As Boolean

Public PSpeed As Integer
Public PBuffer As Integer

Public MHeight As Integer, MWidth As Integer

Public HealthChecksum As String

Public HoldWait As Long, PingTime As Long, HighPing As Long
'
Public Flag1() As Integer
Public Flag2() As Integer
Public Flag3() As Integer
Public Flag4() As Integer
Public Flag5() As Integer
Public FlagPole1() As Integer
Public FlagPole2() As Integer
Public FlagPole3() As Integer
Public FlagPole4() As Integer
Public FlagPole5() As Integer
Public Warp0() As Integer
Public Warp1() As Integer
Public Warp2() As Integer
Public Warp3() As Integer
Public Warp4() As Integer
Public Warp5() As Integer
Public Warp6() As Integer
Public Warp7() As Integer
Public Warp8() As Integer
Public Warp9() As Integer
Public WarpOut0() As Integer
Public WarpOut1() As Integer
Public WarpOut2() As Integer
Public WarpOut3() As Integer
Public WarpOut4() As Integer
Public WarpOut5() As Integer
Public WarpOut6() As Integer
Public WarpOut7() As Integer
Public WarpOut8() As Integer
Public WarpOut9() As Integer
Public Switches() As Integer
Public Switched() As Integer
Public FlagCarry1() As Integer
Public FlagCarry2() As Integer
Public FlagCarry3() As Integer
Public FlagCarry4() As Integer
Public FlagCarry5() As Integer
Public FlagBlink() As Boolean, FlagBlinkT() As Long, FlagBlinking() As Long
Public Captured() As Boolean
Public FlagCap() As Integer
Public WhoTeam() As Integer
Public FlagStatus() As Integer
Public Hold1() As Integer
Public Hold2() As Integer
Public Hold3() As Integer
Public Hold4() As Integer
Public Spawn1() As Integer
Public Spawn2() As Integer
Public Spawn3() As Integer
Public Spawn4() As Integer

Public Type LandMine
    X As Integer
    y As Integer
    Who As Integer
    Color As Integer
    Tick As Long
    Idx As Integer
End Type
Public Mines() As LandMine

Public PowerUp() As Byte
Public PowerX() As Integer
Public PowerY() As Integer
Public PowerIndex() As Integer
Public PowerEffect() As Byte
Public PowerTick() As Long
Public PowerFrame() As Byte
Public PowerFrameT() As Long

Public IsHit() As Boolean, WhoHit() As Integer, HitX() As Integer, HitY() As Integer

Public MapPlay As String, MapName As String
Public HData As HeadMap, HDataNames As hStrings, RoughTile(4000) As RoughRect

Public Type Recharge
    LaserDamage As Byte
    SpecialDamage As Byte
    RechargeRate As Byte
    Mines As Byte
    HldTme As Long
End Type
Public WepRge As Recharge

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

Public RMData() As Byte, RMCount As Long
Public Animations() As Integer, AnimOffset() As Byte
Public Collision() As Integer, SourceX() As Integer, SourceY() As Integer
Public MapX As Integer, MapY As Integer
Public MeX As Integer, MeY As Integer, TmpSX() As Integer, TmpSY() As Integer

Public Serial_Number As Long
Public g_cursorx As Single, CursSpeed As Single
Public g_cursory As Single, Pointer As Integer, PointFrame As Integer

Public AnimFX() As Integer, AnimFY() As Integer, AnimFS() As Byte, ChatQ As Boolean
Public FrameCount() As Byte, AnimSpeed() As Byte, AnimFrames() As Integer, Popping() As Boolean, PopX() As Integer, PopY() As Integer
Public PopAnimF() As Single, SourceTile(255, 255) As Integer
Public AnimCount(255, 255) As Single, SourceTileX() As Integer, SourceTileY() As Integer
Public ScoreView As Boolean, Hz As Byte, TimeLimit As Long, TimeClock As Long, TimeTick As Long
Public KEYColor As Long
Public TeamScores(4) As Integer, NavMenu As Integer, MenuMenu As Integer
Public HostAddy As String, UserName As String, ExitMSG As String, Port As Integer
Public Speed As clsDouble, MeNum As Byte
Public Health As clsByte, Weapon As Integer, LastKey As Integer
Public FPSRec As Long, Racing As Boolean, Mem As String, VMem As String, FMem As String, SMem As String, LastMemCheck As Long
Public Cruise As Boolean

Public RedIndex(255) As Byte, BlueIndex(255) As Byte, PurpIndex(255) As Byte
Public EventHandle As Long, DIKey(33, 1) As Byte ', FlipSkip As Integer
Public rChars(95) As RECT, rChars2(95) As RECT, PlayerScroll As Integer, PlayerSelected As Integer, NoD3D As Boolean
Public AnimateMenu As Boolean, MenuPend As Integer, Ignoring As Boolean, Ignored() As String
Public MoveBuffer(10000) As Byte, MoveBufferPtr As Integer, MovePlay As Boolean, MoveCounter As Integer
Public Paletted As Boolean, NoBlending As Boolean, LowMem As Boolean, NoFarplane As Boolean, LowVRAM As Boolean

Public LoadCap As String
Public LoadBool As Boolean

Private Type PlayerValues
    Nick As String
    Ship As Byte
    Score As Integer
    Admin As Byte
    KeyIs As Byte
    charX As Single
    charY As Single
    animX As Byte
    animY As Byte
    MoveX As Integer
    MoveY As Integer
    InPen As Boolean
    HoldingPen As Long
    Invisible As Boolean
    ArmCrt As Boolean
    ArmCrtTme As Long
    Warping As Boolean
    Warped As Long
    FlagWho As Byte
    FlagID As Byte
    Mode As Integer
    NextSync As Long
    DevCheat As Byte
End Type
Public Players() As PlayerValues


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
End Type
Public UniBall() As UBALL

Public SndCnt As Integer, LDamage(4) As Integer, SDamage(4) As Integer, SDamage2(4) As Integer, LDamage2(4) As Integer
Public LaserDamage1 As Boolean

Public NavRect(8) As RECT, MenuRect(3) As RECT, Menu4Rect(1) As RECT, Menu2Rect(4) As RECT, Menu3Rect(12) As RECT, AdRect As RECT
Public rBombExp(10) As RECT, rShipExp(23) As RECT, rBmbSmoke(8) As RECT, rMissSmoke(8) As RECT, rBomb(4) As RECT, rShrapnel(1) As RECT
Public rShipHit(6) As RECT, rConfig(8) As RECT, rWepAmmo(1) As RECT, rHelp(7) As RECT, Menu9Rect As RECT
Public RectsRet() As Integer, RetCollision() As Integer, PlayerOptR(5) As RECT, PlayerOpt As Integer

Public TxtBuild As String, Chat() As String, ChatClean As Long

Public Sub BuildRects()
    Dim I As Integer
    NavRect(0).Top = 0
    NavRect(0).Bottom = NavRect(0).Top + 32
    NavRect(0).Left = ResX - 20
    NavRect(0).Right = ResX
    NavRect(1).Top = 32
    NavRect(1).Bottom = NavRect(1).Top + 32
    NavRect(1).Left = ResX - 20
    NavRect(1).Right = ResX
    NavRect(2).Top = NavRect(1).Top + 32
    NavRect(2).Bottom = NavRect(2).Top + 32
    NavRect(2).Left = ResX - 20
    NavRect(2).Right = ResX
    NavRect(3).Top = NavRect(2).Top + 32
    NavRect(3).Bottom = NavRect(3).Top + 32
    NavRect(3).Left = ResX - 20
    NavRect(3).Right = ResX
    NavRect(4).Top = 162
    NavRect(4).Bottom = NavRect(4).Top + 32
    NavRect(4).Left = ResX - 20
    NavRect(4).Right = ResX
    NavRect(5).Top = 229
    NavRect(5).Bottom = NavRect(5).Top + 32
    NavRect(5).Left = ResX - 20
    NavRect(5).Right = ResX
    NavRect(6).Top = NavRect(5).Bottom
    NavRect(6).Bottom = NavRect(6).Top + 32
    NavRect(6).Left = ResX - 20
    NavRect(6).Right = ResX
    NavRect(7).Top = NavRect(6).Bottom
    NavRect(7).Bottom = NavRect(7).Top + 32
    NavRect(7).Left = ResX - 20
    NavRect(7).Right = ResX
    NavRect(8).Top = NavRect(7).Bottom
    NavRect(8).Bottom = NavRect(8).Top + 32
    NavRect(8).Left = ResX - 20
    NavRect(8).Right = ResX
    MenuRect(0).Top = 37
    MenuRect(0).Bottom = MenuRect(0).Top + 13
    MenuRect(0).Left = ResX - 130
    MenuRect(0).Right = MenuRect(0).Left + 90
    MenuRect(1).Top = MenuRect(0).Bottom
    MenuRect(1).Bottom = MenuRect(1).Top + 13
    MenuRect(1).Left = ResX - 130
    MenuRect(1).Right = MenuRect(0).Left + 90
    MenuRect(2).Top = MenuRect(1).Bottom
    MenuRect(2).Bottom = MenuRect(2).Top + 13
    MenuRect(2).Left = ResX - 130
    MenuRect(2).Right = MenuRect(0).Left + 90
    MenuRect(3).Top = MenuRect(2).Bottom
    MenuRect(3).Bottom = MenuRect(3).Top + 16
    MenuRect(3).Left = ResX - 130
    MenuRect(3).Right = MenuRect(0).Left + 90
    '
    Menu2Rect(0).Top = CenterY
    Menu2Rect(0).Bottom = Menu2Rect(0).Top + 45
    Menu2Rect(0).Left = CenterX - 132
    Menu2Rect(0).Right = 60 + Menu2Rect(0).Left
    Menu2Rect(1).Top = Menu2Rect(0).Top
    Menu2Rect(1).Bottom = Menu2Rect(0).Bottom
    Menu2Rect(1).Left = Menu2Rect(0).Right
    Menu2Rect(1).Right = 60 + Menu2Rect(1).Left
    Menu2Rect(2).Top = Menu2Rect(0).Top
    Menu2Rect(2).Bottom = Menu2Rect(0).Bottom
    Menu2Rect(2).Left = Menu2Rect(1).Right
    Menu2Rect(2).Right = 60 + Menu2Rect(2).Left
    Menu2Rect(3).Top = Menu2Rect(0).Top
    Menu2Rect(3).Bottom = Menu2Rect(0).Bottom
    Menu2Rect(3).Left = Menu2Rect(2).Right
    Menu2Rect(3).Right = 60 + Menu2Rect(3).Left
    Menu2Rect(4).Top = CenterY + 55
    Menu2Rect(4).Bottom = Menu2Rect(4).Top + 20
    Menu2Rect(4).Left = CenterX - 146
    Menu2Rect(4).Right = Menu2Rect(4).Left + 58
    '
    Menu4Rect(0).Top = CenterY + 7
    Menu4Rect(0).Bottom = Menu4Rect(0).Top + 20
    Menu4Rect(0).Left = CenterX - 93
    Menu4Rect(0).Right = Menu4Rect(0).Left + 59
    Menu4Rect(1).Top = Menu4Rect(0).Top
    Menu4Rect(1).Bottom = Menu4Rect(1).Top + 20
    Menu4Rect(1).Left = Menu4Rect(0).Left + 142
    Menu4Rect(1).Right = Menu4Rect(1).Left + 59
    'Bomb Explode
    rBombExp(0).Left = 17
    rBombExp(0).Right = rBombExp(0).Left + 13
    rBombExp(0).Top = 14
    rBombExp(0).Bottom = rBombExp(0).Top + 12
    rBombExp(1).Left = 74
    rBombExp(1).Right = rBombExp(1).Left + 25
    rBombExp(1).Top = 8
    rBombExp(1).Bottom = rBombExp(1).Top + 22
    rBombExp(2).Left = 135
    rBombExp(2).Right = rBombExp(2).Left + 30
    rBombExp(2).Top = 6
    rBombExp(2).Bottom = rBombExp(2).Top + 27
    rBombExp(3).Left = 195
    rBombExp(3).Right = rBombExp(3).Left + 37
    rBombExp(3).Top = 2
    rBombExp(3).Bottom = rBombExp(3).Top + 34
    rBombExp(4).Left = 257
    rBombExp(4).Right = rBombExp(4).Left + 41
    rBombExp(4).Top = 0
    rBombExp(4).Bottom = rBombExp(4).Top + 37
    rBombExp(5).Left = 3
    rBombExp(5).Right = rBombExp(5).Left + 41
    rBombExp(5).Top = 43
    rBombExp(5).Bottom = rBombExp(5).Top + 38
    '
    rBombExp(6).Left = 67
    rBombExp(6).Right = rBombExp(6).Left + 42
    rBombExp(6).Top = 43
    rBombExp(6).Bottom = rBombExp(6).Top + 38
    rBombExp(7).Left = 130
    rBombExp(7).Right = rBombExp(7).Left + 44
    rBombExp(7).Top = 42
    rBombExp(7).Bottom = rBombExp(7).Top + 40
    rBombExp(8).Left = 194
    rBombExp(8).Right = rBombExp(8).Left + 45
    rBombExp(8).Top = 42
    rBombExp(8).Bottom = rBombExp(8).Top + 40
    rBombExp(9).Left = 256
    rBombExp(9).Right = rBombExp(9).Left + 48
    rBombExp(9).Top = 40
    rBombExp(9).Bottom = rBombExp(9).Top + 43
    rBombExp(10).Left = 319
    rBombExp(10).Right = rBombExp(10).Left + 50
    rBombExp(10).Top = 40
    rBombExp(10).Bottom = rBombExp(10).Top + 43
    
    'Ship Explode
    rShipExp(0).Left = 24
    rShipExp(0).Right = rShipExp(0).Left + 14
    rShipExp(0).Top = 126
    rShipExp(0).Bottom = rShipExp(0).Top + 13
    rShipExp(1).Left = 85
    rShipExp(1).Right = rShipExp(1).Left + 19
    rShipExp(1).Top = 123
    rShipExp(1).Bottom = rShipExp(1).Top + 18
    rShipExp(2).Left = 145
    rShipExp(2).Right = rShipExp(2).Left + 26
    rShipExp(2).Top = 120
    rShipExp(2).Bottom = rShipExp(2).Top + 25
    rShipExp(3).Left = 205
    rShipExp(3).Right = rShipExp(3).Left + 33
    rShipExp(3).Top = 116
    rShipExp(3).Bottom = rShipExp(3).Top + 32
    rShipExp(4).Left = 266
    rShipExp(4).Right = rShipExp(4).Left + 40
    rShipExp(4).Top = 113
    rShipExp(4).Bottom = rShipExp(4).Top + 39
    rShipExp(5).Left = 328
    rShipExp(5).Right = rShipExp(5).Left + 45
    rShipExp(5).Top = 110
    rShipExp(5).Bottom = rShipExp(5).Top + 45
    rShipExp(6).Left = 6
    rShipExp(6).Right = rShipExp(6).Left + 50
    rShipExp(6).Top = 172
    rShipExp(6).Bottom = rShipExp(6).Top + 49
    rShipExp(7).Left = 69
    rShipExp(7).Right = rShipExp(7).Left + 52
    rShipExp(7).Top = 170
    rShipExp(7).Bottom = rShipExp(7).Top + 52
    rShipExp(8).Left = 133
    rShipExp(8).Right = rShipExp(8).Left + 53
    rShipExp(8).Top = 170
    rShipExp(8).Bottom = rShipExp(8).Top + 53
    rShipExp(9).Left = 196
    rShipExp(9).Right = rShipExp(9).Left + 55
    rShipExp(9).Top = 169
    rShipExp(9).Bottom = rShipExp(9).Top + 55
    rShipExp(10).Left = 260
    rShipExp(10).Right = rShipExp(10).Left + 56
    rShipExp(10).Top = 168
    rShipExp(10).Bottom = rShipExp(10).Top + 56
    rShipExp(11).Left = 324
    rShipExp(11).Right = rShipExp(11).Left + 57
    rShipExp(11).Top = 168
    rShipExp(11).Bottom = rShipExp(11).Top + 57
    rShipExp(12).Left = 3
    rShipExp(12).Right = rShipExp(12).Left + 58
    rShipExp(12).Top = 231
    rShipExp(12).Bottom = rShipExp(12).Top + 58
    rShipExp(13).Left = 67
    rShipExp(13).Right = rShipExp(13).Left + 59
    rShipExp(13).Top = 231
    rShipExp(13).Bottom = rShipExp(13).Top + 59
    rShipExp(14).Left = 131
    rShipExp(14).Right = rShipExp(14).Left + 59
    rShipExp(14).Top = 231
    rShipExp(14).Bottom = rShipExp(14).Top + 59
    rShipExp(15).Left = 195
    rShipExp(15).Right = rShipExp(15).Left + 59
    rShipExp(15).Top = 231
    rShipExp(15).Bottom = rShipExp(15).Top + 59
    rShipExp(16).Left = 258
    rShipExp(16).Right = rShipExp(16).Left + 60
    rShipExp(16).Top = 230
    rShipExp(16).Bottom = rShipExp(16).Top + 60
    rShipExp(17).Left = 322
    rShipExp(17).Right = rShipExp(17).Left + 61
    rShipExp(17).Top = 230
    rShipExp(17).Bottom = rShipExp(17).Top + 61
    rShipExp(18).Left = 2
    rShipExp(18).Right = rShipExp(18).Left + 61
    rShipExp(18).Top = 294
    rShipExp(18).Bottom = rShipExp(18).Top + 61
    rShipExp(19).Left = 66
    rShipExp(19).Right = rShipExp(19).Left + 61
    rShipExp(19).Top = 294
    rShipExp(19).Bottom = rShipExp(19).Top + 61
    rShipExp(20).Left = 130
    rShipExp(20).Right = rShipExp(20).Left + 61
    rShipExp(20).Top = 294
    rShipExp(20).Bottom = rShipExp(20).Top + 61
    rShipExp(21).Left = 194
    rShipExp(21).Right = rShipExp(21).Left + 61
    rShipExp(21).Top = 294
    rShipExp(21).Bottom = rShipExp(21).Top + 61
    rShipExp(22).Left = 258
    rShipExp(22).Right = rShipExp(22).Left + 61
    rShipExp(22).Top = 294
    rShipExp(22).Bottom = rShipExp(22).Top + 61
    rShipExp(23).Left = 322
    rShipExp(23).Right = rShipExp(23).Left + 61
    rShipExp(23).Top = 294
    rShipExp(23).Bottom = rShipExp(23).Top + 61
    'bomb smoke
    rBmbSmoke(0).Left = 394
    rBmbSmoke(0).Right = rBmbSmoke(0).Left + 5
    rBmbSmoke(0).Top = 23
    rBmbSmoke(0).Bottom = rBmbSmoke(0).Top + 6
    rBmbSmoke(1).Left = 404
    rBmbSmoke(1).Right = rBmbSmoke(1).Left + 8
    rBmbSmoke(1).Top = 24
    rBmbSmoke(1).Bottom = rBmbSmoke(1).Top + 8
    rBmbSmoke(2).Left = 415
    rBmbSmoke(2).Right = rBmbSmoke(2).Left + 13
    rBmbSmoke(2).Top = 22
    rBmbSmoke(2).Bottom = rBmbSmoke(2).Top + 13
    rBmbSmoke(3).Left = 434
    rBmbSmoke(3).Right = rBmbSmoke(3).Left + 15
    rBmbSmoke(3).Top = 23
    rBmbSmoke(3).Bottom = rBmbSmoke(3).Top + 15
    rBmbSmoke(4).Left = 454
    rBmbSmoke(4).Right = rBmbSmoke(4).Left + 17
    rBmbSmoke(4).Top = 22
    rBmbSmoke(4).Bottom = rBmbSmoke(4).Top + 16
    rBmbSmoke(5).Left = 477
    rBmbSmoke(5).Right = rBmbSmoke(5).Left + 17
    rBmbSmoke(5).Top = 23
    rBmbSmoke(5).Bottom = rBmbSmoke(5).Top + 17
    rBmbSmoke(6).Left = 501
    rBmbSmoke(6).Right = rBmbSmoke(6).Left + 17
    rBmbSmoke(6).Top = 23
    rBmbSmoke(6).Bottom = rBmbSmoke(6).Top + 17
    rBmbSmoke(7).Left = 522
    rBmbSmoke(7).Right = rBmbSmoke(7).Left + 17
    rBmbSmoke(7).Top = 21
    rBmbSmoke(7).Bottom = rBmbSmoke(7).Top + 17
    rBmbSmoke(8).Left = 546
    rBmbSmoke(8).Right = rBmbSmoke(8).Left + 17
    rBmbSmoke(8).Top = 21
    rBmbSmoke(8).Bottom = rBmbSmoke(8).Top + 17
    'missile smoke
    rMissSmoke(0).Left = 395
    rMissSmoke(0).Right = rMissSmoke(0).Left + 3
    rMissSmoke(0).Top = 111
    rMissSmoke(0).Bottom = rMissSmoke(0).Top + 4
    rMissSmoke(1).Left = 400
    rMissSmoke(1).Right = rMissSmoke(1).Left + 4
    rMissSmoke(1).Top = 111
    rMissSmoke(1).Bottom = rMissSmoke(1).Top + 5
    rMissSmoke(2).Left = 405
    rMissSmoke(2).Right = rMissSmoke(2).Left + 8
    rMissSmoke(2).Top = 111
    rMissSmoke(2).Bottom = rMissSmoke(2).Top + 7
    rMissSmoke(3).Left = 415
    rMissSmoke(3).Right = rMissSmoke(3).Left + 8
    rMissSmoke(3).Top = 111
    rMissSmoke(3).Bottom = rMissSmoke(3).Top + 8
    rMissSmoke(4).Left = 425
    rMissSmoke(4).Right = rMissSmoke(4).Left + 9
    rMissSmoke(4).Top = 110
    rMissSmoke(4).Bottom = rMissSmoke(4).Top + 9
    rMissSmoke(5).Left = 436
    rMissSmoke(5).Right = rMissSmoke(5).Left + 10
    rMissSmoke(5).Top = 111
    rMissSmoke(5).Bottom = rMissSmoke(5).Top + 9
    rMissSmoke(6).Left = 448
    rMissSmoke(6).Right = rMissSmoke(6).Left + 10
    rMissSmoke(6).Top = 111
    rMissSmoke(6).Bottom = rMissSmoke(6).Top + 9
    rMissSmoke(7).Left = 459
    rMissSmoke(7).Right = rMissSmoke(7).Left + 9
    rMissSmoke(7).Top = 110
    rMissSmoke(7).Bottom = rMissSmoke(7).Top + 9
    rMissSmoke(8).Left = 471
    rMissSmoke(8).Right = rMissSmoke(8).Left + 9
    rMissSmoke(8).Top = 110
    rMissSmoke(8).Bottom = rMissSmoke(8).Top + 9
    'Bomb pics
    rBomb(0).Left = 389
    rBomb(0).Right = rBomb(0).Left + 5
    rBomb(0).Top = 4
    rBomb(0).Bottom = rBomb(0).Top + 5
    rBomb(1).Left = 405
    rBomb(1).Right = rBomb(1).Left + 7
    rBomb(1).Top = 3
    rBomb(1).Bottom = rBomb(1).Top + 7
    rBomb(2).Left = 420
    rBomb(2).Right = rBomb(2).Left + 9
    rBomb(2).Top = 2
    rBomb(2).Bottom = rBomb(2).Top + 9
    rBomb(3).Left = 435
    rBomb(3).Right = rBomb(3).Left + 11
    rBomb(3).Top = 1
    rBomb(3).Bottom = rBomb(3).Top + 11
    rBomb(4).Left = 450
    rBomb(4).Right = rBomb(4).Left + 13
    rBomb(4).Top = 0
    rBomb(4).Bottom = rBomb(4).Top + 13
    'explode Shrapnel
    rShrapnel(0).Left = 386
    rShrapnel(0).Right = rShrapnel(0).Left + 5
    rShrapnel(0).Top = 174
    rShrapnel(0).Bottom = rShrapnel(0).Top + 5
    rShrapnel(1).Left = 393
    rShrapnel(1).Right = rShrapnel(1).Left + 3
    rShrapnel(1).Top = 175
    rShrapnel(1).Bottom = rShrapnel(1).Top + 3
    'ship hit
    rShipHit(0).Left = 4 + 383
    rShipHit(0).Right = rShipHit(0).Left + 2
    rShipHit(0).Top = 157
    rShipHit(0).Bottom = rShipHit(0).Top + 2
    rShipHit(1).Left = 8 + 383
    rShipHit(1).Right = rShipHit(1).Left + 4
    rShipHit(1).Top = 157
    rShipHit(1).Bottom = rShipHit(1).Top + 4
    rShipHit(2).Left = 13 + 383
    rShipHit(2).Right = rShipHit(2).Left + 6
    rShipHit(2).Top = 157
    rShipHit(2).Bottom = rShipHit(2).Top + 6
    rShipHit(3).Left = 20 + 383
    rShipHit(3).Right = rShipHit(3).Left + 9
    rShipHit(3).Top = 157
    rShipHit(3).Bottom = rShipHit(3).Top + 9
    rShipHit(4).Left = 30 + 383
    rShipHit(4).Right = rShipHit(4).Left + 11
    rShipHit(4).Top = 157
    rShipHit(4).Bottom = rShipHit(4).Top + 11
    rShipHit(5).Left = 43 + 383
    rShipHit(5).Right = rShipHit(5).Left + 11
    rShipHit(5).Top = 157
    rShipHit(5).Bottom = rShipHit(5).Top + 11
    rShipHit(6).Left = 57 + 383
    rShipHit(6).Right = rShipHit(6).Left + 13
    rShipHit(6).Top = 157
    rShipHit(6).Bottom = rShipHit(6).Top + 13
    'configuration
    Dim xt As Integer, yt As Integer
    xt = CenterX - 84
    yt = CenterY - 55
    rConfig(0).Top = yt
    rConfig(0).Bottom = rConfig(0).Top + 10
    rConfig(0).Left = xt
    rConfig(0).Right = rConfig(0).Left + 10
    rConfig(1).Top = yt + 34
    rConfig(1).Bottom = rConfig(1).Top + 10
    rConfig(1).Left = xt
    rConfig(1).Right = rConfig(1).Left + 10
    rConfig(2).Top = yt + 34
    rConfig(2).Bottom = rConfig(2).Top + 10
    rConfig(2).Left = xt + 90
    rConfig(2).Right = rConfig(2).Left + 10
    rConfig(3).Top = yt + 60
    rConfig(3).Bottom = rConfig(3).Top + 10
    rConfig(3).Left = xt
    rConfig(3).Right = rConfig(3).Left + 10
    rConfig(4).Top = yt + 60
    rConfig(4).Bottom = rConfig(4).Top + 10
    rConfig(4).Left = xt + 90
    rConfig(4).Right = rConfig(4).Left + 10
    rConfig(5).Top = yt + 86
    rConfig(5).Bottom = rConfig(5).Top + 10
    rConfig(5).Left = xt
    rConfig(5).Right = rConfig(5).Left + 10
    rConfig(6).Top = yt + 86
    rConfig(6).Bottom = rConfig(6).Top + 10
    rConfig(6).Left = xt + 90
    rConfig(6).Right = rConfig(6).Left + 10
    rConfig(7).Top = yt + 110
    rConfig(7).Bottom = rConfig(7).Top + 20
    rConfig(7).Left = xt + 55
    rConfig(7).Right = rConfig(7).Left + 59
    rConfig(8).Top = 225
    rConfig(8).Bottom = 383
    rConfig(8).Left = 305
    rConfig(8).Right = 496
    'player list
    Menu3Rect(0).Left = ResX - 41
    Menu3Rect(0).Right = Menu3Rect(0).Left + 15
    Menu3Rect(0).Top = 25
    Menu3Rect(0).Bottom = Menu3Rect(0).Top + 8
    Menu3Rect(1).Left = ResX - 41
    Menu3Rect(1).Right = Menu3Rect(1).Left + 15
    Menu3Rect(1).Top = 89
    Menu3Rect(1).Bottom = Menu3Rect(1).Top + 8
    For I = 3 To 12
        Menu3Rect(I).Left = ResX - 132
        Menu3Rect(I).Right = Menu3Rect(I).Left + 91
        Menu3Rect(I).Top = 28 + (I - 3) * 7
        Menu3Rect(I).Bottom = Menu3Rect(I).Top + 7
    Next
    '452, 156
    PlayerOptR(0).Left = ResX - 135
    PlayerOptR(0).Right = PlayerOptR(0).Left + 50
    PlayerOptR(0).Top = 97
    PlayerOptR(0).Bottom = PlayerOptR(0).Top + 12
    PlayerOptR(1).Left = ResX - 85
    PlayerOptR(1).Right = PlayerOptR(1).Left + 50
    PlayerOptR(1).Top = 97
    PlayerOptR(1).Bottom = PlayerOptR(1).Top + 12
    PlayerOptR(2).Left = ResX - 135
    PlayerOptR(2).Right = PlayerOptR(2).Left + 25
    PlayerOptR(2).Top = 97
    PlayerOptR(2).Bottom = PlayerOptR(2).Top + 12
    PlayerOptR(3).Left = ResX - 110
    PlayerOptR(3).Right = PlayerOptR(3).Left + 25
    PlayerOptR(3).Top = 97
    PlayerOptR(3).Bottom = PlayerOptR(3).Top + 12
    PlayerOptR(4).Left = ResX - 85
    PlayerOptR(4).Right = PlayerOptR(4).Left + 25
    PlayerOptR(4).Top = 97
    PlayerOptR(4).Bottom = PlayerOptR(4).Top + 12
    PlayerOptR(5).Left = ResX - 60
    PlayerOptR(5).Right = PlayerOptR(5).Left + 25
    PlayerOptR(5).Top = 97
    PlayerOptR(5).Bottom = PlayerOptR(5).Top + 12
    
    xt = CenterX - 195
    yt = CenterY - 90
    rHelp(0).Top = yt + 110
    rHelp(0).Bottom = rHelp(0).Top + 10
    rHelp(0).Left = xt
    rHelp(0).Right = rHelp(0).Left + 165
    rHelp(1).Top = yt + 120
    rHelp(1).Bottom = rHelp(1).Top + 10
    rHelp(1).Left = xt
    rHelp(1).Right = rHelp(1).Left + 165
    rHelp(2).Top = yt + 130
    rHelp(2).Bottom = rHelp(2).Top + 10
    rHelp(2).Left = xt
    rHelp(2).Right = rHelp(2).Left + 165
    rHelp(3).Top = yt + 170
    rHelp(3).Bottom = rHelp(3).Top + 20
    rHelp(3).Left = xt + 5
    rHelp(3).Right = rHelp(3).Left + 165
    xt = CenterX - 180
    yt = CenterY + 110
    rHelp(4).Top = yt
    rHelp(4).Bottom = rHelp(4).Top + 10
    rHelp(4).Left = xt
    rHelp(4).Right = rHelp(4).Left + 100
    xt = CenterX - 180
    yt = CenterY + 113
    rHelp(5).Top = yt
    rHelp(5).Bottom = rHelp(5).Top + 10
    rHelp(5).Left = xt
    rHelp(5).Right = rHelp(5).Left + 100
    xt = xt + 200
    rHelp(6).Top = yt
    rHelp(6).Bottom = rHelp(6).Top + 10
    rHelp(6).Left = xt
    rHelp(6).Right = rHelp(6).Left + 100
    xt = CenterX - 180
    yt = CenterY + 63
    Menu9Rect.Left = xt
    Menu9Rect.Right = xt + 58
    Menu9Rect.Top = yt
    Menu9Rect.Bottom = yt + 20
    
    'adverts
    AdRect.Top = ResY - 74
    AdRect.Bottom = AdRect.Top + 60
    AdRect.Left = (ResX / 2) - 234
    AdRect.Right = AdRect.Left + 468
End Sub

Public Function CheckRectsAd() As Boolean
    Dim rTemp As RECT, rMouse As RECT, I As Integer
    With rMouse
        .Left = g_cursorx
        .Right = .Left + 32
        .Top = g_cursory
        .Bottom = .Top + 1
    End With
    If IntersectRect(rTemp, AdRect, rMouse) Then
        CheckRectsAd = True
        Exit Function
    End If
End Function

Public Function CheckRectsNav() As Integer
    Dim rTemp As RECT, rMouse As RECT, I As Integer
    With rMouse
        .Left = g_cursorx
        .Right = .Left + 32
        .Top = g_cursory
        .Bottom = .Top + 1
    End With
    For I = 0 To UBound(NavRect)
        If I < 8 Then
            If IntersectRect(rTemp, NavRect(I), rMouse) Then
                CheckRectsNav = I + 1
                Exit Function
            End If
        End If
    Next
End Function

Public Function CheckRectsMenu4() As Integer
    Dim rTemp As RECT, rMouse As RECT, I As Integer
    With rMouse
        .Left = g_cursorx
        .Right = .Left + 32
        .Top = g_cursory
        .Bottom = .Top + 1
    End With
    For I = 0 To UBound(MenuRect)
        If IntersectRect(rTemp, MenuRect(I), rMouse) Then
            CheckRectsMenu4 = I + 1
            Exit Function
        End If
    Next
End Function

Public Function CheckRectsMenuMenu1() As Integer
    Dim rTemp As RECT, rMouse As RECT, I As Integer
    With rMouse
        .Left = g_cursorx
        .Right = .Left + 1
        .Top = g_cursory
        .Bottom = .Top + 1
    End With
    If MenuMenu = 1 Then
        For I = 0 To 3
            If IntersectRect(rTemp, rHelp(I), rMouse) Then
                CheckRectsMenuMenu1 = I + 1
                Exit Function
            End If
        Next
    End If
    If MenuMenu = 5 Then
        If IntersectRect(rTemp, rHelp(4), rMouse) Then
            CheckRectsMenuMenu1 = 5
            Exit Function
        End If
    End If
    If MenuMenu = 6 Then
        If IntersectRect(rTemp, rHelp(5), rMouse) Then
            CheckRectsMenuMenu1 = 5
            Exit Function
        End If
    End If
    If MenuMenu = 7 Or MenuMenu = 8 Then
        If IntersectRect(rTemp, rHelp(5), rMouse) Then
            CheckRectsMenuMenu1 = 5
            Exit Function
        End If
    End If
    If MenuMenu = 7 Then
        If IntersectRect(rTemp, rHelp(6), rMouse) Then
            CheckRectsMenuMenu1 = 6
            Exit Function
        End If
    End If
End Function

Public Function CheckRectsMenuMenu2() As Integer
    Dim rTemp As RECT, rMouse As RECT, I As Integer
    With rMouse
        .Left = g_cursorx
        .Right = .Left + 1
        .Top = g_cursory
        .Bottom = .Top + 1
    End With
    For I = 0 To UBound(Menu2Rect)
        If IntersectRect(rTemp, Menu2Rect(I), rMouse) Then
            CheckRectsMenuMenu2 = I + 1
            Exit Function
        End If
    Next
End Function

Public Function CheckRectsMenu3() As Integer
    Dim rTemp As RECT, rMouse As RECT, I As Integer
    With rMouse
        .Left = g_cursorx
        .Right = .Left + 1
        .Top = g_cursory
        .Bottom = .Top + 1
    End With
    For I = 0 To UBound(Menu3Rect)
        If IntersectRect(rTemp, Menu3Rect(I), rMouse) Then
            CheckRectsMenu3 = I + 1
            Exit Function
        End If
    Next
End Function

Public Function CheckRectsMenuMenu3() As Integer
    Dim rTemp As RECT, rMouse As RECT, I As Integer
    With rMouse
        .Left = g_cursorx
        .Right = .Left + 1
        .Top = g_cursory
        .Bottom = .Top + 1
    End With
    For I = 0 To UBound(rConfig)
        If IntersectRect(rTemp, rConfig(I), rMouse) Then
            CheckRectsMenuMenu3 = I + 1
            Exit Function
        End If
    Next
End Function

Public Function CheckRectsMenuMenu4() As Integer
    Dim rTemp As RECT, rMouse As RECT, I As Integer
    With rMouse
        .Left = g_cursorx
        .Right = .Left + 1
        .Top = g_cursory
        .Bottom = .Top + 1
    End With
    For I = 0 To UBound(Menu4Rect)
        If IntersectRect(rTemp, Menu4Rect(I), rMouse) Then
            CheckRectsMenuMenu4 = I + 1
            Exit Function
        End If
    Next
End Function

Public Function CheckRectMenu9() As Boolean
    Dim rTemp As RECT, rMouse As RECT
    With rMouse
        .Left = g_cursorx
        .Right = .Left + 1
        .Top = g_cursory
        .Bottom = .Top + 1
    End With
    If IntersectRect(rTemp, Menu9Rect, rMouse) Then CheckRectMenu9 = True
End Function

Public Function CheckRectsPlayerOpt() As Integer
    Dim rTemp As RECT, rMouse As RECT, I As Integer
    With rMouse
        .Left = g_cursorx
        .Right = .Left + 1
        .Top = g_cursory
        .Bottom = .Top + 1
    End With
    For I = 0 To UBound(PlayerOptR)
        If I > 1 Or Not Players(MeNum).Admin > 0 Then
            If IntersectRect(rTemp, PlayerOptR(I), rMouse) Then
                CheckRectsPlayerOpt = I + 1
                Exit Function
            End If
        End If
        If I = 1 And Not Players(MeNum).Admin > 0 Then Exit Function
    Next
End Function

Public Sub DoOption()
    Dim lMsg As Byte, j As Integer, b As Byte
    Dim oNewMsg() As Byte, lNewOffSet As Long
    '
    If NavMenu = 3 Then
        j = CheckRectsMenu3
        If j = 1 Then PlayerScroll = PlayerScroll - 1
        If j = 2 Then PlayerScroll = PlayerScroll + 1
        If j > 3 Then PlayerSelected = j - 3
        If PlayerScroll < 0 Then PlayerScroll = 0
        If UBound(Players) > 10 Then
            If PlayerScroll > UBound(Players) - 10 Then PlayerScroll = UBound(Players) - 10
        Else
            PlayerScroll = 0
        End If
        j = CheckRectsPlayerOpt
        PlayerOpt = j
        If j > 0 Then Exit Sub
    End If
    '
    If MenuMenu = 1 Or (MenuMenu > 4 And MenuMenu < 9) Then
        j = CheckRectsMenuMenu1
        If j = 1 Then MenuMenu = 5
        If j = 2 Then MenuMenu = 6
        If j = 3 Then MenuMenu = 7
        If j = 4 Then MenuMenu = 0
        If j = 5 Then MenuMenu = 1
        If j = 6 Then MenuMenu = 8
    End If
    '
    If MenuMenu = 2 Then 'Team Switch
        j = CheckRectsMenuMenu2
        If j = 5 Then MenuMenu = 0
        If j > HData.NumTeams Then Exit Sub
        b = j
        On Local Error Resume Next
        lMsg = MSG_TEAM
        lNewOffSet = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lMsg), LenB(lMsg), lNewOffSet
        AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
        SendTo oNewMsg
        MenuMenu = 0
        If j > 0 Then Exit Sub
    End If
    '
    If MenuMenu = 3 Then 'Options
        j = CheckRectsMenuMenu3
        If j = 1 And Not gObjDSound Is Nothing Then If EnableSound Then EnableSound = False Else EnableSound = True
        If j = 2 Then cfgm = True
        If j = 3 Then cfgm = False
        If j = 4 Then cfgk = True: KeyConfig False
        If j = 5 Then cfgk = False: KeyConfig True
        If j = 6 Then cfgwv = False
        If j = 7 Then cfgwv = True
        If j = 8 Then MenuMenu = 0
        If j > 0 Then Exit Sub
    End If
    '
    If MenuMenu = 4 Then 'Are you sure you want to leave ___ ?'
        j = CheckRectsMenuMenu4
        If j = 1 Then Stopping = True 'Yes'
        If j = 2 Then MenuMenu = 0 'No'
        If j > 0 Then Exit Sub 'What the?'
    End If
    '
    If NavMenu = 4 Then
        j = CheckRectsMenu4
        If j > 0 Then MenuMenu = j: Exit Sub
    End If
    '
    If MenuMenu = 9 Then If CheckRectMenu9 Then MenuMenu = 0
    '
    j = CheckRectsNav
    If j = 1 Then If Not AnimateMenu Then MenuPend = 1: AnimateMenu = True
    If j = 3 Then If Not AnimateMenu Then MenuPend = 3: AnimateMenu = True: PlayerSelected = 1
    If j = 4 Then If Not AnimateMenu Then MenuPend = 4: AnimateMenu = True
    If j = 5 Then DropFlag
    If j = 6 Then Weapon = 1: SpecialSnd 1
    If j = 7 Then Weapon = 2: SpecialSnd 2
    If j = 8 Then Weapon = 3: SpecialSnd 3
    
    If Advertisements Then If CheckRectsAd Then LaunchAd
End Sub

Public Sub sendmsg(cmd As Long, Msgs As String)
    On Local Error Resume Next
    Dim lMsg As Byte
    Dim oNewMsg() As Byte, lNewOffSet As Long
    lNewOffSet = 0
    ReDim oNewMsg(0)
    lMsg = cmd
    AddBufferData oNewMsg, VarPtr(lMsg), LenB(lMsg), lNewOffSet
    AddBufferString oNewMsg, Msgs, lNewOffSet
    SendTo oNewMsg
End Sub

Public Sub GameChat(txt As String)
    Dim X As Byte
    For X = 0 To UBound(Chat)
        If X = UBound(Chat) And Chat(X) <> vbNullString Then KillChatLine
        If Chat(X) = vbNullString Then
            If Chat(0) = vbNullString Then ChatClean = NewGTC
            Chat(X) = txt
            Exit For
        End If
    Next
    WriteChat
End Sub

Public Sub KillChatLine()
    Dim I As Integer
    For I = 0 To UBound(Chat) - 1 Step 1
        Chat(I) = Chat(I + 1)
    Next
    Chat(UBound(Chat)) = vbNullString
    WriteChat
End Sub

Public Function GetPN(plr As String) As Integer
    Dim I As Integer
    For I = 1 To UBound(Players)
        If LCase$(Players(I).Nick) = LCase$(plr) Then GetPN = I: Exit Function
    Next
End Function

Public Sub AddIgnore(plr As String)
    Dim I As Integer, j As Integer
    j = GetPN(plr)
    If Players(j).Admin > 0 Then
        GameChat Chr$(5) & "You are not allowed to ignore this player."
        Exit Sub
    End If
    For I = 0 To UBound(Ignored) + 1
        If I > UBound(Ignored) Then ReDim Preserve Ignored(I)
        If LenB(Ignored(I)) = 0 Then
            Ignored(I) = LCase$(plr)
            GameChat Chr$(5) & plr & " is ignored."
            Exit For
        End If
    Next
End Sub

Public Function IsIgnored(plr As String) As Boolean
    Dim I As Integer
    For I = 0 To UBound(Ignored)
        If Ignored(I) = LCase$(plr) Then
            IsIgnored = True
            Exit Function
        End If
    Next
End Function

Public Sub RemoveIgnore(plr As String)
    Dim I As Integer
    For I = 0 To UBound(Ignored)
        If Ignored(I) = LCase$(plr) Then
            Ignored(I) = vbNullString
            GameChat Chr$(5) & plr & " is unignored."
            Exit For
        End If
    Next
End Sub

Public Sub MoveCalls()
1099:      If Not DevEnv Then On Error GoTo ErrorTrap
1100:      Dim I As Integer, q As Integer, d As Integer, e As Integer, F As Integer, j As Integer
1101:      Dim rBuff As RECT, temptext As String
1102:      Static SendCoor As Single, TxtCursor As Boolean, TxtCursorT As Long, FlipWait As Long
1103:      Static FPS As Long, EngineTime As Long, FPScnt As Long, FPSTime As Long, FPSBoot As Boolean, FPSBootT As Long
1104:      Dim b As Byte
1105:      Dim L As Long, L2 As Long
1106:      Dim tmp As String
1107:      Dim lMsg As Byte
1108:      Dim lOffset As Long
1109:      Dim oNewMsg() As Byte, lNewOffSet As Long
1110:      Dim emptyrect As RECT, rect1 As RECT
1111:      Dim ddsdBuffer As DDSURFACEDESC2, ddsdVMem As DDSURFACEDESC2
1112:
1113:      If Not Playing Then
1114:          If BackBuffer.isLost Then GoTo skip2
1115:          If Not NoFarplane Then BackBuffer.Blt rBuff, DirectDraw_Farplane, rBuff, DDBLT_WAIT Else BackBuffer.BltColorFill rBuff, RGB(0, 0, 0)
1116:          AnimTransferMap LoadCap, LoadBool
1117:
1118:          If (NewGTC - LastMemCheck > 5000 Or Len(Mem) = 0) And DebugShow Then
1119:              LastMemCheck = NewGTC
1120:              Mem = Format$(GetProcessPrivateBytes \ 1024, "#,#")
1121:              ddsdVMem.ddsCaps.lCaps = DDSCAPS_OFFSCREENPLAIN Or DDSCAPS_SYSTEMMEMORY
1122:              If Not LowVRAM Then ddsdVMem.ddsCaps.lCaps = DDSCAPS_OFFSCREENPLAIN Or DDSCAPS_VIDEOMEMORY
1124:              On Error Resume Next
1125:              VMem = Int(DirectDraw.GetFreeMem(ddsdVMem.ddsCaps) / DirectDraw.GetAvailableTotalMem(ddsdVMem.ddsCaps) * 100)
1126:              If Not DevEnv Then On Error GoTo ErrorTrap Else On Error GoTo 0
1127:              FMem = Format$(AvailableRAMMemory, "#,#")
1128:              SMem = Format$(AvailableSWAP, "#,#")
1129:          End If
1130:
1131:          If NewGTC - FPSTime > 1000 Then
1132:              FPSTime = NewGTC
1133:              FPSRec = FPScnt
1134:              FPScnt = 0
1135:          End If
1136:          FPScnt = FPScnt + 1
1137:          GoTo skip
1138:      End If
lol1:
1140:      If ExModeActive Then
1141:          If BufferWasLost And frmDisplay.HasFocus Then
1142:              Players(MeNum).KeyIs = 0
1143:              On Local Error Resume Next
1144:              DirectDraw.RestoreAllSurfaces
1145:              PlainSystemPlanes
1146:              IntDX False, True
1147:              RefreshMap
1148:              BufferWasLost = False
1149:              BackBuffer.BltFast 0, 0, DirectDraw_Chat, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
1150:              Exit Sub
1151:          End If
1152:          DIKeys
1153:      End If
1154:      SENDNewKey
1155:      If NewGTC - ChatClean > 10000 Then
1156:          KillChatLine
1157:          ChatClean = NewGTC
1158:      End If
lol2:
1160:      If Not NoFarplane Then MakeFarplane Else BackBuffer.BltColorFill rBuff, RGB(0, 0, 0)
1161:      mapRender
1162:      For I = 0 To 4
1163:          For d = 1 To UBound(FlagBlinkT, 2)
1164:              If NewGTC - FlagBlinkT(I, d) < 8000 Then
1165:                  If NewGTC - FlagBlinking(I, d) > 100 Then
1166:                      FlagBlinking(I, d) = NewGTC
1167:                      If FlagBlink(I, d) Then FlagBlink(I, d) = False Else FlagBlink(I, d) = True
1168:                  End If
1169:              Else
1170:                  FlagBlink(I, d) = False
1171:              End If
1172:          Next
1173:      Next
1174:      e = 0 'No mines in current existence
1175:      For I = 0 To UBound(Mines)
1176:          If Mines(I).Color > 0 Then
1177:              e = 1 'A mine has been discovered
1178:              AnimMine I '?
1179:              If Players(Mines(I).Who).Ship <> Mines(I).Color Then
1180:                  Mines(I).Color = 0
1181:                  Mines(I).Tick = 0 'Delete mines planted by players who switched teams
1182:              End If
1183:              If Mines(I).Tick > 0 Then
1184:                  If NewGTC - Mines(I).Tick > 500 Then '500ms after activated
1185:                      ExplBomb Mines(I).X, Mines(I).y
1186:                      ExplShrap Mines(I).Who, Mines(I).X, Mines(I).y, 3.5, 700, 0, 12 'Shrapnel.
1187:                      If Mines(I).X - MeX - CenterX > -100 And Mines(I).y - MeY - CenterY > -100 And Mines(I).X - MeX - CenterX < ResX + 100 And Mines(I).y - MeY - CenterY < ResY + 100 Then
1188:                          SndMortars Mines(I).X - MeX - CenterX, Mines(I).y - MeY - CenterY 'Play sound.
1189:                      End If
1190:                      Mines(I).Color = 0 'Delete mine.
1191:                  End If
1192:              End If
1193:          End If
1194:      Next
1195:      If e = 0 And I > 1 Then ReDim Mines(0) 'If no mines are in current existence, redim the array (purge).
1196:      e = 0
1197:      For I = 0 To UBound(PowerUp)
1198:          If PowerUp(I) > 0 Then e = 1
1199:          AnimPowerup I
1200:      Next
1201:      If e = 0 And I > 1 Then ReDim PowerUp(0)
1202:      For I = 1 To 5
1203:          If I = 1 Then
1204:              For d = 1 To UBound(Flag1, 2)
1205:                  If FlagCarry1(d) = 0 Then Flags 1, d
1206:              Next
1207:          ElseIf I = 2 Then
1208:              For d = 1 To UBound(Flag2, 2)
1209:                  If FlagCarry2(d) = 0 Then Flags 2, d
1210:              Next
1211:          ElseIf I = 3 Then
1212:              For d = 1 To UBound(Flag3, 2)
1213:                  If FlagCarry3(d) = 0 Then Flags 3, d
1214:              Next
1215:          ElseIf I = 4 Then
1216:              For d = 1 To UBound(Flag4, 2)
1217:                  If FlagCarry4(d) = 0 Then Flags 4, d
1218:              Next
1219:          ElseIf I = 5 Then
1220:              For d = 1 To UBound(Flag5, 2)
1221:                  If FlagCarry5(d) = 0 Then Flags 5, d
1222:              Next
1223:          End If
1224:      Next
1225:      e = 0
1226:      If BackBuffer.isLost = 0 Then BackBuffer.Lock emptyrect, ddsdBuffer, DDLOCK_WAIT, 0
1227:      For d = 0 To UBound(Laser)
1228:          If Laser(d) Then
1229:              e = 1
1230:              AnimLaser d
1231:          End If
1232:      Next
1233:      e = 0
1234:      For d = 0 To UBound(Bounce)
1235:          If Bounce(d) Then
1236:              e = 1
1237:              AnimBounce d
1238:          End If
1239:      Next
1240:      If e = 0 And d > 1 Then ReDim Bounce(0)
1241:      e = 0
1242:      For d = 0 To UBound(Miss)
1243:          If Miss(d) Then
1244:              e = 1
1245:              AnimMiss d
1246:          End If
1247:      Next
1248:      If e = 0 And d > 1 Then ReDim Miss(0)
1249:
1250:
1251:      '
1252:      For d = 0 To UBound(Spark)
1253:          If NewGTC - Spark(d) < 50 + SparkTick(d) Then
1254:              If Spark(d) > 0 Then
1255:                  e = 1
1256:                  AnimSpark d
1257:              End If
1258:          End If
1259:      Next
1260:      '
1261:      If BackBuffer.isLost = 0 Then BackBuffer.Unlock emptyrect
1262:      '
1263:      For d = 0 To UBound(ExplodeWho)
1264:          If NewGTC - Explode(d) < ShrapTick(d) Then
1265:              If ExplodeWho(d) > 0 Then
1266:                  e = 1
1267:                  AnimShrapnel d
1268:              End If
1269:          Else
1270:              ExplodeWho(d) = 0
1271:          End If
1272:      Next
1273:      '
1274:      For d = 0 To UBound(UniBall)
1275:          If UniBall(d).Color > 0 Then AnimUniBall d
1276:      Next
1277:      '
lol3:
1279:      For I = 1 To UBound(Players)
1280:          If Players(I).Ship > 0 And Players(I).Ship < 10 Then
1281:              Players(I).MoveX = Players(I).charX - MeX
1282:              Players(I).MoveY = Players(I).charY - MeY
1283:              ARCShips I
1284:              If Players(I).ArmCrt And Not Players(I).Invisible Then
1285:                  If NewGTC - Players(I).ArmCrtTme > 500 Then
1286:                      Randomize Timer
1287:                      SmokeTrail newCInt(Players(I).charX + Int(Rnd(3) * 20 + 5)), newCInt(Players(I).charY + Int(Rnd(3) * 20 + 5)), 0
1288:                      Players(I).ArmCrtTme = NewGTC
1289:                  End If
1290:              End If
1291:              '
1292:              If Players(I).FlagWho = 1 Then
1293:                  If FlagCarry1(Players(I).FlagID) > 0 Then Flags 1, newCInt(Players(I).FlagID)
1294:              ElseIf Players(I).FlagWho = 2 Then
1295:                  If FlagCarry2(Players(I).FlagID) > 0 Then Flags 2, newCInt(Players(I).FlagID)
1296:              ElseIf Players(I).FlagWho = 3 Then
1297:                  If FlagCarry3(Players(I).FlagID) > 0 Then Flags 3, newCInt(Players(I).FlagID)
1298:              ElseIf Players(I).FlagWho = 4 Then
1299:                  If FlagCarry4(Players(I).FlagID) > 0 Then Flags 4, newCInt(Players(I).FlagID)
1300:              ElseIf Players(I).FlagWho = 5 Then
1301:                  If FlagCarry5(Players(I).FlagID) > 0 Then Flags 5, newCInt(Players(I).FlagID)
1302:              End If
1303:              CharUpdate I
1304:          End If
1305:      Next
1306:      e = 0
1307:      For I = 0 To UBound(IsHit)
1308:          If IsHit(I) Then
1309:              e = 1
1310:              AnimHit I
1311:          End If
1312:      Next
1313:      If e = 0 Then ReDim IsHit(0)
1314:      e = 0
1315:      q = 0
1316:      For d = 0 To UBound(Smk2)
1317:          q = 1
1318:          If Smk2(d) Then AnimSmoke2 d
1319:      Next
1320:      For d = 0 To UBound(Smk)
1321:          q = 1
1322:          If Smk(d) Then AnimSmoke d
1323:      Next
1324:      For d = 0 To UBound(Mortar)
1325:          If Mortar(d) Then
1326:              e = 1
1327:              Mortars d
1328:          End If
1329:      Next
1330:
1331:      If e = 0 And UBound(Mortar) > 0 Then ReDim Mortar(0)
1332:      If q = 0 Then
1333:          If UBound(Smk) > 0 Then ReDim Smk(0), SmkX(0), SmkY(0), SmkParm(0), SmkColor(0)
1334:      End If
1335:      For I = 0 To UBound(Captured)
1336:          If Captured(I) Then
1337:              e = 1
1338:              If FlagPlay(I) Then Exit For
1339:          End If
1340:      Next
1341:      If e = 0 And I = 1 Then
1342:          ReDim Captured(0)
1343:          ReDim FlagCap(0)
1344:          ReDim WhoTeam(0)
1345:          ReDim FlagStatus(0)
1346:      End If
1347:      e = 0
1348:      For I = 0 To UBound(Expl)
1349:          If Expl(I) Then
1350:              e = 1
1351:              AnimExpl I
1352:          End If
1353:      Next
1354:      If e = 0 Then ReDim Expl(0)
1355:      e = 0
1356:      For I = 0 To UBound(Popping)
1357:          If Popping(I) Then Pop I
1358:      Next
1359:      d = 0
1360:      F = 0
1361:
lol4:
1363:      BackBuffer.BltFast 0, 0, DirectDraw_Chat, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
1364:      e = 0
1365:      Menus
1366:      If Advertisements Then AdBar
1367:      If ScoreView Then DisplayScores
1368:      If WepRecharge < 60 Then WepRecharge = WepRecharge + Speed * 0.21
1369:      If WepRecharge > 60 Then WepRecharge = 60
1370:      If Players(MeNum).DevCheat > 0 And Not Players(MeNum).DevCheat = 5 Then WepRecharge = 60
1371:      If Players(MeNum).Mode = 1 Then
1372:          WepRecharge = 0
1373:      End If
1374:      If g_cursorx + 17 > ResX Then g_cursorx = ResX - 17
1375:      If g_cursorx + 32 > ResX Then MWidth = ResX - g_cursorx Else MWidth = 32
1376:      If g_cursory + 17 > ResY Then g_cursory = ResY - 17
1377:      If cfgm2 Then
1378:          If g_cursory + 28 > ResY Then MHeight = ResY - g_cursory + 5 Else MHeight = 32
1379:      Else
1380:          If g_cursory + 33 > ResY Then MHeight = ResY - g_cursory - 1 Else MHeight = 32
1381:      End If
1382:      If g_cursorx < 0 Then g_cursorx = 0
1383:      If g_cursory < 0 Then g_cursory = 0
1385:
1386:      MPointer
1387:      CrossHairs
1388:      With rBuff
1389:          .Top = 0
1390:          .Bottom = 0
1391:          .Right = 0
1392:          .Left = 0
1393:      End With
1394:
1395:      If (NewGTC - LastMemCheck > 5000 Or Len(Mem) = 0) And DebugShow Then
1396:          LastMemCheck = NewGTC
1397:          Mem = Format$(GetProcessPrivateBytes \ 1024, "#,#")
1398:          ddsdVMem.ddsCaps.lCaps = DDSCAPS_OFFSCREENPLAIN
1399:          If Not LowMem And Not LowVRAM Then ddsdVMem.ddsCaps.lCaps = DDSCAPS_OFFSCREENPLAIN Or DDSCAPS_VIDEOMEMORY
1400:          If LowVRAM Then ddsdVMem.ddsCaps.lCaps = DDSCAPS_OFFSCREENPLAIN Or DDSCAPS_SYSTEMMEMORY
1401:          On Error Resume Next
1402:          VMem = Int(DirectDraw.GetFreeMem(ddsdVMem.ddsCaps) / DirectDraw.GetAvailableTotalMem(ddsdVMem.ddsCaps) * 100)
1403:          If Not DevEnv Then On Error GoTo ErrorTrap Else On Error GoTo 0
1404:          FMem = Format$(AvailableRAMMemory, "#,#")
1405:          SMem = Format$(AvailableSWAP, "#,#")
1406:      End If
1407:
1408:      If NewGTC - FPSTime > 1000 Then
1409:          FPSTime = NewGTC
1410:          FPSRec = FPScnt
1411:          FPScnt = 0
1412:      End If
1413:      FPScnt = FPScnt + 1
1414:
1415:      If FPSRec < 10 Then 'Slow machine, or no?
1416:          If Not FPSBoot Then FPSBootT = NewGTC
1417:          FPSBoot = True
1418:          If NewGTC - FPSBootT > 10000 Then
1419:              ExitMSG = "Minimum FPS is 10. Try go to options and uncheck the 64+MB Video Advance! If you still need help, talk to a " & ProjectName & " admin!"
1420:              Stopping = True
1421:          End If
1422:      Else
1423:          FPSBoot = False
1424:      End If
1425:      If DebugShow Then
               MakeText Chr$(2) & "Sync: " & PSpeed & "  Buffers: " & PBuffer, 15, (CenterY * 2) - 56, False
               MakeText Chr$(2) & "FPS: " & FPSRec & "  Ping: " & PingTime & "  RAM: " & Mem & "KB  Free VRAM: " & VMem & "%", 15, (CenterY * 2) - 43, False
               MakeText Chr$(2) & "Free RAM: " & FMem & "KB  Free Swap: " & SMem & "KB", 15, (CenterY * 2) - 30, False
1429:      End If
1430:
1431:      If NewGTC - SendCoor > PSpeed Or MoveCounter > PBuffer Then
1432:          PlayMoves
1433:      End If
1434:
1435:      If NewGTC - SendCoor > PSpeed Then
1436:          SendCoor = NewGTC
1437:          If MeX <> 0 And MeY <> 0 Then
1438:              Call SendData(MSG_GAMEDATA, Players(MeNum).KeyIs, newCInt(Players(MeNum).charX), newCInt(Players(MeNum).charY))
1439:          End If
1440:      End If
1441:      If BackBuffer.isLost Then GoTo skip2
1442:      tmp = vbNullString
1443:      If NewGTC - TxtCursorT > 200 Then
1444:          If WepRecharge < 6 Then b = 1 Else b = 0
1445:
1446:          TxtCursorT = NewGTC
1447:          If TxtCursor Then TxtCursor = False Else TxtCursor = True
1448:      End If
1449:      If TxtCursor Then tmp = Chr$(10) & Chr$(255)
1450:      If DebugBuild Or DevEnv Then MakeText Chr$(2) & MapName, (CenterX * 2) - 230, (CenterY * 2) - 27, False
1451:      If DebugBuild Or DevEnv Then MakeText Chr$(2) & "For testing purposes only. v" & App.Major & "." & Format$(App.Minor, "00") & "." & Format$(App.Revision, "0000"), (CenterX * 2) - 230, (CenterY * 2) - 15, False
1452:      If LenB(TxtBuild) > 0 Then
1453:          MakeText Chr$(9) & TxtBuild & tmp, 5, ResY - 17, False
1454:      Else
1455:          If Not cfgk And ChatQ Then MakeText tmp, 5, ResY - 17, False
1456:      End If
1457:      If Players(MeNum).InPen And Players(MeNum).Mode = 0 Then
1458:          If NewGTC - Players(MeNum).HoldingPen < HoldWait * 1000 And Round(HoldWait - (NewGTC - Players(MeNum).HoldingPen)) > 0 Then
1459:              temptext = Chr$(6) & "Press F2 for Help and Game Information."
1460:              MakeText temptext, CenterX - (Len(temptext) * 3.2), 180, False
                   temptext = Chr$(6) & "Holding Time Left: " & Round((HoldWait - (NewGTC - Players(MeNum).HoldingPen)) * 0.001)
1462:              MakeText temptext, CenterX - (Len(temptext) * 3.2), 200, False
1463:          End If
1464:      End If
skip:
1466:      If Windowed Then
1467:          Dim ddrval As Long
1468:          Dim r1 As RECT
1469:          Dim r2 As RECT
1470:          DirectX.GetWindowRect frmDisplay.hwnd, r1
1471:          'r1.Top = r1.Top + (ResTop) + 3
1472:          'r1.Bottom = r1.Top + ResY - 119
1473:          r2.Bottom = ResY
1474:          r2.Right = ResX
1475:          ddrval = PrimarySurface.Blt(r1, BackBuffer, r2, DDBLT_WAIT)
1476:      Else
1477:          PrimarySurface.Flip Nothing, DDFLIP_NOVSYNC
1478:      End If
skip2:
1480:      If BackBuffer.isLost Then BufferWasLost = True
1481:      QueryPerformanceCounter curEnd
1482:      Speed = 71.5 * ((curEnd - curStart) / curFreq)
1483:
1484:      QueryPerformanceFrequency curFreq
1485:      QueryPerformanceCounter curStart
1486:
1487:      If Speed > 50 Then Speed = 50
done:
1489:
1490:      If Stopping Then
1491:          frmDisplay.Timer2.Enabled = False
1492:          frmDisplay.Timer1.Enabled = True
1493:      End If
1494:      Exit Sub
wtf:
1496:      Stopping = True
1497:      Unload frmMain
1498:      Unload frmSplash
1499:
1500:      Exit Sub
1501:
ErrorTrap:
1503:      RaiseCritical "MoveCalls failed (Line #" & Erl & ". " & DQ & Err.Number & " " & Err.Description & DQ & ")"
1504:      Stopping = True
End Sub

Public Sub MakeFarplane()
    If BackBuffer.isLost Then Exit Sub
    Dim xt As Integer, yt As Integer, rDD As RECT
    Dim xtl As Integer, ytl As Integer, xw As Integer, yw As Integer
    xw = ResX
    yw = ResY
    If xw > 1280 Then xw = 1280
    If yw > 960 Then yw = 960
    xt = 0.1568 * MeX
    yt = 0.1176 * MeY
    xtl = xt + xw
    ytl = yt + yw
    If xtl > 1280 Then
        xt = 1280 - xw
        xtl = 1280
    End If
    If ytl > 960 Then
        yt = 960 - yw
        ytl = 960
    End If
    '
    If xt < 0 Then
        xt = 0
        xtl = xw
    End If
    If yt < 0 Then
        yt = 0
        ytl = yw
    End If
    '
    With rDD
        .Left = xt
        .Top = yt
        .Right = xtl
        .Bottom = ytl
    End With
    BackBuffer.BltFast 0, 0, DirectDraw_Farplane, rDD, DDBLTFAST_WAIT
End Sub

Public Sub mapRender()
    If BackBuffer.isLost Then Exit Sub
    If DirectDraw_Tiles Is Nothing Then Exit Sub
    Dim DestX As Single, DestY As Single, FrameChange(255, 255) As Byte
    Dim I As Integer, R As Integer, j As Integer, C As Integer, d As Integer, a As Integer, e As Integer
    Dim Xfind As Integer, Yfind As Integer, Xwdth As Integer, Ywdth As Integer, X As Integer
    Dim Xcoor As Integer, Ycoor As Integer, Xdif As Integer, Ydif As Integer
    Dim TileGet As RECT, xt As Integer, yt As Integer, ToX As Integer, ToY As Integer
    ReDim AnimsPlayed(0)
    MeX = Players(MeNum).charX - CenterSX
    MeY = Players(MeNum).charY - CenterSY
    MapX = (MeX - (MeX Mod 16)) / 16 'Possible failure
    MapY = (MeY - (MeY Mod 16)) / 16 'Possible failure
    If MeY < 0 Then MapY = MapY - 1
    If MeX < 0 Then MapX = MapX - 1
    DestX = Players(MeNum).charX - MapX * 16
    DestY = Players(MeNum).charY - MapY * 16
    Xdif = MeX - MapX * 16
    Ydif = MeY - MapY * 16
    ToX = ResX / 16 'Possible failure
    ToY = ResY / 16 'Possible failure
    
    If ResY = 600 Then
        If Ydif < 8 Then ToY = 37 Else ToY = 38
    End If
    I = MapX * 16 + Xdif
    j = MapY * 16 + Ydif
    d = I
    C = j
    If I < 0 Then d = 0
    If j < 0 Then C = 0
    TileGet.Left = d
    TileGet.Top = C
    If I < 0 Then d = I Else d = 0
    If j < 0 Then C = j Else C = 0
    d = TileGet.Left + ResX + d
    C = TileGet.Top + ResY + C
    If d > 4080 Then d = 4080
    If C > 4080 Then C = 4080
    TileGet.Right = d
    TileGet.Bottom = C
    d = MapX * 16 + Xdif
    C = MapY * 16 + Ydif
    If d >= 0 Then d = 0
    If C >= 0 Then C = 0
    BackBuffer.BltFast Abs(d), Abs(C), DirectDraw_Map, TileGet, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
    C = 0
    d = 0
    If MeY < 0 Then C = MapY
    If MeX < 0 Then d = MapX
    For R = Abs(C) To ToY
        For I = Abs(d) To ToX
            xt = I + MapX
            yt = R + MapY
            'UBound functions below are ALWAYS 255 (CPU WASTE!)
            'If yt > UBound(SourceX, 1) Or yt < 0 Then Exit For
            'If xt > UBound(SourceX, 2) Or xt < 0 Then GoTo out
            If yt > 255 Or yt < 0 Then Exit For
            If xt > 255 Or xt < 0 Then GoTo out
            Xfind = 0
            If I = 0 Then Xfind = Xfind + Xdif
            Yfind = 0
            If R = 0 Then Yfind = Yfind + Ydif
            Xwdth = 16
            If I = 0 Then Xwdth = Xwdth - Xdif
            If I = ToX Then Xwdth = Xdif
            Ywdth = 16
            If R = 0 Then Ywdth = Ywdth - Ydif
            If R = ToY Then Ywdth = Ydif
            If ResY = 600 Then
                If Ydif < 8 And ToY = 37 Then
                    If R = ToY Then Ywdth = Ydif + 8
                End If
                If Ydif >= 8 And ToY = 38 Then
                    If R = ToY Then Ywdth = Ydif - 8
                End If
            End If
            
            Xcoor = I * 16
            If I > 0 Then Xcoor = Xcoor - Xdif
            Ycoor = R * 16
            If R > 0 Then Ycoor = Ycoor - Ydif
            
            X = AnimOffset(yt, xt)
            If X > 0 Then
                a = Animations(yt, xt)
                If FrameChange(FrameCount(a), AnimSpeed(a)) = 0 Then
                    If AnimSpeed(a) = 0 Then AnimSpeed(a) = 1
                    AnimCount(FrameCount(a), AnimSpeed(a)) = AnimCount(FrameCount(a), AnimSpeed(a)) + Speed / AnimSpeed(a)
                    If AnimCount(FrameCount(a), AnimSpeed(a)) > FrameCount(a) - 1 Then AnimCount(FrameCount(a), AnimSpeed(a)) = 0
                End If
                FrameChange(FrameCount(a), AnimSpeed(a)) = 1
                e = AnimCount(FrameCount(a), AnimSpeed(a))
                e = (e + X) Mod (FrameCount(a))
                TileGet.Top = AnimFY(a, e) + Yfind
                TileGet.Bottom = TileGet.Top + Ywdth
                TileGet.Left = AnimFX(a, e) + Xfind
                TileGet.Right = TileGet.Left + Xwdth
                Call BackBuffer.BltFast(Xcoor, Ycoor, DirectDraw_Anims(AnimFS(a, 0)), TileGet, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY)
            End If
out:
        Next
    Next
End Sub

Public Sub DropFlag()
    Dim lMsg As Byte
    Dim oNewMsg() As Byte, lNewOffSet As Long
    lNewOffSet = 0
    ReDim oNewMsg(0)
    lMsg = MSG_DROPFLAG
    AddBufferData oNewMsg, VarPtr(lMsg), LenB(lMsg), lNewOffSet
    SendTo oNewMsg
End Sub

Public Sub WriteChat()
    Dim e As Integer, j As Integer, q As Integer, F As Integer, d As Integer, rrect As RECT, I As Integer
    DirectDraw_Chat.BltColorFill rrect, KEYColor
    e = 1
    j = UBound(Chat)
    For I = 0 To j
        q = Len(Chat(I))
        While q > 0
            F = MakeText(Mid$(Chat(I), 1, 1) & Mid$(Chat(I), e + 1, q), 5, 5 + (I + d) * 12, True, DirectDraw_Chat)
            e = e + F - 1
            q = Len(Chat(I)) - e
            If q > 0 Then d = d + 1
        Wend
        e = 0: q = 0
    Next
End Sub

Public Sub AnimTransferMap(Caption As String, IsMapTransfer As Boolean)
    Dim xt As Integer, yt As Integer, PValue As Integer, I As Integer, L As Long
    xt = CenterX - 77
    yt = CenterY - 10
    SlctBox 200, 65
    MakeText Chr$(6) & Caption, xt, yt, False
    yt = yt + 25
    MakeText Chr$(6) & "Press ESC to abort", xt, yt, False
    If IsMapTransfer Then
        PValue = (ResX - 88) \ 12
        L = UBound(RMData) \ PValue
        For I = 1 To PValue
            If I * L >= RMCount Then
                OptionGFX "selectfalse", 32 + I * 12, CenterY + 200
            Else
                OptionGFX "selecttrue", 32 + I * 12, CenterY + 200
            End If
        Next
    End If
End Sub

Sub RefreshMap()
'1675:      On Error GoTo ErrorTrap
1676:      If BackBuffer.isLost Then Exit Sub
1677:      Dim j As Integer, F As Integer
1678:      Dim stx As Integer, sty As Integer
1679:      Dim Key As DDCOLORKEY, rrect As RECT, ddsdProperties2 As DDSURFACEDESC2
1680:      ddsdProperties2.lFlags = DDSD_CAPS Or DDSD_WIDTH Or DDSD_HEIGHT
1681:      ddsdProperties2.ddsCaps.lCaps = DDSCAPS_OFFSCREENPLAIN Or DDSCAPS_SYSTEMMEMORY
1682:      If Not LowMem And Not LowVRAM Then ddsdProperties2.ddsCaps.lCaps = DDSCAPS_OFFSCREENPLAIN Or DDSCAPS_VIDEOMEMORY
1683:      If LowVRAM Then ddsdProperties2.ddsCaps.lCaps = DDSCAPS_OFFSCREENPLAIN Or DDSCAPS_SYSTEMMEMORY
1684:      Key.high = KEYColor
1685:      Key.low = KEYColor
1686:      ddsdProperties.lFlags = DDSD_CAPS Or DDSD_WIDTH Or DDSD_HEIGHT
1687:
1688:      ddsdProperties.lWidth = 16
1689:      ddsdProperties.lHeight = 16
1690:      For j = 1 To UBound(TmpSX)
1691:          F = (j - 1) * 16
1692:          stx = (F Mod 640) And -16
1693:          sty = (F - (F Mod 640)) / 640 * 16
               rrect.Left = TmpSX(j): rrect.Right = rrect.Left + 16: rrect.Top = TmpSY(j): rrect.Bottom = rrect.Top + 16
1695:          Call DirectDraw_Tiles.BltFast(stx, sty, DirectDraw_Tile, rrect, DDBLTFAST_WAIT)
1696:      Next
1697:      BlitEntireMap
1698:
1699:      Exit Sub
1700:
ErrorTrap:
           MsgBox "Error Number: " & Err.Number & vbCrLf & Err.Description & vbCrLf & vbCrLf & "Debug Information:" & vbCrLf & _
               "OpenARC.modGame.RefreshMap" & IIf(Erl > 0, "." & Erl, ""), vbCritical, "Error Occurred"
1704:
End Sub

Sub BlitEntireMap()
    Dim X As Integer, y As Integer, TileGet As RECT
    DirectDraw_Map.BltColorFill TileGet, KEYColor
    For X = 0 To 255
        For y = 0 To 255
            TileGet.Top = SourceTileY(y, X)
            TileGet.Bottom = TileGet.Top + 16
            TileGet.Left = SourceTileX(y, X)
            TileGet.Right = TileGet.Left + 16
            If Not SourceX(y, X) = -1 Then
                DirectDraw_Map.BltFast X * 16, y * 16, DirectDraw_Tiles, TileGet, DDBLTFAST_WAIT
            End If
        Next
    Next
End Sub

Public Sub DoConfig()
    Dim xt As Integer, yt As Integer
    xt = CenterX - 84
    yt = CenterY - 55
    '
    If EnableSound Then
        OptionGFX "checktrue", xt, yt
    Else
        OptionGFX "checkfalse", xt, yt
    End If
    MakeText "Sound Enabled", xt + 16, yt, False
    '
    '
    MakeText "Mouse Controls", xt, yt + 20, False
    If cfgm Then
        OptionGFX "optiontrue", xt, yt + 34
    Else
        OptionGFX "optionfalse", xt, yt + 34
    End If
    MakeText "Classic", xt + 16, yt + 34, False
    
    If Not cfgm Then
        OptionGFX "optiontrue", xt + 90, yt + 34
    Else
        OptionGFX "optionfalse", xt + 90, yt + 34
    End If
    MakeText "Newbie", xt + 106, yt + 34, False
    '
    '
    MakeText "Keyboard Controls", xt, yt + 46, False
    If cfgk Then
        OptionGFX "optiontrue", xt, yt + 60
    Else
        OptionGFX "optionfalse", xt, yt + 60
    End If
    MakeText "Classic", xt + 16, yt + 60, False
    
    If Not cfgk Then
        OptionGFX "optiontrue", xt + 90, yt + 60
    Else
        OptionGFX "optionfalse", xt + 90, yt + 60
    End If
    MakeText "Newbie", xt + 106, yt + 60, False
    '
    '
    MakeText "Weapon Voices", xt, yt + 72, False
    If Not cfgwv Then
        OptionGFX "optiontrue", xt, yt + 86
    Else
        OptionGFX "optionfalse", xt, yt + 86
    End If
    MakeText "Recharged", xt + 16, yt + 86, False
    
    If cfgwv Then
        OptionGFX "optiontrue", xt + 90, yt + 86
    Else
        OptionGFX "optionfalse", xt + 90, yt + 86
    End If
    MakeText "Selected", xt + 106, yt + 86, False
    '
    ReplyGfx "ok", xt + 55, yt + 110
End Sub

Public Sub AnimExpl(I As Integer)
    Dim xt As Integer, yt As Integer, rExpl As RECT
    Dim sw As Integer, sh As Integer
    Dim ExY As Integer
    If NewGTC - AnimExT(I) > 50 Then
        AnimExT(I) = NewGTC
        AnimExF(I) = AnimExF(I) + 1
        If AnimExF(I) > 10 Then
            AnimExF(I) = 0
            Expl(I) = False
            Exit Sub
        End If
    End If
    rExpl.Left = rBombExp(AnimExF(I)).Left
    rExpl.Right = rBombExp(AnimExF(I)).Right
    rExpl.Top = rBombExp(AnimExF(I)).Top
    rExpl.Bottom = rBombExp(AnimExF(I)).Bottom
    
    sw = rExpl.Right - rExpl.Left
    sh = rExpl.Bottom - rExpl.Top
    xt = ExplX(I) - MeX - (sw / 2)
    yt = ExplY(I) - MeY - (sh / 2)
    If xt < 0 Then rExpl.Left = rExpl.Left + Abs(xt): xt = 0
    If yt < 0 Then rExpl.Top = rExpl.Top + Abs(yt): yt = 0
    If xt > ResX - sw Then rExpl.Right = rExpl.Right - (xt - (ResX - sw)): xt = (ResX - sw) + (xt - (ResX - sw))
    If yt > ResY - sh Then rExpl.Bottom = rExpl.Bottom - (yt - (yt - sh)): ExY = (yt - sh) + (yt - (ResY - sh))
    If xt > -62 And yt > -48 And xt < ResX + 62 And yt < ResY + 38 Then
        BackBuffer.BltFast xt, yt, DirectDraw_Tuna1, rExpl, DDBLTFAST_SRCCOLORKEY Or DDBLTFAST_WAIT
    End If
End Sub

Public Sub AnimPowerup(pwr As Integer)
    Dim rBuff As RECT
    Dim ExX As Long, ExY As Long
    If NewGTC - PowerFrameT(pwr) > 100 Then
        PowerFrame(pwr) = PowerFrame(pwr) + 1
        If PowerUp(pwr) = 1 Then
            If PowerFrame(pwr) > 5 Then PowerFrame(pwr) = 0
        Else
            If PowerFrame(pwr) > 11 Then PowerFrame(pwr) = 0
        End If
        PowerFrameT(pwr) = NewGTC
    End If
    
    If PowerEffect(pwr) = 2 Then
        If NewGTC - PowerTick(pwr) > 50 Then
            PowerTick(pwr) = NewGTC
            PowerEffect(pwr) = 3
        Else
            Exit Sub
        End If
    ElseIf PowerEffect(pwr) = 3 Then
        If NewGTC - PowerTick(pwr) > 50 Then
            PowerTick(pwr) = NewGTC
            PowerEffect(pwr) = 2
            Exit Sub
        End If
    End If
    
    
    ExX = PowerX(pwr)
    ExY = PowerY(pwr)
    ExX = ExX - MeX: ExY = ExY - MeY
    
    rBuff.Top = 355 + (PowerUp(pwr) - 1) * 24
    rBuff.Bottom = rBuff.Top + 24
    rBuff.Left = PowerFrame(pwr) * 24
    rBuff.Right = rBuff.Left + 24
    
    If ExX < 0 Then rBuff.Left = rBuff.Left + Abs(ExX): ExX = 0
    If ExY < 0 Then rBuff.Top = rBuff.Top + Abs(ExY): ExY = 0
    If ExX > ResX - 24 Then rBuff.Right = rBuff.Right - (ExX - (ResX - 24)): ExX = ResX - 24 + (ExX - (ResX - 24))
    If ExY > ResY - 24 Then rBuff.Bottom = rBuff.Bottom - (ExY - (ResY - 24)): ExY = ResY - 24 + (ExY - (ResY - 24))
    If PowerUp(pwr) <> 0 Then BackBuffer.BltFast ExX, ExY, DirectDraw_Tuna1, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
End Sub

Public Sub AnimUniBall(I As Integer)
    Dim Rx As Integer, Ry As Integer, rBuff As RECT
    Dim xt As Integer, yt As Integer, j As Integer
    Dim NewX As Integer, NewY As Integer, d As Integer, SgnX As Integer, SgnY As Integer
    Dim RatioX As Single, RatioY As Single
    Rx = 452
    Ry = 81
    
    NewX = UniBall(I).BallX
    NewY = UniBall(I).BallY
    If UniBall(I).BSpeedX > UniBall(I).BSpeedY And UniBall(I).BSpeedY > 0 Then RatioY = UniBall(I).BSpeedX / UniBall(I).BSpeedY
    If UniBall(I).BSpeedY > UniBall(I).BSpeedX And UniBall(I).BSpeedX > 0 Then RatioX = UniBall(I).BSpeedY / UniBall(I).BSpeedX
    If RatioX < 1 Then RatioX = 1
    If RatioY < 1 Then RatioY = 1
    If UniBall(I).BSpeedX > 0 Then UniBall(I).BSpeedX = UniBall(I).BSpeedX - (0.01 / RatioX) * Speed
    If UniBall(I).BSpeedY > 0 Then UniBall(I).BSpeedY = UniBall(I).BSpeedY - (0.01 / RatioY) * Speed
    If UniBall(I).BSpeedX < 0 Then UniBall(I).BSpeedX = 0
    If UniBall(I).BSpeedY < 0 Then UniBall(I).BSpeedY = 0
    
    UniBall(I).BLoopX = UniBall(I).BLoopX + (UniBall(I).BSpeedX * Speed)
    For j = 1 To UniBall(I).BLoopX
        NewX = NewX + UniBall(I).BMoveX
        UniBall(I).BLoopX = UniBall(I).BLoopX - 1
    Next
    
    UniBall(I).BLoopY = UniBall(I).BLoopY + (UniBall(I).BSpeedY * Speed)
    For j = 1 To UniBall(I).BLoopY
        NewY = NewY + UniBall(I).BMoveY
        UniBall(I).BLoopY = UniBall(I).BLoopY - 1
    Next
    
    
    SgnX = Sgn(NewX - UniBall(I).BallX)
    SgnY = Sgn(NewY - UniBall(I).BallY)
    
    
    If SgnX = 1 Then 'x positive testing
        For d = UniBall(I).BallX + 1 To NewX
            j = WeaponTouch(6, I, d, UniBall(I).BallY)
            If j = 6 Then
                UniBall(I).BMoveX = UniBall(I).BMoveX * -1
                NewX = d - 1
                Exit For
            End If
        Next
    End If
    
    If SgnX = -1 Then 'x negative testing
        For d = UniBall(I).BallX - 1 To NewX Step -1
            j = WeaponTouch(6, I, d, UniBall(I).BallY)
            If j = 6 Then
                UniBall(I).BMoveX = UniBall(I).BMoveX * -1
                NewX = d + 1
                Exit For
            End If
        Next
    End If
    
    If SgnY = 1 Then 'y positive testing
        For d = UniBall(I).BallY + 1 To NewY
            j = WeaponTouch(6, I, NewX, d)
            If j = 6 Then
                UniBall(I).BMoveY = UniBall(I).BMoveY * -1
                NewY = d - 1
                Exit For
            End If
        Next
    End If
    
    If SgnY = -1 Then 'y negative testing
        For d = UniBall(I).BallY - 1 To NewY Step -1
            j = WeaponTouch(6, I, NewX, d)
            If j = 6 Then
                UniBall(I).BMoveY = UniBall(I).BMoveY * -1
                NewY = d + 1
                Exit For
            End If
        Next
    End If
    
    UniBall(I).BallX = NewX
    UniBall(I).BallY = NewY
    j = WeaponTouch(6, I, NewX, NewY)
    xt = NewX
    yt = NewY
    xt = xt - MeX: yt = yt - MeY
    
    rBuff.Top = Ry
    rBuff.Bottom = rBuff.Top + 10
    rBuff.Left = Rx + 10 * (UniBall(I).Color - 1)
    rBuff.Right = rBuff.Left + 10
    
    If xt < 0 Then rBuff.Left = rBuff.Left + Abs(xt): xt = 0
    If yt < 0 Then rBuff.Top = rBuff.Top + Abs(yt): yt = 0
    If xt > ResX - 10 Then rBuff.Right = rBuff.Right - (xt - (ResX - 10)): xt = (ResX - 10) + (xt - (ResX - 10))
    If yt > ResY - 10 Then rBuff.Bottom = rBuff.Bottom - (yt - (ResY - 10)): yt = (ResY - 10) + (yt - (ResY - 10))
    
    BackBuffer.BltFast xt, yt, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
End Sub

Public Sub Flags(Colr As Integer, I As Integer)
    If BackBuffer.isLost Then Exit Sub
    Dim xt As Integer, yt As Integer, a As Integer, b As Integer, G As Byte
    Dim rFlag As RECT
    G = 0
    If Colr = 1 Then
        G = 1
        If FlagCarry1(I) > 0 Then
            Flag1(0, I) = Players(FlagCarry1(I)).charX + 18
            Flag1(1, I) = Players(FlagCarry1(I)).charY + 3: G = 9
        End If
        xt = Flag1(0, I)
        yt = Flag1(1, I)
    ElseIf Colr = 2 Then
        G = 2
        If FlagCarry2(I) > 0 Then
            Flag2(0, I) = Players(FlagCarry2(I)).charX + 18
            Flag2(1, I) = Players(FlagCarry2(I)).charY + 3: G = 9
        End If
        xt = Flag2(0, I)
        yt = Flag2(1, I)
    ElseIf Colr = 3 Then
        G = 3
        If FlagCarry3(I) > 0 Then
            Flag3(0, I) = Players(FlagCarry3(I)).charX + 18
            Flag3(1, I) = Players(FlagCarry3(I)).charY + 3: G = 9
        End If
        xt = Flag3(0, I)
        yt = Flag3(1, I)
    ElseIf Colr = 4 Then
        G = 4
        If FlagCarry4(I) > 0 Then
            Flag4(0, I) = Players(FlagCarry4(I)).charX + 18
            Flag4(1, I) = Players(FlagCarry4(I)).charY + 3: G = 9
        End If
        xt = Flag4(0, I)
        yt = Flag4(1, I)
    ElseIf Colr = 5 Then
        G = 5
        If FlagCarry5(I) > 0 Then
            Flag5(0, I) = Players(FlagCarry5(I)).charX + 18
            Flag5(1, I) = Players(FlagCarry5(I)).charY + 3: G = 9
        End If
        xt = Flag5(0, I)
        yt = Flag5(1, I)
    End If
    If G <> 9 Then
        a = xt \ 16
        b = yt \ 16
        On Error GoTo out
        If G = 1 And Animations(b, a) = 28 Then G = 10
        If G = 1 And Animations(b, a) = 36 Then G = 10
        If G = 1 And Animations(b, a) = 44 Then G = 10
        If G = 1 And Animations(b, a) = 62 Then G = 10
        If G = 2 And Animations(b, a) = 29 Then G = 10
        If G = 2 And Animations(b, a) = 37 Then G = 10
        If G = 2 And Animations(b, a) = 45 Then G = 10
        If G = 2 And Animations(b, a) = 63 Then G = 10
        If G = 3 And Animations(b, a) = 30 Then G = 10
        If G = 3 And Animations(b, a) = 38 Then G = 10
        If G = 3 And Animations(b, a) = 46 Then G = 10
        If G = 3 And Animations(b, a) = 64 Then G = 10
        If G = 4 And Animations(b, a) = 31 Then G = 10
        If G = 4 And Animations(b, a) = 39 Then G = 10
        If G = 4 And Animations(b, a) = 47 Then G = 10
        If G = 4 And Animations(b, a) = 65 Then G = 10
        If G = 5 And Animations(b, a) = 132 Then G = 10
        If G = 5 And Animations(b, a) = 133 Then G = 10
        If G = 5 And Animations(b, a) = 134 Then G = 10
        If G = 5 And Animations(b, a) = 135 Then G = 10
        If G = 5 And Animations(b, a) = 140 Then G = 10
    End If
    If G <> 10 Then
        xt = xt - MeX
        yt = yt - MeY
        If xt > -15 And yt > -15 And xt < ResX + 15 And yt < ResY + 15 Then
            rFlag.Top = 32 * (Colr - 1)
            rFlag.Left = 570
            rFlag.Bottom = rFlag.Top + 12
            rFlag.Right = rFlag.Left + 12
            If xt < 0 Then rFlag.Left = rFlag.Left + Abs(xt): xt = 0
            If yt < 0 Then rFlag.Top = rFlag.Top + Abs(yt): yt = 0
            If xt > ResX - 12 Then rFlag.Right = rFlag.Right - (xt - (ResX - 12)): xt = (ResX - 12) + (xt - (ResX - 12))
            If yt > ResY - 12 Then rFlag.Bottom = rFlag.Bottom - (yt - (ResY - 12)): yt = (ResY - 12) + (yt - (ResY - 12))
            If Not FlagBlink(Colr - 1, I) Then BackBuffer.BltFast xt, yt, DirectDraw_Tuna1, rFlag, DDBLTFAST_SRCCOLORKEY Or DDBLTFAST_WAIT
        End If
    End If
out:
End Sub

Public Sub SmokeTrail(SmX As Integer, SmY As Integer, Colr As Integer)
    Dim I As Integer
    For I = 0 To UBound(Smk) + 1
        If I > UBound(Smk) Then
            ReDim Preserve Smk(I)
            ReDim Preserve SmkX(I)
            ReDim Preserve SmkY(I)
            ReDim Preserve SmkColor(I)
        End If
        If Not Smk(I) Then
            Smk(I) = True
            SmkX(I) = SmX
            SmkY(I) = SmY
            SmkColor(I) = Colr
            Exit For
        End If
    Next
End Sub

Public Sub LoadMap()
2455:              If Not DevEnv Then On Error GoTo errors
2456:              Dim MBytes() As Byte, R As Long, countd As Long
2457:              Dim I As Integer, j As Integer
2458:              Dim d As Integer, F As Integer, xt As Integer, yt As Integer
2459:              Dim C As Integer, rrect As RECT, stx As Integer, sty As Integer, SrcTile(65538) As Integer
2460:              Dim TileVal(4255) As Byte
2461:              Dim Key As DDCOLORKEY
2462:              ddsdProperties.lFlags = DDSD_CAPS Or DDSD_WIDTH Or DDSD_HEIGHT
2463:              ddsdProperties.ddsCaps.lCaps = DDSCAPS_OFFSCREENPLAIN Or DDSCAPS_SYSTEMMEMORY
2464:              If Not LowMem And Not LowVRAM Then ddsdProperties.ddsCaps.lCaps = DDSCAPS_OFFSCREENPLAIN Or DDSCAPS_VIDEOMEMORY
'2465:              If LowVRAM Then ddsdProperties.ddsCaps.lCaps = DDSCAPS_OFFSCREENPLAIN Or DDSCAPS_SYSTEMMEMORY
2466:              ddsdProperties.lWidth = 16
2467:              ddsdProperties.lHeight = 16
2468:              Key.high = KEYColor
2469:              Key.low = KEYColor
2470:              ReDim Warp0(1, 0), Warp1(1, 0), Warp2(1, 0), Warp3(1, 0), Warp4(1, 0), Warp5(1, 0), Warp6(1, 0), Warp7(1, 0), Warp8(1, 0), Warp9(1, 0)
2471:              ReDim WarpOut0(0), WarpOut1(0), WarpOut2(0), WarpOut3(0), WarpOut4(0), WarpOut5(0), WarpOut6(0), WarpOut7(0), WarpOut8(0), WarpOut9(0)
2472:              ReDim Hold1(1, 0), Hold2(1, 0), Hold3(1, 0), Hold4(1, 0)
2473:              ReDim Spawn1(1, 0), Spawn2(1, 0), Spawn3(1, 0), Spawn4(1, 0)
2474:              ReDim AnimsX(10, 0), AnimsY(10, 0), TmpSX(0), TmpSY(0)
2475:              ReDim Switches(1, 0), Switched(0), FlagH1(1, 0), FlagH2(1, 0), FlagH3(1, 0), FlagH4(1, 0), FlagH5(1, 0)
2476:              '
2477:              If Len(Dir(AppPath & "attribs.dat")) = 0 Then
2478:                  ExitMSG = "attribs.dat not found!"
2479:                  Stopping = True
2480:                  Exit Sub
2481:              End If
2482:              Open AppPath & "attribs.dat" For Binary As #1
2483:              Get #1, , I
2484:              Get #1, , TileVal()
2485:              Close #1
2486:              If Len(Dir(AppPath & "rough.dat")) = 0 Then
2487:                  ExitMSG = "rough.dat not found!"
2488:                  Stopping = True
2489:                  Exit Sub
2490:              End If
2491:              Open AppPath & "rough.dat" For Binary As #1
2492:              Get #1, , RoughTile()
2493:              Close #1
2494:              '
2495:
    If Len(Dir(MapPlay)) = 0 Or Len(MapPlay) = 0 Then Stopping = True: Exit Sub
2497:              Open MapPlay For Binary As #1
2498:              Get #1, , HData
2499:              If HData.FormatID <> 17016 Then
2500:                  Close #1
2501:                  Stopping = True
2502:                  Exit Sub
2503:              End If
2504:              ReDim hFlagCounts(HData.NumTeams - 1)
2505:              ReDim hFlagPoleCounts(HData.NumTeams - 1)
2506:              Get #1, , hFlagCounts()
2507:              Get #1, , hFlagPoleCounts()
2508:              For I = 0 To HData.NumTeams - 1
2509:                  If I = 0 Then
2510:                      If hFlagPoleCounts(I) > 0 Then
2511:                          ReDim hFlagPoleBases1(hFlagPoleCounts(I) - 1)
2512:                          Get #1, , hFlagPoleBases1()
2513:                      End If
2514:                  ElseIf I = 1 Then
2515:                      If hFlagPoleCounts(I) > 0 Then
2516:                          ReDim hFlagPoleBases2(hFlagPoleCounts(I) - 1)
2517:                          Get #1, , hFlagPoleBases2()
2518:                      End If
2519:                  ElseIf I = 2 Then
2520:                      If hFlagPoleCounts(I) > 0 Then
2521:                          ReDim hFlagPoleBases3(hFlagPoleCounts(I) - 1)
2522:                          Get #1, , hFlagPoleBases3()
2523:                      End If
2524:                  ElseIf I = 3 Then
2525:                      If hFlagPoleCounts(I) > 0 Then
2526:                          ReDim hFlagPoleBases4(hFlagPoleCounts(I) - 1)
2527:                          Get #1, , hFlagPoleBases4()
2528:                      End If
2529:                  End If
2530:              Next
2531:              Get #1, , HDataNames
2532:              ReDim MBytes(131072) As Byte
2533:              Get #1, Loc(1) + 2, MBytes()
2534:              Close #1
2535:
2536:              ReDim SourceTileX(255, 255), SourceTileY(255, 255), SourceX(255, 255), SourceY(255, 255), Collision(255, 255), Animations(255, 255), AnimOffset(255, 255)
2537:              R = DecompressData(MBytes(), 131072)
2538:              If R <> 0 Then
2539:                  ExitMSG = "Failed to decompress map!"
2540:                  Stopping = True
2541:                  Exit Sub
2542:              End If
2543:              CopyMemory SrcTile(0), MBytes(0), 131072
2544:
2545:              ddsdProperties.lFlags = DDSD_CAPS Or DDSD_WIDTH Or DDSD_HEIGHT
2546:              ddsdProperties.lWidth = 640
2547:              ddsdProperties.lHeight = 480
2548:              Set DirectDraw_Tiles = DirectDraw.CreateSurface(ddsdProperties)
2549:              For C = 0 To 255
2550:                  For d = 0 To 255
2551:                      xt = (SrcTile(countd) Mod 40) * 16
2552:                      yt = (SrcTile(countd) - (SrcTile(countd) Mod 40)) / 40 * 16 'Do NOT change to integer division!
2553:                      SourceX(C, d) = xt
2554:                      SourceY(C, d) = yt
2555:                      If SrcTile(countd) > -1 And SrcTile(countd) <= UBound(TileVal) Then Collision(C, d) = TileVal(SrcTile(countd)) Else SrcTile(countd) = 0
2556:                      SourceTile(C, d) = SrcTile(countd)
2557:                      Animations(C, d) = -1
2558:                      '
2559:                      If MBytes(countd * 2 + 1) > 127 Then
2560:                          Animations(C, d) = MBytes(countd * 2)
2561:                          Collision(C, d) = TileVal(4000 + Animations(C, d))
2562:                          If Animations(C, d) <> 158 Then
2563:                              AnimOffset(C, d) = ((MBytes(countd * 2 + 1) - 128) Mod FrameCount(Animations(C, d))) + 1
2564:                          Else
2565:                              AnimOffset(C, d) = MBytes(countd * 2 + 1) - 128
2566:                          End If
2567:                          SourceX(C, d) = -1
2568:                          SourceY(C, d) = 0
2569:                      End If
2570:                      '
2571:                      If SourceX(C, d) = 0 And SourceY(C, d) = 112 Then
2572:                          SourceX(C, d) = -1
2573:                          If Animations(C, d) = -1 Then
2574:                              Collision(C, d) = 2: Animations(C, d) = -2
2575:                          End If
2576:                          GoTo skip
2577:                      End If
2578:
2579:                      TmpSX(0) = 1
2580:                      TmpSY(0) = 1
2581:                      For j = 1 To UBound(TmpSX) + 1
2582:                          If j > UBound(TmpSX) Then
2583:                              ReDim Preserve TmpSX(j), TmpSY(j)
2584:                              TmpSX(j) = SourceX(C, d)
2585:                              TmpSY(j) = SourceY(C, d)
2586:                              F = (j - 1) * 16
2587:                              stx = (F Mod 640) And -16
2588:                              sty = (F - (F Mod 640)) / 640 * 16 'Do NOT change to integer division!
2589:                              SourceTileX(C, d) = stx
2590:                              SourceTileY(C, d) = sty
                                   rrect.Left = SourceX(C, d): rrect.Right = rrect.Left + 16: rrect.Top = SourceY(C, d): rrect.Bottom = rrect.Top + 16
2592:                              Call DirectDraw_Tiles.BltFast(stx, sty, DirectDraw_Tile, rrect, DDBLTFAST_WAIT)
2593:                              Exit For
2594:                          End If
2595:                          If SourceX(C, d) = TmpSX(j) And SourceY(C, d) = TmpSY(j) Then
2596:                              F = (j - 1) * 16
2597:                              stx = (F Mod 640) And -16
2598:                              sty = (F - (F Mod 640)) / 640 * 16 'Do NOT change to integer division!
2599:                              SourceTileX(C, d) = stx
2600:                              SourceTileY(C, d) = sty
2601:                              Exit For
2602:                          End If
2603:                      Next
2604:                      If (Animations(C, d) > 23 And Animations(C, d) < 29) Or Animations(C, d) = 128 Then
2605:                          ReDim Preserve FlagPole1(1, UBound(FlagPole1, 2) + 1)
2606:                          FlagPole1(0, UBound(FlagPole1, 2)) = d * 16
2607:                          FlagPole1(1, UBound(FlagPole1, 2)) = C * 16
2608:                          If Animations(C, d) = 28 Then Animations(C, d) = 24
2609:                      ElseIf Animations(C, d) = 37 Or Animations(C, d) = 35 Or Animations(C, d) = 34 Or Animations(C, d) = 32 Or Animations(C, d) = 129 Then
2610:                          ReDim Preserve FlagPole2(1, UBound(FlagPole2, 2) + 1)
2611:                          FlagPole2(0, UBound(FlagPole2, 2)) = d * 16
2612:                          FlagPole2(1, UBound(FlagPole2, 2)) = C * 16
2613:                          If Animations(C, d) = 37 Then Animations(C, d) = 33
2614:                      ElseIf Animations(C, d) = 46 Or Animations(C, d) = 43 Or Animations(C, d) = 41 Or Animations(C, d) = 40 Or Animations(C, d) = 130 Then
2615:                          ReDim Preserve FlagPole3(1, UBound(FlagPole3, 2) + 1)
2616:                          FlagPole3(0, UBound(FlagPole3, 2)) = d * 16
2617:                          FlagPole3(1, UBound(FlagPole3, 2)) = C * 16
2618:                          If Animations(C, d) = 46 Then Animations(C, d) = 42
2619:                      ElseIf Animations(C, d) = 65 Or Animations(C, d) = 60 Or Animations(C, d) = 59 Or Animations(C, d) = 58 Or Animations(C, d) = 131 Then
2620:                          ReDim Preserve FlagPole4(1, UBound(FlagPole4, 2) + 1)
2621:                          FlagPole4(0, UBound(FlagPole4, 2)) = d * 16
2622:                          FlagPole4(1, UBound(FlagPole4, 2)) = C * 16
2623:                          If Animations(C, d) = 65 Then Animations(C, d) = 61
2624:                      ElseIf Animations(C, d) = 140 Then
2625:                          ReDim Preserve FlagPole5(1, UBound(FlagPole5, 2) + 1)
2626:                          FlagPole5(0, UBound(FlagPole5, 2)) = d * 16
2627:                          FlagPole5(1, UBound(FlagPole5, 2)) = C * 16
2628:                          Animations(C, d) = 136
2629:                      ElseIf Animations(C, d) = 123 Then
2630:                          ReDim Preserve Switches(1, UBound(Switches, 2) + 1)
2631:                          Switches(0, UBound(Switches, 2)) = d * 16
2632:                          Switches(1, UBound(Switches, 2)) = C * 16
2633:                      End If
2634:
skip:
2636:                      countd = countd + 1
2637:                  Next
2638:              Next
                   'truncatemap
2639:              Key.high = KEYColor
2640:              Key.low = KEYColor
2641:              DirectDraw_Tiles.SetColorKey DDCKEY_SRCBLT, Key
2642:              Defaults
2643:              BlitEntireMap
2644:              Exit Sub
errors:
2646:              RaiseCritical "Map loading process failed (Line #" & Erl & ". " & DQ & Err.Number & " " & Err.Description & DQ & ")"
2647:              Stopping = True
End Sub

Public Sub ARCShips(Who As Integer) 'Renders the ships on the map.
    If Players(MeNum).Mode <> 1 And (Players(Who).Mode = 1 Or Players(Who).Invisible) Then Exit Sub
    If Players(Who).Ship < 1 Or Players(Who).Ship > 6 Then Exit Sub
    Dim rSprite As RECT, I As Integer
    If Players(Who).charX = 0 And Players(Who).charY = 0 Then Exit Sub
    If Players(Who).MoveX > -32 And Players(Who).MoveY > -32 And Players(Who).MoveX < ResX + 32 And Players(Who).MoveY < ResY + 32 Then
        I = Len(Players(Who).Nick) * 0.5
        MakeText2 Chr$(2) & Players(Who).Nick & Chr$(1) & " [" & Players(Who).Score & "]", newCInt(Players(Who).MoveX) - I, newCInt(Players(Who).MoveY) + 35
        If Not Players(Who).Warping Then
            rSprite.Left = (Players(Who).animX - 1) * 32
            rSprite.Top = 32 * (Players(Who).Ship - 1)
            rSprite.Right = 32 + rSprite.Left
            rSprite.Bottom = 32 + rSprite.Top
        Else
            If (NewGTC - Players(Who).Warped) > 65000 Then Exit Sub
            I = (NewGTC - Players(Who).Warped)
            If I > 50000 Then Players(Who).Warped = NewGTC
            If I < 1501 Then
                I = I * 8 / 1500
            Else
                Exit Sub
            End If
            rSprite.Left = (Players(Who).animX - 1) * 32
            rSprite.Right = 32 + rSprite.Left
            rSprite.Top = 32 * (Players(Who).Ship - 1) + I
            rSprite.Bottom = 8 + 32 * (Players(Who).Ship - 1)
            BackBuffer.BltFast Players(Who).MoveX, Players(Who).MoveY + I, DirectDraw_Ships, rSprite, DDBLTFAST_SRCCOLORKEY Or DDBLTFAST_WAIT
            rSprite.Top = 32 * (Players(Who).Ship - 1) + I + 8
            rSprite.Bottom = 16 + 32 * (Players(Who).Ship - 1)
            BackBuffer.BltFast Players(Who).MoveX, Players(Who).MoveY + 8 + I, DirectDraw_Ships, rSprite, DDBLTFAST_SRCCOLORKEY Or DDBLTFAST_WAIT
            rSprite.Top = 32 * (Players(Who).Ship - 1) + I + 16
            rSprite.Bottom = 24 + 32 * (Players(Who).Ship - 1)
            BackBuffer.BltFast Players(Who).MoveX, Players(Who).MoveY + 16 + I, DirectDraw_Ships, rSprite, DDBLTFAST_SRCCOLORKEY Or DDBLTFAST_WAIT
            rSprite.Top = 32 * (Players(Who).Ship - 1) + I + 24
            rSprite.Bottom = 32 + 32 * (Players(Who).Ship - 1)
            BackBuffer.BltFast Players(Who).MoveX, Players(Who).MoveY + 24 + I, DirectDraw_Ships, rSprite, DDBLTFAST_SRCCOLORKEY Or DDBLTFAST_WAIT
            Exit Sub
        End If
        If Players(Who).MoveX < 0 Then rSprite.Left = rSprite.Left + Abs(Players(Who).MoveX): Players(Who).MoveX = 0
        If Players(Who).MoveY < 0 Then rSprite.Top = rSprite.Top + Abs(Players(Who).MoveY): Players(Who).MoveY = 0
        If Players(Who).MoveX > ResX - 32 Then rSprite.Right = rSprite.Right - (Players(Who).MoveX - (ResX - 32)): Players(Who).MoveX = ResX - 32 + (Players(Who).MoveX - (ResX - 32))
        If Players(Who).MoveY > ResY - 32 Then rSprite.Bottom = rSprite.Bottom - (Players(Who).MoveY - (ResY - 32)): Players(Who).MoveY = ResY - 32 + (Players(Who).MoveY - (ResY - 32))
        BackBuffer.BltFast Players(Who).MoveX, Players(Who).MoveY, DirectDraw_Ships, rSprite, DDBLTFAST_SRCCOLORKEY Or DDBLTFAST_WAIT
    End If
End Sub

Public Sub PopShip(xp As Integer, yp As Integer)
    Dim I As Integer
    For I = 0 To UBound(Popping) + 1
        If I > UBound(Popping) Then
            ReDim Preserve Popping(I), PopAnimF(I), PopX(I), PopY(I)
        End If
        If Not Popping(I) Then
            PopAnimF(I) = 0
            Popping(I) = True
            PopX(I) = xp
            PopY(I) = yp
            Exit For
        End If
    Next
End Sub

Public Sub CharUpdate(I As Integer)
    Dim j As Integer, d As Integer, DiagMvSpd As Single, LastCX As Single, LastCY As Single, e As Integer
    Dim MvSpd As Single, sx As Single, sy As Single, chs As Single
    
    MvSpd = Speed * 1.1
    
    If Players(I).FlagWho > 0 Then MvSpd = MvSpd * 0.75
    If Players(I).DevCheat > 2 Then MvSpd = MvSpd * 3
    If Players(I).Mode = 1 Then MvSpd = MvSpd * 6
    
    DiagMvSpd = 0.7 * 1.1
    chs = MvSpd / (Int(MvSpd) + 1)
    
    If Players(I).Ship = 6 Then
        Select Case Players(I).KeyIs
        Case Is = vbKeyLeft
            Players(I).animY = aLEFT2
        Case Is = vbKeyUp
            Players(I).animY = aUP2
        Case Is = vbKeyRight
            Players(I).animY = aRIGHT2
        Case Is = vbKeyDown
            Players(I).animY = aDOWN2
        End Select
    End If
    Players(I).animX = Players(I).KeyIs
    If Val(Int(MvSpd)) > 100 Then Exit Sub
    For j = 0 To Int(MvSpd)
        LastCX = Players(I).charX
        LastCY = Players(I).charY
        If Players(I).KeyIs = 1 Then
            Players(I).charX = Players(I).charX + chs
        ElseIf Players(I).KeyIs = 2 Then
            Players(I).charX = Players(I).charX + chs * DiagMvSpd
            Players(I).charY = Players(I).charY - chs * DiagMvSpd
        ElseIf Players(I).KeyIs = 3 Then
            Players(I).charY = Players(I).charY - chs
        ElseIf Players(I).KeyIs = 4 Then
            Players(I).charY = Players(I).charY - chs * DiagMvSpd
            Players(I).charX = Players(I).charX - chs * DiagMvSpd
        ElseIf Players(I).KeyIs = 5 Then
            Players(I).charX = Players(I).charX - chs
        ElseIf Players(I).KeyIs = 6 Then
            Players(I).charX = Players(I).charX - chs * DiagMvSpd
            Players(I).charY = Players(I).charY + chs * DiagMvSpd
        ElseIf Players(I).KeyIs = 7 Then
            Players(I).charY = Players(I).charY + chs
        ElseIf Players(I).KeyIs = 8 Then
            Players(I).charY = Players(I).charY + chs * DiagMvSpd
            Players(I).charX = Players(I).charX + chs * DiagMvSpd
        End If
        Call ShipTouch(I)
        For e = 1 To UBound(RetCollision)
            d = RetCollision(e)
            If d = 8 Then Players(I).charY = Players(I).charY - chs * 0.7
            If d = 9 Then Players(I).charY = Players(I).charY + chs * 0.7
            If d = 10 Then Players(I).charX = Players(I).charX - chs * 0.7
            If d = 11 Then Players(I).charX = Players(I).charX + chs * 0.7
            'The following four lines stop you from moving backwards on
            'ramps if you have a flag.
            'If D = 8 And Players(i).FlagWho > 0 And Players(i).KeyIs = 7 Then Players(i).charY = LastCY
            'If D = 9 And Players(i).FlagWho > 0 And Players(i).KeyIs = 3 Then Players(i).charY = LastCY
            'If D = 10 And Players(i).FlagWho > 0 And Players(i).KeyIs = 1 Then Players(i).charX = LastCX
            'If D = 11 And Players(i).FlagWho > 0 And Players(i).KeyIs = 5 Then Players(i).charX = LastCX
        Next
        GoSub whatever
    Next
    Exit Sub
whatever:
    sx = Players(I).charX
    sy = Players(I).charY
    '
    Call ShipTouch(I)
    If UBound(RectsRet) > 0 Then
        Players(I).charX = LastCX
        Players(I).charY = LastCY
        If (FindRectsRet(104) And FindRectsRet(105)) Or (FindRectsRet(112) And FindRectsRet(113)) Then
            Players(I).charY = sy
            Call ShipTouch(I)
            If Players(I).charY = LastCY Then
                If FindRectsRet(112) And FindRectsRet(113) Then 'touch right
                    Players(I).charX = Players(I).charX - 1
                End If
                Call ShipTouch(I)
                If FindRectsRet(104) And FindRectsRet(105) Then 'touch left
                    Players(I).charX = Players(I).charX + 1
                End If
            End If
            If UBound(RectsRet) > 0 Then Players(I).charY = LastCY
            Return
        End If
        If (FindRectsRet(101) And FindRectsRet(109)) Or (FindRectsRet(108) And FindRectsRet(116)) Then
            Players(I).charX = sx
            Call ShipTouch(I)
            If Players(I).charY = LastCY Then
                If FindRectsRet(101) And FindRectsRet(109) Then 'touch top
                    Players(I).charY = Players(I).charY + 1
                End If
                Call ShipTouch(I)
                If FindRectsRet(108) And FindRectsRet(116) Then 'touch bottom
                    Players(I).charY = Players(I).charY - 1
                End If
            End If
            If UBound(RectsRet) > 0 Then Players(I).charX = LastCX
            Return
        End If
    End If
    For e = 1 To UBound(RectsRet)
        d = RectsRet(e)
        If d = 101 Then
            If sx - LastCX <> 0 Then Players(I).charY = Players(I).charY + chs * 0.8
            If sy - LastCY <> 0 Then Players(I).charX = Players(I).charX + chs * 0.8
        End If
        If d = 102 Then
            If sx - LastCX <> 0 Then Players(I).charY = Players(I).charY + chs * 0.4
            If sy - LastCY <> 0 Then Players(I).charX = Players(I).charX + chs * 0.4
        End If
        If d = 103 Then
            If sx - LastCX <> 0 Then Players(I).charY = Players(I).charY + chs * 0.4
            If sy - LastCY <> 0 Then Players(I).charX = Players(I).charX + chs * 0.4
        End If
        '
        If d = 104 Then
            If sx - LastCX <> 0 Then Players(I).charY = Players(I).charY + chs * 0.8
            If sy - LastCY <> 0 Then Players(I).charX = Players(I).charX + chs * 0.8
        End If
        If d = 105 Then
            If sx - LastCX <> 0 Then Players(I).charY = Players(I).charY - chs * 0.8
            If sy - LastCY <> 0 Then Players(I).charX = Players(I).charX + chs * 0.8
        End If
        '
        If d = 106 Then
            If sx - LastCX <> 0 Then Players(I).charY = Players(I).charY - chs * 0.4
            If sy - LastCY <> 0 Then Players(I).charX = Players(I).charX + chs * 0.4
        End If
        If d = 107 Then
            If sx - LastCX <> 0 Then Players(I).charY = Players(I).charY - chs * 0.4
            If sy - LastCY <> 0 Then Players(I).charX = Players(I).charX + chs * 0.4
        End If
        If d = 108 Then
            If sx - LastCX <> 0 Then Players(I).charY = Players(I).charY - chs * 0.8
            If sy - LastCY <> 0 Then Players(I).charX = Players(I).charX + chs * 0.8
        End If
        '
        If d = 109 Then
            If sx - LastCX <> 0 Then Players(I).charY = Players(I).charY + chs * 0.8
            If sy - LastCY <> 0 Then Players(I).charX = Players(I).charX - chs * 0.8
        End If
        If d = 110 Then
            If sx - LastCX <> 0 Then Players(I).charY = Players(I).charY + chs * 0.4
            If sy - LastCY <> 0 Then Players(I).charX = Players(I).charX - chs * 0.4
        End If
        If d = 111 Then
            If sx - LastCX <> 0 Then Players(I).charY = Players(I).charY + chs * 0.4
            If sy - LastCY <> 0 Then Players(I).charX = Players(I).charX - chs * 0.4
        End If
        If d = 112 Then
            If sx - LastCX <> 0 Then Players(I).charY = Players(I).charY + chs * 0.8
            If sy - LastCY <> 0 Then Players(I).charX = Players(I).charX - chs * 0.8
        End If
        '
        If d = 113 Then
            If sx - LastCX <> 0 Then Players(I).charY = Players(I).charY - chs * 0.8
            If sy - LastCY <> 0 Then Players(I).charX = Players(I).charX - chs * 0.8
        End If
        If d = 114 Then
            If sx - LastCX <> 0 Then Players(I).charY = Players(I).charY - chs * 0.4
            If sy - LastCY <> 0 Then Players(I).charX = Players(I).charX - chs * 0.4
        End If
        If d = 115 Then
            If sx - LastCX <> 0 Then Players(I).charY = Players(I).charY - chs * 0.4
            If sy - LastCY <> 0 Then Players(I).charX = Players(I).charX - chs * 0.4
        End If
        If d = 116 Then
            If sx - LastCX <> 0 Then Players(I).charY = Players(I).charY - chs * 0.8
            If sy - LastCY <> 0 Then Players(I).charX = Players(I).charX - chs * 0.8
        End If
    Next
    '
    Call ShipTouch(I)
    If UBound(RectsRet) > 0 Then
        Players(I).charX = LastCX
        Players(I).charY = LastCY
        If (FindRectsRet(104) And FindRectsRet(105)) Or (FindRectsRet(112) And FindRectsRet(113)) Then
            Players(I).charY = sy
            Call ShipTouch(I)
            If UBound(RectsRet) > 0 Then Players(I).charY = LastCY
            Return
        End If
        If (FindRectsRet(101) And FindRectsRet(109)) Or (FindRectsRet(108) And FindRectsRet(116)) Then
            Players(I).charX = sx
            Call ShipTouch(I)
            If UBound(RectsRet) > 0 Then Players(I).charX = LastCX
            Return
        End If
    End If
    Return
End Sub

Public Sub AnimHit(I As Integer)
    Dim rHit As RECT, sw As Integer, sh As Integer, j As Integer
    Static Frame() As Single, ArraySet As Boolean
    If Not ArraySet Then ArraySet = True: ReDim Frame(0)
    If UBound(IsHit) > UBound(Frame) Then ReDim Preserve Frame(UBound(IsHit))
    If BackBuffer.isLost Then Exit Sub
    j = Frame(I)
    rHit.Top = rShipHit(j).Top
    rHit.Bottom = rShipHit(j).Bottom
    rHit.Left = rShipHit(j).Left
    rHit.Right = rShipHit(j).Right
    sw = rHit.Right - rHit.Left
    sh = rHit.Bottom - rHit.Top
    sw = HitX(I) - MeX - (sw / 2)
    sh = HitY(I) - MeY - (sh / 2)
    BackBuffer.BltFast sw, sh, DirectDraw_Tuna1, rHit, DDBLTFAST_SRCCOLORKEY Or DDBLTFAST_WAIT
    Frame(I) = Frame(I) + Speed * 0.5
    If Frame(I) > 6 Then
        Frame(I) = 0
        IsHit(I) = False
    End If
End Sub

Public Sub AnimSmoke2(I As Integer) 'Missile Smoke
    Dim rSmoke As RECT
    Dim ExX As Integer, ExY As Integer, sw As Integer, sh As Integer
    Static FrameT2() As Single, FrameXC2() As Single, ArraySet As Boolean
    If Not ArraySet Then
        ArraySet = True
        ReDim FrameT2(0), FrameXC2(0)
    End If
    If UBound(FrameXC2) < UBound(Smk2) Then
        ReDim Preserve FrameT2(UBound(Smk2)), FrameXC2(UBound(Smk2))
    End If
    If SmkColor2(I) = 2 Then ExX = 90
    If SmkColor2(I) = 3 Then ExY = 11
    If SmkColor2(I) = 4 Then ExX = 90: ExY = 11
    If SmkColor2(I) = 5 Then ExX = 90: ExY = 54
    
    rSmoke.Left = rMissSmoke(FrameXC2(I)).Left + ExX
    rSmoke.Right = rMissSmoke(FrameXC2(I)).Right + ExX
    rSmoke.Top = rMissSmoke(FrameXC2(I)).Top + ExY
    rSmoke.Bottom = rMissSmoke(FrameXC2(I)).Bottom + ExY
    sw = rSmoke.Right - rSmoke.Left
    sh = rSmoke.Bottom - rSmoke.Top
    ExX = SmkX2(I) - MeX - (sw / 2)
    ExY = SmkY2(I) - MeY - (sh / 2)
    
    If ExX < 0 Then rSmoke.Left = rSmoke.Left + Abs(ExX): ExX = 0
    If ExY < 0 Then rSmoke.Top = rSmoke.Top + Abs(ExY): ExY = 0
    If ExX > ResX - sw Then rSmoke.Right = rSmoke.Right - (ExX - (ResX - sw)): ExX = (ResX - sw) + (ExX - (ResX - sw))
    If ExY > ResY - sh Then rSmoke.Bottom = rSmoke.Bottom - (ExY - (ResY - sh)): ExY = (ResY - sh) + (ExY - (ResY - sh))
    If BackBuffer.isLost Then GoTo skip
    BackBuffer.BltFast ExX, ExY, DirectDraw_Tuna1, rSmoke, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
skip:
    FrameXC2(I) = FrameXC2(I) + Speed * 0.5
    If FrameXC2(I) > 8 Then
        FrameXC2(I) = 0
        Smk2(I) = False
        Exit Sub
    End If
End Sub

Public Function FlagPlay(Buff As Integer) As Boolean
    If Not Captured(Buff) Then Exit Function
    If Not EnableSound Then Exit Function
    FlagPlay = True
    If Not EnableSound Then
        Captured(Buff) = False
        Exit Function
    End If
    If SndCnt = 0 Then
        If dsTeam.GetStatus = DSBSTATUS_PLAYING Then Exit Function
        If dsBase.GetStatus = DSBSTATUS_PLAYING Then Exit Function
        If dsTeamWins.GetStatus = DSBSTATUS_PLAYING Then Exit Function
        Select Case FlagCap(Buff)
        Case 1
            dsGreen.Play DSBPLAY_DEFAULT
        Case 2
            dsRed.Play DSBPLAY_DEFAULT
        Case 3
            dsBlue.Play DSBPLAY_DEFAULT
        Case 4
            dsYellow.Play DSBPLAY_DEFAULT
        Case 5
            dsNeutral.Play DSBPLAY_DEFAULT
        End Select
        SndCnt = SndCnt + 1
    ElseIf SndCnt = 1 Then
        If dsGreen.GetStatus = DSBSTATUS_PLAYING Then Exit Function
        If dsRed.GetStatus = DSBSTATUS_PLAYING Then Exit Function
        If dsBlue.GetStatus = DSBSTATUS_PLAYING Then Exit Function
        If dsYellow.GetStatus = DSBSTATUS_PLAYING Then Exit Function
        If dsNeutral.GetStatus = DSBSTATUS_PLAYING Then Exit Function
        If FlagStatus(Buff) = 1 Then
            dsFlagCap.Play DSBPLAY_DEFAULT
        ElseIf FlagStatus(Buff) = 2 Then
            dsFlagRet.Play DSBPLAY_DEFAULT
        ElseIf FlagStatus(Buff) = 4 Then
            dsSWFlip.Play DSBPLAY_DEFAULT
        End If
        SndCnt = SndCnt + 1
    ElseIf SndCnt = 2 Then
        If dsSWFlip.GetStatus = DSBSTATUS_PLAYING Then Exit Function
        If dsFlagCap.GetStatus = DSBSTATUS_PLAYING Then Exit Function
        If dsFlagRet.GetStatus = DSBSTATUS_PLAYING Then Exit Function
        If dsTeam.GetStatus = DSBSTATUS_PLAYING Then Exit Function
        If FlagStatus(Buff) <> 3 Then
            Select Case WhoTeam(Buff)
            Case 1
                dsGreen.Play DSBPLAY_DEFAULT
            Case 2
                dsRed.Play DSBPLAY_DEFAULT
            Case 3
                dsBlue.Play DSBPLAY_DEFAULT
            Case 4
                dsYellow.Play DSBPLAY_DEFAULT
            Case 5
                dsNeutral.Play DSBPLAY_DEFAULT
            End Select
        End If
        SndCnt = SndCnt + 1
    ElseIf SndCnt = 3 Then
        If dsGreen.GetStatus = DSBSTATUS_PLAYING Then Exit Function
        If dsRed.GetStatus = DSBSTATUS_PLAYING Then Exit Function
        If dsBlue.GetStatus = DSBSTATUS_PLAYING Then Exit Function
        If dsYellow.GetStatus = DSBSTATUS_PLAYING Then Exit Function
        If dsNeutral.GetStatus = DSBSTATUS_PLAYING Then Exit Function
        If FlagStatus(Buff) = 1 Or FlagStatus(Buff) = 4 Then
            dsTeam.Play DSBPLAY_DEFAULT
        ElseIf FlagStatus(Buff) = 2 Then
            dsBase.Play DSBPLAY_DEFAULT
        ElseIf FlagStatus(Buff) = 3 Then
            dsTeamWins.Play DSBPLAY_DEFAULT
        End If
        SndCnt = 0
        Captured(Buff) = False
    End If
End Function

Public Sub Pop(I As Integer)
    Dim rPop As RECT
    Dim xt As Integer, yt As Integer, ew As Integer, eh As Integer
    ew = (rShipExp(PopAnimF(I)).Right - rShipExp(PopAnimF(I)).Left)
    eh = (rShipExp(PopAnimF(I)).Bottom - rShipExp(PopAnimF(I)).Top)
    xt = PopX(I) - MeX - ew \ 2
    yt = PopY(I) - MeY - eh \ 2
    rPop.Left = rShipExp(PopAnimF(I)).Left
    rPop.Right = rShipExp(PopAnimF(I)).Right
    rPop.Top = rShipExp(PopAnimF(I)).Top
    rPop.Bottom = rShipExp(PopAnimF(I)).Bottom
    If xt < 0 Then rPop.Left = rPop.Left + Abs(xt): xt = 0
    If yt < 0 Then rPop.Top = rPop.Top + Abs(yt): yt = 0
    If xt > ResX - ew Then rPop.Right = rPop.Right - (xt - (ResX - ew)): xt = (ResX - ew) + (xt - (ResX - ew))
    If yt > ResY - eh Then rPop.Bottom = rPop.Bottom - (yt - (ResY - eh)): yt = (ResY - eh) + (yt - (ResY - eh))
    If BackBuffer.isLost Then Exit Sub
    BackBuffer.BltFast xt, yt, DirectDraw_Tuna1, rPop, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
    PopAnimF(I) = PopAnimF(I) + 0.5 * Speed
    If PopAnimF(I) > 23 Then
        Popping(I) = False
        PopAnimF(I) = 0
        Exit Sub
    End If
End Sub

Public Sub Menus()
2707:      'On Error GoTo ErrorTrap
2708:      Dim rBuff As RECT
2709:      Dim xt As Integer, yt As Integer
2710:      If NavMenu = 3 Then ShowPlayers
2711:      If NavMenu = 4 Then
2712:          rBuff.Top = 60
2713:          rBuff.Bottom = rBuff.Top + 95
2714:          rBuff.Left = 251
2715:          rBuff.Right = rBuff.Left + 101
2716:          BackBuffer.BltFast ResX - 135, 18, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY  ' DirectDraw_Menu
2717:      End If
2718:      Interface
2719:      If TimeTick > 0 Then
2720:          TimeTick = TimeLimit - (NewGTC - TimeClock) * 0.001
2721:          If TimeTick > 0 Then DisplayTime
2722:      End If
2723:      If NavMenu = 1 Then Radar
2724:      ShowTeamScores
2725:      If AnimateMenu Then AnimMenu
2726:      If MenuMenu = 1 Then
2727:          xt = CenterX - 195
2728:          yt = CenterY - 90
2729:          SlctBox 420, 215
               MakeText Chr$(4) & "- " & UCase$(ProjectName) & " INSTRUCTION NAVIGATOR -", xt + 110, yt, False
2731:          yt = yt + 20
2732:          MakeText Chr$(7) & "CONTROLS", xt, yt, False
2733:          yt = yt + 20
2734:          MakeText Chr$(5) & "ARROW KEYS - Controls your ship", xt, yt, False
2735:          yt = yt + 10
2736:          MakeText Chr$(5) & "CTRL - Selects secondary weapon", xt, yt, False
2737:          yt = yt + 10
2738:          MakeText Chr$(5) & "MOUSE - Aims your weapons", xt, yt, False
2739:          yt = yt + 10
2740:          MakeText Chr$(5) & "LEFT CLICK - Fires laser", xt, yt, False
2741:          yt = yt + 10
2742:          MakeText Chr$(5) & "RIGHT CLICK - Fires secondary weapon if secondary weapon is charged", xt, yt, False
2743:          yt = yt + 20
               MakeText Chr$(7) & "HELP TOPICS:", xt, yt, False
2745:          yt = yt + 10
               MakeText Chr$(8) & "  THE ONE MINUTE " & UCase$(ProjectName) & " GUIDE", xt, yt, False
2747:          yt = yt + 10
2748:          MakeText Chr$(8) & "  GAME OBJECTIVES", xt, yt, False
2749:          yt = yt + 10
2750:          MakeText Chr$(8) & "  CREDITS", xt, yt, False
2751:          yt = yt + 20
2752:          MakeText Chr$(7) & ProjectName & " Version " & App.Major & "." & App.Minor & "." & App.Revision & " - By " & App.CompanyName, xt, yt, False
2753:          yt = yt + 20
2754:          ReplyGfx "ok", CLng(xt + 5), CLng(yt)
2755:      ElseIf MenuMenu = 2 Then
2756:          SlctBox 342, 167
2757:          rBuff.Top = 12
2758:          rBuff.Bottom = rBuff.Top + 45
2759:          rBuff.Left = 300
2760:          rBuff.Right = 60 * HData.NumTeams + rBuff.Left
2761:          MakeText "Click on the ship of the team you want to change to.", CenterX - 150, CenterY - 65, False
               MakeText "Note:  There is a forced delay between your last shot", CenterX - 150, CenterY - 45, False
2763:          MakeText "and when you may change teams.  If the button below", CenterX - 150, CenterY - 34, False
2764:          MakeText "doesn't 'work', wait a moment and try again.", CenterX - 150, CenterY - 23, False
2765:          Call BackBuffer.BltFast(CenterX - 132, CenterY, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT) ' DirectDraw_ShipButtons
2766:          ReplyGfx "cancel", CenterX - 146, CenterY + 55
2767:      End If
2768:      If MenuMenu = 3 Then
2769:          'SlctBox 190, 150
2770:          SlctBox 200, 150
2771:          DoConfig
2772:      End If
2773:      If MenuMenu = 4 Then
2774:          SlctBox 260, 57
2775:          If BackBuffer.isLost = 0 Then
2776:              MakeText "Are you sure you want to leave " & ProjectName & "?", CenterX - 106, CenterY - 13, False
2777:          End If
2778:          ReplyGfx "yes", Menu4Rect(0).Left, Menu4Rect(0).Top
2779:          ReplyGfx "no", Menu4Rect(1).Left, Menu4Rect(1).Top
2780:      ElseIf MenuMenu = 5 Then
2781:          xt = CenterX - 180
2782:          yt = CenterY - 110
2783:          SlctBox 400, 250
2784:          MakeText Chr$(4) & ProjectName & " Controls", xt, yt, False
2785:          yt = yt + 20
2786:          MakeText Chr$(5) & "Steer your saucer using the arrow keys. Aim weapons using the", xt, yt, False
2787:          yt = yt + 10
2788:          MakeText Chr$(5) & "mouse. Left-click to fire your fast-recharging laser and", xt, yt, False
2789:          yt = yt + 10
2790:          MakeText Chr$(5) & "right-click to fire your secondary weapons.", xt, yt, False
2791:          yt = yt + 20 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
               MakeText Chr$(5) & "Press CTRL to toggle between the different secondary weapons:", xt, yt, False
2793:          yt = yt + 10
2794:          MakeText Chr$(5) & "rocket, bomb and bouncy laser. You can store up to three", xt, yt, False
2795:          yt = yt + 10
2796:          MakeText Chr$(5) & "shots for missiles and bouncies but two shots for bombs.", xt, yt, False
2797:          yt = yt + 10
2798:          MakeText Chr$(5) & "Secondary weapons recharge slowly; bouncy lasers recharge", xt, yt, False
2799:          yt = yt + 10
2800:          MakeText Chr$(5) & "fastest and bombs slowest. You can tell how many shots you have", xt, yt, False
2801:          yt = yt + 10
2802:          MakeText Chr$(5) & "by the number of yellow dots beside your aiming cross hair and", xt, yt, False
2803:          yt = yt + 10
2804:          MakeText Chr$(5) & "beside each weapon icon on the right side of the screen.", xt, yt, False
2805:          yt = yt + 20
2806:          MakeText Chr$(5) & "Every saucer that's the same Color as yours is on your team.", xt, yt, False
2807:          yt = yt + 10
2808:          MakeText Chr$(5) & "The other Color is the enemy! Destroy them! On most maps,", xt, yt, False
2809:          yt = yt + 10
2810:          MakeText Chr$(5) & "steal the enemy's flags and take them to your base.", xt, yt, False
2811:          yt = yt + 20
2812:          MakeText Chr$(5) & "To chat with other players, type and press Enter. To chat", xt, yt, False
2813:          yt = yt + 10
2814:          MakeText Chr$(5) & "with only your teammates, first type a semicolon (;), then", xt, yt, False
2815:          yt = yt + 10
2816:          MakeText Chr$(5) & "the rest of your message.", xt, yt, False
2817:          yt = yt + 20
2818:          MakeText Chr$(8) & "BACK TO MAIN HELP", xt, yt, False
2819:      ElseIf MenuMenu = 6 Then
2820:          xt = CenterX - 165
2821:          yt = CenterY - 117
2822:          SlctBox 370, 270
2823:          MakeText Chr$(4) & ProjectName & " Game Objectives.", xt, yt, False
2824:          yt = yt + 20
2825:          MakeText Chr$(6) & "Capture the colored flags.", xt, yt, False
2826:          yt = yt + 20
2827:          MakeText Chr$(5) & "Your objective is to fight your way into enemy territory", xt, yt, False
2828:          yt = yt + 10
2829:          MakeText Chr$(5) & "and capture their flag while defending your own. Your", xt, yt, False
2830:          yt = yt + 10
2831:          MakeText Chr$(5) & "team wins when you place a flag on all of your flag poles.", xt, yt, False
2832:          yt = yt + 20
2833:          MakeText Chr$(6) & "Capture the white flags.", xt, yt, False
2834:          yt = yt + 20
2835:          MakeText Chr$(5) & "Your objective is to capture all of the white flags on this", xt, yt, False
2836:          yt = yt + 10
2837:          MakeText Chr$(5) & "level. Your team wins when you have placed a white flag on", xt, yt, False
2838:          yt = yt + 10
2839:          MakeText Chr$(5) & "each flag post.", xt, yt, False
2840:          yt = yt + 20
2841:          MakeText Chr$(6) & "Power switch game.", xt, yt, False
2842:          yt = yt + 20
2843:          MakeText Chr$(5) & "Toggle all the mega power switches to your team Color. Then", xt, yt, False
2844:          yt = yt + 10
2845:          MakeText Chr$(5) & "your team flips the super-mega power switch and wins!", xt, yt, False
2846:          yt = yt + 20
2847:          MakeText Chr$(6) & "Frag fest.", xt, yt, False
2848:          yt = yt + 20
2849:          MakeText Chr$(5) & "Destroy everyone that's not on your team.", xt, yt, False
2850:          yt = yt + 20
2851:          MakeText Chr$(8) & "BACK TO MAIN HELP", xt, yt, False
2852:      ElseIf MenuMenu = 7 Then
2853:          xt = CenterX - 159
2854:          yt = CenterY - 117
2855:          SlctBox 350, 270
2856:          MakeText Chr$(4) & ProjectName & " Credits", xt, yt, False
2857:          yt = yt + 20
2858:          MakeText Chr$(7) & ProjectName & " Developers", xt, yt, False
2859:          yt = yt + 20
2860:          MakeText Chr$(6) & "odret - " & ProjectName & "'s lead developer.", xt, yt, False
2861:          yt = yt + 20
2862:          MakeText Chr$(6) & "dionyziz - developer, and our database man!", xt, yt, False
2863:          yt = yt + 20
2864:          MakeText Chr$(6) & "OMouse - developer, primarily working on a C++ OpenARC.", xt, yt, False
2865:          yt = yt + 20
2866:          MakeText Chr$(6) & "All " & ProjectName & " fans! If it weren't for you there wouldn't", xt, yt, False
2867:          yt = yt + 10
2868:          MakeText Chr$(6) & "be a new, faster release!", xt, yt, False
2869:          yt = yt + 10
2870:          MakeText Chr$(6) & "(not to mention the fact it works on Windows 95 now)", xt, yt, False
2871:          yt = CenterY + 113
2872:          MakeText Chr$(8) & "BACK TO MAIN HELP", xt, yt, False
2873:          MakeText Chr$(8) & ProjectName & " Credits Part 2", xt + 200, yt, False
2874:      ElseIf MenuMenu = 8 Then
2875:          xt = CenterX - 159
2876:          yt = CenterY - 117
2877:          SlctBox 350, 270
2878:          MakeText Chr$(4) & ProjectName & " Credits Continued.", xt, yt, False
2879:          yt = yt + 20
2880:          MakeText Chr$(7) & ProjectName & " Development", xt, yt, False
2881:          yt = yt + 20
2882:          MakeText Chr$(6) & "Thank you John Vechey for creating ARC. If it wasn't", xt, yt, False
2883:          yt = yt + 10
2884:          MakeText Chr$(6) & "for you and your hard work, there would be no " & ProjectName & "!", xt, yt, False
2885:          yt = yt + 10
2886:          yt = CenterY + 113
2887:          MakeText Chr$(8) & "BACK TO MAIN HELP", xt, yt, False
2888:      ElseIf MenuMenu = 9 Then
2889:          xt = CenterX - 180
2890:          yt = CenterY - 67
2891:          SlctBox 390, 160
2892:          MakeText Chr$(4) & ProjectName & " Commands.", xt, yt, False
2893:          yt = yt + 15
2894:          MakeText Chr$(6) & "/Clear - Clear chat text.", xt, yt, False
2895:          yt = yt + 10
2896:          MakeText Chr$(6) & "/Ignore <player> - Blocks chat text to your screen from player.", xt, yt, False
2897:          yt = yt + 10
2898:          MakeText Chr$(6) & "/Unignore <player> - See player chat text.", xt, yt, False
2899:          If Players(MeNum).Admin Then
2900:              yt = yt + 10
2901:              MakeText Chr$(6) & "/Playpass <newpassword> - Sets game password.", xt, yt, False
2902:              yt = yt + 10
2903:              MakeText Chr$(6) & "/Mute <player> - Block player chat from all players.", xt, yt, False
2904:              yt = yt + 10
2905:              MakeText Chr$(6) & "/Unmute <player> - Allow the player to chat.", xt, yt, False
2906:              yt = yt + 10
2907:              MakeText Chr$(6) & "/Ban <player> - Bans or unbans (/Clearbans).", xt, yt, False
2908:              yt = yt + 10
2909:              MakeText Chr$(6) & "/Kick <player> - Disconnects player from the game.", xt, yt, False
2910:              yt = yt + 10
2911:              MakeText Chr$(6) & "/Reset - Sends flags to home basses and clears scores.", xt, yt, False
2912:              yt = yt + 10
2913:              MakeText Chr$(6) & "/Lock - Keeps players in holding pen.", xt, yt, False
2914:              yt = yt + 10
2915:              MakeText Chr$(6) & "/Unlock - Releases players.", xt, yt, False
2916:          End If
2917:          yt = CenterY + 63
2918:          ReplyGfx "ok", CLng(xt), CLng(yt)
2919:      End If
2920:
2921:      Exit Sub
2922:
ErrorTrap:
2924:      RaiseCritical "Menus() failed. (Line #" & Erl & ". " & DQ & Err.Number & " " & Err.Description & DQ & ")"
2925:      Stopping = True
End Sub

Public Sub DisplayScores()
    '120, 9
    Dim SpcCnt(5) As Integer, tmp As String, I As Integer, j As Integer, HighestScr As Integer
    MakeText Chr$(1) & "Green Team", 10, 120, False
    MakeText Chr$(2) & "Red Team", 160, 120, False
    If HData.NumTeams > 2 Then MakeText Chr$(3) & "Blue Team", 310, 120, False
    If HData.NumTeams > 3 Then MakeText Chr$(4) & "Yellow Team", 460, 120, False
    If HData.NumTeams > 4 Then MakeText Chr$(5) & "Neutral Team", 610, 120, False
    For I = 1 To UBound(Players)
        If Players(I).Score > HighestScr Then HighestScr = Players(I).Score
    Next
    For j = HighestScr To 0 Step -1
        For I = 1 To UBound(Players)
            If Players(I).Score = j Then
                If Players(I).Ship < 6 Then
                    SpcCnt(Players(I).Ship) = SpcCnt(Players(I).Ship) + 1
                    If Players(I).InPen Then
                        tmp = Chr$(4) & Players(I).Score & Chr$(11) & " " & Players(I).Nick
                    Else
                        tmp = Chr$(4) & Players(I).Score & Chr$(5) & " " & Players(I).Nick
                    End If
                    If Players(I).Mode > 0 Then tmp = Chr$(4) & Players(I).Score & Chr$(9) & " obs-" & Chr$(5) & Players(I).Nick
                    MakeText tmp, 16 + (150 * (Players(I).Ship - 1)), 132 + (SpcCnt(Players(I).Ship) * 12), False
                End If
            End If
        Next
    Next
End Sub

Sub MPointer()
    Static PointTime As Single
    Dim I As Integer
    Pointer = 5
    If MenuMenu = 3 Then If CheckRectsMenuMenu3 > 0 Then GoTo pnter
    If NavMenu = 4 Then If CheckRectsMenu4 > 0 Then GoTo pnter
    If NavMenu = 3 Then If CheckRectsMenu3 > 0 Or CheckRectsPlayerOpt > 0 Then GoTo pnter
    If MenuMenu = 1 Or (MenuMenu > 4 And MenuMenu < 9) Then If CheckRectsMenuMenu1 > 0 Then GoTo pnter
    If MenuMenu = 2 Then If CheckRectsMenuMenu2 > 0 Then GoTo pnter
    If MenuMenu = 4 Then If CheckRectsMenuMenu4 > 0 Then GoTo pnter
    If MenuMenu = 9 Then If CheckRectMenu9 Then GoTo pnter
    If Advertisements Then If CheckRectsAd Then GoTo pnter
    I = CheckRectsNav
    If I > 9 Then GoTo pnter
    Pointer = 4
    If I > 0 Then GoTo pnter
    Pointer = Weapon Mod 4
    If Pointer = 0 Then Pointer = 1
    Exit Sub
pnter:
    If NewGTC - PointTime > 100 Then
        PointFrame = PointFrame - 1
        If PointFrame < 1 Then PointFrame = 3
        PointTime = NewGTC
    End If
End Sub

Public Sub CrossHairs()
    Dim Rch As RECT
    If Pointer > 3 Then
        Rch.Left = (Pointer + 2) * 32 + 147
        Rch.Right = Rch.Left + MWidth
        Rch.Top = 32 * PointFrame + 279
        Rch.Bottom = Rch.Top + MHeight
        'Stop
        Call BackBuffer.BltFast(g_cursorx, g_cursory, DirectDraw_NavBar, Rch, DDBLTFAST_SRCCOLORKEY Or DDBLTFAST_WAIT)
        Exit Sub
    End If
    Dim RechargeCheck As Integer, AmmoAmmount As Integer
    If Not cfgm Or (cfgm And Not cfgm2) Then
        If Weapon = 1 Then
            AmmoAmmount = MissAmmo
            If WepRecharge < 40 Then RechargeCheck = 1
        ElseIf Weapon = 2 Then
            AmmoAmmount = MortarAmmo
            If WepRecharge < 24 Then RechargeCheck = 1
        ElseIf Weapon = 3 Then
            AmmoAmmount = BounceAmmo
        End If
    End If
    
    If WepRecharge < 12 Then RechargeCheck = 1
    If Not cfgm Then If AmmoAmmount = 0 Then RechargeCheck = 1
    If cfgm And Not cfgm2 Then If AmmoAmmount = 0 Then RechargeCheck = 1
    AmmoAmmount = 96 - (AmmoAmmount * 32)
    If cfgm Then
        If RechargeCheck = 1 Then
            Rch.Left = 151
            Rch.Right = Rch.Left + MWidth - 8 '24
            Rch.Top = 410
            Rch.Bottom = Rch.Top + MHeight - 10 '22
        Else
            Rch.Left = 183
            Rch.Right = Rch.Left + MWidth - 8 '24
            Rch.Top = 410
            Rch.Bottom = Rch.Top + MHeight - 10 '22
        End If
        If cfgm2 Then
            'Stop
            Call BackBuffer.BltFast(g_cursorx + 5, g_cursory + 5, DirectDraw_NavBar, Rch, DDBLTFAST_SRCCOLORKEY Or DDBLTFAST_WAIT)
            Exit Sub
        End If
    End If
    Rch.Left = (Pointer - 1) * 64 + 32 - (32 * RechargeCheck) + 147
    Rch.Right = Rch.Left + MWidth
    Rch.Top = AmmoAmmount + 279
    Rch.Bottom = Rch.Top + MHeight
    Call BackBuffer.BltFast(g_cursorx, g_cursory, DirectDraw_NavBar, Rch, DDBLTFAST_SRCCOLORKEY Or DDBLTFAST_WAIT)
End Sub

Public Function MakeText(txt As String, tx As Integer, ty As Integer, buildtrim As Boolean, Optional ddSurf7 As DirectDrawSurface7) As Integer
    Dim I As Integer, p As Integer, a As Integer
    Dim t As String
    Dim C As Byte
    Dim ap As Byte
    Dim q As Integer
    If ddSurf7 Is Nothing Then Set ddSurf7 = BackBuffer
    q = ResX - 160
    C = 5
    For I = 1 To Len(txt)
        t = Mid$(txt, I, 1)
        a = Asc(t)
        If a = 1 Then C = 1: GoTo skip2
        If a = 2 Then C = 2: GoTo skip2
        If a = 3 Then C = 3: GoTo skip2
        If a = 4 Then C = 4: GoTo skip2
        If a = 5 Then C = 5: GoTo skip2
        If a = 6 Then C = 6: GoTo skip2
        If a = 7 Then C = 7: GoTo skip2
        If a = 8 Then C = 8: GoTo skip2
        If a = 9 Then C = 9: GoTo skip2
        If a = 10 Then C = 10: GoTo skip2
        If a = 11 Then C = 11: GoTo skip2
        If a > 64 And a < 91 Then ap = (a - 65) * 2 + 1: GoTo skip
        If a > 96 And a < 123 Then ap = (a - 97) * 2 + 2: GoTo skip
        If a = 32 Then ap = 0: GoTo skip
        If t = "!" Then ap = 53: GoTo skip
        If t = "?" Then ap = 54: GoTo skip
        If a > 48 And a < 58 Then ap = a - 49 + 55: GoTo skip
        If t = "0" Then ap = 64: GoTo skip
        If t = "." Then ap = 65: GoTo skip
        If t = "," Then ap = 66: GoTo skip
        If t = "-" Then ap = 67: GoTo skip
        If t = "+" Then ap = 68: GoTo skip
        If t = "(" Then ap = 69: GoTo skip
        If t = ")" Then ap = 70: GoTo skip
        If t = "`" Then ap = 71: GoTo skip
        If t = "~" Then ap = 72: GoTo skip
        If t = "@" Then ap = 73: GoTo skip
        If t = "$" Then ap = 74: GoTo skip
        If t = "#" Then ap = 75: GoTo skip
        If t = "%" Then ap = 76: GoTo skip
        If t = "*" Then ap = 77: GoTo skip
        If t = "[" Then ap = 78: GoTo skip
        If t = "]" Then ap = 79: GoTo skip
        If t = "{" Then ap = 80: GoTo skip
        If t = "}" Then ap = 81: GoTo skip
        If t = "|" Then ap = 82: GoTo skip
        If t = "/" Then ap = 83: GoTo skip
        If t = "\" Then ap = 84: GoTo skip
        If t = ":" Then ap = 85: GoTo skip
        If t = ";" Then ap = 86: GoTo skip
        If a = 34 Then ap = 87: GoTo skip
        If t = "=" Then ap = 88: GoTo skip
        If t = "<" Then ap = 89: GoTo skip
        If t = ">" Then ap = 90: GoTo skip
        If t = "&" Then ap = 91: GoTo skip
        If t = "^" Then ap = 92: GoTo skip
        If t = "'" Then ap = 93: GoTo skip
        If t = "_" Then ap = 94: GoTo skip
        If t = Chr$(255) Then ap = 95: GoTo skip
        ap = 32
skip:
        rChars(ap).Top = C * 10
        rChars(ap).Bottom = rChars(ap).Top + 10
        If buildtrim Then
            ddSurf7.BltFast tx + p, ty, DirectDraw_Text, rChars(ap), DDBLTFAST_WAIT
        Else
            ddSurf7.BltFast tx + p, ty, DirectDraw_Text, rChars(ap), DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
        End If
        p = p + rChars(ap).Right - rChars(ap).Left
        If p > q And buildtrim Then
            MakeText = I
            Exit Function
        End If
skip2:
        ap = 0
    Next
    MakeText = Len(txt)
End Function

Public Sub PlayMoves()
    Dim lOffset As Long
    Dim playercount As Byte
    Dim T1 As Byte, T2 As Byte, T3 As Integer, T4 As Integer
    Dim I As Integer
    
    PBuffer = 1
    If PingTime > 300 Then PBuffer = 2
    If PingTime > 400 Then PBuffer = 3
    If PingTime > 500 Then PBuffer = 4

    If MoveCounter >= PBuffer Then MovePlay = True
    If MoveCounter < 1 Then MovePlay = False
    If Not MovePlay Then Exit Sub
    GetBufferData_Old MoveBuffer, VarPtr(playercount), LenB(playercount), lOffset
    '
    If playercount = 254 Or playercount = 253 Or playercount = 252 Then
        GetBufferData_Old MoveBuffer, VarPtr(T1), LenB(T1), lOffset
        GetBufferData_Old MoveBuffer, VarPtr(T2), LenB(T2), lOffset
        GetBufferData_Old MoveBuffer, VarPtr(T3), LenB(T3), lOffset
        GetBufferData_Old MoveBuffer, VarPtr(T4), LenB(T4), lOffset
        
        If playercount = 254 Then '254 signifies 'in the pen'
            If T1 = MeNum Then
                Defaults
                Players(MeNum).HoldingPen = NewGTC
                HoldWait = WepRge.HldTme
            End If
            Players(T1).charX = T3
            Players(T1).charY = T4
            Players(T1).ArmCrt = False
            Players(T1).Invisible = False
            Players(T1).InPen = True
            playercount = 1
        End If
        '
        If playercount = 253 Then '253 signifies 'out of the pen'
            playercount = 1
            If Players(T1).Invisible Then GoTo out
            Players(T1).charX = T3
            Players(T1).charY = T4
            Players(T1).InPen = False
            If T1 = MeNum Then
                If EnableSound Then dsSpawn.Play DSBPLAY_DEFAULT
            End If
        End If
        '
        If playercount = 252 Then '252 is 'warping'
            playercount = 1
            Players(T1).charX = T3
            Players(T1).charY = T4
        End If
        '
        GoTo out
    End If
    '
    For I = 1 To playercount
        GetBufferData_Old MoveBuffer, VarPtr(T1), LenB(T1), lOffset
        GetBufferData_Old MoveBuffer, VarPtr(T2), LenB(T2), lOffset
        GetBufferData_Old MoveBuffer, VarPtr(T3), LenB(T3), lOffset
        GetBufferData_Old MoveBuffer, VarPtr(T4), LenB(T4), lOffset
        
        If T1 > UBound(Players) Then GoTo skip
        If LenB(Players(T1).Nick) = 0 Then GoTo skip
        If T1 <> MeNum Then
            Players(T1).KeyIs = T2
            If Players(T1).Invisible Then
                Players(T1).KeyIs = 9
            Else
                Players(T1).KeyIs = T2
            End If
        End If
        If (T1 <> MeNum Or Players(T1).Warping) And (T3 <> 0 Or T4 <> 0) Then
            Players(T1).charX = T3
            Players(T1).charY = T4
        End If
skip:
    Next
out:
    CopyMemory MoveBuffer(0), MoveBuffer(lOffset), MoveBufferPtr - lOffset
    MoveBufferPtr = MoveBufferPtr - playercount * 6 - 1
    MoveCounter = MoveCounter - 1
End Sub

Public Sub SmokeTrail2(SmX2 As Integer, SmY2 As Integer, Colr As Integer)
    Dim I As Integer
    For I = 0 To UBound(Smk2) + 1
        If I > UBound(Smk2) Then
            ReDim Preserve Smk2(I)
            ReDim Preserve SmkX2(I)
            ReDim Preserve SmkY2(I)
            ReDim Preserve SmkColor2(I)
        End If
        If Not Smk2(I) Then
            Smk2(I) = True
            SmkX2(I) = SmX2
            SmkY2(I) = SmY2
            SmkColor2(I) = Colr
            Exit For
        End If
    Next
    SmkY2(I) = SmkY2(I) + 1
End Sub

Public Function ShipRects(Who As Integer, by As Integer, bx As Integer, Bool As Boolean) As Boolean
    Dim rWho As RECT, rBlock As RECT, rTemp As RECT
    If Bool Then
        rBlock.Left = bx
        rBlock.Right = rBlock.Left + 1
        rBlock.Top = by
        rBlock.Bottom = rBlock.Top + 1
    Else
        If SourceTile(by, bx) > -1 Then
            rBlock.Left = bx * 16 + RoughTile(SourceTile(by, bx)).hLeft
            rBlock.Right = rBlock.Left + 16 - RoughTile(SourceTile(by, bx)).hLeft - RoughTile(SourceTile(by, bx)).hRight
            rBlock.Top = by * 16 + RoughTile(SourceTile(by, bx)).hTop
            rBlock.Bottom = rBlock.Top + 16 - RoughTile(SourceTile(by, bx)).hTop - RoughTile(SourceTile(by, bx)).hBottom
        Else
            rBlock.Left = bx * 16
            rBlock.Right = rBlock.Left + 16
            rBlock.Top = by * 16
            rBlock.Bottom = rBlock.Top + 16
        End If
    End If
    '1
    With rWho
        .Left = Players(Who).charX + 12
        .Right = .Left + 4
        .Top = Players(Who).charY + 1
        .Bottom = .Top + 3
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then
        ReDim Preserve RectsRet(UBound(RectsRet) + 1)
        RectsRet(UBound(RectsRet)) = 101
        ShipRects = True
    End If
    '2
    With rWho
        .Left = Players(Who).charX + 8
        .Right = .Left + 8
        .Top = Players(Who).charY + 4
        .Bottom = .Top + 4
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then
        ReDim Preserve RectsRet(UBound(RectsRet) + 1)
        RectsRet(UBound(RectsRet)) = 102
        ShipRects = True
    End If
    '3
    With rWho
        .Left = Players(Who).charX + 4
        .Right = .Left + 12
        .Top = Players(Who).charY + 8
        .Bottom = .Top + 4
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then
        ReDim Preserve RectsRet(UBound(RectsRet) + 1)
        RectsRet(UBound(RectsRet)) = 103
        ShipRects = True
    End If
    '
    '4
    With rWho
        .Left = Players(Who).charX + 1
        .Right = .Left + 15
        .Top = Players(Who).charY + 12
        .Bottom = .Top + 4
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then
        ReDim Preserve RectsRet(UBound(RectsRet) + 1)
        RectsRet(UBound(RectsRet)) = 104
        ShipRects = True
    End If
    '5
    With rWho
        .Left = Players(Who).charX + 1
        .Right = .Left + 15
        .Top = Players(Who).charY + 16
        .Bottom = .Top + 4
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then
        ReDim Preserve RectsRet(UBound(RectsRet) + 1)
        RectsRet(UBound(RectsRet)) = 105
        ShipRects = True
    End If
    '
    '6
    With rWho
        .Left = Players(Who).charX + 4
        .Right = .Left + 12
        .Top = Players(Who).charY + 20
        .Bottom = .Top + 4
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then
        ReDim Preserve RectsRet(UBound(RectsRet) + 1)
        RectsRet(UBound(RectsRet)) = 106
        ShipRects = True
    End If
    '7
    With rWho
        .Left = Players(Who).charX + 8
        .Right = .Left + 8
        .Top = Players(Who).charY + 24
        .Bottom = .Top + 4
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then
        ReDim Preserve RectsRet(UBound(RectsRet) + 1)
        RectsRet(UBound(RectsRet)) = 107
        ShipRects = True
    End If
    '8
    With rWho
        .Left = Players(Who).charX + 12
        .Right = .Left + 4
        .Top = Players(Who).charY + 28
        .Bottom = .Top + 3
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then
        ReDim Preserve RectsRet(UBound(RectsRet) + 1)
        RectsRet(UBound(RectsRet)) = 108
        ShipRects = True
    End If
    '
    '
    '
    '9
    With rWho
        .Left = Players(Who).charX + 16
        .Right = .Left + 4
        .Top = Players(Who).charY + 1
        .Bottom = .Top + 3
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then
        ReDim Preserve RectsRet(UBound(RectsRet) + 1)
        RectsRet(UBound(RectsRet)) = 109
        ShipRects = True
    End If
    '10
    With rWho
        .Left = Players(Who).charX + 16
        .Right = .Left + 8
        .Top = Players(Who).charY + 4
        .Bottom = .Top + 4
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then
        ReDim Preserve RectsRet(UBound(RectsRet) + 1)
        RectsRet(UBound(RectsRet)) = 110
        ShipRects = True
    End If
    '11
    With rWho
        .Left = Players(Who).charX + 16
        .Right = .Left + 12
        .Top = Players(Who).charY + 8
        .Bottom = .Top + 4
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then
        ReDim Preserve RectsRet(UBound(RectsRet) + 1)
        RectsRet(UBound(RectsRet)) = 111
        ShipRects = True
    End If
    '
    '12
    With rWho
        .Left = Players(Who).charX + 16
        .Right = .Left + 15
        .Top = Players(Who).charY + 12
        .Bottom = .Top + 4
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then
        ReDim Preserve RectsRet(UBound(RectsRet) + 1)
        RectsRet(UBound(RectsRet)) = 112
        ShipRects = True
    End If
    '13
    With rWho
        .Left = Players(Who).charX + 16
        .Right = .Left + 15
        .Top = Players(Who).charY + 16
        .Bottom = .Top + 4
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then
        ReDim Preserve RectsRet(UBound(RectsRet) + 1)
        RectsRet(UBound(RectsRet)) = 113
        ShipRects = True
    End If
    '
    '14
    With rWho
        .Left = Players(Who).charX + 16
        .Right = .Left + 12
        .Top = Players(Who).charY + 20
        .Bottom = .Top + 4
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then
        ReDim Preserve RectsRet(UBound(RectsRet) + 1)
        RectsRet(UBound(RectsRet)) = 114
        ShipRects = True
    End If
    '15
    With rWho
        .Left = Players(Who).charX + 16
        .Right = .Left + 8
        .Top = Players(Who).charY + 24
        .Bottom = .Top + 4
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then
        ReDim Preserve RectsRet(UBound(RectsRet) + 1)
        RectsRet(UBound(RectsRet)) = 115
        ShipRects = True
    End If
    '16
    With rWho
        .Left = Players(Who).charX + 16
        .Right = .Left + 4
        .Top = Players(Who).charY + 28
        .Bottom = .Top + 3
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then
        ReDim Preserve RectsRet(UBound(RectsRet) + 1)
        RectsRet(UBound(RectsRet)) = 116
        ShipRects = True
    End If
    '17
    With rWho
        .Left = Players(Who).charX + 15
        .Right = .Left + 2
        .Top = Players(Who).charY + 15
        .Bottom = .Top + 2
    End With
    If IntersectRect(rTemp, rWho, rBlock) Then
        ReDim Preserve RectsRet(UBound(RectsRet) + 1)
        RectsRet(UBound(RectsRet)) = 117
        ShipRects = True
    End If
End Function

Public Sub CreateHit(Who As Integer, WX As Integer, WY As Integer)
    Dim d As Long
    For d = 0 To UBound(IsHit)
        If Not IsHit(d) Then Exit For
    Next
    If d > UBound(IsHit) Then
        ReDim Preserve IsHit(d)
        ReDim Preserve WhoHit(d)
        ReDim Preserve HitX(d)
        ReDim Preserve HitY(d)
    End If
    IsHit(d) = True
    WhoHit(d) = Who
    HitX(d) = WX
    HitY(d) = WY
End Sub

Function PixelIntersect(Who As Integer, j As Integer, I As Integer) As Integer
    Dim ddsdBuffer As DDSURFACEDESC2
    Dim X As Integer, y As Integer, TPCol As Long, BPCol As Long, tc As Integer
    Dim bx As Integer, by As Integer, tx As Integer, ty As Integer
    Dim dx As Integer, dy As Integer, mvx As Integer, mvy As Integer
    Dim ssx As Integer, ssy As Integer, stx As Integer, sty As Integer
    Dim rrect As RECT, rBuff As RECT, rSprite As RECT
    rSprite.Left = (Players(Who).animX - 1) * 32
    rSprite.Top = 32 * (Players(Who).Ship - 1)
    rSprite.Right = 32 + rSprite.Left
    rSprite.Bottom = 32 + rSprite.Top
    
    tx = SourceTileX(j, I)
    ty = SourceTileY(j, I)
    bx = I * 16 - MeX
    by = j * 16 - MeY
    If bx < 0 Or by < 0 Then Exit Function
    
    mvx = Players(Who).charX - MeX
    mvy = Players(Who).charY - MeY
    
    
    If mvx >= bx Then 'right
        ssx = 0
        stx = mvx - bx
        dx = 15 - stx
        If Abs(mvx - bx) >= Abs(mvy - by) Then tc = 101
    End If
    If mvy >= by Then ' down
        ssy = 0
        sty = mvy - by
        dy = 15 - sty
        If Abs(mvx - bx) < Abs(mvy - by) Then tc = 102
    End If
    If mvx < bx Then ' left
        ssx = 32 - (mvx + 32 - bx)
        stx = 0
        dx = 32 - ssx - 1
        If Abs(mvx - bx) >= Abs(mvy - by) Then tc = 103
    End If
    If mvy < by Then ' up
        ssy = 32 - (mvy + 32 - by)
        sty = 0
        dy = 32 - ssy - 1
        If Abs(mvx - bx) < Abs(mvy - by) Then tc = 104
    End If
    
    If BackBuffer.isLost = 0 Then
        DirectDraw_Ships.Lock rrect, ddsdBuffer, DDLOCK_WAIT, 0
        DirectDraw_Tiles.Lock rrect, ddsdBuffer, DDLOCK_WAIT, 0
        For X = 0 To dx
            For y = 0 To dy
                TPCol = DirectDraw_Tiles.GetLockedPixel(tx + stx + X, ty + sty + y)
                BPCol = DirectDraw_Ships.GetLockedPixel(rSprite.Left + ssx + X, rSprite.Top + ssy + y)
                If TPCol <> KEYColor And BPCol <> KEYColor Then PixelIntersect = tc:  GoTo out
            Next
        Next
out:
        DirectDraw_Tiles.Unlock rrect
        DirectDraw_Ships.Unlock rrect
    End If
End Function

Public Function PixelIntersect2(lx As Integer, ly As Integer, j As Integer, I As Integer) As Integer
    On Error GoTo errors
    Dim ddsdBuffer As DDSURFACEDESC2, TPCol As Long, bx As Integer, by As Integer
    Dim tx As Integer, ty As Integer, mvx As Integer, mvy As Integer, rrect As RECT
    If BackBuffer.isLost Then Exit Function
    tx = SourceTileX(j, I)
    ty = SourceTileY(j, I)
    bx = I * 16
    by = j * 16
    If bx < 0 Or by < 0 Then Exit Function
    mvx = lx - bx
    mvy = ly - by
    If mvx > RoughTile(SourceTile(j, I)).hLeft - 1 And mvy > RoughTile(SourceTile(j, I)).hTop - 1 And mvx < 16 - RoughTile(SourceTile(j, I)).hRight And mvy < 16 - RoughTile(SourceTile(j, I)).hBottom Then
        If BackBuffer.isLost = 0 Then
1:          DirectDraw_Tiles.Lock rrect, ddsdBuffer, DDLOCK_WAIT, 0
            TPCol = DirectDraw_Tiles.GetLockedPixel(tx + mvx, ty + mvy)
            If TPCol <> KEYColor Then PixelIntersect2 = 1:   GoTo out
out:
            DirectDraw_Tiles.Unlock rrect
        End If
    End If
    Exit Function
errors:
    If Erl = 1 Then
        If StartLog Then StartupLog "WARNING: " & errors(Err.Number)
        DirectDraw.RestoreAllSurfaces
        Resume Next
    End If
End Function

Public Function PixelIntersect3(lx As Integer, ly As Integer, j As Integer, I As Integer) As Integer
    Dim ddsdBuffer As DDSURFACEDESC2
    Dim tx As Integer, ty As Integer, mvx As Integer, mvy As Integer, rrect As RECT
    Dim X As Integer, y As Integer, TPCol As Long, bx As Integer, by As Integer
    tx = SourceTileX(j, I)
    ty = SourceTileY(j, I)
    bx = I * 16
    by = j * 16
    mvx = lx - bx
    mvy = ly - by
    If BackBuffer.isLost = 0 Then
        DirectDraw_Tiles.Lock rrect, ddsdBuffer, DDLOCK_WAIT, 0
        For X = 0 To 2
            For y = 0 To 2
                If mvx + X > 15 Then GoTo skip
                If mvy + y > 15 Then GoTo skip
                If mvx + X < 0 Then GoTo skip
                If mvy + y < 0 Then GoTo skip
                TPCol = DirectDraw_Tiles.GetLockedPixel(tx + mvx + X, ty + mvy + y)
                If TPCol <> KEYColor Then PixelIntersect3 = 1:  GoTo out
skip:
            Next
        Next
out:
        DirectDraw_Tiles.Unlock rrect
    End If
End Function

Public Sub ReBoun(Who As Integer, cx As Integer, cy As Integer, Ang As Single, Re As Integer)
    Dim j As Integer
    For j = 0 To UBound(Bounce) + 1
        If j > UBound(Bounce) Then
            ReDim Preserve Bounce(j), BounceWho(j), BounceAngle(j), BounceDist(j), BounceTrav(j), BounceX(j), BounceY(j), BounceTeam(j), BounceStopMve(j)
        End If
        If Not Bounce(j) Then
            BounceWho(j) = Who
            BounceTeam(j) = Players(Who).Ship
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

Public Sub MakeText2(txt As String, tx As Integer, ty As Integer)
    Dim I As Integer, a As Integer, p As Integer
    Dim C As Byte
    Dim t As String
    Dim ap As Byte
    For I = 1 To Len(txt)
        t = Mid$(txt, I, 1)
        If LenB(t) > 0 Then a = Asc(t)
        If a = 1 Then C = 0: GoTo skip2
        If a = 2 Then C = 1: GoTo skip2
        If a = 3 Then C = 2: GoTo skip2
        If a = 4 Then C = 3: GoTo skip2
        If a = 5 Then C = 4: GoTo skip2
        If a = 6 Then C = 5: GoTo skip2
        If a = 7 Then C = 7: GoTo skip2
        If a = 8 Then C = 8: GoTo skip2
        If a = 9 Then C = 9: GoTo skip2
        If a = 10 Then C = 10: GoTo skip2
        If a > 64 And a < 91 Then ap = (a - 65) * 2 + 1: GoTo skip
        If a > 96 And a < 123 Then ap = (a - 97) * 2 + 2: GoTo skip
        If a = 32 Then ap = 0: GoTo skip
        If t = "!" Then ap = 53: GoTo skip
        If t = "?" Then ap = 54: GoTo skip
        If a > 48 And a < 58 Then ap = a - 49 + 55: GoTo skip
        If t = "0" Then ap = 64: GoTo skip
        If t = "." Then ap = 65: GoTo skip
        If t = "," Then ap = 66: GoTo skip
        If t = "-" Then ap = 67: GoTo skip
        If t = "+" Then ap = 68: GoTo skip
        If t = "(" Then ap = 69: GoTo skip
        If t = ")" Then ap = 70: GoTo skip
        If t = "`" Then ap = 71: GoTo skip
        If t = "~" Then ap = 72: GoTo skip
        If t = "@" Then ap = 73: GoTo skip
        If t = "$" Then ap = 74: GoTo skip
        If t = "#" Then ap = 75: GoTo skip
        If t = "%" Then ap = 76: GoTo skip
        If t = "*" Then ap = 77: GoTo skip
        If t = "[" Then ap = 78: GoTo skip
        If t = "]" Then ap = 79: GoTo skip
        If t = "{" Then ap = 80: GoTo skip
        If t = "}" Then ap = 81: GoTo skip
        If t = "|" Then ap = 82: GoTo skip
        If t = "/" Then ap = 83: GoTo skip
        If t = "\" Then ap = 84: GoTo skip
        If t = ":" Then ap = 85: GoTo skip
        If t = ";" Then ap = 86: GoTo skip
        If a = 34 Then ap = 87: GoTo skip
        If t = "=" Then ap = 88: GoTo skip
        If t = "<" Then ap = 89: GoTo skip
        If t = ">" Then ap = 90: GoTo skip
        If t = "&" Then ap = 91: GoTo skip
        If t = "^" Then ap = 92: GoTo skip
        If t = "'" Then ap = 93: GoTo skip
        If t = "_" Then ap = 94: GoTo skip
        ap = 32
skip:
        rChars2(ap).Top = C * 6 + 1
        rChars2(ap).Bottom = rChars2(ap).Top + 5
        BackBuffer.BltFast tx + p, ty, DirectDraw_Text2, rChars2(ap), DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
        p = p + rChars2(ap).Right - rChars2(ap).Left
skip2:
        ap = 0
    Next
End Sub

Public Function ShipTouch(Who As Integer) As Integer
    Dim rTemp As RECT, rWho As RECT, rBlock As RECT
    Dim I As Integer, j As Integer, b As Integer, d As Integer, G As Integer
    Dim i2 As Integer, j2 As Integer, RetArray As Integer, e As Integer
    ReDim RectsRet(0), RetCollision(0)
    If Players(Who).DevCheat = 2 Or Players(Who).DevCheat = 4 Then Exit Function
    If Players(Who).Mode = 1 Then Exit Function
    With rWho
        .Top = Players(Who).charY + 1
        .Left = Players(Who).charX + 1
        .Bottom = rWho.Top + 30
        .Right = rWho.Left + 30
    End With
    j2 = (Players(Who).charY And -16) \ 16
    i2 = (Players(Who).charX And -16) \ 16
    b = j2 + 2
    d = i2 + 2
    For j = j2 To b
        For I = i2 To d
            If j < 0 Or I < 0 Then GoTo skip
            If j > 255 Or I > 255 Then GoTo skip
            G = Collision(j, I)
            If G Then
                With rBlock
                    .Top = j * 16
                    .Left = I * 16
                    .Bottom = rBlock.Top + 16
                    .Right = rBlock.Left + 16
                End With
                If IntersectRect(rTemp, rWho, rBlock) Then
                    RetArray = UBound(RectsRet)
                    If ShipRects(Who, j, I, False) Then
                        For e = 0 To UBound(RetCollision)
                            If RetCollision(e) = G Then Exit For
                        Next
                        If FindRectsRet(117) Then
                            If e > UBound(RetCollision) Then ReDim Preserve RetCollision(UBound(RetCollision) + 1): RetCollision(UBound(RetCollision)) = G
                        End If
                    End If
                    If G <> 1 And G <> 2 And Not (G > 3 And G < 8) Then ReDim Preserve RectsRet(RetArray)
                End If
                'ShipTouch = PixelIntersect(Who, j, i)
            End If
skip:
        Next
    Next
End Function

Public Function FindRectsRet(searchret As Integer) As Boolean
    Dim I As Integer
    For I = 1 To UBound(RectsRet)
        If RectsRet(I) = searchret Then FindRectsRet = True: Exit Function
    Next
End Function

Public Sub ShowPlayers()
    Dim rBuff As RECT
    Dim I As Integer, j As Integer, X As Integer
    Static ButnDwn As Integer, ButnDwnT As Long
    rBuff.Top = 56
    rBuff.Bottom = rBuff.Top + 95
    rBuff.Left = 352
    rBuff.Right = rBuff.Left + 100
    BackBuffer.BltFast ResX - 135, 18, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
    rBuff.Top = 175
    rBuff.Bottom = rBuff.Top + 9
    rBuff.Left = 352
    rBuff.Right = rBuff.Left + 93
    BackBuffer.BltFast ResX - 135, 28 + (PlayerSelected - 1) * 7, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
    rBuff.Top = 168
    rBuff.Bottom = rBuff.Top + 7
    rBuff.Left = 352
    rBuff.Right = rBuff.Left + 93
    BackBuffer.BltFast ResX - 135, 29 + (PlayerSelected - 1) * 7, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
    If Players(MeNum).Admin > 0 Then
        '
        rBuff.Top = 156
        rBuff.Bottom = rBuff.Top + 10
        rBuff.Left = 452
        rBuff.Right = rBuff.Left + 100
        BackBuffer.BltFast ResX - 135, 100, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
        If ButnDwn <> PlayerOpt And PlayerOpt > 0 Then ButnDwn = PlayerOpt: ButnDwnT = NewGTC
        If ButnDwn > 0 Then
            rBuff.Top = 168
            rBuff.Bottom = rBuff.Top + 10
            rBuff.Left = 452 + (ButnDwn - 3) * 25
            rBuff.Right = rBuff.Left + 25
        End If
        If NewGTC - ButnDwnT < 150 And ButnDwn > 0 Then
            BackBuffer.BltFast ResX - 136 + (ButnDwn - 3) * 25, 98, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
        Else
            ButnDwn = 0
        End If
        '
    Else
        '
        If ButnDwn <> PlayerOpt And PlayerOpt > 0 Then ButnDwn = PlayerOpt: ButnDwnT = NewGTC
        If NewGTC - ButnDwnT < 150 And ButnDwn > 0 Then
            rBuff.Top = 150
            rBuff.Bottom = rBuff.Top + 11
            rBuff.Left = 353 + (ButnDwn - 1) * 50
            rBuff.Right = rBuff.Left + 45
            BackBuffer.BltFast ResX - 135 + (ButnDwn - 1) * 50, 99, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
        Else
            ButnDwn = 0
        End If
        '
    End If
    j = 0
    For I = 1 + PlayerScroll To UBound(Players)
        If I > UBound(Players) Then Exit For
        If LenB(Players(I).Nick) > 0 Then
            If IsIgnored(Players(I).Nick) Then X = 4
            MakeText2 Chr$(2 + X + Players(I).Ship) & Players(I).Nick, ResX - 133, 29 + (((I - 1) - PlayerScroll) * 7)
            MakeText2 Chr$(2 + Players(I).Ship) & Players(I).Score, ResX - 55, 29 + (((I - 1) - PlayerScroll) * 7)
            '
            If I = PlayerSelected + PlayerScroll Then
                Select Case PlayerOpt
                Case 1
                    If IsIgnored(Players(I).Nick) Then
                        RemoveIgnore Players(I).Nick
                    Else
                        AddIgnore Players(I).Nick
                    End If
                Case 2
                Case 3
                    If IsIgnored(Players(I).Nick) Then
                        RemoveIgnore Players(I).Nick
                    Else
                        AddIgnore Players(I).Nick
                    End If
                Case 4
                Case 5
                    Call sendmsg(MSG_GAMECHAT, "/kick " & Players(I).Nick)
                Case 6
                    Call sendmsg(MSG_GAMECHAT, "/mute " & Players(I).Nick)
                End Select
                PlayerOpt = 0
            End If
            '
            j = j + 1
            If j > 9 Then Exit For
            If j > 19 Then Exit For
        End If
    Next
    Ignoring = False
    With rBuff
        .Top = 162
        .Bottom = .Top + 6
        .Left = 352
        .Right = .Left + 5
    End With
    If UBound(Players) + 20 > 10 Then I = (49 / (UBound(Players) + 20 - 10)) * PlayerScroll Else I = 0
    BackBuffer.BltFast ResX - 41, 37 + I, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
End Sub

Public Sub CreatePowerup(PwrUp As Byte, PwrIndx As Integer, px As Integer, py As Integer)
    Dim I As Integer
    For I = 0 To UBound(PowerUp) + 1
        If I > UBound(PowerUp) Then ReDim Preserve PowerUp(I), PowerX(I), PowerY(I), PowerIndex(I), PowerEffect(I), PowerTick(I), PowerFrame(I), PowerFrameT(I)
        If PowerUp(I) = 0 Then
            PowerUp(I) = PwrUp
            PowerIndex(I) = PwrIndx
            PowerX(I) = px
            PowerY(I) = py
            PowerEffect(I) = 1
            PowerFrame(I) = 0
            PowerFrameT(I) = NewGTC
            Exit Sub
        End If
    Next
End Sub

Public Sub TruncateMap()
    Dim I As Integer, j As Integer, x1 As Integer, x2 As Integer, Y1 As Integer, Y2 As Integer, NDX As Integer, NDY As Integer
    Dim NSX() As Integer, NSY() As Integer, NC() As Integer, NA() As Integer, NAO() As Byte
    Dim t As Integer
    t = 1
    For I = t To UBound(Collision, 2)
        For j = t To UBound(Collision, 1) - t
            If SourceTileY(j, I) <> 112 Or SourceTileX(j, I) <> -1 Then x1 = I: Exit For
        Next
        If SourceTileY(j, I) <> 112 Or SourceTileX(j, I) <> -1 Then Exit For
    Next
    
    For I = UBound(Collision, 2) - t To t Step -1
        For j = UBound(Collision, 1) - t To t Step -1
            If SourceTileY(j, I) <> 112 Or SourceTileX(j, I) <> -1 Then x2 = I: Exit For
        Next
        If SourceTileY(j, I) <> 112 Or SourceTileX(j, I) <> -1 Then Exit For
    Next
    
    For I = t To UBound(Collision, 1) - t
        For j = t To UBound(Collision, 2) - t
            If SourceTileY(j, I) <> 112 Or SourceTileX(j, I) <> -1 Then Y1 = I: Exit For
        Next
        If SourceTileY(j, I) <> 112 Or SourceTileX(j, I) <> -1 Then: Exit For
    Next
    
    For I = UBound(Collision, 1) - t To t Step -1
        For j = UBound(Collision, 2) - t To t Step -1
            If SourceTileY(j, I) <> 112 Or SourceTileX(j, I) <> -1 Then Y2 = I: Exit For
        Next
        If SourceTileY(j, I) <> 112 Or SourceTileX(j, I) <> -1 Then Exit For
    Next
    
    NDX = x2 - x1 + 1
    NDY = Y2 - Y1 + 1
    ReDim NSX(NDY, NDX), NSY(NDY, NDX), NC(NDY, NDX), NA(NDY, NDX), NAO(NDY, NDX)
    For I = Y1 To Y2
        For j = x1 To x2
            NDY = I - Y1
            NDX = j - x1
            NSX(NDY, NDX) = SourceTileX(I, j)
            NSY(NDY, NDX) = SourceTileY(I, j)
            NC(NDY, NDX) = Collision(I, j)
            NA(NDY, NDX) = Animations(I, j)
            NAO(NDY, NDX) = AnimOffset(I, j)
        Next
    Next
    NDX = x2 - x1 + 1
    NDY = Y2 - Y1 + 1
    HData.Height = NDY * 16 - 16
    HData.Width = NDX * 16 - 16
    For I = 0 To NDY - 1
        For j = 0 To NDX - 1
            SourceTileX(I, j) = NSX(I, j)
            SourceTileY(I, j) = NSY(I, j)
            Collision(I, j) = NC(I, j)
            Animations(I, j) = NA(I, j)
            AnimOffset(I, j) = NAO(I, j)
        Next
    Next
End Sub
