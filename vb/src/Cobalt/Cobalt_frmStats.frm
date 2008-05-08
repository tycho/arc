VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form frmStats 
   BackColor       =   &H00000000&
   BorderStyle     =   1  'Fixed Single
   ClientHeight    =   2910
   ClientLeft      =   150
   ClientTop       =   720
   ClientWidth     =   6510
   Icon            =   "Cobalt_frmStats.frx":0000
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   ScaleHeight     =   2910
   ScaleWidth      =   6510
   StartUpPosition =   3  'Windows Default
   Begin MSComctlLib.ListView ListView1 
      Height          =   2895
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   6495
      _ExtentX        =   11456
      _ExtentY        =   5106
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      FullRowSelect   =   -1  'True
      _Version        =   393217
      ForeColor       =   65535
      BackColor       =   0
      Appearance      =   0
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      NumItems        =   0
   End
   Begin VB.Timer Timer1 
      Enabled         =   0   'False
      Interval        =   1000
      Left            =   120
      Top             =   3120
   End
   Begin VB.Menu mnuedit 
      Caption         =   "Edit"
      Begin VB.Menu mnucopy 
         Caption         =   "Copy all"
      End
   End
End
Attribute VB_Name = "frmStats"
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
Public svrid As Integer

Private Sub Form_Load()
    ListView1.ColumnHeaders.Add , , "Name", 2000
    ListView1.ColumnHeaders.Add , , "Ping", 800
    ListView1.ColumnHeaders.Add , , "Caps", 800
    ListView1.ColumnHeaders.Add , , "Frags", 800
    ListView1.ColumnHeaders.Add , , "Deaths", 800
    ListView1.ColumnHeaders.Add , , "Durration", 1000
    ListView1.View = lvwReport
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Set frmStats = Nothing
End Sub

Private Sub mnucopy_Click()
    Dim j As Long, s As String
    For j = 1 To ListView1.ListItems.Count
        If ListView1.ListItems(j).Text <> vbNullString Then
            s = s & vbNewLine
            s = s & ListView1.ListItems(j).Text
            s = s & " / Ping: " & ListView1.ListItems(j).SubItems(1)
            s = s & " / Caps: " & ListView1.ListItems(j).SubItems(2)
            s = s & " / Frags: " & ListView1.ListItems(j).SubItems(3)
            s = s & " / Deaths: " & ListView1.ListItems(j).SubItems(4)
            s = s & " / Durration: " & ListView1.ListItems(j).SubItems(5)
        Else
            s = s & Mid(ListView1.ListItems(j).SubItems(1), 3)
        End If
    Next
    Clipboard.Clear
    Clipboard.SetText Mid(s, 3)
End Sub

Private Sub Timer1_Timer()
    Dim itmX As ListItem, i As Integer, j As Integer, p As Integer
    Dim itmSubX As ListSubItem, strtime As String
    On Error GoTo clearall
    If svrid > UBound(ServerDat) Then
        Timer1.Enabled = False
        Exit Sub
    End If
    If ServerDat(svrid) Is Nothing Then
        Timer1.Enabled = False
        Exit Sub
    End If
    For j = 1 To ListView1.ListItems.Count
        p = Mid(ListView1.ListItems(j).Key, 1, Len(ListView1.ListItems(j).Key) - 1)
        For i = 0 To UBound(svrPlayers)
            If svrPlayers(i).ServerID = svrid And svrPlayers(i).playerID = p Then Exit For
        Next
        If i > UBound(svrPlayers) Then
            ListView1.ListItems.Remove j
            Exit Sub
        End If
    Next
    
    For i = 0 To UBound(svrPlayers)
        If svrPlayers(i).ServerID = svrid And svrPlayers(i).playerID > 0 Then
            If svrPlayers(i).Ship <> 0 And svrPlayers(i).ScreenName <> vbNullString Then
                For j = 1 To ListView1.ListItems.Count
                    p = Mid(ListView1.ListItems(j).Key, 1, Len(ListView1.ListItems(j).Key) - 1)
                    If p = svrPlayers(i).playerID Then Exit For
                Next
                If j > ListView1.ListItems.Count Then
                    Set itmX = ListView1.ListItems.Add()
                    itmX.Key = svrPlayers(i).playerID & "K"
                Else
                    Set itmX = ListView1.ListItems.Item(j)
                End If
                itmX.Text = svrPlayers(i).ScreenName
                itmX.ForeColor = Choose(svrPlayers(i).Ship, RGB(1, 254, 1), RGB(254, 1, 1), RGB(1, 1, 254), RGB(254, 254, 1), RGB(254, 254, 254))
                itmX.SubItems(1) = svrPlayers(i).Ping
                itmX.SubItems(2) = svrPlayers(i).Caps
                itmX.SubItems(3) = svrPlayers(i).Frags
                itmX.SubItems(4) = svrPlayers(i).Deaths
                strtime = Fix(svrPlayers(i).Time / 1000 / 60) & ":" & CInt((svrPlayers(i).Time / 1000) Mod 60)
                itmX.SubItems(5) = strtime
            End If
        End If
    Next
    Exit Sub
clearall:
    ListView1.ListItems.Clear
End Sub
