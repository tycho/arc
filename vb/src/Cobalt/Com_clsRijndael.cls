VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsRijndael"
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
'*******************************************************************'

' Visual Basic AES (Rijndael) Implementation
' P. Fresle and David Midkiff (mdj2023@hotmail.com)
' Modified for support with ActiveX by Antonio Ramirez Cobos
'
' AES (Rijndael) implementation with file support, hex conversion,
' speed string concatenation and overall optimisations for Visual Basic.
'
' Originally written in VB by P. Fresle and later optimized/overhauled
' for efficiency by David Midkiff. Implemented to ActiveX by Antonio Ramirez Cobos
'
' Information on the algorithm can be found at:
' http://csrc.nist.gov/encryption/aes/

Option Explicit
Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (ByVal Destination As Any, ByVal Source As Any, ByVal Length As Long)
Private Declare Sub CopyMem Lib "kernel32" Alias "RtlMoveMemory" (Destination As Any, Source As Any, ByVal Length As Long)

Private ByteArray()     As Byte
Private hiByte          As Long
Private hiBound         As Long
Private m_lOnBits(30)   As Long
Private m_l2Power(30)   As Long
Private m_bytOnBits(7)  As Byte
Private m_byt2Power(7)  As Byte
Private m_InCo(3)       As Byte
Private m_fbsub(255)    As Byte
Private m_rbsub(255)    As Byte
Private m_ptab(255)     As Byte
Private m_ltab(255)     As Byte
Private m_ftable(255)   As Long
Private m_rtable(255)   As Long
Private m_rco(29)       As Long
Private m_Nk            As Long
Private m_Nb            As Long
Private m_Nr            As Long
Private m_fi(23)        As Byte
Private m_ri(23)        As Byte
Private m_fkey(119)     As Long
Private m_rkey(119)     As Long
Private m_Key           As String
'
' MTS

Event Progress(Percent As Long)
Event StatusChanged(lStatus As Long)

Private Property Let key(New_Value As String)
    m_Key = New_Value
End Property

Public Function EncryptString(Text As String, Optional key As String) As String
    Dim bytIn() As Byte, Out As String, bytKey() As Byte
    On Error GoTo errhandler
    If m_Key <> key And key <> vbNullString Then m_Key = key
    bytIn = Text
    bytKey = m_Key
    Out = StrConv(EncryptByte(bytIn, bytKey), vbUnicode)
    EncryptString = Out
    Exit Function
errhandler:
    Call Err.Raise(Err.Number, Err.Source, Err.Description)
End Function

Public Function DecryptString(Text As String, Optional key As String) As String
    Dim bytOut() As Byte, bytKey() As Byte, lCount As Long, lLength As Long, IsTextInHex As Boolean
    On Error GoTo errhandler
    If m_Key <> key And key <> vbNullString Then m_Key = key
    bytKey = m_Key
    If IsTextInHex = False Then Text = EnHex(Text)
    lLength = Len(Text)
    ReDim bytOut((lLength \ 2) - 1)
    For lCount = 1 To lLength Step 2
        bytOut(lCount \ 2) = CByte("&H" & Mid$(Text, lCount, 2))
    Next
    Dim tlong As Long
    DecryptString = DecryptByte(bytOut, bytKey, tlong)
    Exit Function
errhandler:
    Call Err.Raise(Err.Number, Err.Source, Err.Description)
End Function

Public Function EncryptFile(InFile As String, OutFile As String, Overwrite As Boolean, Optional key As String) As Boolean
    
    On Error GoTo errhandler
    If FileExist(InFile) = False Then
        EncryptFile = False
        Exit Function
    End If
    If FileExist(OutFile) = True And Overwrite = False Then
        EncryptFile = False
        Exit Function
    End If
    Dim Buffer As String, FileO As Integer
    FileO = FreeFile
    Open InFile For Binary As #FileO
    Buffer = Space$(LOF(1))
    Get #FileO, , Buffer
    Close #FileO
    If m_Key <> key And key <> vbNullString Then m_Key = key
    
    Buffer = EncryptString(Buffer, m_Key)
    If FileExist(OutFile) = True Then Kill OutFile
    FileO = FreeFile
    Open OutFile For Binary As #FileO
    Put #FileO, , Buffer
    Close #FileO
    RaiseEvent Progress(100)
    
    EncryptFile = True
    Exit Function
    
errhandler:
    ' ---------------------------------------------------------------------------
    ' Raise friendly error to the handler
    ' ---------------------------------------------------------------------------
    Call Err.Raise(Err.Number, Err.Source, Err.Description)
End Function

Public Function DecryptFile(InFile As String, OutFile As String, Overwrite As Boolean, Optional key As String) As Boolean
    On Error GoTo errhandler
    
    If FileExist(InFile) = False Then
        DecryptFile = False
        Exit Function
    End If
    If FileExist(OutFile) = True And Overwrite = False Then
        DecryptFile = False
        Exit Function
    End If
    Dim Buffer As String, FileO As Integer
    FileO = FreeFile
    Open InFile For Binary As #FileO
    Buffer = Space$(LOF(1))
    Get #FileO, , Buffer
    Close #FileO
    If m_Key <> key And key <> vbNullString Then m_Key = key
    Buffer = DecryptString(Buffer, m_Key)
    If FileExist(OutFile) Then Kill OutFile
    
    FileO = FreeFile
    Open OutFile For Binary As #FileO
    Put #FileO, , Buffer
    Close #FileO
    RaiseEvent Progress(100)
    DecryptFile = True
    Exit Function
    
errhandler:
    ' ---------------------------------------------------------------------------
    ' Raise friendly error to the handler
    ' ---------------------------------------------------------------------------
    Call Err.Raise(Err.Number, Err.Source, Err.Description)
    
End Function

Private Sub Append(ByRef StringData As String, Optional Length As Long)
    Dim DataLength As Long
    If Length > 0 Then DataLength = Length Else DataLength = Len(StringData)
    If DataLength + hiByte > hiBound Then
        hiBound = hiBound + 1024
        ReDim Preserve ByteArray(hiBound)
    End If
    CopyMem ByVal VarPtr(ByteArray(hiByte)), ByVal StringData, DataLength
    hiByte = hiByte + DataLength
End Sub

Private Function DeHex(Data As String) As String
    Dim iCount As Double
    Reset
    For iCount = 1 To Len(Data) Step 2
        Append Chr$(Val("&H" & Mid$(Data, iCount, 2)))
    Next
    DeHex = GData
    Reset
End Function

Private Function FileExist(Filename As String) As Boolean
    On Error GoTo errorhandler
    Call FileLen(Filename)
    FileExist = True
    Exit Function
    
errorhandler:
    FileExist = False
End Function

Private Property Get GData() As String
    Dim StringData As String
    StringData = Space(hiByte)
    CopyMem ByVal StringData, ByVal VarPtr(ByteArray(0)), hiByte
    GData = StringData
End Property

Private Sub Reset()
    hiByte = 0
    hiBound = 1024
    ReDim ByteArray(hiBound)
End Sub

Private Function EnHex(Data As String) As String
    Dim iCount As Double, sTemp As String
    Reset
    For iCount = 1 To Len(Data)
        sTemp = Hex$(Asc(Mid$(Data, iCount, 1)))
        If Len(sTemp) < 2 Then sTemp = "0" & sTemp
        Append sTemp
    Next
    EnHex = GData
    Reset
End Function
Private Sub Class_Initialize()
    m_InCo(0) = &HB
    m_InCo(1) = &HD
    m_InCo(2) = &H9
    m_InCo(3) = &HE
    
    m_bytOnBits(0) = 1
    m_bytOnBits(1) = 3
    m_bytOnBits(2) = 7
    m_bytOnBits(3) = 15
    m_bytOnBits(4) = 31
    m_bytOnBits(5) = 63
    m_bytOnBits(6) = 127
    m_bytOnBits(7) = 255
    
    m_byt2Power(0) = 1
    m_byt2Power(1) = 2
    m_byt2Power(2) = 4
    m_byt2Power(3) = 8
    m_byt2Power(4) = 16
    m_byt2Power(5) = 32
    m_byt2Power(6) = 64
    m_byt2Power(7) = 128
    m_lOnBits(0) = 1
    m_lOnBits(1) = 3
    m_lOnBits(2) = 7
    m_lOnBits(3) = 15
    m_lOnBits(4) = 31
    m_lOnBits(5) = 63
    m_lOnBits(6) = 127
    m_lOnBits(7) = 255
    m_lOnBits(8) = 511
    m_lOnBits(9) = 1023
    m_lOnBits(10) = 2047
    m_lOnBits(11) = 4095
    m_lOnBits(12) = 8191
    m_lOnBits(13) = 16383
    m_lOnBits(14) = 32767
    m_lOnBits(15) = 65535
    m_lOnBits(16) = 131071
    m_lOnBits(17) = 262143
    m_lOnBits(18) = 524287
    m_lOnBits(19) = 1048575
    m_lOnBits(20) = 2097151
    m_lOnBits(21) = 4194303
    m_lOnBits(22) = 8388607
    m_lOnBits(23) = 16777215
    m_lOnBits(24) = 33554431
    m_lOnBits(25) = 67108863
    m_lOnBits(26) = 134217727
    m_lOnBits(27) = 268435455
    m_lOnBits(28) = 536870911
    m_lOnBits(29) = 1073741823
    m_lOnBits(30) = 2147483647
    m_l2Power(0) = 1
    m_l2Power(1) = 2
    m_l2Power(2) = 4
    m_l2Power(3) = 8
    m_l2Power(4) = 16
    m_l2Power(5) = 32
    m_l2Power(6) = 64
    m_l2Power(7) = 128
    m_l2Power(8) = 256
    m_l2Power(9) = 512
    m_l2Power(10) = 1024
    m_l2Power(11) = 2048
    m_l2Power(12) = 4096
    m_l2Power(13) = 8192
    m_l2Power(14) = 16384
    m_l2Power(15) = 32768
    m_l2Power(16) = 65536
    m_l2Power(17) = 131072
    m_l2Power(18) = 262144
    m_l2Power(19) = 524288
    m_l2Power(20) = 1048576
    m_l2Power(21) = 2097152
    m_l2Power(22) = 4194304
    m_l2Power(23) = 8388608
    m_l2Power(24) = 16777216
    m_l2Power(25) = 33554432
    m_l2Power(26) = 67108864
    m_l2Power(27) = 134217728
    m_l2Power(28) = 268435456
    m_l2Power(29) = 536870912
    m_l2Power(30) = 1073741824
End Sub

Private Function LShift(ByVal lValue As Long, ByVal iShiftBits As Integer) As Long
    If iShiftBits = 0 Then
        LShift = lValue
        Exit Function
    ElseIf iShiftBits = 31 Then
        If lValue And 1 Then LShift = &H80000000 Else LShift = 0
        Exit Function
    ElseIf iShiftBits < 0 Or iShiftBits > 31 Then
        Err.Raise 6
    End If
    
    If (lValue And m_l2Power(31 - iShiftBits)) Then LShift = ((lValue And m_lOnBits(31 - (iShiftBits + 1))) * m_l2Power(iShiftBits)) Or &H80000000 Else LShift = ((lValue And m_lOnBits(31 - iShiftBits)) * m_l2Power(iShiftBits))
End Function

Private Function RShift(ByVal lValue As Long, ByVal iShiftBits As Integer) As Long
    If iShiftBits = 0 Then
        RShift = lValue
        Exit Function
    ElseIf iShiftBits = 31 Then
        If lValue And &H80000000 Then RShift = 1 Else RShift = 0
        Exit Function
    ElseIf iShiftBits < 0 Or iShiftBits > 31 Then
        Err.Raise 6
    End If
    
    RShift = (lValue And &H7FFFFFFE) \ m_l2Power(iShiftBits)
    
    If (lValue And &H80000000) Then RShift = (RShift Or (&H40000000 \ m_l2Power(iShiftBits - 1)))
End Function

Private Function LShiftByte(ByVal bytValue As Byte, ByVal bytShiftBits As Byte) As Byte
    If bytShiftBits = 0 Then
        LShiftByte = bytValue
        Exit Function
    ElseIf bytShiftBits = 7 Then
        If bytValue And 1 Then LShiftByte = &H80 Else LShiftByte = 0
        Exit Function
    ElseIf bytShiftBits < 0 Or bytShiftBits > 7 Then
        Err.Raise 6
    End If
    
    LShiftByte = ((bytValue And m_bytOnBits(7 - bytShiftBits)) * m_byt2Power(bytShiftBits))
End Function
Private Function RShiftByte(ByVal bytValue As Byte, ByVal bytShiftBits As Byte) As Byte
    If bytShiftBits = 0 Then
        RShiftByte = bytValue
        Exit Function
    ElseIf bytShiftBits = 7 Then
        If bytValue And &H80 Then RShiftByte = 1 Else RShiftByte = 0
        Exit Function
    ElseIf bytShiftBits < 0 Or bytShiftBits > 7 Then
        Err.Raise 6
    End If
    
    RShiftByte = bytValue \ m_byt2Power(bytShiftBits)
End Function
Private Function RotateLeft(ByVal lValue As Long, ByVal iShiftBits As Integer) As Long
    RotateLeft = LShift(lValue, iShiftBits) Or RShift(lValue, (32 - iShiftBits))
End Function

Private Function RotateLeftByte(ByVal bytValue As Byte, ByVal bytShiftBits As Byte) As Byte
    RotateLeftByte = LShiftByte(bytValue, bytShiftBits) Or RShiftByte(bytValue, (8 - bytShiftBits))
End Function
Private Function Pack(B() As Byte) As Long
    Dim lCount As Long
    Dim lTemp  As Long
    
    For lCount = 0 To 3
        lTemp = B(lCount)
        Pack = Pack Or LShift(lTemp, (lCount * 8))
    Next
End Function

Private Function PackFrom(B() As Byte, ByVal K As Long) As Long
    Dim lCount As Long, lTemp  As Long
    
    For lCount = 0 To 3
        lTemp = B(lCount + K)
        PackFrom = PackFrom Or LShift(lTemp, (lCount * 8))
    Next
End Function
Private Sub Unpack(ByVal a As Long, B() As Byte)
    B(0) = a And m_lOnBits(7)
    B(1) = RShift(a, 8) And m_lOnBits(7)
    B(2) = RShift(a, 16) And m_lOnBits(7)
    B(3) = RShift(a, 24) And m_lOnBits(7)
End Sub
Private Sub UnpackFrom(ByVal a As Long, B() As Byte, ByVal K As Long)
    B(0 + K) = a And m_lOnBits(7)
    B(1 + K) = RShift(a, 8) And m_lOnBits(7)
    B(2 + K) = RShift(a, 16) And m_lOnBits(7)
    B(3 + K) = RShift(a, 24) And m_lOnBits(7)
End Sub
Private Function xtime(ByVal a As Byte) As Byte
    Dim B As Byte
    If (a And &H80) Then B = &H1B Else B = 0
    a = LShiftByte(a, 1)
    a = a Xor B
    xtime = a
End Function
Private Function bmul(ByVal x As Byte, Y As Byte) As Byte
    If x <> 0 And Y <> 0 Then bmul = m_ptab((CLng(m_ltab(x)) + CLng(m_ltab(Y))) Mod 255) Else bmul = 0
End Function
Private Function SubByte(ByVal a As Long) As Long
    Dim B(3) As Byte
    Unpack a, B
    B(0) = m_fbsub(B(0)): B(1) = m_fbsub(B(1))
    B(2) = m_fbsub(B(2)): B(3) = m_fbsub(B(3))
    SubByte = Pack(B)
End Function
Private Function product(ByVal x As Long, ByVal Y As Long) As Long
    Dim xb(3) As Byte, yb(3) As Byte
    Unpack x, xb
    Unpack Y, yb
    product = bmul(xb(0), yb(0)) Xor bmul(xb(1), yb(1)) Xor bmul(xb(2), yb(2)) Xor bmul(xb(3), yb(3))
End Function
Private Function InvMixCol(ByVal x As Long) As Long
    Dim Y As Long, M As Long, B(3) As Byte
    
    M = Pack(m_InCo): B(3) = product(M, x)
    M = RotateLeft(M, 24): B(2) = product(M, x)
    M = RotateLeft(M, 24): B(1) = product(M, x)
    M = RotateLeft(M, 24): B(0) = product(M, x)
    Y = Pack(B): InvMixCol = Y
End Function

Private Function ByteSub(ByVal x As Byte) As Byte
    Dim Y As Byte
    Y = m_ptab(255 - m_ltab(x)): x = Y
    x = RotateLeftByte(x, 1): Y = Y Xor x
    x = RotateLeftByte(x, 1): Y = Y Xor x
    x = RotateLeftByte(x, 1): Y = Y Xor x
    x = RotateLeftByte(x, 1): Y = Y Xor x
    Y = Y Xor &H63: ByteSub = Y
End Function
Private Sub gentables()
    Dim I As Long, Y As Byte, B(3) As Byte, ib As Byte
    
    m_ltab(0) = 0: m_ptab(0) = 1: m_ltab(1) = 0: m_ptab(1) = 3: m_ltab(3) = 1
    For I = 2 To 255
        m_ptab(I) = m_ptab(I - 1) Xor xtime(m_ptab(I - 1)): m_ltab(m_ptab(I)) = I
    Next
    m_fbsub(0) = &H63: m_rbsub(&H63) = 0
    For I = 1 To 255
        ib = I: Y = ByteSub(ib): m_fbsub(I) = Y: m_rbsub(Y) = I
    Next
    Y = 1
    For I = 0 To 29
        m_rco(I) = Y: Y = xtime(Y)
    Next
    For I = 0 To 255
        Y = m_fbsub(I): B(3) = Y Xor xtime(Y)
        B(2) = Y: B(1) = Y: B(0) = xtime(Y)
        m_ftable(I) = Pack(B): Y = m_rbsub(I)
        B(3) = bmul(m_InCo(0), Y): B(2) = bmul(m_InCo(1), Y)
        B(1) = bmul(m_InCo(2), Y): B(0) = bmul(m_InCo(3), Y)
        m_rtable(I) = Pack(B)
    Next
End Sub

Private Sub gkey(ByVal nb As Long, ByVal nk As Long, key() As Byte)
    Dim I As Long, j As Long, K As Long, M As Long, n As Long, C1 As Long, C2 As Long, C3 As Long, CipherKey(7) As Long
    
    m_Nb = nb: m_Nk = nk
    If m_Nb >= m_Nk Then m_Nr = 6 + m_Nb Else m_Nr = 6 + m_Nk
    C1 = 1
    If m_Nb < 8 Then
        C2 = 2: C3 = 3
    Else
        C2 = 3: C3 = 4
    End If
    For j = 0 To nb - 1
        M = j * 3
        m_fi(M) = (j + C1) Mod nb: m_fi(M + 1) = (j + C2) Mod nb
        m_fi(M + 2) = (j + C3) Mod nb: m_ri(M) = (nb + j - C1) Mod nb
        m_ri(M + 1) = (nb + j - C2) Mod nb: m_ri(M + 2) = (nb + j - C3) Mod nb
    Next
    n = m_Nb * (m_Nr + 1)
    For I = 0 To m_Nk - 1
        j = I * 4: CipherKey(I) = PackFrom(key, j)
    Next
    For I = 0 To m_Nk - 1
        m_fkey(I) = CipherKey(I)
    Next
    j = m_Nk: K = 0
    Do While j < n
        m_fkey(j) = m_fkey(j - m_Nk) Xor SubByte(RotateLeft(m_fkey(j - 1), 24)) Xor m_rco(K)
        If m_Nk <= 6 Then
            I = 1
            Do While I < m_Nk And (I + j) < n
                m_fkey(I + j) = m_fkey(I + j - m_Nk) Xor m_fkey(I + j - 1)
                I = I + 1
            Loop
        Else
            I = 1
            Do While I < 4 And (I + j) < n
                m_fkey(I + j) = m_fkey(I + j - m_Nk) Xor m_fkey(I + j - 1)
                I = I + 1
            Loop
            If j + 4 < n Then m_fkey(j + 4) = m_fkey(j + 4 - m_Nk) Xor SubByte(m_fkey(j + 3))
            I = 5
            Do While I < m_Nk And (I + j) < n
                m_fkey(I + j) = m_fkey(I + j - m_Nk) Xor m_fkey(I + j - 1)
                I = I + 1
            Loop
        End If
        j = j + m_Nk
        K = K + 1
    Loop
    For j = 0 To m_Nb - 1
        m_rkey(j + n - nb) = m_fkey(j)
    Next
    I = m_Nb
    Do While I < n - m_Nb
        K = n - m_Nb - I
        For j = 0 To m_Nb - 1
            m_rkey(K + j) = InvMixCol(m_fkey(I + j))
        Next
        I = I + m_Nb
    Loop
    j = n - m_Nb
    Do While j < n
        m_rkey(j - n + m_Nb) = m_fkey(j)
        j = j + 1
    Loop
End Sub

Private Sub Encrypt(buff() As Byte)
    Dim I As Long, j As Long, K As Long, M As Long, a(7) As Long, B(7) As Long, x() As Long, Y() As Long, t() As Long
    For I = 0 To m_Nb - 1
        j = I * 4: a(I) = PackFrom(buff, j): a(I) = a(I) Xor m_fkey(I)
    Next
    K = m_Nb: x = a: Y = B
    For I = 1 To m_Nr - 1
        For j = 0 To m_Nb - 1
            M = j * 3: Y(j) = m_fkey(K) Xor m_ftable(x(j) And m_lOnBits(7)) Xor RotateLeft(m_ftable(RShift(x(m_fi(M)), 8) And m_lOnBits(7)), 8) Xor RotateLeft(m_ftable(RShift(x(m_fi(M + 1)), 16) And m_lOnBits(7)), 16) Xor RotateLeft(m_ftable(RShift(x(m_fi(M + 2)), 24) And m_lOnBits(7)), 24): K = K + 1
        Next
        t = x: x = Y: Y = t
    Next
    For j = 0 To m_Nb - 1
        M = j * 3: Y(j) = m_fkey(K) Xor m_fbsub(x(j) And m_lOnBits(7)) Xor RotateLeft(m_fbsub(RShift(x(m_fi(M)), 8) And m_lOnBits(7)), 8) Xor RotateLeft(m_fbsub(RShift(x(m_fi(M + 1)), 16) And m_lOnBits(7)), 16) Xor RotateLeft(m_fbsub(RShift(x(m_fi(M + 2)), 24) And m_lOnBits(7)), 24): K = K + 1
    Next
    For I = 0 To m_Nb - 1
        j = I * 4: UnpackFrom Y(I), buff, j: x(I) = 0: Y(I) = 0
    Next
End Sub

Private Sub Decrypt(buff() As Byte)
    Dim I As Long, j As Long, K As Long, M As Long, a(7) As Long, B(7) As Long, x() As Long, Y() As Long, t() As Long
    For I = 0 To m_Nb - 1
        j = I * 4: a(I) = PackFrom(buff, j): a(I) = a(I) Xor m_rkey(I)
    Next
    K = m_Nb: x = a: Y = B
    For I = 1 To m_Nr - 1
        For j = 0 To m_Nb - 1
            M = j * 3: Y(j) = m_rkey(K) Xor m_rtable(x(j) And m_lOnBits(7)) Xor RotateLeft(m_rtable(RShift(x(m_ri(M)), 8) And m_lOnBits(7)), 8) Xor RotateLeft(m_rtable(RShift(x(m_ri(M + 1)), 16) And m_lOnBits(7)), 16) Xor RotateLeft(m_rtable(RShift(x(m_ri(M + 2)), 24) And m_lOnBits(7)), 24): K = K + 1
        Next
        t = x: x = Y: Y = t
    Next
    For j = 0 To m_Nb - 1
        M = j * 3: Y(j) = m_rkey(K) Xor m_rbsub(x(j) And m_lOnBits(7)) Xor RotateLeft(m_rbsub(RShift(x(m_ri(M)), 8) And m_lOnBits(7)), 8) Xor RotateLeft(m_rbsub(RShift(x(m_ri(M + 1)), 16) And m_lOnBits(7)), 16) Xor RotateLeft(m_rbsub(RShift(x(m_ri(M + 2)), 24) And m_lOnBits(7)), 24): K = K + 1
    Next
    For I = 0 To m_Nb - 1
        j = I * 4: UnpackFrom Y(I), buff, j: x(I) = 0: Y(I) = 0
    Next
End Sub


Private Function IsInitialized(ByRef vArray As Variant) As Boolean
    On Error Resume Next
    IsInitialized = IsNumeric(UBound(vArray))
End Function
Public Function EncryptByte(bytMessage() As Byte, bytPassword() As Byte) As Byte()
    Dim bytKey(31) As Byte, bytIn()  As Byte, bytOut() As Byte, bytTemp(31) As Byte
    Dim lCount As Long, lEncodedLength As Long, lPosition As Long, lLength As Long
    
    If Not IsInitialized(bytMessage) Then Exit Function
    If Not IsInitialized(bytPassword) Then Exit Function
    For lCount = 0 To UBound(bytPassword)
        bytKey(lCount) = bytPassword(lCount)
        If lCount = 31 Then Exit For
    Next
    gentables
    gkey 8, 8, bytKey
    lLength = UBound(bytMessage) + 1
    lEncodedLength = lLength + 4
    If lEncodedLength Mod 32 <> 0 Then lEncodedLength = lEncodedLength + 32 - (lEncodedLength Mod 32)
    ReDim bytIn(lEncodedLength - 1)
    ReDim bytOut(lEncodedLength - 1)
    CopyMemory VarPtr(bytIn(0)), VarPtr(lLength), 4
    CopyMemory VarPtr(bytIn(4)), VarPtr(bytMessage(0)), lLength
    For lCount = 0 To lEncodedLength - 1 Step 32
        CopyMemory VarPtr(bytTemp(0)), VarPtr(bytIn(lCount)), 32
        Encrypt bytTemp
        CopyMemory VarPtr(bytOut(lCount)), VarPtr(bytTemp(0)), 32
        RaiseEvent Progress((lCount / lEncodedLength) * 100)
        DoEvents
    Next
    EncryptByte = bytOut
End Function
Public Function DecryptByte(bytIn() As Byte, bytPassword() As Byte, lLength As Long) As Byte()
    On Error Resume Next
    Dim bytMessage() As Byte, bytKey(31) As Byte, bytOut() As Byte
    Dim bytTemp(31) As Byte, lCount As Long
    Dim lEncodedLength As Long
    If Not IsInitialized(bytIn) Then Exit Function
    If Not IsInitialized(bytPassword) Then Exit Function
    lEncodedLength = UBound(bytIn) + 1
    If lEncodedLength Mod 32 <> 0 Then Exit Function
    For lCount = 0 To UBound(bytPassword)
        bytKey(lCount) = bytPassword(lCount)
        If lCount = 31 Then Exit For
    Next
    gentables
    gkey 8, 8, bytKey
    ReDim bytOut(lEncodedLength - 1)
    For lCount = 0 To lEncodedLength - 1 Step 32
        CopyMemory VarPtr(bytTemp(0)), VarPtr(bytIn(lCount)), 32
        Decrypt bytTemp
        CopyMemory VarPtr(bytOut(lCount)), VarPtr(bytTemp(0)), 32
        RaiseEvent Progress(Fix((lCount / lEncodedLength) * 100))
        DoEvents
    Next
    CopyMemory VarPtr(lLength), VarPtr(bytOut(0)), 4
    If lLength > lEncodedLength - 4 Then Exit Function
    ReDim bytMessage(lLength - 1)
    CopyMemory VarPtr(bytMessage(0)), VarPtr(bytOut(4)), lLength
    
    DecryptByte = bytMessage
End Function

Private Function ToString() As String
    ToString = "Rijndael"
End Function


