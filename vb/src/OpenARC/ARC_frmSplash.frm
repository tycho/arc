VERSION 5.00
Begin VB.Form frmSplash 
   Appearance      =   0  'Flat
   BackColor       =   &H80000005&
   BorderStyle     =   0  'None
   Caption         =   "Loading..."
   ClientHeight    =   1890
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   4125
   ControlBox      =   0   'False
   Icon            =   "ARC_frmSplash.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Picture         =   "ARC_frmSplash.frx":000C
   ScaleHeight     =   126
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   275
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Visible         =   0   'False
   Begin VB.Timer Timer1 
      Enabled         =   0   'False
      Interval        =   3
      Left            =   0
      Top             =   0
   End
   Begin VB.Label lblLoading 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   1560
      Width           =   3855
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

Dim m_TransparencyLevel As Integer
Dim m_TransparencyDirection As Integer

Private Sub Form_Load()
    MakeTransparent Me.hwnd, m_TransparencyLevel
    MakeAlwaysOnTop Me, True
    m_TransparencyLevel = 0
    m_TransparencyDirection = 3
    LoadSettings
End Sub

Private Sub Timer1_Timer()
    If m_TransparencyDirection <> 0 Then
        If MakeTransparent(Me.hwnd, m_TransparencyLevel) = 1 Then
            If m_TransparencyDirection < 0 Then Me.Visible = False
        End If
        m_TransparencyLevel = m_TransparencyLevel + m_TransparencyDirection
        If m_TransparencyLevel < Abs(m_TransparencyDirection) Then
            m_TransparencyDirection = 0
            m_TransparencyLevel = 0
            MakeTransparent Me.hwnd, m_TransparencyLevel
        End If
        If m_TransparencyLevel > (255 - Abs(m_TransparencyDirection)) Then
            m_TransparencyDirection = 0
            m_TransparencyLevel = 255
            SplashComplete
        End If
    End If
End Sub

Private Sub LoadSettings()
    CursSpeed = GetSettingLong(HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "cursspeed", 0)
    CursSpeed = (1 + CursSpeed * 0.1)
    EnableSound = CBool(GetSettingLong(HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "Sound", 1))
    NoD3D = GetSettingLong(HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "NoD3D", 0)
    Paletted = CBool(GetSettingLong(HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "8BitColor", 0))
    bDebugLog = CBool(GetSettingLong(HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "DebugLog", 0))
    NoFarplane = CBool(GetSettingLong(HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "NoFarplane", 0))
    NoBlending = CBool(GetSettingLong(HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "NoBlending", 0))
    LowMem = CBool(GetSettingLong(HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "LowMemory", 0))
    LowVRAM = CBool(GetSettingLong(HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "LowVRAM", 0))
    Windowed = CBool(GetSettingLong(HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "Windowed", 0))
 End Sub

Private Sub SplashComplete()
    If StartLog Then
        StartupLog "-------------------------------"
        StartupLog "- ENTERING STARTUP RUNLEVEL 2 -"
        StartupLog "-------------------------------"
    End If
    If StartLog Then
        StartupLog "Sound:         " & IIf(EnableSound, "ENABLED", "DISABLED")
        StartupLog "Direct3D:      " & IIf(NoD3D, "DISABLED", "ENABLED")
        StartupLog "8-bit Color:   " & IIf(Paletted, "ENABLED", "DISABLED")
        StartupLog "Debug Log:     " & IIf(bDebugLog, "ENABLED", "DISABLED")
        StartupLog "Farplane:      " & IIf(NoFarplane, "DISABLED", "ENABLED")
        StartupLog "Blending:      " & IIf(NoBlending, "DISABLED", "ENABLED")
        StartupLog "Windowed:      " & IIf(Windowed, "YES", "NO")
        If Not LowVRAM And Not LowMem Then
            StartupLog "Surfaces stored in: Video Memory"
        ElseIf LowMem And Not LowVRAM Then
            StartupLog "Surfaces stored in: DirectX's Decision"
        ElseIf LowVRAM Then
            StartupLog "Surfaces stored in: System Memory"
        End If
    End If
    Timer1.Enabled = False
    SetLoadTitle "Initializing objects..."
    If Encrypted Then Set Encryption = New clsEncryption
    Set Speed = New clsDouble
    Set Health = New clsByte
    Set BounceAmmo = New clsByte
    Set MissAmmo = New clsByte
    Set MortarAmmo = New clsByte
    Set MineAmmo = New clsByte
    Set WepRecharge = New clsSingle
    SetLoadTitle "Initializing variables..."
    If DevEnv Then DebugShow = True
    DimEm
    PSpeed = 150
    PBuffer = 1
    InitKeys
    SetLoadTitle "Initializing Network..."
    InitSocket
End Sub
