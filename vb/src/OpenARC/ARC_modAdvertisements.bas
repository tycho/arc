Attribute VB_Name = "modAdvertisements"
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

'Note: This module is a work in progress and doesn't do much at the moment.

Private Type Advertisement
    FileName As String
    URL As String
End Type

Private Adverts() As Advertisement
Private CurrentBanner As Integer
Private sSurface As DirectDrawSurface7

Public Sub LoadBanner()
    Dim rrect As RECT
    CurrentBanner = CurrentBanner + 1
    If CurrentBanner > UBound(Adverts) Then CurrentBanner = 0
    ddsdProperties.ddsCaps.lCaps = DDSCAPS_SYSTEMMEMORY Or DDSCAPS_OFFSCREENPLAIN
    ddsdProperties.lFlags = DDSD_CAPS Or DDSD_WIDTH Or DDSD_HEIGHT
    ddsdProperties.lWidth = 468
    ddsdProperties.lHeight = 60
    Set sSurface = DirectDraw.CreateSurfaceFromFile(Adverts(CurrentBanner).FileName, ddsdProperties)
    rrect.Left = 0: rrect.Bottom = 60: rrect.Right = 468: rrect.Top = 0
    DirectDraw_AdBar.BltFast 9, 9, sSurface, rrect, DDBLTFAST_WAIT 'Or DDBLTFAST_DESTCOLORKEY
End Sub

Public Sub InitBanners()
    ReDim Adverts(2)
    Adverts(0).FileName = AppPath & "labs.bmp"
    Adverts(0).URL = "http://www.uplinklabs.net"
    Adverts(1).FileName = AppPath & "cobalt.bmp"
    Adverts(1).URL = "http://www.uplinklabs.net/cobalt"
    Adverts(2).FileName = AppPath & "banner1.bmp"
    Adverts(2).URL = "http://www.outpost.com"
End Sub

Public Sub LaunchAd()
    Shell "C:\program files\internet explorer\iexplore.exe " & """" & Adverts(CurrentBanner).URL & """", vbMinimizedNoFocus
End Sub
