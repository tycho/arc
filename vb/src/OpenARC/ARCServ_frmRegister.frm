VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "mswinsck.ocx"
Begin VB.Form frmRegister 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Register Server"
   ClientHeight    =   2910
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   3150
   Icon            =   "ARCServ_frmRegister.frx":0000
   LinkTopic       =   "frmRegister"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2910
   ScaleWidth      =   3150
   StartUpPosition =   1  'CenterOwner
   Begin MSWinsockLib.Winsock Socket1 
      Left            =   2760
      Top             =   1200
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.Timer Timer2 
      Enabled         =   0   'False
      Left            =   2280
      Top             =   2280
   End
   Begin VB.Timer Timer1 
      Enabled         =   0   'False
      Interval        =   2000
      Left            =   2280
      Top             =   1800
   End
   Begin VB.CheckBox Check1 
      Caption         =   "Register again on connection loss"
      Height          =   255
      Left            =   120
      TabIndex        =   3
      Top             =   1560
      Value           =   1  'Checked
      Width           =   2895
   End
   Begin VB.TextBox Text4 
      Height          =   285
      IMEMode         =   3  'DISABLE
      Left            =   1560
      PasswordChar    =   "*"
      TabIndex        =   0
      Top             =   480
      Width           =   1455
   End
   Begin VB.TextBox Text3 
      Height          =   285
      Left            =   1560
      TabIndex        =   6
      Top             =   120
      Width           =   1455
   End
   Begin VB.CommandButton cmdUnregister 
      Caption         =   "Unregister"
      Enabled         =   0   'False
      Height          =   375
      Left            =   128
      TabIndex        =   5
      Top             =   2400
      Width           =   2895
   End
   Begin VB.CommandButton cmdRegister 
      Caption         =   "Register"
      Default         =   -1  'True
      Height          =   375
      Left            =   128
      TabIndex        =   4
      Top             =   1920
      Width           =   2895
   End
   Begin VB.TextBox Text2 
      Height          =   285
      Left            =   1560
      TabIndex        =   2
      Top             =   1200
      Width           =   735
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Left            =   1560
      TabIndex        =   1
      Top             =   840
      Width           =   1455
   End
   Begin VB.Label Label4 
      Alignment       =   1  'Right Justify
      Caption         =   "Password:"
      Height          =   255
      Left            =   120
      TabIndex        =   10
      Top             =   480
      Width           =   1335
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      Caption         =   "Screen Name:"
      Height          =   255
      Left            =   120
      TabIndex        =   9
      Top             =   120
      Width           =   1335
   End
   Begin VB.Label Label2 
      Alignment       =   1  'Right Justify
      Caption         =   "Register Port:"
      Height          =   255
      Left            =   120
      TabIndex        =   8
      Top             =   1200
      Width           =   1335
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "Lobby Server IP:"
      Height          =   255
      Left            =   120
      TabIndex        =   7
      Top             =   840
      Width           =   1335
   End
End
Attribute VB_Name = "frmRegister"
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

Private Sub Check1_Click()
    If Check1.Value = 0 Then Timer2.Enabled = False
End Sub

Private Sub cmdRegister_Click()
    If LenB(Trim$(Text3)) = 0 Then MsgBox "Enter in a username", vbCritical, "Register": Exit Sub
    If LenB(Trim$(Text4)) = 0 Then MsgBox "Enter in a password", vbCritical, "Register": Exit Sub
    Me.Hide
    Timer1.Interval = 1
    Timer1.Enabled = True
    writeini "Settings2", "sn", Text3.Text, AppPath & "settings.ini"
    writeini "Settings2", "Server", Text1.Text, AppPath & "settings.ini"
    writeini "Settings2", "Port", Text2.Text, AppPath & "settings.ini"
End Sub

Public Sub cmdUnregister_Click()
    On Error Resume Next
    Dim I2 As Integer, L As Long, tmp As String
    Dim lNewMsg As Byte, lOffset As Long, oNewMsg() As Byte, lNewOffSet As Long
    Timer1.Enabled = False
    For I2 = 1 To UBound(PlayerDat)
        If PlayerDat(I2).Ship > 0 Then
            lNewMsg = MSG_ERROR
            lNewOffSet = 0
            ReDim oNewMsg(0)
            AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
            tmp = "The server cancelled its registration with Cobalt Gaming Systems!"
            AddBufferString oNewMsg, tmp, lNewOffSet
            SendTo oNewMsg, I2, True
            PlayerDat(I2).die = True
            DoEvents
            frmServer.Socket1(I2).Close
            frmServer.UDPArray(I2).Disconnect
            frmServer.UDPBroadcast.Disconnect
            Unload frmServer.Socket1(I2)
            Unload frmServer.UDPArray(I2)
        End If
    Next
    frmServer.UDP.Cleanup
    If ConnectionOK Then
        frmServer.txtLog.SelStart = Len(frmServer.txtLog)
        frmServer.txtLog.SelText = vbNewLine & "Unregistered from Cobalt."
        ConnectionOK = False
    End If
    cmdRegister.Enabled = True
    cmdUnregister.Enabled = False
    cmdRegister.Default = True
    DoEvents
    Socket1.Close
End Sub

Private Sub Form_Load()
    Text3 = readini("Settings2", "sn", AppPath & "settings.ini")
    Text1 = readini("Settings2", "Server", AppPath & "settings.ini")
    Text2 = readini("Settings2", "Port", AppPath & "settings.ini")
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    If UnloadMode = 0 Then
        Me.Hide
        Cancel = 1
        Exit Sub
    End If
End Sub

Private Sub Socket1_Close()
    Socket1.Close
    RegisterAgain "connection lost"
End Sub

Private Sub Socket1_Connect()
    Dim s As String, I2 As Integer, PassProtectected As Boolean, b As Byte
    Dim lNewMsg As Byte, lOffset As Long, oNewMsg() As Byte, lNewOffSet As Long
    lNewMsg = SVR_SERVERLOGIN
    lNewOffSet = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
    I2 = ServerVersion
    AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
    AddBufferString oNewMsg, g_ServerName, lNewOffSet
    s = 666
    AddBufferString oNewMsg, s, lNewOffSet
    s = Text3
    AddBufferString oNewMsg, s, lNewOffSet
    s = Text4
    AddBufferString oNewMsg, s, lNewOffSet
    s = g_Password
    If LenB(s) = 0 Then s = Chr(0)
    AddBufferString oNewMsg, s, lNewOffSet
    's = GetMapName(Filename)
    'AddBufferString oNewMsg, s, lNewOffSet
    If g_Password <> "" Then PassProtectected = True
    AddBufferData oNewMsg, VarPtr(PassProtectected), LenB(PassProtectected), lNewOffSet
    b = g_MaxPlayers
    AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
    b = g_UniBall
    AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
    I2 = g_TimeLimit
    AddBufferData oNewMsg, VarPtr(I2), LenB(I2), lNewOffSet
    AddBufferData oNewMsg, VarPtr(Port), LenB(Port), lNewOffSet
    AddBufferData oNewMsg, VarPtr(Port2), LenB(Port2), lNewOffSet
    GameDescription.tHostedby = Text3
    GameDescription.tMapname = HDataNames.hExtendedName
    GameDescription.tDescription = HDataNames.hDescription
    AddBufferData oNewMsg, VarPtr(GameDescription), LenB(GameDescription), lNewOffSet
    AddBufferData oNewMsg, VarPtr(Serial_Number), LenB(Serial_Number), lNewOffSet
    SendTo2 oNewMsg, 0
End Sub

Private Function GetFileName(Path As String) As String
    Dim tmp As String
    Dim tmpa() As String
    tmp = StrReverse(Path)
    tmpa = Split(tmp, "\")
    GetFileName = StrReverse(tmpa(0))
End Function

Private Function GetMapName(Path As String) As String
    Dim mapfile As String
    Dim smapfile() As String
    mapfile = GetFileName(Path)
    smapfile = Split(mapfile, ".")
    GetMapName = smapfile(0)
End Function

Public Sub RegisterAgain(Error As String)
    Socket1.Close
    ErrorMSG = "Registration error: " & Error
    If Check1.Value = 1 Then Timer1.Enabled = True
    frmServer.txtLog.SelStart = Len(frmServer.txtLog)
    frmServer.txtLog.SelText = vbNewLine & ErrorMSG
    cmdRegister.Enabled = True
    cmdUnregister.Enabled = False
End Sub

Private Sub Socket1_DataArrival(ByVal bytesTotal As Long)
    Dim Data() As Byte, i As Long
    Static NewMSG() As Byte, MsgBroke As Boolean
    If bytesTotal > 1024 Then Exit Sub
    Dim DataLength As Long
    DataLength = bytesTotal
    ReDim Data(bytesTotal)
    Socket1.GetData Data, vbByte + vbArray, bytesTotal
    If MsgBroke Then
        i = UBound(NewMSG) + 1
        ReDim Preserve NewMSG(UBound(NewMSG) + DataLength)
        CopyMemory NewMSG(i), Data(0), DataLength
    Else
        ReDim NewMSG(UBound(Data))
        CopyMemory NewMSG(0), Data(0), DataLength
    End If
    
    If Data(UBound(Data)) = 3 Then
        DataProcess NewMSG, UBound(NewMSG), 0
        MsgBroke = False
    Else
        MsgBroke = True
    End If
End Sub

Private Sub Socket1_Error(ByVal Number As Integer, Description As String, ByVal Scode As Long, ByVal Source As String, ByVal HelpFile As String, ByVal HelpContext As Long, CancelDisplay As Boolean)
    If Number = 10060 Then
        Timer1.Enabled = True
    End If
    Socket1.Close
    RegisterAgain Description
End Sub

Private Sub Timer1_Timer()
    'Exit Sub
    Timer1.Enabled = False
    Timer1.Interval = 2000
    If frmServer.mnuStart.Enabled Then MsgBox "You have not started a server yet.": Exit Sub
    cmdRegister.Enabled = False
    cmdUnregister.Enabled = True
    cmdUnregister.Default = True
    frmServer.txtLog.SelStart = Len(frmServer.txtLog)
    frmServer.txtLog.SelText = vbNewLine & "Connecting..."
    InitSocket
End Sub

Private Sub Timer2_Timer()
    'Exit Sub
    frmServer.txtLog.SelStart = Len(frmServer.txtLog)
    frmServer.txtLog.SelText = vbNewLine & "Reconnecting to Cobalt."
    Timer2.Interval = 20000
End Sub

Function DataProcess(ReceivedData() As Byte, ReceivedLen As Long, pID As Byte)
    Dim I2 As Integer, X As Integer, b As Byte, b2 As Byte, tmp As String, L As Long, L2 As Integer
    
    Dim lMsg As Byte, lOffset As Long, MessageLEN As Integer
    Dim oNewMsg() As Byte, lNewOffSet As Long
    Dim lNewMsg As Byte
    On Error GoTo out
nextpacket:
    GetBufferData ReceivedData, VarPtr(lMsg), LenB(lMsg), lOffset
    Select Case lMsg
    Case SVR_COBALTID
        
    Case SVR_REMOVEUSER
        GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
        frmServer.Socket1(b).Close
    Case SVR_ADDUSER
        GetBufferData ReceivedData, VarPtr(b2), LenB(b2), lOffset
        GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
        If PlayerDat(b2).Ship = 0 Then GoTo done
        PlayerDat(b2).Admin = b
        If IsBanned(PlayerDat(b2).Nick, frmServer.Socket1(b2).RemoteHostIP) And b = 0 Then
            sendmsg MSG_SERVERMSG, "Banned.", CInt(b2)
            GoTo done
        End If
        If PlayerDat(b2).Admin < 2 Then
        For X = 0 To UBound(AdminList)
            If LCase(AdminList(X)) = LCase(PlayerDat(b2).Nick) Then PlayerDat(b2).Admin = 2: Exit For
        Next
        End If
        PlayerDat(b2).ID = 3
        lNewMsg = MSG_LOGIN
        lNewOffSet = 0
        AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
        SendTo oNewMsg, CInt(b2)
        'if bDebugLog = 1 then DebugLog "MSG_LOGIN"
    Case SVR_ERROR
        GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
        tmp = GetBufferString(ReceivedData, lOffset)
        L2 = b
        sendmsgforce MSG_ERROR, tmp, L2, True
        If b <= UBound(PlayerDat) Then If PlayerDat(b).Ship > 0 Then PlayerDat(b).die = True
    Case MSG_SERVERMSG
        tmp = GetBufferString(ReceivedData, lOffset)
        frmServer.txtLog.SelStart = Len(frmServer.txtLog)
        frmServer.txtLog.SelText = vbNewLine & tmp
    Case MSG_LOGIN
        GetBufferData ReceivedData, VarPtr(Aver), LenB(Aver), lOffset
        cmdRegister.Enabled = False
        ConnectionOK = True
        Timer1.Enabled = False
        Timer2.Enabled = False
        Me.Enabled = True
        For b = 1 To UBound(PlayerDat)
            If PlayerDat(b).Ship > 0 Then
                L2 = PlayerDat(b).ID
                tmp = PlayerDat(b).Nick
                lNewMsg = SVR_JOINED
                lNewOffSet = 0
                ReDim oNewMsg(0)
                AddBufferData oNewMsg, VarPtr(lNewMsg), LenB(lNewMsg), lNewOffSet
                AddBufferData oNewMsg, VarPtr(b), LenB(b), lNewOffSet
                AddBufferString oNewMsg, tmp, lNewOffSet
                'dpc.Send oNewMsg, 0, DPNSEND_GUARANTEED
                SendTo2 oNewMsg, 0
            End If
        Next
        frmServer.txtLog.SelStart = Len(frmServer.txtLog)
        frmServer.txtLog.SelText = vbNewLine & "Now registered with Cobalt."
    Case MSG_GAMECHAT
        GetBufferData ReceivedData, VarPtr(I2), LenB(I2), lOffset
        tmp = GetBufferString(ReceivedData, lOffset)
        Call sendmsg(MSG_GAMECHAT, Chr(5) & tmp, I2)
    Case MSG_GAG
        GetBufferData ReceivedData, VarPtr(b2), LenB(b2), lOffset
        GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
        PlayerDat(b2).gagged = b
    Case 255
        GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
        If b = 1 Then Check1.Value = 0
        tmp = GetBufferString(ReceivedData, lOffset)
        frmServer.txtLog.SelStart = Len(frmServer.txtLog)
        frmServer.txtLog.SelText = vbNewLine & tmp
        frmRegister.Socket1.Close
    End Select
    
done:
    GetBufferData ReceivedData, VarPtr(b), LenB(b), lOffset
    If b <> 3 Then Exit Function
    If lOffset < ReceivedLen Then
        'Stop
        GoTo nextpacket
    End If
out:
End Function

Function InitSocket() As Boolean
    On Error GoTo errors
    Socket1.RemoteHost = Text1
    If Not IsNumeric(Text2) Then Err.Raise vbObjectError, App.Title, "Invalid port number"
    Socket1.RemotePort = CInt(Text2)
    Socket1.Close
    Socket1.Connect
    InitSocket = True
    Exit Function
errors:
    InitSocket = False
End Function
