VERSION 5.00
Object = "{33101C00-75C3-11CF-A8A0-444553540000}#1.0#0"; "cswsk32.ocx"
Object = "{318E65B1-7C10-4B42-8A69-EB8DB2C1CACF}#1.0#0"; "FlexUI.ocx"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "RICHTX32.OCX"
Begin VB.Form frmMain 
   Caption         =   "Cobalt Front End"
   ClientHeight    =   7260
   ClientLeft      =   60
   ClientTop       =   750
   ClientWidth     =   9405
   Icon            =   "Cobalt_frmMain.frx":0000
   LinkTopic       =   "frmMain"
   ScaleHeight     =   484
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   627
   StartUpPosition =   2  'CenterScreen
   Begin SocketWrenchCtrl.Socket sckMain 
      Left            =   120
      Top             =   600
      _Version        =   65536
      _ExtentX        =   741
      _ExtentY        =   741
      _StockProps     =   0
      AutoResolve     =   -1  'True
      Backlog         =   5
      Binary          =   -1  'True
      Blocking        =   -1  'True
      Broadcast       =   0   'False
      BufferSize      =   0
      HostAddress     =   ""
      HostFile        =   ""
      HostName        =   ""
      InLine          =   0   'False
      Interval        =   0
      KeepAlive       =   0   'False
      Library         =   ""
      Linger          =   0
      LocalPort       =   0
      LocalService    =   ""
      Protocol        =   0
      RemotePort      =   0
      RemoteService   =   ""
      ReuseAddress    =   0   'False
      Route           =   -1  'True
      Timeout         =   0
      Type            =   1
      Urgent          =   0   'False
   End
   Begin SocketWrenchCtrl.Socket sckGamePing 
      Index           =   0
      Left            =   600
      Top             =   600
      _Version        =   65536
      _ExtentX        =   741
      _ExtentY        =   741
      _StockProps     =   0
      AutoResolve     =   -1  'True
      Backlog         =   5
      Binary          =   -1  'True
      Blocking        =   -1  'True
      Broadcast       =   0   'False
      BufferSize      =   0
      HostAddress     =   ""
      HostFile        =   ""
      HostName        =   ""
      InLine          =   0   'False
      Interval        =   0
      KeepAlive       =   0   'False
      Library         =   ""
      Linger          =   0
      LocalPort       =   0
      LocalService    =   ""
      Protocol        =   0
      RemotePort      =   0
      RemoteService   =   ""
      ReuseAddress    =   0   'False
      Route           =   -1  'True
      Timeout         =   0
      Type            =   1
      Urgent          =   0   'False
   End
   Begin VB.CommandButton cmdServer 
      Caption         =   "Create"
      Height          =   375
      Left            =   1800
      TabIndex        =   4
      Top             =   3000
      Width           =   1335
   End
   Begin VB.CommandButton cmdJoin 
      Caption         =   "Join"
      Height          =   375
      Left            =   120
      TabIndex        =   3
      Top             =   3000
      Width           =   1335
   End
   Begin MSComctlLib.ListView lvGameUsers 
      Height          =   1575
      Left            =   3960
      TabIndex        =   17
      Top             =   1800
      Width           =   2175
      _ExtentX        =   3836
      _ExtentY        =   2778
      LabelEdit       =   1
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      HideColumnHeaders=   -1  'True
      _Version        =   393217
      SmallIcons      =   "ilIcons"
      ForeColor       =   0
      BackColor       =   16777215
      Appearance      =   1
      NumItems        =   0
   End
   Begin MSComctlLib.ListView lvGames 
      Height          =   1140
      Left            =   120
      TabIndex        =   2
      Top             =   1800
      Width           =   3735
      _ExtentX        =   6588
      _ExtentY        =   2011
      LabelEdit       =   1
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      HideColumnHeaders=   -1  'True
      _Version        =   393217
      SmallIcons      =   "ilIcons"
      ForeColor       =   0
      BackColor       =   16777215
      Appearance      =   1
      NumItems        =   0
   End
   Begin VB.Frame framChat 
      Caption         =   "Chat"
      Height          =   3375
      Left            =   120
      TabIndex        =   12
      Top             =   3480
      Width           =   8415
      Begin VB.PictureBox pictPrivate 
         BorderStyle     =   0  'None
         Height          =   340
         Left            =   6000
         ScaleHeight     =   345
         ScaleWidth      =   2295
         TabIndex        =   15
         Top             =   3000
         Width           =   2295
         Begin VB.CommandButton cmdPager 
            Caption         =   "Private Messages"
            BeginProperty Font 
               Name            =   "Arial"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   315
            Left            =   0
            Picture         =   "Cobalt_frmMain.frx":038A
            TabIndex        =   5
            Top             =   0
            Width           =   2295
         End
      End
      Begin VB.PictureBox pictSend 
         BorderStyle     =   0  'None
         Height          =   340
         Left            =   4680
         ScaleHeight     =   345
         ScaleWidth      =   1215
         TabIndex        =   14
         Top             =   2980
         Width           =   1215
         Begin VB.CommandButton cmdSend 
            Caption         =   "Send"
            Default         =   -1  'True
            BeginProperty Font 
               Name            =   "Arial"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   315
            Left            =   0
            Picture         =   "Cobalt_frmMain.frx":3452
            TabIndex        =   1
            Top             =   0
            Width           =   1215
         End
      End
      Begin VB.TextBox txtChat 
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H80000012&
         Height          =   285
         Left            =   120
         MaxLength       =   300
         TabIndex        =   0
         Top             =   3000
         Width           =   4455
      End
      Begin RichTextLib.RichTextBox txtInChat 
         Height          =   2655
         Left            =   120
         TabIndex        =   13
         Top             =   240
         Width           =   5775
         _ExtentX        =   10186
         _ExtentY        =   4683
         _Version        =   393217
         BackColor       =   -2147483633
         BorderStyle     =   0
         Enabled         =   -1  'True
         ReadOnly        =   -1  'True
         ScrollBars      =   2
         Appearance      =   0
         AutoVerbMenu    =   -1  'True
         OLEDragMode     =   0
         OLEDropMode     =   0
         TextRTF         =   $"Cobalt_frmMain.frx":44AA
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Tahoma"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin MSComctlLib.ListView lvUsers 
         Height          =   2655
         Left            =   6000
         TabIndex        =   16
         Top             =   240
         Width           =   2325
         _ExtentX        =   4101
         _ExtentY        =   4683
         LabelEdit       =   1
         LabelWrap       =   -1  'True
         HideSelection   =   -1  'True
         HideColumnHeaders=   -1  'True
         _Version        =   393217
         SmallIcons      =   "ilIcons"
         ForeColor       =   0
         BackColor       =   16777215
         Appearance      =   1
         NumItems        =   0
      End
   End
   Begin VB.Timer tmrKeepAlive 
      Interval        =   30000
      Left            =   2040
      Top             =   120
   End
   Begin VB.TextBox txtGameDescription 
      BackColor       =   &H00FFFFFF&
      ForeColor       =   &H00000000&
      Height          =   1575
      Left            =   6240
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   8
      Top             =   1800
      Width           =   2295
   End
   Begin VB.Timer ChatPause 
      Enabled         =   0   'False
      Interval        =   1000
      Left            =   1560
      Top             =   120
   End
   Begin VB.Timer tmrUpdate 
      Enabled         =   0   'False
      Interval        =   1000
      Left            =   1080
      Top             =   120
   End
   Begin VB.Timer tmrReconnect 
      Enabled         =   0   'False
      Interval        =   5000
      Left            =   600
      Top             =   120
   End
   Begin VB.Timer tmrDataArrival 
      Enabled         =   0   'False
      Interval        =   1
      Left            =   120
      Top             =   120
   End
   Begin MSComctlLib.ImageList ilIcons 
      Left            =   8280
      Top             =   480
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   0
      ImageWidth      =   16
      ImageHeight     =   16
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   20
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmMain.frx":4525
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmMain.frx":4877
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmMain.frx":4BC9
            Key             =   ""
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmMain.frx":4F1B
            Key             =   ""
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmMain.frx":526D
            Key             =   ""
         EndProperty
         BeginProperty ListImage6 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmMain.frx":55BF
            Key             =   ""
         EndProperty
         BeginProperty ListImage7 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmMain.frx":5911
            Key             =   ""
         EndProperty
         BeginProperty ListImage8 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmMain.frx":5C63
            Key             =   ""
         EndProperty
         BeginProperty ListImage9 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmMain.frx":5FB5
            Key             =   ""
         EndProperty
         BeginProperty ListImage10 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmMain.frx":6307
            Key             =   ""
         EndProperty
         BeginProperty ListImage11 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmMain.frx":6659
            Key             =   ""
         EndProperty
         BeginProperty ListImage12 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmMain.frx":69AB
            Key             =   ""
         EndProperty
         BeginProperty ListImage13 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmMain.frx":6CFD
            Key             =   ""
         EndProperty
         BeginProperty ListImage14 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmMain.frx":704F
            Key             =   ""
         EndProperty
         BeginProperty ListImage15 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmMain.frx":73A1
            Key             =   ""
         EndProperty
         BeginProperty ListImage16 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmMain.frx":76F3
            Key             =   ""
         EndProperty
         BeginProperty ListImage17 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmMain.frx":7A45
            Key             =   ""
         EndProperty
         BeginProperty ListImage18 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmMain.frx":7D97
            Key             =   ""
         EndProperty
         BeginProperty ListImage19 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmMain.frx":80E9
            Key             =   ""
         EndProperty
         BeginProperty ListImage20 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Cobalt_frmMain.frx":843B
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin VB.Label lblForums 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "OpenARC Forums"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   -1  'True
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   240
      Left            =   7320
      MousePointer    =   2  'Cross
      TabIndex        =   11
      Top             =   240
      Width           =   1860
   End
   Begin VB.Label lblWeb 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "OpenARC Web Site"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   -1  'True
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   240
      Left            =   7320
      MousePointer    =   2  'Cross
      TabIndex        =   10
      Top             =   0
      Width           =   2040
   End
   Begin VB.Label lblRoom 
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00910000&
      Height          =   375
      Left            =   480
      TabIndex        =   9
      Top             =   1080
      Width           =   6615
   End
   Begin FlexUIProject.FlexUI FlexUI1 
      Left            =   8400
      Top             =   840
      _ExtentX        =   820
      _ExtentY        =   794
      ControlsSetupString=   $"Cobalt_frmMain.frx":878D
      MinFormWidth    =   628
      MinFormHeight   =   440
   End
   Begin VB.Label lblVersion 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Cobalt Client v2.00 build 0000"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   255
      Left            =   120
      TabIndex        =   7
      Top             =   6960
      Width           =   8415
   End
   Begin VB.Label Label2 
      AutoSize        =   -1  'True
      Height          =   195
      Left            =   1680
      TabIndex        =   6
      Top             =   1080
      Visible         =   0   'False
      Width           =   45
   End
   Begin VB.Image imgAdvert 
      Appearance      =   0  'Flat
      BorderStyle     =   1  'Fixed Single
      Height          =   930
      Left            =   2280
      Top             =   120
      Visible         =   0   'False
      Width           =   7050
   End
   Begin VB.Menu mnuFile 
      Caption         =   "&File"
      Begin VB.Menu mainopt 
         Caption         =   "&Options"
      End
      Begin VB.Menu div1 
         Caption         =   "-"
      End
      Begin VB.Menu reconnect 
         Caption         =   "&Connect"
      End
      Begin VB.Menu mnudisconnect 
         Caption         =   "&Disconnect"
      End
      Begin VB.Menu div2 
         Caption         =   "-"
      End
      Begin VB.Menu exit 
         Caption         =   "E&xit"
      End
   End
   Begin VB.Menu opt 
      Caption         =   "opt"
      Visible         =   0   'False
      Begin VB.Menu admin2 
         Caption         =   "Admin"
         Begin VB.Menu gag 
            Caption         =   "Gag (by IP address)"
         End
         Begin VB.Menu mnuListIP 
            Caption         =   "List IP Addresses"
         End
         Begin VB.Menu warn 
            Caption         =   "Warn"
         End
         Begin VB.Menu boot 
            Caption         =   "Kick"
         End
         Begin VB.Menu mnuban 
            Caption         =   "Bans"
            Begin VB.Menu mnunameban 
               Caption         =   "Nickname Ban"
            End
            Begin VB.Menu mnuipban 
               Caption         =   "IP Address Ban"
            End
            Begin VB.Menu mnuhdban 
               Caption         =   "HD Serial Ban"
            End
            Begin VB.Menu mnuBanSysID 
               Caption         =   "Unique System ID Ban"
            End
         End
         Begin VB.Menu mnuList 
            Caption         =   "Lists"
            Begin VB.Menu mnugaglist 
               Caption         =   "Gag list"
            End
            Begin VB.Menu mnubanlist 
               Caption         =   "Account Ban list"
            End
            Begin VB.Menu mnuipbanlist 
               Caption         =   "IP Ban list"
            End
            Begin VB.Menu mnuhdbanlist 
               Caption         =   "HD Ban list"
            End
            Begin VB.Menu mnuListSysIDBans 
               Caption         =   "Unique System ID Ban list"
            End
         End
      End
      Begin VB.Menu owhisper 
         Caption         =   "Whisper"
      End
      Begin VB.Menu opage 
         Caption         =   "Page"
      End
      Begin VB.Menu mnuprofile 
         Caption         =   "View Statistics"
      End
      Begin VB.Menu odiv 
         Caption         =   "-"
      End
      Begin VB.Menu mnuicon 
         Caption         =   "Icon"
      End
      Begin VB.Menu muzz 
         Caption         =   "Muzzle"
      End
   End
   Begin VB.Menu cht 
      Caption         =   "cht"
      Visible         =   0   'False
      Begin VB.Menu nck 
         Caption         =   "Nick"
         Begin VB.Menu cwhisper 
            Caption         =   "Whisper"
         End
         Begin VB.Menu cprofile 
            Caption         =   "View Statistics"
         End
         Begin VB.Menu cnick 
            Caption         =   "Copy Nick"
         End
      End
      Begin VB.Menu chtdiv 
         Caption         =   "-"
      End
      Begin VB.Menu linkgo 
         Caption         =   "Jump to LINK"
      End
      Begin VB.Menu cpychat 
         Caption         =   "Copy Selected Chat"
      End
      Begin VB.Menu chtdiv2 
         Caption         =   "-"
      End
      Begin VB.Menu scrldwn 
         Caption         =   "Scroll Down"
         Checked         =   -1  'True
      End
      Begin VB.Menu ShowEE 
         Caption         =   "Show Enter/Exit"
         Checked         =   -1  'True
      End
   End
   Begin VB.Menu svrlst 
      Caption         =   "svrlst"
      Visible         =   0   'False
      Begin VB.Menu mnustats 
         Caption         =   "Game Stats"
      End
      Begin VB.Menu mnudstrgme 
         Caption         =   "Destroy Game"
      End
      Begin VB.Menu mnugetpw 
         Caption         =   "Get Password"
      End
   End
   Begin VB.Menu mnuRoom 
      Caption         =   "&Rooms"
      Begin VB.Menu mnuRoomList 
         Caption         =   "Room &List"
      End
   End
   Begin VB.Menu mnupeople 
      Caption         =   "&People"
      Begin VB.Menu mnupage 
         Caption         =   "&Page Someone"
      End
      Begin VB.Menu mnuprofile2 
         Caption         =   "&View User Statistics"
         Visible         =   0   'False
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "&Help"
      Begin VB.Menu ucheck 
         Caption         =   "&Check for Updates"
         Visible         =   0   'False
      End
      Begin VB.Menu mnuabout 
         Caption         =   "&About"
      End
   End
   Begin VB.Menu mnuplaying 
      Caption         =   "playing"
      Visible         =   0   'False
      Begin VB.Menu mnukick 
         Caption         =   "Kick"
      End
      Begin VB.Menu plwhisper 
         Caption         =   "Whisper"
      End
      Begin VB.Menu pldiv 
         Caption         =   "-"
      End
      Begin VB.Menu mnushowping 
         Caption         =   "Show Ping"
      End
   End
   Begin VB.Menu mnumain 
      Caption         =   "main"
      Visible         =   0   'False
      Begin VB.Menu mnushow 
         Caption         =   "Show"
      End
   End
End
Attribute VB_Name = "frmMain"
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
Private Type NOTIFYICONDATA
    cbSize As Long
    hwnd As Long
    uID As Long
    uFlags As Long
    uCallbackMessage As Long
    hIcon As Long
    sTip As String * 64
End Type
Private sysIcon As NOTIFYICONDATA
Private Declare Function ShellExecute Lib "shell32.dll" Alias _
   "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation _
   As String, ByVal lpFile As String, ByVal lpParameters _
   As String, ByVal lpDirectory As String, ByVal nShowCmd _
   As Long) As Long
Private Declare Function Shell_NotifyIcon Lib "shell32.dll" Alias "Shell_NotifyIconA" (ByVal dwMessage As Long, lpData As NOTIFYICONDATA) As Long

Private Function WebURL(ByVal URL As String) As Long
    WebURL = ShellExecute(0&, vbNullString, URL, vbNullString, vbNullString, vbNormalFocus)
End Function

Private Sub ban_Click()
    Call mnunameban_Click
End Sub

Private Sub boot_Click()
    If MsgBox("Kick " & lvUsers.SelectedItem.Text & " ?", vbInformation Or vbYesNo, "Kick") = vbNo Then Exit Sub
    ChatSend "/kick " & lvUsers.SelectedItem.Text
End Sub

Private Sub ChatPause_Timer()
    ChatPause.Enabled = False
End Sub

Private Sub cmdJoin_Click()
    JoinGame
End Sub

Private Sub cmdPager_Click()
    On Error Resume Next
    ScreenNameBox = 1
    txtChat.SetFocus
    Dim i As Integer
    If PagerStat(1) Then
        frmPageReq.Show
        Exit Sub
    End If
    For i = 0 To UBound(PagerMSG)
        If PagerMSG(i).PName(0) <> vbNullString Then Exit For
    Next
    If i > UBound(PagerMSG) Then
        frmPageReq.Show
    Else
        frmPager.Show
    End If
End Sub

Private Sub cmdSend_Click()
    If Not ChatPause.Enabled Then
        ChatSend txtChat
        txtChat = vbNullString
    End If
    If txtChat.Enabled Then txtChat.SetFocus
End Sub

Private Sub cmdServer_Click()
    Dim i As Integer, LaunchPath As String
    LaunchPath = AppPath
    If Dir(LaunchPath & "server.exe") <> "" Then
        Call writeini("Settings2", "sn", UserName, LaunchPath & "settings.ini")
        Call writeini("Settings2", "Server", HostAddy, LaunchPath & "settings.ini")
        Call writeini("Settings2", "Port", Port2, LaunchPath & "settings.ini")
        Call Shell(LaunchPath & "server.exe", vbNormalFocus)
    Else
        RaiseError LaunchPath & "server.exe not found!"
    End If
End Sub

Private Sub cnick_Click()
    Clipboard.Clear
    Clipboard.SetText txtInChat.SelText
End Sub

Private Sub exit_Click()
    Form_Unload 0
End Sub

Private Sub Form_Load()
    lblVersion.Caption = "Cobalt Front End version " & App.Major & "." & Format$(App.Minor, "0") & " build " & Format$(App.Revision, "0000") & " (beta)"
    'Me.Picture = Me.picBG.Picture
    lvUsers.ColumnHeaders.Add , , "People Here", lvUsers.Width - 25
    lvUsers.View = lvwReport
    lvGameUsers.ColumnHeaders.Add , , "People Playing", lvGameUsers.Width - 25
    lvGameUsers.View = lvwReport
    lvGames.ColumnHeaders.Add , , "Games", lvGames.Width - 25
    lvGames.View = lvwReport
    Me.Caption = "Cobalt Front End v" & App.Major & "." & Format$(App.Minor, "0") & "." & Format$(App.Revision, "0000") & " (beta)"
    Form_Resize
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    Form_Unload 0
End Sub

Private Sub lblForums_Click()
  WebURL ("http://forums.uplinklabs.net")
End Sub

Private Sub lblWeb_Click()
  WebURL ("http://openarc.sourceforge.net")
End Sub

Private Sub lvGames_Click()
    If lvGames.SelectedItem Is Nothing Then
        Exit Sub
    End If
    lvGameUsers.ListItems.Clear
    RefreshPlayers
End Sub

Private Sub lvGames_DblClick()
    JoinGame
End Sub

Private Sub RefreshPlayers()
    Dim i As Integer, X As Integer, j As Integer, a As Integer
    If lvGames.ListItems.Count = 0 Then Exit Sub
    i = Mid$(lvGames.SelectedItem.Key, 2)
    If i > UBound(ServerDat) Then Exit Sub
    If ServerDat(i) Is Nothing Then Exit Sub
    If txtGameDescription <> ServerDat(i).sDesc Then txtGameDescription = ServerDat(i).sDesc
    SrvIcons i
    For X = 0 To UBound(svrPlayers)
        If i = svrPlayers(X).ServerID Then
            a = 0
            If svrPlayers(X).Ping < 180 Then a = 5
            If svrPlayers(X).Ping >= 180 And svrPlayers(X).Ping < 300 Then a = 6
            If svrPlayers(X).Ping >= 300 And svrPlayers(X).Ping < 450 Then a = 7
            If svrPlayers(X).Ping >= 450 Then a = 8
            For j = 1 To lvGameUsers.ListItems.Count
                If lvGameUsers.ListItems(j).Key = "P" & X Then
                    If lvGameUsers.ListItems(j).SmallIcon <> a Then lvGameUsers.ListItems(j).SmallIcon = a
                    Exit For
                End If
            Next
            If j > lvGameUsers.ListItems.Count Then
                lvGameUsers.ListItems.Add , "P" & X, svrPlayers(X).ScreenName, 0, a
            End If
        End If
    Next
    
    For j = 1 To lvGameUsers.ListItems.Count
        If svrPlayers(Mid$(lvGameUsers.ListItems(j).Key, 2)).playerID = 0 Then
            lvGameUsers.ListItems.Remove j
            Exit For
        End If
    Next
    lvGameUsers.Refresh
End Sub

Private Sub lvGames_KeyUp(KeyCode As Integer, Shift As Integer)
    lvGameUsers.ListItems.Clear
    RefreshPlayers
End Sub

Private Sub lvGames_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If lvGames.ListItems.Count = 0 Then Exit Sub
    If Button = 2 Then PopupMenu frmMain.svrlst
End Sub

Private Sub Form_Resize()
    On Error Resume Next
    lblVersion.Width = Me.ScaleWidth - 15
    If imgAdvert.Visible Then
        imgAdvert.Move Me.ScaleWidth - imgAdvert.Width - 4
        lblRoom.Move 12, 80, Me.ScaleWidth - lblRoom.Left - lblWeb.Width - 8
        Else
        lblRoom.Move 12, 10, Me.ScaleWidth - lblRoom.Left - lblWeb.Width - 8
    End If
    lblWeb.Move lblRoom.Width + lblRoom.Left + 2
    lblForums.Move lblRoom.Width + lblRoom.Left + 2
    lvGames.Move 8, lblRoom.Top + lblRoom.Height + 1, (Me.ScaleWidth - 40) / 3 + 2
    lvGameUsers.Move lvGames.Left + lvGames.Width + 5, lvGames.Top, (Me.ScaleWidth - 40) / 3 + 2
    txtGameDescription.Move lvGameUsers.Left + lvGameUsers.Width + 5, lvGames.Top, (Me.ScaleWidth - 40) / 3 + 2
    cmdJoin.Move lvGames.Left, lvGames.Top + lvGames.Height + 3, (lvGames.Width / 2) - 3
    cmdServer.Move cmdJoin.Left + cmdJoin.Width + 5, cmdJoin.Top, (lvGames.Width / 2) - 3
    framChat.Move 8, cmdJoin.Top + cmdJoin.Height + 10, Me.ScaleWidth - 20, Me.ScaleHeight - lblRoom.Top - 160
    lblVersion.Move 8, framChat.Top + framChat.Height + 3
    txtInChat.Move txtInChat.Left, txtInChat.Top, (framChat.Width * Screen.TwipsPerPixelX) - 2700, (framChat.Height * Screen.TwipsPerPixelY) - 700
    lvUsers.Move txtInChat.Left + txtInChat.Width + 110, txtInChat.Top, lvUsers.Width, txtInChat.Height
    cmdPager.Move cmdPager.Left, cmdPager.Top, pictPrivate.Width
    txtChat.Move txtInChat.Left, txtInChat.Height + txtInChat.Top + 60, txtInChat.Width - pictSend.Width - 55
    pictPrivate.Move lvUsers.Left - 10, txtChat.Top - 12, lvUsers.Width + 40
    pictSend.Move txtChat.Left + txtChat.Width + 90, txtChat.Top - 20
    lvGameUsers.ColumnHeaders(1).Width = lvGameUsers.Width - 25
    lvGames.ColumnHeaders(1).Width = lvGames.Width - 25
    lvUsers.ColumnHeaders(1).Width = lvUsers.Width - 25
    If scrldwn.Checked Then Call SendMessage(txtInChat.hwnd, WM_VSCROLL, SB_BOTTOM, ByVal 0&)
    Me.Refresh
    If Not SysTray Then Exit Sub
    If Me.WindowState = vbMinimized Then
        With sysIcon
            .cbSize = LenB(sysIcon)
            .hwnd = frmAbout.hwnd
            .uFlags = NIF_DOALL
            .uCallbackMessage = WM_MOUSEMOVE
            .hIcon = frmMain.icon
            .sTip = "CFront" & vbNullChar
        End With
        Shell_NotifyIcon NIM_ADD, sysIcon
        Me.Hide
    Else
        Shell_NotifyIcon NIM_DELETE, sysIcon
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
    On Error Resume Next
    Unload frmMain
    Unload frmLogin
    Unload frmPager
    Unload frmSplash
    sckMain.Disconnect
    sckMain.Cleanup
    End
End Sub

Private Sub gag_Click()
    ChatSend "/gag " & lvUsers.SelectedItem.Text & " " & Val(InputBox("Gag time in minutes.", "Gag " & lvUsers.SelectedItem.Text, "0"))
End Sub

Private Sub lvGameUsers_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Button = 2 Then
        If Admin > 1 Then mnukick.Visible = True Else mnukick.Visible = False
        PopupMenu mnuplaying
    End If
End Sub

Private Sub lvUsers_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Not Me.tmrUpdate.Enabled Then Exit Sub
    If Button = 2 Then
        If lvUsers.ListItems.Count < 1 Then Exit Sub
        If IsMuzzled(lvUsers.SelectedItem.Text) Then muzz.Checked = True Else muzz.Checked = False
        PopupMenu opt
    End If
End Sub

Private Sub mnudisconnect_Click()
    sckMain.Disconnect
    sckMain.Cleanup
    Me.Hide
    frmLogin.Show
End Sub

Private Sub mainopt_Click()
    frmOptions.Show
End Sub

Private Sub mnuabout_Click()
    frmAbout.Show 1
End Sub

Private Sub mnubanlist_Click()
    ChatSend "/bans"
End Sub

Private Sub mnuBanSysID_Click()
    Dim BanTime As String
    BanTime = InputBox("Ban time in minutes.", "Unique System ID Ban" & lvUsers.SelectedItem.Text, "0")
    If BanTime = vbNullString Then Exit Sub
    ChatSend "/bansysid " & lvUsers.SelectedItem.Text & " " & Val(BanTime)
End Sub

Private Sub mnudstrgme_Click()
    Dim i As Integer
    i = Mid(frmMain.lvGames.SelectedItem.Key, 2)
    If ServerDat(i) Is Nothing Then Exit Sub
    If MsgBox("DESTROY " & ServerDat(i).sName & " ?", vbInformation Or vbYesNo, "Destroy Server") = vbNo Then Exit Sub
    ChatSend "/destroy " & i
End Sub

Private Sub mnueditprofile_Click()
    If Not tmrUpdate.Enabled Then Exit Sub
    Dim lNewMsg As Byte, lOffset As Long, i As Integer, Txt As String
    Dim oNewMsg() As Byte, lNewOffset As Long
    lNewMsg = MSG_PROFILEEDIT
    lNewOffset = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
    i = 1
    AddBufferData oNewMsg, VarPtr(i), LenB(i), lNewOffset
    SendTo oNewMsg
End Sub

Private Sub mnugaglist_Click()
    ChatSend "/gags"
End Sub

Private Sub mnugetpw_Click()
    Dim i As Integer
    i = Mid(frmMain.lvGames.SelectedItem.Key, 2)
    If ServerDat(i) Is Nothing Then Exit Sub
    ChatSend "/serverpw " & i
End Sub

Private Sub mnuhdban_Click()
    Dim BanTime As String
    BanTime = InputBox("Ban time in minutes.", "HD Serial BAN" & lvUsers.SelectedItem.Text, "0")
    If BanTime = vbNullString Then Exit Sub
    ChatSend "/hdban " & lvUsers.SelectedItem.Text & " " & Val(BanTime)
End Sub

Private Sub mnuhdbanlist_Click()
    ChatSend "/hdbans"
End Sub

Private Sub mnuicon_Click()
    If SetIcon > 0 Then ChatSend "/icon " & lvUsers.SelectedItem.Text & " " & SetIcon
End Sub

Private Sub mnuipban_Click()
    Dim BanTime As String
    BanTime = InputBox("Ban time in minutes.", "IP BAN" & lvUsers.SelectedItem.Text, "0")
    If BanTime = vbNullString Then Exit Sub
    ChatSend "/ipban " & lvUsers.SelectedItem.Text & " " & Val(BanTime)
End Sub

Private Sub mnuipbanlist_Click()
    ChatSend "/ipbans"
End Sub

Private Sub mnukick_Click()
    If MsgBox("Kick " & frmMain.lvGameUsers.SelectedItem.Text & " ?", vbInformation Or vbYesNo, "CFront") = vbNo Then Exit Sub
    mnukick.Caption = "Kick " & frmMain.lvGameUsers.SelectedItem.Text
    ChatSend "/softboot " & frmMain.lvGameUsers.SelectedItem.Text
End Sub

Private Sub mnuListIP_Click()
    ChatSend "/iplist"
End Sub

Private Sub mnuListSysIDBans_Click()
    ChatSend "/sysidbans"
End Sub

Private Sub mnunameban_Click()
    Dim BanTime As String
    BanTime = InputBox("Ban time in minutes.", "Name BAN" & lvUsers.SelectedItem.Text, "0")
    If BanTime = vbNullString Then Exit Sub
    ChatSend "/ban " & lvUsers.SelectedItem.Text & " " & Val(BanTime)
End Sub

Private Sub mnupage_Click()
    If Not tmrUpdate.Enabled Then Exit Sub
    ScreenNameBox = 1
    frmPageReq.Show
End Sub

Private Sub mnuprofile_Click()
    RequestProfile lvUsers.SelectedItem.Text
End Sub

Private Sub mnuprofile2_Click()
    If Not tmrUpdate.Enabled Then Exit Sub
    ScreenNameBox = 2
    frmPageReq.Show
End Sub

Private Sub mnuRoomList_Click()
    frmRooms.Show 1
End Sub

Private Sub mnushow_Click()
    On Error Resume Next
    Me.WindowState = vbNormal
    Me.Show
End Sub

Private Sub mnushowping_Click()
    Dim i As Integer
    i = Mid(frmMain.lvGameUsers.SelectedItem.Key, 2)
    ErrorMSG = "Ping for " & frmMain.lvGameUsers.SelectedItem.Text & " (" & svrPlayers(i).Ping & ")ms."
    RaiseInfo ErrorMSG
End Sub

Private Sub mnustats_Click()
    Dim stats As New frmStats, i As Integer
    If frmMain.lvGames.ListItems.Count = 0 Then Exit Sub
    i = Mid(frmMain.lvGames.SelectedItem.Key, 2)
    If i > UBound(ServerDat) Then Exit Sub
    If ServerDat(i) Is Nothing Then Exit Sub
    stats.Show
    stats.svrid = i
    stats.Timer1 = True
    stats.Caption = "Game Stats [" & ServerDat(i).sName & "]"
End Sub

Private Sub muzz_Click()
    MuzzleThem lvUsers.SelectedItem.Text
End Sub

Private Sub opage_Click()
    SendPage lvUsers.SelectedItem.Text, Chr(1)
End Sub

Private Sub owhisper_Click()
    txtChat = "/whisper " & lvUsers.SelectedItem.Text & " " & txtChat
    txtChat.SetFocus: txtChat.SelStart = Len(txtChat.Text)
End Sub

Private Sub plwhisper_Click()
    txtChat = "/whisper " & lvGameUsers.SelectedItem.Text & " " & txtChat
    txtChat.SetFocus: txtChat.SelStart = Len(txtChat)
End Sub

Private Sub reconnect_Click()
    frmLogin.Show
End Sub

Private Sub sckGamePing_Connect(Index As Integer)
    sckGamePing(Index).Cleanup
    If Index > UBound(ServerDat) Then Exit Sub
    If ServerDat(Index) Is Nothing Then Exit Sub
    ServerDat(Index).latency = NewGTC - ServerDat(Index).pingStart
    ServerDat(Index).Reachable = True
    PingRefresh
    'frmSignUp.Show
End Sub

Private Sub sckGamePing_LastError(Index As Integer, ErrorCode As Integer, ErrorString As String, Response As Integer)
    ServerDat(Index).Reachable = False
    PingRefresh
End Sub

Private Sub sckMain_Connect()
    ReDim Rooms(0)
    Set Rooms(0) = New clsChatRoom
    tmrDataArrival.Enabled = True
    If NewUser Then
        frmLogin.ShowNewUser
        Exit Sub
    End If
    If Not SigningUp Then
        SendEncSig
    End If
End Sub

Private Sub sckMain_Disconnect()
    sckMain.Disconnect
    sckMain.Cleanup
    EnableEncryption = False
    'DisEnable
    If Me.Visible Or Not frmLogin.Visible Then
        lvUsers.ListItems.Clear
        lvGames.ListItems.Clear
        lvGameUsers.ListItems.Clear
        txtGameDescription.Text = vbNullString
        AddChat "CFront", "You were disconnected from Cobalt."
        tmrReconnect.Enabled = True
        Exit Sub
    End If
    If Authenticated = True Then
        ErrorMSG = "Disconnected."
    Else
        ErrorMSG = "Disconnected. You might be IP banned or the server may be too busy to accept your request."
    End If
    RaiseError ErrorMSG
End Sub

Private Sub sckMain_LastError(ErrorCode As Integer, ErrorString As String, Response As Integer)
    If ErrorCode = WSAECONNABORTED Or ErrorCode = WSAECONNRESET Or ErrorCode = WSAECONNREFUSED Or ErrorCode = WSAEHOSTDOWN Or ErrorCode = WSAEHOSTUNREACH Or ErrorCode = WSANO_DATA Then
        'DisEnable
        If Me.Visible Or Not frmLogin.Visible Then
            AddChat "Cobalt", ErrorString
            tmrReconnect.Enabled = True
            Exit Sub
        End If
        ErrorMSG = ErrorString
        RaiseError ErrorMSG
    End If
End Sub

Private Sub sckMain_Read(DataLength As Integer, IsUrgent As Integer)
    Dim i As Long, NewData(32000) As Byte, DL As Long
    Static Data(32000) As Byte, DataLengthOld As Long
    DL = sckMain.ReadBytes(NewData(), 32000)
    If DataLength < 1 Or DataLength > 32000 Then Exit Sub
    CopyMemory Data(DataLengthOld), NewData(0), DL
    DataLengthOld = DataLengthOld + DL
    
    If Data(DataLengthOld - 1) = 3 Then
        i = DataLengthOld
        DataLengthOld = 0
        DataProcess Data, i, 0
    End If
End Sub

Private Sub sckMain_Timeout(Status As Integer, Response As Integer)
    'DisEnable
    If Me.Visible Or Not frmLogin.Visible Then
        AddChat "Cobalt", "Timed out connecting to Cobalt."
        tmrReconnect.Enabled = True
        Exit Sub
    End If
    
    ErrorMSG = "Connection attempt timed out."
    RaiseError ErrorMSG
End Sub

Private Sub tmrKeepAlive_Timer()
    Dim lNewMsg As Byte
    Dim oNewMsg() As Byte, lNewOffset As Long
    Dim i As Integer
    If KeepAlive Then
        lNewMsg = 0
        lNewOffset = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
        SendTo oNewMsg
    End If
    For i = 0 To lvGames.ListItems.Count
        MrB i
    Next
    PingRefresh
End Sub

Private Sub tmrReconnect_Timer()
    tmrReconnect.Enabled = False
    AddChat UserDat(0).Nick, "Reconnecting. . ."
    sckMain.Connect
End Sub

Public Sub OKCLient()
    CTime = -1
    'DisEnable False
    'Unload frmsignon
    frmLogin.Visible = False
    ZZZTick = NewGTC
    tmrUpdate.Enabled = True
    txtChat.Enabled = True
    cmdSend.Enabled = True
    uptime = Timer
    LoadMuzzle
    If Sleeping Then
        MeSleep 1
    End If
    Authenticated = True
    If Not Me.Visible Then Me.Show
    'DoEvents
    txtChat.SetFocus
End Sub

Private Sub tmrUpdate_Timer()
    Dim i As Integer, tDate As Date, l As Long, j As Integer
    If CLng(NewGTC - ZZZTick) > 240000 Then
        MeSleep 1
        ZZZTick = NewGTC
        Sleeping = True
    End If
    For i = 0 To UBound(PagerMSG)
        If PagerMSG(i).PName(0) <> vbNullString Then Exit For
    Next
    If Not PagerStat(1) Then
        If Not i > UBound(PagerMSG) Then
            If CLng(NewGTC - PageBeep) > 10000 Then
                PlayWAV "ringin.wav", False
                PageBeep = NewGTC
                AddChat "Cobalt", "You have received a private message request. Click 'Private Messages' to find out what it is!"
            End If
        End If
    End If
    CTime = CTime + 1
    l = CTime
    If ShowUptime Then Me.Caption = ProjectName & " Front End v" & App.Major & "." & Format$(App.Minor, "0") & "." & Format$(App.Revision, "0000") & " (" & Time & ") uptime: " & CLng((l - (l Mod 60)) / 60) & " minutes."
End Sub

Private Sub warn_Click()
    txtChat.Text = "/warn " & lvUsers.SelectedItem.Text & " "
    txtChat.SelStart = Len(txtChat.Text)
    txtChat.SetFocus
End Sub
