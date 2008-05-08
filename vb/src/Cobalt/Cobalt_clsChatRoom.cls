VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsChatRoom"
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

Private mvarRoomIndex As Integer
Private mvarRoomName As String

Private Sub Class_Initialize()
    ReDim Admins(0)
    ReDim Bans(0)
    ReDim Gags(0)
End Sub

'---------------------------------------------------------------------------------------------------------------------
'Publicly accessible functions and subroutines. NOT to be
'changed unless you want to change the entire program!

Public Property Let RoomName(ByVal vData As String)
    mvarRoomName = vData
End Property

Public Property Get RoomName() As String
    RoomName = mvarRoomName
End Property

Public Property Let RoomIndex(ByVal vData As Integer)
    mvarRoomIndex = vData
End Property

Public Property Get RoomIndex() As Integer
    RoomIndex = mvarRoomIndex
End Property

