VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Begin VB.Form frmSplash 
   BackColor       =   &H00000000&
   BorderStyle     =   1  'Fixed Single
   ClientHeight    =   90
   ClientLeft      =   15
   ClientTop       =   15
   ClientWidth     =   4770
   ControlBox      =   0   'False
   Icon            =   "Cobalt_frmSplash.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Picture         =   "Cobalt_frmSplash.frx":1042
   ScaleHeight     =   6
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   318
   StartUpPosition =   2  'CenterScreen
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   2160
      Top             =   0
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Timer tmrSize 
      Interval        =   1
      Left            =   0
      Top             =   0
   End
   Begin VB.Label lblDisclaimer 
      BackStyle       =   0  'Transparent
      Caption         =   $"Cobalt_frmSplash.frx":2FE84
      BeginProperty Font 
         Name            =   "Small Fonts"
         Size            =   5.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   615
      Left            =   240
      TabIndex        =   3
      Top             =   2640
      Width           =   4335
   End
   Begin VB.Label lblTrademarks 
      BackStyle       =   0  'Transparent
      Caption         =   $"Cobalt_frmSplash.frx":2FFA8
      BeginProperty Font 
         Name            =   "Small Fonts"
         Size            =   5.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   375
      Left            =   240
      TabIndex        =   2
      Top             =   3240
      Width           =   4335
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   14.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   375
      Left            =   120
      TabIndex        =   1
      Top             =   1920
      Width           =   4455
   End
   Begin VB.Label lblLoad 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Version 2.00.0000"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   2280
      Width           =   4455
   End
   Begin VB.Image Image1 
      Height          =   2250
      Left            =   0
      Picture         =   "Cobalt_frmSplash.frx":30054
      Top             =   120
      Width           =   4800
   End
End
Attribute VB_Name = "frmSplash"
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

Private TimerAction As Integer
Private LastHeight As Integer
Private Const GWL_EXSTYLE As Long = -20
Private Const WS_EX_APPWINDOW As Long = &H40000
Private Declare Function GetWindowLong Lib "user32.dll" Alias "GetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long) As Long
Private Declare Function SetWindowLong Lib "user32.dll" Alias "SetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
Private Declare Function SetWindowText Lib "user32.dll" Alias "SetWindowTextA" (ByVal hwnd As Long, ByVal lpString As String) As Long

Private Sub Form_Load()
    SetWindowText Me.hwnd, "cfront"
    MakeAlwaysOnTop Me, True
    lblLoad.Caption = "Version " & App.Major & "." & Format$(App.Minor, "0") & " build " & App.Revision
    Label1.Caption = "Beta"
    TimerAction = 0
    Me.Show
    Me.Refresh
End Sub

Private Sub tmrSize_Timer()
    If TimerAction = 1 Then
        Me.Height = Me.Height - 75
        Me.Move Me.Left, (Screen.Height \ 2 - (0.5 * Me.Height))
        If Me.Height = LastHeight Then
            frmLogin.Show
            Unload Me
        End If
        LastHeight = Me.Height
    Else
        If Me.Height >= 3750 Then
            tmrSize.Enabled = False
            Pause2 1000
            LoadLogin
            TimerAction = 1
        Else
            Me.Height = Me.Height + 75
            Me.Move Me.Left, (Screen.Height \ 2 - (0.5 * Me.Height))
        End If
    End If
End Sub

Public Sub LoadCap(sCaption As String)
    lblLoad = sCaption
End Sub

Private Sub LoadLogin()
    LoadCap "Initializing variables..."
    ReDim ServerDat(0), Muzzle(0), UserDat(0), svrPlayers(0), PagerMSG(0), Rooms(0)
    Set Rooms(0) = New clsChatRoom
    ReDim PagerMSG(0).PName(0)
    ReDim PagerMSG(0).Pages(0)
    FlashWindows = GetSettingLong(HKEY_CURRENT_USER, "SOFTWARE\Cobalt", "FlashWindows", -1)
    NoEnterLeave = GetSettingLong(HKEY_CURRENT_USER, "SOFTWARE\Cobalt", "NoEnterLeave")
    NoUpdate = GetSettingLong(HKEY_CURRENT_USER, "SOFTWARE\Cobalt", "NoUpdate")
    NoPager = GetSettingLong(HKEY_CURRENT_USER, "SOFTWARE\Cobalt", "NoPager")
    NoBadWords = GetSettingLong(HKEY_CURRENT_USER, "SOFTWARE\Cobalt", "NoBadWords")
    TimeStamp = GetSettingLong(HKEY_CURRENT_USER, "SOFTWARE\Cobalt", "TimeStamp")
    ShowUptime = GetSettingLong(HKEY_CURRENT_USER, "SOFTWARE\Cobalt", "ShowUptime")
    KeepAlive = GetSettingLong(HKEY_CURRENT_USER, "SOFTWARE\Cobalt", "KeepAlive")
    NoColor = GetSettingLong(HKEY_CURRENT_USER, "SOFTWARE\Cobalt", "NoColor")
    ColorCodes = GetSettingLong(HKEY_CURRENT_USER, "SOFTWARE\Cobalt", "ColorCodes")
    SysTray = GetSettingLong(HKEY_CURRENT_USER, "SOFTWARE\Cobalt", "SysTray")
    skins = GetSettingLong(HKEY_CURRENT_USER, "SOFTWARE\Cobalt", "Skin", 5)
    SoundDIR = GetSettingString(HKEY_CURRENT_USER, "SOFTWARE\Cobalt", "SoundDIR")
    If SoundDIR = vbNullString Then
        SoundDIR = AppPath & "sound\"
    End If
    ChatColor = GetSettingString(HKEY_CURRENT_USER, "SOFTWARE\Cobalt", "ChatColor")
    Set UserDat(0) = New clsUserData
    UserDat(0).Nick = "Cobalt"
    LoadCap "Checking for updates..."
    UniqueID = KeyGen(CalculateMD5(ReadRegistry(HKEY_LOCAL_MACHINE, "SOFTWARE\Microsoft\Windows\CurrentVersion", "ProductID")), EncPassword, 3)
    If Not NoUpdate Then
        Dim AU As prjUpdate.clsULupdate
        Set AU = New prjUpdate.clsULupdate
        With AU
            .SoftwareTitle = ProjectName
            .AddUpdateURL "http://openarc.sourceforge.net/update.htm"
            .PresentVersion = App.Major & "." & App.Minor & "." & App.Revision
            Dim Result
            Result = .CheckForUpdate
        End With
    End If
    LoadCap "Initializing encryption..."
    InitEncryption
    InitKeys
    LoadCap "Downloading server list..."
    Load frmLogin
End Sub

Private Sub Pause2(Interval As Long)
    Dim current As Long
    current = NewGTC
    Do While NewGTC - current < Interval
        DoEvents
    Loop
End Sub
