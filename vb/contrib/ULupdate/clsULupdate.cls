VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsULupdate"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Public SoftwareTitle As String
Public PresentVersion As String
Private UpdateURL() As String
Private UpdateDL() As String
Private WithEvents Main As frmMain
Attribute Main.VB_VarHelpID = -1
Private WithEvents Error As frmError
Attribute Error.VB_VarHelpID = -1
Private WithEvents CriticalError As frmCriticalError
Attribute CriticalError.VB_VarHelpID = -1
Private Objects As New frmObjects
Public Event UnloadAll()

Public Sub AddUpdateURL(URL As String)
    ReDim Preserve UpdateURL(UBound(UpdateURL) + 1)
    UpdateURL(UBound(UpdateURL)) = URL
End Sub

Public Function ForceUpdateDL(Location As String)
    ReDim UpdateDL(0)
    UpdateDL(0) = Location
    ShowUpdatePopup True
End Function

Public Function CheckForUpdate()
    'On Error GoTo errors
    Dim UpdateData As String
    Load Objects
    With Objects.Inet
        For I = 1 To UBound(UpdateURL)
            UpdateData = LCase$(.OpenURL(UpdateURL(I)))
            Do While .StillExecuting = True
                DoEvents
            Loop
            If LenB(UpdateData) > 5 Then GoTo nextpiece
        Next
        If LenB(UpdateData) <= 5 Then GoTo errors
nextpiece:
        Dim A
        Dim B
        Dim C
        Dim Ver As String
        A = DSplit(UpdateData, "<title>", "</title>")
        If A(0) = "ulupdate" Then
            B = DSplit(A(1), "<body>", "</body>")
            C = Split(B(0), "<br>")
            Ver = C(1) & "." & C(2) & "." & C(3)
            If Ver <> PresentVersion Then
                If TestifNew(PresentVersion, Ver) = True Then
                    For I = 4 To UBound(C)
                        ReDim Preserve UpdateDL(I - 4)
                        UpdateDL(I - 4) = C(I)
                    Next
                    ShowUpdatePopup False
                End If
            End If
        End If
    End With
    Exit Function
errors:
    ShowErrorPopup "Either your connection to the internet is invalid or the update server is not online at the moment. Unable to check for new updates."
End Function

Function TestifNew(ByVal VersionNow As String, ByVal VersionCurrent As String) As Boolean
    Dim v1
    v1 = Split(VersionNow, ".")
    Dim v2
    v2 = Split(VersionCurrent, ".")
    If CInt(v1(0)) < CInt(v2(0)) Then
        TestifNew = True
        GoTo ReRoute
    ElseIf CInt(v1(0)) = CInt(v2(0)) Then
        If CInt(v1(1)) < CInt(v2(1)) Then
            TestifNew = True
            GoTo ReRoute
        ElseIf CInt(v1(1)) = CInt(v2(1)) Then
            If CInt(v1(2)) < CInt(v2(2)) Then
                TestifNew = True
                GoTo ReRoute
            End If
        End If
    End If
BeRoute:
    TestifNew = False
ReRoute:
End Function

Public Sub ShowUpdatePopup(Forced As Boolean)
    Set Main = New frmMain
    Load Main
    With Main
        .lblSpecifics.Caption = "An update for " & SoftwareTitle & " is available." & vbCrLf & "Would you like to download it now?"
        'ReDim modGeneral.DLFile(UBound(UpdateDL))
        modGeneral.DLFile = UpdateDL
        SetWindowPos .hwnd, conHwndTopmost, .Left / 15, .Top / 15, .Width / 15, .Height / 15, conSwpNoActivate Or conSwpShowWindow
        .Show
        If Forced = True Then
            .Forced = True
            .cmdYes_Click
            .cmdYes.Visible = False
            .cmdNo.Visible = False
        End If
    End With
End Sub

Public Sub ShowErrorPopup(Text As String)
    Set Main = New frmMain
    Load Main
    With Main
        .lblSpecifics.Caption = "The automatic update system failed to check for updates. This probably means the update server is down. To make sure you have the latest version, periodically download from the website."
        SetWindowPos .hwnd, conHwndTopmost, .Left / 15, .Top / 15, .Width / 15, .Height / 15, conSwpNoActivate Or conSwpShowWindow
        .Forced = True
        .cmdYes.Visible = False
        .cmdNo.Visible = False
        .tmrUnload.Interval = 5000
        .tmrUnload.Enabled = True
        .Show
    End With
End Sub

Private Sub Class_Initialize()
    ReDim UpdateDL(0)
    ReDim UpdateURL(0)
    ReDim modGeneral.DLFile(0)
End Sub

Private Sub Main_UnloadSystem()
    RaiseEvent UnloadAll
End Sub

Private Sub Error_UnloadSystem()
    RaiseEvent UnloadAll
End Sub

Private Sub CriticalError_UnloadSystem()
    RaiseEvent UnloadAll
End Sub

Public Function RaiseError(Caption As String)
    Set Error = New frmError
    Error.Show
    Error.lblErrorMessage = Caption
    Do While Error.Visible = True
        DoEvents
    Loop
    RaiseError = 0
End Function

Public Function RaiseCritical(Caption As String)
    Set CriticalError = New frmCriticalError
    CriticalError.Show
    CriticalError.lblErrorMessage = Caption
    Do While CriticalError.Visible = True
        DoEvents
    Loop
    RaiseCritical = 0
End Function
