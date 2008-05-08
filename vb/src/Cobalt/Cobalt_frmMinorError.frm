VERSION 5.00
Begin VB.Form frmError 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Error"
   ClientHeight    =   2655
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   4575
   ControlBox      =   0   'False
   Icon            =   "Cobalt_frmMinorError.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2655
   ScaleWidth      =   4575
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmdEnd 
      Caption         =   "&End Program"
      Height          =   495
      Left            =   2340
      TabIndex        =   3
      Top             =   2040
      Width           =   1575
   End
   Begin VB.CommandButton cmdIgnore 
      Caption         =   "&Ignore"
      Height          =   495
      Left            =   660
      TabIndex        =   2
      Top             =   2040
      Width           =   1575
   End
   Begin VB.Frame Frame1 
      Caption         =   "Message"
      Height          =   1695
      Left            =   720
      TabIndex        =   0
      Top             =   120
      Width           =   3735
      Begin VB.Label lblErrorMessage 
         Height          =   1335
         Left            =   120
         TabIndex        =   1
         Top             =   240
         Width           =   3495
      End
   End
   Begin VB.Image imgExclamation 
      Height          =   480
      Left            =   120
      Picture         =   "Cobalt_frmMinorError.frx":1042
      Top             =   360
      Width           =   465
   End
End
Attribute VB_Name = "frmError"
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

Private Sub cmdEnd_Click()
    End
End Sub

Private Sub cmdIgnore_Click()
    Unload Me
End Sub

Private Sub Form_Load()
    MakeAlwaysOnTop Me, True
End Sub
