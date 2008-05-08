VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.3#0"; "comctl32.ocx"
Begin VB.UserControl SierraStyledList 
   BackColor       =   &H00081421&
   ClientHeight    =   3495
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   7590
   ScaleHeight     =   233
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   506
   Begin VB.PictureBox picMouse 
      Height          =   495
      Left            =   600
      Picture         =   "SierraStyledList.ctx":0000
      ScaleHeight     =   435
      ScaleWidth      =   435
      TabIndex        =   9
      Top             =   2880
      Visible         =   0   'False
      Width           =   495
   End
   Begin VB.PictureBox imgLock 
      Appearance      =   0  'Flat
      BackColor       =   &H00081421&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   255
      Index           =   0
      Left            =   510
      ScaleHeight     =   255
      ScaleWidth      =   255
      TabIndex        =   8
      Top             =   195
      Width           =   255
   End
   Begin VB.PictureBox imgOfficial 
      Appearance      =   0  'Flat
      BackColor       =   &H00081421&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   255
      Index           =   0
      Left            =   195
      ScaleHeight     =   255
      ScaleWidth      =   255
      TabIndex        =   7
      Top             =   195
      Width           =   255
   End
   Begin VB.VScrollBar VScroll1 
      Enabled         =   0   'False
      Height          =   3495
      Left            =   7335
      Max             =   0
      TabIndex        =   5
      Top             =   0
      Width           =   255
   End
   Begin VB.Image imgStars 
      Height          =   495
      Index           =   0
      Left            =   240
      Top             =   480
      Visible         =   0   'False
      Width           =   1215
   End
   Begin VB.Label lblClickMe 
      BackStyle       =   0  'Transparent
      Height          =   615
      Index           =   0
      Left            =   120
      TabIndex        =   6
      Top             =   120
      Visible         =   0   'False
      Width           =   7215
   End
   Begin ComctlLib.ImageList ilStars 
      Index           =   5
      Left            =   3000
      Top             =   2280
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483646
      ImageWidth      =   110
      ImageHeight     =   16
      MaskColor       =   16777215
      _Version        =   327682
      BeginProperty Images {0713E8C2-850A-101B-AFC0-4210102A8DA7} 
         NumListImages   =   2
         BeginProperty ListImage1 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "SierraStyledList.ctx":0152
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "SierraStyledList.ctx":01A8
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin ComctlLib.ImageList ilStars 
      Index           =   4
      Left            =   2400
      Top             =   2280
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483646
      ImageWidth      =   86
      ImageHeight     =   16
      MaskColor       =   16777215
      _Version        =   327682
      BeginProperty Images {0713E8C2-850A-101B-AFC0-4210102A8DA7} 
         NumListImages   =   2
         BeginProperty ListImage1 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "SierraStyledList.ctx":16BA
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "SierraStyledList.ctx":1710
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin ComctlLib.ImageList ilStars 
      Index           =   3
      Left            =   1800
      Top             =   2280
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483646
      ImageWidth      =   62
      ImageHeight     =   16
      MaskColor       =   16777215
      _Version        =   327682
      BeginProperty Images {0713E8C2-850A-101B-AFC0-4210102A8DA7} 
         NumListImages   =   2
         BeginProperty ListImage1 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "SierraStyledList.ctx":27A2
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "SierraStyledList.ctx":27F8
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin ComctlLib.ImageList ilStars 
      Index           =   2
      Left            =   1200
      Top             =   2280
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483646
      ImageWidth      =   38
      ImageHeight     =   16
      MaskColor       =   16777215
      _Version        =   327682
      BeginProperty Images {0713E8C2-850A-101B-AFC0-4210102A8DA7} 
         NumListImages   =   2
         BeginProperty ListImage1 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "SierraStyledList.ctx":340A
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "SierraStyledList.ctx":3460
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin ComctlLib.ImageList ilStars 
      Index           =   1
      Left            =   600
      Top             =   2280
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483646
      ImageWidth      =   14
      ImageHeight     =   16
      MaskColor       =   16777215
      _Version        =   327682
      BeginProperty Images {0713E8C2-850A-101B-AFC0-4210102A8DA7} 
         NumListImages   =   2
         BeginProperty ListImage1 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "SierraStyledList.ctx":3BF2
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "SierraStyledList.ctx":3C48
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin ComctlLib.ImageList imgIcons 
      Left            =   0
      Top             =   2880
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   327682
      BeginProperty Images {0713E8C2-850A-101B-AFC0-4210102A8DA7} 
         NumListImages   =   4
         BeginProperty ListImage1 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "SierraStyledList.ctx":3F5A
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "SierraStyledList.ctx":42AC
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "SierraStyledList.ctx":45FE
            Key             =   ""
         EndProperty
         BeginProperty ListImage4 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "SierraStyledList.ctx":4950
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin ComctlLib.ImageList ilStars 
      Index           =   0
      Left            =   0
      Top             =   2280
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483646
      ImageWidth      =   1
      ImageHeight     =   1
      MaskColor       =   16777215
      _Version        =   327682
      BeginProperty Images {0713E8C2-850A-101B-AFC0-4210102A8DA7} 
         NumListImages   =   2
         BeginProperty ListImage1 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "SierraStyledList.ctx":4CA2
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "SierraStyledList.ctx":4CF8
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin VB.Image Stars 
      Height          =   225
      Index           =   0
      Left            =   720
      Picture         =   "SierraStyledList.ctx":4D4E
      Top             =   1440
      Visible         =   0   'False
      Width           =   225
   End
   Begin VB.Label lblPlayers 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Players: 0/16"
      BeginProperty Font 
         Name            =   "MS Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   0
      Left            =   5760
      TabIndex        =   4
      Tag             =   "Flexible width"
      Top             =   195
      Visible         =   0   'False
      Width           =   1455
   End
   Begin VB.Label lblMap 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "aplgo"
      BeginProperty Font 
         Name            =   "MS Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   0
      Left            =   3840
      TabIndex        =   3
      Tag             =   "Flexible width"
      Top             =   195
      Visible         =   0   'False
      Width           =   1935
   End
   Begin VB.Label lblPing 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Ping: 100"
      BeginProperty Font 
         Name            =   "MS Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   240
      Index           =   0
      Left            =   2160
      TabIndex        =   2
      Top             =   480
      Visible         =   0   'False
      Width           =   885
   End
   Begin VB.Label lblUnreach 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "** SERVER UNREACHABLE **"
      BeginProperty Font 
         Name            =   "MS Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   240
      Index           =   0
      Left            =   960
      TabIndex        =   1
      Top             =   480
      Visible         =   0   'False
      Width           =   3165
   End
   Begin VB.Label lblServerName 
      BackStyle       =   0  'Transparent
      Caption         =   "Sierra West Delta"
      BeginProperty Font 
         Name            =   "MS Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   0
      Left            =   960
      TabIndex        =   0
      Tag             =   "Flexible width"
      Top             =   195
      Visible         =   0   'False
      Width           =   2295
   End
   Begin VB.Shape shpServer 
      BorderColor     =   &H00FFFFFF&
      FillColor       =   &H00081421&
      FillStyle       =   0  'Solid
      Height          =   645
      Index           =   0
      Left            =   120
      Top             =   120
      Visible         =   0   'False
      Width           =   7215
   End
End
Attribute VB_Name = "SierraStyledList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Public Event Clicked(Index As Integer)
Public Event Join(Index As Integer)

Private Type Server
    Index As Integer
    ServerName As String
    Map As String
    Locked As Boolean
    Official As Boolean
    Players As Integer
    MaxPlayers As Integer
    Ping As Integer
    Active As Boolean
End Type

Private Type SortServer
    Ping As Integer
    OldIndex As Integer
    NewIndex As Integer
End Type

Private SortedIndexes() As Integer

Private LastWidth As Long
Private LastHeight As Long
Private LastServerCount As Long

Private Servers() As Server

Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (hpvDest As Any, hpvSource As Any, ByVal cbCopy As Long)

Public Function Count() As Integer
    Dim tmp As Integer
    Dim I As Integer
    For I = 0 To UBound(Servers)
        If Servers(I).Active Then
            tmp = tmp + 1
        End If
    Next
    Count = tmp
End Function

Public Sub ClearList()
    ReDim Servers(0)
    For I = 1 To shpServer.ubound
        Unload shpServer(I)
        Unload imgOfficial(I)
        Unload imgLock(I)
        Unload imgStars(I)
        Unload lblServerName(I)
        Unload lblMap(I)
        Unload lblPlayers(I)
        Unload lblUnreach(I)
        Unload lblPing(I)
        Unload lblClickMe(I)
    Next
End Sub

Private Sub LoadNew(Index As Integer)
    Load shpServer(Index)
    Load imgOfficial(Index)
    Load imgLock(Index)
    Load imgStars(Index)
    Load lblServerName(Index)
    Load lblMap(Index)
    Load lblPlayers(Index)
    Load lblUnreach(Index)
    Load lblPing(Index)
    Load lblClickMe(Index)
End Sub

Public Function Selected() As Integer
    For I = 0 To UBound(shpServer)
        If shpServer(I).FillColor = &H313431 Then
            Selected = I
        End If
    Next
End Function

Public Sub UpdateServer(ServerIndex, ServerName As String, Map As String, Players As Integer, MaxPlayers As Integer, Ping As Integer, Official As Boolean, Locked As Boolean)
    Servers(ServerIndex).ServerName = ServerName
    Servers(ServerIndex).Map = Map
    Servers(ServerIndex).Players = Players
    Servers(ServerIndex).MaxPlayers = MaxPlayers
    Servers(ServerIndex).Ping = Ping
    Servers(ServerIndex).Official = Official
    Servers(ServerIndex).Locked = Locked
    Servers(ServerIndex).Active = True
End Sub

Public Sub RemoveServer(ServerIndex)
    Servers(ServerIndex).ServerName = vbNullString
    Servers(ServerIndex).Map = vbNullString
    Servers(ServerIndex).Players = 0
    Servers(ServerIndex).MaxPlayers = 0
    Servers(ServerIndex).Ping = -1
    Servers(ServerIndex).Official = False
    Servers(ServerIndex).Locked = False
    Servers(ServerIndex).Active = False
    shpServer(ServerIndex).Visible = False
    lblServerName(ServerIndex).Visible = False
    lblPlayers(ServerIndex).Visible = False
    lblMap(ServerIndex).Visible = False
    imgLock(ServerIndex).Visible = False
    imgOfficial(ServerIndex).Visible = False
    lblClickMe(ServerIndex).Visible = False
    lblUnreach(ServerIndex).Visible = False
    lblPing(ServerIndex).Visible = False
    imgStars(ServerIndex).Visible = False
End Sub

Public Function AddServer(ServerName As String, Map As String, Players As Integer, MaxPlayers As Integer, Ping As Integer, Official As Boolean, Locked As Boolean)
    Dim I As Integer
    For I = 0 To shpServer.ubound
        If shpServer(I).Visible = False Then
            Exit For
        End If
    Next
    If I > shpServer.ubound Then
        LoadNew I
    End If
    If I > UBound(Servers) Then
        ReDim Preserve Servers(I)
    End If
    Servers(I).Index = I
    Servers(I).ServerName = ServerName
    Servers(I).Map = Map
    Servers(I).Locked = Locked
    Servers(I).Official = Official
    Servers(I).Ping = Ping
    Servers(I).Players = Players
    Servers(I).MaxPlayers = MaxPlayers
    Servers(I).Active = True
    AddServer = I
End Function

Public Sub UpdateList()
    Dim I As Integer
    For I = 0 To UBound(Servers)
        If Servers(I).Active Then
            imgLock(I).BackColor = &H81421
            imgOfficial(I).BackColor = &H81421
            imgIcons.BackColor = &H81421
            lblServerName(I) = Servers(I).ServerName
            lblMap(I) = Servers(I).Map
            lblPlayers(I) = "Players: " & Servers(I).Players & "/" & Servers(I).MaxPlayers
            If Servers(I).Players = Servers(I).MaxPlayers Then
                lblPlayers(I).ForeColor = vbRed
            Else
                lblPlayers(I).ForeColor = vbWhite
            End If
            If Servers(I).Official Then
                imgOfficial(I).Picture = imgIcons.Overlay(1, 2) 'imgIcons.ListImages(2).Picture
            Else
                imgOfficial(I).Picture = imgIcons.Overlay(1, 1) 'imgIcons.ListImages(1).Picture
            End If
            If Servers(I).Locked Then
                imgLock(I).Picture = imgIcons.Overlay(1, 4) 'imgIcons.ListImages(4).Picture
            Else
                imgLock(I).Picture = imgIcons.Overlay(1, 3) 'imgIcons.ListImages(3).Picture
            End If
            SetColour False
            PingIndex I
            lblServerName(I).Visible = True
            lblPlayers(I).Visible = True
            lblMap(I).Visible = True
            imgLock(I).Visible = True
            imgOfficial(I).Visible = True
            shpServer(I).Visible = True
            lblClickMe(I).Visible = True
            lblClickMe(I).Move shpServer(I).Left, shpServer(I).Top, shpServer(I).Width, shpServer(I).Height
            shpServer(I).FillColor = &H81421
            shpServer(I).ZOrder 1
            lblClickMe(I).ZOrder 0
        End If
    Next
    Dim PCSV As String
    Dim strPCSV() As String
    If UBound(Servers) > 0 Then
        PCSV = Sort(Servers)
        strPCSV = Split(PCSV, "|")
        ReDim SortedIndexes(UBound(strPCSV) - 1)
        For I = 0 To UBound(strPCSV) - 1
            SortedIndexes(I) = CInt(strPCSV(I))
        Next
    End If
    UserControl_Resize
End Sub

Private Sub lblClickMe_Click(Index As Integer)
    Dim I As Integer
    If shpServer(Index).FillColor = &H313431 Then
        RaiseEvent Join(Index)
    Else
        For I = 0 To shpServer.ubound
            If I <> Index Then
                shpServer(I).FillColor = &H81421
                imgLock(I).BackColor = &H81421
                imgOfficial(I).BackColor = &H81421
                imgIcons.BackColor = &H81421
                SetColour False
                If Servers(I).Official Then
                    imgOfficial(I).Picture = imgIcons.Overlay(1, 2) 'imgIcons.ListImages(2).Picture
                Else
                    imgOfficial(I).Picture = imgIcons.Overlay(1, 1) 'imgIcons.ListImages(1).Picture
                End If
                If Servers(I).Locked Then
                    imgLock(I).Picture = imgIcons.Overlay(1, 4) 'imgIcons.ListImages(4).Picture
                Else
                    imgLock(I).Picture = imgIcons.Overlay(1, 3) 'imgIcons.ListImages(3).Picture
                End If
                PingIndex I
            Else
                shpServer(I).FillColor = &H313431
                imgLock(I).BackColor = &H313431
                imgOfficial(I).BackColor = &H313431
                imgIcons.BackColor = &H313431
                SetColour True
                If Servers(I).Official Then
                    imgOfficial(I).Picture = imgIcons.Overlay(1, 2) 'imgIcons.ListImages(2).Picture
                Else
                    imgOfficial(I).Picture = imgIcons.Overlay(1, 1) 'imgIcons.ListImages(1).Picture
                End If
                If Servers(I).Locked Then
                    imgLock(I).Picture = imgIcons.Overlay(1, 4) 'imgIcons.ListImages(4).Picture
                Else
                    imgLock(I).Picture = imgIcons.Overlay(1, 3) 'imgIcons.ListImages(3).Picture
                End If
                PingIndex I
            End If
        Next
    End If
    UserControl.Refresh
    RaiseEvent Clicked(Index)
End Sub

Private Sub lblClickMe_DblClick(Index As Integer)
    Dim I As Integer
    For I = 0 To shpServer.ubound
        If I <> Index Then
            shpServer(I).FillColor = &H81421
            imgLock(I).BackColor = &H81421
            imgOfficial(I).BackColor = &H81421
            imgIcons.BackColor = &H81421
            SetColour False
            If Servers(I).Official Then
                imgOfficial(I).Picture = imgIcons.Overlay(1, 2) 'imgIcons.ListImages(2).Picture
            Else
                imgOfficial(I).Picture = imgIcons.Overlay(1, 1) 'imgIcons.ListImages(1).Picture
            End If
            If Servers(I).Locked Then
                imgLock(I).Picture = imgIcons.Overlay(1, 4) 'imgIcons.ListImages(4).Picture
            Else
                imgLock(I).Picture = imgIcons.Overlay(1, 3) 'imgIcons.ListImages(3).Picture
            End If
            PingIndex I
        Else
            shpServer(I).FillColor = &H313431
            imgLock(I).BackColor = &H313431
            imgOfficial(I).BackColor = &H313431
            imgIcons.BackColor = &H313431
            SetColour True
            If Servers(I).Official Then
                imgOfficial(I).Picture = imgIcons.Overlay(1, 2) 'imgIcons.ListImages(2).Picture
            Else
                imgOfficial(I).Picture = imgIcons.Overlay(1, 1) 'imgIcons.ListImages(1).Picture
            End If
            If Servers(I).Locked Then
                imgLock(I).Picture = imgIcons.Overlay(1, 4) 'imgIcons.ListImages(4).Picture
            Else
                imgLock(I).Picture = imgIcons.Overlay(1, 3) 'imgIcons.ListImages(3).Picture
            End If
            PingIndex I
        End If
    Next
    RaiseEvent Clicked(Index)
    RaiseEvent Join(Index)
End Sub

Private Sub lblClickMe_MouseDown(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)
    lblClickMe(Index).MousePointer = vbCustom
    lblClickMe(Index).MouseIcon = picMouse.Picture
End Sub

Private Sub lblClickMe_MouseUp(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)
    lblClickMe(Index).MousePointer = vbDefault
    lblClickMe(Index).MouseIcon = Nothing
End Sub

Private Sub UserControl_Initialize()
    Dim I As Integer
    ReDim Servers(0)
    imgIcons.MaskColor = vbGreen
    imgIcons.BackColor = UserControl.BackColor
    For I = 0 To ilStars.ubound
        ilStars(I).MaskColor = vbBlue
        ilStars(I).BackColor = &H81421
    Next
End Sub

Private Sub UserControl_Resize()
    VScroll1.Move UserControl.ScaleWidth - VScroll1.Width, 0, VScroll1.Width, UserControl.ScaleHeight
    Dim I As Long, J As Long
    Dim NextTop As Integer
    If UserControl.ScaleWidth < 500 Then
        UserControl.Width = Screen.TwipsPerPixelX * 500
    End If
    If UserControl.ScaleHeight < 50 Then
        UserControl.Height = Screen.TwipsPerPixelY * 50
    End If
    'If UserControl.ScaleWidth = LastWidth And UserControl.ScaleHeight = LastHeight And LastServerCount = UBound(Servers) Then
    '    Exit Sub
    'Else
    '    LastWidth = UserControl.ScaleWidth
    '    LastHeight = UserControl.ScaleHeight
    '    LastServerCount = UBound(Servers)
    'End If
    NextTop = 8
    AssertArray SortedIndexes
    For J = 0 To UBound(SortedIndexes)
        I = SortedIndexes(J)
        If Servers(I).Active Then
            shpServer(I).Move 8, NextTop, UserControl.ScaleWidth - 25, 43
            lblClickMe(I).Move 8, NextTop, UserControl.ScaleWidth - 25, 43
            imgOfficial(I).Move shpServer(I).Left + 8, shpServer(I).Top + 5
            imgLock(I).Move imgOfficial(I).Left + 24, imgOfficial(I).Top
            lblServerName(I).Move shpServer(I).Left + 56, shpServer(I).Top + 5, shpServer(I).Width * 0.3
            imgStars(I).Move shpServer(I).Left + 4, shpServer(I).Top + 22
            lblUnreach(I).Move lblServerName(I).Left, lblServerName(I).Top + 19
            lblPing(I).Move 140, lblUnreach(I).Top
            lblPlayers(I).Move shpServer(I).Width - 97, lblServerName(I).Top
            lblMap(I).Move shpServer(I).Left + 150, lblServerName(I).Top, shpServer(I).Width - lblServerName(I).Width - lblPlayers(I).Width - 8  'lblPlayers(I).Left - lblPlayers(I).Width - (shpServer(I).Width * 0.2), lblServerName(I).Top
            NextTop = NextTop + shpServer(I).Height + 4
        End If
    Next
End Sub

Private Function Sort(intArray() As Server) As String
    Dim SortArray() As SortServer
    Dim Finished As Boolean
    Dim strTemp As String, intCounter As Integer, EventLoop As Integer
    Dim I As Integer, intTemp As Integer, intTemp1 As Integer
    ReDim SortArray(UBound(intArray))
    Finished = False
    For I = 0 To UBound(intArray)
        SortArray(I).Ping = intArray(I).Ping
        SortArray(I).OldIndex = intArray(I).Index
        SortArray(I).NewIndex = intArray(I).Index
    Next
    For EventLoop = 0 To UBound(SortArray)
        For intCounter = 0 To UBound(SortArray) - 1
            If SortArray(intCounter).Ping > SortArray(intCounter + 1).Ping Then
                intTemp = SortArray(intCounter).Ping
                intTemp1 = SortArray(intCounter).NewIndex
                SortArray(intCounter).Ping = SortArray(intCounter + 1).Ping
                SortArray(intCounter).NewIndex = SortArray(intCounter + 1).NewIndex
                SortArray(intCounter + 1).Ping = intTemp
                SortArray(intCounter + 1).NewIndex = intTemp1
            End If
        Next intCounter
    Next EventLoop
    For intCounter = 0 To UBound(SortArray)
        strTemp = strTemp & SortArray(intCounter).NewIndex & "|"
    Next intCounter
    Sort = strTemp
End Function

Private Sub AssertArray(iArray() As Integer)
    On Error GoTo errors
    Dim I As Long
    I = UBound(iArray)
    Exit Sub
errors:
    ReDim iArray(0)
    iArray(0) = 0
End Sub

Private Function PingIndex(ServerIndex As Integer) As Integer
    If Not Servers(ServerIndex).Active Then Exit Function
    If Servers(ServerIndex).Ping < 0 Then 'unreachable
        imgStars(ServerIndex).Visible = False
        lblPing(ServerIndex).Visible = False
        lblUnreach(ServerIndex).Visible = True
    ElseIf Servers(ServerIndex).Ping <= 50 And Servers(ServerIndex).Ping >= 0 Then '5 stars 0-50
        PingIndex = 5
        imgStars(ServerIndex).Picture = ilStars(5).Overlay(1, 2)
        lblPing(ServerIndex).ForeColor = vbGreen
    ElseIf Servers(ServerIndex).Ping <= 100 And Servers(ServerIndex).Ping > 50 Then '4.5 stars 51-100
        PingIndex = 5
        imgStars(ServerIndex).Picture = ilStars(5).Overlay(1, 2)
        imgStars(ServerIndex).Width = imgStars(ServerIndex).Width - 6
        lblPing(ServerIndex).ForeColor = vbGreen
    ElseIf Servers(ServerIndex).Ping <= 120 And Servers(ServerIndex).Ping > 100 Then '4 stars 101-120
        PingIndex = 4
        imgStars(ServerIndex).Picture = ilStars(4).Overlay(1, 2)
        lblPing(ServerIndex).ForeColor = vbGreen
    ElseIf Servers(ServerIndex).Ping <= 140 And Servers(ServerIndex).Ping > 120 Then '3.5 stars 121-140
        PingIndex = 4
        imgStars(ServerIndex).Picture = ilStars(4).Overlay(1, 2)
        imgStars(ServerIndex).Width = imgStars(ServerIndex).Width - 6
        lblPing(ServerIndex).ForeColor = vbGreen
    ElseIf Servers(ServerIndex).Ping <= 160 And Servers(ServerIndex).Ping > 140 Then '3 stars 141-160
        PingIndex = 3
        imgStars(ServerIndex).Picture = ilStars(3).Overlay(1, 2)
        lblPing(ServerIndex).ForeColor = vbYellow
    ElseIf Servers(ServerIndex).Ping <= 180 And Servers(ServerIndex).Ping > 160 Then '2.5 stars 161-180
        PingIndex = 3
        imgStars(ServerIndex).Picture = ilStars(3).Overlay(1, 2)
        imgStars(ServerIndex).Width = imgStars(ServerIndex).Width - 6
        lblPing(ServerIndex).ForeColor = vbYellow
    ElseIf Servers(ServerIndex).Ping <= 200 And Servers(ServerIndex).Ping > 180 Then '2 stars 181-200
        PingIndex = 2
        imgStars(ServerIndex).Picture = ilStars(2).Overlay(1, 2)
        lblPing(ServerIndex).ForeColor = vbRed
    ElseIf Servers(ServerIndex).Ping <= 220 And Servers(ServerIndex).Ping > 200 Then '1.5 stars 201-220
        PingIndex = 2
        imgStars(ServerIndex).Picture = ilStars(2).Overlay(1, 2)
        lblPing(ServerIndex).ForeColor = vbRed
        imgStars(ServerIndex).Width = imgStars(ServerIndex).Width - 6
    ElseIf Servers(ServerIndex).Ping <= 240 And Servers(ServerIndex).Ping > 220 Then '1 star 221-240
        PingIndex = 1
        imgStars(ServerIndex).Picture = ilStars(1).Overlay(1, 2)
        lblPing(ServerIndex).ForeColor = vbRed
    ElseIf Servers(ServerIndex).Ping > 240 Then
        PingIndex = 1
        imgStars(ServerIndex).Picture = ilStars(1).Overlay(1, 2)
        imgStars(ServerIndex).Width = imgStars(ServerIndex).Width - 6
        lblPing(ServerIndex).ForeColor = vbRed
    End If
    If Servers(ServerIndex).Ping >= 0 Then
        lblPing(ServerIndex).Caption = "Ping: " & Servers(ServerIndex).Ping
        imgStars(ServerIndex).Visible = True
        lblUnreach(ServerIndex).Visible = False
        lblPing(ServerIndex).Visible = True
    End If
End Function

Private Sub SetColour(Selected As Boolean)
    Dim I As Integer
    For I = 0 To ilStars.ubound
        If Selected Then
            ilStars(I).BackColor = &H313431
        Else
            ilStars(I).BackColor = &H81421
        End If
    Next
End Sub
