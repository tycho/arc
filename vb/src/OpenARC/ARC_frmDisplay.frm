VERSION 5.00
Begin VB.Form frmDisplay 
   BackColor       =   &H00000000&
   BorderStyle     =   0  'None
   Caption         =   "OpenARC"
   ClientHeight    =   7200
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   9600
   ClipControls    =   0   'False
   ControlBox      =   0   'False
   ForeColor       =   &H00FFFFFF&
   Icon            =   "ARC_frmDisplay.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   480
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   640
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Visible         =   0   'False
   Begin VB.Timer tmrAdbanner 
      Enabled         =   0   'False
      Interval        =   5000
      Left            =   1080
      Top             =   360
   End
   Begin VB.Timer Timer2 
      Enabled         =   0   'False
      Interval        =   1
      Left            =   120
      Top             =   360
   End
   Begin VB.Timer Timer1 
      Enabled         =   0   'False
      Interval        =   1
      Left            =   600
      Top             =   360
   End
End
Attribute VB_Name = "frmDisplay"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
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
Public ChatP As Long
Public HasFocus As Boolean
Implements DirectXEvent

Public Sub SetSystemCursor()
    Dim point As POINTAPI
    
    point.X = g_cursorx
    point.y = g_cursory
    Call ClientToScreen(hwnd, point)
    Call SetCursorPos(point.X, point.y)
End Sub

Private Sub DirectXEvent_DXCallback(ByVal eventid As Long)
    Dim NumItems As Integer, i As Integer
    Dim mousevalue As Long
    Dim diDeviceData(1 To 10) As DIDEVICEOBJECTDATA
    Dim lx As Integer, ly As Integer
    If Not Playing Then Exit Sub
    On Error GoTo INPUTLOST
    NumItems = DirectInput_DevM.GetDeviceData(diDeviceData, 0)
    For i = 1 To NumItems
        Select Case diDeviceData(i).lOfs
        Case DIMOFS_X
            If CursSpeed >= 0 Then
                g_cursorx = g_cursorx + diDeviceData(i).lData * CursSpeed  '(1.5)
            Else
                g_cursorx = g_cursorx - diDeviceData(i).lData * CursSpeed  '(1.5)
            End If
            GoTo out
        Case DIMOFS_Y
            If (1 + CursSpeed * 0.1) >= 0 Then
                g_cursory = g_cursory + diDeviceData(i).lData * CursSpeed  '(1.5)
            Else
                g_cursory = g_cursory - diDeviceData(i).lData * CursSpeed  '(1.5)
            End If
            GoTo out
        End Select
        lx = g_cursorx - Players(MeNum).MoveX
        ly = g_cursory - Players(MeNum).MoveY
        
        Select Case diDeviceData(i).lOfs
        Case DIMOFS_BUTTON0
            If diDeviceData(i).lData = 0 Then
                GoTo out
            End If
            If Pointer > 3 Then DoOption ' newCInt(g_cursorx), newCInt(g_cursory)
            If cfgm Then
                If cfgm2 Then
                    If Pointer < 4 Then FireLaser MeNum, lx, ly, newCInt(Players(MeNum).charX), newCInt(Players(MeNum).charY)
                Else
                    If Pointer < 4 Then
                        If Weapon = 1 Then
                            FireMiss MeNum, lx, ly, newCInt(Players(MeNum).charX), newCInt(Players(MeNum).charY)
                        ElseIf Weapon = 2 Then
                            FireMort MeNum, lx, ly, newCInt(Players(MeNum).charX), newCInt(Players(MeNum).charY)
                        ElseIf Weapon = 3 Then
                            FireBounce MeNum, lx, ly, newCInt(Players(MeNum).charX), newCInt(Players(MeNum).charY)
                        End If
                    End If
                End If
            Else
                If Pointer < 4 Then
                    FireLaser MeNum, lx, ly, newCInt(Players(MeNum).charX), newCInt(Players(MeNum).charY)
                End If
            End If
        Case DIMOFS_BUTTON1
            If diDeviceData(i).lData = 0 Then
                GoTo out
            End If
            If Not cfgm Then
                If Weapon = 1 Then
                    FireMiss MeNum, lx, ly, newCInt(Players(MeNum).charX), newCInt(Players(MeNum).charY)
                ElseIf Weapon = 2 Then
                    FireMort MeNum, lx, ly, newCInt(Players(MeNum).charX), newCInt(Players(MeNum).charY)
                ElseIf Weapon = 3 Then
                    FireBounce MeNum, lx, ly, newCInt(Players(MeNum).charX), newCInt(Players(MeNum).charY)
                End If
            Else
                If cfgm2 Then cfgm2 = False Else cfgm2 = True
            End If
        Case DIMOFS_Z
            If diDeviceData(i).lData = 120 Then
                Weapon = Weapon - 1
            Else
                Weapon = Weapon + 1
            End If
            If Weapon = 0 Then Weapon = 1
            If Weapon > 3 Then Weapon = Weapon - 1
            SpecialSnd CByte(Weapon)
        Case DIMOFS_BUTTON2
            If diDeviceData(i).lData = 0 Then GoTo out
            Weapon = 2
            SpecialSnd CByte(Weapon)
        End Select
        mousevalue = diDeviceData(i).lOfs
out:
    Next
    Exit Sub
INPUTLOST:
    If (Err.Number = DIERR_INPUTLOST) Or (Err.Number = DIERR_NOTACQUIRED) Then
        SetSystemCursor
        Exit Sub
    End If
End Sub

Private Sub Form_GotFocus()
    HasFocus = True
End Sub

Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
    If Shift > 0 Then Exit Sub
    If KeyCode > 47 And KeyCode < 58 Then
        If cfgk Then ChatQ = True
        If Not ChatQ Then Exit Sub
        TxtBuild = TxtBuild & Chr$(KeyCode)
    End If
End Sub

Private Sub Form_KeyPress(KeyAscii As Integer)
    If KeyAscii = 13 And MenuMenu = 4 Then Stopping = True
    If KeyAscii > 47 And KeyAscii < 58 Then KeyAscii = 0: Exit Sub
    If Not Playing Then
        If KeyAscii = 27 Then Stopping = True
        Exit Sub
    End If
    If Not cfgk Then
        If LCase$(Chr$(KeyAscii)) = "t" And Not ChatQ Then
            ChatQ = True
            KeyAscii = 0: Exit Sub
        End If
    Else
        ChatQ = True
    End If
    If Not ChatQ Then KeyAscii = 0: Exit Sub
    
    If KeyAscii = 96 Then
        If LenB(TxtBuild) = 0 Then '" ` " == 96
            GameChat Chr$(5) & "Weighted Ping: " & PingTime & "  Highest Ping: " & HighPing & "  Current FPS: " & FPSRec
            Exit Sub
        End If
    End If
    
    If KeyAscii = 13 Or Len(TxtBuild) > 150 Then
        ChatQ = False
        If Left$(TxtBuild, 1) = "/" Then
            If TxtBuild = "/?" Or LCase$(TxtBuild) = "/help" Then MenuMenu = 9: TxtBuild = vbNullString
            If TxtBuild = "/clear" Then
                ReDim Chat(7)
                KillChatLine
            End If
            If InStr(LCase$(TxtBuild), "/ignore") Then AddIgnore Mid$(TxtBuild, InStr(TxtBuild, " ") + 1)
            If InStr(LCase$(TxtBuild), "/unignore") Then RemoveIgnore Mid$(TxtBuild, InStr(TxtBuild, " ") + 1)
        End If
        
        If NewGTC - ChatP > 1000 Then
            ChatP = NewGTC
            If LenB(TxtBuild) > 0 Then Call sendmsg(MSG_GAMECHAT, TxtBuild)
            TxtBuild = vbNullString
            KeyAscii = 0
        End If
    Else
        If KeyAscii = 8 Then
            If LenB(TxtBuild) > 0 Then
                TxtBuild = Mid$(TxtBuild, 1, Len(TxtBuild) - 1): Exit Sub
            Else
                ChatQ = False
            End If
        End If
        If KeyAscii <> 8 And KeyAscii <> 9 And KeyAscii <> 27 Then TxtBuild = TxtBuild & Chr$(KeyAscii)
    End If
End Sub

Private Sub Form_Load()
    CenterX = ResX \ 2
    CenterY = ResY \ 2
    CenterSX = CenterX - 16
    CenterSY = CenterY - 16
    Stopping = False
    NavMenu = 1: MenuMenu = 0: ScoreView = False
    If Paletted Then
        NoD3D = True
        SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "NoD3D", 1
    End If
    EnableSound = CBool(GetSettingLong(HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "Sound", 1)) ' true
    cfgm = CBool(GetSettingLong(HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "Mouse"))  ' false
    cfgk = Not CBool(GetSettingLong(HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "Keyboard")) ' true
    cfgwv = Not CBool(GetSettingLong(HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "Voice", 0)) ' true
    ReDim FrameCount(255), AnimSpeed(255), AnimFrames(255, 0)
    ReDim AnimFX(255, 0), AnimFY(255, 0), AnimFS(255, 0)
    Me.Caption = ProjectName & " v" & App.Major & "." & Format$(App.Minor, "00") & "." & Format$(App.Revision, "0000")
    Me.Show
End Sub

Private Sub Form_LostFocus()
    HasFocus = False
End Sub

Private Sub Form_MouseMove(Button As Integer, Shift As Integer, X As Single, y As Single)
    If Stopping Or DirectInput_Dev Is Nothing Then Exit Sub
    Dim didevstate As DIMOUSESTATE
    On Error GoTo NOTYETACQUIRED
    Call DirectInput_DevM.GetDeviceStateMouse(didevstate)
    On Error GoTo 0
    Exit Sub
NOTYETACQUIRED:
    Call AcquireMouse
End Sub

Sub AcquireMouse()
    Dim CursorPoint As POINTAPI
    
    ' Move private cursor to system cursor.
    Call GetCursorPos(CursorPoint)  ' Get position before Windows loses cursor
    Call ScreenToClient(hwnd, CursorPoint)
    
    On Error GoTo CANNOTACQUIRE
    DirectInput_DevM.Acquire
    g_cursorx = CursorPoint.X
    g_cursory = CursorPoint.y
    
    On Error GoTo 0
    Exit Sub
    
CANNOTACQUIRE:
    Exit Sub
    
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    If Playing Then
        'SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "Sound", EnableSound * -1
        SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "Mouse", cfgm
        SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "Keyboard", Not cfgk
        SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "Voice", Not cfgwv
    End If
    frmDisplay.SetSystemCursor
    Call DirectDraw.SetCooperativeLevel(frmDisplay.hwnd, DDSCL_NORMAL)
    DoEvents
    Clean
End Sub

Private Sub Timer1_Timer()
    Timer1.Enabled = False
    Static StopRepeating As Boolean
    If Not Stopping Then
        If Not StopRepeating Then
            StopRepeating = True
            Dim lMsg As Byte
            Dim oNewMsg() As Byte, lNewOffSet As Long
            lNewOffSet = 0
            ReDim oNewMsg(0)
            lMsg = MSG_MAP
            AddBufferData oNewMsg, VarPtr(lMsg), LenB(lMsg), lNewOffSet
            SendTo oNewMsg, True
        End If
    Else
        On Error Resume Next
        Do While frmCriticalError.Visible Or frmError.Visible
            DoEvents
        Loop
        frmDisplay.Hide
        DoEvents
        Unload frmSplash
        Unload frmDisplay
        Unload frmMain
    End If
End Sub

Private Sub Timer2_Timer()
    QueryPerformanceFrequency curFreq
    QueryPerformanceCounter curStart
    Do While Not Stopping
        If PeekMessage(Message, 0, 0, 0, PM_NOREMOVE) Then        'checks for a message in the queue and removes it if there is one
           DoEvents
        End If
        MoveCalls
    Loop
    If StartLog Then
        StartupLog "-------------------------------"
        StartupLog "-    PROGRAM IS TERMINATING   -"
        StartupLog "-        (USER EXITED)        -"
        StartupLog "-------------------------------"
        StartupLog CalcTime(NewGTC - StartupTime) & " total running time."
    End If
    'Timer2.Enabled = False
End Sub

Private Sub tmrAdbanner_Timer()
    LoadBanner
End Sub
