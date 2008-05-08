Attribute VB_Name = "modIP"
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
'               This module is used with permission.                '
'                 Copyright © Verburgh Peter 2001                   '
'*******************************************************************'

'******************************************************************
'Created By Verburgh Peter.
' 07-23-2001
' verburgh.peter@skynet.be
'-------------------------------------
'With this small application , you can detect the IP's installed on your computer,
'including subnet mask , BroadcastAddr..
'
'I've wrote this because i've a programm that uses the winsock control, but,
'if you have multiple ip's  installed on your pc , you could get by using the Listen
' method the wrong ip ...
'Because Winsock.Localip => detects the default ip installed on your PC ,
' and in most of the cases it could be the LAN (nic) not the WAN (nic)
'So then you have to use the Bind function ,to bind to your right ip..
'but how do you know & find that ip ?
'you can find it now by this appl.. it check's in the api.. IP Table..
'******************************************************************

Option Explicit
Option Compare Text

Const MAX_IP = 10   'To make a buffer... i dont think you have more than 10

Type IPINFO
    dwAddr As Long          'IP address
    dwIndex As Long         'interface index
    dwMask As Long          'subnet mask
    dwBCastAddr As Long     'broadcast address
    dwReasmSize  As Long    'assembly size
    unused1 As Integer      'not currently used
    unused2 As Integer      'not currently used
End Type

Type MIB_IPADDRTABLE
    dEntrys As Long   'number of entries in the table
    mIPInfo(MAX_IP) As IPINFO  'array of IP address entries
End Type

Type IP_Array
    mBuffer As MIB_IPADDRTABLE
    BufferLen As Long
End Type

Public IP_Addr(10) As IPINFO

Public Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (Destination As Any, Source As Any, ByVal Length As Long)
Public Declare Function GetIpAddrTable Lib "IPHlpApi" (pIPAdrTable As Byte, pdwSize As Long, ByVal Sort As Long) As Long

'converts a Long  to a string
Public Function ConvertAddressToString(longAddr As Long) As String
    Dim myByte(3) As Byte
    Dim Cnt As Long
    CopyMemory myByte(0), longAddr, 4
    For Cnt = 0 To 3
        ConvertAddressToString = ConvertAddressToString + CStr(myByte(Cnt)) + "."
    Next Cnt
    ConvertAddressToString = left$(ConvertAddressToString, Len(ConvertAddressToString) - 1)
End Function

Public Sub EnumerateIPs()
    Dim Ret As Long, tel As Integer
    Dim bBytes() As Byte
    Dim Listing As MIB_IPADDRTABLE
    On Error GoTo END1
    GetIpAddrTable ByVal 0&, Ret, True
    If Ret <= 0 Then Exit Sub
    ReDim bBytes(0 To Ret - 1) As Byte
    GetIpAddrTable bBytes(0), Ret, False
    CopyMemory Listing.dEntrys, bBytes(0), 4
    For tel = 0 To Listing.dEntrys - 1
        CopyMemory Listing.mIPInfo(tel), bBytes(4 + (tel * Len(Listing.mIPInfo(0)))), Len(Listing.mIPInfo(tel))
        IP_Addr(tel).dwAddr = Listing.mIPInfo(tel).dwAddr
        IP_Addr(tel).dwMask = Listing.mIPInfo(tel).dwMask
        IP_Addr(tel).dwBCastAddr = Listing.mIPInfo(tel).dwBCastAddr
    Next
    Exit Sub
END1:
    MsgBox "IP address enumeration failed!", vbExclamation, ProjectName
End Sub

