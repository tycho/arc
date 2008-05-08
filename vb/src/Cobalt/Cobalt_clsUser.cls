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
Private mvarNick As String
Private mvarGame As Long
Private mvaricon2 As Byte
Private mvaricon As Byte
Private mvarclsGameData As clsGameData
Private mvarAdmin As Byte
Private mvarMode As Byte

Public Property Let Mode(ByVal vData As Byte)
    mvarMode = vData
End Property

Public Property Get Mode() As Byte
    Mode = mvarMode
End Property

Public Property Let Admin(ByVal vData As Byte)
    mvarAdmin = vData
End Property


Public Property Get Admin() As Byte
    Admin = mvarAdmin
End Property

Public Property Get clsGameData() As clsGameData
    If mvarclsGameData Is Nothing Then
        Set mvarclsGameData = New clsGameData
    End If
    Set clsGameData = mvarclsGameData
End Property

Public Property Set clsGameData(vData As clsGameData)
    Set mvarclsGameData = vData
End Property

Private Sub Class_Terminate()
    Set mvarclsGameData = Nothing
End Sub

Public Property Let icon(ByVal vData As Byte)
    mvaricon = vData
End Property

Public Property Get icon() As Byte
    icon = mvaricon
End Property

Public Property Let icon2(ByVal vData As Byte)
    mvaricon2 = vData
End Property

Public Property Get icon2() As Byte
    icon2 = mvaricon2
End Property

Public Property Let Game(ByVal vData As Long)
    mvarGame = vData
End Property

Public Property Get Game() As Long
    Game = mvarGame
End Property

Public Property Let Nick(ByVal vData As String)
    mvarNick = vData
End Property

Public Property Get Nick() As String
    Nick = mvarNick
End Property
