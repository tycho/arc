Attribute VB_Name = "modCobalt"
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

Private Const ICC_USEREX_CLASSES = &H200

Private Type INITCOMMONCONTROLSTYPE
    dwSize As Long
    dwICC As Long
End Type


Public Declare Function FlashWindow Lib "user32" (ByVal hwnd As Long, ByVal bInvert As Long) As Long

Private Declare Function InitCommonControlsEx Lib "comctl32.dll" ( _
    iccex As INITCOMMONCONTROLSTYPE) _
    As Boolean
Private Declare Function SetParent Lib "user32.dll" ( _
    ByVal hWndChild As Long, _
    ByVal hWndNewParent As Long) _
    As Long
Private Declare Function LockWindowUpdate Lib "user32.dll" ( _
    ByVal hwndLock As Long) _
    As Long
Public Const NIM_ADD = &H0
Public Const NIM_MODIFY = &H1
Public Const NIM_DELETE = &H2
Public Const NIF_MESSAGE = &H1
Public Const NIF_ICON = &H2
Public Const NIF_TIP = &H4
Public Const NIF_DOALL = NIF_MESSAGE Or NIF_ICON Or NIF_TIP
Public Const WM_MOUSEMOVE = &H200
Public Const WM_LBUTTONDBLCLK = &H203
Public Const WM_RBUTTONUP = &H205
Public Declare Function RegCloseKey Lib "advapi32.dll" _
    (ByVal hKey As Long) As Long

Public Declare Function RegCreateKey Lib "advapi32.dll" _
    Alias "RegCreateKeyA" (ByVal hKey As Long, ByVal lpSubKey _
    As String, phkResult As Long) As Long

Public Declare Function RegDeleteKey Lib "advapi32.dll" _
    Alias "RegDeleteKeyA" (ByVal hKey As Long, ByVal lpSubKey _
    As String) As Long

Public Declare Function RegDeleteValue Lib "advapi32.dll" _
    Alias "RegDeleteValueA" (ByVal hKey As Long, ByVal _
    lpValueName As String) As Long

Public Declare Function RegOpenKey Lib "advapi32.dll" _
    Alias "RegOpenKeyA" (ByVal hKey As Long, ByVal lpSubKey _
    As String, phkResult As Long) As Long

Public Declare Function RegQueryValueEx Lib "advapi32.dll" _
    Alias "RegQueryValueExA" (ByVal hKey As Long, ByVal lpValueName _
    As String, ByVal lpReserved As Long, lpType As Long, lpData _
    As Any, lpcbData As Long) As Long

Public Declare Function RegSetValueEx Lib "advapi32.dll" _
    Alias "RegSetValueExA" (ByVal hKey As Long, ByVal _
    lpValueName As String, ByVal Reserved As Long, ByVal _
    dwType As Long, lpData As Any, ByVal cbData As Long) As Long

Public Sub DisEnable(Optional Discon As Boolean = True)
    'frmMain.tmrDataArrival.Enabled = False
    frmMain.cmdSend.Enabled = False
    frmMain.cmdPager.Enabled = False
    frmMain.lvUsers.ListItems.Clear
    frmMain.txtInChat.Text = vbNullString
    frmMain.lvGames.ListItems.Clear
    frmMain.lvGameUsers.ListItems.Clear
    frmMain.txtGameDescription.Text = vbNullString: frmMain.txtChat.Text = vbNullString
    frmMain.txtChat.Enabled = False
    ReDim ServerDat(0), svrPlayers(0)
    ReDim Preserve UserDat(0)
    If Discon Then frmMain.sckMain.Disconnect: EnableEncryption = False
End Sub

Public Sub AddUser(Idx As Integer)
    Dim i As Integer, j As Integer
    Dim lstM As Object
    On Error Resume Next
    For i = 1 To frmMain.lvUsers.ListItems.Count
        j = Val(Mid$(frmMain.lvUsers.ListItems.Item(i).Key, 2))
        If j > 0 And Not UserDat(j) Is Nothing Then
            If UserDat(Idx).Admin > UserDat(j).Admin Then Exit For
            If UserDat(j).Admin <= UserDat(Idx).Admin Then
                If LCase$(UserDat(Idx).Nick) < LCase$(frmMain.lvUsers.ListItems.Item(i).Text) Then Exit For
            End If
        End If
    Next
    j = UserDat(Idx).icon
    If IsMuzzled(UserDat(Idx).Nick) Then j = 3
    If j = 18 And Admin < 4 Then j = 0
    If Not (UserDat(Idx).Mode = 1 And Admin < 4) Then
        Set lstM = frmMain.lvUsers.ListItems.Add(i, "P" & Idx, UserDat(Idx).Nick, 0, j)
        If UserDat(Idx).Mode = 0 Then lstM.ForeColor = vbBlack
        If UserDat(Idx).Mode = 1 Then lstM.ForeColor = RGB(155, 155, 155)
    End If
End Sub

Public Function GetUN2(strUser As String) As Integer
    Dim i As Integer
    For i = 0 To UBound(UserDat)
        If Not UserDat(i) Is Nothing Then
            If LCase$(UserDat(i).Nick) = LCase$(strUser) Then Exit For
        End If
    Next
    If i > UBound(UserDat) Then Exit Function
    GetUN2 = i
End Function

Public Function AddChat(Nick As String, ByVal Chat As String, Optional stamp As String = vbNullString) As Long
    Dim itmX As ListItem, s As String, addi As Boolean, i As Integer, j As Integer, X As Integer, a As Integer
    Dim itmSubX As ListSubItem, NewColor As Long, Xs As Single, PM As Boolean
    If Mid$(Chat, 1, 1) = "&" Then
        i = InStr(Mid$(Chat, 2), "&")
        If i Then
            If IsNumeric("&H" & Mid$(Chat, 2, i - 1)) Then NewColor = "&H" & Mid$(Chat, 2, i - 1)
            Chat = Mid$(Chat, i + 2)
        End If
    End If
    Chat = stamp & Chat
    If NewColor = 0 Or NoColor Then NewColor = vbBlack
    a = GetUN2(Nick)
    With frmMain.txtInChat
        If TimeStamp Then
            .SelStart = Len(.Text)
            .SelColor = vbBlack
            .SelBold = False
            .SelItalic = False
            .SelUnderline = False
            j = DateTime.Hour(Now)
            If j > 12 Then j = j - 12: PM = True
            If PM Then
                .SelText = "[" & Format$(j, "00") & ":" & Format$(DateTime.Minute(Now), "00") & " PM] "
            Else
                .SelText = "[" & Format$(j, "00") & ":" & Format$(DateTime.Minute(Now), "00") & " AM] "
            End If
        End If
        .SelStart = Len(.Text)
        .SelColor = vbBlack
        .SelBold = False
        .SelItalic = False
        .SelUnderline = False
        If Not UserDat(GetUN2(Nick)) Is Nothing Then If UserDat(GetUN2(Nick)).Admin > 3 Then .SelBold = True
        If Nick = "Cobalt" Then .SelBold = True: .SelColor = RGB(0, 128, 0)
        .SelText = Nick
        .SelStart = Len(.Text)
        .SelColor = vbBlack
        .SelBold = False
        .SelItalic = False
        .SelUnderline = False
        .SelText = " : "
        .SelStart = Len(.Text)
        .SelColor = NewColor
        .SelText = Chat & vbNewLine
        If Len(.Text) > 15000 Then
            .SelStart = 0
            .SelLength = InStrRev(.Text, vbCrLf, Len(.Text) - 2000, vbTextCompare) + 1
            .SelText = vbNullString
        End If
        AddChat = NewColor
        If frmMain.scrldwn.Checked Then Call SendMessage(.hwnd, WM_VSCROLL, SB_BOTTOM, ByVal 0&)
    End With
    If FlashWindows And frmMain.WindowState = vbMinimized Then
        FlashWindow frmMain.hwnd, 0
    End If
End Function

Public Sub MuzzleThem(MuzzUser As String)
    If MuzzUser = vbNullString Then Exit Sub
    Dim i As Integer, X As Integer, DidMuzz As Boolean, j As Integer
    MuzzUser = LCase$(MuzzUser)
    '
    For X = 1 To UBound(UserDat)
        If Not UserDat(X) Is Nothing Then
            If LCase$(UserDat(X).Nick) = MuzzUser Then j = UserDat(X).icon
            If LCase$(UserDat(X).Nick) = MuzzUser And Not IsMuzzled(UserDat(X).Nick) Then
                If MuzzUser = LCase$(UserName) Then
                    ErrorMSG = "Muzzle yourself?"
                    RaiseInfo ErrorMSG
                    Exit Sub
                End If
                If UserDat(X).Admin > 0 And Admin < 5 Then
                    ErrorMSG = "You're not allowed to muzzle these Keepers of the Sacred Cobalt Flame.  Their word must be heard!"
                    RaiseError ErrorMSG
                    Exit Sub
                End If
                Exit For
            End If
        End If
    Next
    '
    For X = 0 To UBound(Muzzle)
        If LCase$(Muzzle(X)) = MuzzUser Then
            Muzzle(X) = vbNullString
            PlayWAV "unmuzzle.wav", False
            DidMuzz = False
            GoTo lstupdate
        End If
    Next
    
    For X = 0 To UBound(Muzzle) + 1
        If X > UBound(Muzzle) Then ReDim Preserve Muzzle(X)
        If Muzzle(X) = vbNullString Then
            Muzzle(X) = LCase$(MuzzUser)
            PlayWAV "muzzle.wav", False
            DidMuzz = True
            Exit For
        End If
    Next
    
lstupdate:
    For i = 1 To frmMain.lvUsers.ListItems.Count
        If LCase$(frmMain.lvUsers.ListItems(i).Text) = MuzzUser Then
            If DidMuzz Then
                frmMain.lvUsers.ListItems(i).SmallIcon = 3
            Else
                frmMain.lvUsers.ListItems(i).SmallIcon = j
            End If
            DoEvents
            frmMain.lvUsers.Refresh
        End If
    Next
End Sub

'checks if a user is muzzled
Public Function IsMuzzled(sn As String) As Boolean
    Dim i As Integer
    For i = 0 To UBound(Muzzle)
        If LCase$(sn) = LCase$(Muzzle(i)) Then
            IsMuzzled = True
            Exit For
        End If
    Next
End Function

'finds bad words and replaces them
Public Function BadWords(Txt As String) As Boolean
    If NoBadWords = 1 Then
        Txt = Replace(Txt, "fuck", "frick", , , vbTextCompare)
        Txt = Replace(Txt, "bitch", "brat", , , vbTextCompare)
        Txt = Replace(Txt, "fag", "fruit", , , vbTextCompare)
        Txt = Replace(Txt, "cock", "dong", , , vbTextCompare)
        Txt = Replace(Txt, "ass", "butt", , , vbTextCompare)
        Txt = Replace(Txt, "nigger", "dude", , , vbTextCompare)
        Txt = Replace(Txt, "damn", "darn", , , vbTextCompare)
        Txt = Replace(Txt, "shit", "crap", , , vbTextCompare)
    ElseIf NoBadWords = 2 Then
        Txt = Replace(Txt, "fuck", "Ghent", , , vbTextCompare)
        Txt = Replace(Txt, "bitch", "Kaleina", , , vbTextCompare)
        Txt = Replace(Txt, "fag", "Ragnar", , , vbTextCompare)
        Txt = Replace(Txt, "cock", "jv", , , vbTextCompare)
        Txt = Replace(Txt, "ass", "BaKeD", , , vbTextCompare)
        Txt = Replace(Txt, "nigger", "Osiris", , , vbTextCompare)
        Txt = Replace(Txt, "damn", "darn", , , vbTextCompare)
        Txt = Replace(Txt, "shit", "Err0r", , , vbTextCompare)
    End If
End Function

Public Sub SrvIcons(Index As Integer)
    Dim i As Integer, j As Integer, p As Integer
    j = Index
    
    If j = 0 Then Exit Sub
    For i = 0 To UBound(svrPlayers)
        If svrPlayers(i).ServerID = j Then p = p + 1
    Next
    
    For i = 1 To frmMain.lvGames.ListItems.Count
        If frmMain.lvGames.ListItems(i).Key = "S" & j Then
            If p >= ServerDat(j).MaxPlayers Then
                frmMain.lvGames.ListItems(i).SmallIcon = 9
                frmMain.lvGames.Refresh
                Exit Sub
            End If
            Exit For
        End If
    Next
    If i > frmMain.lvGames.ListItems.Count Then Exit Sub
    
    If ServerDat(j).PassProtected Then
        frmMain.lvGames.ListItems(i).SmallIcon = 17
    Else
        If ServerDat(j).GameType = 0 Then frmMain.lvGames.ListItems(i).SmallIcon = 11
        If ServerDat(j).GameType = 1 Then frmMain.lvGames.ListItems(i).SmallIcon = 20
    End If
    frmMain.lvGames.Refresh
End Sub

Public Sub PingRefresh(Optional Start As Integer = -1)
    Dim i As Integer, j As Integer, a As Integer, c As Integer
    If frmMain.lvGames.ListItems.Count = 0 Then Exit Sub
    If Start = -1 Then
        For c = 1 To frmMain.lvGames.ListItems.Count
            j = Mid$(frmMain.lvGames.ListItems(c).Key, 2)
            If j > 0 And frmMain.lvGames.ListItems.Count - 1 > j Then
                If ServerDat(j).latency < 180 Then a = 5
                If ServerDat(j).latency >= 180 And ServerDat(j).latency < 300 Then a = 6
                If ServerDat(j).latency >= 300 And ServerDat(j).latency < 450 Then a = 7
                If ServerDat(j).latency >= 450 Then a = 8
                ServerDat(j).MrB = a
                If Not ServerDat(j).Reachable Then
                    a = 9
                    ServerDat(j).MrB = 4
                    frmMain.lvGames.ListItems.Item(j).Text = ServerDat(j).sName & " [fail]"
                Else
                    frmMain.lvGames.ListItems.Item(j).Text = ServerDat(j).sName & " [" & ServerDat(j).latency & "ms]"
                End If
                Bwidth = a
            End If
        Next
    Else
        j = Mid$(frmMain.lvGames.ListItems(Start).Key, 2)
        If j > 0 Then
            If ServerDat(j).latency < 180 Then a = 5
            If ServerDat(j).latency >= 180 And ServerDat(j).latency < 300 Then a = 6
            If ServerDat(j).latency >= 300 And ServerDat(j).latency < 450 Then a = 7
            If ServerDat(j).latency >= 450 Then a = 8
            ServerDat(j).MrB = a
            If Not ServerDat(j).Reachable Then
                a = 9
                ServerDat(j).MrB = 4
                frmMain.lvGames.ListItems.Item(j).Text = ServerDat(j).sName & " [fail]"
            Else
                frmMain.lvGames.ListItems.Item(j).Text = ServerDat(j).sName & " [" & ServerDat(j).latency & "ms]"
            End If
            Bwidth = a
        End If
    End If
End Sub

Public Sub RefreshPlayers()
    Dim i As Integer, X As Integer, j As Integer, a As Integer
    If frmMain.lvGames.ListItems.Count = 0 Then Exit Sub
    i = Mid$(frmMain.lvGames.SelectedItem.Key, 2)
    If i > UBound(ServerDat) Then Exit Sub
    If ServerDat(i) Is Nothing Then Exit Sub
    PingRefresh
    If frmMain.txtGameDescription <> ServerDat(i).sDesc Then frmMain.txtGameDescription = ServerDat(i).sDesc
    SrvIcons i
    For X = 0 To UBound(svrPlayers)
        If i = svrPlayers(X).ServerID Then
            a = 0
            If svrPlayers(X).Ping < 180 Then a = 5
            If svrPlayers(X).Ping >= 180 And svrPlayers(X).Ping < 300 Then a = 6
            If svrPlayers(X).Ping >= 300 And svrPlayers(X).Ping < 450 Then a = 7
            If svrPlayers(X).Ping >= 450 Then a = 8
            For j = 1 To frmMain.lvGameUsers.ListItems.Count
                If frmMain.lvGameUsers.ListItems(j).Key = "P" & X Then
                    If frmMain.lvGameUsers.ListItems(j).SmallIcon <> a Then frmMain.lvGameUsers.ListItems(j).SmallIcon = a
                    Exit For
                End If
            Next
            If j > frmMain.lvGameUsers.ListItems.Count Then
                frmMain.lvGameUsers.ListItems.Add , "P" & X, svrPlayers(X).ScreenName, 0, a
            End If
        End If
    Next
    
    For j = 1 To frmMain.lvGameUsers.ListItems.Count
        If svrPlayers(Mid$(frmMain.lvGameUsers.ListItems(j).Key, 2)).playerID = 0 Then
            frmMain.lvGameUsers.ListItems.Remove j
            Exit For
        End If
    Next
    frmMain.lvGameUsers.Refresh
End Sub

'Gets the path of the application stuff. If it's running in the dev
'environment, it will default to the 'current' directory.
Public Function AppPath()
    Dim X As String
    X = App.Path
    If DevEnv Then X = App.Path & "\..\current"
    If Right$(X, 1) <> "\" Then X = X + "\"
    AppPath = X
End Function

Public Sub LoadMuzzle()
    Dim nBytes As Long
    Dim cvalues As String * 32767
    Dim cbuffer As String
    Dim X As Integer, Muzzled As Boolean, Muzzles As String
    Dim Y As Integer, i As Integer
    Dim ctext As String
    Dim nend As Integer
    Call GetPrivateProfileSection(LCase(UserName), cvalues, 32767, AppPath & "cobaltdata\muzzle.dat")
    X = 1
    Y = 0
    Do While Not nend
        X = InStr(Y + 1, cvalues, Chr(0))
        ctext = Mid$(cvalues, Y + 1, X - Y - 1)
        If Len(ctext) = 0 Then
            Exit Do
        End If
        Muzzled = Val(Mid$(ctext, InStr(ctext, "=") + 1))
        Muzzles = Mid$(ctext, 1, InStr(ctext, "=") - 1)
        For i = 0 To UBound(Muzzle) + 1
            If i > UBound(Muzzle) Then ReDim Preserve Muzzle(i)
            If Muzzle(i) = vbNullString Then
                Muzzle(i) = Muzzles
                Exit For
            End If
        Next
        Y = X
    Loop
End Sub

'used for unique system ID generation
Public Function KeyGen(ByVal kNamev As String, ByVal kPass As String, ByVal kType As Integer) As String
    '****************************************************************************
    '* KeyGen v2.01 Build 01                                                    *
    '* Copyright © 2000 W.G.Griffiths                                           *
    '*                                                                          *
    '* Url: http://www.webdreams.org.uk                                         *
    '* E-Mail: w.g.griffiths@telinco.co.uk                                      *
    '*                                                                          *
    '* kNamev = Any text String, Object, String$()                               *
    '* kPass = Developer Password as String                                     *
    '*                                                                          *
    '* kType = 1  Numeric Key                                                   *
    '* ktype = 2  Alphanumeric Key                                              *
    '* kType = 3  Hex Key                                                       *
    '*                                                                          *
    '* This function returns a Software Key for a given                         *
    '* name and password                                                        *
    '*                                                                          *
    '* NOTE: Watch www.webdreams.org.uk over the next few months....            *
    '****************************************************************************
    
    On Error Resume Next         'still here just as a precaution
    
    Dim cTable(512) As Integer   'character map
    Dim nKeys(16) As Integer     'xor keys used for pArray(x) xor nkeys(x)
    Dim s0(512) As Integer       'swap-box data used to map character table
    Dim nArray(16) As Integer    'name array data
    Dim pArray(16) As Integer    'password array data
    Dim n As Integer             'for next loop counter
    Dim nPtr As Integer          'name pointer (used for counting)
    Dim cPtr As Integer          'character pointer (used for counting)
    Dim cFlip As Boolean         'character flip (used to flip between numeric and alpha)
    Dim sIni As Integer          'holds s-box values
    Dim temp As Integer          'holds s-box values
    Dim rtn As Integer           'holds generated key values used agains chr map
    Dim gkey As String           'generated key as string
    Dim nLen As Integer          'number of chr's in name
    Dim pLen As Integer          'number of chr's in password
    Dim kPtr As Integer          'key pointer
    Dim sPtr As Integer          'space pointer (used in hex key)
    Dim nOffset As Integer       'name offset
    Dim pOffset As Integer       'password offset
    Dim tOffset As Integer       'total offset
    
    Dim KeySize As Integer       'the size of the key to make
    
    Const nXor As Integer = 18   'name xor value
    Const pXor As Integer = 25   'password xor value
    Const cLw As Integer = 65    'character lower limit 65 = A ** do not change **
    Const nLw As Integer = 48    'number lower limit 48 = 0 ** do not change **
    Const sOffset As Integer = 0 'character map offset
    
    '****************************************************************************
    'Thanks to Chris Fournier for his suggestions for adding support for        *
    'Strings, Objects and String$() as arrays                                    *
    'Your comments please                                                       *
    '****************************************************************************
    Dim kName As String
    
    kName = kNamev
    '****************************************************************************
    
    nLen = Len(kName)
    pLen = Len(kPass)
    
    'password xor keys ** change to make keygen unique **
    nKeys(1) = 12
    nKeys(2) = 18
    nKeys(3) = 123
    nKeys(4) = 46
    nKeys(5) = 64
    nKeys(6) = 34
    nKeys(7) = 78
    nKeys(8) = 201
    nKeys(9) = 10
    nKeys(10) = 123
    nKeys(11) = 248
    nKeys(12) = 41
    nKeys(13) = 136
    nKeys(14) = 69
    nKeys(15) = 54
    nKeys(16) = 106
    
    sIni = 0
    
    'set s boxes
    For n = 0 To 512
        s0(n) = n
    Next n
    
    For n = 0 To 512
        sIni = (sOffset + sIni + n) Mod 256
        temp = s0(n)
        s0(n) = s0(sIni)
        s0(sIni) = temp
    Next n
    
    If kType = 1 Then       '(numeric)
        
        nPtr = 0
        KeySize = 16
        gkey = StringMake(16, " ")
        
        For n = 0 To 512
            cTable(s0(n)) = (nLw + (nPtr))
            nPtr = nPtr + 1
            If nPtr = 10 Then nPtr = 0
        Next n
        
        
        
    ElseIf kType = 2 Then   '(alphanumeric)
        
        nPtr = 0
        cPtr = 0
        KeySize = 16
        gkey = StringMake(16, " ")
        
        cFlip = False
        For n = 0 To 512
            If cFlip Then
                cTable(s0(n)) = (nLw + nPtr)
                nPtr = nPtr + 1
                If nPtr = 10 Then nPtr = 0
                cFlip = False
            Else
                cTable(s0(n)) = (cLw + cPtr)
                cPtr = cPtr + 1
                If cPtr = 26 Then cPtr = 0
                cFlip = True
            End If
        Next n
        
        
        
    Else  '(hex)
        
        KeySize = 8
        gkey = StringMake(19, " ")
        
    End If
    
    kPtr = 1
    
    For n = 1 To nLen 'name
        nArray(kPtr) = nArray(kPtr) + AscW(Mid$(kName, n, 1)) Xor nXor
        nOffset = nOffset + nArray(kPtr)
        kPtr = kPtr + 1
        If kPtr = 9 Then kPtr = 1
    Next n
    
    For n = 1 To pLen 'password
        pArray(kPtr) = pArray(kPtr) + AscW(Mid$(kPass, n, 1)) Xor pXor
        pOffset = pOffset + pArray(kPtr)
        kPtr = kPtr + 1
        If kPtr = 9 Then kPtr = 1
    Next n
    
    tOffset = (nOffset + pOffset) Mod 512
    
    kPtr = 1
    sPtr = 1
    For n = 1 To KeySize
        pArray(n) = pArray(n) Xor nKeys(n)
        rtn = Math.Abs(((nArray(n) Xor pArray(n)) Mod 512) - tOffset)
        
        If kType = 3 Then 'hex key
            If rtn < 16 Then
                Mid$(gkey, kPtr, 2) = "0" & Hex(rtn)
            Else
                Mid$(gkey, kPtr, 2) = Hex(rtn)
            End If
            If sPtr = 2 And kPtr < 18 Then
                kPtr = kPtr + 1
                Mid$(gkey, kPtr + 1, 1) = "-"
            End If
            kPtr = kPtr + 2
            sPtr = sPtr + 1
            If sPtr = 3 Then sPtr = 1
        Else  'numeric - alphanumeric key
            Mid$(gkey, n, 1) = ChrW$(cTable(rtn))
        End If
    Next
    
    KeyGen = gkey
    
End Function

Private Function StringMake(ByVal num As Integer, ByVal Character As String) As String
    Dim temp As String
    Dim i As Integer
    For i = 1 To num
        temp = temp & Character
    Next
    StringMake = temp
End Function

Public Function DevEnv() As Boolean
    On Error GoTo errors
    Debug.Print 1 / 0
    DevEnv = False
    Exit Function
errors:
    DevEnv = True
End Function

'Writes a variable to an INI file
Public Sub writeini(Parent, child, context, file)
    Dim lpAppName As String, lpFileName As String, lpKeyName As String, lpString As String
    Dim U As Long
    lpAppName = Parent
    lpKeyName = child
    lpString = context
    lpFileName = file
    U = WritePrivateProfileString(lpAppName, lpKeyName, lpString, lpFileName)
    If U = 0 Then
        ErrorMSG = "Could not save settings."
        RaiseError ErrorMSG
    End If
End Sub

'Reads a variable from an INI file
Public Function readini(Parent, child, file, default As Variant) As Variant
    Dim X As Long, ReturnString As String, i As Integer, j As Integer
    Dim temp As String * 255
    Dim lpAppName As String, lpKeyName As String, lpDefault As String, lpFileName As String
    lpAppName = Parent
    lpKeyName = child
    lpDefault = file
    lpFileName = file
    X = GetPrivateProfileString(lpAppName, lpKeyName, lpDefault, temp, Len(temp), lpFileName)
    For i = 1 To Len(temp)
        If Asc(Mid$(temp, i, 1)) <> 0 Then
            ReturnString = ReturnString & Mid$(temp, i, 1)
        Else
            Exit For
        End If
    Next
    If X <> 0 And ReturnString <> file Then
        readini = ReturnString
    Else
        readini = default
    End If
End Function

Public Sub JoinGame()
    Dim i As Integer, LaunchPath As String, tmp As String, j As Integer, p As Integer
    If frmMain.lvGames.ListItems.Count = 0 Then Exit Sub
    i = Mid$(frmMain.lvGames.SelectedItem.Key, 2)
    If ServerDat(i).latency > 1000 Then
        ErrorMSG = "Your ping to this server is too high to play."
        RaiseError ErrorMSG
        Exit Sub
    End If
    For j = 0 To UBound(svrPlayers)
        If svrPlayers(j).ServerID = i Then p = p + 1
    Next
    If p >= ServerDat(i).MaxPlayers Then
        ErrorMSG = "This game is full."
        RaiseError ErrorMSG
        Exit Sub
    End If
    LaunchPath = AppPath
    Call writeini("Settings", "UserName", UserName, LaunchPath & "settings.ini")
    Call writeini("Settings", "Server", ServerDat(i).ip, LaunchPath & "settings.ini")
    Call writeini("Settings", "Port", ServerDat(i).port, LaunchPath & "settings.ini")
    pause 1000
    If Dir(LaunchPath & "arc.exe") <> vbNullString Then
        PlayWAV "rd_close.wav", True
        PlayWAV "rd_open.wav", True
        tmp = Password
        If ServerDat(i).PassProtected Then tmp = tmp & Chr(255) Else tmp = tmp & Chr(1)
        Call Shell(LaunchPath & "arc.exe " & tmp, vbNormalFocus)
    Else
        ErrorMSG = LaunchPath & "arc.exe not found!"
        RaiseError ErrorMSG
    End If
End Sub

'Pauses for X seconds.
Public Sub pause(seconds As Long)
    Dim X As Long
    X = NewGTC + seconds
    Do Until NewGTC > X
        DoEvents
    Loop
End Sub

Public Sub DeleteValue(ByVal hKey As Long, ByVal strPath As String, ByVal strValue As String)
    Dim hCurKey As Long
    Dim lRegResult As Long
    lRegResult = RegOpenKey(hKey, strPath, hCurKey)
    lRegResult = RegDeleteValue(hCurKey, strValue)
    lRegResult = RegCloseKey(hCurKey)
End Sub

Public Sub DeleteKey(ByVal hKey As Long, ByVal strPath As String)
    Dim lRegResult As Long
    lRegResult = RegDeleteKey(hKey, strPath)
End Sub

Public Function GetSettingString(hKey As Long, strPath As String, strValue As String, Optional default As String) As String
    Dim hCurKey As Long
    Dim lResult As Long
    Dim lValueType As Long
    Dim strBuffer As String
    Dim lDataBufferSize As Long
    Dim intZeroPos As Integer
    Dim lRegResult As Long
    'Set up default value
    If Not IsEmpty(default) Then
        GetSettingString = default
    Else
        GetSettingString = vbNullString
    End If
    lRegResult = RegOpenKey(hKey, strPath, hCurKey)
    lRegResult = RegQueryValueEx(hCurKey, strValue, 0&, lValueType, ByVal 0&, lDataBufferSize)
    If lRegResult = 0 Then
        If lValueType = REG_SZ Then
            strBuffer = String(lDataBufferSize, " ")
            lResult = RegQueryValueEx(hCurKey, strValue, 0&, 0&, ByVal strBuffer, lDataBufferSize)
            intZeroPos = InStr(strBuffer, Chr$(0))
            If intZeroPos > 0 Then
                GetSettingString = Left$(strBuffer, intZeroPos - 1)
            Else
                GetSettingString = strBuffer
            End If
        End If
    Else
        'there is a problem
    End If
    lRegResult = RegCloseKey(hCurKey)
End Function
Public Sub SaveSettingString(hKey As Long, strPath As String, strValue As String, strData As String)
    Dim hCurKey As Long
    Dim lRegResult As Long
    lRegResult = RegCreateKey(hKey, strPath, hCurKey)
    lRegResult = RegSetValueEx(hCurKey, strValue, 0, REG_SZ, _
        ByVal strData, Len(strData))
    If lRegResult <> 0 Then
        'MsgBox "error"
        'there is a problem
    End If
    lRegResult = RegCloseKey(hCurKey)
End Sub

Public Function GetSettingLong(ByVal hKey As Long, ByVal strPath As String, ByVal strValue As String, Optional default As Long) As Long
    
    Dim lRegResult As Long
    Dim lValueType As Long
    Dim lBuffer As Long
    Dim lDataBufferSize As Long
    Dim hCurKey As Long
    'Set up default value
    If Not IsEmpty(default) Then
        GetSettingLong = default
    Else
        GetSettingLong = 0
    End If
    lRegResult = RegOpenKey(hKey, strPath, hCurKey)
    lDataBufferSize = 4 '4 bytes = 32 bits = long
    lRegResult = RegQueryValueEx(hCurKey, strValue, 0&, lValueType, lBuffer, lDataBufferSize)
    If lRegResult = 0 Then
        If lValueType = REG_DWORD Then
            GetSettingLong = lBuffer
        End If
    Else
        'there is a problem
    End If
    lRegResult = RegCloseKey(hCurKey)
End Function
Public Sub SaveSettingLong(ByVal hKey As Long, ByVal strPath As String, ByVal strValue As String, ByVal lData As Long)
    Dim hCurKey As Long
    Dim lRegResult As Long
    lRegResult = RegCreateKey(hKey, strPath, hCurKey)
    lRegResult = RegSetValueEx(hCurKey, strValue, 0&, REG_DWORD, lData, 4)
    If lRegResult <> 0 Then
        'there is a problem
    End If
    lRegResult = RegCloseKey(hCurKey)
End Sub

Public Sub GetAllKeys(hKey As Long, strPath As String)
    Dim lRegResult As Long
    Dim lCounter As Long
    Dim hCurKey As Long
    Dim strBuffer As String
    lCounter = 0
    lRegResult = RegOpenKey(hKey, strPath, hCurKey)
    ReDim LoginNames(lCounter)
    Do
        strBuffer = String(255, " ")
        lRegResult = RegEnumKey(hCurKey, lCounter, strBuffer, 255)
        If lRegResult = 0& Then
            ReDim Preserve LoginNames(lCounter) As String
            strBuffer = Trim$(strBuffer)
            If Right$(strBuffer, 1) <> Chr$(0) Then
                LoginNames(UBound(LoginNames)) = strBuffer
            Else
                LoginNames(UBound(LoginNames)) = Mid$(strBuffer, 1, Len(strBuffer) - 1)
            End If
            If LoginNames(UBound(LoginNames)) = vbNullString Then LoginNames(UBound(LoginNames)) = "Cobalt"
            lCounter = lCounter + 1
        Else
            Exit Do
        End If
    Loop
End Sub

'requests a user's profile from the server
Public Sub RequestProfile(Txt As String)
    If Txt = vbNullString Then Exit Sub
    Dim lNewMsg As Byte, lOffset As Long
    Dim oNewMsg() As Byte, lNewOffset As Long
    lNewMsg = MSG_PROFILE
    lNewOffset = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
    AddBufferString oNewMsg, Txt, lNewOffset
    SendTo oNewMsg
End Sub

Public Sub ShowStats()
    AddChat "Cobalt", "Requested User Statistics"
    AddChat "Cobalt", "Today's Frags: " & ProfileStats.DFrags
    AddChat "Cobalt", "Today's Deaths: " & ProfileStats.DDeaths
    AddChat "Cobalt", "All-Time Frags: " & ProfileStats.AFrags
    AddChat "Cobalt", "All-Time Deaths: " & ProfileStats.ADeaths
    AddChat "Cobalt", "Current session uptime: " & ProfileStats.NUptime
    AddChat "Cobalt", "Record uptime: " & ProfileStats.TUptime
End Sub

Public Sub CreateRoom(RoomName As String, RoomID As Integer)
    Dim i As Integer
    For i = 0 To UBound(Rooms)
        If Rooms(i).RoomName = vbNullString Then
            Exit For
        End If
    Next
    If i > UBound(Rooms) Then
        ReDim Preserve Rooms(i)
        Set Rooms(i) = New clsChatRoom
    End If
    Rooms(i).RoomName = RoomName
    Rooms(i).RoomIndex = RoomID
End Sub

Public Sub JoinRoom(RoomIndex As Integer)
    'frmMain.txtInChat.Text = vbnullstring
    AddChat "Cobalt", "You have joined the room '" & Rooms(RoomIndex).RoomName & "'."
    frmMain.lvUsers.ListItems.Clear
    ReDim UserDat(0)
    Set UserDat(0) = New clsUserData
    UserDat(0).Nick = "Cobalt"
    frmMain.lblRoom.Caption = Rooms(RoomIndex).RoomName
End Sub

Public Sub RemoveRoom(RoomID As Integer)
    Dim i As Integer
    For i = 0 To UBound(Rooms)
        If Rooms(i).RoomIndex = RoomID Then
            Exit For
        End If
    Next
    If i > UBound(Rooms) Then
        Exit Sub
    End If
    Rooms(i).RoomName = vbNullString
End Sub

Public Function SaveResource(ByVal sResourceName As String, ByVal sResourceType As String, ByVal sToFile As String) As Long
    Dim abResourceData() As Byte
    Dim iFileNumOut As Integer
    
    On Error GoTo ErrFailed
    
    'Retrieve the resource contents (data) into a byte array
    abResourceData = LoadResData(CInt(sResourceName), sResourceType)
    
    'Get Free File Handle
    iFileNumOut = FreeFile
    
    'Open the output file
    Open sToFile For Binary Access Write As #iFileNumOut
    
    'Write the resource to the file
    Put #iFileNumOut, , abResourceData
    
    'Close the file
    Close #iFileNumOut
    
    Exit Function
    
ErrFailed:
    'Failed to save resource file
    If Err.Number = 70 Then SaveResource = 0: Exit Function
    SaveResource = Err.Number
End Function

Public Sub Main()
    On Error Resume Next
    Dim uICC As INITCOMMONCONTROLSTYPE
    
    With uICC
        .dwSize = LenB(uICC)
        .dwICC = ICC_USEREX_CLASSES
    End With
    InitCommonControlsEx uICC
    
    On Error GoTo 0
    frmSplash.Show
    
End Sub



