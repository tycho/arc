Attribute VB_Name = "modDirectX"
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

Public Const DQ = """"

Public DefaultGUID As String

Public ResX As Integer
Public ResY As Integer

Public ResXT As Long
Public ResTop As Integer
Public ResYT As Long

Public Windowed As Boolean

Public CenterX As Integer, CenterY As Integer, CenterSX As Integer, CenterSY As Integer

Public Key As DDCOLORKEY

Public DirectX As DirectX7
Public DirectDraw As DirectDraw7
Public DDClip As DirectDrawClipper
Public d3d As Direct3D7
Public dev As Direct3DDevice7
Public ddsdProperties As DDSURFACEDESC2
Public ddem As DirectDrawEnumModes
Public dx As DirectX7

Public RedShiftLeft As Long
Public RedShiftRight As Long
Public GreenShiftLeft As Long
Public GreenShiftRight As Long
Public BlueShiftLeft As Long
Public BlueShiftRight As Long

Public PrimarySurface As DirectDrawSurface7
Public BackBuffer As DirectDrawSurface7
Public DirectDraw_Map As DirectDrawSurface7
Public DirectDraw_Tile As DirectDrawSurface7
Public DirectDraw_Tuna As DirectDrawSurface7
Public Direct3D_Alpha As DirectDrawSurface7
Public DirectDraw_Farplane As DirectDrawSurface7

Public DirectDraw_Tuna1 As DirectDrawSurface7
Public ddp As DirectDrawPalette

Public DDText As DirectDrawSurface7
Public DirectDraw_Text As DirectDrawSurface7
Public DirectDraw_Text2 As DirectDrawSurface7
Public DirectDraw_Chat As DirectDrawSurface7
Public DirectDraw_Debug As DirectDrawSurface7
Public DirectDraw_TestOnly As DirectDrawSurface7
Public DirectDraw_Miss As DirectDrawSurface7
Public DirectDraw_Ships As DirectDrawSurface7
Public DirectDraw_Extra As DirectDrawSurface7
Public DirectDraw_Sprite As DirectDrawSurface7
Public DirectDraw_Crosshairs As DirectDrawSurface7
Public DirectDraw_Flags As DirectDrawSurface7
Public DirectDraw_Tiles As DirectDrawSurface7
Public DirectDraw_Anims(1) As DirectDrawSurface7
Public DirectDraw_Pop As DirectDrawSurface7
Public DirectDraw_NavBar As DirectDrawSurface7
Public DirectDraw_AdBar As DirectDrawSurface7
Public DirectDraw_Explode As DirectDrawSurface7
Public DirectDraw_ArrowBar As DirectDrawSurface7

Public DirectInput As DirectInput
Public DirectInput_M As DirectInput
Public DirectInput_Dev As DirectInputDevice
Public DirectInput_DevM As DirectInputDevice

Public gObjDX As New DirectX7
Public gObjDSound As DirectSound

Public dsRdOpen As DirectSoundBuffer
Public dsRdClose As DirectSoundBuffer
Public dsMine() As DirectSoundBuffer
Public dsGotPup() As DirectSoundBuffer
Public dsBomb() As DirectSoundBuffer
Public dsMortars() As DirectSoundBuffer
Public dsMortarsL() As DirectSoundBuffer
Public dsPop() As DirectSoundBuffer
Public dsWarp() As DirectSoundBuffer
Public dsWelcome As DirectSoundBuffer
Public dsDropflag() As DirectSoundBuffer
Public dsWin As DirectSoundBuffer
Public dsTeamWins As DirectSoundBuffer
Public dsEngine As DirectSoundBuffer
Public dsLose As DirectSoundBuffer
Public dsSysint As DirectSoundBuffer
Public dsGreen As DirectSoundBuffer
Public dsRed As DirectSoundBuffer
Public dsBlue As DirectSoundBuffer
Public dsYellow As DirectSoundBuffer
Public dsNeutral As DirectSoundBuffer
Public dsTeam As DirectSoundBuffer
Public dsBase As DirectSoundBuffer
Public dsSWFlip As DirectSoundBuffer
Public dsSWSpec As DirectSoundBuffer
Public dsArmCrit As DirectSoundBuffer
Public dsFlagCap As DirectSoundBuffer
Public dsFlagRet As DirectSoundBuffer
Public dsGotMiss As DirectSoundBuffer
Public dsGotMort As DirectSoundBuffer
Public dsGotBoun As DirectSoundBuffer
Public dsLaser() As DirectSoundBuffer
Public dsLasrHitS() As DirectSoundBuffer
Public dsLasrHitW() As DirectSoundBuffer
Public dsMissile() As DirectSoundBuffer
Public dsTires() As DirectSoundBuffer
Public dsRockHits() As DirectSoundBuffer
Public dsRockHitW() As DirectSoundBuffer
Public dsSpawn As DirectSoundBuffer
Public dsBounShot() As DirectSoundBuffer
Public dsBounHits() As DirectSoundBuffer
Public dsBounce() As DirectSoundBuffer
Public bSpecialSnd As Byte
Declare Function BitBlt Lib "gdi32.dll" (ByVal hdcDest As Long, ByVal nXDest As Long, ByVal nYDest As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hdcSrc As Long, ByVal nXSrc As Long, ByVal nYSrc As Long, ByVal dwRop As Long) As Long

Public Sub InitDirectX()
142:       If Not DevEnv Then On Error GoTo ErrorTrap
144:       Load frmDisplay
145:       LoadDirectX7
146:       LoadDirectInput
147:       LoadColorPalette
148:       If Not Windowed Then
149:           If Paletted Then
150:               InitPaletted
151:           Else
152:               InitNotPaletted
153:           End If
154:       Else
155:           NoD3D = True: InitWindowed
156:       End If
157:       If EnableSound Then LoadSounds
158:       SetLoadTitle "Starting game..."
159:       LoadDisplay
160:       If Advertisements Then
161:           InitBanners
162:           LoadBanner
163:           frmDisplay.tmrAdbanner.Enabled = True
164:       End If
165:       frmMain.Timer3.Enabled = True
166:       Exit Sub
ErrorTrap:
168:       RaiseCritical "InitDirectX failed (Line #" & Erl & ")"
169:       Stopping = True
End Sub

Private Sub InitPaletted()
169:       If Not DevEnv Then On Error GoTo errors
170:       If StartLog Then
171:           StartupLog "Initializing for " & ResX & "x" & ResY & "x8..."
172:       End If
173:       Dim ddsd1 As DDSURFACEDESC2, caps As DDSCAPS2
174:       Dim ddsd4 As DDSURFACEDESC2
176:       Set DirectDraw = DirectX.DirectDrawCreate(DefaultGUID)
177:       If StartLog Then
178:           StartupLog "Setting cooperative level..."
179:       End If
180:       Call DirectDraw.SetCooperativeLevel(frmDisplay.hwnd, DDSCL_FULLSCREEN Or DDSCL_EXCLUSIVE)
181:       If StartLog Then
182:           StartupLog "Setting display mode..."
183:       End If
184:       DirectDraw.SetDisplayMode ResX, ResY, 8, Hz, DDSDM_DEFAULT
185:       ddsd1.lFlags = DDSD_CAPS Or DDSD_BACKBUFFERCOUNT
186:       ddsd1.ddsCaps.lCaps = DDSCAPS_PRIMARYSURFACE Or DDSCAPS_FLIP Or DDSCAPS_COMPLEX
187:       ddsd1.ddpfPixelFormat.lFlags = DDPF_PALETTEINDEXED8
188:       ddsd1.lBackBufferCount = 1
189:       If StartLog Then
190:           StartupLog "Creating primary surface..."
191:       End If
192:       Set PrimarySurface = DirectDraw.CreateSurface(ddsd1)
193:       caps.lCaps = DDSCAPS_BACKBUFFER
194:       If StartLog Then
195:           StartupLog "Creating back buffer surface..."
196:       End If
197:       Set BackBuffer = PrimarySurface.GetAttachedSurface(caps)
198:       BackBuffer.GetSurfaceDesc ddsd4
199:       If StartLog Then
200:           StartupLog "Graphics have initialized successfully!"
201:       End If
202:       Exit Sub
errors:
204:       RaiseCritical "InitPaletted failed. (Line #" & Erl & ")"
205:       Stopping = True
End Sub

Private Sub InitWindowed()
208:       If Not DevEnv Then On Error GoTo errors
209:       Dim ddsd1 As DDSURFACEDESC2, caps As DDSCAPS2
210:       Dim ddsd4 As DDSURFACEDESC2
211:       If StartLog Then
212:           StartupLog "Initializing for " & ResX & "x" & ResY & " in windowed mode..."
213:       End If
214:       ResXT = ResX * Screen.TwipsPerPixelX
215:       ResYT = ResY * Screen.TwipsPerPixelY
216:       ResTop = Abs(CInt(GetSettingString(HKEY_CURRENT_USER, "Control Panel\Desktop\WindowMetrics", "CaptionHeight"))) / Screen.TwipsPerPixelY
217:       Set DirectDraw = DirectX.DirectDrawCreate(DefaultGUID)
218:       frmDisplay.Move CenterX - (ResXT / 2), CenterY - (frmDisplay.Height + ((ResY - frmDisplay.ScaleHeight) * Screen.TwipsPerPixelY)), ResXT, frmDisplay.Height + ((ResY - frmDisplay.ScaleHeight) * Screen.TwipsPerPixelY)
219:       If StartLog Then
220:           StartupLog "Setting cooperative level..."
221:       End If
222:       Call DirectDraw.SetCooperativeLevel(frmDisplay.hwnd, DDSCL_NORMAL)
223:       ddsd1.lFlags = DDSD_CAPS
224:       ddsd1.ddsCaps.lCaps = DDSCAPS_PRIMARYSURFACE Or DDSCAPS_3DDEVICE Or DDSCAPS_VIDEOMEMORY
225:       If StartLog Then
226:           StartupLog "Creating primary surface..."
227:       End If
228:       Set PrimarySurface = DirectDraw.CreateSurface(ddsd1)
229:       If StartLog Then
230:           StartupLog "Creating clipper..."
231:       End If
232:       Set DDClip = DirectDraw.CreateClipper(0)
233:       DDClip.SetHWnd frmDisplay.hwnd
234:       PrimarySurface.SetClipper DDClip
pass3:
1251:      If Not LowMem And Not LowVRAM Then ddsd4.ddsCaps.lCaps = DDSCAPS_OFFSCREENPLAIN Or DDSCAPS_VIDEOMEMORY
1252:      If LowVRAM Then ddsd4.ddsCaps.lCaps = DDSCAPS_OFFSCREENPLAIN Or DDSCAPS_SYSTEMMEMORY
235:       ddsd4.ddsCaps.lCaps = DDSCAPS_OFFSCREENPLAIN Or DDSCAPS_VIDEOMEMORY
236:       ddsd4.lFlags = DDSD_CAPS Or DDSD_WIDTH Or DDSD_HEIGHT
237:       ddsd4.lHeight = ResY
238:       ddsd4.lWidth = ResX
239:       If StartLog Then
240:           StartupLog "Creating fake back buffer surface..."
241:       End If
242:       Set BackBuffer = DirectDraw.CreateSurface(ddsd4)
243:       BackBuffer.GetSurfaceDesc ddsd4
244:       If StartLog Then
245:           StartupLog "Graphics have initialized successfully!"
246:       End If
247:       Exit Sub
352:       If Erl = 228 Or Erl = 242 Then
353:           Err.Clear
354:           If StartLog Then
355:               StartupLog "WARNING: Window initialization failed. Retrying with low memory assumption."
356:           End If
357:           LowMem = True
359:           GoTo pass3
368:       Else
369:           RaiseCritical "InitWindowed failed. (Line #" & Erl & ". " & Err.Description & ")"
370:       End If
371:       Stopping = True
errors:
    RaiseCritical "InitWindowed failed. (Line #" & Erl & ")"
    Stopping = True
End Sub

Public Sub SetupPalette()
    If Not DevEnv Then On Error GoTo errors
    Dim I As Integer
    Dim BFHEADER As BITMAPFILEHEADER
    Dim BINFOHEADER As BITMAPINFOHEADER
    Dim Dummy As Byte
    Dim ddpe(255) As PALETTEENTRY
    Dim iFreeFile As Integer
    iFreeFile = FreeFile
    If FileExists(AppPath & "graphics.patch\Farplane.bmp") Then
        Open AppPath & "graphics.patch\Farplane.bmp" For Binary Access Read As #iFreeFile
    Else
        Open AppPath & "graphics\Farplane.bmp" For Binary Access Read As #iFreeFile
    End If
    Get #1, , BFHEADER
    Get #1, , BINFOHEADER
    For I = 0 To 255
        Get #1, , ddpe(I).Blue
        Get #1, , ddpe(I).Green
        Get #1, , ddpe(I).Red
        Get #1, , Dummy
    Next I
    Close #1
    Set ddp = DirectDraw.CreatePalette(DDPCAPS_8BIT Or DDPCAPS_ALLOW256, ddpe())
    PrimarySurface.SetPalette ddp
    Exit Sub
errors:
    RaiseCritical "SetupPalette failed."
    Stopping = True
End Sub

Private Sub InitNotPaletted()
285:       On Error GoTo errors
286:       Dim ddsd1 As DDSURFACEDESC2, caps As DDSCAPS2
287:       Dim ddsd4 As DDSURFACEDESC2
288:       If StartLog Then
289:           StartupLog "Initializing for " & ResX & "x" & ResY & "x16..."
290:       End If
291:       If NoD3D Then GoTo pase2
292:       Set DirectDraw = DirectX.DirectDrawCreate(DefaultGUID)
293:       If StartLog Then
294:           StartupLog "Setting cooperative level..."
295:       End If
296:       Call DirectDraw.SetCooperativeLevel(frmDisplay.hwnd, DDSCL_FULLSCREEN Or DDSCL_EXCLUSIVE)
297:       If StartLog Then
298:           StartupLog "Setting display mode..."
299:       End If
300:       DirectDraw.SetDisplayMode ResX, ResY, 16, Hz, DDSDM_DEFAULT
301:       ddsd1.lFlags = DDSD_CAPS Or DDSD_BACKBUFFERCOUNT
302:       ddsd1.ddsCaps.lCaps = DDSCAPS_PRIMARYSURFACE Or DDSCAPS_FLIP Or DDSCAPS_COMPLEX Or DDSCAPS_3DDEVICE Or DDSCAPS_VIDEOMEMORY Or DDSCAPS_LOCALVIDMEM
303:       ddsd1.lBackBufferCount = 1
304:       If StartLog Then
305:           StartupLog "Creating primary surface..."
306:       End If
307:       Set PrimarySurface = DirectDraw.CreateSurface(ddsd1)
308:       caps.lCaps = DDSCAPS_BACKBUFFER
309:       If StartLog Then
310:           StartupLog "Creating back buffer surface..."
311:       End If
312:       Set BackBuffer = PrimarySurface.GetAttachedSurface(caps)
313:       BackBuffer.GetSurfaceDesc ddsd4
314:       If StartLog Then
315:           StartupLog "Initializing Direct3D..."
316:       End If
317:       Set d3d = DirectDraw.GetDirect3D
318:       If StartLog Then
319:           StartupLog "Initializing Direct3D device..."
320:       End If
321:       Set dev = d3d.CreateDevice("IID_IDirect3DHALDevice", BackBuffer)
322:       Exit Sub
pase2:
324:       On Error GoTo errors
325:       NoD3D = True
326:       Set DirectDraw = DirectX.DirectDrawCreate(DefaultGUID)
327:       If StartLog Then
328:           StartupLog "Setting cooperative level..."
329:       End If
330:       Call DirectDraw.SetCooperativeLevel(frmDisplay.hwnd, DDSCL_FULLSCREEN Or DDSCL_EXCLUSIVE)
331:       If StartLog Then
332:           StartupLog "Setting display mode..."
333:       End If
334:       DirectDraw.SetDisplayMode ResX, ResY, 16, Hz, DDSDM_DEFAULT
pase3:
336:       On Error GoTo errors
337:       ddsd1.lFlags = DDSD_CAPS Or DDSD_BACKBUFFERCOUNT
338:       ddsd1.ddsCaps.lCaps = DDSCAPS_PRIMARYSURFACE Or DDSCAPS_FLIP Or DDSCAPS_COMPLEX
339:       ddsd1.lBackBufferCount = 1
340:       If StartLog Then
341:           StartupLog "Creating primary surface..."
342:       End If
343:       Set PrimarySurface = DirectDraw.CreateSurface(ddsd1)
344:       caps.lCaps = DDSCAPS_BACKBUFFER
345:       If StartLog Then
346:           StartupLog "Creating back buffer surface..."
347:       End If
348:       Set BackBuffer = PrimarySurface.GetAttachedSurface(caps)
349:       BackBuffer.GetSurfaceDesc ddsd4
350:       Exit Sub
errors:
352:       If Erl = 296 Or Erl = 300 Or Erl = 307 Or Erl = 312 Or Erl = 317 Or Erl = 321 Then
353:           Err.Clear
354:           If StartLog Then
                   StartupLog "WARNING: Direct3D is apparently unavailable. Disabling for this session."
356:           End If
357:           NoD3D = True
358:           'SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "NoD3D", 1
359:           GoTo pase3
360:       ElseIf Erl = 334 Or Erl = 343 Or Erl = 348 Then
361:           Err.Clear
362:           If StartLog Then
                   StartupLog "WARNING: 16-bit color is causing errors. Reverting to 8-bit mode (restart required)."
364:           End If
365:           Paletted = True
366:           SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "8BitColor", 1
367:           RaiseCritical ProjectName & " has automatically adjusted some settings to make itself compatible with your machine. Please retry joining a game."
368:       Else
369:           RaiseCritical "InitNotPaletted failed. (Line #" & Erl & ". " & Err.Description & ")"
370:       End If
371:       Stopping = True
End Sub

Function ExModeActive() As Boolean
    Dim TestCoopRes As Long
    TestCoopRes = DirectDraw.TestCooperativeLevel
    If (TestCoopRes = DD_OK) Then
        ExModeActive = True
    Else
        ExModeActive = False
    End If
End Function

Private Sub LoadColorPalette()
    Dim I As Integer
    For I = 0 To 255
        If I > 128 + 16 Or I < 128 Then
            PurpIndex(I) = I Mod 16 + 32
        Else
            PurpIndex(I) = I
        End If
        
        If I > 48 + 16 Or I < 48 Then
            RedIndex(I) = I Mod 16 + 48
        Else
            RedIndex(I) = I
        End If
        
        If I > 80 + 16 Or I < 80 Then
            BlueIndex(I) = I Mod 16 + 80
        Else
            BlueIndex(I) = I
        End If
    Next
End Sub

Private Sub LoadDirectX7()
408:       If Not DevEnv Then On Error GoTo ErrorTrap
409:       If StartLog Then
410:           StartupLog "Creating DirectX7 object..."
411:       End If
412:       Set dx = New DirectX7
413:       Set DirectX = New DirectX7
414:       Exit Sub
ErrorTrap:
416:       RaiseCritical "DirectX load failed (Line #" & Erl & ": '" & Err.Description & "')"
End Sub

Private Sub LoadDirectInput()
    SetLoadTitle "DirectX: Loading DI..."
    If StartLog Then
        StartupLog "Setting up DirectInput keyboard device..."
    End If
    Set DirectInput = dx.DirectInputCreate
    Set DirectInput_Dev = DirectInput.CreateDevice("GUID_SysKeyboard")
End Sub

Private Sub LoadSounds()
429:       On Error GoTo errors
430:       SetLoadTitle "DirectX: Loading sounds..."
431:       InitSnd
432:       If Not gObjDSound Is Nothing And EnableSound Then
433:           If FileExists(AppPath & "sound.patch\mine.wav") Then
434:               Call LoadWave("mine", AppPath & "sound.patch\mine.wav")
435:           Else
436:               Call LoadWave("mine", AppPath & "sound\mine.wav")
437:           End If
438:           If FileExists(AppPath & "sound.patch\gotpup.wav") Then
439:               Call LoadWave("gotpup", AppPath & "sound.patch\gotpup.wav")
440:           Else
441:               Call LoadWave("gotpup", AppPath & "sound\gotpup.wav")
442:           End If
443:           If FileExists(AppPath & "sound.patch\rd_open.wav") Then
444:               Call LoadWave("rdopen", AppPath & "sound.patch\rd_open.wav")
445:           Else
446:               Call LoadWave("rdopen", AppPath & "sound\rd_open.wav")
447:           End If
448:           If FileExists(AppPath & "sound.patch\rd_close.wav") Then
449:               Call LoadWave("rdclose", AppPath & "sound.patch\rd_close.wav")
450:           Else
451:               Call LoadWave("rdclose", AppPath & "sound\rd_close.wav")
452:           End If
453:           If FileExists(AppPath & "sound.patch\morthit.wav") Then
454:               Call LoadWave("mortar", AppPath & "sound.patch\morthit.wav")
455:           Else
456:               Call LoadWave("mortar", AppPath & "sound\morthit.wav")
457:           End If
458:           If FileExists(AppPath & "sound.patch\mortlnch.wav") Then
459:               Call LoadWave("mortarlaunch", AppPath & "sound.patch\mortlnch.wav")
460:           Else
461:               Call LoadWave("mortarlaunch", AppPath & "sound\mortlnch.wav")
462:           End If
463:           If FileExists(AppPath & "sound.patch\shipexpl.wav") Then
464:               Call LoadWave("pop", AppPath & "sound.patch\shipexpl.wav")
465:           Else
466:               Call LoadWave("pop", AppPath & "sound\shipexpl.wav")
467:           End If
468:           If FileExists(AppPath & "sound.patch\welcome.wav") Then
469:               Call LoadWave("welcome", AppPath & "sound.patch\welcome.wav")
470:           Else
471:               Call LoadWave("welcome", AppPath & "sound\welcome.wav")
472:           End If
473:           If FileExists(AppPath & "sound.patch\dropflag.wav") Then
474:               Call LoadWave("dropflag", AppPath & "sound.patch\dropflag.wav")
475:           Else
476:               Call LoadWave("dropflag", AppPath & "sound\dropflag.wav")
477:           End If
478:           If FileExists(AppPath & "sound.patch\spawn.wav") Then
479:               Call LoadWave("spawn", AppPath & "sound.patch\spawn.wav")
480:           Else
481:               Call LoadWave("spawn", AppPath & "sound\spawn.wav")
482:           End If
483:           If FileExists(AppPath & "sound.patch\laser.wav") Then
484:               Call LoadWave("laser", AppPath & "sound.patch\laser.wav")
485:           Else
486:               Call LoadWave("laser", AppPath & "sound\laser.wav")
487:           End If
488:           If FileExists(AppPath & "sound.patch\lasrhits.wav") Then
489:               Call LoadWave("lasrhits", AppPath & "sound.patch\lasrhits.wav")
490:           Else
491:               Call LoadWave("lasrhits", AppPath & "sound\lasrhits.wav")
492:           End If
493:           If FileExists(AppPath & "sound.patch\lasrhitw.wav") Then
494:               Call LoadWave("lasrhitw", AppPath & "sound.patch\lasrhitw.wav")
495:           Else
496:               Call LoadWave("lasrhitw", AppPath & "sound\lasrhitw.wav")
497:           End If
498:           If FileExists(AppPath & "sound.patch\bounshot.wav") Then
499:               Call LoadWave("bounshot", AppPath & "sound.patch\bounshot.wav")
500:           Else
501:               Call LoadWave("bounshot", AppPath & "sound\bounshot.wav")
502:           End If
503:           If FileExists(AppPath & "sound.patch\bounhits.wav") Then
504:               Call LoadWave("bounhits", AppPath & "sound.patch\bounhits.wav")
505:           Else
506:               Call LoadWave("bounhits", AppPath & "sound\bounhits.wav")
507:           End If
508:           If FileExists(AppPath & "sound.patch\bounce.wav") Then
509:               Call LoadWave("bounce", AppPath & "sound.patch\bounce.wav")
510:           Else
511:               Call LoadWave("bounce", AppPath & "sound\bounce.wav")
512:           End If
513:           If FileExists(AppPath & "sound.patch\win.wav") Then
514:               Call LoadWave("win", AppPath & "sound.patch\win.wav")
515:           Else
516:               Call LoadWave("win", AppPath & "sound\win.wav")
517:           End If
518:           If FileExists(AppPath & "sound.patch\teamwins.wav") Then
519:               Call LoadWave("teamwins", AppPath & "sound.patch\teamwins.wav")
520:           Else
521:               Call LoadWave("teamwins", AppPath & "sound\teamwins.wav")
522:           End If
523:           If FileExists(AppPath & "sound.patch\lose.wav") Then
524:               Call LoadWave("lose", AppPath & "sound.patch\lose.wav")
525:           Else
526:               Call LoadWave("lose", AppPath & "sound\lose.wav")
527:           End If
528:           If FileExists(AppPath & "sound.patch\sysinit.wav") Then
529:               Call LoadWave("sysinit", AppPath & "sound.patch\sysinit.wav")
530:           Else
531:               Call LoadWave("sysinit", AppPath & "sound\sysinit.wav")
532:           End If
533:           If FileExists(AppPath & "sound.patch\green.wav") Then
534:               Call LoadWave("green", AppPath & "sound.patch\green.wav")
535:           Else
536:               Call LoadWave("green", AppPath & "sound\green.wav")
537:           End If
538:           If FileExists(AppPath & "sound.patch\red.wav") Then
539:               Call LoadWave("red", AppPath & "sound.patch\red.wav")
540:           Else
541:               Call LoadWave("red", AppPath & "sound\red.wav")
542:           End If
543:           If FileExists(AppPath & "sound.patch\blue.wav") Then
544:               Call LoadWave("blue", AppPath & "sound.patch\blue.wav")
545:           Else
546:               Call LoadWave("blue", AppPath & "sound\blue.wav")
547:           End If
548:           If FileExists(AppPath & "sound.patch\yellow.wav") Then
549:               Call LoadWave("yellow", AppPath & "sound.patch\yellow.wav")
550:           Else
551:               Call LoadWave("yellow", AppPath & "sound\yellow.wav")
552:           End If
553:           If FileExists(AppPath & "sound.patch\neutral.wav") Then
554:               Call LoadWave("neutral", AppPath & "sound.patch\neutral.wav")
555:           Else
556:               Call LoadWave("neutral", AppPath & "sound\neutral.wav")
557:           End If
558:           If FileExists(AppPath & "sound.patch\team.wav") Then
559:               Call LoadWave("team", AppPath & "sound.patch\team.wav")
560:           Else
561:               Call LoadWave("team", AppPath & "sound\team.wav")
562:           End If
563:           If FileExists(AppPath & "sound.patch\flagcap.wav") Then
564:               Call LoadWave("flagcap", AppPath & "sound.patch\flagcap.wav")
565:           Else
566:               Call LoadWave("flagcap", AppPath & "sound\flagcap.wav")
567:           End If
568:           If FileExists(AppPath & "sound.patch\flagret.wav") Then
569:               Call LoadWave("flagret", AppPath & "sound.patch\flagret.wav")
570:           Else
571:               Call LoadWave("flagret", AppPath & "sound\flagret.wav")
572:           End If
573:           If FileExists(AppPath & "sound.patch\base.wav") Then
574:               Call LoadWave("base", AppPath & "sound.patch\base.wav")
575:           Else
576:               Call LoadWave("base", AppPath & "sound\base.wav")
577:           End If
578:           If FileExists(AppPath & "sound.patch\armorlo.wav") Then
579:               Call LoadWave("armcrit", AppPath & "sound.patch\armorlo.wav")
580:           Else
581:               Call LoadWave("armcrit", AppPath & "sound\armorlo.wav")
582:           End If
583:           If FileExists(AppPath & "sound.patch\got_miss.wav") Then
584:               Call LoadWave("gotmiss", AppPath & "sound.patch\got_miss.wav")
585:           Else
586:               Call LoadWave("gotmiss", AppPath & "sound\got_miss.wav")
587:           End If
588:           If FileExists(AppPath & "sound.patch\got_mort.wav") Then
589:               Call LoadWave("gotmort", AppPath & "sound.patch\got_mort.wav")
590:           Else
591:               Call LoadWave("gotmort", AppPath & "sound\got_mort.wav")
592:           End If
593:           If FileExists(AppPath & "sound.patch\got_boun.wav") Then
594:               Call LoadWave("gotboun", AppPath & "sound.patch\got_boun.wav")
595:           Else
596:               Call LoadWave("gotboun", AppPath & "sound\got_boun.wav")
597:           End If
598:           If FileExists(AppPath & "sound.patch\sw_flip.wav") Then
599:               Call LoadWave("swflip", AppPath & "sound.patch\sw_flip.wav")
600:           Else
601:               Call LoadWave("swflip", AppPath & "sound\sw_flip.wav")
602:           End If
603:           If FileExists(AppPath & "sound.patch\sw_spec.wav") Then
604:               Call LoadWave("swspec", AppPath & "sound.patch\sw_spec.wav")
605:           Else
606:               Call LoadWave("swspec", AppPath & "sound\sw_spec.wav")
607:           End If
608:           If FileExists(AppPath & "sound.patch\missile.wav") Then
609:               Call LoadWave("missile", AppPath & "sound.patch\missile.wav")
610:           Else
611:               Call LoadWave("missile", AppPath & "sound\missile.wav")
612:           End If
613:           If FileExists(AppPath & "sound.patch\rockhits.wav") Then
614:               Call LoadWave("rockhits", AppPath & "sound.patch\rockhits.wav")
615:           Else
616:               Call LoadWave("rockhits", AppPath & "sound\rockhits.wav")
617:           End If
618:           If FileExists(AppPath & "sound.patch\rockhitw.wav") Then
619:               Call LoadWave("rockhitw", AppPath & "sound.patch\rockhitw.wav")
620:           Else
621:               Call LoadWave("rockhitw", AppPath & "sound\rockhitw.wav")
622:           End If
623:           If FileExists(AppPath & "sound.patch\warp.wav") Then
624:               Call LoadWave("warp", AppPath & "sound.patch\warp.wav")
625:           Else
626:               Call LoadWave("warp", AppPath & "sound\warp.wav")
627:           End If
628:           If FileExists(AppPath & "sound.patch\mine.wav") Then
629:               Call LoadWave("mine", AppPath & "sound.patch\mine.wav")
630:           Else
631:               Call LoadWave("mine", AppPath & "sound\mine.wav")
632:           End If
633:       End If
634:       Exit Sub
errors:
636:       If StartLog Then
637:           StartupLog "WARNING: An error within LoadSounds() occurred on line " & Erl & " (" & Err.Description & ")."
639:           StartupLog "WARNING: Sound will be disabled for the remainder of this run."
640:       End If
641:       EnableSound = False
End Sub

Private Sub LoadWave(SoundType As String, sFile As String)
    Dim dsBuf As DSBUFFERDESC
    Dim gW As WAVEFORMATEX
    dsBuf.lFlags = DSBCAPS_CTRLFREQUENCY Or DSBCAPS_CTRLPAN Or DSBCAPS_CTRLVOLUME
    If SoundType = "rdopen" Then
        Set dsRdOpen = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "rdclose" Then
        Set dsRdClose = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "mine" Then
        ReDim dsMine(0)
        Set dsMine(0) = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "gotpup" Then
        ReDim dsGotPup(0)
        Set dsGotPup(0) = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "bomb" Then
        ReDim dsBomb(0)
        Set dsBomb(0) = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "Miss" Then
        ReDim dsMiss(0)
        Set dsMiss(0) = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "engine" Then
        Set dsEngine = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "tires" Then
        ReDim dsTires(0)
        Set dsTires(0) = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "mortar" Then
        ReDim dsMortars(0)
        Set dsMortars(0) = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "mortarlaunch" Then
        ReDim dsMortarsL(0)
        Set dsMortarsL(0) = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "pop" Then
        ReDim dsPop(0)
        Set dsPop(0) = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "welcome" Then
        Set dsWelcome = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "dropflag" Then
        ReDim dsDropflag(0)
        Set dsDropflag(0) = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "spawn" Then
        Set dsSpawn = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "laser" Then
        ReDim dsLaser(0)
        Set dsLaser(0) = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "lasrhits" Then
        ReDim dsLasrHitS(0)
        Set dsLasrHitS(0) = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "lasrhitw" Then
        ReDim dsLasrHitW(0)
        Set dsLasrHitW(0) = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "bounshot" Then
        ReDim dsBounShot(0)
        Set dsBounShot(0) = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "bounhits" Then
        ReDim dsBounHits(0)
        Set dsBounHits(0) = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "bounce" Then
        ReDim dsBounce(0)
        Set dsBounce(0) = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "win" Then
        Set dsWin = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "lose" Then
        Set dsLose = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "sysint" Then
        Set dsSysint = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "green" Then
        Set dsGreen = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "red" Then
        Set dsRed = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "blue" Then
        Set dsBlue = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "yellow" Then
        Set dsYellow = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "neutral" Then
        Set dsNeutral = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "team" Then
        Set dsTeam = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "base" Then
        Set dsBase = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "flagcap" Then
        Set dsFlagCap = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "flagret" Then
        Set dsFlagRet = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "teamwins" Then
        Set dsTeamWins = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "armcrit" Then
        Set dsArmCrit = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "gotmiss" Then
        Set dsGotMiss = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "gotmort" Then
        Set dsGotMort = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "gotboun" Then
        Set dsGotBoun = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "swflip" Then
        Set dsSWFlip = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "swspec" Then
        Set dsSWSpec = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "missile" Then
        ReDim dsMissile(0)
        Set dsMissile(0) = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "rockhits" Then
        ReDim dsRockHits(0)
        Set dsRockHits(0) = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "rockhitw" Then
        ReDim dsRockHitW(0)
        Set dsRockHitW(0) = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    ElseIf SoundType = "warp" Then
        ReDim dsWarp(0)
        Set dsWarp(0) = gObjDSound.CreateSoundBufferFromFile(sFile, dsBuf, gW)
    End If
    If Err.Number <> 0 Then
        RaiseCritical "Unable to load " + sFile
        Stopping = True
    End If
End Sub

Private Sub InitSnd()
    Set gObjDSound = DirectX.DirectSoundCreate("")
    gObjDSound.SetCooperativeLevel frmDisplay.hwnd, DSSCL_PRIORITY
    'If Err.Number <> 0 Then
    '    Set gObjDSound = Nothing
    '    EnableSound = False
    '    Err.Clear
    'End If
End Sub

Private Sub LoadDisplay()
693:       If Not DevEnv Then On Error GoTo ErrorTrap
694:       frmSplash.Hide
695:       frmDisplay.Show
696:       'LockWindowUpdate frmDisplay.hWnd
697:       DirectInput_Dev.SetCommonDataFormat DIFORMAT_KEYBOARD
698:       DirectInput_Dev.SetCooperativeLevel frmDisplay.hwnd, DISCL_NONEXCLUSIVE Or DISCL_BACKGROUND
699:       LoadAnims
700:       BuildRects
701:       If Paletted Then SetupPalette
702:       PlainSystemPlanes
703:       IntDX True
704:       If Not NoD3D Then IntDX3D
705:       MouseCalls
706:       KeyConfig
           If StartLog Then
                StartupLog "-------------------------------"
                StartupLog "- ENTERING STARTUP RUNLEVEL 4 -"
                StartupLog "-------------------------------"
           End If
707:       frmDisplay.Timer2.Enabled = True
708:       Exit Sub
ErrorTrap:
710:       RaiseCritical "LoadDisplay failed (Line #" & Erl & ")"
End Sub

Private Sub LoadAnims()
    Dim b As Byte, C As Byte, I As Integer, a As Integer, j As Integer
    If Len(Dir(AppPath & "anims.dat")) = 0 Then GoTo leave
    Open AppPath & "anims.dat" For Binary As #1
    Seek #1, 23
    Get #1, , b
    If b <> 143 Then
        Close #1
        GoTo leave
    End If
    For I = 0 To 255
        Seek #1, I * 66 + 1
        Get #1, , b
        Get #1, , C
        If b > 0 Then
            FrameCount(I) = b
            AnimSpeed(I) = C
        End If
        If b - 1 > UBound(AnimFrames, 2) Then ReDim Preserve AnimFrames(255, b - 1), AnimFX(255, b - 1), AnimFY(255, b - 1), AnimFS(255, b - 1)
        For j = 0 To b - 1
            Get #1, , a
            AnimFrames(I, j) = a
        Next
    Next
    Close #1
    Exit Sub
leave:
    RaiseCritical "Failed to load anims.dat. Try reinstalling " & ProjectName & "."
    Stopping = True
End Sub

Public Sub IntDX3D()
504:    Dim SurfaceDesc As DDSURFACEDESC2
505:    If Not DevEnv Then On Error GoTo ErrorTrap
        If StartLog Then
            StartupLog "Setting up Direct3D_Alpha surface..."
        End If
506:    SurfaceDesc.lFlags = DDSD_CAPS Or DDSD_WIDTH Or DDSD_HEIGHT
507:    SurfaceDesc.ddsCaps.lCaps = DDSCAPS_TEXTURE
508:    SurfaceDesc.ddsCaps.lCaps2 = DDSCAPS2_TEXTUREMANAGE
509:    'Set Direct3D_Alpha = DirectDraw.CreateSurfaceFromFile(AppPath & "gfx.bmp", SurfaceDesc)
510:    SurfaceDesc.lWidth = 128
511:    SurfaceDesc.lHeight = 128
512:    Set Direct3D_Alpha = DirectDraw.CreateSurface(SurfaceDesc)
        Direct3D_Alpha.SetFillColor RGB(0, 0, 0): Direct3D_Alpha.SetForeColor RGB(0, 0, 0)
514:    Direct3D_Alpha.DrawBox 0, 0, 100, 94
        Direct3D_Alpha.SetFillColor RGB(200, 0, 0): Direct3D_Alpha.SetForeColor RGB(200, 0, 0)
516:    Direct3D_Alpha.DrawBox 0, 95, 101, 109
        Direct3D_Alpha.SetFillColor RGB(0, 50, 220): Direct3D_Alpha.SetForeColor RGB(0, 100, 255)
518:    Direct3D_Alpha.DrawBox 0, 109, 101, 125
519:
520:    Exit Sub
521:
ErrorTrap:
523:    RaiseCritical "Initializing Direct3D failed. (Line #" & Erl & ")"
524:    Stopping = True
End Sub

Public Sub MouseCalls()
    g_cursorx = frmDisplay.ScaleWidth \ 2
    g_cursory = frmDisplay.ScaleHeight \ 2
    Set DirectInput_M = dx.DirectInputCreate
    Set DirectInput_DevM = DirectInput_M.CreateDevice("guid_SysMouse")
    Call DirectInput_DevM.SetCommonDataFormat(DIFORMAT_MOUSE)
    Call DirectInput_DevM.SetCooperativeLevel(frmDisplay.hwnd, DISCL_FOREGROUND Or DISCL_EXCLUSIVE)
    Dim diProp As DIPROPLONG
    diProp.lHow = DIPH_DEVICE
    diProp.lObj = 0
    diProp.lData = 50
    diProp.lSize = Len(diProp)
    Call DirectInput_DevM.SetProperty("DIPROP_BUFFERSIZE", diProp)
    EventHandle = dx.CreateEvent(frmDisplay)
    Call DirectInput_DevM.SetEventNotification(EventHandle)
End Sub

Public Sub SpecialSnd(WepSnd As Byte, Optional isVoiced As Boolean = False)
    If Not gObjDSound Is Nothing Then
        If EnableSound Then
            If cfgwv Xor isVoiced Then
                If WepSnd = 1 Then
                    dsGotMort.Stop
                    dsGotBoun.Stop
                    dsGotMiss.SetCurrentPosition 0
                    dsGotMiss.Play DSBPLAY_DEFAULT
                ElseIf WepSnd = 2 Then
                    dsGotBoun.Stop
                    dsGotMiss.Stop
                    dsGotMort.SetCurrentPosition 0
                    dsGotMort.Play DSBPLAY_DEFAULT
                ElseIf WepSnd = 3 Then
                    dsGotMiss.Stop
                    dsGotMort.Stop
                    dsGotBoun.SetCurrentPosition 0
                    dsGotBoun.Play DSBPLAY_DEFAULT
                End If
            ElseIf cfgwv And isVoiced Then
            'nothing!
            Else
                dsSWSpec.Play DSBPLAY_DEFAULT
            End If
        End If
    End If
End Sub

Public Sub Clean()
    If Not DirectInput_Dev Is Nothing Then DirectInput_Dev.Unacquire
    If EventHandle <> 0 Then dx.DestroyEvent EventHandle
    
    Set DirectInput = Nothing
    Set DirectInput_M = Nothing
    Set gObjDSound = Nothing
    Set DirectInput_Dev = Nothing
    Set DirectInput_DevM = Nothing
    '
    Set DirectDraw_Tile = Nothing
    Set DirectDraw_Tuna = Nothing
    Set DirectDraw_Farplane = Nothing
    Set DirectDraw_Map = Nothing
    
    Set DirectDraw_Tuna1 = Nothing
    Set Direct3D_Alpha = Nothing
    Set DDText = Nothing
    Set DirectDraw_Text = Nothing
    Set DirectDraw_Text2 = Nothing
    Set DirectDraw_Miss = Nothing
    Set DirectDraw_Ships = Nothing
    Set DirectDraw_Sprite = Nothing
    Set DirectDraw_Crosshairs = Nothing
    Set DirectDraw_Flags = Nothing
    Set DirectDraw_Tiles = Nothing
    Set DirectDraw_Anims(0) = Nothing
    Set DirectDraw_Anims(1) = Nothing
    Set DirectDraw_Pop = Nothing
    Set DirectDraw_NavBar = Nothing
    Set DirectDraw_AdBar = Nothing
    Set DirectDraw_Explode = Nothing
    Set DirectDraw_ArrowBar = Nothing
    
    Set d3d = Nothing
    Set dev = Nothing
    Set BackBuffer = Nothing
    Set PrimarySurface = Nothing
    '
    Set DirectDraw = Nothing
    Set gObjDX = Nothing
    Set DirectX = Nothing
End Sub

Public Sub KeyConfig(Optional QControl As Boolean)
    DIKey(0, 0) = 75: DIKey(0, 1) = 203 'move left
    DIKey(1, 0) = 77: DIKey(1, 1) = 205 'move right
    DIKey(2, 0) = 72: DIKey(2, 1) = 200 'move up
    DIKey(3, 0) = 80: DIKey(3, 1) = 208 'move down
    If QControl Then
        DIKey(0, 1) = 31 'move left
        DIKey(1, 1) = 33 'move right
        DIKey(2, 1) = 18 'move up
        DIKey(3, 1) = 32 'move down
    End If
    DIKey(4, 0) = 71 'move up-left
    DIKey(5, 0) = 73 'move up-right
    DIKey(6, 0) = 79 'move down-left
    DIKey(7, 0) = 81 'move down-right
    DIKey(8, 0) = 211 'cruise left
    DIKey(9, 0) = 209 'cruise right
    DIKey(10, 0) = 199 'cruise up
    DIKey(11, 0) = 207 'cruise down
    DIKey(12, 0) = 210: DIKey(12, 1) = 201 'cruise stop
    DIKey(13, 0) = 157: DIKey(13, 1) = 29 'next special
    DIKey(14, 0) = 0 'prev special
    DIKey(15, 0) = 67 'no special
    DIKey(16, 0) = 68 'select missile
    DIKey(17, 0) = 87 'select grenade
    DIKey(18, 0) = 88 'select bouncy
    DIKey(19, 0) = 15 'drop flag
    DIKey(20, 0) = 0 'start chat
    DIKey(21, 0) = 28 'send chat
    DIKey(22, 0) = 41 'show ping
    DIKey(23, 0) = 59 'toggle score
    DIKey(24, 0) = 60 'help dialog
    DIKey(25, 0) = 61 'config dialog
    DIKey(26, 0) = 62 'team dialog
    DIKey(27, 0) = 1 'exit arc
    DIKey(28, 0) = 63 'show radar
    DIKey(29, 0) = 64 'show cd player
    DIKey(30, 0) = 65 'show players
    DIKey(31, 0) = 66 'show options
End Sub

Public Sub SndLaserHitS(sndx As Integer, sndy As Integer)
    If Not EnableSound Then Exit Sub
    Dim I As Integer
    For I = 0 To UBound(dsLasrHitS) + 1
        If I > UBound(dsLasrHitS) Then ReDim Preserve dsLasrHitS(I)
        If dsLasrHitS(I) Is Nothing Then Set dsLasrHitS(I) = gObjDSound.DuplicateSoundBuffer(dsLasrHitS(0))
        If dsLasrHitS(I).GetStatus <> DSBSTATUS_PLAYING Then
            dsLasrHitS(I).SetPan sndx * 5
            dsLasrHitS(I).SetVolume -(Abs(sndx) + Abs(sndy)) * 2
            PlaySound dsLasrHitS(I)
            Exit For
        End If
    Next
End Sub

Public Sub SndLaserHitW(sndx As Integer, sndy As Integer)
    If Not EnableSound Then Exit Sub
    Dim I As Integer
    For I = 0 To UBound(dsLasrHitW) + 1
        If I > UBound(dsLasrHitW) Then ReDim Preserve dsLasrHitW(I)
        If dsLasrHitW(I) Is Nothing Then Set dsLasrHitW(I) = gObjDSound.DuplicateSoundBuffer(dsLasrHitW(0))
        If dsLasrHitW(I).GetStatus <> DSBSTATUS_PLAYING Then
            dsLasrHitW(I).SetPan sndx * 5
            dsLasrHitW(I).SetVolume -(Abs(sndx) + Abs(sndy)) * 2
            PlaySound dsLasrHitW(I)
            Exit For
        End If
    Next
End Sub

Public Sub SndPop(sndx As Integer, sndy As Integer)
    If Not EnableSound Then Exit Sub
    Dim I As Integer
    For I = 0 To UBound(dsPop) + 1
        If I > UBound(dsPop) Then ReDim Preserve dsPop(I)
        If dsPop(I) Is Nothing Then Set dsPop(I) = gObjDSound.DuplicateSoundBuffer(dsPop(0))
        If dsPop(I).GetStatus <> DSBSTATUS_PLAYING Then
            dsPop(I).SetPan sndx * 5
            dsPop(I).SetVolume -(Abs(sndx) + Abs(sndy)) * 2
            PlaySound dsPop(I)
            Exit For
        End If
    Next
End Sub

Public Sub SndMine(sndx As Integer, sndy As Integer)
    If Not EnableSound Then Exit Sub
    Dim I As Integer
    For I = 0 To UBound(dsMine) + 1
        If I > UBound(dsMine) Then ReDim Preserve dsMine(I)
        If dsMine(I) Is Nothing Then Set dsMine(I) = gObjDSound.DuplicateSoundBuffer(dsMine(0))
        If dsMine(I).GetStatus <> DSBSTATUS_PLAYING Then
            dsMine(I).SetPan sndx * 5
            dsMine(I).SetVolume -(Abs(sndx) + Abs(sndy)) * 2
            PlaySound dsMine(I)
            Exit For
        End If
    Next
End Sub

Public Sub SndWarp(sndx As Integer, sndy As Integer)
    If Not EnableSound Then Exit Sub
    Dim I As Integer
    For I = 0 To UBound(dsWarp) + 1
        If I > UBound(dsWarp) Then ReDim Preserve dsWarp(I)
        If dsWarp(I) Is Nothing Then Set dsWarp(I) = gObjDSound.DuplicateSoundBuffer(dsWarp(0))
        If dsWarp(I).GetStatus <> DSBSTATUS_PLAYING Then
            dsWarp(I).SetPan sndx * 5
            dsWarp(I).SetVolume -(Abs(sndx) + Abs(sndy)) * 2
            PlaySound dsWarp(I)
            Exit For
        End If
    Next
End Sub

Public Sub SndLaser(sndx As Integer, sndy As Integer)
    If Not EnableSound Then Exit Sub
    Dim I As Integer
    For I = 0 To UBound(dsLaser) + 1
        If I > UBound(dsLaser) Then ReDim Preserve dsLaser(I)
        If dsLaser(I) Is Nothing Then Set dsLaser(I) = gObjDSound.DuplicateSoundBuffer(dsLaser(0))
        If dsLaser(I).GetStatus <> DSBSTATUS_PLAYING Then
            dsLaser(I).SetPan sndx * 5
            dsLaser(I).SetVolume -(Abs(sndx) + Abs(sndy)) * 2
            PlaySound dsLaser(I)
            Exit For
        End If
    Next
End Sub

Public Sub SndDropFlag()
    If Not EnableSound Then Exit Sub
    Dim I As Integer
    For I = 0 To UBound(dsDropflag) + 1
        If I > UBound(dsDropflag) Then ReDim Preserve dsDropflag(I)
        If dsDropflag(I) Is Nothing Then Set dsDropflag(I) = gObjDSound.DuplicateSoundBuffer(dsDropflag(0))
        If dsDropflag(I).GetStatus <> DSBSTATUS_PLAYING Then
            PlaySound dsDropflag(I)
            Exit For
        End If
    Next
End Sub

Public Sub SndMortarsL(sndx As Integer, sndy As Integer)
    If Not EnableSound Then Exit Sub
    Dim I As Integer
    For I = 0 To UBound(dsMortarsL) + 1
        If I > UBound(dsMortarsL) Then ReDim Preserve dsMortarsL(I)
        If dsMortarsL(I) Is Nothing Then Set dsMortarsL(I) = gObjDSound.DuplicateSoundBuffer(dsMortarsL(0))
        If dsMortarsL(I).GetStatus <> DSBSTATUS_PLAYING Then
            dsMortarsL(I).SetPan sndx * 5
            dsMortarsL(I).SetVolume -(Abs(sndx) + Abs(sndy)) * 2
            PlaySound dsMortarsL(I)
            Exit For
        End If
    Next
End Sub

Public Sub SndMortars(sndx As Integer, sndy As Integer)
    If Not EnableSound Then Exit Sub
    Dim I As Integer
    For I = 0 To UBound(dsMortars) + 1
        If I > UBound(dsMortars) Then ReDim Preserve dsMortars(I)
        If dsMortars(I) Is Nothing Then Set dsMortars(I) = gObjDSound.DuplicateSoundBuffer(dsMortars(0))
        If dsMortars(I).GetStatus <> DSBSTATUS_PLAYING Then
            dsMortars(I).SetPan sndx * 5
            dsMortars(I).SetVolume -(Abs(sndx) + Abs(sndy)) * 2
            PlaySound dsMortars(I)
            Exit For
        End If
    Next
End Sub

Public Sub SndMissile(sndx As Integer, sndy As Integer)
    If Not EnableSound Then Exit Sub
    Dim I As Integer
    For I = 0 To UBound(dsMissile) + 1
        If I > UBound(dsMissile) Then ReDim Preserve dsMissile(I)
        If dsMissile(I) Is Nothing Then Set dsMissile(I) = gObjDSound.DuplicateSoundBuffer(dsMissile(0))
        If dsMissile(I).GetStatus <> DSBSTATUS_PLAYING Then
            dsMissile(I).SetPan sndx * 5
            dsMissile(I).SetVolume -(Abs(sndx) + Abs(sndy)) * 2
            PlaySound dsMissile(I)
            Exit For
        End If
    Next
End Sub

Public Sub SndRockHits(sndx As Integer, sndy As Integer)
    If Not EnableSound Then Exit Sub
    Dim I As Integer
    For I = 0 To UBound(dsRockHits) + 1
        If I > UBound(dsRockHits) Then ReDim Preserve dsRockHits(I)
        If dsRockHits(I) Is Nothing Then Set dsRockHits(I) = gObjDSound.DuplicateSoundBuffer(dsRockHits(0))
        If dsRockHits(I).GetStatus <> DSBSTATUS_PLAYING Then
            dsRockHits(I).SetPan sndx * 5
            dsRockHits(I).SetVolume -(Abs(sndx) + Abs(sndy)) * 2
            PlaySound dsRockHits(I)
            Exit For
        End If
    Next
End Sub

Public Sub SndRockHitW(sndx As Integer, sndy As Integer)
    If Not EnableSound Then Exit Sub
    Dim I As Integer
    For I = 0 To UBound(dsRockHitW) + 1
        If I > UBound(dsRockHitW) Then ReDim Preserve dsRockHitW(I)
        If dsRockHitW(I) Is Nothing Then Set dsRockHitW(I) = gObjDSound.DuplicateSoundBuffer(dsRockHitW(0))
        If dsRockHitW(I).GetStatus <> DSBSTATUS_PLAYING Then
            dsRockHitW(I).SetPan sndx * 6
            dsRockHitW(I).SetVolume -(Abs(sndx) + Abs(sndy)) * 2
            PlaySound dsRockHitW(I)
            Exit For
        End If
    Next
End Sub

Public Sub SndBounShot(sndx As Integer, sndy As Integer)
    If Not EnableSound Then Exit Sub
    Dim I As Integer
    For I = 0 To UBound(dsBounShot) + 1
        If I > UBound(dsBounShot) Then ReDim Preserve dsBounShot(I)
        If dsBounShot(I) Is Nothing Then Set dsBounShot(I) = gObjDSound.DuplicateSoundBuffer(dsBounShot(0))
        If dsBounShot(I).GetStatus <> DSBSTATUS_PLAYING Then
            dsBounShot(I).SetPan sndx * 5
            dsBounShot(I).SetVolume -(Abs(sndx) + Abs(sndy)) * 2
            PlaySound dsBounShot(I)
            Exit For
        End If
    Next
End Sub

Public Sub SndBounHits(sndx As Integer, sndy As Integer)
    If Not EnableSound Then Exit Sub
    Dim I As Integer
    For I = 0 To UBound(dsBounHits) + 1
        If I > UBound(dsBounHits) Then ReDim Preserve dsBounHits(I)
        If dsBounHits(I) Is Nothing Then Set dsBounHits(I) = gObjDSound.DuplicateSoundBuffer(dsBounHits(0))
        If dsBounHits(I).GetStatus <> DSBSTATUS_PLAYING Then
            dsBounHits(I).SetPan sndx * 5
            dsBounHits(I).SetVolume -(Abs(sndx) + Abs(sndy)) * 2
            PlaySound dsBounHits(I)
            Exit For
        End If
    Next
End Sub

Public Sub SndBounce(sndx As Integer, sndy As Integer)
    If Not EnableSound Then Exit Sub
    Dim I As Integer
    For I = 0 To UBound(dsBounce) + 1
        If I > UBound(dsBounce) Then ReDim Preserve dsBounce(I)
        If dsBounce(I) Is Nothing Then Set dsBounce(I) = gObjDSound.DuplicateSoundBuffer(dsBounce(0))
        If dsBounce(I).GetStatus <> DSBSTATUS_PLAYING Then
            dsBounce(I).SetPan sndx * 5
            dsBounce(I).SetVolume -(Abs(sndx) + Abs(sndy)) * 2
            PlaySound dsBounce(I)
            Exit For
        End If
    Next
End Sub

Public Sub SndGotPup()
    If Not EnableSound Then Exit Sub
    Dim I As Integer
    For I = 0 To UBound(dsGotPup) + 1
        If I > UBound(dsGotPup) Then ReDim Preserve dsGotPup(I)
        If dsGotPup(I) Is Nothing Then Set dsGotPup(I) = gObjDSound.DuplicateSoundBuffer(dsGotPup(0))
        If dsGotPup(I).GetStatus <> DSBSTATUS_PLAYING Then
            PlaySound dsGotPup(I)
            Exit For
        End If
    Next
End Sub

Public Function IntDX(Initial As Boolean, Optional Reload As Boolean = False)
1134:      Dim I As Integer, j As Integer, a As Integer, b As Byte, C As Byte, sErrDesc As String
1135:      Dim xt As Integer, yt As Integer, X As Integer, rrect As RECT, iErl As Integer, lErrNum As Long
1136:      If Not Initial Then DoEvents
retry:                                   'used for memory errors
1137:      If Initial Then On Error GoTo teherrors
1138:      ddsdProperties.lFlags = DDSD_CAPS Or DDSD_WIDTH Or DDSD_HEIGHT
1139:      ddsdProperties.ddsCaps.lCaps = DDSCAPS_OFFSCREENPLAIN Or DDSCAPS_SYSTEMMEMORY
1140:      If Not LowVRAM Then ddsdProperties.ddsCaps.lCaps = DDSCAPS_OFFSCREENPLAIN Or DDSCAPS_VIDEOMEMORY
1142:      ddsdProperties.lWidth = 584
1143:      ddsdProperties.lHeight = 21
           If StartLog And Initial Then
               StartupLog "Creating DDText..."
           End If
1144:      If DDText Is Nothing Then Set DDText = DirectDraw.CreateSurface(ddsdProperties) '949
1145:      rrect.Top = 1201
1146:      rrect.Bottom = 21 + rrect.Top
1147:      rrect.Left = 0
1148:      rrect.Right = 584
1149:      DDText.BltFast 0, 0, DirectDraw_Tuna, rrect, DDBLTFAST_WAIT
1150:      Key.high = 0
1151:      Key.low = 0
1152:      DDText.SetColorKey DDCKEY_SRCBLT, Key
           If StartLog And Initial Then
               StartupLog "Setting up text..."
           End If
1153:      If Paletted Then
1154:          SetupText2
1155:      Else
1156:          SetupText
1157:      End If
1158:
1159:      'farplane
1160:      ddsdProperties.lWidth = 1280
1161:      ddsdProperties.lHeight = 960
1162:      If ResX > 1280 Or ResY > 960 Then NoFarplane = True
           If StartLog And Initial Then
               StartupLog "Creating DirectDraw_Farplane..."
           End If
1163:      If Not NoFarplane And (DirectDraw_Farplane Is Nothing Or Reload) Then
1164:          Set DirectDraw_Farplane = Nothing
1165:          If FileExists(AppPath & "graphics.patch\Farplane.bmp") Then
1166:              Set DirectDraw_Farplane = DirectDraw.CreateSurfaceFromFile(AppPath & "graphics.patch\Farplane.bmp", ddsdProperties) '967
1167:          Else
1168:              Set DirectDraw_Farplane = DirectDraw.CreateSurfaceFromFile(AppPath & "graphics\Farplane.bmp", ddsdProperties) '967
1169:          End If
1170:      End If
1171:      'map
1172:      Key.high = KEYColor
1173:      Key.low = KEYColor
1174:      ddsdProperties.lWidth = 255 * 16
1175:      ddsdProperties.lHeight = 255 * 16
           If LowMem Then ddsdProperties.ddsCaps.lCaps = DDSCAPS_SYSTEMMEMORY Or DDSCAPS_OFFSCREENPLAIN
           If StartLog And Initial Then
               StartupLog "Creating DirectDraw_Map..."
           End If
1176:      If DirectDraw_Map Is Nothing Or Reload Then
1177:          Set DirectDraw_Map = Nothing
1178:          Set DirectDraw_Map = DirectDraw.CreateSurface(ddsdProperties) '974
1179:      End If
           If LowMem Then
                ddsdProperties.ddsCaps.lCaps = DDSCAPS_OFFSCREENPLAIN Or DDSCAPS_SYSTEMMEMORY
                If Not LowVRAM Then ddsdProperties.ddsCaps.lCaps = DDSCAPS_OFFSCREENPLAIN Or DDSCAPS_VIDEOMEMORY
           End If
1180:      DirectDraw_Map.SetColorKey DDCKEY_SRCBLT, Key
1181:      ddsdProperties.lWidth = 640
1182:      ddsdProperties.lHeight = 480
           If StartLog And Initial Then
               StartupLog "Creating DirectDraw_Tuna1..."
           End If
1183:      If DirectDraw_Tuna1 Is Nothing Then Set DirectDraw_Tuna1 = DirectDraw.CreateSurface(ddsdProperties) '978
1184:      DirectDraw_Tuna1.SetColorKey DDCKEY_SRCBLT, Key
1185:      'chat
1186:      ddsdProperties.lWidth = ResX
1187:      ddsdProperties.lHeight = UBound(Chat) * 12 + 24
           If StartLog And Initial Then
               StartupLog "Creating DirectDraw_Chat..."
           End If
1188:      If DirectDraw_Chat Is Nothing Then Set DirectDraw_Chat = DirectDraw.CreateSurface(ddsdProperties) '983
1189:      DirectDraw_Chat.SetColorKey DDCKEY_SRCBLT, Key
1190:      'ships
1191:      ddsdProperties.lWidth = 290
1192:      ddsdProperties.lHeight = 165
           If StartLog And Initial Then
               StartupLog "Creating DirectDraw_Ships..."
           End If
1193:      If DirectDraw_Ships Is Nothing Then Set DirectDraw_Ships = DirectDraw.CreateSurface(ddsdProperties) '988
           rrect.Left = 0: rrect.Right = rrect.Left + 289: rrect.Top = 292: rrect.Bottom = rrect.Top + 165
1195:      Call DirectDraw_Ships.BltFast(0, 0, DirectDraw_Tuna, rrect, DDBLTFAST_WAIT)
1196:      DirectDraw_Ships.SetColorKey DDCKEY_SRCBLT, Key
1197:
1198:      'adbar
1199:      If Advertisements Then
1200:          ddsdProperties.lWidth = 486
1201:          ddsdProperties.lHeight = 83
               If StartLog And Initial Then
                   StartupLog "Creating DirectDraw_AdBar..."
               End If
1202:          If DirectDraw_AdBar Is Nothing Then Set DirectDraw_AdBar = DirectDraw.CreateSurface(ddsdProperties) '997
               rrect.Left = 0: rrect.Right = 486: rrect.Top = 1237: rrect.Bottom = 1319
1204:          DirectDraw_AdBar.BltColorFill rrect, 0&
1205:          DirectDraw_AdBar.BltFast 0, 0, DirectDraw_Tuna, rrect, DDBLTFAST_WAIT
1206:          DirectDraw_AdBar.SetColorKey DDCKEY_SRCBLT, Key
1207:      End If
1208:      'navbar
1209:      ddsdProperties.lWidth = 640
1210:      ddsdProperties.lHeight = 480
           If StartLog And Initial Then
               StartupLog "Creating DirectDraw_NavBar..."
           End If
1211:      If DirectDraw_NavBar Is Nothing Then Set DirectDraw_NavBar = DirectDraw.CreateSurface(ddsdProperties) '1006
           rrect.Left = 0: rrect.Right = 640: rrect.Top = 0: rrect.Bottom = 480
1213:      DirectDraw_NavBar.BltColorFill rrect, 0&
1214:      DirectDraw_NavBar.SetColorKey DDCKEY_SRCBLT, Key
           rrect.Left = 493: rrect.Right = rrect.Left + 147: rrect.Top = 260: rrect.Bottom = rrect.Top + 480
1216:      DirectDraw_NavBar.BltFast 0, 0, DirectDraw_Tuna, rrect, DDBLTFAST_WAIT
1217:      'selected
           rrect.Left = 536: rrect.Right = 640: rrect.Top = 741: rrect.Bottom = 925
1219:      DirectDraw_NavBar.BltFast 147, 0, DirectDraw_Tuna, rrect, DDBLTFAST_WAIT
1220:      'scores
           rrect.Left = 120: rrect.Right = 400: rrect.Top = 1189: rrect.Bottom = 1201
1222:      DirectDraw_NavBar.BltFast 251, 0, DirectDraw_Tuna, rrect, DDBLTFAST_WAIT
1223:      'options
           rrect.Left = 63: rrect.Right = 134: rrect.Top = 136: rrect.Bottom = 146
1225:      DirectDraw_NavBar.BltFast 531, 0, DirectDraw_Tuna, rrect, DDBLTFAST_WAIT
1226:      'nav door
1227:      rrect.Left = 360
1228:      rrect.Top = 260
           rrect.Bottom = rrect.Top + 94: rrect.Right = rrect.Left + 100
1230:      DirectDraw_NavBar.BltFast 147, 184, DirectDraw_Tuna, rrect, DDBLTFAST_WAIT
1231:
           rrect.Top = rrect.Bottom + 2: rrect.Bottom = rrect.Top + 94
1233:      DirectDraw_NavBar.BltFast 147 + 100, 184, DirectDraw_Tuna, rrect, DDBLTFAST_WAIT
1234:
           rrect.Top = rrect.Bottom + 2: rrect.Bottom = rrect.Top + 94
1236:      DirectDraw_NavBar.BltFast 147 + 210, 184, DirectDraw_Tuna, rrect, DDBLTFAST_WAIT
1237:
           rrect.Top = rrect.Bottom + 2: rrect.Bottom = rrect.Top + 94
1239:      DirectDraw_NavBar.BltFast 147 + 320, 184, DirectDraw_Tuna, rrect, DDBLTFAST_WAIT
1240:
1241:      'select box
           rrect.Left = 0: rrect.Right = 48: rrect.Top = 170: rrect.Bottom = 218
1243:      DirectDraw_NavBar.BltFast 251, 12, DirectDraw_Tuna, rrect, DDBLTFAST_WAIT
1244:      'ship buttons
           rrect.Left = 64: rrect.Right = 304: rrect.Top = 89: rrect.Bottom = 134
1246:      DirectDraw_NavBar.BltFast 300, 12, DirectDraw_Tuna, rrect, DDBLTFAST_WAIT
1247:      'menu
           rrect.Left = 429: rrect.Right = 530: rrect.Top = 1006: rrect.Bottom = 1100
1249:      DirectDraw_NavBar.BltFast 251, 60, DirectDraw_Tuna, rrect, DDBLTFAST_WAIT
1250:      'time window
           rrect.Left = 573: rrect.Right = 640: rrect.Top = 1149: rrect.Bottom = 1176
1252:      DirectDraw_NavBar.BltFast 452, 120, DirectDraw_Tuna, rrect, DDBLTFAST_WAIT
1253:      'command buttons
           rrect.Left = 0: rrect.Right = 58: rrect.Top = 29: rrect.Bottom = 168
1255:      DirectDraw_NavBar.BltFast 540, 14, DirectDraw_Tuna, rrect, DDBLTFAST_WAIT
1256:      'mouse pointers
           rrect.Left = 64: rrect.Right = 320: rrect.Top = 163: rrect.Bottom = 292
1258:      DirectDraw_NavBar.BltFast 147, 278, DirectDraw_Tuna, rrect, DDBLTFAST_WAIT
           rrect.Left = 0: rrect.Right = 63: rrect.Top = 262: rrect.Bottom = 288
1260:      DirectDraw_NavBar.BltFast 147, 407, DirectDraw_Tuna, rrect, DDBLTFAST_WAIT
1261:      'radar scope
           rrect.Left = 609: rrect.Right = 634: rrect.Top = 967: rrect.Bottom = 989
1263:      DirectDraw_NavBar.BltFast 251, 154, DirectDraw_Tuna, rrect, DDBLTFAST_WAIT
1264:      'radar objects '''''''''''EXTRAS
1265:      ddsdProperties.lWidth = 290
1266:      ddsdProperties.lHeight = 300
           If StartLog And Initial Then
               StartupLog "Creating DirectDraw_Extra..."
           End If
1267:      If FileExists(AppPath & "graphics.patch\extras.bmp") Then
1268:          Set DirectDraw_Extra = DirectDraw.CreateSurfaceFromFile(AppPath & "graphics.patch\extras.bmp", ddsdProperties) '1062
1269:      Else
1270:          Set DirectDraw_Extra = DirectDraw.CreateSurfaceFromFile(AppPath & "graphics\extras.bmp", ddsdProperties) '1062
1271:      End If
           rrect.Left = 0: rrect.Right = rrect.Left + 80: rrect.Top = 0: rrect.Bottom = rrect.Top + 60
1273:      Call DirectDraw_NavBar.BltFast(452, 57, DirectDraw_Extra, rrect, DDBLTFAST_WAIT)
1274:      'special2 objects
           'rrect.Left = 0: rrect.Right = 72: rrect.Top = 46: rrect.Bottom = 247
1276:      'DirectDraw_NavBar.BltFast 567, 170, DirectDraw_Extra, rrect, DDBLTFAST_WAIT
           rrect.Left = 0: rrect.Right = 290: rrect.Top = 268: rrect.Bottom = rrect.Top + 32
1278:      Call DirectDraw_Ships.BltFast(0, 128, DirectDraw_Extra, rrect, DDBLTFAST_WAIT)
1279:      'deathmatch ship
1280:      Set DirectDraw_Extra = Nothing
1281:      'player list
           rrect.Left = 360: rrect.Right = 460: rrect.Top = 644: rrect.Bottom = 772
1283:      DirectDraw_NavBar.BltFast 352, 56, DirectDraw_Tuna, rrect, DDBLTFAST_WAIT
1284:      'player list admin
           rrect.Left = 259: rrect.Right = 359: rrect.Top = 726: rrect.Bottom = 749
1286:      DirectDraw_NavBar.BltFast 452, 156, DirectDraw_Tuna, rrect, DDBLTFAST_WAIT
1287:
1288:      '
1289:      'Tuna!
1290:      'explosions
           rrect.Left = 0: rrect.Right = 383: rrect.Top = 790: rrect.Bottom = 1145
1292:      DirectDraw_Tuna1.BltFast 0, 0, DirectDraw_Tuna, rrect, DDBLTFAST_WAIT
1293:      'bombs, smoke, shield, shrapnel
           rrect.Left = 0: rrect.Right = 187: rrect.Top = 582: rrect.Bottom = 761
1295:      DirectDraw_Tuna1.BltFast 383, 0, DirectDraw_Tuna, rrect, DDBLTFAST_WAIT
           rrect.Left = 210: rrect.Right = 298: rrect.Top = 670: rrect.Bottom = 681
1297:      DirectDraw_Tuna1.BltFast 485, 165, DirectDraw_Tuna, rrect, DDBLTFAST_WAIT
1298:      'flags
           rrect.Left = 288: rrect.Right = 300: rrect.Top = 311: rrect.Bottom = 451
1300:      DirectDraw_Tuna1.BltFast 570, 0, DirectDraw_Tuna, rrect, DDBLTFAST_WAIT
1301:      'powerups
           rrect.Left = 0: rrect.Right = 288: rrect.Top = 423: rrect.Bottom = 546
1303:      DirectDraw_Tuna1.BltFast 0, 355, DirectDraw_Tuna, rrect, DDBLTFAST_WAIT
1304:      Set DirectDraw_Tuna = Nothing
1305:      '
           rrect.Left = 0: rrect.Right = 0: rrect.Top = 0: rrect.Bottom = 0
1307:
           DirectDraw_NavBar.SetFillColor vbRed: DirectDraw_NavBar.SetForeColor vbRed
1309:      DirectDraw_NavBar.DrawBox 404, 387, 404 + 60, 387 + 15
           DirectDraw_NavBar.SetFillColor vbBlue: DirectDraw_NavBar.SetForeColor vbBlue
1311:      DirectDraw_NavBar.DrawBox 510, 387, 510 + 60, 387 + 15
1312:
1313:      DirectDraw_NavBar.SetFillColor RGB(255, 120, 0)
1314:      DirectDraw_NavBar.SetForeColor RGB(255, 120, 0)
1315:      DirectDraw_NavBar.DrawBox 465, 374, 465 + 4, 374 + 3
1316:      rWepAmmo(0).Left = 465
1317:      rWepAmmo(0).Right = rWepAmmo(0).Left + 4
1318:      rWepAmmo(0).Top = 374
1319:      rWepAmmo(0).Bottom = rWepAmmo(0).Top + 3
1320:      DirectDraw_NavBar.SetFillColor vbGreen
1321:      DirectDraw_NavBar.SetForeColor vbGreen
1322:      DirectDraw_NavBar.DrawBox 465, 380, 465 + 23, 380 + 4
1323:      rWepAmmo(1).Left = 465
1324:      rWepAmmo(1).Right = rWepAmmo(1).Left + 23
1325:      rWepAmmo(1).Top = 380
1326:      rWepAmmo(1).Bottom = rWepAmmo(1).Top + 4
1327:      'extract anims from tiles
1328:      ddsdProperties.lWidth = 640
1329:      ddsdProperties.lHeight = 480
           If StartLog And Initial Then
               StartupLog "Creating DirectDraw_Anims(0) and DirectDraw_Anims(1)..."
           End If
1330:      If DirectDraw_Anims(0) Is Nothing Then Set DirectDraw_Anims(0) = DirectDraw.CreateSurface(ddsdProperties) '1121
1331:      ddsdProperties.lHeight = 480
1332:      If DirectDraw_Anims(1) Is Nothing Then Set DirectDraw_Anims(1) = DirectDraw.CreateSurface(ddsdProperties) '1123
1333:      b = 0
1334:      j = 0
1335:      For I = 0 To 255
1336:          If FrameCount(I) > 0 Then
1337:              For C = 0 To FrameCount(I) - 1
1338:                  xt = (AnimFrames(I, C) Mod 40) * 16
1339:                  yt = (AnimFrames(I, C) - (AnimFrames(I, C) Mod 40)) / 40 * 16 'Do NOT change this to integer division!
                       rrect.Left = xt: rrect.Right = rrect.Left + 16: rrect.Top = yt: rrect.Bottom = rrect.Top + 16
1341:                  AnimFX(I, C) = X
1342:                  AnimFY(I, C) = a
1343:                  AnimFS(I, C) = b
1344:                  Call DirectDraw_Anims(b).BltFast(X, a, DirectDraw_Tile, rrect, DDBLTFAST_WAIT)
1345:                  j = j + 16
1346:                  X = (j Mod 640) And -16
1347:                  a = (j - (j Mod 640)) / 640 * 16 'Do NOT change this to integer division!
1348:                  If a > 464 Then
1349:                      b = 1
1350:                      a = a - 480
1351:                  End If
1352:              Next
1353:          End If
1354:      Next
1355:      DirectDraw_Anims(0).SetColorKey DDCKEY_SRCBLT, Key
1356:      DirectDraw_Anims(1).SetColorKey DDCKEY_SRCBLT, Key
1357:      IntDX = True
1358:      Exit Function
teherrors:
    iErl = Erl
    lErrNum = Err.Number
    sErrDesc = Err.Description
    Err.Clear
    StartupLog "WARNING: An error has occured on line " & iErl & ". (" & lErrNum & ")"
    'If lErrNum = 0 Then
    '    Err.Clear
    '    Resume Next
    'End If
    If iErl = 1144 Or iErl = 1166 Or iErl = 1168 Or iErl = 1178 Or iErl = 1183 Or iErl = 1188 Or _
          iErl = 1193 Or iErl = 1202 Or iErl = 1211 Or iErl = 1268 Or iErl = 1270 Or iErl = 1330 Or _
          iErl = 1332 Then
        If Not LowMem Then
            LowMem = True
            If StartLog Then
                StartupLog "WARNING: Internal : " & lErrNum & " " & sErrDesc
                StartupLog "WARNING: DirectX  : " & errors(lErrNum) & " " & iErl
                StartupLog "WARNING: Assuming low memory for this session."
            End If
            GoTo retry
        ElseIf Not LowVRAM Then
            LowVRAM = True
            If StartLog Then
                StartupLog "WARNING: " & errors(lErrNum) & " " & iErl
                StartupLog "WARNING: Assuming low video memory for this session."
            End If
            GoTo retry
        Else
            RaiseCritical "Your machine doesn't appear to have enough memory to run the game. Critical fault at line #" & iErl & ". (" & sErrDesc & ")"
        End If
    End If
    RaiseCritical "DirectX init failed. (Line #" & iErl & ". " & DQ & lErrNum & " " & sErrDesc & DQ & ")"
    frmMain.Timer2.Enabled = True
End Function

Public Sub SetupText()
    Dim TheCOLOR As Long, j As Integer, CStep As Integer
    Dim TheKEY As Long
    Dim I As Integer, Hdr As Integer, Key As DDCOLORKEY
    Dim CKey1 As Long, rrect As RECT
    Dim TempDXD As DDSURFACEDESC2
    Key.low = 0
    Key.high = 0
    
    If DirectDraw_Text Is Nothing Then
        DDText.Lock rrect, TempDXD, DDLOCK_WAIT, 0
        CKey1 = DDText.GetLockedPixel(0, 0)
        For I = 1 To 584
            TheKEY = DDText.GetLockedPixel(I, 7)
            If TheKEY = CKey1 Then
                rChars(CStep).Left = Hdr + 1
                If CStep = 93 Then
                    rChars(CStep).Right = I
                ElseIf CStep = 94 Then
                    rChars(CStep).Left = rChars(CStep).Left - 1
                    rChars(CStep).Right = I
                Else
                    rChars(CStep).Right = I + 1
                End If
                rChars(CStep).Top = 8
                rChars(CStep).Bottom = 18
                CStep = CStep + 1
                Hdr = I
                If CStep > 95 Then Exit For
            End If
        Next
        CStep = 0
        Hdr = 0
        For I = 1 To 365
            TheKEY = DDText.GetLockedPixel(I, 0)
            If TheKEY = CKey1 Then
                rChars2(CStep).Left = Hdr + 1
                rChars2(CStep).Right = I + 1
                rChars2(CStep).Top = 1
                rChars2(CStep).Bottom = 6
                CStep = CStep + 1
                If CStep > 95 Then Exit For
                Hdr = I
            End If
        Next
        DDText.Unlock rrect
    End If
    '
    rChars(0).Top = 8
    rChars(0).Bottom = 18
    rChars(0).Left = 0
    rChars(0).Right = 584
    
    rChars2(0).Top = 0
    rChars2(0).Bottom = 6
    rChars2(0).Left = 0
    rChars2(0).Right = 365
    
    Key.high = KEYColor
    Key.low = KEYColor
    ddsdProperties.lWidth = 584
    ddsdProperties.lHeight = 480
    For j = 1 To 11
        If j = 1 Then TheCOLOR = RGB(82, 227, 82)
        If j = 2 Then TheCOLOR = RGB(231, 81, 82)
        If j = 3 Then TheCOLOR = RGB(82, 81, 231)
        If j = 4 Then TheCOLOR = RGB(214, 219, 41)
        If j = 5 Then TheCOLOR = RGB(231, 227, 231)
        If j = 6 Then TheCOLOR = RGB(255, 251, 255)
        If j = 7 Then TheCOLOR = RGB(140, 138, 140)
        If j = 8 Then TheCOLOR = RGB(148, 146, 255)
        If j = 9 Then TheCOLOR = RGB(222, 170, 0)
        If j = 10 Then TheCOLOR = RGB(198, 105, 0)
        If j = 11 Then TheCOLOR = RGB(189, 186, 189)
        If DirectDraw_Text Is Nothing Then Set DirectDraw_Text = DirectDraw.CreateSurface(ddsdProperties)
        DirectDraw_Text.SetFillColor TheCOLOR
        DirectDraw_Text.SetForeColor TheCOLOR
        DirectDraw_Text.DrawBox 0, 10 * j, 584, 10 * (j + 1)
        DirectDraw_Text.BltFast 0, 10 * j, DDText, rChars(0), DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
    Next
    DirectDraw_Text.SetColorKey DDCKEY_SRCBLT, Key
    ddsdProperties.lWidth = 365
    ddsdProperties.lHeight = 480
    For I = 0 To 10
        If I = 0 Then TheCOLOR = RGB(222, 105, 0)
        If I = 1 Then TheCOLOR = RGB(255, 180, 0)
        If I = 2 Then TheCOLOR = RGB(0, 170, 0)
        If I = 3 Then TheCOLOR = RGB(214, 0, 0)
        If I = 4 Then TheCOLOR = RGB(82, 81, 231)
        If I = 5 Then TheCOLOR = RGB(206, 203, 0)
        If I = 6 Then TheCOLOR = vbWhite
        If I = 7 Then TheCOLOR = RGB(0, 81, 0)
        If I = 8 Then TheCOLOR = RGB(99, 0, 0)
        If I = 9 Then TheCOLOR = RGB(0, 0, 140)
        If I = 10 Then TheCOLOR = RGB(99, 97, 0)
        If DirectDraw_Text2 Is Nothing Then Set DirectDraw_Text2 = DirectDraw.CreateSurface(ddsdProperties)
        DirectDraw_Text2.SetFillColor TheCOLOR
        DirectDraw_Text2.SetForeColor TheCOLOR
        DirectDraw_Text2.DrawBox 0, 6 * I, 365, 6 * (I + 1)
        DirectDraw_Text2.BltFast 0, 6 * I, DDText, rChars2(0), DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
        DirectDraw_Text2.SetColorKey DDCKEY_SRCBLT, Key
    Next
    rChars(0).Left = 1
    rChars(0).Right = 6
    rChars2(0).Left = 1
    rChars2(0).Right = 2
End Sub

Public Sub SetupText2()
    Dim TheCOLOR As Long, j As Integer, CStep As Integer
    Dim I As Integer, Hdr As Integer, Key As DDCOLORKEY
    Key.low = 0
    Key.high = 0
    
    If DirectDraw_Text Is Nothing Then
        Dim ddsBufferArray() As Byte
        Dim ddsdBuffer As DDSURFACEDESC2
        Dim emptyrect As RECT
        DDText.Lock emptyrect, ddsdBuffer, DDLOCK_NOSYSLOCK Or DDLOCK_WAIT, 0
        DDText.GetLockedArray ddsBufferArray
        For I = 1 To 584
            If ddsBufferArray(I, 7) = 45 Then
                rChars(CStep).Left = Hdr + 1
                rChars(CStep).Right = I + 1
                rChars(CStep).Top = 8
                rChars(CStep).Bottom = 18
                CStep = CStep + 1
                Hdr = I
                If CStep > 95 Then Exit For
            End If
        Next
        CStep = 0
        Hdr = 0
        For I = 1 To 365
            If ddsBufferArray(I, 0) = 45 Then
                rChars2(CStep).Left = Hdr
                rChars2(CStep).Right = I
                rChars2(CStep).Top = 1
                rChars2(CStep).Bottom = 6
                CStep = CStep + 1
                If CStep > 95 Then Exit For
                Hdr = I
            End If
        Next
        DDText.Unlock emptyrect
    End If
    '
    rChars(0).Top = 8
    rChars(0).Bottom = 18
    rChars(0).Left = 0
    rChars(0).Right = 584
    
    rChars2(0).Top = 0
    rChars2(0).Bottom = 6
    rChars2(0).Left = 0
    rChars2(0).Right = 365
    
    Key.high = KEYColor
    Key.low = KEYColor
    ddsdProperties.lWidth = 584
    ddsdProperties.lHeight = 480
    For j = 1 To 11
        If j = 1 Then TheCOLOR = RGB(82, 227, 82)
        If j = 2 Then TheCOLOR = RGB(231, 81, 82)
        If j = 3 Then TheCOLOR = RGB(82, 81, 231)
        If j = 4 Then TheCOLOR = RGB(214, 219, 41)
        If j = 5 Then TheCOLOR = RGB(231, 227, 231)
        If j = 6 Then TheCOLOR = RGB(255, 251, 255)
        If j = 7 Then TheCOLOR = RGB(140, 138, 140)
        If j = 8 Then TheCOLOR = RGB(148, 146, 255)
        If j = 9 Then TheCOLOR = RGB(222, 170, 0)
        If j = 10 Then TheCOLOR = RGB(198, 105, 0)
        If j = 11 Then TheCOLOR = RGB(189, 186, 189)
        If DirectDraw_Text Is Nothing Then Set DirectDraw_Text = DirectDraw.CreateSurface(ddsdProperties)
        DirectDraw_Text.SetFillColor TheCOLOR
        DirectDraw_Text.SetForeColor TheCOLOR
        DirectDraw_Text.DrawBox 0, 10 * j, 584, 10 * (j + 1)
        DirectDraw_Text.BltFast 0, 10 * j, DDText, rChars(0), DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
    Next
    DirectDraw_Text.SetColorKey DDCKEY_SRCBLT, Key
    ddsdProperties.lWidth = 365
    ddsdProperties.lHeight = 480
    For I = 0 To 10
        If I = 0 Then TheCOLOR = RGB(222, 105, 0)
        If I = 1 Then TheCOLOR = RGB(255, 180, 0)
        If I = 2 Then TheCOLOR = RGB(0, 170, 0)
        If I = 3 Then TheCOLOR = RGB(214, 0, 0)
        If I = 4 Then TheCOLOR = RGB(82, 81, 231)
        If I = 5 Then TheCOLOR = RGB(206, 203, 0)
        If I = 6 Then TheCOLOR = vbWhite
        If I = 7 Then TheCOLOR = RGB(0, 81, 0)
        If I = 8 Then TheCOLOR = RGB(99, 0, 0)
        If I = 9 Then TheCOLOR = RGB(0, 0, 140)
        If I = 10 Then TheCOLOR = RGB(99, 97, 0)
        If DirectDraw_Text2 Is Nothing Then Set DirectDraw_Text2 = DirectDraw.CreateSurface(ddsdProperties)
        DirectDraw_Text2.SetFillColor TheCOLOR
        DirectDraw_Text2.SetForeColor TheCOLOR
        DirectDraw_Text2.DrawBox 0, 6 * I, 365, 6 * (I + 1)
        DirectDraw_Text2.BltFast 0, 6 * I, DDText, rChars2(0), DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
        DirectDraw_Text2.SetColorKey DDCKEY_SRCBLT, Key
    Next
    rChars(0).Left = 1
    rChars(0).Right = 6
    rChars2(0).Left = 1
    rChars2(0).Right = 2
End Sub

Public Sub DIKeys()
    Dim kbState As DIKEYBOARDSTATE
    Static Exiting As Boolean, ScoreStat As Boolean, CtrlR As Boolean, CruiseWait As Long, AppsDown As Boolean
    Static minedrop As Boolean
    DirectInput_Dev.Acquire
    Call DirectInput_Dev.GetDeviceStateKeyboard(kbState)
    'escape
    Dim I As Long
    
    If kbState.Key(DIKey(27, 0)) Then
        Exiting = True
    Else
        If Exiting Then
            Exiting = False
            If MenuMenu > 0 Then
                MenuMenu = 0
            Else
                MenuMenu = 4
            End If
        End If
    End If
    
    'GameChat "DIKEYS: " & Timer & " " & Players(MeNum).Mode
    If Players(MeNum).Mode = 1 Then GoTo skipchecks
    If Players(MeNum).Invisible Then Players(MeNum).KeyIs = 0
    If Not Players(MeNum).Invisible And Not Players(MeNum).Warping Then '2
skipchecks:
        'GameChat "SkipChecks Success: " & Timer
        If kbState.Key(82) And Players(MeNum).Mode = 0 Then
            If Not minedrop Then
                If WepRge.Mines Then LayMine Players(MeNum).charX + 12, Players(MeNum).charY + 12
                minedrop = True
            End If
        Else
            minedrop = False
        End If
        
        If Not Cruise Then Players(MeNum).KeyIs = 0
        If Not cfgk Then 'And Not ChatQ Then
            If kbState.Key(DIK_F) Then Players(MeNum).KeyIs = 1
            If kbState.Key(DIK_S) Then Players(MeNum).KeyIs = 5
            If kbState.Key(DIK_E) Then Players(MeNum).KeyIs = 3
            If kbState.Key(DIK_D) Then Players(MeNum).KeyIs = 7
            If kbState.Key(DIK_F) And kbState.Key(DIK_E) Then Players(MeNum).KeyIs = 2
            If kbState.Key(DIK_S) And kbState.Key(DIK_E) Then Players(MeNum).KeyIs = 4
            If kbState.Key(DIK_S) And kbState.Key(DIK_D) Then Players(MeNum).KeyIs = 6
            If kbState.Key(DIK_D) And kbState.Key(DIK_F) Then Players(MeNum).KeyIs = 8
        End If
        If cfgk Or (Not cfgk And Not ChatQ) Then
            'arrowkey stright directions
            If kbState.Key(DIKey(0, 1)) Then Cruise = False: Players(MeNum).KeyIs = 5 'left
            If kbState.Key(DIKey(1, 1)) Then Cruise = False: Players(MeNum).KeyIs = 1 'right
            If kbState.Key(DIKey(2, 1)) Then Cruise = False: Players(MeNum).KeyIs = 3 'up
            If kbState.Key(DIKey(3, 1)) Then Cruise = False: Players(MeNum).KeyIs = 7 'down
            'arrowkey diagonal directions
            If kbState.Key(DIKey(0, 1)) And kbState.Key(DIKey(2, 1)) Then Players(MeNum).KeyIs = 4
            If kbState.Key(DIKey(1, 1)) And kbState.Key(DIKey(2, 1)) Then Players(MeNum).KeyIs = 2
            If kbState.Key(DIKey(0, 1)) And kbState.Key(DIKey(3, 1)) Then Players(MeNum).KeyIs = 6
            If kbState.Key(DIKey(1, 1)) And kbState.Key(DIKey(3, 1)) Then Players(MeNum).KeyIs = 8
            If kbState.Key(DIKey(1, 1)) And kbState.Key(DIKey(0, 1)) Then Players(MeNum).KeyIs = 0
            If kbState.Key(DIKey(2, 1)) And kbState.Key(DIKey(3, 1)) Then Players(MeNum).KeyIs = 0
        End If
        'numpad stright directions
        If kbState.Key(DIKey(0, 0)) Then Cruise = False: Players(MeNum).KeyIs = 5
        If kbState.Key(DIKey(1, 0)) Then Cruise = False: Players(MeNum).KeyIs = 1
        If kbState.Key(DIKey(2, 0)) Then Cruise = False: Players(MeNum).KeyIs = 3
        If kbState.Key(DIKey(3, 0)) Then Cruise = False: Players(MeNum).KeyIs = 7
        'numpad diagonal directions
        If kbState.Key(DIKey(4, 0)) Then Cruise = False: Players(MeNum).KeyIs = 4
        If kbState.Key(DIKey(5, 0)) Then Cruise = False: Players(MeNum).KeyIs = 2
        If kbState.Key(DIKey(6, 0)) Then Cruise = False: Players(MeNum).KeyIs = 6
        If kbState.Key(DIKey(7, 0)) Then Cruise = False: Players(MeNum).KeyIs = 8
        'cruise control
        If NewGTC - CruiseWait > 100 Then
            CruiseWait = NewGTC
            If kbState.Key(DIKey(8, 0)) Then Cruise = True: Players(MeNum).KeyIs = 5
            If kbState.Key(DIKey(9, 0)) Then Cruise = True: Players(MeNum).KeyIs = 1
            If kbState.Key(DIKey(10, 0)) Then Cruise = True: Players(MeNum).KeyIs = 3
            If kbState.Key(DIKey(11, 0)) Then Cruise = True: Players(MeNum).KeyIs = 7
            If kbState.Key(DIKey(8, 0)) And kbState.Key(DIKey(10, 0)) Then Players(MeNum).KeyIs = 4
            If kbState.Key(DIKey(9, 0)) And kbState.Key(DIKey(10, 0)) Then Players(MeNum).KeyIs = 2
            If kbState.Key(DIKey(8, 0)) And kbState.Key(DIKey(11, 0)) Then Players(MeNum).KeyIs = 6
            If kbState.Key(DIKey(9, 0)) And kbState.Key(DIKey(11, 0)) Then Players(MeNum).KeyIs = 8
            If kbState.Key(DIKey(12, 0)) Or kbState.Key(DIKey(12, 1)) Then Cruise = False
        End If
        'next special
        If kbState.Key(DIKey(13, 0)) Or kbState.Key(DIKey(13, 1)) Then
            If Not CtrlR Then
                CtrlR = True
                Weapon = Weapon + 1
                If Weapon > 3 Then Weapon = 1
                If Weapon = 1 Then bSpecialSnd = 1
                If Weapon = 2 Then bSpecialSnd = 2
                If Weapon = 3 Then bSpecialSnd = 3
                SpecialSnd bSpecialSnd
            End If
        Else
            CtrlR = False
        End If
        'fps toggle
        If kbState.Key(DIK_APPS) Then 'application menu key
            If Not AppsDown Then
                AppsDown = True
                If DebugShow Then
                    DebugShow = False
                    Else
                    DebugShow = True
                End If
            End If
        Else
            AppsDown = False
        End If
        'weapon keys
        If kbState.Key(DIKey(16, 0)) Then Weapon = 1: SpecialSnd 1
        If kbState.Key(DIKey(17, 0)) Then Weapon = 2: SpecialSnd 2
        If kbState.Key(DIKey(18, 0)) Then Weapon = 3: SpecialSnd 3
        'drop flag
        If kbState.Key(DIKey(19, 0)) Then If Players(MeNum).FlagWho > 0 Then DropFlag
        'dialogs
        If kbState.Key(DIKey(23, 0)) Then 'player scores
            If Not ScoreStat Then
                If ScoreView Then ScoreView = False Else ScoreView = True
                ScoreStat = True
            End If
        Else
            ScoreStat = False
        End If
        If kbState.Key(DIKey(24, 0)) Then MenuMenu = 1 'help F2
        If kbState.Key(DIKey(25, 0)) Then MenuMenu = 3 'config F3
        If kbState.Key(DIKey(26, 0)) Then MenuMenu = 2 'switch team F4
        If kbState.Key(DIKey(28, 0)) Then If Not AnimateMenu Then MenuPend = 1: AnimateMenu = True 'radar
        If kbState.Key(DIKey(29, 0)) Then If Not AnimateMenu Then MenuPend = 2: AnimateMenu = True 'cd players
        If kbState.Key(DIKey(30, 0)) Then If Not AnimateMenu Then MenuPend = 3: AnimateMenu = True: PlayerSelected = 1 'players
        If kbState.Key(DIKey(31, 0)) Then If Not AnimateMenu Then MenuPend = 4: AnimateMenu = True 'options
    End If '2
    If Players(MeNum).KeyIs = 0 Then Players(MeNum).KeyIs = 9
End Sub

Public Sub AdBar()
    If BackBuffer.isLost Then Exit Sub
    Dim rBox As RECT
    rBox.Top = 0: rBox.Bottom = 83: rBox.Left = 0: rBox.Right = 486
    BackBuffer.BltFast (ResX / 2) - 243, ResY - 83, DirectDraw_AdBar, rBox, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
End Sub

Public Function CreateASurface(DirectdrawObject As DirectDraw7, DDSurface As DirectDrawSurface7, Width As Long, Height As Long, SourceFile As String) As Boolean
    On Error GoTo errhandle
    Dim ddsdF As DDSURFACEDESC2
    Dim Surfpic As Picture
    
    ddsdF.lFlags = DDSD_CAPS Or DDSD_HEIGHT Or DDSD_WIDTH
    ddsdF.ddsCaps.lCaps = DDSCAPS_OFFSCREENPLAIN And DDSCAPS_VIDEOMEMORY
    ddsdF.lWidth = Width
    ddsdF.lHeight = Height
    Set Surfpic = LoadPicture(SourceFile)
    SavePicture Surfpic, App.Path & "\tmp.bmp"
    Set DDSurface = DirectdrawObject.CreateSurfaceFromFile(App.Path & "\tmp.bmp", ddsdF)
    Kill App.Path & "\tmp.bmp"
    Set Surfpic = Nothing
    CreateASurface = True
    
    Exit Function
errhandle:
    CreateASurface = False
End Function


Public Sub SlctBox(bxWidth As Integer, bxHeight As Integer)
    If BackBuffer.isLost Then Exit Sub
    Dim rBox As RECT
    Dim X As Integer, y As Integer, xt As Integer, yt As Integer
    Dim xTo As Integer, yTo As Integer
    xTo = (bxWidth - (bxWidth Mod 16)) \ 16
    yTo = (bxHeight - (bxHeight Mod 16)) \ 16
    For X = 0 To xTo
        For y = 0 To yTo
            rBox.Top = 0: rBox.Bottom = 0: rBox.Left = 0: rBox.Right = 0
            xt = X * 16
            yt = y * 16
            If X = 0 Then
                If y = 0 Then rBox.Top = 0
                If y > 0 Then rBox.Top = 16
                If y = yTo Then rBox.Top = 32
                rBox.Bottom = rBox.Top + 16
                rBox.Right = rBox.Left + 16
            End If
            If X > 0 And X <> xTo Then
                rBox.Left = 16
                If y = 0 Then rBox.Top = 0
                If y > 0 Then rBox.Top = 16
                If y = yTo Then rBox.Top = 32
                rBox.Bottom = rBox.Top + 16
                rBox.Right = rBox.Left + 16
            End If
            If X = xTo Then
                rBox.Left = 32
                If y = 0 Then rBox.Top = 0
                If y > 0 Then rBox.Top = 16
                If y = yTo Then rBox.Top = 32
                rBox.Bottom = rBox.Top + 16
                rBox.Right = rBox.Left + 16
            End If
            rBox.Left = 251 + rBox.Left
            rBox.Right = rBox.Right + 251
            rBox.Top = 12 + rBox.Top
            rBox.Bottom = rBox.Bottom + 12
            BackBuffer.BltFast xt + (CenterX - bxWidth \ 2), yt + (CenterY - bxHeight \ 2), DirectDraw_NavBar, rBox, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
        Next
    Next
End Sub

Public Sub OptionGFX(frm As String, xt As Integer, yt As Integer)
    Dim rOpt As RECT, I As Integer
    Select Case frm
    Case "checkfalse"
        I = 0
    Case "checktrue"
        I = 1
    Case "optionfalse"
        I = 2
    Case "optiontrue"
        I = 3
    Case "selectfalse"
        I = 4
    Case "selecttrue"
        I = 5
    End Select
    rOpt.Top = 0
    rOpt.Bottom = rOpt.Top + 10
    rOpt.Left = 531 + I * 12
    rOpt.Right = rOpt.Left + 11
    BackBuffer.BltFast xt, yt, DirectDraw_NavBar, rOpt, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
End Sub

Public Sub ReplyGfx(CmdName As String, xt As Long, yt As Long)
    If BackBuffer.isLost Then Exit Sub
    Dim frme As Integer
    Select Case LCase$(CmdName)
    Case "blank"
        frme = 0
    Case "back"
        frme = 1
    Case "next"
        frme = 2
    Case "ok"
        frme = 3
    Case "cancel"
        frme = 4
    Case "yes"
        frme = 5
    Case "no"
        frme = 6
    End Select
    Dim rReply As RECT
    rReply.Top = frme * 20 + 14
    rReply.Bottom = rReply.Top + 20
    rReply.Left = 540
    rReply.Right = rReply.Left + 58
    Call BackBuffer.BltFast(xt, yt, DirectDraw_NavBar, rReply, DDBLTFAST_WAIT)
End Sub

Public Sub LineDraw(Typ As Byte, Colr As Integer, Idx As Integer, LasrX As Integer, LasrY As Integer, LasrX2 As Integer, LasrY2 As Integer)
    If Paletted Then
        LineDraw2 Typ, Colr, Idx, LasrX, LasrY, LasrX2, LasrY2
        Exit Sub
    End If
    Dim PixCol As Long
    Dim mn As Long, md As Long, balance As Long, x_move As Long, y_move As Long
    Dim e As Long, NewX As Long, NewY As Long
    Dim Phase As Integer
    If BackBuffer.isLost Then Exit Sub
    
    
    If Typ = 4 Then
        If Colr = 1 Then PixCol = DDRGB(247, 243, 148)
        If Colr = 2 Then PixCol = DDRGB(206, 203, 0)
        If Colr = 3 Then PixCol = DDRGB(222, 198, 0)
        If Colr = 4 Then PixCol = DDRGB(214, 138, 0)
        If Colr = 4 Then PixCol = DDRGB(190, 190, 190)
        If LasrX > 1 And LasrY > 1 And LasrX < ResX + 1 And LasrY < ResY + 1 Then BackBuffer.SetLockedPixel LasrX, LasrY, PixCol
        Exit Sub
    End If
    
    md = LasrX2 - LasrX
    If md < 0 Then
        md = -md
        x_move = -1
    Else
        x_move = 1
    End If
    
    mn = LasrY2 - LasrY
    If mn < 0 Then
        mn = -mn
        y_move = -1
    Else
        y_move = 1
    End If
    
    NewX = LasrX
    NewY = LasrY
    
    If mn < md Then
        balance = md
    Else
        balance = -mn
    End If
    mn = 2 * mn
    md = 2 * md
    If Typ = 1 Then If LaserStopMve(Idx) > 0 Then e = LaserDist(Idx) - LaserStopMve(Idx)
    If Typ = 2 Then If BounceStopMve(Idx) > 0 Then e = BounceDist(Idx) - BounceStopMve(Idx)
    While ((NewX <> LasrX2) Or (NewY <> LasrY2))
        e = e + 1
        If e > 17 Then Phase = 2 Else Phase = 1
        If e > 25 Then Phase = 3
        If e > 33 Then Phase = 4
        If Typ = 1 Then
            If LaserStopMve(Idx) > 0 Then
                If e - (LaserDist(Idx) - LaserStopMve(Idx)) < 5 Then Phase = 1
            End If
        End If
        If Typ = 3 Then
            If e > 2 Then Phase = 2 Else Phase = 1
            If e > 7 Then Phase = 3
            If e > 10 Then Phase = 4
        End If
        If Colr = 1 Then
            If Phase = 1 Then PixCol = DDRGB(0, 220, 0)
            If Typ = 1 Then If Phase = 1 And LaserHit(Idx) Then PixCol = DDRGB(255, 255, 255)
            If Phase = 2 Then PixCol = DDRGB(0, 200, 0)
            If Phase = 3 Then PixCol = DDRGB(0, 180, 0)
            If Phase = 4 Then PixCol = DDRGB(0, 140, 0)
        ElseIf Colr = 2 Then
            If Phase = 1 Then PixCol = DDRGB(247, 40, 41)
            If Typ = 1 Then If Phase = 1 And LaserHit(Idx) Then PixCol = DDRGB(255, 255, 255)
            If Phase = 2 Then PixCol = DDRGB(247, 0, 0)
            If Phase = 3 Then PixCol = DDRGB(198, 0, 0)
            If Phase = 4 Then PixCol = DDRGB(148, 0, 0)
        ElseIf Colr = 3 Then
            If Phase = 1 Then PixCol = DDRGB(0, 0, 255)
            If Typ = 1 Then If Phase = 1 And LaserHit(Idx) Then PixCol = DDRGB(255, 255, 255)
            If Phase = 2 Then PixCol = DDRGB(0, 0, 239)
            If Phase = 3 Then PixCol = DDRGB(0, 0, 173)
            If Phase = 4 Then PixCol = DDRGB(0, 0, 140)
        ElseIf Colr = 4 Then
            If Phase = 1 Then PixCol = DDRGB(239, 235, 0)
            If Typ = 1 Then If Phase = 1 And LaserHit(Idx) Then PixCol = DDRGB(255, 255, 255)
            If Phase = 2 Then PixCol = DDRGB(206, 203, 0)
            If Phase = 3 Then PixCol = DDRGB(156, 154, 66)
            If Phase = 4 Then PixCol = DDRGB(140, 138, 0)
        ElseIf Colr = 5 Then
            If Phase = 1 Then PixCol = DDRGB(214, 211, 214)
            If Phase = 2 Then PixCol = DDRGB(120, 120, 120)
            If Phase = 3 Then PixCol = DDRGB(60, 60, 60)
            If Phase = 4 Then PixCol = DDRGB(10, 10, 10)
        ElseIf Colr = 6 Then
            If Phase = 1 Then PixCol = DDRGB(214, 211, 214)
            If Phase = 2 Then PixCol = DDRGB(90, 89, 90)
            If Phase = 3 Then PixCol = DDRGB(49, 52, 49)
            If Phase = 4 Then PixCol = DDRGB(0, 0, 0)
        End If
        If Typ = 1 Then If e > 70 Then Exit Sub
        If Typ = 2 Then If e > 90 Then Exit Sub
        If Typ = 3 Then If e > 14 Then Exit Sub
        If NewX > 0 And NewY > 0 And NewX < ResX And NewY < ResY Then
            If e < 50 Then
                BackBuffer.SetLockedPixel NewX, NewY, PixCol
            Else
                If Typ = 1 Then
                    If e > 60 Then
                        If Int(Rnd * 4) = 0 Then BackBuffer.SetLockedPixel NewX, NewY, PixCol
                    Else
                        If Int(Rnd * 2) = 0 Then BackBuffer.SetLockedPixel NewX, NewY, PixCol
                    End If
                ElseIf Typ = 2 Then
                    If e < 70 Then BackBuffer.SetLockedPixel NewX, NewY, PixCol
                    If e > 69 And e < 80 Then If Int(Rnd * 2) = 0 Then BackBuffer.SetLockedPixel NewX, NewY, PixCol
                    If e > 79 Then If Int(Rnd * 4) = 0 Then BackBuffer.SetLockedPixel NewX, NewY, PixCol
                End If
            End If
            
            If e = 2 And Not Typ = 3 And Not Typ = 2 Then
                BackBuffer.SetLockedPixel NewX + 1, NewY, PixCol
                BackBuffer.SetLockedPixel NewX - 1, NewY, PixCol
                BackBuffer.SetLockedPixel NewX, NewY + 1, PixCol
                BackBuffer.SetLockedPixel NewX, NewY - 1, PixCol
            End If
        End If
out:
        If balance < 0 Then
            balance = balance + md
            NewY = NewY + y_move
        Else
            balance = balance - mn
            NewX = NewX + x_move
        End If
    Wend
End Sub

Public Sub LineDraw2(Typ As Byte, Colr As Integer, Idx As Integer, LasrX As Integer, LasrY As Integer, LasrX2 As Integer, LasrY2 As Integer)
    Dim PixCol As Long
    Dim mn As Long, md As Long, balance As Long, x_move As Long, y_move As Long
    Dim e As Long, NewX As Long, NewY As Long, Phase As Integer
    If BackBuffer.isLost Then Exit Sub
    
    
    If Typ = 4 Then
        If Colr = 1 Then PixCol = 204
        If Colr = 2 Then PixCol = 98
        If Colr = 3 Then PixCol = 2
        If Colr = 4 Then PixCol = 5
        If LasrX > 1 And LasrY > 1 And LasrX < ResX + 1 And LasrY < ResY + 1 Then BackBuffer.SetLockedPixel LasrX, LasrY, PixCol
        Exit Sub
    End If
    
    md = LasrX2 - LasrX
    If md < 0 Then
        md = -md
        x_move = -1
    Else
        x_move = 1
    End If
    
    mn = LasrY2 - LasrY
    If mn < 0 Then
        mn = -mn
        y_move = -1
    Else
        y_move = 1
    End If
    
    NewX = LasrX
    NewY = LasrY
    
    If mn < md Then
        balance = md
    Else
        balance = -mn
    End If
    mn = 2 * mn
    md = 2 * md
    If Typ = 1 Then If LaserStopMve(Idx) > 0 Then e = LaserDist(Idx) - LaserStopMve(Idx)
    If Typ = 2 Then If BounceStopMve(Idx) > 0 Then e = BounceDist(Idx) - BounceStopMve(Idx)
    While ((NewX <> LasrX2) Or (NewY <> LasrY2))
        e = e + 1
        If e > 17 Then Phase = 2 Else Phase = 1
        If e > 25 Then Phase = 3
        If e > 33 Then Phase = 4
        If Typ = 1 Then
            If LaserStopMve(Idx) > 0 Then
                If e - (LaserDist(Idx) - LaserStopMve(Idx)) < 5 Then Phase = 1
            End If
        End If
        If Typ = 3 Then
            If e > 2 Then Phase = 2 Else Phase = 1
            If e > 7 Then Phase = 3
            If e > 10 Then Phase = 4
        End If
        If Colr = 1 Then
            If Phase = 1 Then PixCol = 65
            If Typ = 1 Then If Phase = 1 And LaserHit(Idx) Then PixCol = 16
            If Phase = 2 Then PixCol = 67
            If Phase = 3 Then PixCol = 69
            If Phase = 4 Then PixCol = 71
        ElseIf Colr = 2 Then
            If Phase = 1 Then PixCol = 49
            If Typ = 1 Then If Phase = 1 And LaserHit(Idx) Then PixCol = 16
            If Phase = 2 Then PixCol = 51
            If Phase = 3 Then PixCol = 53
            If Phase = 4 Then PixCol = 55
        ElseIf Colr = 3 Then
            If Phase = 1 Then PixCol = 81
            If Typ = 1 Then If Phase = 1 And LaserHit(Idx) Then PixCol = 16
            If Phase = 2 Then PixCol = 83
            If Phase = 3 Then PixCol = 85
            If Phase = 4 Then PixCol = 87
        ElseIf Colr = 4 Then
            If Phase = 1 Then PixCol = 97
            If Typ = 1 Then If Phase = 1 And LaserHit(Idx) Then PixCol = 16
            If Phase = 2 Then PixCol = 99
            If Phase = 3 Then PixCol = 101
            If Phase = 4 Then PixCol = 103
        ElseIf Colr = 5 Then
            If Phase = 1 Then PixCol = 17
            If Phase = 2 Then PixCol = 22
            If Phase = 3 Then PixCol = 42
            If Phase = 4 Then PixCol = 47
        ElseIf Colr = 6 Then
            If Phase = 1 Then PixCol = 17
            If Phase = 2 Then PixCol = 19
            If Phase = 3 Then PixCol = 21
            If Phase = 4 Then PixCol = 23
        End If
        If Typ = 1 Then If e > 70 Then Exit Sub
        If Typ = 2 Then If e > 90 Then Exit Sub
        If Typ = 3 Then If e > 14 Then Exit Sub
        If NewX > 0 And NewY > 0 And NewX < ResX And NewY < ResY Then
            If e < 50 Then
                BackBuffer.SetLockedPixel NewX, NewY, PixCol
            Else
                If Typ = 1 Then
                    If e > 60 Then
                        If Int(Rnd * 4) = 0 Then BackBuffer.SetLockedPixel NewX, NewY, PixCol
                    Else
                        If Int(Rnd * 2) = 0 Then BackBuffer.SetLockedPixel NewX, NewY, PixCol
                    End If
                ElseIf Typ = 2 Then
                    If e < 70 Then BackBuffer.SetLockedPixel NewX, NewY, PixCol
                    If e > 69 And e < 80 Then If Int(Rnd * 2) = 0 Then BackBuffer.SetLockedPixel NewX, NewY, PixCol
                    If e > 79 Then If Int(Rnd * 4) = 0 Then BackBuffer.SetLockedPixel NewX, NewY, PixCol
                End If
            End If
            
            If e = 2 And Not Typ = 3 And Not Typ = 2 Then
                BackBuffer.SetLockedPixel NewX + 1, NewY, PixCol
                BackBuffer.SetLockedPixel NewX - 1, NewY, PixCol
                BackBuffer.SetLockedPixel NewX, NewY + 1, PixCol
                BackBuffer.SetLockedPixel NewX, NewY - 1, PixCol
            End If
        End If
out:
        If balance < 0 Then
            balance = balance + md
            NewY = NewY + y_move
        Else
            balance = balance - mn
            NewX = NewX + x_move
        End If
    Wend
End Sub

Public Function DDRGB(Red As Integer, Green As Integer, Blue As Integer) As Long
    If Paletted Then
        DDRGB = 64 'RGB(Red, Green, Blue)
        Exit Function
    End If
    DDRGB = (Red \ RedShiftRight) * RedShiftLeft + _
        (Green \ GreenShiftRight) * GreenShiftLeft + _
        (Blue \ BlueShiftRight) * BlueShiftLeft
End Function

Public Sub ExplSpark(ExplX As Integer, ExplY As Integer)
    Dim I As Integer, d As Integer, j As Integer, F As Single
    For I = 0 To UBound(Spark) + 1
        If I > UBound(Spark) Then
            ReDim Preserve Spark(I), SparkX(I), SparkY(I), SparkSpeed(30, I)
            ReDim Preserve SparkAngle(30, I), SparkDist(30, I), SparkTick(I)
            Exit For
        End If
    Next
    Randomize
    For d = 0 To 30
        SparkAngle(d, I) = -90 + d * 12
        j = Int(Rnd * 10 + 1)
        If j < 11 Then F = 1
        If j < 9 Then F = 0.5
        If j < 7 Then F = 0.3
        If j < 3 Then F = 0.1
        SparkSpeed(d, I) = F
        SparkDist(d, I) = 2
    Next
    SparkTick(I) = Int(Rnd * 5) * 40
    Spark(I) = NewGTC
    SparkX(I) = ExplX
    SparkY(I) = ExplY
End Sub

Public Sub DisplayTime()
    Dim xt As Integer, yt As Integer, rBuff As RECT
    Dim a As Integer, I As Integer, j As Integer
    xt = 452
    yt = 120
    rBuff.Top = yt
    rBuff.Bottom = rBuff.Top + 27
    rBuff.Left = xt
    rBuff.Right = rBuff.Left + 67
    BackBuffer.BltFast ResX - 118, 112, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
    
    a = Int(TimeTick \ 60)
    
    If a > 99 Then a = 99
    I = (a - (a Mod 10)) \ 10 * 7
    j = (a Mod 10) * 7
    rBuff.Top = 0
    rBuff.Bottom = rBuff.Top + 12
    rBuff.Left = 251 + I
    rBuff.Right = rBuff.Left + 7
    BackBuffer.BltFast ResX - 103, 122, DirectDraw_NavBar, rBuff, DDBLTFAST_SRCCOLORKEY Or DDBLTFAST_WAIT
    rBuff.Left = 251 + j
    rBuff.Right = rBuff.Left + 7
    BackBuffer.BltFast ResX - 94, 122, DirectDraw_NavBar, rBuff, DDBLTFAST_SRCCOLORKEY Or DDBLTFAST_WAIT
    
    a = TimeTick
    a = a - Int(a \ 60) * 60
    
    If a > 99 Then a = 99
    I = (a - (a Mod 10)) \ 10 * 7
    j = (a Mod 10) * 7
    rBuff.Top = 0
    rBuff.Bottom = rBuff.Top + 12
    rBuff.Left = 251 + I
    rBuff.Right = rBuff.Left + 7
    BackBuffer.BltFast ResX - 83, 122, DirectDraw_NavBar, rBuff, DDBLTFAST_SRCCOLORKEY Or DDBLTFAST_WAIT
    rBuff.Left = 251 + j
    rBuff.Right = rBuff.Left + 7
    BackBuffer.BltFast ResX - 74, 122, DirectDraw_NavBar, rBuff, DDBLTFAST_SRCCOLORKEY Or DDBLTFAST_WAIT
End Sub

Public Sub Radar()
    If Players(MeNum).InPen Then Exit Sub
    Dim I As Integer, RayX As Integer, RayY As Integer
    Dim j As Integer
    Dim rBuff As RECT
    Dim xt As Integer, yt As Integer, X As Integer, Rx As Integer, Ry As Integer
    Rx = 452
    Ry = 57
    Static FlagFlashT As Long
    For I = 1 To UBound(Players)
        If Not Players(I).InPen Then
            RayX = ResX - 86 + (Players(I).charX - Players(MeNum).charX) * 0.03
            RayY = 62 + (Players(I).charY - Players(MeNum).charY) * 0.03
            If RayX > ResX - 135 And RayY > 17 And RayX < ResX - 39 And RayY < 109 Then
                rBuff.Top = Ry + ((Players(I).Ship - 1) * 5)
                rBuff.Bottom = rBuff.Top + 2
                rBuff.Left = 40 + Rx
                rBuff.Right = rBuff.Left + 3
                BackBuffer.BltFast RayX, RayY, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
                If Players(I).FlagWho > 0 Then
                    If NewGTC - FlagFlashT > 500 Then
                        If NewGTC - FlagFlashT > 1000 Then FlagFlashT = NewGTC
                        rBuff.Top = Ry + ((Players(I).FlagWho - 1) * 5)
                        rBuff.Bottom = rBuff.Top + 4
                        rBuff.Left = 40 + Rx
                        rBuff.Right = rBuff.Left + 4
                        BackBuffer.BltFast RayX, RayY - 1, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
                    End If
                End If
            End If
        End If
    Next
    For I = 0 To UBound(UniBall)
        If UniBall(I).Color > 0 Then
            RayX = ResX - 86 + (UniBall(I).BallX - Players(MeNum).charX) * 0.03
            RayY = 62 + (UniBall(I).BallY - Players(MeNum).charY) * 0.03
            rBuff.Top = Ry + ((UniBall(I).Color - 1) * 5)
            rBuff.Bottom = rBuff.Top + 4
            rBuff.Left = 40 + Rx
            rBuff.Right = rBuff.Left + 4
            BackBuffer.BltFast RayX, RayY - 1, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
        End If
    Next
    'flagpoles
    'green
    I = 0
    For j = 1 To UBound(FlagPole1, 2)
        If FlagPole1(0, j) <> 0 Or FlagPole1(0, j) <> 0 Then
            RayX = ResX - 86 + (FlagPole1(0, j) - Players(MeNum).charX) * 0.03
            RayY = 62 + (FlagPole1(1, j) - Players(MeNum).charY) * 0.03
            If RayX > ResX - 135 And RayY > 17 And RayX < ResX - 39 And RayY < 109 Then
                xt = FlagPole1(0, j) \ 16
                yt = FlagPole1(1, j) \ 16
                I = Animations(yt, xt)
                If I = 24 Then X = 0
                If I = 25 Then X = 1
                If I = 26 Then X = 2
                If I = 27 Then X = 3
                If I = 128 Then X = 4
                rBuff.Top = Ry
                rBuff.Bottom = rBuff.Top + 4
                rBuff.Left = (X * 4) + Rx
                rBuff.Right = rBuff.Left + 3
                BackBuffer.BltFast RayX, RayY, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
            End If
        End If
    Next
    'red
    For j = 1 To UBound(FlagPole2, 2)
        If FlagPole2(0, j) <> 0 Or FlagPole2(0, j) <> 0 Then
            RayX = ResX - 86 + (FlagPole2(0, j) - Players(MeNum).charX) * 0.03
            RayY = 62 + (FlagPole2(1, j) - Players(MeNum).charY) * 0.03
            If RayX > ResX - 135 And RayY > 17 And RayX < ResX - 39 And RayY < 109 Then
                xt = FlagPole2(0, j) \ 16
                yt = FlagPole2(1, j) \ 16
                I = Animations(yt, xt)
                If I = 32 Then X = 0
                If I = 33 Then X = 1
                If I = 34 Then X = 2
                If I = 35 Then X = 3
                If I = 129 Then X = 4
                rBuff.Top = Ry + 5
                rBuff.Bottom = rBuff.Top + 4
                rBuff.Left = (X * 4) + Rx
                rBuff.Right = rBuff.Left + 3
                BackBuffer.BltFast RayX, RayY, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
            End If
        End If
    Next
    'blue
    For j = 1 To UBound(FlagPole3, 2)
        If FlagPole3(0, j) <> 0 Or FlagPole3(0, j) <> 0 Then
            RayX = ResX - 86 + (FlagPole3(0, j) - Players(MeNum).charX) * 0.03
            RayY = 62 + (FlagPole3(1, j) - Players(MeNum).charY) * 0.03
            If RayX > ResX - 135 And RayY > 17 And RayX < ResX - 39 And RayY < 109 Then
                xt = FlagPole3(0, j) \ 16
                yt = FlagPole3(1, j) \ 16
                I = Animations(yt, xt)
                If I = 40 Then X = 0
                If I = 41 Then X = 1
                If I = 42 Then X = 2
                If I = 43 Then X = 3
                If I = 130 Then X = 4
                rBuff.Top = Ry + 10
                rBuff.Bottom = rBuff.Top + 4
                rBuff.Left = (X * 4) + Rx
                rBuff.Right = rBuff.Left + 3
                BackBuffer.BltFast RayX, RayY, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
            End If
        End If
    Next
    'yellow
    For j = 1 To UBound(FlagPole4, 2)
        If FlagPole4(0, j) <> 0 Or FlagPole4(0, j) <> 0 Then
            RayX = ResX - 86 + (FlagPole4(0, j) - Players(MeNum).charX) * 0.03
            RayY = 62 + (FlagPole4(1, j) - Players(MeNum).charY) * 0.03
            If RayX > ResX - 135 And RayY > 17 And RayX < ResX - 39 And RayY < 109 Then
                xt = FlagPole4(0, j) \ 16
                yt = FlagPole4(1, j) \ 16
                I = Animations(yt, xt)
                If I = 58 Then X = 0
                If I = 59 Then X = 1
                If I = 60 Then X = 2
                If I = 61 Then X = 3
                If I = 131 Then X = 4
                rBuff.Top = Ry + 15
                rBuff.Bottom = rBuff.Top + 4
                rBuff.Left = (X * 4) + Rx
                rBuff.Right = rBuff.Left + 3
                BackBuffer.BltFast RayX, RayY, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
            End If
        End If
    Next
    'white
    For j = 1 To UBound(FlagPole5, 2)
        If FlagPole5(0, j) <> 0 Or FlagPole5(0, j) <> 0 Then
            RayX = ResX - 86 + (FlagPole5(0, j) - Players(MeNum).charX) * 0.03
            RayY = 62 + (FlagPole5(1, j) - Players(MeNum).charY) * 0.03
            If RayX > ResX - 135 And RayY > 17 And RayX < ResX - 39 And RayY < 109 Then
                xt = FlagPole5(0, j) \ 16
                yt = FlagPole5(1, j) \ 16
                I = Animations(yt, xt)
                If I = 136 Then X = 4
                rBuff.Top = Ry + 20
                rBuff.Bottom = rBuff.Top + 4
                rBuff.Left = (X * 4) + Rx
                rBuff.Right = rBuff.Left + 3
                BackBuffer.BltFast RayX, RayY, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
            End If
        End If
    Next
    'flags
    For j = 1 To UBound(Flag1, 2)
        If Flag1(0, j) <> 0 Or Flag1(0, j) <> 0 Then
            RayX = ResX - 86 + (Flag1(0, j) - Players(MeNum).charX) * 0.03
            RayY = 62 + (Flag1(1, j) - Players(MeNum).charY) * 0.03
            If RayX > ResX - 135 And RayY > 17 And RayX < ResX - 39 And RayY < 109 And FlagCarry1(j) = 0 Then
                rBuff.Top = Ry
                rBuff.Bottom = rBuff.Top + 3
                rBuff.Left = (5 * 4) + Rx
                rBuff.Right = rBuff.Left + 3
                BackBuffer.BltFast RayX, RayY, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
            End If
        End If
    Next
    For j = 1 To UBound(Flag2, 2)
        If Flag2(0, j) <> 0 Or Flag2(0, j) <> 0 Then
            RayX = ResX - 86 + (Flag2(0, j) - Players(MeNum).charX) * 0.03
            RayY = 62 + (Flag2(1, j) - Players(MeNum).charY) * 0.03
            If RayX > ResX - 135 And RayY > 17 And RayX < ResX - 39 And RayY < 109 And FlagCarry2(j) = 0 Then
                rBuff.Top = Ry
                rBuff.Bottom = rBuff.Top + 3
                rBuff.Left = (6 * 4) + Rx
                rBuff.Right = rBuff.Left + 3
                BackBuffer.BltFast RayX, RayY, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
            End If
        End If
    Next
    For j = 1 To UBound(Flag3, 2)
        If Flag3(0, j) <> 0 Or Flag3(0, j) <> 0 Then
            RayX = ResX - 86 + (Flag3(0, j) - Players(MeNum).charX) * 0.03
            RayY = 62 + (Flag3(1, j) - Players(MeNum).charY) * 0.03
            If RayX > ResX - 135 And RayY > 17 And RayX < ResX - 39 And RayY < 109 And FlagCarry3(j) = 0 Then
                rBuff.Top = Ry
                rBuff.Bottom = rBuff.Top + 3
                rBuff.Left = (7 * 4) + Rx
                rBuff.Right = rBuff.Left + 3
                BackBuffer.BltFast RayX, RayY, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
            End If
        End If
    Next
    For j = 1 To UBound(Flag4, 2)
        If Flag4(0, j) <> 0 Or Flag4(0, j) <> 0 Then
            RayX = ResX - 86 + (Flag4(0, j) - Players(MeNum).charX) * 0.03
            RayY = 62 + (Flag4(1, j) - Players(MeNum).charY) * 0.03
            If RayX > ResX - 135 And RayY > 17 And RayX < ResX - 39 And RayY < 109 And FlagCarry4(j) = 0 Then
                rBuff.Top = Ry
                rBuff.Bottom = rBuff.Top + 3
                rBuff.Left = (8 * 4) + Rx
                rBuff.Right = rBuff.Left + 3
                BackBuffer.BltFast RayX, RayY, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
            End If
        End If
    Next
    For j = 1 To UBound(Flag5, 2)
        If Flag5(0, j) <> 0 Or Flag5(0, j) <> 0 Then
            RayX = ResX - 86 + (Flag5(0, j) - Players(MeNum).charX) * 0.03
            RayY = 62 + (Flag5(1, j) - Players(MeNum).charY) * 0.03
            If RayX > ResX - 135 And RayY > 17 And RayX < ResX - 39 And RayY < 109 And FlagCarry5(j) = 0 Then
                rBuff.Top = Ry
                rBuff.Bottom = rBuff.Top + 3
                rBuff.Left = (9 * 4) + Rx
                rBuff.Right = rBuff.Left + 3
                BackBuffer.BltFast RayX, RayY, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
            End If
        End If
    Next
    rBuff.Top = 154
    rBuff.Bottom = rBuff.Top + 22
    rBuff.Left = 251
    rBuff.Right = rBuff.Left + 25
    BackBuffer.BltFast ResX - 97, 51, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
End Sub

Public Sub ShowTeamScores()
    Dim I As Integer, j As Integer, a As Integer
    Dim rBuff As RECT
    a = TeamScores(1)
    If a > 99 Then a = 99
    I = (a - (a Mod 10)) \ 10 * 7
    j = (a Mod 10) * 7
    rBuff.Top = 0
    rBuff.Bottom = rBuff.Top + 12
    rBuff.Left = 251 + I
    rBuff.Right = rBuff.Left + 7
    BackBuffer.BltFast ResX - 33, 392, DirectDraw_NavBar, rBuff, DDBLTFAST_SRCCOLORKEY Or DDBLTFAST_WAIT
    rBuff.Left = 251 + j
    rBuff.Right = rBuff.Left + 7
    BackBuffer.BltFast ResX - 24, 392, DirectDraw_NavBar, rBuff, DDBLTFAST_SRCCOLORKEY Or DDBLTFAST_WAIT
    a = TeamScores(2)
    If a > 99 Then a = 99
    I = (a - (a Mod 10)) \ 10 * 7 + (1 * 70)
    j = (a Mod 10) * 7 + (1 * 70)
    rBuff.Top = 0
    rBuff.Bottom = rBuff.Top + 12
    rBuff.Left = 251 + I
    rBuff.Right = rBuff.Left + 7
    BackBuffer.BltFast ResX - 33, 412, DirectDraw_NavBar, rBuff, DDBLTFAST_SRCCOLORKEY Or DDBLTFAST_WAIT
    rBuff.Left = 251 + j
    rBuff.Right = rBuff.Left + 7
    BackBuffer.BltFast ResX - 24, 412, DirectDraw_NavBar, rBuff, DDBLTFAST_SRCCOLORKEY Or DDBLTFAST_WAIT
    If HData.NumTeams > 2 Then
        a = TeamScores(3)
        If a > 99 Then a = 99
        I = (a - (a Mod 10)) \ 10 * 7 + (2 * 70)
        j = (a Mod 10) * 7 + (2 * 70)
        rBuff.Top = 0
        rBuff.Bottom = rBuff.Top + 12
        rBuff.Left = 251 + I
        rBuff.Right = rBuff.Left + 7
        BackBuffer.BltFast ResX - 33, 432, DirectDraw_NavBar, rBuff, DDBLTFAST_SRCCOLORKEY Or DDBLTFAST_WAIT
        rBuff.Left = 251 + j
        rBuff.Right = rBuff.Left + 7
        BackBuffer.BltFast ResX - 24, 432, DirectDraw_NavBar, rBuff, DDBLTFAST_SRCCOLORKEY Or DDBLTFAST_WAIT
    End If
    If HData.NumTeams > 3 Then
        a = TeamScores(4)
        If a > 99 Then a = 99
        I = (a - (a Mod 10)) \ 10 * 7 + (3 * 70)
        j = (a Mod 10) * 7 + (3 * 70)
        rBuff.Top = 0
        rBuff.Bottom = rBuff.Top + 12
        rBuff.Left = 251 + I
        rBuff.Right = rBuff.Left + 7
        BackBuffer.BltFast ResX - 33, 452, DirectDraw_NavBar, rBuff, DDBLTFAST_SRCCOLORKEY Or DDBLTFAST_WAIT
        rBuff.Left = 251 + j
        rBuff.Right = rBuff.Left + 7
        BackBuffer.BltFast ResX - 24, 452, DirectDraw_NavBar, rBuff, DDBLTFAST_SRCCOLORKEY Or DDBLTFAST_WAIT
    End If
End Sub

Public Sub AnimMenu()
    Dim rrect As RECT, xt, yt
    Static MenuLen As Integer, MenuOC As Integer, MenuLen2 As Single, rdopend As Boolean
    xt = ResX - 135
    yt = 18
    rrect.Top = 184
    rrect.Bottom = rrect.Top + 94
    If MenuOC = 0 Then
        If NavMenu = MenuPend Then AnimateMenu = False: Exit Sub
        MenuLen2 = 100
        MenuOC = -1
        If EnableSound Then dsRdClose.Play DSBPLAY_DEFAULT
    End If
    
    MenuLen2 = MenuLen2 + ((3 * Speed) * MenuOC)
    
    If MenuLen2 > 100 Then
        MenuOC = 0
        AnimateMenu = False
    End If
    If MenuLen2 < -10 Then MenuOC = 1
    If MenuOC = 1 And MenuLen2 > 0 Then
        If Not rdopend Then
            NavMenu = MenuPend
            If EnableSound Then dsRdOpen.Play DSBPLAY_DEFAULT
        End If
    End If
    MenuLen = MenuLen2
    If MenuLen < 0 Then MenuLen = 0
    rrect.Top = 184 + MenuLen
    rrect.Bottom = rrect.Top + 94 - MenuLen
    rrect.Left = 210 + 147
    rrect.Right = rrect.Left + 100
    BackBuffer.BltFast xt, yt, DirectDraw_NavBar, rrect, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
    rrect.Top = 184
    rrect.Bottom = rrect.Top + 94 - MenuLen
    rrect.Left = 320 + 147
    rrect.Right = rrect.Left + 100
    BackBuffer.BltFast xt, MenuLen + yt, DirectDraw_NavBar, rrect, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
    rrect.Top = 184
    rrect.Bottom = rrect.Top + 94
    rrect.Left = MenuLen + 147
    rrect.Right = rrect.Left + 100 - MenuLen
    BackBuffer.BltFast xt, yt, DirectDraw_NavBar, rrect, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
    rrect.Left = 100 + 147
    rrect.Right = rrect.Left + 100 - MenuLen
    BackBuffer.BltFast MenuLen + xt, yt, DirectDraw_NavBar, rrect, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
End Sub

Public Function PlaySound(Sound As DirectSoundBuffer)
    On Error Resume Next
    If Not Sound Is Nothing And EnableSound Then
        Sound.Play DSBPLAY_DEFAULT
    End If
End Function

Public Sub Direct3D_Blit(SurfaceIndex As Integer, DestX As Single, DestY As Single, Optional SrcX As Single, Optional SrcY As Single, Optional DestWidth As Integer, Optional DestHeight As Integer, Optional ABOne As Boolean, Optional Alpha As Single, Optional R As Single, Optional G As Single, Optional b As Single, Optional Angle As Single)
2263:      If Not DevEnv Then On Error GoTo ErrorTrap
2264:
2265:      If NoD3D Then Exit Sub
2266:      Dim SrcRect As RECT
2267:      Dim DestRect As RECT
2268:      Dim TempVerts(3) As D3DTLVERTEX
           Select Case SurfaceIndex
               Case 0
2271:              With SrcRect
2272:                  .Top = 0
2273:                  .Bottom = 94
2274:                  .Left = 0
2275:                  .Right = 100
2276:              End With
2277:              With DestRect
2278:                  .Left = ResX - 135
2279:                  .Right = .Left + 100
2280:                  .Top = 18
2281:                  .Bottom = .Top + 94
2282:              End With
               Case 1
2284:              With SrcRect
2285:                  .Top = 95
2286:                  .Bottom = 108
2287:                  .Left = 0
2288:                  .Right = Health
2289:              End With
2290:              With DestRect
2291:                  .Left = ResX - (47 + Health)
2292:                  .Right = .Left + Health
2293:                  .Top = 163
2294:                  .Bottom = .Top + 15
2295:              End With
               Case 2
2297:              With SrcRect
2298:                  .Top = 110
2299:                  .Bottom = 123
2300:                  .Left = 0
2301:                  .Right = WepRecharge
2302:              End With
2303:              With DestRect
2304:                  .Left = ResX - (47 + WepRecharge)
2305:                  .Right = .Left + WepRecharge
2306:                  .Top = 182
2307:                  .Bottom = .Top + 14
2308:              End With
           End Select
2310:      dev.BeginScene
2311:      'Set up the TempVerts(3) vertices
2312:      SetUpGeom TempVerts, 128, 128, SrcRect, DestRect, 1, 1, 1, 0.6, 0
2313:      'Enable alpha-blending
2314:      dev.SetRenderState D3DRENDERSTATE_ALPHABLENDENABLE, True
2315:      'Enable color-keying (ColorKey is drawn transparent)
2316:      dev.SetRenderState D3DRENDERSTATE_COLORKEYENABLE, True
2317:      dev.SetRenderState D3DRENDERSTATE_COLORKEYBLENDENABLE, True
2318:      'Use Alpha Blend One alpha blending
2319:      If ABOne = True Then
2320:          dev.SetRenderState D3DRENDERSTATE_SRCBLEND, D3DBLEND_ONE
2321:          dev.SetRenderState D3DRENDERSTATE_DESTBLEND, D3DBLEND_ONE
2322:          'Alpha blend to a certain fade value (0 - 1)
2323:      Else
2324:          dev.SetRenderState D3DRENDERSTATE_SRCBLEND, D3DBLEND_SRCALPHA
2325:          dev.SetRenderState D3DRENDERSTATE_DESTBLEND, D3DBLEND_INVSRCALPHA
2326:          dev.SetRenderState D3DRENDERSTATE_TEXTUREFACTOR, DirectX.CreateColorRGBA(1, 1, 1, 0.6)
2327:          dev.SetTextureStageState 0, D3DTSS_ALPHAOP, D3DTA_TFACTOR
2328:      End If
2329:
2330:      'Set the texture on the D3D device
2331:      dev.SetTexture 0, Direct3D_Alpha
2332:      dev.SetTextureStageState 0, D3DTSS_MIPFILTER, 3
2333:      'Draw the triangles that make up our square texture
2334:      dev.DrawPrimitive D3DPT_TRIANGLESTRIP, D3DFVF_TLVERTEX, TempVerts(0), 4, D3DDP_DEFAULT
2335:      'Turn off alphablending after we're done
2336:      dev.SetRenderState D3DRENDERSTATE_ALPHABLENDENABLE, False
2337:      dev.EndScene
2338:
2339:      Exit Sub
2340:
ErrorTrap:
2342:      RaiseCritical "Direct3D_Blit failed (Line #" & Erl & ". " & DQ & Err.Number & " " & Err.Description & DQ & ")"
2343:      Stopping = True
End Sub

Public Sub SetUpGeom(Verts() As D3DTLVERTEX, SurfW As Integer, SurfH As Integer, Src As RECT, Dest As RECT, R As Single, G As Single, b As Single, a As Single, Angle As Single)
    'This sub sets up the vertices for a sprite, taking into account
    'width, height, vertex color, and rotation angle
    'NOTE: R, G, and B dictate the color that the sprite will be -
    '1, 1, 1 is normal, lower values will colorize the vertices
    
    ' * v1      * v3
    ' |\        |
    ' |  \      |
    ' |    \    |
    ' |      \  |
    ' |        \|
    ' * v0      * v2
    
    Dim XCenter As Single
    Dim YCenter As Single
    Dim XCor As Single
    Dim YCor As Single
    
    'Center coordinates on screen of the sprite
    XCenter = Dest.Left + (Dest.Right - Dest.Left - 1) / 2
    YCenter = Dest.Top + (Dest.Bottom - Dest.Top - 1) / 2
    
    'Calculate screen coordinates of sprite, and only rotate if necessary
    If Angle = 0 Then
        XCor = Dest.Left
        YCor = Dest.Bottom
    Else
        XCor = XCenter + (Dest.Left - XCenter) * Sin(Angle) + (Dest.Bottom - YCenter) * Cos(Angle)
        YCor = YCenter + (Dest.Bottom - YCenter) * Sin(Angle) - (Dest.Left - XCenter) * Cos(Angle)
    End If
    
    '0 - Bottom left vertex
    DirectX.CreateD3DTLVertex XCor, YCor, 0, 1, DirectX.CreateColorRGBA(R, G, b, a), 0, Src.Left / SurfW, (Src.Bottom + 1) / SurfH, Verts(0)
    
    'Calculate screen coordinates of sprite, and only rotate if necessary
    If Angle = 0 Then
        XCor = Dest.Left
        YCor = Dest.Top
    Else
        XCor = XCenter + (Dest.Left - XCenter) * Sin(Angle) + (Dest.Top - YCenter) * Cos(Angle)
        YCor = YCenter + (Dest.Top - YCenter) * Sin(Angle) - (Dest.Left - XCenter) * Cos(Angle)
    End If
    
    '1 - Top left vertex
    DirectX.CreateD3DTLVertex XCor, YCor, 0, 1, DirectX.CreateColorRGBA(R, G, b, a), 0, Src.Left / SurfW, Src.Top / SurfH, Verts(1)
    
    'Calculate screen coordinates of sprite, and only rotate if necessary
    If Angle = 0 Then
        XCor = Dest.Right
        YCor = Dest.Bottom
    Else
        XCor = XCenter + (Dest.Right - XCenter) * Sin(Angle) + (Dest.Bottom - YCenter) * Cos(Angle)
        YCor = YCenter + (Dest.Bottom - YCenter) * Sin(Angle) - (Dest.Right - XCenter) * Cos(Angle)
    End If
    
    '2 - Bottom right vertex
    DirectX.CreateD3DTLVertex XCor, YCor, 0, 1, DirectX.CreateColorRGBA(R, G, b, a), 0, (Src.Right + 1) / SurfW, (Src.Bottom + 1) / SurfH, Verts(2)
    
    'Calculate screen coordinates of sprite, and only rotate if necessary
    If Angle = 0 Then
        XCor = Dest.Right
        YCor = Dest.Top
    Else
        XCor = XCenter + (Dest.Right - XCenter) * Sin(Angle) + (Dest.Top - YCenter) * Cos(Angle)
        YCor = YCenter + (Dest.Top - YCenter) * Sin(Angle) - (Dest.Right - XCenter) * Cos(Angle)
    End If
    
    '3 - Top right vertex
    DirectX.CreateD3DTLVertex XCor, YCor, 0, 1, DirectX.CreateColorRGBA(R, G, b, a), 0, (Src.Right + 1) / SurfW, Src.Top / SurfH, Verts(3)
End Sub

Public Sub PlainSystemPlanes()
    On Error GoTo ErrorTrap
    If BackBuffer.isLost Then Exit Sub
    Dim ddsdProperties2 As DDSURFACEDESC2, rrect As RECT
    Dim TempDXD As DDSURFACEDESC2, Key As DDCOLORKEY
retry:
    Key.low = 0
    Key.high = 0
    ddsdProperties2.lFlags = DDSD_CAPS Or DDSD_WIDTH Or DDSD_HEIGHT
    ddsdProperties2.ddsCaps.lCaps = DDSCAPS_OFFSCREENPLAIN Or DDSCAPS_SYSTEMMEMORY
    ddsdProperties2.lWidth = 640
    ddsdProperties2.lHeight = 1320
    Set DirectDraw_Tuna = Nothing
    If FileExists(AppPath & "graphics.patch\tuna.bmp") Then
        Set DirectDraw_Tuna = DirectDraw.CreateSurfaceFromFile(AppPath & "graphics.patch\tuna.bmp", ddsdProperties2)
    Else
        Set DirectDraw_Tuna = DirectDraw.CreateSurfaceFromFile(AppPath & "graphics\tuna.bmp", ddsdProperties2)
    End If
    ddsdProperties2.lWidth = 640
    ddsdProperties2.lHeight = 1600
    Set DirectDraw_Tile = Nothing
    If FileExists(AppPath & "graphics.patch\Tiles.bmp") Then
        Set DirectDraw_Tile = DirectDraw.CreateSurfaceFromFile(AppPath & "graphics.patch\Tiles.bmp", ddsdProperties2)
    Else
        Set DirectDraw_Tile = DirectDraw.CreateSurfaceFromFile(AppPath & "graphics\Tiles.bmp", ddsdProperties2)
    End If
    With TempDXD
        .lFlags = DDSD_CAPS Or DDSD_HEIGHT Or DDSD_WIDTH
        .ddsCaps.lCaps = DDSCAPS_OFFSCREENPLAIN Or DDSCAPS_SYSTEMMEMORY
    End With
    DirectDraw_Tuna.Lock rrect, TempDXD, DDLOCK_WAIT, 0
    KEYColor = DirectDraw_Tuna.GetLockedPixel(0, 0)
    DirectDraw_Tuna.Unlock rrect
    If Not Paletted Then GetColorShiftValues DirectDraw_Tile
    Exit Sub
ErrorTrap:
    If Not LowMem Then
        LowMem = True
        SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "LowMemory", 1
        GoTo retry
    ElseIf Not LowVRAM Then
        SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "LowVRAM", 1
        LowVRAM = True
        GoTo retry
    Else
        RaiseCritical "Your machine doesn't appear to have enough memory to run the game. Critical fault at line #" & Erl & ". (" & Err.Description & ")"
    End If
    RaiseCritical "Plane files failed to load properly. (Line #" & Erl & ". " & DQ & Err.Number & " " & Err.Description & DQ & ")"
End Sub

Public Sub GetColorShiftValues(PrimarySurface As DirectDrawSurface7)
    Dim PixelFormat As DDPIXELFORMAT
    PrimarySurface.GetPixelFormat PixelFormat
    MaskToShiftValues PixelFormat.lRBitMask, RedShiftRight, RedShiftLeft
    MaskToShiftValues PixelFormat.lGBitMask, GreenShiftRight, GreenShiftLeft
    MaskToShiftValues PixelFormat.lBBitMask, BlueShiftRight, BlueShiftLeft
End Sub

Public Sub MaskToShiftValues(ByVal Mask As Long, ShiftRight As Long, ShiftLeft As Long)
    Dim ZeroBitCount As Long
    Dim OneBitCount As Long
    ZeroBitCount = 0
    Do While (Mask And 1) = 0
        ZeroBitCount = ZeroBitCount + 1
        Mask = Mask \ 2
    Loop
    OneBitCount = 0
    Do While (Mask And 1) = 1
        OneBitCount = OneBitCount + 1
        Mask = Mask \ 2
    Loop
    ShiftRight = 2 ^ (8 - OneBitCount)
    ShiftLeft = 2 ^ ZeroBitCount
End Sub
