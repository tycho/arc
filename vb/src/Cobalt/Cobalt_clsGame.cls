VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsGameData"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
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
Private mvarsName As String
Private mvarsDesc As String
Private mvarID As Long
Private mvarGame As Long
Private mvarlatency As Long
Private mvarCreator As String
Private mvarsGuideInstance As String
Private mvarIP As String
Private mvarPort As Long
Private mvarTestTick As Long
Private mvarPassProtected As Boolean
Private mvarMaxPlayers As Byte
Private mvarGameType As Byte
Private mvarTimeLimit As Integer
Private mvarPort2 As Long
Private mvarReachable As Boolean
Private mvarMrB As Integer
Private mvarpingStart As Long
Private mvarFrags As Integer
Private mvarDeath As Integer
Private mvarDurration As Long

Public Property Let Durration(ByVal vData As Long)
    mvarDurration = vData
End Property

Public Property Get Durration() As Long
    Durration = mvarDurration
End Property

Public Property Let Death(ByVal vData As Integer)
    mvarDeath = vData
End Property

Public Property Get Death() As Integer
    Death = mvarDeath
End Property

Public Property Let Frags(ByVal vData As Integer)
    mvarFrags = vData
End Property

Public Property Get Frags() As Integer
    Frags = mvarFrags
End Property

Public Property Let pingStart(ByVal vData As Long)
    mvarpingStart = vData
End Property

Public Property Get pingStart() As Long
    pingStart = mvarpingStart
End Property

Public Property Let MrB(ByVal vData As Integer)
    mvarMrB = vData
End Property

Public Property Get MrB() As Integer
    MrB = mvarMrB
End Property

Public Property Let Reachable(ByVal vData As Boolean)
    mvarReachable = vData
End Property

Public Property Get Reachable() As Boolean
    Reachable = mvarReachable
End Property

Public Property Let Port2(ByVal vData As Long)
    mvarPort2 = vData
End Property

Public Property Get Port2() As Long
    Port2 = mvarPort2
End Property

Public Property Let TimeLimit(ByVal vData As Integer)
    mvarTimeLimit = vData
End Property

Public Property Get TimeLimit() As Integer
    TimeLimit = mvarTimeLimit
End Property

Public Property Let GameType(ByVal vData As Byte)
    mvarGameType = vData
End Property

Public Property Get GameType() As Byte
    GameType = mvarGameType
End Property

Public Property Let MaxPlayers(ByVal vData As Byte)
    mvarMaxPlayers = vData
End Property

Public Property Get MaxPlayers() As Byte
    MaxPlayers = mvarMaxPlayers
End Property

Public Property Let PassProtected(ByVal vData As Boolean)
    mvarPassProtected = vData
End Property

Public Property Get PassProtected() As Boolean
    PassProtected = mvarPassProtected
End Property

Public Property Let TestTick(ByVal vData As Long)
    mvarTestTick = vData
End Property

Public Property Get TestTick() As Long
    TestTick = mvarTestTick
End Property

Public Property Let port(ByVal vData As Long)
    mvarPort = vData
End Property

Public Property Get port() As Long
    port = mvarPort
End Property

Public Property Let ip(ByVal vData As String)
    mvarIP = vData
End Property

Public Property Get ip() As String
    ip = mvarIP
End Property

Public Property Let sGuideInstance(ByVal vData As String)
    mvarsGuideInstance = vData
End Property

Public Property Get sGuideInstance() As String
    sGuideInstance = mvarsGuideInstance
End Property

Public Property Let Creator(ByVal vData As String)
    mvarCreator = vData
End Property

Public Property Get Creator() As String
    Creator = mvarCreator
End Property

Public Property Let latency(ByVal vData As Long)
    mvarlatency = vData
End Property


Public Property Get latency() As Long
    latency = mvarlatency
End Property

Public Property Let Game(ByVal vData As Long)
    mvarGame = vData
End Property

Public Property Get Game() As Long
    Game = mvarGame
End Property

Public Property Let ID(ByVal vData As Long)
    mvarID = vData
End Property

Public Property Get ID() As Long
    ID = mvarID
End Property

Public Property Let sDesc(ByVal vData As String)
    mvarsDesc = vData
End Property

Public Property Get sDesc() As String
    sDesc = mvarsDesc
End Property

Public Property Let sName(ByVal vData As String)
    mvarsName = vData
End Property

Public Property Get sName() As String
    sName = mvarsName
End Property
