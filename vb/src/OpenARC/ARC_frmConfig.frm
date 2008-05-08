VERSION 5.00
Begin VB.Form frmConfig 
   BorderStyle     =   1  'Fixed Single
   ClientHeight    =   3015
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   3975
   Icon            =   "ARC_frmConfig.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3015
   ScaleWidth      =   3975
   StartUpPosition =   1  'CenterOwner
   Begin VB.Frame framTroubleshooting 
      Caption         =   "Troubleshooting"
      Height          =   1095
      Left            =   120
      TabIndex        =   11
      Top             =   120
      Visible         =   0   'False
      Width           =   3735
      Begin VB.CheckBox chkHybrid 
         Caption         =   "Enable DirectDraw/Direct3D hybrid"
         ForeColor       =   &H8000000D&
         Height          =   285
         Left            =   120
         TabIndex        =   14
         ToolTipText     =   "Disable this if you get an AUTOMATION ERROR when attempting to join a game!"
         Top             =   240
         Width           =   3495
      End
      Begin VB.CheckBox chkLowMem 
         Caption         =   "Enable 64MB+ video advance"
         ForeColor       =   &H8000000D&
         Height          =   255
         Left            =   120
         TabIndex        =   13
         ToolTipText     =   "Disable this if you get Run Time Error 7 (out of memory)."
         Top             =   480
         Width           =   3495
      End
      Begin VB.CheckBox chkSysMem 
         Caption         =   "Use system RAM preferentially"
         ForeColor       =   &H8000000D&
         Height          =   255
         Left            =   120
         TabIndex        =   12
         ToolTipText     =   "If you experience strange graphics, check this box."
         Top             =   720
         Width           =   3495
      End
   End
   Begin VB.Frame Frame2 
      Caption         =   "Other"
      Height          =   615
      Left            =   120
      TabIndex        =   9
      Top             =   120
      Visible         =   0   'False
      Width           =   3735
      Begin VB.CheckBox chkWindowed 
         Caption         =   "Run in a window"
         ForeColor       =   &H8000000D&
         Height          =   255
         Left            =   120
         TabIndex        =   10
         ToolTipText     =   "This should increase your framerate without a noticeable drop in quality."
         Top             =   240
         Width           =   3495
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "Advanced"
      Height          =   1575
      Left            =   120
      TabIndex        =   4
      Top             =   840
      Width           =   3735
      Begin VB.CheckBox chkHWAccel 
         Caption         =   "No hardware acceleration"
         ForeColor       =   &H8000000D&
         Height          =   255
         Left            =   120
         TabIndex        =   7
         Top             =   1200
         Width           =   3495
      End
      Begin VB.CheckBox chkHWBlt 
         Caption         =   "No hardware Blt"
         ForeColor       =   &H8000000D&
         Height          =   255
         Left            =   120
         TabIndex        =   6
         Top             =   960
         Width           =   3495
      End
      Begin VB.CheckBox chkHWTrans 
         Caption         =   "No hardware transparency"
         ForeColor       =   &H8000000D&
         Height          =   255
         Left            =   120
         TabIndex        =   5
         Top             =   720
         Width           =   3495
      End
      Begin VB.Label Label1 
         BackStyle       =   0  'Transparent
         Caption         =   "CAUTION: These settings may fix graphical errors, but they will affect FPS."
         ForeColor       =   &H00000080&
         Height          =   495
         Left            =   240
         TabIndex        =   8
         Top             =   240
         Width           =   3375
      End
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "OK"
      Height          =   375
      Left            =   2760
      TabIndex        =   2
      Top             =   2520
      Width           =   1095
   End
   Begin VB.Frame framFramerate 
      Caption         =   "Framerate"
      Height          =   855
      Left            =   120
      TabIndex        =   0
      Top             =   1320
      Visible         =   0   'False
      Width           =   3735
      Begin VB.CheckBox chk8Bit 
         Caption         =   "8 bit graphics mode"
         ForeColor       =   &H8000000D&
         Height          =   255
         Left            =   120
         TabIndex        =   3
         ToolTipText     =   "This should increase your framerate without a noticeable drop in quality."
         Top             =   480
         Width           =   3495
      End
      Begin VB.CheckBox chkFarplane 
         Caption         =   "Disable Farplane (background)"
         ForeColor       =   &H8000000D&
         Height          =   255
         Left            =   120
         TabIndex        =   1
         ToolTipText     =   "Check this if you want a higher framerate."
         Top             =   240
         Width           =   3495
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

Private WinDir As String

Private Sub chk8Bit_Click()
    SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "8BitColor", chk8Bit.Value
    Paletted = CBool(chk8Bit.Value)
    CheckHybrid
End Sub

Private Sub chkFarplane_Click()
    SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "NoFarplane", chkFarplane.Value
    NoFarplane = CBool(chkFarplane.Value)
End Sub

Private Sub chkHWAccel_Click()
    SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\Microsoft\DirectDraw", "EmulationOnly", chkHWAccel.Value
    CheckHybrid
End Sub

Private Sub chkHWBlt_Click()
    writeini "DirectDraw", "nohwblt", chkHWBlt.Value, WinDir & "\win.ini"
End Sub

Private Sub chkHWTrans_Click()
    writeini "DirectDraw", "nohwtrans", chkHWTrans.Value, WinDir & "\win.ini"
End Sub

Private Sub chkHybrid_Click() 'Direct3D
    Dim tmp As Long
    If chkHybrid.Value = 1 Then
        tmp = 0
        NoD3D = False
    Else
        tmp = 1
        NoD3D = True
    End If
    SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "NoD3D", tmp
End Sub

Private Sub chkLowMem_Click() '64+ MB
    If chkLowMem.Value = 0 Then
        SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "LowMemory", 1
        LowMem = True
        Else
        SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "LowMemory", 0
        LowMem = False
    End If
End Sub

Private Sub chkSysMem_Click()
    If chkSysMem.Value = 1 Then
        SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "LowVRAM", 1
        LowVRAM = True
        Else
        SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "LowVRAM", 0
        LowVRAM = False
    End If
End Sub

Private Sub chkWindowed_Click()
    If chkWindowed.Value = 1 Then
        SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "Windowed", 1
        Windowed = True
        Else
        SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "Windowed", 0
        SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "NoD3D", 1
        SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "LowMemory", 0
        SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "LowVRAM", 0
        NoD3D = False
        LowMem = False
        LowVRAM = False
        Windowed = False
    End If
    CheckHybrid
End Sub

Private Sub CheckHybrid()
    If chkWindowed.Value = 1 Or chk8Bit.Value = 1 Or chkHWAccel.Value = 1 Then
        chkHybrid.Value = 0
        chkHybrid.Enabled = False
        Else
        chkHybrid.Enabled = True
    End If
End Sub

Private Sub cmdOK_Click()
    Unload Me
End Sub

Private Sub Form_Load()
    Me.Caption = ProjectName & " Options"
    WinDir = String$(255, Chr$(0))
    sl = GetWindowsDirectory(WinDir, 255)
    WinDir = Mid$(WinDir, 1, sl)
    If Not NoD3D Then Me.chkHybrid.Value = 1
    If Not LowMem Then Me.chkLowMem.Value = 1
    If LowVRAM Then Me.chkSysMem.Value = 1
    If NoFarplane Then Me.chkFarplane.Value = 1
    If Paletted Then Me.chk8Bit.Value = 1
    If Windowed Then Me.chkWindowed.Value = 1
    chkHWTrans.Value = Val(readini("DirectDraw", "nohwtrans", WinDir & "\win.ini"))
    chkHWBlt.Value = Val(readini("DirectDraw", "nohwblt", WinDir & "\win.ini"))
    chkHWAccel.Value = GetSettingLong(HKEY_CURRENT_USER, "SOFTWARE\Microsoft\DirectDraw", "EmulationOnly")
End Sub
