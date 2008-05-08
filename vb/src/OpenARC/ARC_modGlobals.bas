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

Public Stopping As Boolean
Public Playing As Boolean
Public BufferWasLost As Boolean
Public bDebugLog As Integer
Public Const PI As Double = 3.141592653
Public Const Div180byPI As Double = 180 / PI
Public Const TwoPI As Double = PI * 2
Public Const DivBy360 As Double = 1 / 360
Public Const Div360MultPI As Double = DivBy360 * TwoPI
Public Const dLEFT As Integer = 1
Public Const dUP As Integer = 2
Public Const dRIGHT As Integer = 3
Public Const dDOWN  As Integer = 4

Public Const aLEFT2 As Integer = 98
Public Const aUP2 As Integer = 1
Public Const aRIGHT2 As Integer = 33
Public Const aDOWN2 As Integer = 65

'Public Crypt As clsCryptAPI

Public Function NewGTC() As Long
    Dim C As Long
    C = GetTickCount
    If C < 0 Then
        C = C + 2147483647
    End If
    NewGTC = C
End Function

Public Sub SetLoadTitle(sCaption As String)
    If StartLog Then
        StartupLog "Load title changed to: '" & sCaption & "'"
    End If
    frmSplash.lblLoading.Caption = sCaption
    frmSplash.Refresh
    LoadCap = sCaption
End Sub
