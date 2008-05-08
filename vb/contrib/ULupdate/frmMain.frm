VERSION 5.00
Object = "{48E59290-9880-11CF-9754-00AA00C00908}#1.0#0"; "msinet.ocx"
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.3#0"; "COMCTL32.OCX"
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "mswinsck.ocx"
Begin VB.Form frmMain 
   BorderStyle     =   3  'Fixed Dialog
   ClientHeight    =   1575
   ClientLeft      =   45
   ClientTop       =   45
   ClientWidth     =   4545
   ControlBox      =   0   'False
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "Automatic Update Program"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1575
   ScaleWidth      =   4545
   ShowInTaskbar   =   0   'False
   Visible         =   0   'False
   Begin MSWinsockLib.Winsock WS 
      Left            =   4320
      Top             =   1440
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.Timer tmrUnload 
      Enabled         =   0   'False
      Interval        =   20
      Left            =   1680
      Top             =   600
   End
   Begin ComctlLib.ProgressBar prgDL 
      Height          =   255
      Left            =   240
      TabIndex        =   5
      Top             =   840
      Visible         =   0   'False
      Width           =   4095
      _ExtentX        =   7223
      _ExtentY        =   450
      _Version        =   327682
      Appearance      =   1
   End
   Begin VB.Timer tmrHeight 
      Enabled         =   0   'False
      Interval        =   20
      Left            =   2160
      Top             =   600
   End
   Begin VB.PictureBox picBack 
      Align           =   1  'Align Top
      Height          =   1575
      Left            =   0
      Picture         =   "frmMain.frx":628A
      ScaleHeight     =   101
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   299
      TabIndex        =   0
      Top             =   0
      Width           =   4545
      Begin VB.CommandButton cmdNo 
         Caption         =   "No"
         CausesValidation=   0   'False
         Height          =   375
         Left            =   1200
         TabIndex        =   4
         Top             =   1080
         Visible         =   0   'False
         Width           =   975
      End
      Begin VB.CommandButton cmdYes 
         Caption         =   "Yes"
         Height          =   375
         Left            =   120
         TabIndex        =   3
         Top             =   1080
         Visible         =   0   'False
         Width           =   975
      End
      Begin VB.Label lblTitle 
         Alignment       =   2  'Center
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Uplink Laboratories Auto-Update"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   9
            Charset         =   161
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FF0000&
         Height          =   210
         Left            =   765
         TabIndex        =   2
         Top             =   60
         Width           =   3030
      End
      Begin VB.Label lblSpecifics 
         Alignment       =   2  'Center
         BackStyle       =   0  'Transparent
         Caption         =   "An update for %softwaretitle% is available. Would you like to download it now?"
         ForeColor       =   &H00FF0000&
         Height          =   915
         Left            =   165
         TabIndex        =   1
         Top             =   300
         Width           =   4215
      End
   End
   Begin InetCtlsObjects.Inet Inet1 
      Left            =   2760
      Top             =   1440
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim theindex As Integer
Public Forced As Boolean
Dim File As String
Dim TMP
Dim Ad As String
Dim X As Integer
Dim I As Integer
Dim File2 As String
Dim Rec As String
Dim Num As Integer
Dim FSize As String
Dim Temp2 As String
Dim Str As String
Dim ErrorReturned As Boolean
Dim N As Integer
Public FileNum As Integer
Public Event UnloadSystem()

Sub InitPos()
    Dim WindowRect As RECT
    SystemParametersInfo SPI_GETWORKAREA, 0, WindowRect, 0
    Me.Top = WindowRect.Bottom * Screen.TwipsPerPixelY - Me.Height
    Me.Left = WindowRect.Right * Screen.TwipsPerPixelX - Me.Width
End Sub

Private Sub cmdNo_Click()
    cmdYes.Visible = False
    cmdNo.Visible = False
    tmrUnload.Enabled = True
End Sub

Public Sub cmdYes_Click()
    On Error GoTo errors
    cmdYes.Visible = False
    cmdNo.Visible = False
    If N <> 1 Then
        prgDL.Visible = True
        lblSpecifics.Caption = "Connecting..."
        DownloadFile
        N = 1
    Else
        Shell File2, vbNormalFocus
        RaiseEvent UnloadSystem
    End If
    Exit Sub
errors:
    With Me
        .lblSpecifics.Caption = "The automatic update system failed to download updates. Please manually update by visiting the website!"
        SetWindowPos .hwnd, conHwndTopmost, .Left / 15, .Top / 15, .Width / 15, .Height / 15, conSwpNoActivate Or conSwpShowWindow
        .Forced = True
        .prgDL.Visible = False
        .cmdYes.Visible = False
        .cmdNo.Visible = False
        .tmrUnload.Interval = 5000
        .tmrUnload.Enabled = True
        .Show
    End With
End Sub

Private Sub Form_Load()
    Me.Height = 120
    tmrHeight.Enabled = True
End Sub

Private Sub tmrHeight_Timer()
    Me.Height = Me.Height + 100 '200
    InitPos
    If ErrorReturned = True Or Forced = True Then
        cmdYes.Visible = False
        cmdNo.Visible = False
    End If
    If Me.Height >= 1665 Then
        Me.Height = 1665
        tmrHeight.Enabled = False
        If ErrorReturned = False And Forced = False Then
            cmdYes.Visible = True
            cmdNo.Visible = True
        Else
            cmdYes.Visible = False
            cmdNo.Visible = False
        End If
        InitPos
        Me.Refresh
        DoEvents
    End If
End Sub

Private Sub tmrUnload_Timer()
    tmrUnload.Interval = 20 '40
    Me.Height = Me.Height - 100 '200
    InitPos
    Me.Refresh
    DoEvents
    If Me.Height <= 120 Then
        Me.Height = 120
        Unload Me
    End If
End Sub

Sub DownloadFile(Optional Index As Integer = 0)
    'Dim Ad As String
    cmdYes.Visible = False
    cmdNo.Visible = False
    theindex = Index
    Ad = DLFile(Index) 'here is the long messy and confusing process of
    If Ad = "" Then Err.Raise vbObjectError
    'seperating the address, file path, and file name
    'make sure ur only using /'s or else this wont work
    'If Ad = "" Then Exit Sub
    Ad = Replace(Ad, "http://", "")
    X = 0
    Do Until X = Len(Ad)    'scans for the first /
        DoEvents
        X = X + 1
        If Mid$(Ad, X, 1) = "/" Then
            File = Mid$(Ad, X, Len(Ad))  'gets the end...the file path
            Ad = Mid$(Ad, 1, X - 1)
            Exit Do
        End If
    Loop
    File2 = File
    TMP = Split(File2, "/")
    File2 = TMP(UBound(TMP))
    File2 = App.Path & "\" & GetFileW(DLFile(Index))
    If FileExist(File2) = True Then
        Kill File2
    End If
    'lblS.Caption = File2
    
    WS.Close    'closes winsock
    WS.Connect Ad, 80   'connects to the address on port 80
    lblSpecifics.Caption = "Connecting to: " & Ad
End Sub

Private Sub WS_Connect()
    Dim Header As String
    lblSpecifics.Caption = "Connected, requesting " & File
    'this prepares our header
    Header = Header & "GET " & File & " HTTP/1.1" & vbCrLf
    Header = Header & "Host: " & Ad & vbCrLf
    Header = Header & "User-Agent: ULupdate Downloader\1.0" & vbCrLf
    Header = Header & "Accept: */*" & vbCrLf
    WS.SendData Header & vbCrLf 'sends the header
End Sub

Private Sub WS_DataArrival(ByVal bytesTotal As Long)
    Dim B As Long
    Dim C As Single
    Dim StatusCode As Integer
    Dim Data As String
    Dim Temp As Long
    If bytesTotal < 1 Then Exit Sub
    WS.GetData Data, vbString 'gets the data that is sent
    Num = 0
    'Debug.Print "---" & vbCrLf & Data
    If LenB(Data) > 0 And InStr(1, LCase$(Data), LCase$("HTTP")) Then  'processes the servers response for the file size
        'Debug.Print Data
        Dim X
        X = Split(Data, vbCrLf)
        If Left$(X(0), 4) = "HTTP" Then
            StatusCode = Mid$(X(0), 10, 3)
        End If
        If StatusCode = "404" Then
            cmdYes.Visible = False
            cmdNo.Visible = False
            prgDL.Visible = False
            lblSpecifics.Caption = "The file could not be located on the server. This error is most likely at the fault of Uplink Laboratories staff. Please report this to them:" & vbCrLf & "staff@uplinklabs.net"
            ErrorReturned = True
            tmrUnload.Interval = 5000
            tmrUnload.Enabled = True
            Exit Sub
        End If
        Str = Data
        'Data = Str
        Do
            'Num = Num + 1
            If bytesTotal = 0 Then
                Exit Sub
            End If
            If Data = "" Then Exit Sub
            Data = Right$(Data, Len(Data) - 1)   'front of header
            Dim A As String
            A = LCase$(Mid$(Data, 1, 15))
            If A = LCase$("Content-Length:") Then    'when the front is...
                'MsgBox Data
                Do  'for the file size...
                    Num = Num + 1
                    If Mid$(Data, Num, 2) = vbCrLf Then  'finds the vbcrlf, telling us that the line with the file size has ended
                        Temp2 = Mid$(Data, 1, Num)   'isolates the line with the size
                        FSize = Mid$(Temp2, 16, Len(Temp2))
                        prgDL.Max = FSize
                        Exit Do
                    End If
                Loop
                Exit Do
            End If
        Loop
        Num = 0
        Do
            Num = Num + 1
            If Mid$(Str, Num, 4) = (vbCrLf & vbCrLf) Then    'at the end of the header may be the beginning of the file, seperated by two vbcrlfs
                Str = Mid$(Str, Num + 4, Len(Str))   'when they are found
                'MsgBox "VBCRLF X2"
                prgDL.Value = prgDL.Value + Len(Str)
                Rec = Len(Str)
                lblSpecifics.Caption = Int(Rec / 1024) & " KB / " & Int(FSize / 1024) & " KB"
                Open File2 For Binary As #5 'writes to the file
                Put #5, , Str
                Exit Do
            End If
        Loop
    Else
        'Open File2 For Binary As #2
        prgDL.Value = prgDL.Value + Len(Data)
        Rec = Int(Rec) + Len(Data)  'adds to how many bytes have been recieved
        lblSpecifics.Caption = Int(Rec / 1024) & " KB / " & Int(FSize / 1024) & " KB"
        If IsOpen(5) Then
            Temp = (LOF(5) + 1)
            If Temp = 0 Then
                Put #5, , Data
            Else
                Put #5, Temp, Data
            End If
        End If
        Me.Refresh
        If prgDL.Value = prgDL.Max Then
            Close #5
            If Forced = True Then
                cmdYes.Visible = False
                cmdNo.Visible = False
                cmdYes_Click
            Else
                cmdYes.Visible = True
                cmdNo.Visible = True
                lblSpecifics.Caption = "Download completed successfully!" & vbCrLf & "Would you like to install the update now?"
                prgDL.Visible = False
            End If
        End If
    End If
End Sub

Private Function IsOpen(File) As Boolean
    On Error GoTo errors
    Dim X As Long
    X = LOF(File)
    IsOpen = True
    Exit Function
errors:
    IsOpen = False
End Function

Private Sub WS_Error(ByVal Number As Integer, Description As String, ByVal Scode As Long, ByVal Source As String, ByVal HelpFile As String, ByVal HelpContext As Long, CancelDisplay As Boolean)
    On Error Resume Next
    If theindex < UBound(DLFile) And Trim$(DLFile(UBound(DLFile))) <> "" Then
        DownloadFile (theindex + 1)
    Else
        cmdYes.Visible = False
        cmdNo.Visible = False
        prgDL.Visible = False
        lblSpecifics.Caption = "An error occurred during the update check and download. Try again later or download manually."
        ErrorReturned = True
        tmrUnload.Interval = 5000
        tmrUnload.Enabled = True
    End If
End Sub

Private Function FileExist(Path As String) As Boolean
    On Error GoTo doesntexist
    Dim X As Long
    X = FileLen(Path)
    If X > 0 Then
        FileExist = True
    End If
    Exit Function
doesntexist:
    FileExist = False
End Function
