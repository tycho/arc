Attribute VB_Name = "modGlobals"
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

Public Const WM_LBUTTONDOWN = &H201
Public Const WM_LBUTTONUP = &H202
Public Const WM_VSCROLL = &H115
Public Const SB_LINEUP = 0
Public Const SB_LINEDOWN = 1
Public Const SB_PAGEUP = 2
Public Const SB_PAGEDOWN = 3
Public Const SB_THUMBPOSITION = 4
Public Const SB_THUMBTRACK = 5
Public Const SB_TOP = 6
Public Const SB_BOTTOM = 7
Public Const SB_ENDSCROLL = 8
Public Type svrp
    Ship As Byte
    ScreenName As String
    ServerID As Long
    playerID As Long
    Ping As Integer
    Frags As Integer
    Deaths As Integer
    Caps As Integer
    Time As Long
End Type
Public Type hPager
    PName() As String
    Pages() As String
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
Public PagerMSG() As hPager
Public UserName As String
Public Password As String
Public LoginKey As Byte
Public port As Integer
Public HostAddy As String, SetIcon As Byte, SoundDIR As String
Public Sleeping As Boolean, ScreenNameBox As Integer, RoomNumber As Integer
Public NewUser As Boolean, SrvBwidth As Integer, Bwidth As Integer
Public Authenticated As Boolean, RHost As String, RURL As String
Public SkinEnabled As Boolean, CTime As Long, Port2 As Long, Bandwidth(3) As Integer
Public SigningUp As Boolean, MeNum As Integer, NoBadWords As Integer, ChatColor As String
Public UniqueID As String, Muzzle() As String, ColorCodes As Boolean, NoColor As Boolean
Public EnableEncryption As Boolean, NoEnterLeave As Boolean, EnterMSG As String, ExitMSG As String
Public ErrorMSG As String, TimeStamp As Boolean, ZZZTick As Long, Email As String, FlashWindows As Boolean
Public COBALTID As Long, Admin As Integer, Serial_Number As Long, LoginNames() As String, LoginPasswords() As String
Public Down As Boolean, LstX As Integer, LstY As Integer, uptime As Long, Rooms() As clsChatRoom
Public ServerDat() As clsGameData, UserDat() As clsUserData, svrPlayers() As svrp
Public PagerFrames(2, 2) As String, PagerAnim As Integer, PagerStat(1) As Boolean, PageBeep As Long
Public NoUpdate As Boolean, NoPager As Boolean, ShowUptime As Boolean, SysTray As Boolean, _
    skins As Long, KeepAlive As Boolean

Public Function RaiseError(Caption As String)
    On Error Resume Next
    frmError.lblErrorMessage = Caption
    frmError.Show 1
    Do While frmError.Visible = True
        DoEvents
    Loop
    RaiseError = 0
End Function

Public Function RaiseInfo(Caption As String)
    On Error Resume Next
    frmInfo.lblErrorMessage = Caption
    frmInfo.Show 1
    Do While frmInfo.Visible = True
        DoEvents
    Loop
    RaiseInfo = 0
End Function

Public Function RaiseCritical(Caption As String)
    On Error Resume Next
    frmCriticalError.lblErrorMessage = Caption
    frmCriticalError.Show 1
    Do While frmCriticalError.Visible = True
        DoEvents
    Loop
    RaiseCritical = 0
End Function
