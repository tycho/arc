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

Private Type tRoomPrivs
    Name As String
    ByWhom As String
    Expire As Date
End Type

Private Type tRoomAdmin
    Name As String
    RoomCreator As Boolean
    pID As Integer
End Type

Private mvarRoomIndex As Integer
Private mvarRoomName As String
Private mvarLocked As Boolean
Private mvarModerated As Boolean
Private mvarBans() As tRoomPrivs
Private mvarGags() As tRoomPrivs
Private mvarAdmins() As tRoomAdmin

Private Function mvarCleanup()
    ReDim mvarBans(0)
    ReDim mvarGags(0)
    ReDim mvarAdmins(0)
    mvarRoomIndex = 0
    mvarRoomName = vbNullString
End Function

Private Function mvarPromote(sUserName As String, bProtected As Boolean)
    Dim I As Integer
    Dim pID As Integer
    pID = -1
    For I = 1 To UBound(UserDat)
        If Not UserDat(I) Is Nothing Then
            If StringComp(UserDat(I).Nick, sUserName) Then
                pID = I
                Exit For
            End If
        End If
    Next
    If pID = -1 Then Exit Function
    For I = 0 To UBound(mvarAdmins)
        If IsEmptyString(mvarAdmins(I).Name) Then
            Exit For
        End If
    Next
    If I > UBound(mvarAdmins) Then
        ReDim Preserve mvarAdmins(I)
    End If
    mvarAdmins(I).Name = sUserName
    mvarAdmins(I).RoomCreator = bProtected
    mvarAdmins(I).pID = pID
    If UserDat(pID).Admin < 1 Then SetIcon pID, 13, mvarRoomIndex
    For I = 1 To UBound(UserDat)
        If Not UserDat(I) Is Nothing Then
            If UserDat(I).Room = mvarRoomIndex Then
                SendChat UserDat(pID).Nick & " has been given room admin status.", 0, I
            End If
        End If
    Next
    mvarPromote = True
End Function

Private Function mvarDemote(sUserName As String)
    Dim I As Integer
    Dim pID As Integer
    pID = -1
    For I = 1 To UBound(UserDat)
        If Not UserDat(I) Is Nothing Then
            If StringComp(UserDat(I).Nick, sUserName) Then
                pID = I
                Exit For
            End If
        End If
    Next
    If pID = -1 Then Exit Function
    If UserDat(pID).Admin > 0 Then Exit Function
    For I = 0 To UBound(mvarAdmins)
        If Not UserDat(I) Is Nothing Then
            If StringComp(mvarAdmins(I).Name, UserDat(pID).Nick) Then
                Exit For
            End If
        End If
    Next
    If mvarAdmins(I).RoomCreator Then Exit Function
    If Not UserDat(I) Is Nothing Then
        If Not StringComp(mvarAdmins(I).Name, UserDat(pID).Nick) Then
            Exit Function
        End If
    Else
        Exit Function
    End If
    mvarAdmins(I).Name = vbNullString
    mvarAdmins(I).pID = 0
    SetIcon pID, 19, mvarRoomIndex
    For I = 1 To UBound(UserDat)
        If Not UserDat(I) Is Nothing Then
            If UserDat(I).Room = mvarRoomIndex Then
                SendChat UserDat(pID).Nick & " has been deopped.", 0, I
            End If
        End If
    Next
    mvarDemote = True
End Function

Private Function mvarIsBanned(sUserName As String) As Boolean
    Dim I As Integer
    For I = 0 To UBound(mvarBans)
        If StringComp(Trim$(mvarBans(I).Name), Trim$(sUserName)) And mvarBans(I).Expire > Now Then mvarIsBanned = True: Exit Function
    Next
End Function

Private Function mvarIsAdmin(sUserName As String) As Boolean
    Dim I As Integer
    Dim pID As Integer
    For I = 1 To UBound(UserDat)
        If Not UserDat(I) Is Nothing Then
            If StringComp(UserDat(I).Nick, sUserName) Then
                pID = I
                Exit For
            End If
        End If
    Next
    If UserDat(pID).Admin > 2 Then
        mvarIsAdmin = True
        Exit Function
    End If
    For I = 0 To UBound(mvarAdmins)
        If StringComp(Trim$(mvarAdmins(I).Name), Trim$(sUserName)) Then mvarIsAdmin = True: Exit Function
    Next
End Function

Private Function mvarIsGagged(ByVal sUserName As String) As Boolean
    Dim I As Integer
    For I = 1 To UBound(UserDat)
        If Not UserDat(I) Is Nothing Then
            If StringComp(Trim$(UserDat(I).Nick), Trim$(sUserName)) And UserDat(I).Admin = 5 Then
                Exit Function
            End If
        End If
    Next
    For I = 0 To UBound(mvarGags)
        If StringComp(Trim$(mvarGags(I).Name), Trim$(sUserName)) And mvarGags(I).Expire > Now Then mvarIsGagged = True: Exit Function
    Next
End Function

Private Function mvarGag(sUser As String, dTime As Date, sWho As String)
    Dim I As Integer
    For I = 0 To UBound(mvarAdmins)
        If StringComp(sUser, mvarAdmins(I).Name) Then
            If mvarAdmins(I).RoomCreator Then Exit Function
        End If
    Next
    For I = 1 To UBound(UserDat)
        If Not UserDat(I) Is Nothing Then
            If StringComp(sUser, UserDat(I).Nick) Then
                If UserDat(I).Admin > 0 Then Exit Function
            End If
        End If
    Next
    For I = 0 To UBound(mvarGags)
        If StringComp(Trim$(mvarGags(I).Name), Trim$(sUser)) Then mvarGags(I).Expire = dTime: Exit Function ': GoTo Out
    Next
    For I = 0 To UBound(mvarGags) + 1
        If I > UBound(mvarGags) Then ReDim Preserve mvarGags(I)
        If IsEmptyString(Trim$(mvarGags(I).Name)) Then
            mvarGags(I).Name = sUser
            mvarGags(I).Expire = dTime
            mvarGags(I).ByWhom = sWho
            Exit For
        End If
    Next
    mvarGag = True
'Out:
    'Open AppPath & "gags_" & mvarRoomIndex & ".dat" For Binary Access Write As #1
    'Put #1, , mvarGags()
    'Close #1
End Function

Private Function mvarBan(sUser As String, dTime As Date, sWho As String)
    Dim I As Integer
    For I = 0 To UBound(mvarAdmins)
        If StringComp(sUser, mvarAdmins(I).Name) Then
            If mvarAdmins(I).RoomCreator Then Exit Function
        End If
    Next
    For I = 1 To UBound(UserDat)
        If Not UserDat(I) Is Nothing Then
            If StringComp(sUser, UserDat(I).Nick) Then
                If UserDat(I).Admin > 0 Then Exit Function
            End If
        End If
    Next
    For I = 0 To UBound(mvarBans)
        If StringComp(Trim$(mvarBans(I).Name), Trim$(sUser)) Then mvarBans(I).Expire = dTime: Exit Function ': GoTo Out
    Next
    For I = 0 To UBound(mvarBans) + 1
        If I > UBound(mvarBans) Then ReDim Preserve mvarBans(I)
        If IsEmptyString(Trim$(mvarBans(I).Name)) Then
            mvarBans(I).Name = sUser
            mvarBans(I).Expire = dTime
            mvarBans(I).ByWhom = sWho
            Exit For
        End If
    Next
    mvarBan = True
'Out:
'    Open AppPath & "bans_" & mvarRoomIndex & ".dat" For Binary Access Write As #1
'    Put #1, , mvarBans()
'    Close #1
End Function

Private Sub Class_Initialize()
    ReDim mvarAdmins(0)
    ReDim mvarBans(0)
    ReDim mvarGags(0)
End Sub






'---------------------------------------------------------------------------------------------------------------------
'Publicly accessible functions and subroutines. NOT to be
'changed unless you want to change the entire program!

Public Function Gag(sUser As String, dTime As Date, sWho As String) As Boolean
    'The publicly accessible gag function;
    'designed to be indirect access to the gag code
    Gag = mvarGag(sUser, dTime, sWho)
End Function

Public Function Ban(sUser As String, dTime As Date, sWho As String) As Boolean
    'The publicly accessible ban function;
    'designed to be indirect access to the ban code
    Ban = mvarBan(sUser, dTime, sWho)
End Function

Public Function Promote(sUser As String, Optional Protected As Boolean = False) As Boolean
    'The publicly accessible promotion function;
    'designed to be indirect access to the promotion code
    Promote = mvarPromote(sUser, Protected)
End Function

Public Function Demote(sUser As String) As Boolean
    'The publicly accessible demotion function;
    'designed to be indirect access to the demotion code
    Demote = mvarDemote(sUser)
End Function

Public Sub Cleanup()
    'The publicly accessible cleanup function;
    'designed to be indirect access to the cleanup code
    mvarCleanup
End Sub

Public Function IsBanned(UserName As String) As Boolean
    IsBanned = mvarIsBanned(UserName)
End Function

Public Function IsGagged(UserName As String) As Boolean
    IsGagged = mvarIsGagged(UserName)
End Function

Public Function IsAdmin(UserName As String) As Boolean
    IsAdmin = mvarIsAdmin(UserName)
End Function

Public Property Let RoomName(ByVal vData As String)
    mvarRoomName = vData
End Property

Public Property Get RoomName() As String
    RoomName = mvarRoomName
End Property

Public Property Let Locked(ByVal vData As Boolean)
    mvarLocked = vData
End Property

Public Property Get Locked() As Boolean
    Locked = mvarLocked
End Property

Public Property Let Moderated(ByVal vData As Boolean)
    mvarModerated = vData
End Property

Public Property Get Moderated() As Boolean
    Moderated = mvarModerated
End Property

Public Property Let RoomIndex(ByVal vData As Integer)
    mvarRoomIndex = vData
End Property

Public Property Get RoomIndex() As Integer
    RoomIndex = mvarRoomIndex
End Property
