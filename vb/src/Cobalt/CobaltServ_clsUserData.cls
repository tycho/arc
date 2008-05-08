VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsUserData"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
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
Private mvarID As Long
Private mvarNick As String
Private mvaricon As Byte
Private mvaricon2 As Byte
Private mvargame As Long
Private mvaradmin As Byte
Private mvargagged As Boolean
Private mvargameID As Long
Private mvarMode As Byte
Private mvarUptime As Long
Private mvarHDSerial As Long
Private mvarSysID As String
Private mvarIP As String
Private mvarchatid As Byte
Private mvarRoom As Integer
Private mvarFlooding As Long
Private mvarOffenses As Long
Attribute mvarOffenses.VB_VarHelpID = -1
Private BeenWarned As Long
Private LastFloodCheck As Long
Private mvarEncryption As Integer

Public Property Let Room(ByVal vData As Integer)
    'used when assigning a value to the property, on the left side of an assignment.
    'Syntax: X.Room = 5
    mvarRoom = vData
End Property

Public Property Get Room() As Integer
    Room = mvarRoom
End Property

Public Property Let Encryption(ByVal vData As String)
    mvarEncryption = vData
End Property

Public Property Get Encryption() As String
    Encryption = mvarEncryption
End Property

Public Property Let chatid(ByVal vData As Byte)
    mvarchatid = vData
End Property

Public Property Get chatid() As Byte
    chatid = mvarchatid
End Property

Public Property Let IP(ByVal vData As String)
    mvarIP = vData
End Property

Public Property Get IP() As String
    IP = mvarIP
End Property

Public Property Let HDSerial(ByVal vData As Long)
    mvarHDSerial = vData
End Property

Public Property Get HDSerial() As Long
    HDSerial = mvarHDSerial
End Property

Public Property Let SysID(ByVal vData As String)
    mvarSysID = vData
End Property

Public Property Get SysID() As String
    SysID = mvarSysID
End Property

Public Property Let Uptime(ByVal vData As Long)
    mvarUptime = vData
End Property

Public Property Get Uptime() As Long
    Uptime = mvarUptime
End Property

Public Property Let Mode(ByVal vData As Byte)
    mvarMode = vData
End Property

Public Property Get Mode() As Byte
    Mode = mvarMode
End Property

Public Property Let gameID(ByVal vData As Long)
    mvargameID = vData
End Property

Public Property Get gameID() As Long
    gameID = mvargameID
End Property

Public Property Let gagged(ByVal vData As Boolean)
    mvargagged = vData
End Property

Public Property Get gagged() As Boolean
    gagged = mvargagged
End Property

Public Property Let flooding(Messages As Long)
    mvarFlooding = Messages
End Property

Public Property Get flooding() As Long
    flooding = mvarFlooding
End Property

Public Property Let Admin(ByVal vData As Byte)
    mvaradmin = vData
End Property

Public Property Get Admin() As Byte
    Admin = mvaradmin
End Property

Public Property Let game(ByVal vData As Long)
    mvargame = vData
End Property

Public Property Get game() As Long
    game = mvargame
End Property

Public Property Let icon2(ByVal vData As Byte)
    mvaricon2 = vData
End Property

Public Property Get icon2() As Byte
    icon2 = mvaricon2
End Property

Public Property Let Icon(ByVal vData As Byte)
    mvaricon = vData
End Property

Public Property Get Icon() As Byte
    Icon = mvaricon
End Property

Public Property Let Nick(ByVal vData As String)
    mvarNick = vData
End Property

Public Property Get Nick() As String
    Nick = mvarNick
End Property

Public Property Let id(ByVal vData As Long)
    mvarID = vData
End Property

Public Property Get id() As Long
    id = mvarID
End Property

Public Sub FloodCheck()
    Dim L As Long
    L = NewGTC - LastFloodCheck
    Dim c As Long
    c = L / 1000
    If mvarFlooding > 0 Then
        mvarFlooding = mvarFlooding - (c * 3)
        If mvarFlooding < 0 Then
            mvarFlooding = 0
        End If
    End If
    If mvarFlooding >= 7 And BeenWarned >= 2 Then
        If mvarOffenses < 1 Then
            GagMe
            Else
            BanMyHD
        End If
    ElseIf mvarFlooding >= 7 And BeenWarned < 2 Then
        BeenWarned = BeenWarned + 1
        mvarFlooding = 3
        SendChat "Do not flood. You have " & 2 - BeenWarned & " warning(s) left. If you do not comply, you will be gagged. Repeated offenses receive 10 minute bans.", 0, GetPN2(mvarNick)
    End If
    LastFloodCheck = NewGTC
End Sub

Private Sub Class_Initialize()
    LastFloodCheck = NewGTC
    BeenWarned = 0
    mvarEncryption = 0
End Sub

Private Sub GagMe()
    Dim d2 As Date
    Dim newCmd As Long, lNewMsg As Byte, oNewMsg() As Byte, lNewOffset As Long, B As Byte, L As Long, j As Integer
    Dim Who
    Dim bParm As String
    Dim I As Integer
    Who = -1
    bParm = mvarIP
    I = GetPN2(mvarNick)
    If I = 0 Then Exit Sub
    If 4 > Me.Admin Then
        newCmd = 1
        d2 = DateAdd("n", Minute(Time), Date)
        d2 = DateAdd("h", Hour(Time), d2)
        d2 = DateAdd("s", Second(Time), d2)
        d2 = DateAdd("n", Val(newCmd), d2)
        Gag UserDat(I).Nick, d2, UserDat(0).Nick
        UserDat(I).gagged = True
        lNewMsg = MSG_ICON
        lNewOffset = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
        AddBufferData oNewMsg, VarPtr(I), LenB(I), lNewOffset
        B = 18
        UserDat(I).Icon = B
        AddBufferData oNewMsg, VarPtr(B), LenB(B), lNewOffset
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
            SendTo oNewMsg, UserDat(I).game
        End If
        SendChat mvarNick & " is gagged for 1 minute (excess flood)", 0, -1
        BeenWarned = 0
        mvarOffenses = mvarOffenses + 1
    End If
End Sub

Private Sub BanMyHD()
    Dim d2 As Date
    Dim newCmd As Long, lNewMsg As Byte, oNewMsg() As Byte, lNewOffset As Long, B As Byte, L As Long, j As Integer
    Dim Who
    Dim bParm As String
    Dim I As Long
    Who = -1
    bParm = mvarIP
    I = GetPN2(mvarNick)
    If I = 0 Then Exit Sub
    If Me.Admin < 4 Then
        newCmd = 10
        d2 = DateAdd("n", Minute(Time), Date)
        d2 = DateAdd("h", Hour(Time), d2)
        d2 = DateAdd("s", Second(Time), d2)
        d2 = DateAdd("n", Val(newCmd), d2)
        Ban3 mvarNick, mvarHDSerial, d2, 0
        SendChat mvarNick & " is banned for 10 minutes (repeated excess flood)", 0, -1
        Kick CInt(I), 0, 1
    End If
End Sub
