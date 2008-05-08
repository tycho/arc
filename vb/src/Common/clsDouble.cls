VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsDouble"
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

Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (hpvDest As Any, hpvSource As Any, ByVal cbCopy As Long)
Private Declare Function VirtualAlloc Lib "kernel32" (ByVal lpAddress As Long, ByVal dwSize As Long, ByVal flAllocationType As Long, ByVal flProtect As Long) As Long
Private Declare Function VirtualFree Lib "kernel32" (ByVal lpAddress As Long, ByVal dwSize As Long, ByVal dwFreeType As Long) As Long
Private Declare Function VirtualProtect Lib "kernel32" (ByVal lpAddress As Long, ByVal dwSize As Long, ByVal flNewProtect As Long, lpflOldProtect As Long) As Long
Private mvarValue As Double
Private mvarAddress As Long
Private Const MEM_COMMIT = 4096
Private Const MEM_DECOMMIT = 16384
Private Const MEM_PRIVATE& = &H20000
Private Const PAGE_NOACCESS = 1
Private Const PAGE_READONLY = 2
Private Const PAGE_READWRITE = 4
Private Const PAGE_WRITECOPY = 8
Private Const PAGE_EXECUTE = 16
Private Const PAGE_EXECUTE_READ = 32
Private Const PAGE_EXECUTE_READWRITE = 64
Private Const PAGE_EXECUTE_WRITECOPY = 128
Private Const PAGE_GUARD = 256
Private Const PAGE_NOCACHE = 512

Public Property Let Value(ByVal vData As Double)
    Dim B As Double
    VirtualProtect mvarAddress, 8, PAGE_READWRITE, PAGE_READONLY
    CopyMemory B, ByVal mvarAddress, 8
    If B <> mvarValue Then End 'Memory altered.
    mvarValue = vData
    CopyMemory ByVal mvarAddress, mvarValue, 8
    VirtualProtect mvarAddress, 8, PAGE_READONLY, PAGE_READWRITE
End Property

Public Property Get Value() As Double
Attribute Value.VB_UserMemId = 0
Attribute Value.VB_MemberFlags = "200"
    Value = mvarValue
End Property

Private Sub Class_Initialize()
    mvarAddress = VirtualAlloc(0&, 8, MEM_COMMIT, PAGE_READONLY)
End Sub

Private Sub Class_Terminate()
    VirtualFree mvarAddress, 8, MEM_DECOMMIT
End Sub

