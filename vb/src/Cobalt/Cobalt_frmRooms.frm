VERSION 5.00
Begin VB.Form frmRooms 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Select a Room"
   ClientHeight    =   3120
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   3735
   ForeColor       =   &H00FFFFFF&
   Icon            =   "Cobalt_frmRooms.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3120
   ScaleWidth      =   3735
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton cmdCancel 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   2520
      TabIndex        =   3
      Top             =   2640
      Width           =   1095
   End
   Begin VB.CommandButton cmdCreate 
      Caption         =   "Create"
      Height          =   375
      Left            =   1320
      TabIndex        =   2
      Top             =   2640
      Width           =   1095
   End
   Begin VB.CommandButton cmdJoin 
      Caption         =   "Join"
      Default         =   -1  'True
      Height          =   375
      Left            =   120
      TabIndex        =   1
      Top             =   2640
      Width           =   1095
   End
   Begin VB.ListBox lstRooms 
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   2460
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   3495
   End
End
Attribute VB_Name = "frmRooms"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub cmdCancel_Click()
    Unload Me
End Sub

Private Sub cmdCreate_Click()
    frmNewRoom.Show 1
    Unload Me
End Sub

Private Sub cmdJoin_Click()
    If lstRooms.Text = vbNullString Then
        Unload Me
        Exit Sub
    End If
    Dim oNewMsg() As Byte, lNewOffset As Long, lNewMsg As Byte, X As Integer
    lNewMsg = MSG_JOINROOM
    ReDim oNewMsg(0)
    lNewOffset = 0
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
    X = -1
    For i = 0 To UBound(Rooms)
        If Rooms(i).RoomName = lstRooms.Text Then
            X = Rooms(i).RoomIndex
            Exit For
        End If
    Next
    If X = -1 Then Exit Sub
    AddBufferData oNewMsg, VarPtr(X), LenB(X), lNewOffset
    SendTo oNewMsg
    Unload Me
End Sub

Private Sub Form_Load()
    For i = 0 To UBound(Rooms)
        If Rooms(i).RoomName <> vbNullString Then
            lstRooms.AddItem Rooms(i).RoomName
        End If
    Next
End Sub

Private Sub lstRooms_DblClick()
    Dim oNewMsg() As Byte, lNewOffset As Long, lNewMsg As Byte, X As Integer
    lNewMsg = MSG_JOINROOM
    ReDim oNewMsg(0)
    lNewOffset = 0
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffset
    X = -1
    For i = 0 To UBound(Rooms)
        If Rooms(i).RoomName = lstRooms.Text Then
            X = Rooms(i).RoomIndex
            Exit For
        End If
    Next
    If X = -1 Then Exit Sub
    AddBufferData oNewMsg, VarPtr(X), LenB(X), lNewOffset
    SendTo oNewMsg
    Unload Me
End Sub
