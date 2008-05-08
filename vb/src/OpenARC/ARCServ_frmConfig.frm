VERSION 5.00
Begin VB.Form frmConfig 
   BorderStyle     =   1  'Fixed Single
   ClientHeight    =   5295
   ClientLeft      =   45
   ClientTop       =   735
   ClientWidth     =   4455
   Icon            =   "ARCServ_frmConfig.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5295
   ScaleWidth      =   4455
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton cmdBrowse 
      Caption         =   "Browse"
      Height          =   285
      Left            =   3360
      TabIndex        =   43
      Top             =   840
      Width           =   855
   End
   Begin VB.CheckBox OptCfg 
      Alignment       =   1  'Right Justify
      Caption         =   "CS Mode"
      Height          =   255
      Index           =   6
      Left            =   1770
      TabIndex        =   17
      ToolTipText     =   "Counter-Strike mode. Allows players to select their team."
      Top             =   3960
      Width           =   1000
   End
   Begin VB.TextBox txtcfg 
      Height          =   285
      IMEMode         =   3  'DISABLE
      Index           =   9
      Left            =   1320
      MaxLength       =   80
      TabIndex        =   3
      ToolTipText     =   "If you want a message of the day, type it here. If not, you may leave it blank."
      Top             =   1560
      Width           =   2895
   End
   Begin VB.TextBox Text5 
      Height          =   285
      Left            =   3120
      TabIndex        =   5
      Text            =   "0"
      ToolTipText     =   "If you want to host a deathmatch, enter the kill limit here."
      Top             =   1920
      Width           =   375
   End
   Begin VB.CheckBox OptCfg 
      Alignment       =   1  'Right Justify
      Caption         =   "Mines"
      Height          =   255
      Index           =   0
      Left            =   720
      TabIndex        =   16
      Top             =   3960
      Width           =   855
   End
   Begin VB.TextBox txtcfg 
      Height          =   285
      Index           =   6
      Left            =   3435
      TabIndex        =   22
      Text            =   "22100"
      Top             =   120
      Width           =   780
   End
   Begin VB.TextBox txtcfg 
      Height          =   285
      Index           =   3
      Left            =   1320
      TabIndex        =   21
      Text            =   "22000"
      Top             =   120
      Width           =   855
   End
   Begin VB.CheckBox Check1 
      Alignment       =   1  'Right Justify
      Caption         =   "UniBall"
      Height          =   255
      Left            =   720
      TabIndex        =   19
      ToolTipText     =   "Flags are replaced with Balls that you shoot into flag holders."
      Top             =   4320
      Width           =   855
   End
   Begin VB.TextBox Text3 
      Height          =   285
      Left            =   3120
      TabIndex        =   7
      Text            =   "0"
      ToolTipText     =   "If you want the round to be timed, enter the time limit here."
      Top             =   2280
      Width           =   375
   End
   Begin VB.TextBox Text2 
      Height          =   285
      Left            =   3120
      TabIndex        =   9
      Text            =   "0"
      Top             =   2640
      Width           =   375
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Left            =   240
      TabIndex        =   20
      Top             =   4920
      Width           =   3975
   End
   Begin VB.ComboBox Combo3 
      Appearance      =   0  'Flat
      Height          =   315
      ItemData        =   "ARCServ_frmConfig.frx":1042
      Left            =   3120
      List            =   "ARCServ_frmConfig.frx":1055
      Style           =   2  'Dropdown List
      TabIndex        =   12
      Top             =   3240
      Width           =   1095
   End
   Begin VB.ComboBox Combo2 
      Appearance      =   0  'Flat
      Height          =   315
      ItemData        =   "ARCServ_frmConfig.frx":1081
      Left            =   1800
      List            =   "ARCServ_frmConfig.frx":1094
      Style           =   2  'Dropdown List
      TabIndex        =   11
      Top             =   3240
      Width           =   1095
   End
   Begin VB.CheckBox OptCfg 
      Alignment       =   1  'Right Justify
      Caption         =   "Powerups"
      Height          =   255
      Index           =   5
      Left            =   3000
      TabIndex        =   18
      Top             =   3960
      Width           =   1095
   End
   Begin VB.TextBox txtcfg 
      Height          =   285
      Index           =   8
      Left            =   1320
      MaxLength       =   3
      TabIndex        =   8
      Text            =   "10"
      Top             =   2640
      Width           =   375
   End
   Begin VB.TextBox txtcfg 
      Height          =   285
      Index           =   5
      Left            =   1320
      MaxLength       =   3
      TabIndex        =   6
      Text            =   "1"
      Top             =   2280
      Width           =   375
   End
   Begin VB.ComboBox Combo1 
      Appearance      =   0  'Flat
      Height          =   315
      ItemData        =   "ARCServ_frmConfig.frx":10C0
      Left            =   480
      List            =   "ARCServ_frmConfig.frx":10D3
      Style           =   2  'Dropdown List
      TabIndex        =   10
      Top             =   3240
      Width           =   1095
   End
   Begin VB.TextBox txtcfg 
      Height          =   285
      Index           =   4
      Left            =   1320
      MaxLength       =   3
      TabIndex        =   4
      Text            =   "130"
      Top             =   1920
      Width           =   375
   End
   Begin VB.TextBox txtcfg 
      Height          =   285
      IMEMode         =   3  'DISABLE
      Index           =   2
      Left            =   1320
      MaxLength       =   15
      PasswordChar    =   "*"
      TabIndex        =   2
      ToolTipText     =   "Leave this blank if you don't want your server to be password protected."
      Top             =   1200
      Width           =   2895
   End
   Begin VB.CheckBox OptCfg 
      Alignment       =   1  'Right Justify
      Caption         =   "Bouncies"
      Height          =   255
      Index           =   4
      Left            =   3000
      TabIndex        =   15
      Top             =   3600
      Value           =   1  'Checked
      Width           =   1095
   End
   Begin VB.CheckBox OptCfg 
      Alignment       =   1  'Right Justify
      Caption         =   "Grenades"
      Height          =   255
      Index           =   3
      Left            =   1770
      TabIndex        =   14
      Top             =   3600
      Value           =   1  'Checked
      Width           =   1000
   End
   Begin VB.CheckBox OptCfg 
      Alignment       =   1  'Right Justify
      Caption         =   "Missiles"
      Height          =   255
      Index           =   2
      Left            =   720
      TabIndex        =   13
      Top             =   3600
      Value           =   1  'Checked
      Width           =   855
   End
   Begin VB.TextBox txtcfg 
      Height          =   285
      Index           =   1
      Left            =   1320
      Locked          =   -1  'True
      TabIndex        =   1
      ToolTipText     =   "On the right, click Browse to select a map."
      Top             =   840
      Width           =   1935
   End
   Begin VB.TextBox txtcfg 
      Height          =   285
      Index           =   0
      Left            =   1320
      MaxLength       =   50
      TabIndex        =   0
      ToolTipText     =   "Enter the name for your server, as you want it to appear in the Cobalt lobby."
      Top             =   480
      Width           =   2895
   End
   Begin VB.Label Label3 
      Alignment       =   2  'Center
      Caption         =   "Administrator list. Separate names with a comma."
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   -1  'True
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   240
      TabIndex        =   42
      Top             =   4680
      Width           =   3975
   End
   Begin VB.Label Label21 
      Alignment       =   1  'Right Justify
      Caption         =   "MOTD:"
      Height          =   255
      Left            =   120
      TabIndex        =   41
      Top             =   1560
      Width           =   1095
   End
   Begin VB.Label Label20 
      Caption         =   "frags."
      Height          =   255
      Left            =   3600
      TabIndex        =   40
      Top             =   1920
      Width           =   615
   End
   Begin VB.Label Label17 
      Alignment       =   1  'Right Justify
      Caption         =   "Deathmatch:"
      Height          =   255
      Left            =   2040
      TabIndex        =   39
      Top             =   1920
      Width           =   975
   End
   Begin VB.Label Label8 
      Caption         =   "Ping:"
      Height          =   255
      Left            =   3000
      TabIndex        =   38
      Top             =   120
      Width           =   375
   End
   Begin VB.Label Label13 
      Caption         =   "TCP/UDP:"
      Height          =   255
      Left            =   435
      TabIndex        =   37
      ToolTipText     =   "Port TCP Out/In. Port UDP Out."
      Top             =   120
      Width           =   855
   End
   Begin VB.Label Label7 
      Caption         =   "minutes."
      Height          =   255
      Left            =   3600
      TabIndex        =   36
      Top             =   2280
      Width           =   615
   End
   Begin VB.Label Label6 
      Alignment       =   1  'Right Justify
      Caption         =   "Time Limit:"
      Height          =   255
      Left            =   1920
      TabIndex        =   35
      Top             =   2280
      Width           =   1095
   End
   Begin VB.Label Label5 
      Caption         =   "minutes."
      Height          =   255
      Left            =   3600
      TabIndex        =   34
      Top             =   2640
      Width           =   615
   End
   Begin VB.Label Label4 
      Alignment       =   1  'Right Justify
      Caption         =   "Idle time:"
      Height          =   255
      Left            =   2040
      TabIndex        =   33
      Top             =   2640
      Width           =   975
   End
   Begin VB.Label Label19 
      Caption         =   "Recharge Rate"
      Height          =   255
      Left            =   3120
      TabIndex        =   32
      Top             =   3000
      Width           =   1095
   End
   Begin VB.Label Label18 
      Caption         =   "Special Damage"
      Height          =   255
      Left            =   1800
      TabIndex        =   31
      Top             =   3000
      Width           =   1215
   End
   Begin VB.Label Label16 
      Caption         =   "ms."
      Height          =   255
      Left            =   1725
      TabIndex        =   30
      Top             =   1920
      Width           =   255
   End
   Begin VB.Label Label15 
      Alignment       =   1  'Right Justify
      Caption         =   "Max Players:"
      Height          =   255
      Left            =   120
      TabIndex        =   29
      Top             =   2640
      Width           =   1095
   End
   Begin VB.Label Label12 
      Alignment       =   1  'Right Justify
      Caption         =   "Password:"
      Height          =   255
      Left            =   120
      TabIndex        =   28
      Top             =   1200
      Width           =   1095
   End
   Begin VB.Label Label11 
      Alignment       =   1  'Right Justify
      Caption         =   "Game Sync:"
      Height          =   255
      Left            =   120
      TabIndex        =   27
      Top             =   1920
      Width           =   1095
   End
   Begin VB.Label Label10 
      Alignment       =   2  'Center
      Caption         =   "Laser Damage"
      Height          =   255
      Left            =   480
      TabIndex        =   26
      Top             =   3000
      Width           =   1095
   End
   Begin VB.Label Label9 
      Alignment       =   1  'Right Justify
      Caption         =   "Holding time:"
      Height          =   255
      Left            =   120
      TabIndex        =   25
      Top             =   2280
      Width           =   1095
   End
   Begin VB.Label Label2 
      Alignment       =   1  'Right Justify
      Caption         =   "Map:"
      ForeColor       =   &H00000000&
      Height          =   255
      Left            =   120
      TabIndex        =   24
      Top             =   840
      Width           =   1095
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "Server Name:"
      Height          =   255
      Left            =   120
      TabIndex        =   23
      Top             =   480
      Width           =   1095
   End
   Begin VB.Menu file 
      Caption         =   "&File"
      Begin VB.Menu new 
         Caption         =   "&New"
      End
      Begin VB.Menu open 
         Caption         =   "&Open"
      End
      Begin VB.Menu save 
         Caption         =   "&Save"
      End
      Begin VB.Menu div 
         Caption         =   "-"
      End
      Begin VB.Menu exit 
         Caption         =   "E&xit"
      End
   End
End
Attribute VB_Name = "frmConfig"
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
Private ConfigFail As Boolean
Option Compare Text

Private Sub BallOption_Click(Index As Integer)
    g_UniBall = Index + 1
    If Index = 0 Then Text3 = "3"
    If Index = 1 Then Text3 = "0"
End Sub

Private Sub Check1_Click()
    g_UniBall = Check1.Value
End Sub

Private Sub Check2_Click()
    g_SmashARC = Check1.Value
End Sub

Private Sub cmdBrowse_Click()
    frmMaps.Show 1
    txtcfg(1) = MapPlay
    If HData.FormatID <> 17016 Then MsgBox "Not a valid Cobalt Game map!", vbCritical, "Error": Exit Sub
    txtcfg(5) = HData.HoldingTime
    txtcfg(8) = HData.MaxPlayers
    Combo1.ListIndex = HData.LaserDamage
    Combo2.ListIndex = HData.SpecialDamage
    Combo3.ListIndex = HData.Recharge
    OptCfg(2).Value = HData.MissEnabled
    OptCfg(3).Value = HData.MortEnabled
    OptCfg(4).Value = HData.BouncyEnabled
    OptCfg(5).Value = CInt(CBool(HData.PowerupPosCount)) * -1
    OptCfg(6).Value = CInt(g_CStrike) * -1
    If HData.PowerupPosCount = 0 Then OptCfg(5).Enabled = False Else OptCfg(5).Enabled = True
End Sub

Private Sub exit_Click()
    Unload Me
End Sub

Private Sub Form_Load()
    Dim I As Integer
    Me.Caption = ProjectName & " Game Server - Configuration"
    Combo1.ListIndex = 0
    txtcfg(0) = g_ServerName
    txtcfg(1) = MapPlay
    txtcfg(2) = g_Password
    txtcfg(5) = g_HoldTime
    txtcfg(8) = g_MaxPlayers
    txtcfg(3) = Port
    txtcfg(6) = Port2
    If g_MOTD <> "" Then
        txtcfg(9) = g_MOTD
        Else
        txtcfg(9) = "Welcome to " & ProjectName & "."
    End If
    Combo1.ListIndex = g_LaserDamage
    Combo2.ListIndex = g_SpecialDamage
    Combo3.ListIndex = g_RechargeRate
    OptCfg(0).Value = Sgn(g_Mines)
    OptCfg(2).Value = Sgn(g_Missiles)
    OptCfg(3).Value = Sgn(g_Grenades)
    OptCfg(4).Value = Sgn(g_Bouncies)
    OptCfg(5).Value = g_PowerUps
    OptCfg(6).Value = g_CStrike * -1
    If g_UniBall > 0 Then Check1.Value = 1
    Text3 = g_TimeLimit
    Text5 = g_DeathMatch
    For I = 0 To UBound(AdminList)
        If AdminList(I) <> "" Then
            Text1 = Text1 & AdminList(I)
            If I < UBound(AdminList) Then Text1 = Text1 & ","
        End If
    Next
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    Dim L As Long, I As Integer, j As Integer, j2 As Integer
    If UnloadMode = 5 Then Exit Sub
    If ConfigFail Then Exit Sub
    If Command$ = vbNullString Then
        L = MsgBox("Enable changes?", vbYesNoCancel + vbExclamation, App.Title)
        If L = vbNo Then Exit Sub
        If L = vbCancel Then
            Cancel = 1
            Exit Sub
        End If
    End If
    Dim g_Difficulty As Long
    If LenB(Trim$(txtcfg(0))) = 0 And Not LANBuild And Not PeerBuild Then MsgBox "You need a server name.", vbExclamation, App.Title: Cancel = 1: Exit Sub
    If LenB(Trim$(txtcfg(1))) = 0 Then MsgBox "You need to select a map!", vbExclamation, App.Title: Cancel = 1: Exit Sub
    If LenB(Trim$(txtcfg(4))) = 0 Then MsgBox "You need to set the asynchronous update speed in timeout. Lower the value the more real time, however more bandwidth usage.", vbExclamation, App.Title: Cancel = 1: Exit Sub
    If CInt(txtcfg(8)) < 1 Then MsgBox "Max Players must be greater than 0.", vbExclamation, App.Title: Cancel = 1: Exit Sub
    If CInt(txtcfg(8)) > 255 Then MsgBox "Max Players must be less than 255.", vbExclamation, App.Title: Cancel = 1: Exit Sub
    g_ServerName = txtcfg(0)
    MapPlay = txtcfg(1)
    Filename = AppPath & "maps\" & MapPlay
    g_Password = txtcfg(2)
    g_DeathMatch = CByte(Text5)
    g_MOTD = txtcfg(9)
    If CInt(txtcfg(5)) > 255 Then txtcfg(5) = 255
    g_HoldTime = CByte(txtcfg(5))
    g_IdleTime = CSng(Text2)
    g_LaserDamage = Combo1.ListIndex
    g_SpecialDamage = Combo2.ListIndex
    g_RechargeRate = Combo3.ListIndex
    g_FlagReturn = 1
    g_Mines = OptCfg(0).Value * (g_Difficulty + 1)
    g_Missiles = OptCfg(2).Value * (g_Difficulty + 1)
    g_Grenades = OptCfg(3).Value * (g_Difficulty + 2)
    g_Bouncies = OptCfg(4).Value * (g_Difficulty + 3)
    g_PowerUps = OptCfg(5).Value
    g_CStrike = OptCfg(6).Value
    g_MaxPlayers = txtcfg(8)
    g_TimeLimit = Text3
    Port = CInt(txtcfg(3))
    Port2 = CInt(txtcfg(6))
    Port3 = Port + 5
    GameDescription.tDeathmatch = CBool(g_DeathMatch)
    GameDescription.tMissiles = g_Missiles
    GameDescription.tBombs = g_Grenades
    GameDescription.tBouncies = g_Bouncies
    GameDescription.tMines = g_Mines
    GameDescription.tFlagreturn = g_FlagReturn
    GameDescription.tMaxplayers = g_MaxPlayers
    GameDescription.tPowerups = g_PowerUps
    GameDescription.tLaserdamage = g_LaserDamage
    GameDescription.tSpecialdamage = g_SpecialDamage
    GameDescription.tRechargerate = g_RechargeRate
    GameDescription.tTimeLimit = g_TimeLimit
    GameDescription.tHoldtime = g_HoldTime
    On Error GoTo Errs
    If Text1 <> "" Then
        j = InStr(1, Text1, ",") - 1
        AdminList(UBound(AdminList)) = Trim$(Mid$(Text1, 1, j))
        j2 = 0
        Do
            ReDim Preserve AdminList(UBound(AdminList) + 1)
            j = InStr(j2 + 1, Text1, ",") + 1
            If j = 0 Then Exit Do
            j2 = InStr(j, Text1, ",") - 1
            If j2 = -1 Then Exit Do
            AdminList(UBound(AdminList)) = Trim$(Mid$(Text1, j, (j2 - 1) - j + 2))
        Loop
        AdminList(UBound(AdminList)) = Trim$(Mid$(Text1, j))
    End If
    Exit Sub
Errs:
    MsgBox "The admins you entered are not seperated by a comma ex:" & vbNewLine & vbNewLine & "Admin1,Admin2," & vbNewLine & vbNewLine & "Even if theres only one admin you need to have a comma after it.", vbExclamation, App.Title
    Cancel = 1
End Sub


Private Sub open_Click()
    Dim s As String
    s = OpenDialog(Me, "(Server Config)|*.conf", "Open Config", AppPath)
    LoadConfig s
End Sub

Private Function FileExists(Path As String) As Boolean
    On Error GoTo errors
    If FileLen(Path) > 0 Then FileExists = True
errors:
End Function

Public Sub LoadConfig(s As String)
    On Error GoTo errors
1:  If LenB(Trim$(s)) = 0 Or Not FileExists(s) Then GoTo nonexistent
2:    If Mid$(s, 2, 1) <> ":" And Mid$(s, 3, 1) <> ":" Then
3:      If left$(s, 1) <> "\" And left$(s, 1) <> "/" Then
4:          s = App.Path & "\" & s
5:          Else
6:          s = App.Path & s
7:      End If
8:  End If
9:  txtcfg(0) = readini("Server", "ServerName", s)
10: txtcfg(1) = readini("Server", "Map", s)
11: MapPlay = txtcfg(1)
12: If IsNumeric(readini("Server", "HoldTime", s)) Then txtcfg(5) = CInt(readini("Server", "HoldTime", s))
13: txtcfg(9) = readini("Server", "MOTD", s)
14: If CInt(readini("Server", "Port", s)) > 0 Then txtcfg(3) = CInt(readini("Server", "Port", s))
15: If CInt(readini("Server", "Port2", s)) > 0 Then txtcfg(6) = CInt(readini("Server", "Port2", s))
16: If IsNumeric(readini("Server", "IdleTime", s)) Then Text2 = CInt(readini("Server", "IdleTime", s))
17: txtcfg(8) = readini("Server", "MaxPlayers", s)
18: Combo1.ListIndex = CInt(readini("Server", "LaserDamage", s))
19: Combo2.ListIndex = CInt(readini("Server", "SpecialDamage", s))
20: Combo3.ListIndex = CInt(readini("Server", "RechargeRate", s))
21: OptCfg(0).Value = CInt(readini("Server", "Mines", s))
22: OptCfg(2).Value = CInt(readini("Server", "Missiles", s))
23: OptCfg(3).Value = CInt(readini("Server", "Grenades", s))
24: OptCfg(4).Value = CInt(readini("Server", "Bouncies", s))
25: OptCfg(5).Value = CInt(readini("Server", "Pups", s))
26: OptCfg(6).Value = CInt(readini("Server", "CSMode", s))
27: Text1 = readini("Server", "Admins", s)
28: g_UniBall = CByte(readini("Server", "UniBall", s))
29: Check1.Value = Sgn(g_UniBall)
30: Text3 = CStr(readini("Server", "TimeLimit", s))
31: Text5 = CStr(readini("Server", "DeathMatch", s))
    Exit Sub
nonexistent:
    MsgBox "Your config file is corrupt or missing.", vbExclamation, ProjectName
    ConfigFail = True
    Exit Sub
errors:
    MsgBox "LoadConfig has encountered an error with your configuration file. (frmConfig.frm, Line #" & Erl & ")", vbExclamation, ProjectName
    ConfigFail = True
End Sub

Private Sub save_Click()
    Dim s As String
    s = SaveDialog(Me, "(Server Config)|*.conf", "Save Config", AppPath)
    If LenB(Trim$(s)) = 0 Then Exit Sub
    Call writeini("Server", "ServerName", txtcfg(0), s)
    Call writeini("Server", "Map", txtcfg(1), s)
    Call writeini("Server", "MaxPlayers", txtcfg(8), s)
    Call writeini("Server", "HoldTime", txtcfg(5), s)
    Call writeini("Server", "MOTD", txtcfg(9), s)
    Call writeini("Server", "IdleTime", Text2, s)
    Call writeini("Server", "TimeLimit", Text3, s)
    Call writeini("Server", "DeathMatch", Text5, s)
    Call writeini("Server", "LaserDamage", Combo1.ListIndex, s)
    Call writeini("Server", "SpecialDamage", Combo2.ListIndex, s)
    Call writeini("Server", "RechargeRate", Combo3.ListIndex, s)
    Call writeini("Server", "Mines", OptCfg(0).Value, s)
    Call writeini("Server", "Missiles", OptCfg(2).Value, s)
    Call writeini("Server", "Grenades", OptCfg(3).Value, s)
    Call writeini("Server", "Bouncies", OptCfg(4).Value, s)
    Call writeini("Server", "Pups", OptCfg(5).Value, s)
    Call writeini("Server", "CSMode", OptCfg(6).Value, s)
    Call writeini("Server", "Admins", Text1, s)
    Call writeini("Server", "UniBall", g_UniBall, s)
    Call writeini("Server", "Port", txtcfg(3), s)
    Call writeini("Server", "Port2", txtcfg(6), s)
End Sub

Private Sub Text5_Change()
    If Not IsNumeric(Text5) Then Exit Sub
    If CInt(Text5) > 254 Then Text5 = "254"
End Sub

Private Sub TxtCfg_Change(Index As Integer)
    If Index = 3 Then txtcfg(6) = txtcfg(Index) + 100
End Sub

Private Sub txtcfg_GotFocus(Index As Integer)
    If Index = 1 Then
        cmdBrowse.Default = True
    End If
End Sub

Private Sub txtcfg_LostFocus(Index As Integer)
    If Index = 1 Then
        cmdBrowse.Default = False
    End If
End Sub
