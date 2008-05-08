VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Begin VB.Form frmOptions 
   AutoRedraw      =   -1  'True
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Options"
   ClientHeight    =   3975
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5895
   BeginProperty Font 
      Name            =   "Arial"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "Cobalt_frmOptions.frx":0000
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   265
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   393
   StartUpPosition =   1  'CenterOwner
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   2280
      Top             =   1920
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Frame Frame 
      Caption         =   "Muzzle List"
      Height          =   2775
      Index           =   1
      Left            =   240
      TabIndex        =   0
      Top             =   480
      Width           =   5415
      Begin VB.PictureBox Picture2 
         BorderStyle     =   0  'None
         Height          =   495
         Left            =   120
         ScaleHeight     =   495
         ScaleWidth      =   2055
         TabIndex        =   27
         Top             =   2160
         Width           =   2055
         Begin VB.CommandButton Command1 
            Caption         =   "Remove Selected"
            Height          =   375
            Left            =   0
            TabIndex        =   28
            Top             =   0
            Width           =   1935
         End
      End
      Begin VB.PictureBox Picture1 
         BorderStyle     =   0  'None
         Height          =   495
         Left            =   3000
         ScaleHeight     =   495
         ScaleWidth      =   1815
         TabIndex        =   25
         Top             =   1440
         Width           =   1815
         Begin VB.CommandButton Command2 
            Caption         =   "Add to Muzzle"
            Height          =   375
            Left            =   0
            TabIndex        =   26
            Top             =   0
            Width           =   1695
         End
      End
      Begin VB.TextBox Text4 
         Height          =   285
         Left            =   3000
         TabIndex        =   10
         Top             =   1080
         Width           =   1695
      End
      Begin VB.ListBox List1 
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   1815
         ItemData        =   "Cobalt_frmOptions.frx":1042
         Left            =   120
         List            =   "Cobalt_frmOptions.frx":1044
         TabIndex        =   9
         Top             =   240
         Width           =   1935
      End
      Begin VB.Label Label5 
         Alignment       =   1  'Right Justify
         Caption         =   "Muzzle:"
         Height          =   255
         Left            =   2280
         TabIndex        =   11
         Top             =   1080
         Width           =   615
      End
   End
   Begin VB.Frame Frame 
      Caption         =   "Cobalt"
      Height          =   2775
      Index           =   3
      Left            =   240
      TabIndex        =   24
      Top             =   480
      Width           =   5415
      Begin VB.PictureBox Picture3 
         BorderStyle     =   0  'None
         Height          =   2415
         Left            =   120
         ScaleHeight     =   161
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   345
         TabIndex        =   29
         Top             =   240
         Width           =   5175
         Begin VB.CheckBox Check1 
            Caption         =   "Flash lobby window on new messages"
            Height          =   210
            Left            =   0
            TabIndex        =   38
            Top             =   1605
            Width           =   3735
         End
         Begin VB.CheckBox Check18 
            Caption         =   "Keep-alive"
            Height          =   255
            Left            =   0
            TabIndex        =   37
            Top             =   1800
            Width           =   2775
         End
         Begin VB.CheckBox Check13 
            Caption         =   "Send Cobalt to tray when minimized"
            Height          =   210
            Left            =   0
            TabIndex        =   36
            Top             =   1380
            Width           =   2895
         End
         Begin VB.CheckBox Check8 
            Caption         =   "Show uptime"
            Height          =   255
            Left            =   0
            TabIndex        =   35
            Top             =   1125
            Width           =   1695
         End
         Begin VB.CheckBox Check7 
            Caption         =   "Chat timestamp"
            Height          =   255
            Left            =   0
            TabIndex        =   34
            Top             =   900
            Width           =   1695
         End
         Begin VB.CheckBox Check6 
            Caption         =   "Enable profanity filter"
            Height          =   255
            Left            =   0
            TabIndex        =   33
            Top             =   675
            Width           =   2055
         End
         Begin VB.CheckBox Check5 
            Caption         =   "Disable pager"
            Height          =   255
            Left            =   0
            TabIndex        =   32
            Top             =   450
            Width           =   2295
         End
         Begin VB.CheckBox Check4 
            Caption         =   "Disable update checking"
            Height          =   255
            Left            =   0
            TabIndex        =   31
            Top             =   225
            Width           =   2175
         End
         Begin VB.CheckBox Check2 
            Caption         =   "Don't Show Entry / Leave Messages"
            Height          =   255
            Left            =   0
            TabIndex        =   30
            Top             =   0
            Width           =   3015
         End
      End
   End
   Begin VB.CommandButton Command4 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   4680
      TabIndex        =   20
      Top             =   3480
      Width           =   1095
   End
   Begin VB.CommandButton Command3 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   3480
      TabIndex        =   19
      Top             =   3480
      Width           =   1095
   End
   Begin VB.Frame Frame 
      Caption         =   "Messages"
      Height          =   2775
      Index           =   2
      Left            =   240
      TabIndex        =   12
      Top             =   480
      Width           =   5415
      Begin VB.CheckBox Check14 
         Caption         =   "Turn off colors"
         Height          =   255
         Left            =   1080
         TabIndex        =   23
         Top             =   1920
         Visible         =   0   'False
         Width           =   1455
      End
      Begin VB.TextBox Text12 
         Height          =   315
         Left            =   1080
         TabIndex        =   22
         Top             =   1560
         Visible         =   0   'False
         Width           =   1575
      End
      Begin VB.TextBox Text8 
         Height          =   285
         Left            =   1680
         TabIndex        =   16
         Top             =   840
         Width           =   3495
      End
      Begin VB.TextBox Text7 
         Height          =   285
         Left            =   1680
         TabIndex        =   15
         Top             =   480
         Width           =   3495
      End
      Begin VB.Label Label15 
         Alignment       =   1  'Right Justify
         Caption         =   "RGB chat:"
         Height          =   255
         Left            =   120
         TabIndex        =   21
         Top             =   1600
         Visible         =   0   'False
         Width           =   855
      End
      Begin VB.Label Label8 
         Alignment       =   1  'Right Justify
         Caption         =   "Exit message:"
         Height          =   255
         Left            =   120
         TabIndex        =   14
         Top             =   840
         Width           =   1455
      End
      Begin VB.Label Label7 
         Alignment       =   1  'Right Justify
         Caption         =   "Entry message:"
         Height          =   255
         Left            =   120
         TabIndex        =   13
         Top             =   480
         Width           =   1455
      End
   End
   Begin VB.Frame Frame 
      Caption         =   "Account Settings"
      Height          =   2775
      Index           =   0
      Left            =   240
      TabIndex        =   2
      Top             =   480
      Width           =   5415
      Begin VB.TextBox Text5 
         Height          =   285
         Left            =   1560
         MaxLength       =   255
         TabIndex        =   18
         Top             =   1920
         Width           =   3135
      End
      Begin VB.TextBox Text3 
         Height          =   285
         IMEMode         =   3  'DISABLE
         Left            =   1560
         MaxLength       =   50
         PasswordChar    =   "*"
         TabIndex        =   7
         Top             =   1200
         Width           =   1575
      End
      Begin VB.TextBox Text2 
         Height          =   285
         IMEMode         =   3  'DISABLE
         Left            =   1560
         MaxLength       =   50
         PasswordChar    =   "*"
         TabIndex        =   6
         Top             =   840
         Width           =   1575
      End
      Begin VB.TextBox Text1 
         Height          =   285
         IMEMode         =   3  'DISABLE
         Left            =   1560
         MaxLength       =   50
         PasswordChar    =   "*"
         TabIndex        =   4
         Top             =   480
         Width           =   1575
      End
      Begin VB.Label Label6 
         Alignment       =   1  'Right Justify
         Caption         =   "Contact Email:"
         Height          =   255
         Left            =   240
         TabIndex        =   17
         Top             =   1920
         Width           =   1215
      End
      Begin VB.Label Label3 
         Alignment       =   1  'Right Justify
         Caption         =   "Confirm Password:"
         Height          =   255
         Left            =   120
         TabIndex        =   8
         Top             =   1200
         Width           =   1335
      End
      Begin VB.Label Label2 
         Alignment       =   1  'Right Justify
         Caption         =   "New Password:"
         Height          =   255
         Left            =   120
         TabIndex        =   5
         Top             =   840
         Width           =   1335
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Old Password:"
         Height          =   255
         Left            =   120
         TabIndex        =   3
         Top             =   480
         Width           =   1335
      End
   End
   Begin MSComctlLib.TabStrip TabStrip1 
      Height          =   3255
      Left            =   120
      TabIndex        =   1
      Top             =   120
      Width           =   5655
      _ExtentX        =   9975
      _ExtentY        =   5741
      _Version        =   393216
      BeginProperty Tabs {1EFB6598-857C-11D1-B16A-00C0F0283628} 
         NumTabs         =   4
         BeginProperty Tab1 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            Caption         =   "Account"
            Key             =   "account"
            ImageVarType    =   2
         EndProperty
         BeginProperty Tab2 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            Caption         =   "Muzzle List"
            Key             =   "muzzlelist"
            ImageVarType    =   2
         EndProperty
         BeginProperty Tab3 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            Caption         =   "Messages"
            Key             =   "messages"
            ImageVarType    =   2
         EndProperty
         BeginProperty Tab4 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            Caption         =   "Cobalt"
            Key             =   "cobalt"
            ImageVarType    =   2
         EndProperty
      EndProperty
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
End
Attribute VB_Name = "frmOptions"
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
Dim Modified As Boolean
Dim ResX As Integer, ResY As Integer
Dim DirectX As DirectX7, Windir As String
Dim DirectDraw As DirectDraw7
Dim ddem As DirectDrawEnumModes, DisPath As String

Private Sub Check1_Click()
    FlashWindows = Check1.Value
End Sub

Private Sub Check13_Click()
    SysTray = Check13.Value
End Sub

Private Sub Check14_Click()
    NoColor = Check14.Value
End Sub

Private Sub Check18_Click()
    KeepAlive = Check18.Value
End Sub

Private Sub Check2_Click()
    NoEnterLeave = Check2.Value
End Sub

Private Sub Check4_Click()
    NoUpdate = Check4.Value
End Sub

Private Sub Check5_Click()
    NoPager = Check5.Value
End Sub

Private Sub Check6_Click()
    If Check6.Value Then
        NoBadWords = 1
    Else
        NoBadWords = 0
    End If
End Sub

Private Sub Check7_Click()
    TimeStamp = Check7.Value
End Sub

Private Sub Check8_Click()
    ShowUptime = Check8.Value
    If ShowUptime = 0 Then frmMain.Caption = ProjectName & " Front End v" & App.Major & "." & Format$(App.Minor, "0") & "." & Format$(App.Revision, "0000") & " (beta)"
End Sub

Private Sub Command1_Click()
    MuzzleThem List1.List(List1.ListIndex)
    List1.Clear
    Dim i As Integer
    For i = 0 To UBound(Muzzle)
        If Muzzle(i) <> vbNullString Then
            List1.AddItem Muzzle(i)
        End If
    Next
    List1.Refresh
End Sub

Private Sub Command2_Click()
    If IsMuzzled(Text4) Then Exit Sub
    MuzzleThem Text4
    List1.AddItem Text4
    Text4 = vbNullString
End Sub

Private Sub Command3_Click()
    On Error Resume Next
    If Modified Then
        Dim lNewMsg As Byte, lOffset As Long, tmp As String
        Dim oNewMsg() As Byte, lNewOffset As Long
        If LCase(Text2) <> LCase(Text3) Then
            ErrorMSG = "The confirm password entry doesn't match the new password."
            RaiseError ErrorMSG
            Exit Sub
        End If
        lNewMsg = MSG_ACCOUNT
        lNewOffset = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
        tmp = Text1
        If tmp = vbNullString Then tmp = " "
        AddBufferString oNewMsg, tmp, lNewOffset
        tmp = Text2
        If tmp = vbNullString Then tmp = " "
        AddBufferString oNewMsg, tmp, lNewOffset
        tmp = Text3
        If tmp = vbNullString Then tmp = " "
        AddBufferString oNewMsg, tmp, lNewOffset
        tmp = Text5
        If tmp = vbNullString Then tmp = " "
        AddBufferString oNewMsg, tmp, lNewOffset
        tmp = Text7
        If tmp = vbNullString Then tmp = " "
        AddBufferString oNewMsg, tmp, lNewOffset
        tmp = Text8
        If tmp = vbNullString Then tmp = " "
        AddBufferString oNewMsg, tmp, lNewOffset
        SendTo oNewMsg
    End If
    EnterMSG = Text7
    ExitMSG = Text8
    Email = Text5
    ChatColor = RGB2BGR(Text12)
    SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\Cobalt", "NoEnterLeave", NoEnterLeave
    SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\Cobalt", "FlashWindows", FlashWindows
    SaveSettingString HKEY_CURRENT_USER, "SOFTWARE\Cobalt", "ChatColor", ChatColor
    SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\Cobalt", "NoColor", NoColor
    SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\Cobalt", "NoUpdate", NoUpdate
    SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\Cobalt", "NoPager", NoPager
    SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\Cobalt", "NoBadWords", NoBadWords
    SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\Cobalt", "TimeStamp", TimeStamp
    SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\Cobalt", "ShowUptime", ShowUptime
    SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\Cobalt", "SysTray", SysTray
    SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\Cobalt", "KeepAlive", KeepAlive
    SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\Cobalt", "Skin", skins
    Unload Me
End Sub

Private Sub Command4_Click()
    Unload Me
End Sub

Private Sub Form_Load()
    Dim sl As Long
    Frame(0).ZOrder
    If ColorCodes Then
        Text12.Visible = True
        Check14.Visible = True
        Label15.Visible = True
    End If
    Text5 = Email
    Text7 = EnterMSG
    Text8 = ExitMSG
    Text12 = RGB2BGR(ChatColor)
    Windir = String(255, Chr(0))
    sl = GetWindowsDirectory(Windir, 255)
    Windir = Mid(Windir, 1, sl)
    Check2.Value = FlashWindows * -1
    Check2.Value = NoEnterLeave * -1
    Check4.Value = NoUpdate * -1
    Check5.Value = NoPager * -1
    If NoBadWords > 0 Then
        Check6.Value = 1
    End If
    Check7.Value = TimeStamp * -1
    Check8.Value = ShowUptime * -1
    Check13.Value = SysTray * -1
    Check14.Value = NoColor * -1
    Check18.Value = KeepAlive * -1
    Modified = False
End Sub

Private Function RGB2BGR(Color As String) As String
    RGB2BGR = Mid$(Color, 5, 2) & Mid$(Color, 3, 2) & Mid$(Color, 1, 2)
End Function

Private Sub TabStrip1_Click()
    Dim s As String
    Select Case TabStrip1.SelectedItem.Index
    Case 1
        Frame(0).ZOrder
    Case 2
        List1.Clear
        Frame(1).ZOrder
        Dim i As Integer
        For i = 0 To UBound(Muzzle)
            If Muzzle(i) <> vbNullString Then
                List1.AddItem Muzzle(i)
            End If
        Next
    Case 3
        Frame(2).ZOrder
    Case 4
        Frame(3).ZOrder
    Case 5
        Frame(4).ZOrder
        If skins <> 5 Then Me.Height = Me.Height + 100
    End Select
End Sub

Private Sub Text1_Change()
    Modified = True
End Sub

Private Sub Text2_Change()
    Modified = True
End Sub

Private Sub Text3_Change()
    Modified = True
End Sub

Private Sub Text5_Change()
    Modified = True
End Sub

Private Sub Text7_Change()
    Modified = True
End Sub

Private Sub Text8_Change()
    Modified = True
End Sub

