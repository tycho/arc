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
'local variable(s) to hold property value(s)
Private mvarsName As String
Private mvarsDesc As String
Private mvarIPHost As String
'local variable(s) to hold property value(s)
Private mvarID As Long
'local variable(s) to hold property value(s)
Private mvarCreator As String
'local variable(s) to hold property value(s)
Private mvarguidInst As String
'local variable(s) to hold property value(s)
Private mvarPassProtected As Boolean
'local variable(s) to hold property value(s)
Private mvarMaxPlayers As Byte
'local variable(s) to hold property value(s)
Private mvarHameType As Byte
Private mvarTimeLimit As Integer
'local variable(s) to hold property value(s)
Private mvarPort As Long
Private mvarPort2 As Long
'local variable(s) to hold property value(s)
Private mvarPassword As String
Public Property Let Password(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.Password = 5
    mvarPassword = vData
End Property


Public Property Get Password() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Password
    Password = mvarPassword
End Property



Public Property Let Port2(ByVal vData As Long)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.Port2 = 5
    mvarPort2 = vData
End Property


Public Property Get Port2() As Long
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Port2
    Port2 = mvarPort2
End Property



Public Property Let Port(ByVal vData As Long)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.Port = 5
    mvarPort = vData
End Property


Public Property Get Port() As Long
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Port
    Port = mvarPort
End Property



Public Property Let TimeLimit(ByVal vData As Integer)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.TimeLimit = 5
    mvarTimeLimit = vData
End Property


Public Property Get TimeLimit() As Integer
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.TimeLimit
    TimeLimit = mvarTimeLimit
End Property



Public Property Let GameType(ByVal vData As Byte)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.HameType = 5
    mvarHameType = vData
End Property


Public Property Get GameType() As Byte
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.HameType
    GameType = mvarHameType
End Property



Public Property Let MaxPlayers(ByVal vData As Byte)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.MaxPlayers = 5
    mvarMaxPlayers = vData
End Property


Public Property Get MaxPlayers() As Byte
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.MaxPlayers
    MaxPlayers = mvarMaxPlayers
End Property



Public Property Let PassProtected(ByVal vData As Boolean)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.PassProtected = 5
    mvarPassProtected = vData
End Property


Public Property Get PassProtected() As Boolean
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.PassProtected
    PassProtected = mvarPassProtected
End Property



Public Property Let guidInst(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.guidInst = 5
    mvarguidInst = vData
End Property


Public Property Get guidInst() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.guidInst
    guidInst = mvarguidInst
End Property



Public Property Let Creator(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.Creator = 5
    mvarCreator = vData
End Property


Public Property Get Creator() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Creator
    Creator = mvarCreator
End Property



Public Property Let id(ByVal vData As Long)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.ID = 5
    mvarID = vData
End Property


Public Property Get id() As Long
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.ID
    id = mvarID
End Property


Public Property Let IPHost(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.IPHost = 5
    mvarIPHost = vData
End Property


Public Property Get IPHost() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.IPHost
    IPHost = mvarIPHost
End Property



Public Property Let sDesc(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.sDesc = 5
    mvarsDesc = vData
End Property


Public Property Get sDesc() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.sDesc
    sDesc = mvarsDesc
End Property



Public Property Let sName(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.sName = 5
    mvarsName = vData
End Property


Public Property Get sName() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.sName
    sName = mvarsName
End Property



