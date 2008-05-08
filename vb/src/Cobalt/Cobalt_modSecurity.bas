Attribute VB_Name = "modSecurity"
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

Public CryptAPI As clsCryptAPI
Public Encryption As clsEncryption
Public EncPassword As String

Public Function EncPass() As Byte()
    EncPass = EncPassword
End Function

Public Function sEncryptString(sText As String, sPassword As String) As String
    sEncryptString = CryptAPI.EncryptString(sText, sPassword)
End Function

Public Sub InitEncryption()
    Set CryptAPI = New clsCryptAPI
    Set Encryption = New clsEncryption
End Sub

Public Function Scramble(strString As String) As String
    Dim i As Integer, even As String, odd As String
    For i% = 1 To Len(strString$)
        If i% Mod 2 = 0 Then
            even$ = even$ & Mid$(strString$, i%, 1)
        Else
            odd$ = odd$ & Mid$(strString$, i%, 1)
        End If
    Next i
    Scramble$ = even$ & odd$
End Function

Public Function Unscramble(strString As String) As String
    Dim X As Integer, evenint As Integer, oddint As Integer
    Dim even As String, odd As String, fin As String
    X% = Len(strString$)
    X% = Int(Len(strString$) / 2)
    even$ = Mid$(strString$, 1, X%)
    odd$ = Mid$(strString$, X% + 1)
    For X = 1 To Len(strString$)
        If X% Mod 2 = 0 Then
            evenint% = evenint% + 1
            fin$ = fin$ & Mid$(even$, evenint%, 1)
        Else
            oddint% = oddint% + 1
            fin$ = fin$ & Mid$(odd$, oddint%, 1)
        End If
    Next X%
    Unscramble$ = fin$
End Function
