Attribute VB_Name = "modDirectPlay"
Option Explicit
Public Const AppGuid = "{4EAF0D68-B180-48FF-88A6-ABDADE99A067}"

Public lngMyPlayerID As Long

Public objDX As DirectX8                        '//Main DirectX8 object
Public objDPServer As DirectPlay8Server         '//Server object, for message handling
Public objDPServerAddress As DirectPlay8Address '//Server's own IP, port

'Dim AppDesc As DPN_APPLICATION_DESC     '//Application description
'With AppDesc
'    .guidApplication = AppGuid          '//Same as client! (Important!)
'    .lMaxPlayers = 3                    '//TicTactoe = max 2 players + 1 server
'    .SessionName = "TicTacToe Game"     '//Name our session like this
'    .lFlags = DPNSESSION_CLIENT_SERVER  '//this game is 100% Client-Server
'End With
                
'Set objDX = New DirectX8                                    '//Create DirectX object
'Set objDPServer = objDX.DirectPlayServerCreate              '//Create Server object
'Set objDPServerAddress = objDX.DirectPlayAddressCreate      '//Create Server DP address
'objDPServer.RegisterMessageHandler frmMain                  '//Register Server message handler
'objDPServerAddress.SetSP DP8SP_TCPIP                        '//Configure Server address for TCP/IP
'objDPServerAddress.AddComponentLong DPN_KEY_PORT, intServerPort '//Listen on this port
'objDPServer.Host AppDesc, objDPServerAddress                '//Start hosting the session
