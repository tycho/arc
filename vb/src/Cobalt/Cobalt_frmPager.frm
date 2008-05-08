VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form frmPager 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Private Message Center"
   ClientHeight    =   3615
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7335
   Icon            =   "Cobalt_frmPager.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   241
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   489
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame Frame1 
      Caption         =   "Chat"
      Height          =   3015
      Left            =   2760
      TabIndex        =   7
      Top             =   120
      Width           =   4455
      Begin MSComctlLib.ListView lvChat 
         Height          =   2655
         Left            =   120
         TabIndex        =   8
         Top             =   240
         Width           =   4215
         _ExtentX        =   7435
         _ExtentY        =   4683
         Arrange         =   1
         LabelEdit       =   1
         LabelWrap       =   -1  'True
         HideSelection   =   -1  'True
         HideColumnHeaders=   -1  'True
         _Version        =   393217
         ForeColor       =   -2147483640
         BackColor       =   -2147483633
         Appearance      =   0
         NumItems        =   0
      End
   End
   Begin VB.Frame framPages 
      Caption         =   "Session List"
      Height          =   2895
      Left            =   120
      TabIndex        =   5
      Top             =   120
      Width           =   2535
      Begin MSComctlLib.ListView lvPages 
         Height          =   2535
         Left            =   120
         TabIndex        =   6
         Top             =   240
         Width           =   2295
         _ExtentX        =   4048
         _ExtentY        =   4471
         Arrange         =   1
         LabelEdit       =   1
         LabelWrap       =   -1  'True
         HideSelection   =   -1  'True
         HideColumnHeaders=   -1  'True
         _Version        =   393217
         ForeColor       =   -2147483640
         BackColor       =   -2147483633
         Appearance      =   0
         NumItems        =   0
      End
   End
   Begin VB.CommandButton cmdDismiss 
      Caption         =   "Dismiss"
      Height          =   375
      Left            =   1440
      TabIndex        =   4
      Top             =   3120
      Width           =   1215
   End
   Begin VB.CommandButton cmdAdd 
      Caption         =   "Add"
      Height          =   375
      Left            =   120
      TabIndex        =   3
      Top             =   3120
      Width           =   1215
   End
   Begin VB.CommandButton cmdSend 
      Caption         =   "Send"
      Default         =   -1  'True
      Height          =   315
      Left            =   6240
      TabIndex        =   1
      Top             =   3195
      Width           =   975
   End
   Begin VB.TextBox txtChat 
      Height          =   285
      Left            =   2760
      TabIndex        =   0
      Top             =   3210
      Width           =   3375
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Height          =   195
      Left            =   3000
      TabIndex        =   2
      Top             =   0
      Visible         =   0   'False
      Width           =   45
   End
End
Attribute VB_Name = "frmPager"
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
Public PagerIndex As Integer

Public Sub AddChat(Nick As String, ByVal Chat As String)
    Dim itmX As ListItem, s As String, addi As Boolean, i As Integer, j As Integer, X As Integer
    Set itmX = Me.lvChat.ListItems.Add()
    itmX.Text = Nick
    Chat = ": " & Chat
    For i = 1 To Len(Chat)
        s = Mid$(Chat, i, 1)
        Label1 = Label1 & s
        If Label1.Width > lvChat.Width - 10 Then
            For X = Len(Label1) To Len(Label1) - 15 Step -1
                If Mid$(Label1, X, 1) = " " Then Exit For
            Next
            If j = 0 Then itmX.SubItems(1) = Mid$(Label1, 1, X)
            If j = 1 Then lvChat.ListItems.Add.SubItems(1) = "  " & Mid$(Label1, 1, X)
            j = 1
            Label1 = Mid$(Label1, X + 1)
        End If
        If i = Len(Chat) And Label1 <> vbNullString And j = 1 Then lvChat.ListItems.Add.SubItems(1) = "  " & Label1: Label1 = vbNullString
        If i = Len(Chat) And Label1 <> vbNullString And j = 0 Then itmX.SubItems(1) = Label1: Label1 = vbNullString
    Next
    DoEvents
    Call SendMessage(lvChat.hwnd, WM_VSCROLL, SB_BOTTOM, ByVal 0&)
End Sub

Private Sub cmdAdd_Click()
    ScreenNameBox = 1
    lvPages.SetFocus
    frmPageReq.Show
End Sub

Private Sub cmdDismiss_Click()
    Dim i As Integer
    'On Error Resume Next
    If lvPages.ListItems.Count = 0 Then Exit Sub
    SendPage lvPages.SelectedItem.Text, Chr(5)
    For i = 1 To lvPages.ListItems.Count
        If lvPages.ListItems(i).Text = PagerMSG(PagerIndex).PName(0) Then
            If lvPages.ListItems(i).Selected Then
                lvChat.ListItems.Clear
            End If
            ReDim PagerMSG(PagerIndex).PName(0), PagerMSG(PagerIndex).Pages(0)
            lvPages.ListItems.Remove i
            If lvPages.ListItems.Count = 0 Then Unload Me
            Exit Sub
        End If
    Next
End Sub

Private Sub cmdSend_Click()
    Dim j As Integer
    If txtChat = vbNullString Then Exit Sub
    If PagerMSG(PagerIndex).PName(UBound(PagerMSG(PagerIndex).PName)) = "[END]" Then
        ErrorMSG = "This user has dismissed you."
        RaiseError ErrorMSG
        Exit Sub
    End If
    If frmMain.tmrUpdate.Enabled = False Then
        ErrorMSG = "Connect to Cobalt."
        RaiseError ErrorMSG
        Exit Sub
    End If
    j = UBound(PagerMSG(PagerIndex).Pages) + 1
    ReDim Preserve PagerMSG(PagerIndex).Pages(j)
    ReDim Preserve PagerMSG(PagerIndex).PName(j)
    PagerMSG(PagerIndex).PName(j) = UserName
    PagerMSG(PagerIndex).Pages(j) = txtChat
    AddChat UserName, txtChat
    SendPage PagerMSG(PagerIndex).PName(0), txtChat
    txtChat = vbNullString
End Sub

Private Sub Form_Load()
    On Error Resume Next
    Dim i As Long
    PagerStat(1) = True
    lvPages.ColumnHeaders.Add , , "Active Pages", lvPages.Width - 10
    lvPages.View = lvwReport
    lvChat.ColumnHeaders.Add , , "Nick", 800
    lvChat.ColumnHeaders.Add , , "Pages", lvChat.Width - 800
    lvChat.View = lvwReport
    For i = 0 To UBound(PagerMSG)
        If PagerMSG(i).PName(0) <> vbNullString Then
            lvPages.ListItems.Add , , PagerMSG(i).PName(0), 0, 0
            SendPage PagerMSG(i).PName(0), Chr(3)
        End If
    Next
    Dim j As Long
    For j = 0 To UBound(PagerMSG(0).Pages)
        AddChat PagerMSG(0).PName(j), PagerMSG(0).Pages(j)
    Next
    'If frmMain.WindowState <> vbNormal Then frmMain.WindowState = vbNormal
    Me.Top = frmMain.Top
    Me.Left = frmMain.Left
    lvPages.ListItems(1).Selected = True
End Sub
