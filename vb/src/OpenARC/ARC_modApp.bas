Attribute VB_Name = "modApp"
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
Public Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (hpvDest As Any, hpvSource As Any, ByVal cbCopy As Long)
'Public Declare Sub CopyMemory Lib "C:\OpenARC\CDLL\Release\CDLL.dll" Alias "CopyMemorySSE" (ByVal hpvDest As Long, ByVal hpvSource As Long, ByVal cbCopy As Long)
Public iLAttempts As clsByte
Public DebugConsole As clsByte
Type MEMORY_BASIC_INFORMATION ' 28 bytes
    BaseAddress As Long
    AllocationBase As Long
    AllocationProtect As Long
    RegionSize As Long
    State As Long
    Protect As Long
    lType As Long
    End Type
Declare Function VirtualQuery& Lib "kernel32" (ByVal lpAddress As Long, lpBuffer As _
    MEMORY_BASIC_INFORMATION, ByVal dwLength As Long)
Type SYSTEM_INFO ' 36 Bytes
    dwOemID As Long
    dwPageSize As Long
    lpMinimumApplicationAddress As Long
    lpMaximumApplicationAddress As Long
    dwActiveProcessorMask As Long
    dwNumberOrfProcessors As Long
    dwProcessorType As Long
    dwAllocationGranularity As Long
    wProcessorLevel As Integer
    wProcessorRevision As Integer
    End Type
Declare Sub GetSystemInfo Lib "kernel32" (lpSystemInfo As SYSTEM_INFO)
Public Declare Function LockWindowUpdate Lib "user32" (ByVal hwndLock As Long) As Long
Public Declare Function GetClientRect Lib "user32" (ByVal hwnd As Integer, ByRef lpRect As RECT) As Integer
Public Declare Function OffsetRect Lib "user32" (lpRect As RECT, ByVal X As Long, ByVal y As Long) As Long
Public Declare Function SetRect Lib "user32" (lpRect As RECT, ByVal x1 As Long, ByVal Y1 As Long, ByVal x2 As Long, ByVal Y2 As Long) As Long
'looks at message and removes/leaves it if there is one
'returns nonzero if a message was in event queue
Public Declare Function PeekMessage Lib "user32" Alias "PeekMessageA" (lpMsg As Msg, ByVal hwnd As Long, ByVal wMsgFilterMin As Long, ByVal wMsgFilterMax As Long, ByVal wRemoveMsg As Long) As Long
'dispatches message calls the right message handling procedure
Public Declare Function DispatchMessage Lib "user32" Alias "DispatchMessageA" (lpMsg As Msg) As Long
'virtual accelerator key translator
'dont worry about what it does just leave it there
Public Declare Function TranslateMessage Lib "user32" (lpMsg As Msg) As Long
'gets next message in event queue
Public Declare Function GetMessage Lib "user32" Alias "GetMessageA" (lpMsg As Msg, ByVal hwnd As Long, ByVal wMsgFilterMin As Long, ByVal wMsgFilterMax As Long) As Long
'checks if there is a message in event queue
Public Declare Function GetQueueStatus Lib "user32" (ByVal fuFlags As Long) As Long


Public Const MY_WM_QUIT = &HA1     'WM_QUIT in api viewer is wrong this is the right constant

Public Const PM_REMOVE = &H1       'paramater on peekmessage to remove or leave message in queue
Public Const PM_NOREMOVE = &H0
'type of events that can happen with window
Public Const QS_MOUSEBUTTON = &H4
Public Const QS_MOUSEMOVE = &H2
Public Const QS_PAINT = &H20
Public Const QS_POSTMESSAGE = &H8  'any other message
Public Const QS_TIMER = &H10
Public Const QS_HOTKEY = &H80
Public Const QS_KEY = &H1
Public Const QS_MOUSE = (QS_MOUSEMOVE Or QS_MOUSEBUTTON)
Public Const QS_INPUT = (QS_MOUSE Or QS_KEY)
Public Const QS_ALLEVENTS = (QS_INPUT Or QS_POSTMESSAGE Or QS_TIMER Or QS_PAINT Or QS_HOTKEY)

'extra messages that can be sent (not used in example)
Public Const QS_SENDMESSAGE = &H40    'message sent by other thread or app
Public Const QS_ALLINPUT = (QS_SENDMESSAGE Or QS_PAINT Or QS_TIMER Or QS_POSTMESSAGE Or QS_MOUSEBUTTON Or QS_MOUSEMOVE Or QS_HOTKEY Or QS_KEY)
'*************************

Public Declare Function GetTickCount Lib "kernel32" () As Long
Declare Function GetWindowsDirectory Lib "kernel32.dll" Alias "GetWindowsDirectoryA" (ByVal lpBuffer As String, ByVal nSize As Long) As Long
Declare Function SetWindowPos Lib "user32" (ByVal hwnd As Long, ByVal hWndInsertAfter As Long, ByVal X As Long, ByVal y As Long, ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long) As Long
Const HWND_TOPMOST As Integer = -1
Const HWND_NOTOPMOST As Integer = -2
Const SWP_NOMOVE As Long = &H2
Const SWP_NOSIZE As Long = &H1

Public Type POINTAPI
    X As Long
    y As Long
End Type

Public Type Msg
    hwnd     As Long        'window where message occured
    Message  As Long        'message id itself
    wParam   As Long        'further defines message
    lParam   As Long        'further defines message
    Time     As Long        'time of message event
    pt       As POINTAPI    'position of mouse
End Type

Public Message As Msg         'holds message recieved from queue

Public Type BITMAPFILEHEADER
    bfType As Integer
    bfSize As Long
    bfReserved1 As Integer
    bfReserved2 As Integer
    bfOffBits As Long
End Type

Public Type BITMAPINFOHEADER
    biSize As Long
    biWidth As Long
    biHeight As Long
    biPlanes As Integer
    biBitCount As Integer
    biCompression As Long
    biSizeImage As Long
    biXPelsPerMeter As Long
    biYPelsPerMeter As Long
    biClrUsed As Long
    biClrImportant As Long
End Type

Public HandleDC  As Long, HandleDC2  As Long

Private Declare Function uncompress Lib "zlib.dll" (Dest As Any, destLen As Any, Src As Any, ByVal srcLen As Long) As Long

Declare Function QueryPerformanceFrequency Lib "kernel32" (lpFrequency As Currency) As Long
Declare Function QueryPerformanceCounter Lib "kernel32.dll" (lpPerformanceCount As Currency) As Long

Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationname As String, ByVal lpKeyName As Any, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long
Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationname As String, ByVal lpKeyName As Any, ByVal lpString As Any, ByVal lpFileName As String) As Long
Public Declare Function GetVolumeInformation Lib "kernel32" Alias "GetVolumeInformationA" (ByVal lpRootPathName As String, ByVal lpVolumeNameBuffer As String, ByVal nVolumeNameSize As Long, lpVolumeSerial_Numberber As Long, lpMaximumComponentLength As Long, lpFileSystemFlags As Long, ByVal lpFileSystemNameBuffer As String, ByVal nFileSystemNameSize As Long) As Long

Declare Function IntersectRect Lib "user32" (lpDestRect As RECT, lpSrc1Rect As RECT, lpSrc2Rect As RECT) As Long

Public Declare Function GetCursorPos Lib "user32" (lpPoint As POINTAPI) As Long
Public Declare Function SetCursorPos Lib "user32" (ByVal X As Long, ByVal y As Long) As Long
Public Declare Function ScreenToClient Lib "user32" (ByVal hwnd As Long, lpPoint As POINTAPI) As Long
Public Declare Function ClientToScreen Lib "user32" (ByVal hwnd As Long, lpPoint As POINTAPI) As Long
Public Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
Public Declare Function CallWindowProc Lib "user32" Alias "CallWindowProcA" (ByVal lpPrevWndFunc As Long, ByVal hwnd As Long, ByVal Msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long

Declare Function VirtualAlloc Lib "kernel32" (ByVal lpAddress As Long, ByVal dwSize As Long, ByVal flAllocationType As Long, ByVal flProtect As Long) As Long
Declare Function VirtualFree Lib "kernel32" (ByVal lpAddress As Long, ByVal dwSize As Long, ByVal dwFreeType As Long) As Long
Declare Function VirtualProtect Lib "kernel32" (ByVal lpAddress As Long, ByVal dwSize As Long, ByVal flNewProtect As Long, lpflOldProtect As Long) As Long

Public Const MEM_COMMIT = 4096
Public Const MEM_DECOMMIT = 16384
Public Const MEM_PRIVATE& = &H20000
Public Const PAGE_NOACCESS = 1
Public Const PAGE_READONLY = 2
Public Const PAGE_READWRITE = 4
Public Const PAGE_WRITECOPY = 8
Public Const PAGE_EXECUTE = 16
Public Const PAGE_EXECUTE_READ = 32
Public Const PAGE_EXECUTE_READWRITE = 64
Public Const PAGE_EXECUTE_WRITECOPY = 128
Public Const PAGE_GUARD = 256
Public Const PAGE_NOCACHE = 512

Public Encryption As clsEncryption
Private Type MEMORYSTATUS
    dwLength As Long
    dwMemoryLoad As Long
    dwTotalPhys As Long
    dwAvailPhys As Long
    dwTotalPageFile As Long
    dwAvailPageFile As Long
    dwTotalVirtual As Long
    dwAvailVirtual As Long
End Type

Private pUdtMemStatus As MEMORYSTATUS

Private Declare Sub GlobalMemoryStatus Lib _
    "kernel32" (lpBuffer As MEMORYSTATUS)
    
Public StartupTime As Long

Public Function GetDriveInfo(strDrive As String, iType As Integer)
    Dim Serial_Number As Long
    Dim Drive_Label As String
    Dim Fat_Type As String
    Dim Return_Value As Long
    Drive_Label = Space(256)
    Fat_Type = Space(256)
    Return_Value = GetVolumeInformation(strDrive, Drive_Label, Len(Drive_Label), Serial_Number, 0, 0, Fat_Type, Len(Fat_Type))
    GetDriveInfo = CStr(Serial_Number)
End Function

Public Function newCInt(Variable) As Integer
    newCInt = Variable \ 1
End Function

Public Sub PrintByteArray(bArray() As Byte)
    Dim a As String
    Dim I As Integer, max As Integer
    If UBound(bArray) > 50 Then
        max = 50
    Else
        max = UBound(bArray)
    End If
    For I = 0 To max
        a = a & " " & CInt(bArray(I))
    Next
    a = a & vbCrLf
    For I = 0 To max
        a = a & " " & Chr$(CInt(bArray(I)))
    Next
    Debug.Print a
End Sub

Public Function RaiseError(Caption As String)
    frmDisplay.Hide
    DoEvents
    If StartLog Then
        StartupLog "-------------------------------"
        StartupLog "-    ERROR HAS BEEN RAISED    -"
        StartupLog "-   TERMINATING PROGRAM NOW   -"
        StartupLog "-------------------------------"
        StartupLog Caption
    End If
    If Not DirectDraw Is Nothing Then DirectDraw.RestoreDisplayMode
    frmError.lblErrorMessage = Caption
    frmError.Show 1
    Do While frmError.Visible = True
        DoEvents
    Loop
    Stopping = True
    RaiseError = 0
End Function

Public Function RaiseCritical(Caption As String)
    If StartLog Then
        StartupLog "-------------------------------"
        StartupLog "-       CRITICAL FAILURE      -"
        StartupLog "-   TERMINATING PROGRAM NOW   -"
        StartupLog "-------------------------------"
        StartupLog Caption
    End If
    frmDisplay.Hide
    DoEvents
    If Not DirectDraw Is Nothing Then DirectDraw.RestoreDisplayMode
    frmCriticalError.lblErrorMessage = Caption
    frmCriticalError.Show 1
    Do While frmCriticalError.Visible = True
        DoEvents
    Loop
    Stopping = True
    RaiseCritical = 0
End Function

Public Sub MakeAlwaysOnTop(TheForm As Form, SetOnTop As Boolean)
    Dim lflag As Integer
    If SetOnTop Then
        lflag = HWND_TOPMOST
    Else
        lflag = HWND_NOTOPMOST
    End If
    SetWindowPos TheForm.hwnd, lflag, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE
End Sub

Public Sub DebugLog(txt As String)
    On Error Resume Next
    Dim iFreeFile As Integer
    iFreeFile = FreeFile
    Debug.Print txt
    Open AppPath & "DebugLog.txt" For Append As #iFreeFile
    Print #1, txt
    Close #1
End Sub

Public Sub StartupLog(txt As String)
    On Error Resume Next
    Dim iFreeFile As Integer
    iFreeFile = FreeFile
    frmDebug.AddText txt
    Open AppPath & "blackbox.txt" For Append As #iFreeFile
    Print #1, txt
    Close #1
End Sub

Public Sub DimEm()
    LDamage(0) = 3
    LDamage(1) = 5
    LDamage(2) = 7
    LDamage(3) = 14
    LDamage(4) = 18
    LDamage2(0) = 3
    LDamage2(1) = 7
    LDamage2(2) = 12
    LDamage2(3) = 15
    LDamage2(4) = 20
    SDamage(0) = 8
    SDamage(1) = 13
    SDamage(2) = 16
    SDamage(3) = 35
    SDamage(4) = 45
    SDamage2(0) = 2.25 '9
    SDamage2(1) = 3.25 '13
    SDamage2(2) = 4.25 '17
    SDamage2(3) = 7 '28
    SDamage2(4) = 9.25 '39
    ReDim Flag1(1, 0), Flag2(1, 0), Flag3(1, 0), Flag4(1, 0), Flag5(1, 0)
    ReDim FlagCarry1(0), FlagCarry2(0), FlagCarry3(0), FlagCarry4(0), FlagCarry5(0), FlagBlinkT(4, 0), FlagBlink(4, 0), FlagBlinking(4, 0)
    ReDim Mortar(0), LastNCX(0), LastNCY(0), Chat(7), Mines(0)
    ReDim MortarX(0), Popping(0), Ignored(0), RMData(0)
    ReDim FlagPole1(1, 0), FlagPole2(1, 0), FlagPole3(1, 0), FlagPole4(1, 0), FlagPole5(1, 0)
    ReDim MortarY(0), MortarFrame(0), MortarDest(0), MortarDist(0), MortarAngle(0)
    ReDim MortarWho(0), ShrapAngle(30, 0), ShrapDist(0), MortarTeam(0), MortarSpeed(0)
    ReDim Explode(0), ExplodeWho(0), ExplodeX(0), ExplodeY(0), ExplodeWho(0), ShrapSpeed(0), ShrapTick(0)
    ReDim Spark(0), SparkTick(0)
    ReDim Miss(0), MissWho(0), MissX(0), MissY(0), MissDist(0), MissAngle(0), MissTeam(0)
    ReDim Switches(0), Switched(0)
    ReDim SmkX(0), SmkY(0), SmkColor(0), Smk(0), SmkT(0), Players(0)
    ReDim SmkX2(0), SmkY2(0), SmkColor2(0), Smk2(0), SmkT2(0)
    ReDim Captured(0), FlagCap(0), WhoTeam(0), FlagStatus(0)
    ReDim IsHit(0), WhoHit(0), HitX(0), HitY(0), BounceStopMve(0)
    ReDim Bounce(0), BounceWho(0), BounceAngle(0), BounceDist(0), BounceTrav(0), BounceX(0), BounceY(0), BounceTeam(0)
    ReDim Laser(0), LaserWho(0), LaserAngle(0), LaserDist(0), LaserX(0), LaserY(0), LaserStopMve(0), LaserTeam(0), LaserHit(0)
    ReDim Expl(0), ExplX(0), ExplY(0), AnimExT(0), AnimExF(0)
    ReDim PopAnimF(0), PopX(0), PopY(0)
    ReDim PowerUp(0), PowerX(0), PowerY(0), PowerIndex(0), PowerEffect(0), PowerTick(0), PowerFrame(0), PowerFrameT(0)
    ReDim UniBall(0)
End Sub

Public Function DecompressData(TheData() As Byte, OrigSize As Long) As Long
    
    'Allocate memory for buffers
    Dim BufferSize As Long, CompressedSize As Long, OriginalSize As Long
    Dim result As Long
    Dim TempBuffer() As Byte
    
    BufferSize = OrigSize
    BufferSize = BufferSize + (BufferSize * 0.01) + 12
    ReDim TempBuffer(BufferSize)
    
    'Decompress data
    result = uncompress(TempBuffer(0), BufferSize, TheData(0), UBound(TheData) + 1)
    
    'Truncate buffer to compressed size
    ReDim Preserve TheData(BufferSize - 1)
    CopyMemory TheData(0), TempBuffer(0), BufferSize
    
    'Reset properties
    If result = 0 Then
        CompressedSize = 0
        OriginalSize = 0
    End If
    
    'Return error code (if any)
    DecompressData = result
    
End Function

Public Sub Defaults()
    Health = 60
    WepRecharge = 60
    Weapon = 1
End Sub

Public Sub Interface()
    'On Error GoTo ErrorTrap
218:           Dim rBuff As RECT
219:           Dim I As Integer, j As Integer, a As Integer, b As Integer
220:           Dim X As Integer, y As Integer
221:           Dim PixColB1 As Byte
222:           If BackBuffer.isLost Then Exit Sub
223:
224:           If NoD3D Then
225:               If Not Paletted Then
226:                   HandleDC = BackBuffer.GetDC
227:                   HandleDC2 = DirectDraw_NavBar.GetDC
228:                   If NavMenu = 1 Then BitBlt HandleDC, ResX - 135, 18, 100, 94, HandleDC2, 510, 279, vbSrcAnd
229:                   BitBlt HandleDC, ResX - (47 + Health), 163, Health, 15, HandleDC2, 404, 387, vbSrcCopy
230:                   BitBlt HandleDC, ResX - (47 + WepRecharge), 182, WepRecharge, 15, HandleDC2, 510, 387, vbSrcCopy
231:                   DirectDraw_NavBar.ReleaseDC HandleDC2
232:                   BackBuffer.ReleaseDC HandleDC
233:               End If
234:
235:               If Paletted Then
236:                   If NoBlending Then
237:                       BackBuffer.SetFillColor vbRed
238:                       BackBuffer.DrawBox ResX - (47 + Health), 163, ResX - 47 + Health, 164 + 15
239:                       BackBuffer.SetFillColor vbBlue
240:                       BackBuffer.DrawBox ResX - (47 + WepRecharge), 181, ResX - 47 + WepRecharge, 183 + 15
241:                   Else
242:                       Dim ddsBufferArray() As Byte
243:                       Dim ddsdBuffer As DDSURFACEDESC2
244:                       Dim emptyrect As RECT
245:                       BackBuffer.Lock emptyrect, ddsdBuffer, DDLOCK_NOSYSLOCK Or DDLOCK_WAIT, 0
246:                       BackBuffer.GetLockedArray ddsBufferArray
247:                       X = ResX - 135
248:                       y = 18
249:
250:                       For j = 4 To 17
251:                           For I = 0 To Health
252:                               X = (ResX - 46 - I)
253:                               y = 160 + j
254:                               PixColB1 = ddsBufferArray(X, y)
255:                               ddsBufferArray(X, y) = RedIndex(PixColB1)
256:                           Next
257:                       Next
258:
259:                       For j = 4 To 17
260:                           For I = 0 To WepRecharge
261:                               X = (ResX - 46 - I)
262:                               y = 178 + j
263:                               PixColB1 = ddsBufferArray(X, y)
264:                               ddsBufferArray(X, y) = BlueIndex(PixColB1)
265:                           Next
266:                       Next
267:                       BackBuffer.Unlock emptyrect
268:                   End If
269:               End If
lol:
271:           Else
272:               If NavMenu = 1 Then Direct3D_Blit 0, 0, 0, , , , , False, 0, 0, 0, 0, 0
273:               Direct3D_Blit 1, 0, 0, , , , , False, 0, 0, 0, 0, 0
274:               Direct3D_Blit 2, 0, 0, , , , , False, 0, 0, 0, 0, 0
275:           End If
276:           If WepRge.Mines Then MakeText2 "mines(" & MineAmmo & ")", ResX - 132, 106
277:           I = 250
278:           j = 252
279:           a = ResX - 53
280:           With rBuff
281:               .Top = rWepAmmo(1).Top
282:               .Bottom = rWepAmmo(1).Bottom
283:               .Left = rWepAmmo(1).Left
284:           End With
285:           rBuff.Right = rWepAmmo(1).Left + MissBar
286:           If Weapon = 1 Then
287:               BackBuffer.BltFast a - 10, I, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT
288:           Else
289:               BackBuffer.BltFast a, I, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT
290:           End If
291:           rBuff.Right = rWepAmmo(1).Left + MortarBar
292:           If Weapon = 2 Then
293:               BackBuffer.BltFast a - 10, I + 34, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT
294:           Else
295:               BackBuffer.BltFast a, I + 34, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT
296:           End If
297:           rBuff.Right = rWepAmmo(1).Left + BounceBar
298:           If Weapon = 3 Then
299:               BackBuffer.BltFast a - 10, I + 69, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT
300:           Else
301:               BackBuffer.BltFast a, I + 69, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT
302:           End If
312:           '
313:           a = ResX - 36
314:           j = 249
315:           With rBuff
316:               .Top = 0
317:               .Bottom = 3
318:               .Left = 0
319:               .Right = 4
320:           End With
321:           If Weapon = 1 Then
322:               For I = 0 To MissAmmo - 1 Step 1
323:                   b = I
324:                   BackBuffer.BltFast a - 10, j - 4 - b * 4, DirectDraw_NavBar, rWepAmmo(0), DDBLTFAST_WAIT
325:               Next
326:           Else
327:               For I = 0 To MissAmmo - 1 Step 1
328:                   b = I
329:                   BackBuffer.BltFast a, j - 4 - b * 4, DirectDraw_NavBar, rWepAmmo(0), DDBLTFAST_WAIT
330:               Next
331:           End If
332:           If Weapon = 2 Then
333:               For I = 0 To MortarAmmo - 1 Step 1
334:                   b = I
335:                   BackBuffer.BltFast a - 10, 34 + j - 3 - b * 4, DirectDraw_NavBar, rWepAmmo(0), DDBLTFAST_WAIT
336:               Next
337:           Else
338:               For I = 0 To MortarAmmo - 1 Step 1
339:                   b = I
340:                   BackBuffer.BltFast a, 34 + j - 3 - b * 4, DirectDraw_NavBar, rWepAmmo(0), DDBLTFAST_WAIT
341:               Next
342:           End If
343:           j = 250
344:           If Weapon = 3 Then
345:               For I = 0 To BounceAmmo - 1 Step 1
346:                   b = I
347:                   BackBuffer.BltFast a - 10, 68 + j - 3 - b * 4, DirectDraw_NavBar, rWepAmmo(0), DDBLTFAST_WAIT
348:               Next
349:           Else
350:               For I = 0 To BounceAmmo - 1 Step 1
351:                   b = I
352:                   BackBuffer.BltFast a, 68 + j - 3 - b * 4, DirectDraw_NavBar, rWepAmmo(0), DDBLTFAST_WAIT
353:               Next
354:           End If
355:
369:           '
370:           'For i = 0 To 3
371:           'BackBuffer.DrawBox a, 249 - 4 - i * 3, a + 6, 249 - i * 3
372:           'Next
373:           '
374:           '565, 170
375:           rBuff.Top = 0
376:           rBuff.Bottom = 231
377:           rBuff.Left = 0
378:           rBuff.Right = 147
379:           BackBuffer.BltFast ResX - 147, 0, DirectDraw_NavBar, rBuff, DDBLTFAST_SRCCOLORKEY Or DDBLTFAST_WAIT
380:           If Weapon = 1 Then
381:               rBuff.Top = 0
382:               rBuff.Bottom = rBuff.Top + 34
383:               rBuff.Left = 147
384:               rBuff.Right = 72 + rBuff.Left
385:               BackBuffer.BltFast ResX - 72, 231, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
386:           Else
387:               rBuff.Top = 229
388:               rBuff.Bottom = rBuff.Top + 36
389:               rBuff.Left = 0
390:               rBuff.Right = 147
391:               BackBuffer.BltFast ResX - 147, rBuff.Top, DirectDraw_NavBar, rBuff, DDBLTFAST_SRCCOLORKEY Or DDBLTFAST_WAIT
392:           End If
393:           If Weapon = 2 Then
394:               rBuff.Top = 34
395:               rBuff.Bottom = rBuff.Top + 34
396:               rBuff.Left = 147
397:               rBuff.Right = 72 + rBuff.Left
398:               BackBuffer.BltFast ResX - 72, 265, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
399:           Else
400:               rBuff.Top = 263
401:               rBuff.Bottom = rBuff.Top + 36
402:               rBuff.Left = 0
403:               rBuff.Right = 147
404:               BackBuffer.BltFast ResX - 147, rBuff.Top, DirectDraw_NavBar, rBuff, DDBLTFAST_SRCCOLORKEY Or DDBLTFAST_WAIT
405:           End If
406:           If Weapon = 3 Then
407:               rBuff.Top = 68
408:               rBuff.Bottom = rBuff.Top + 34
409:               rBuff.Left = 147
410:               rBuff.Right = 72 + rBuff.Left
411:               BackBuffer.BltFast ResX - 72, 299, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
412:           Else
413:               rBuff.Top = 297
414:               rBuff.Bottom = rBuff.Top + 34
415:               rBuff.Left = 0
416:               rBuff.Right = 147
417:               BackBuffer.BltFast ResX - 147, rBuff.Top, DirectDraw_NavBar, rBuff, DDBLTFAST_SRCCOLORKEY Or DDBLTFAST_WAIT
418:           End If
419:
420:
421:           rBuff.Top = 329
422:           rBuff.Bottom = 480
423:           rBuff.Left = 0
424:           rBuff.Right = 147
425:           BackBuffer.BltFast ResX - 147, rBuff.Top, DirectDraw_NavBar, rBuff, DDBLTFAST_SRCCOLORKEY Or DDBLTFAST_WAIT
426:
442:
443:           If ResY > 480 Then
444:               rBuff.Top = 151
445:               rBuff.Bottom = 16 + rBuff.Top
446:               rBuff.Left = 221
447:               rBuff.Right = 30 + rBuff.Left
448:               BackBuffer.BltFast ResX - 30, 480, DirectDraw_NavBar, rBuff, DDBLTFAST_SRCCOLORKEY Or DDBLTFAST_WAIT
449:               b = ResY - 480
450:               b = b \ 16
    rBuff.Left = 226: rBuff.Right = 251: rBuff.Top = 168: rBuff.Bottom = 184
452:               'If ResY = 600 Then b = b - 1
453:               For I = 1 To b - 1
454:                   BackBuffer.BltFast ResX - 25, 480 + 16 * I, DirectDraw_NavBar, rBuff, DDBLTFAST_SRCCOLORKEY Or DDBLTFAST_WAIT  ' DirectDraw_Spacer
455:               Next
456:               rBuff.Bottom = rBuff.Bottom - 8
457:               If ResY = 600 Then BackBuffer.BltFast ResX - 25, 480 + (I * 16), DirectDraw_NavBar, rBuff, DDBLTFAST_SRCCOLORKEY Or DDBLTFAST_WAIT
458:           End If
459:
460:           rBuff.Top = 4 * 30
461:           rBuff.Bottom = rBuff.Top + 30
462:           rBuff.Left = 224
463:           rBuff.Right = 24 + rBuff.Left
464:           If Players(MeNum).FlagWho > 0 Then
465:               BackBuffer.BltFast ResX - 27, 165, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
466:           End If
467:           If NavMenu = 1 Then
468:               rBuff.Top = 0 * 30
469:               rBuff.Bottom = rBuff.Top + 30
470:               BackBuffer.BltFast ResX - 27, 5, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
471:           ElseIf NavMenu = 3 Then
472:               rBuff.Top = 2 * 30
473:               rBuff.Bottom = rBuff.Top + 30
474:               BackBuffer.BltFast ResX - 27, 65, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
475:           ElseIf NavMenu = 4 Then
476:               rBuff.Top = 3 * 30
477:               rBuff.Bottom = rBuff.Top + 30
478:               BackBuffer.BltFast ResX - 27, 95, DirectDraw_NavBar, rBuff, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY
479:           End If
    
    Exit Sub
    
ErrorTrap:
    RaiseCritical "Interface failed. (Line #" & Erl & ")"
    Stopping = True
End Sub

Public Sub writeini(Parent, child, context, file)
    Dim lpAppName As String, lpFileName As String, lpKeyName As String, lpString As String
    Dim U As Long
    lpAppName = Parent
    lpKeyName = child
    lpString = context
    lpFileName = file
    U = WritePrivateProfileString(lpAppName, lpKeyName, lpString, lpFileName)
    If U = 0 Then
        RaiseError "Could not save settings."
    End If
End Sub

Public Function readini(Parent, child, file)
    Dim X As Long, ReturnString As String, I As Integer
    Dim temp As String * 255
    Dim lpAppName As String, lpKeyName As String, lpDefault As String, lpFileName As String
    lpAppName = Parent
    lpKeyName = child
    lpDefault = file
    lpFileName = file
    X = GetPrivateProfileString(lpAppName, lpKeyName, lpDefault, temp, Len(temp), lpFileName)
    For I = 1 To Len(temp)
        If Asc(Mid$(temp, I, 1)) <> 0 Then
            ReturnString = ReturnString & Mid$(temp, I, 1)
        Else
            Exit For
        End If
    Next
    If X <> 0 And ReturnString <> file Then
        readini = ReturnString
    Else
        readini = vbNullString
    End If
End Function

Public Function AppPath(Optional NoSlash As Boolean = False)
    Dim X As String
    X = App.Path
    If DevEnv Then X = X & "\..\current"
    If Not NoSlash Then If Right$(X, 1) <> "\" Then X = X + "\"
    AppPath = X
End Function

Public Function DevEnv() As Boolean
    On Error GoTo teherror
    Debug.Print 1 / 0
    DevEnv = False
    Exit Function
teherror:
    DevEnv = True
End Function

Public Function Encode(Sin As String) As Long
    Dim X As Double
    Dim Hash As Double
    Dim CheckDigit As Double
    If Len(Sin) < 4 Then
        Encode = -1
        Exit Function
    End If
    Encode = Asc(Left$(Sin, 1))
    For X = 2 To Len(Sin)
        If X Mod 3 = 0 Then
            Hash = (1 / Asc(Mid$(Sin, X, 1)))
        Else
            Hash = Asc(Mid$(Sin, X, 1))
        End If
        Encode = Encode * Hash
    Next X
    While Encode > 214748364
        Encode = Encode / 10
    Wend
    Encode = Int(Encode)
    X = 10
    CheckDigit = 0
    Do
        CheckDigit = CheckDigit + ((Encode Mod X) \ (X \ 10))
        X = X * 10
    Loop Until X > Encode
    CheckDigit = CheckDigit Mod 10
    Encode = (Encode * 10) + CheckDigit
End Function

Public Function GetProcessPrivateBytes() As Long

    ' returns -1 if function fails, number o
    '     f bytes used by current process otherwis
    '     e
    Dim lpMem& ' memory pointer
    Dim lPrivateBytes& 'total bytes used so far
    Dim ret& ' API return code
    Dim si As SYSTEM_INFO ' used To find out address range used my this process
    Dim mbi As MEMORY_BASIC_INFORMATION ' memory block status
    Dim lLenMbi&
    GetProcessPrivateBytes = -1 ' default To failure
    lLenMbi = Len(mbi) ' number of bytes In MEMORY_BASIC_INFORMATION structure
    Call GetSystemInfo(si) ' find the address range used by this process
    lpMem = si.lpMinimumApplicationAddress


    While lpMem < si.lpMaximumApplicationAddress
        mbi.RegionSize = 0
        ret = VirtualQuery(lpMem, mbi, lLenMbi)


        If ret = lLenMbi Then

            If ((mbi.lType = MEM_PRIVATE) And (mbi.State = MEM_COMMIT)) Then ' this block is In use by this process
                lPrivateBytes = lPrivateBytes + mbi.RegionSize
            End If

            On Error GoTo Finished
            ' the only time an error can occur on th
            '     e next line is an overflow
            ' error. We have got as far as we can an
            '     yway so we must have finished.
            ' advance lpMem to the next address rang
            '     e.
            lpMem = mbi.BaseAddress + mbi.RegionSize
            On Error GoTo 0 ' switch off error trapping
        Else ' Function failed
            Exit Function ' abort now
        End If

    Wend

Finished:
    GetProcessPrivateBytes = lPrivateBytes
End Function

Public Function Scramble(strString As String) As String
    Dim I As Integer, even As String, odd As String
    For I% = 1 To Len(strString$)
        If I% Mod 2 = 0 Then
            even$ = even$ & Mid$(strString$, I%, 1)
        Else
            odd$ = odd$ & Mid$(strString$, I%, 1)
        End If
    Next I
    Scramble$ = even$ & odd$
End Function

Public Function Unscramble(strString As String) As String
    Dim X As Integer, evenint As Integer, oddint As Integer
    Dim even As String, odd As String, fin As String
    X% = Len(strString$)
    X% = Int(Len(strString$) / 2)
    even$ = Mid$(strString$, 1, X%)
    odd$ = Mid$(strString$, X% + 1)
    For X = 1 To Len(strString$)
        If X% Mod 2 = 0 Then
            evenint% = evenint% + 1
            fin$ = fin$ & Mid$(even$, evenint%, 1)
        Else
            oddint% = oddint% + 1
            fin$ = fin$ & Mid$(odd$, oddint%, 1)
        End If
    Next X%
    Unscramble$ = fin$
End Function

Public Sub Pause2(interval As Long)
    Dim current As Long
    current = NewGTC
    Do While NewGTC - current < interval
        DoEvents
    Loop
End Sub

Public Function AvailableRAMMemory() As Long
    On Error Resume Next
    Dim AmountInBytes As Double
    GlobalMemoryStatus pUdtMemStatus
    AmountInBytes = pUdtMemStatus.dwAvailPhys
    
    AvailableRAMMemory = BtoKB(AmountInBytes)
End Function

Public Function TotalRAM() As Long
    On Error Resume Next
    Dim AmountInBytes As Double
    GlobalMemoryStatus pUdtMemStatus
    AmountInBytes = pUdtMemStatus.dwTotalPhys
    
    TotalRAM = BtoKB(AmountInBytes)
End Function

Public Function AvailableSWAP() As Long
    On Error Resume Next
    Dim AmountInBytes As Double
    GlobalMemoryStatus pUdtMemStatus
    AmountInBytes = pUdtMemStatus.dwAvailPageFile
    
    AvailableSWAP = BtoKB(AmountInBytes)
End Function

Public Function SWAPSize() As Long
    On Error Resume Next
    Dim AmountInBytes As Double
    GlobalMemoryStatus pUdtMemStatus
    AmountInBytes = pUdtMemStatus.dwTotalPageFile
    
    SWAPSize = BtoKB(AmountInBytes)
End Function

Public Function BtoKB(b As Double) As Double
    On Error Resume Next
    Dim AmountInBytes As Double
    AmountInBytes = (b / 1024)
    
    BtoKB = Format(AmountInBytes, "###,###,##0.00")
End Function

Public Sub DeleteFile(Path As String)
    On Error Resume Next
    Kill Path
End Sub

Public Function FileExists(Path As String)
    On Error GoTo errors
    Dim j As Long
    j = FileLen(Path)
    If j > 0 Then FileExists = True
    Exit Function
errors:
End Function

Private Function Validate(ByRef User As String, ByRef Password As String) As Boolean
    If StrComp(User, "debug", vbTextCompare) = 0 Then
        If StrComp(CalculateMD5(LCase$(Password)), CalculateMD5(LCase$(ProjectName))) = 0 Then
            DebugConsole = 1
            Validate = True
        End If
    End If
End Function

Public Function ProcessCommand(ByVal Command As String)
    Dim cmd() As String
    cmd = Split(Command, " ")
    If DebugConsole <> 1 Then
        Select Case LCase$(cmd(0))
            Case "login"
                If iLAttempts > 0 And Validate(cmd(1), cmd(2)) Then
                    frmDebug.AddText "Login accepted. Debug commands enabled."
                Else
                    iLAttempts = iLAttempts - 1
                    If iLAttempts > 0 Then
                        frmDebug.AddText "Login invalid. " & iLAttempts & " attempts remaining."
                    Else
                        frmDebug.AddText "Access denied."
                    End If
                End If
            Case Else
                frmDebug.AddText "Invalid command."
        End Select
    Else
        Select Case LCase$(cmd(0))
            Case "clear"
                frmDebug.txtDebug = vbNullString
            Case "cls"
                frmDebug.txtDebug = vbNullString
            Case "ver"
                frmDebug.AddText ProjectName & " v" & App.Major & "." & Format$(App.Minor, "00") & "." & Format$(App.Revision, "0000")
            Case "version"
                frmDebug.AddText ProjectName & " v" & App.Major & "." & Format$(App.Minor, "00") & "." & Format$(App.Revision, "0000")
            Case "windowed"
                If Not Playing Then
                    If Windowed Then
                        Windowed = False
                        frmDebug.AddText "Windowed mode DISABLED."
                    Else
                        Windowed = True
                        frmDebug.AddText "Windowed mode ENABLED."
                    End If
                End If
            Case "lowmem"
                If Not Playing Then
                    If LowMem Then
                        LowMem = False
                        frmDebug.AddText "LowMem is now FALSE."
                        SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "LowMemory", 0
                    Else
                        LowMem = False
                        frmDebug.AddText "LowMem is now TRUE."
                        SaveSettingLong HKEY_CURRENT_USER, "SOFTWARE\" & ProjectName & "\Game", "LowMemory", 1
                    End If
                End If
            Case Else
                frmDebug.AddText "Invalid command."
        End Select
    End If
End Function

Public Function CalcTime(Time As Long)
    If Time < 1 Then CalcTime = "<unknown>": Exit Function
    Dim Days As Long
    Dim Hours As Long
    Dim Minutes As Long
    Dim Seconds As Long
    Seconds = Time / 1000
    If Seconds > 59 Then
        Minutes = Seconds / 60
        Seconds = Seconds Mod 60
        If Minutes > 59 Then
            Hours = Minutes / 60
            Minutes = Minutes Mod 60
            If Hours > 23 Then
                Days = Hours / 24
                Hours = Hours Mod 24
            End If
        End If
    End If
    CalcTime = Days & " days, " & Hours & " hours, " & Minutes & " minutes, " & Seconds & " seconds"
End Function
