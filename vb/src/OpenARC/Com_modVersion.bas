Attribute VB_Name = "modVersion"
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

Public Const ProjectName      As String = "OpenARC" 'Used everywhere as the name of the program.
Public Const BuildType        As String = " -     B E T A     - "
'Public Const BuildType       As String = " - I N T E R N A L - "
'Public Const BuildType       As String = " -  R E L E A S E  - "
Public Const ClientVersion   As Integer = 3
Public Const ServerVersion   As Integer = 3
Public Const AdminBuild      As Byte = 0
Public Const DebugBuild      As Byte = 1
Public Const DevBuild        As Byte = 0

Public Const Advertisements  As Boolean = False
Public Const LANBuild        As Boolean = False
Public Const PeerBuild       As Boolean = False
Public Const StartLog        As Boolean = False
Public Const Encrypted       As Boolean = False 'Buggy?
