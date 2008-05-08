VERSION 5.00
Begin VB.Form frmNewUser 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "New Account"
   ClientHeight    =   4695
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   4815
   Icon            =   "Cobalt_frmNewUser.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4695
   ScaleWidth      =   4815
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.TextBox txtLicenseAgreement 
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1455
      Left            =   120
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   10
      Top             =   2640
      Width           =   4575
   End
   Begin VB.TextBox txtUser 
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   360
      TabIndex        =   0
      Top             =   360
      Width           =   4335
   End
   Begin VB.TextBox txtPassword 
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      IMEMode         =   3  'DISABLE
      Left            =   360
      PasswordChar    =   "*"
      TabIndex        =   1
      Top             =   960
      Width           =   4335
   End
   Begin VB.TextBox txtPasswordV 
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      IMEMode         =   3  'DISABLE
      Left            =   360
      PasswordChar    =   "*"
      TabIndex        =   2
      Top             =   1560
      Width           =   4335
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   120
      TabIndex        =   4
      Top             =   4200
      Width           =   1095
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   3600
      TabIndex        =   5
      Top             =   4200
      Width           =   1095
   End
   Begin VB.ComboBox cmbYear 
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      ItemData        =   "Cobalt_frmNewUser.frx":1042
      Left            =   360
      List            =   "Cobalt_frmNewUser.frx":1044
      Style           =   2  'Dropdown List
      TabIndex        =   3
      Top             =   2160
      Width           =   4335
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Account Nickname"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   255
      Left            =   120
      TabIndex        =   9
      Top             =   120
      Width           =   3135
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "Account Password"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   255
      Left            =   120
      TabIndex        =   8
      Top             =   720
      Width           =   3135
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Account Password (retype)"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   255
      Left            =   120
      TabIndex        =   7
      Top             =   1320
      Width           =   3135
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "Year of Birth"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   255
      Left            =   120
      TabIndex        =   6
      Top             =   1920
      Width           =   3135
   End
End
Attribute VB_Name = "frmNewUser"
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

Private Sub txtUsername_KeyPress(KeyAscii As Integer)
    KeyAscii = Asc(UCase$(Chr$(KeyAscii)))
End Sub

Private Sub cmdCancel_Click()
    Unload Me
    frmLogin.Show
End Sub

Private Sub cmdOK_Click()
    SignMEUP
End Sub

Sub SignMEUP()
    ErrorMSG = vbNullString
    If txtUser = vbNullString Then ErrorMSG = "User name is required!"
    If Len(txtPassword.Text) < 5 Then ErrorMSG = "Your password must be at least (5) characters long."
    If txtPassword = vbNullString Then ErrorMSG = "Password required."
    If txtPassword <> txtPasswordV Then ErrorMSG = "Your password boxes do not match."
    If Year(Now) - cmbYear.Text < 13 Then ErrorMSG = "By law, you must be at least 13 years old to register for Cobalt or any other online service."
    If ErrorMSG <> vbNullString Then
        MsgBox ErrorMSG, vbExclamation, ProjectName
        Exit Sub
    End If
    Dim lNewMsg As Byte, lOffset As Long, i As Integer
    Dim oNewMsg() As Byte, lNewOffset As Long
    Me.Hide
    frmLogin.SetFocus
    lNewMsg = MSG_SIGNUP
    lNewOffset = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
    i = 12
    AddBufferData oNewMsg, VarPtr(i), LenB(i), lNewOffset
    AddBufferString oNewMsg, txtUser, lNewOffset, True
    AddBufferString oNewMsg, txtPassword, lNewOffset, True
    SendTo oNewMsg
    Unload Me
End Sub

Private Sub Form_Load()
    Dim i As Integer
    Dim d As Integer
    d = DateTime.Year(Now)
    cmbYear.Clear
    For i = 0 To 100
        cmbYear.AddItem d - i
    Next
    cmbYear.ListIndex = 0
    txtLicenseAgreement.Text = "By clicking OK, you agree to..." & vbCrLf & _
                            "1. Abide by the terms of the GNU Public License." & vbCrLf & _
                            "2. While this program is not designed to, nor is capable of altering functionality or damaging " & _
                            "any computer system, we cannot be held liable for any damages or changes. If you do not " & _
                            "agree to the terms and conditions, you should click 'Cancel' now."
End Sub
