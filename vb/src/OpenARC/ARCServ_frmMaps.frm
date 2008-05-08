VERSION 5.00
Begin VB.Form frmMaps 
   BorderStyle     =   1  'Fixed Single
   ClientHeight    =   2850
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   5070
   Icon            =   "ARCServ_frmMaps.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2850
   ScaleWidth      =   5070
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton cmdOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   3120
      Style           =   1  'Graphical
      TabIndex        =   1
      Top             =   2400
      Width           =   1095
   End
   Begin VB.FileListBox File1 
      Height          =   2625
      Left            =   120
      Pattern         =   "*.map"
      TabIndex        =   0
      Top             =   120
      Width           =   2175
   End
   Begin VB.Label lblMapDescription 
      BorderStyle     =   1  'Fixed Single
      Height          =   1335
      Left            =   2400
      TabIndex        =   5
      Top             =   960
      Width           =   2535
   End
   Begin VB.Label Label3 
      Alignment       =   2  'Center
      Caption         =   "Map Description"
      Height          =   255
      Left            =   2400
      TabIndex        =   4
      Top             =   720
      Width           =   2535
   End
   Begin VB.Label lblMapTitle 
      Alignment       =   2  'Center
      BorderStyle     =   1  'Fixed Single
      Height          =   255
      Left            =   2400
      TabIndex        =   3
      Top             =   360
      Width           =   2535
   End
   Begin VB.Label Label1 
      Alignment       =   2  'Center
      Caption         =   "Map Name"
      Height          =   255
      Left            =   2400
      TabIndex        =   2
      Top             =   120
      Width           =   2535
   End
End
Attribute VB_Name = "frmMaps"
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
Option Compare Text
Dim LastFileName As String

Private Sub cmdOK_Click()
    LastFileName = Filename
    MapPlay = Mid$(Filename, InStrRev(Filename, "\") + 1)
    Unload Me
End Sub

Private Sub File1_Click()
    Filename = AppPath & "maps\" & File1.List(File1.ListIndex)
    LoadMap False
    lblMapTitle.Caption = HDataNames.hExtendedName
    lblMapDescription.Caption = HDataNames.hDescription
End Sub

Private Sub File1_DblClick()
    Filename = AppPath & "maps\" & File1.List(File1.ListIndex)
    LoadMap False
    lblMapTitle.Caption = HDataNames.hExtendedName
    lblMapDescription.Caption = HDataNames.hDescription
    LastFileName = Filename
    MapPlay = Mid$(Filename, InStrRev(Filename, "\") + 1)
    Unload Me
End Sub

Private Sub Form_Load()
    On Error GoTo errors
    Me.Caption = ProjectName & " Server - Map Selection"
    LastFileName = Filename
    File1.Path = AppPath & "maps"
    File1.Pattern = "*.map"
    Exit Sub
errors:
    MsgBox "The maps directory is either nonexistent or empty!", vbExclamation, App.Title
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Filename = LastFileName
End Sub
