Attribute VB_Name = "modWeapons"
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

Public WepRecharge As clsSingle
Public MissBar As Single, MortarBar As Single, BounceBar As Single

Public Mortar() As Boolean
Public MortarWho() As Integer
Public MortarTeam() As Integer
Public MortarX() As Integer
Public MortarY() As Integer
Public MortarFrame() As Integer
Public MortarDest() As Single
Public MortarDist() As Single
Public MortarAngle() As Single
Public MortarSpeed() As Single
Public MortarAmmo As clsByte
Public Explode() As Long, ExplodeX() As Integer, ExplodeY() As Integer, ExplodeWho() As Integer
Public ShrapAngle() As Integer, ShrapDist() As Single, ShrapSpeed() As Single, ShrapTick() As Single
Public Spark() As Long, SparkX() As Integer, SparkY() As Integer
Public SparkAngle() As Integer, SparkDist() As Single, SparkSpeed() As Single, SparkTick() As Single
'
Public Miss() As Boolean
Public MissWho() As Integer
Public MissTeam() As Integer
Public MissX() As Integer
Public MissY() As Integer
Public MissDist() As Single
Public MissAngle() As Single
Public MissAmmo As clsByte
'
Public Bounce() As Boolean
Public BounceWho() As Integer
Public BounceTeam() As Integer
Public BounceX() As Integer
Public BounceY() As Integer
Public BounceDist() As Single
Public BounceTrav() As Single
Public BounceAngle() As Single
Public BounceStopMve() As Integer
Public BounceAmmo As clsByte
Public MineAmmo As clsByte
'
Public Laser() As Boolean
Public LaserWho() As Integer
Public LaserTeam() As Integer
Public LaserX() As Integer
Public LaserY() As Integer
Public LaserDist() As Single
Public LaserAngle() As Single
Public LaserStopMve() As Integer
Public LaserHit() As Boolean
'
Public Expl() As Boolean
Public ExplX() As Integer
Public ExplY() As Integer
Public AnimExT() As Long, AnimExF() As Integer
'
Public Smk() As Boolean
Public SmkX() As Integer, SmkColor() As Integer
Public SmkY() As Integer, SmkT() As Long
Public Smk2() As Boolean
Public SmkX2() As Integer, SmkColor2() As Integer
Public SmkY2() As Integer, SmkT2() As Long, SmkT3() As Long

Public Sub AnimSmoke(I As Integer)
    Dim rSmoke As RECT, j As Integer
    Dim ExX As Integer, ExY As Integer, sw As Integer, sh As Integer
    Static FrameT() As Single, ArraySet As Boolean, ResXmSW As Integer, ResYmSH As Integer
    Static FrameXC() As Single, TickStart() As Boolean
    If Not ArraySet Then
        ArraySet = True
        ReDim FrameT(0), FrameXC(0), TickStart(0)
    End If
    If UBound(FrameXC) <> UBound(Smk) Then
        ReDim Preserve FrameT(UBound(Smk)), FrameXC(UBound(Smk)), TickStart(UBound(Smk))
    End If
    j = FrameXC(I)
    rSmoke.Left = rBmbSmoke(j).Left
    rSmoke.Right = rBmbSmoke(j).Right
    If SmkColor(I) < 5 Then
        rSmoke.Top = rBmbSmoke(j).Top + (17 * SmkColor(I))
        rSmoke.Bottom = rBmbSmoke(j).Bottom + (17 * SmkColor(I))
    Else
        rSmoke.Top = rBmbSmoke(j).Top + 117
        rSmoke.Bottom = rBmbSmoke(j).Bottom + 117
    End If
    sw = rSmoke.Right - rSmoke.Left
    sh = rSmoke.Bottom - rSmoke.Top
    ExX = SmkX(I) - MeX - (sw / 2)
    ExY = SmkY(I) - MeY - (sh / 2)
    ResXmSW = ResX - sw
    ResYmSH = ResY - sh
    If ExX < 0 Then rSmoke.Left = rSmoke.Left + Abs(ExX): ExX = 0
    If ExY < 0 Then rSmoke.Top = rSmoke.Top + Abs(ExY): ExY = 0
    If ExX > ResXmSW Then rSmoke.Right = rSmoke.Right - (ExX - (ResXmSW)): ExX = (ResXmSW) + (ExX - (ResXmSW))
    If ExY > ResYmSH Then rSmoke.Bottom = rSmoke.Bottom - (ExY - (ResYmSH)): ExY = (ResYmSH) + (ExY - (ResYmSH))
    If BackBuffer.isLost Then GoTo skip
    BackBuffer.BltFast ExX, ExY, DirectDraw_Tuna1, rSmoke, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
    
skip:
    FrameXC(I) = FrameXC(I) + Speed * 0.19
    If FrameXC(I) > 8 Then
        FrameXC(I) = 0
        Smk(I) = False
    End If
End Sub

Public Sub Mortars(I As Integer)
    Dim rWeapon As RECT, sw As Integer, sh As Integer
    Dim ExX As Integer, ExY As Integer, j As Integer, d As Integer, si As Single
    If MortarDist(I) <= MortarDest(I) Then
        MortarDist(I) = MortarDist(I) + MortarSpeed(I) * 1.5 * Speed
        ExX = Cos(MortarAngle(I) * Div360MultPI) * MortarDist(I) + MortarX(I)
        ExY = Sin(MortarAngle(I) * Div360MultPI) * MortarDist(I) + MortarY(I)
        If ExX - MeX > -60 And ExY - MeY > -60 And ExX - MeX < ResX + 60 And ExY - MeY < ResY + 60 Then
            If MortarDist(I) > MortarDest(I) Then
                d = WeaponTouch(2, I, ExX, ExY)
                If d = 0 Or d = 1 Or d = 2 Then
                    If d <> 3 Then
                        ExplBomb ExX, ExY
                        ExplShrap MortarWho(I), ExX, ExY, 3.5, 700, 0, 12
                        SndMortars ExX - MeX - CenterX, ExY - MeY - CenterY
                    End If
                    Mortar(I) = False
                End If
            End If
            si = (MortarDest(I) - MortarDist(I)) / MortarDest(I)
            If si > 0 Then j = 0
            If si > 0.1 Then j = 1
            If si > 0.2 Then j = 2
            If si > 0.3 Then j = 3
            If si > 0.4 Then j = 4
            If si > 0.5 Then j = 4
            If si > 0.6 Then j = 3
            If si > 0.7 Then j = 2
            If si > 0.8 Then j = 1
            If si > 0.9 Then j = 0
            rWeapon.Left = rBomb(j).Left
            rWeapon.Right = rBomb(j).Right
            rWeapon.Top = rBomb(j).Top
            rWeapon.Bottom = rBomb(j).Bottom
            If NewGTC - SmkT(I) > 100 And MortarDist(I) > 24 Then
                SmkT(I) = NewGTC
                SmokeTrail ExX, ExY, MortarTeam(I)
            End If
            sw = rWeapon.Right - rWeapon.Left
            sh = rWeapon.Bottom - rWeapon.Top
            ExX = ExX - MeX - (sw / 2)
            ExY = ExY - MeY - (sh / 2)
            If ExX < 0 Then rWeapon.Left = rWeapon.Left + Abs(ExX): ExX = 0
            If ExY < 0 Then rWeapon.Top = rWeapon.Top + Abs(ExY): ExY = 0
            If ExX > ResX - 15 Then rWeapon.Right = rWeapon.Right - (ExX - (ResX - 15)): ExX = ResX - 15 + (ExX - (ResX - 15))
            If ExY > ResY - 15 Then rWeapon.Bottom = rWeapon.Bottom - (ExY - (ResY - 15)): ExY = ResY - 15 + (ExY - (ResY - 15))
            BackBuffer.BltFast ExX, ExY, DirectDraw_Tuna1, rWeapon, DDBLTFAST_SRCCOLORKEY Or DDBLTFAST_WAIT
        Else
            If MortarDist(I) > MortarDest(I) Then Mortar(I) = False
        End If
    End If
End Sub

Public Sub AnimSpark(I As Integer)
    Dim j As Integer, xt As Integer, yt As Integer, OldDist As Integer
    Dim d As Integer, R As Integer
    For j = 0 To 30
        d = SparkAngle(j, I)
        If d <> 0 Then
            OldDist = SparkDist(j, I)
            SparkDist(j, I) = SparkDist(j, I) + SparkSpeed(j, I) * Speed
            For R = OldDist To SparkDist(j, I)
                xt = Cos(d * Div360MultPI) * R + SparkX(I)
                yt = Sin(d * Div360MultPI) * R + SparkY(I)
                If WeaponTouch(5, I, xt, yt) Then SparkAngle(j, I) = 0: Exit For
            Next
            If SparkAngle(j, I) = 0 Then GoTo out
            xt = xt - MeX
            yt = yt - MeY
            If SparkDist(j, I) > 0 Then R = 1
            If SparkDist(j, I) > 3 Then R = 2
            If SparkDist(j, I) > 6 Then R = 3
            If SparkDist(j, I) > 11 Then R = 4
            LineDraw 4, R, 0, xt, yt, SparkX(I), SparkY(I)
out:
        End If
    Next
End Sub

Public Sub AnimMine(Idx As Integer)
    Dim rBuff As RECT
    Dim ExX As Long, ExY As Long, ERX As Integer, ERY As Integer
    ExX = Mines(Idx).X
    ExY = Mines(Idx).y
    ExX = ExX - MeX: ExY = ExY - MeY
    
    rBuff.Top = 93
    rBuff.Bottom = rBuff.Top + 8
    rBuff.Left = 444 + Mines(Idx).Color * 8
    rBuff.Right = rBuff.Left + 8
    
    If ExX < 0 Then rBuff.Left = rBuff.Left + Abs(ExX): ExX = 0
    If ExY < 0 Then rBuff.Top = rBuff.Top + Abs(ExY): ExY = 0
    ERX = ExX - (ResX - 8)
    ERY = ExY - (ResY - 8)
    If ExX > ResX - 8 Then rBuff.Right = rBuff.Right - ERX: ExX = ResX - 8 + ERX
    If ExY > ResY - 8 Then rBuff.Bottom = rBuff.Bottom - ERY: ExY = ResY - 8 + ERY
    BackBuffer.BltFast ExX, ExY, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
End Sub

Public Sub SetMine(Idx As Integer, Who As Byte, Color As Byte, X As Integer, y As Integer)
    Dim I As Integer
    For I = 0 To UBound(Mines) + 1
        If I > UBound(Mines) Then ReDim Preserve Mines(I)
        If Mines(I).Who = 0 Then
            Mines(I).Who = Who
            Mines(I).Color = Color
            Mines(I).X = X
            Mines(I).y = y
            Mines(I).Tick = 0
            Mines(I).Idx = Idx
            Exit For
        End If
    Next
End Sub

Public Sub LayMine(X As Integer, y As Integer)
    Dim lMsg As Byte
    Dim oNewMsg() As Byte, lNewOffSet As Long
    If MineAmmo < 1 Then Exit Sub
    If Players(MeNum).DevCheat = 0 Or Players(MeNum).DevCheat = 5 Then MineAmmo = MineAmmo - 1
    WepRecharge = WepRecharge - 30
    lMsg = MSG_MINES
    lNewOffSet = 0
    ReDim oNewMsg(0)
    AddBufferData oNewMsg, VarPtr(lMsg), LenB(lMsg), lNewOffSet
    AddBufferData oNewMsg, VarPtr(X), LenB(X), lNewOffSet
    AddBufferData oNewMsg, VarPtr(y), LenB(y), lNewOffSet
    SendTo oNewMsg, True
End Sub

Public Sub AnimLaser(I As Integer)
    Dim NewX As Integer, NewY As Integer, j As Integer
    Dim OldDist As Integer, d As Integer
    Dim LasrX As Integer, LasrY As Integer, LasrX2 As Integer, LasrY2 As Integer, TmpDist As Integer
    OldDist = LaserDist(I)
    LaserDist(I) = LaserDist(I) + 6.5 * Speed
    If LaserDist(I) > 570 Then
        If LaserDist(I) > LaserStopMve(I) + 70 Then
            LaserStopMve(I) = -11
            LaserHit(I) = False
            Laser(I) = False: Exit Sub
        End If
    End If
    TmpDist = LaserDist(I)
    If TmpDist > 500 And LaserStopMve(I) = -11 Then LaserStopMve(I) = OldDist
    If LaserStopMve(I) > -11 Then
        If TmpDist - LaserStopMve(I) > 70 Then
            LaserStopMve(I) = -11
            LaserHit(I) = False
            Laser(I) = False: Exit Sub
        End If
        TmpDist = LaserStopMve(I)
    End If
    If LaserStopMve(I) = -11 Then
        For d = OldDist To LaserDist(I)
            NewX = Cos(LaserAngle(I) * Div360MultPI) * d + LaserX(I)
            NewY = Sin(LaserAngle(I) * Div360MultPI) * d + LaserY(I)
            j = WeaponTouch(0, I, NewX, NewY)
            If j > 0 Then
                TmpDist = d - 1
                LaserStopMve(I) = d - 1
                Exit For
            End If
        Next
    Else
        NewX = Cos(LaserAngle(I) * Div360MultPI) * LaserStopMve(I) + LaserX(I)
        NewY = Sin(LaserAngle(I) * Div360MultPI) * LaserStopMve(I) + LaserY(I)
    End If
    If NewX - MeX > -71 And NewY - MeY > -71 And NewX - MeX < ResX + 71 And NewY - MeY < ResY + 71 Then
        LasrX = NewX - MeX
        LasrY = NewY - MeY
        
        If j > 0 Then
            If j = 2 Then
                SndLaserHitS LasrX - CenterX, LasrY - CenterY
            Else
                LaserHit(I) = True
                SndLaserHitW LasrX - CenterX, LasrY - CenterY
                ExplSpark NewX, NewY
            End If
        End If
        
        TmpDist = LaserDist(I)
        If TmpDist > 70 Then
            TmpDist = TmpDist - 70
        Else
            TmpDist = 0
        End If
        If LaserStopMve(I) > -1 Then If LaserDist(I) > LaserStopMve(I) + 70 Then GoTo out
        LasrX2 = Cos(LaserAngle(I) * Div360MultPI) * TmpDist + LaserX(I) - MeX
        LasrY2 = Sin(LaserAngle(I) * Div360MultPI) * TmpDist + LaserY(I) - MeY
        LineDraw 1, LaserTeam(I), I, LasrX, LasrY, LasrX2, LasrY2
out:
    End If
End Sub

Public Sub AnimBounce(I As Integer)
    Dim NewX As Integer, NewY As Integer, tmp As Integer, OldDist As Integer
    Dim d As Integer, e As Integer, j As Integer
    Dim LasrX As Integer, LasrY As Integer, LasrX2 As Integer, LasrY2 As Integer, TmpDist As Integer
    OldDist = BounceDist(I)
    BounceTrav(I) = BounceTrav(I) + 8 * Speed
    BounceDist(I) = BounceDist(I) + 8 * Speed
    TmpDist = BounceDist(I)
    
    If BounceTrav(I) > 1000 And BounceStopMve(I) = -11 Then BounceStopMve(I) = OldDist
    
    If BounceStopMve(I) > -11 Then
        If TmpDist - BounceStopMve(I) > 90 Then
            BounceStopMve(I) = -11
            Bounce(I) = False: Exit Sub
        End If
        TmpDist = BounceStopMve(I)
    End If
    
    If BounceStopMve(I) = -11 Then
        e = BounceDist(I)
        d = OldDist + 1
        If d > e Then
            NewX = Cos(BounceAngle(I) * Div360MultPI) * d + BounceX(I)
            NewY = Sin(BounceAngle(I) * Div360MultPI) * d + BounceY(I)
        End If
        For d = d To e
            NewX = Cos(BounceAngle(I) * Div360MultPI) * d + BounceX(I)
            NewY = Sin(BounceAngle(I) * Div360MultPI) * d + BounceY(I)
            j = BounceWho(I)
            tmp = WeaponTouch(3, I, NewX, NewY)
            If tmp > 0 Then
                TmpDist = d - 1
                BounceStopMve(I) = d - 1
                BounceDist(I) = BounceDist(I) + 8
                Exit For
            End If
        Next
    Else
        NewX = Cos(BounceAngle(I) * Div360MultPI) * (BounceStopMve(I)) + BounceX(I)
        NewY = Sin(BounceAngle(I) * Div360MultPI) * (BounceStopMve(I)) + BounceY(I)
    End If
    LasrX = NewX - MeX
    LasrY = NewY - MeY
    If LasrX > -100 And LasrY > -100 And LasrX < ResX + 100 And LasrY < ResY + 100 Then
        If tmp > 0 Then
            If tmp = 2 Then
                SndBounHits LasrX - CenterX, LasrY - CenterY
            Else
                SndBounce LasrX - CenterX, LasrY - CenterY
            End If
        End If
        TmpDist = BounceDist(I)
        If TmpDist > 90 Then
            TmpDist = TmpDist - 90
        Else
            TmpDist = 0
        End If
        LasrX2 = (Cos(BounceAngle(I) * Div360MultPI) * TmpDist + BounceX(I)) - MeX
        LasrY2 = (Sin(BounceAngle(I) * Div360MultPI) * TmpDist + BounceY(I)) - MeY
        LineDraw 2, BounceTeam(I), I, LasrX, LasrY, LasrX2, LasrY2
    End If
End Sub

Public Sub AnimMiss(I As Integer)
    Dim ExX As Integer, j As Integer, d As Integer, OldDist As Integer
    Dim LasrX As Integer, LasrY As Integer, LasrX2 As Integer, LasrY2 As Integer
    Dim NewX As Integer, NewY As Integer
    Dim NewX2 As Integer, NewY2 As Integer
    OldDist = MissDist(I)
    MissDist(I) = MissDist(I) + 4.5 * Speed
    If MissDist(I) > 500 Then Miss(I) = False
    For d = OldDist To MissDist(I)
        NewX = Cos(MissAngle(I) * Div360MultPI) * d + MissX(I)
        NewY = Sin(MissAngle(I) * Div360MultPI) * d + MissY(I)
        j = WeaponTouch(1, I, NewX, NewY)
        If j > 0 Then Exit For
    Next
    For ExX = OldDist To d - 1 Step 7
        If MissDist(I) > 24 And NewGTC - SmkT2(I) > 10 Then
            NewX2 = Cos(MissAngle(I) * Div360MultPI) * (ExX - 5) + MissX(I)
            NewY2 = Sin(MissAngle(I) * Div360MultPI) * (ExX - 5) + MissY(I)
            SmokeTrail2 NewX2, NewY2, MissTeam(I)
        End If
    Next
    
    LasrX = NewX - MeX
    LasrY = NewY - MeY
    NewX2 = Cos(MissAngle(I) * Div360MultPI) * (d - 14) + MissX(I)
    NewY2 = Sin(MissAngle(I) * Div360MultPI) * (d - 14) + MissY(I)
    LasrX2 = NewX2 - MeX
    LasrY2 = NewY2 - MeY
    If LasrX > -15 And LasrY > -15 And LasrX < ResX + 15 And LasrY < ResY + 15 Then
        LineDraw 3, 6, I, LasrX, LasrY, LasrX2, LasrY2
        If j > 0 Then
            If j = 2 Then
                SndRockHits LasrX - CenterX, LasrY - CenterY
            Else
                SndRockHitW LasrX - CenterX, LasrY - CenterY
            End If
            NewX = Cos(MissAngle(I) * Div360MultPI) * (d - 1) + MissX(I)
            NewY = Sin(MissAngle(I) * Div360MultPI) * (d - 1) + MissY(I)
            If j <> 2 Then ExplShrap MissWho(I), NewX, NewY, 2.4, 150, 6, 24
            SmokeTrail NewX, NewY, 5
            Miss(I) = False
        End If
    End If
    If j > 0 Then Miss(I) = False
End Sub

Public Sub ExplBomb(xt As Integer, yt As Integer)
    Dim I As Integer
    For I = 0 To UBound(ExplX) + 1
        If I > UBound(Expl) Then
            ReDim Preserve Expl(I), ExplX(I), ExplY(I), AnimExT(I), AnimExF(I)
        End If
        If Not Expl(I) Then
            Expl(I) = True
            ExplX(I) = xt: ExplY(I) = yt
            AnimExT(I) = NewGTC: AnimExF(I) = 0
            Exit For
        End If
    Next
End Sub

Public Sub ExplShrap(Who As Integer, ExplX As Integer, ExplY As Integer, ExplSpeed As Single, ExplTick As Long, ExplStart As Integer, ExplPower As Integer)
    Dim I As Integer, d As Integer
    For I = 0 To UBound(ExplodeWho) + 1
        If I > UBound(ExplodeWho) Then
            ReDim Preserve Explode(I), ExplodeX(I), ExplodeY(I), ShrapSpeed(I), ShrapTick(I)
            ReDim Preserve ShrapAngle(30, I), ShrapDist(I), ExplodeWho(I)
            Exit For
        End If
    Next
    For d = 0 To 30 Step 1
        ShrapAngle(d, I) = -90 + d * ExplPower
    Next
    Explode(I) = NewGTC
    ShrapDist(I) = ExplStart
    ShrapSpeed(I) = ExplSpeed
    ShrapTick(I) = ExplTick
    ExplodeX(I) = ExplX
    ExplodeY(I) = ExplY
    ExplodeWho(I) = Who
End Sub

Public Sub FireLaser(Who As Byte, lx As Integer, ly As Integer, cx As Integer, cy As Integer)
    Dim j As Integer, LasrX As Integer, LasrY As Integer
    Dim lMsg As Byte
    Dim oNewMsg() As Byte, lNewOffSet As Long
    If Who = MeNum Then If WepRecharge < 12 Or Players(Who).Ship = 6 Or Players(MeNum).Invisible Or Players(Who).Warping Then Exit Sub
    For j = 0 To UBound(Laser) + 1
        If j > UBound(Laser) Then
            ReDim Preserve Laser(j), LaserWho(j), LaserAngle(j), LaserDist(j), LaserX(j), LaserY(j), LaserStopMve(j), LaserTeam(j), LaserHit(j)
        End If
        If Not Laser(j) Then
            LaserWho(j) = Who
            LaserTeam(j) = Players(Who).Ship
            LaserStopMve(j) = -11
            If lx = 0 Then lx = 1
            If ly = 0 Then ly = 1
            LaserAngle(j) = Atn(ly / lx)
            LaserAngle(j) = LaserAngle(j) * Div180byPI
            If lx < 0 Then LaserAngle(j) = LaserAngle(j) + 180
            LaserDist(j) = 0
            LaserX(j) = cx + 16
            LaserY(j) = cy + 16
            Laser(j) = True
            If Who = MeNum Then
                WepRecharge = WepRecharge - 12
                lMsg = MSG_LASER
                lNewOffSet = 0
                ReDim oNewMsg(0)
                AddBufferData oNewMsg, VarPtr(lMsg), LenB(lMsg), lNewOffSet
                AddBufferData oNewMsg, VarPtr(lx), LenB(lx), lNewOffSet
                AddBufferData oNewMsg, VarPtr(ly), LenB(ly), lNewOffSet
                AddBufferData oNewMsg, VarPtr(cx), LenB(cx), lNewOffSet
                AddBufferData oNewMsg, VarPtr(cy), LenB(cy), lNewOffSet
                SendTo oNewMsg, False
            End If
            LasrX = cx - MeX
            LasrY = cy - MeY
            If LasrX > -100 And LasrY > -100 And LasrX < ResX + 100 And LasrY < ResY + 100 Then SndLaser LasrX - CenterX, LasrY - CenterY
            Exit For
        End If
    Next
End Sub

Public Sub FireMiss(Who As Byte, lx As Integer, ly As Integer, cx As Integer, cy As Integer)
    Dim j As Integer, LasrX As Integer, LasrY As Integer
    Dim lMsg As Byte
    Dim oNewMsg() As Byte, lNewOffSet As Long
    If Who = MeNum Then If WepRecharge < 40 Or MissAmmo = 0 Or Players(MeNum).Invisible Or Players(Who).Warping Then Exit Sub
    For j = 0 To UBound(Miss) + 1
        If j > UBound(Miss) Then
            ReDim Preserve Miss(j), MissWho(j), MissAngle(j), MissDist(j), MissX(j), MissY(j), MissTeam(j), SmkT2(j)
        End If
        If Not Miss(j) Then
            If lx = 0 Then lx = 1
            If ly = 0 Then ly = 1
            MissAngle(j) = Atn(ly / lx)
            MissAngle(j) = MissAngle(j) * Div180byPI
            If lx < 0 Then MissAngle(j) = MissAngle(j) + 180
            MissDist(j) = 0
            MissX(j) = cx + 16
            MissY(j) = cy + 16
            Miss(j) = True
            MissWho(j) = Who
            MissTeam(j) = Players(Who).Ship
            If Who = MeNum Then
                If Players(MeNum).DevCheat = 0 Or Players(MeNum).DevCheat = 5 Then MissAmmo = MissAmmo - 1
                WepRecharge = WepRecharge - 30
                lMsg = MSG_MISS
                lNewOffSet = 0
                ReDim oNewMsg(0)
                AddBufferData oNewMsg, VarPtr(lMsg), LenB(lMsg), lNewOffSet
                AddBufferData oNewMsg, VarPtr(lx), LenB(lx), lNewOffSet
                AddBufferData oNewMsg, VarPtr(ly), LenB(ly), lNewOffSet
                AddBufferData oNewMsg, VarPtr(cx), LenB(cx), lNewOffSet
                AddBufferData oNewMsg, VarPtr(cy), LenB(cy), lNewOffSet
                SendTo oNewMsg, True
            End If
            LasrX = cx - MeX
            LasrY = cy - MeY
            If LasrX > -60 And LasrY > -60 And LasrX < ResX + 60 And LasrY < ResY + 60 Then SndMissile LasrX - CenterX, LasrY - CenterY
            Exit For
        End If
    Next
End Sub

Public Sub FireMort(Who As Byte, lx As Integer, ly As Integer, cx As Integer, cy As Integer)
    Dim j As Integer, LasrX As Integer, LasrY As Integer
    Dim lMsg As Byte
    Dim oNewMsg() As Byte, lNewOffSet As Long
    If Who = MeNum Then If WepRecharge < 24 Or MortarAmmo = 0 Or Players(MeNum).Invisible Or Players(Who).Warping Then Exit Sub
    For j = 0 To UBound(Mortar)
        If Not Mortar(j) Then Exit For
        If j = UBound(Mortar) Then
            j = j + 1
            ReDim Preserve Mortar(j), MortarWho(j), MortarX(j), MortarY(j), MortarDest(j), MortarDist(j)
            ReDim Preserve MortarAngle(j), MortarTeam(j), MortarSpeed(j), MortarTeam(j), SmkT(j)
            j = j - 1
        End If
    Next
    If lx = 0 Then lx = 1
    If ly = 0 Then ly = 1
    MortarAngle(j) = Atn(ly / lx)
    MortarAngle(j) = MortarAngle(j) * Div180byPI
    If lx < 0 Then MortarAngle(j) = MortarAngle(j) + 180
    MortarDest(j) = Sqr(lx ^ 2 + ly ^ 2) ' x^2 is slower than x*x
    MortarSpeed(j) = (MortarDest(j) * 0.0038) + ((477 - MortarDest(j)) * 0.001)
    MortarDist(j) = 0
    MortarX(j) = cx + 16
    MortarY(j) = cy + 16
    Mortar(j) = True
    MortarWho(j) = Who
    MortarTeam(j) = Players(Who).Ship
    If Who = MeNum Then
        If Players(MeNum).DevCheat = 0 Or Players(MeNum).DevCheat = 5 Then MortarAmmo = MortarAmmo - 1
        WepRecharge = WepRecharge - 24
        lMsg = MSG_BOMB
        lNewOffSet = 0
        ReDim oNewMsg(0)
        AddBufferData oNewMsg, VarPtr(lMsg), LenB(lMsg), lNewOffSet
        AddBufferData oNewMsg, VarPtr(lx), LenB(lx), lNewOffSet
        AddBufferData oNewMsg, VarPtr(ly), LenB(ly), lNewOffSet
        AddBufferData oNewMsg, VarPtr(cx), LenB(cx), lNewOffSet
        AddBufferData oNewMsg, VarPtr(cy), LenB(cy), lNewOffSet
        SendTo oNewMsg, True
    End If
    LasrX = cx - MeX
    LasrY = cy - MeY
    If LasrX > -100 And LasrY > -100 And LasrX < ResX + 100 And LasrY < ResY + 100 Then SndMortarsL LasrX - CenterX, LasrY - CenterY
End Sub

Public Sub FireBounce(Who As Byte, lx As Integer, ly As Integer, cx As Integer, cy As Integer)
    Dim j As Integer, LasrX As Integer, LasrY As Integer
    Dim lMsg As Byte
    Dim oNewMsg() As Byte, lNewOffSet As Long
    If Who = MeNum Then If WepRecharge < 12 Or BounceAmmo = 0 Or Players(MeNum).Invisible Or Players(Who).Warping Then Exit Sub
    For j = 0 To UBound(Bounce) + 1
        If j > UBound(Bounce) Then
            ReDim Preserve Bounce(j), BounceWho(j), BounceAngle(j), BounceDist(j), BounceTrav(j), BounceX(j), BounceY(j), BounceTeam(j), BounceStopMve(j)
        End If
        If Not Bounce(j) Then
            If lx = 0 Then lx = 1
            If ly = 0 Then ly = 1
            BounceWho(j) = Who
            BounceTeam(j) = Players(Who).Ship
            BounceStopMve(j) = -11
            BounceAngle(j) = Atn(ly / lx)
            BounceAngle(j) = BounceAngle(j) * Div180byPI
            If lx < 0 Then BounceAngle(j) = BounceAngle(j) + 180
            BounceDist(j) = 0
            BounceTrav(j) = 0
            BounceX(j) = cx + 16
            BounceY(j) = cy + 16
            Bounce(j) = True
            If Who = MeNum Then
                If Players(MeNum).DevCheat = 0 Or Players(MeNum).DevCheat = 5 Then BounceAmmo = BounceAmmo - 1
                WepRecharge = WepRecharge - 12
                lMsg = MSG_BOUNCY
                lNewOffSet = 0
                ReDim oNewMsg(0)
                AddBufferData oNewMsg, VarPtr(lMsg), LenB(lMsg), lNewOffSet
                AddBufferData oNewMsg, VarPtr(lx), LenB(lx), lNewOffSet
                AddBufferData oNewMsg, VarPtr(ly), LenB(ly), lNewOffSet
                AddBufferData oNewMsg, VarPtr(cx), LenB(cx), lNewOffSet
                AddBufferData oNewMsg, VarPtr(cy), LenB(cy), lNewOffSet
                SendTo oNewMsg
            End If
            LasrX = cx - MeX
            LasrY = cy - MeY
            If LasrX > -100 And LasrY > -100 And LasrX < ResX + 100 And LasrY < ResY + 100 Then SndBounShot LasrX - CenterX, LasrY - CenterY
            Exit For
        End If
    Next
End Sub

Public Sub AnimShrapnel(I As Integer)
    Dim j As Integer, xt As Integer, yt As Integer, ShrapF As Integer, OldDist As Integer
    Dim d As Integer, R As Integer, X As Integer
    OldDist = ShrapDist(I)
    ShrapDist(I) = ShrapDist(I) + ShrapSpeed(I) * Speed
    For j = 0 To 30
        d = ShrapAngle(j, I)
        If d <> 0 Then
            For R = OldDist To ShrapDist(I)
                xt = Cos(d * Div360MultPI) * R + ExplodeX(I)
                yt = Sin(d * Div360MultPI) * R + ExplodeY(I)
                If WeaponTouch(4, I, xt, yt) Then
                    X = X + 1
                    ShrapAngle(j, I) = 0: Exit For
                End If
            Next
            If ShrapAngle(j, I) = 0 Then GoTo out
            xt = xt - MeX
            yt = yt - MeY
            ShrapF = Int(Rnd * 2)
            BackBuffer.BltFast xt, yt, DirectDraw_Tuna1, rShrapnel(ShrapF), DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
out:
        End If
    Next
End Sub

Public Function WeaponTouch(Wep As Integer, WepIndex As Integer, WX As Integer, WY As Integer) As Integer
    Dim rTemp As RECT, rWho As RECT, rBlock As RECT, I As Integer, j As Integer, SgnX As Integer, SgnY As Integer
    Dim C As Integer, d As Integer, e As Integer, F As Integer, h As Single
    Dim TestXY As Integer, b As Integer
    Dim PowerX As Integer, PowerY As Integer
    If Wep = 0 Then 'Laser
        b = LaserWho(WepIndex)
        rWho.Top = WY
        rWho.Left = WX
        rWho.Bottom = rWho.Top + 1
        rWho.Right = rWho.Left + 1
        SgnX = WX - LaserX(WepIndex)
        SgnY = WY - LaserY(WepIndex)
        SgnX = Sgn(SgnX): SgnY = Sgn(SgnY)
    ElseIf Wep = 1 Then 'Missile
        b = MissWho(WepIndex)
        rWho.Top = WY
        rWho.Left = WX
        rWho.Bottom = rWho.Top + 1
        rWho.Right = rWho.Left + 1
        SgnX = WX - MissX(WepIndex)
        SgnY = WY - MissY(WepIndex)
        SgnX = Sgn(SgnX): SgnY = Sgn(SgnY)
    ElseIf Wep = 2 Then 'Mortar
        b = MortarWho(WepIndex)
        rWho.Top = WY
        rWho.Left = WX
        rWho.Bottom = rWho.Top + 2
        rWho.Right = rWho.Left + 2
        SgnX = WX - MortarX(WepIndex)
        SgnY = WY - MortarY(WepIndex)
        SgnX = Sgn(SgnX): SgnY = Sgn(SgnY)
    ElseIf Wep = 3 Then 'Bounce
        rWho.Top = WY
        rWho.Left = WX
        rWho.Bottom = rWho.Top + 1
        rWho.Right = rWho.Left + 1
        b = BounceWho(WepIndex)
        SgnX = WX - BounceX(WepIndex)
        SgnY = WY - BounceY(WepIndex)
        SgnX = Sgn(SgnX): SgnY = Sgn(SgnY)
    ElseIf Wep = 4 Then
        b = ExplodeWho(WepIndex)
        rWho.Top = WY
        rWho.Left = WX
        rWho.Bottom = rWho.Top + 3
        rWho.Right = rWho.Left + 3
        SgnX = WX - ExplodeX(WepIndex)
        SgnY = WY - ExplodeY(WepIndex)
        SgnX = Sgn(SgnX): SgnY = Sgn(SgnY)
    ElseIf Wep = 6 Then
        rWho.Top = WY
        rWho.Left = WX
        rWho.Bottom = rWho.Top + 10
        rWho.Right = rWho.Left + 10
        SgnX = WX - UniBall(WepIndex).BallX
        SgnY = WY - UniBall(WepIndex).BallY
        SgnX = Sgn(SgnX): SgnY = Sgn(SgnY)
    End If
    
    For I = 0 To UBound(UniBall)
        rBlock.Top = UniBall(I).BallY
        rBlock.Left = UniBall(I).BallX
        rBlock.Bottom = rBlock.Top + 10
        rBlock.Right = rBlock.Left + 10
        If IntersectRect(rTemp, rWho, rBlock) Then
            WeaponTouch = 1 'Weapon hit uniball
            If Wep = 9 Then
                PowerX = Cos(LaserAngle(WepIndex) * Div360MultPI) * 100 'Cosine present, FPU div needed.
                PowerY = Sin(LaserAngle(WepIndex) * Div360MultPI) * 100 'sine present, FPU div needed.
                UniBall(I).BSpeedX = UniBall(I).BSpeedX + (PowerX * 0.01 * UniBall(I).BMoveX)
                UniBall(I).BSpeedY = UniBall(I).BSpeedY + (PowerY * 0.01 * UniBall(I).BMoveY)
                If UniBall(I).BSpeedX < 0 Then
                    UniBall(I).BSpeedX = Abs(UniBall(I).BSpeedX)
                    UniBall(I).BMoveX = UniBall(I).BMoveX * -1
                End If
                If UniBall(I).BSpeedY < 0 Then
                    UniBall(I).BSpeedY = Abs(UniBall(I).BSpeedY)
                    UniBall(I).BMoveY = UniBall(I).BMoveY * -1
                End If
            End If
        End If
    Next
    
    For I = 1 To UBound(Players)
        If (I <> b And Not Players(I).Invisible And Players(I).Mode <> 1) And Wep <> 6 Then
            rBlock.Top = Players(I).charY + 1
            rBlock.Left = Players(I).charX + 1
            rBlock.Bottom = rBlock.Top + 30
            rBlock.Right = rBlock.Left + 30
            If IntersectRect(rTemp, rWho, rBlock) Then
                If ShipRects(I, WY, WX, True) Then
                    WeaponTouch = 2 'Weapon hit player.
                    If WX - MeX > -10 And WY - MeY > -10 And WX - MeX < ResX + 10 And WY - MeY < ResY + 10 Then
                        If I = MeNum And Players(b).Ship <> Players(MeNum).Ship And Players(MeNum).Mode <> 1 Then
                            b = Health
                            If Not Players(MeNum).InPen And Wep = 4 Then b = b - SDamage2(WepRge.SpecialDamage)
                            If Wep = 0 Then
                                b = b - LDamage(WepRge.LaserDamage)
                            End If
                            
                            If Wep = 1 Then b = b - SDamage(WepRge.SpecialDamage)
                            If Wep = 3 Then b = b - LDamage2(WepRge.SpecialDamage) 'Bouncy laser
                            If b < 0 Then b = 0
                            Health = b
                        End If
                        CreateHit I, WX, WY
                        Exit Function
                    End If
                End If
            End If
        End If
    Next
    
nxttest:
    If Wep = 3 Then
        rWho.Top = WY - 2
        rWho.Left = WX - 2
        rWho.Bottom = rWho.Top + 4
        rWho.Right = rWho.Left + 4
    End If
    
    j = (WY And -16) \ 16
    I = (WX And -16) \ 16
    If j < 0 Or I < 0 Then Exit Function
    If Wep = 5 Then
        If Collision(j, I) = 0 Or Collision(j, I) = 2 Then Exit Function
        If Collision(j, I) > -1 And Collision(j, I) < 8 Then
            SgnX = WX - SparkX(WepIndex)
            SgnY = WY - SparkY(WepIndex)
            SgnX = Sgn(SgnX): SgnY = Sgn(SgnY)
            If SourceTile(j, I) = 425 Then If SgnY <> 1 Then WeaponTouch = 1: Exit Function
            If SourceTile(j, I) = 424 Then If SgnX <> 1 Then WeaponTouch = 1: Exit Function
            If SourceTile(j, I) = 422 Then If SgnX <> -1 Then WeaponTouch = 1: Exit Function
            If SourceTile(j, I) = 303 Then If SgnX <> 1 Then WeaponTouch = 1: Exit Function
            If SourceTile(j, I) = 301 Then If SgnX <> -1 Then WeaponTouch = 1: Exit Function
            If SourceTile(j, I) = 225 Then If SgnY <> 1 Then WeaponTouch = 1: Exit Function
            If SourceTile(j, I) = 345 Then If SgnY <> -1 Then WeaponTouch = 1: Exit Function
            If SourceTile(j, I) = 388 Then If SgnY <> 1 Then WeaponTouch = 1: Exit Function
            If SourceTile(j, I) = 308 Then If SgnY <> -1 Then WeaponTouch = 1: Exit Function
            If Collision(j, I) = 4 Then If SgnY = 0 Or SgnY = -1 Then Exit Function
            If Collision(j, I) = 5 Then If SgnY = 0 Or SgnY = 1 Then Exit Function
            If Collision(j, I) = 6 Then If SgnX = 0 Or SgnX = -1 Then Exit Function
            If Collision(j, I) = 7 Then If SgnX = 0 Or SgnX = 1 Then Exit Function
            If Animations(j, I) < 0 And BackBuffer.isLost = 0 Then
                If PixelIntersect2(WX, WY, j, I) Then WeaponTouch = 1
            Else
                WeaponTouch = 1
            End If
        End If
        Exit Function
    End If
    
    If j < 0 Or I < 0 Then
        If Wep = 2 Then WeaponTouch = 3
        Exit Function
    End If
    If j > 255 Or I > 255 Then
        If Wep = 2 Then WeaponTouch = 3
        Exit Function
    End If
    C = I - 1
    d = I + 1
    e = j - 1
    F = j + 1
    For j = e To F
        For I = C To d
            If j < 0 Or I < 0 Then GoTo out
            If j > 255 Or I > 255 Then GoTo out
            If SourceTile(j, I) > -1 Then
                rBlock.Left = I * 16 + RoughTile(SourceTile(j, I)).hLeft
                rBlock.Right = rBlock.Left + 16 - RoughTile(SourceTile(j, I)).hLeft - RoughTile(SourceTile(j, I)).hRight
                rBlock.Top = j * 16 + RoughTile(SourceTile(j, I)).hTop
                rBlock.Bottom = rBlock.Top + 16 - RoughTile(SourceTile(j, I)).hTop - RoughTile(SourceTile(j, I)).hBottom
            Else
                rBlock.Left = I * 16
                rBlock.Right = rBlock.Left + 16
                rBlock.Top = j * 16
                rBlock.Bottom = rBlock.Top + 16
            End If
            If IntersectRect(rTemp, rWho, rBlock) Then
                If Collision(j, I) > -1 And Collision(j, I) < 8 Then
                    If Wep = 0 Then
                        If Collision(j, I) = 0 Or Collision(j, I) = 2 Then GoTo out
                        If SourceTile(j, I) = 425 Then If SgnY <> 1 Then WeaponTouch = 1: Exit Function
                        If SourceTile(j, I) = 424 Then If SgnX <> 1 Then WeaponTouch = 1: Exit Function
                        If SourceTile(j, I) = 422 Then If SgnX <> -1 Then WeaponTouch = 1: Exit Function
                        If SourceTile(j, I) = 303 Then If SgnX <> 1 Then WeaponTouch = 1: Exit Function
                        If SourceTile(j, I) = 301 Then If SgnX <> -1 Then WeaponTouch = 1: Exit Function
                        If SourceTile(j, I) = 225 Then If SgnY <> 1 Then WeaponTouch = 1: Exit Function
                        If SourceTile(j, I) = 345 Then If SgnY <> -1 Then WeaponTouch = 1: Exit Function
                        If SourceTile(j, I) = 388 Then If SgnY <> 1 Then WeaponTouch = 1: Exit Function
                        If SourceTile(j, I) = 308 Then If SgnY <> -1 Then WeaponTouch = 1: Exit Function
                        If Collision(j, I) = 4 Then If SgnY = 0 Or SgnY = -1 Then GoTo out
                        If Collision(j, I) = 5 Then If SgnY = 0 Or SgnY = 1 Then GoTo out
                        If Collision(j, I) = 6 Then If SgnX = 0 Or SgnX = -1 Then GoTo out
                        If Collision(j, I) = 7 Then If SgnX = 0 Or SgnX = 1 Then GoTo out
                        If Animations(j, I) = -1 And BackBuffer.isLost = 0 Then
                            If PixelIntersect2(WX, WY, j, I) Then WeaponTouch = 1: Exit Function
                        Else
                            WeaponTouch = 1: Exit Function
                        End If
                    ElseIf Wep = 1 Then
                        If Collision(j, I) = 0 Or Collision(j, I) = 2 Then GoTo out
                        If SourceTile(j, I) = 425 Then If SgnY <> 1 Then WeaponTouch = 1: Exit Function
                        If SourceTile(j, I) = 424 Then If SgnX <> 1 Then WeaponTouch = 1: Exit Function
                        If SourceTile(j, I) = 422 Then If SgnX <> -1 Then WeaponTouch = 1: Exit Function
                        If SourceTile(j, I) = 303 Then If SgnX <> 1 Then WeaponTouch = 1: Exit Function
                        If SourceTile(j, I) = 301 Then If SgnX <> -1 Then WeaponTouch = 1: Exit Function
                        If SourceTile(j, I) = 225 Then If SgnY <> 1 Then WeaponTouch = 1: Exit Function
                        If SourceTile(j, I) = 345 Then If SgnY <> -1 Then WeaponTouch = 1: Exit Function
                        If SourceTile(j, I) = 388 Then If SgnY <> 1 Then WeaponTouch = 1: Exit Function
                        If SourceTile(j, I) = 308 Then If SgnY <> -1 Then WeaponTouch = 1: Exit Function
                        If Collision(j, I) = 4 Then If SgnY = 0 Or SgnY = -1 Then GoTo out
                        If Collision(j, I) = 5 Then If SgnY = 0 Or SgnY = 1 Then GoTo out
                        If Collision(j, I) = 6 Then If SgnX = 0 Or SgnX = -1 Then GoTo out
                        If Collision(j, I) = 7 Then If SgnX = 0 Or SgnX = 1 Then GoTo out
                        If Animations(j, I) = -1 And BackBuffer.isLost = 0 Then
                            If PixelIntersect2(WX, WY, j, I) Then WeaponTouch = 1: Exit Function
                        Else
                            WeaponTouch = 1: Exit Function
                        End If
                    ElseIf Wep = 2 Or Wep = 4 Then
                        If Animations(j, I) = -2 And Wep = 2 Then WeaponTouch = 3: GoTo out
                        If Collision(j, I) = 0 Or Collision(j, I) = 2 Then GoTo out
                        If SourceTile(j, I) = 425 Then If SgnY <> 1 Then WeaponTouch = 1: Exit Function
                        If SourceTile(j, I) = 424 Then If SgnX <> 1 Then WeaponTouch = 1: Exit Function
                        If SourceTile(j, I) = 422 Then If SgnX <> -1 Then WeaponTouch = 1: Exit Function
                        If SourceTile(j, I) = 303 Then If SgnX <> 1 Then WeaponTouch = 1: Exit Function
                        If SourceTile(j, I) = 301 Then If SgnX <> -1 Then WeaponTouch = 1: Exit Function
                        If SourceTile(j, I) = 225 Then If SgnY <> 1 Then WeaponTouch = 1: Exit Function
                        If SourceTile(j, I) = 345 Then If SgnY <> -1 Then WeaponTouch = 1: Exit Function
                        If SourceTile(j, I) = 388 Then If SgnY <> 1 Then WeaponTouch = 1: Exit Function
                        If SourceTile(j, I) = 308 Then If SgnY <> -1 Then WeaponTouch = 1: Exit Function
                        If Collision(j, I) = 4 Then If SgnY = 0 Or SgnY = -1 Then GoTo out
                        If Collision(j, I) = 5 Then If SgnY = 0 Or SgnY = 1 Then GoTo out
                        If Collision(j, I) = 6 Then If SgnX = 0 Or SgnX = -1 Then GoTo out
                        If Collision(j, I) = 7 Then If SgnX = 0 Or SgnX = 1 Then GoTo out
                        If Animations(j, I) = -1 And BackBuffer.isLost = 0 Then
                            If PixelIntersect3(WX, WY, j, I) Then WeaponTouch = 1: Exit Function
                        Else
                            WeaponTouch = 1: Exit Function
                        End If
                    ElseIf Wep = 3 Then
                        If Collision(j, I) = 0 Or Collision(j, I) = 2 Then GoTo out
                        If SourceTile(j, I) = 425 Then If SgnY <> 1 Then GoTo detect
                        If SourceTile(j, I) = 424 Then If SgnX <> 1 Then GoTo detect
                        If SourceTile(j, I) = 422 Then If SgnX <> -1 Then GoTo detect
                        If SourceTile(j, I) = 303 Then If SgnX <> 1 Then GoTo detect
                        If SourceTile(j, I) = 301 Then If SgnX <> -1 Then GoTo detect
                        If SourceTile(j, I) = 225 Then If SgnY <> 1 Then GoTo detect
                        If SourceTile(j, I) = 345 Then If SgnY <> -1 Then GoTo detect
                        If SourceTile(j, I) = 388 Then If SgnY <> 1 Then GoTo detect
                        If SourceTile(j, I) = 308 Then If SgnY <> -1 Then GoTo detect
                        If Collision(j, I) = 4 Then If SgnY = 0 Or SgnY = -1 Then GoTo out
                        If Collision(j, I) = 5 Then If SgnY = 0 Or SgnY = 1 Then GoTo out
                        If Collision(j, I) = 6 Then If SgnX = 0 Or SgnX = -1 Then GoTo out
                        If Collision(j, I) = 7 Then If SgnX = 0 Or SgnX = 1 Then GoTo out
detect:
                        '3 0 118
                        If Animations(j, I) > -1 And BackBuffer.isLost = 0 Then
                            rWho.Top = WY + SgnY
                            rWho.Bottom = rWho.Top + 1
                            If WX >= I * 16 And WY + SgnY >= j * 16 And WX <= I * 16 + 16 And WY + SgnY <= j * 16 + 16 Then WeaponTouch = 3: TestXY = 1
                            If TestXY = 0 Then
                                rWho.Top = WY
                                rWho.Left = WX + SgnX
                                rWho.Bottom = rWho.Top + 1
                                rWho.Right = rWho.Left + 1
                                If WX + SgnX >= I * 16 And WY >= j * 16 And WX + SgnX <= I * 16 + 16 And WY <= j * 16 + 16 Then WeaponTouch = 3: TestXY = 2
                            End If
                        Else
                            If PixelIntersect2(WX, WY, j, I) = 1 Then WeaponTouch = 3: Exit Function
                            If PixelIntersect2(WX, WY + SgnY, j, I) = 1 Then WeaponTouch = 3: TestXY = 1
                            If TestXY = 0 Then If PixelIntersect2(WX + SgnX, WY, j, I) Then WeaponTouch = 3: TestXY = 2
                        End If
                        If TestXY = 1 Then
                            If BounceAngle(WepIndex) < 1 Then
                                h = Abs(BounceAngle(WepIndex))
                            ElseIf BounceAngle(WepIndex) > 0 And BounceAngle(WepIndex) < 91 Then
                                h = BounceAngle(WepIndex) * -1
                            ElseIf BounceAngle(WepIndex) > 90 And BounceAngle(WepIndex) < 181 Then
                                h = 270 - (BounceAngle(WepIndex) - 90)
                            ElseIf BounceAngle(WepIndex) > 180 And BounceAngle(WepIndex) < 270 Then
                                h = 90 + (270 - BounceAngle(WepIndex))
                            End If
                            C = BounceWho(WepIndex)
                            ReBoun C, WX, WY, h, WepIndex
                            Exit Function
                        ElseIf TestXY = 2 Then
                            If BounceAngle(WepIndex) < 1 Then
                                h = 180 + Abs(BounceAngle(WepIndex))
                            ElseIf BounceAngle(WepIndex) > 0 And BounceAngle(WepIndex) < 91 Then
                                h = 180 - BounceAngle(WepIndex)
                            ElseIf BounceAngle(WepIndex) > 90 And BounceAngle(WepIndex) < 181 Then
                                h = 90 - (BounceAngle(WepIndex) - 90)
                            ElseIf BounceAngle(WepIndex) > 180 And BounceAngle(WepIndex) < 270 Then
                                h = -90 + (270 - BounceAngle(WepIndex))
                            End If ' test done
                            C = BounceWho(WepIndex)
                            ReBoun C, WX, WY, h, WepIndex
                            Exit Function
                        End If
                    ElseIf Wep = 6 Then
                        If Collision(j, I) = 0 Or Collision(j, I) = 3 Then GoTo out
                        WeaponTouch = 6
                        Exit Function
                    End If ' wep checked
                    '
                End If ' collision checked
            End If ' intersected
            
out:
        Next
    Next
End Function

