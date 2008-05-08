  SetCompressor /SOLID LZMA
  !include "MUI.nsh"
  Name "OpenARC"
  OutFile "..\pub\openarc_setup.exe"
  InstallDir "$PROGRAMFILES\OpenARC"
  InstallDirRegKey HKCU "Software\Cobalt" ""
  !define MUI_ABORTWARNING
  !define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\box-install.ico"
  !define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\box-uninstall.ico"
  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "..\etc\gpl.txt"
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH
  
  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH

  !insertmacro MUI_LANGUAGE "English"
  SetFont "Tahoma" 8
  XPStyle on
  CRCCheck on
  WindowIcon on
  # BGGradient C2D6F2 5296F7
  BrandingText "OpenARC v0.2.0"
  # InstType /NOCUSTOM
  # InstallColors 5296F7 C2D6F2
  InstallColors 00C100 008000
  InstProgressFlags smooth colored
  AutoCloseWindow true
  ShowInstDetails nevershow
  ShowUninstDetails nevershow

  var TempResult

Section "OpenARC Core Files" SecOpenARC
  SectionIn RO
  CreateDirectory "$INSTDIR\"
  SetOutPath "$INSTDIR\"
  File "..\current\*.exe"
  File "..\current\*.dat"
  File "..\current\*.pdb"
  File "..\current\*.dll"
  File "..\graphics\icons\green_png.ico"
  File "..\graphics\icons\red_png.ico"
  CreateDirectory "$INSTDIR\sound.patch"
  CreateDirectory "$INSTDIR\graphics.patch"
  CreateDirectory "$INSTDIR\graphics"
  SetOutPath "$INSTDIR\graphics"
  File "..\current\graphics\*.bmp"
  CreateDirectory "$INSTDIR\sound"
  SetOutPath "$INSTDIR\sound"
  File "..\current\sound\*.WAV"

  WriteRegStr HKCU "Software\Cobalt" "" $INSTDIR
  RmDir "$SMPROGRAMS\Cobalt Gaming Systems"
  CreateDirectory "$SMPROGRAMS\OpenARC"
  CreateShortCut "$SMPROGRAMS\OpenARC\CFront.lnk" "$INSTDIR\cfront.exe"
  Delete "$DESKTOP\Cobalt.lnk"
  CreateShortCut "$DESKTOP\CFront.lnk" "$INSTDIR\cfront.exe"
  Version::IsWindowsXP
  ; get result
   Pop $TempResult
  ; check result
  StrCmp $TempResult "1" ItIsWindowsXP IsIsNotWindowsXP
  ItIsWindowsXP:
  ;32-bit PNG icons!
  CreateShortCut "$SMPROGRAMS\OpenARC\OpenARC Client.lnk" "$INSTDIR\arc.exe" "" "$INSTDIR\green_png.ico"
  CreateShortCut "$SMPROGRAMS\OpenARC\OpenARC Server.lnk" "$INSTDIR\server.exe" "" "$INSTDIR\red_png.ico"
  CreateShortCut "$DESKTOP\OpenARC Client.lnk" "$INSTDIR\arc.exe" "" "$INSTDIR\green_png.ico"
  CreateShortCut "$DESKTOP\OpenARC Server.lnk" "$INSTDIR\server.exe" "" "$INSTDIR\red_png.ico"
  Goto Go2
  IsIsNotWindowsXP:
  ;Crap 16-bit icons from hell.
  CreateShortCut "$SMPROGRAMS\OpenARC\OpenARC Client.lnk" "$INSTDIR\arc.exe"
  CreateShortCut "$SMPROGRAMS\OpenARC\OpenARC Server.lnk" "$INSTDIR\server.exe"
  CreateShortCut "$DESKTOP\OpenARC Client.lnk" "$INSTDIR\arc.exe"
  CreateShortCut "$DESKTOP\OpenARC Server.lnk" "$INSTDIR\server.exe"
  Goto Go2
  Go2:

  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  CreateShortCut "$SMPROGRAMS\OpenARC\Uninstall.lnk" "$INSTDIR\uninstall.exe"
SectionEnd

Section "sedit v2 (Map Editor)" SecMapEditor
  CreateDirectory "$INSTDIR\sedit"
  SetOutPath "$INSTDIR\sedit"
  SetOverWrite on
  File "..\tools\sedit\custom.dat"
  File "..\tools\sedit\Gfx.dll"
  File "..\tools\sedit\sedit.exe"
  File "..\tools\sedit\SEDIT_LICENSE"
  File "..\current\anims.dat"
  File "..\current\graphics\extras.bmp"
  File "..\current\graphics\Farplane.bmp"
  File "..\current\graphics\Tiles.bmp"
  File "..\current\graphics\tuna.bmp"
  CreateDirectory "$SMPROGRAMS\OpenARC"
  CreateShortCut "$SMPROGRAMS\OpenARC\OpenARC Map Editor (sedit).lnk" "$INSTDIR\sedit\sedit.exe"
SectionEnd

Section "Maps" SecMaps
  SetOverWrite ifnewer
  CreateDirectory "$INSTDIR\maps"
  SetOutPath "$INSTDIR\maps"
  File "..\current\maps\*.map"
SectionEnd

Section /O "Hoopy Patch" SecHoopy
  SetOverWrite ifnewer
  CreateDirectory "$INSTDIR\graphics.patch\"
  SetOutPath "$INSTDIR\graphics.patch\"
  File "..\tunapack\Farplane.bmp"
  File "..\tunapack\Tuna.bmp"
  CreateDirectory "$INSTDIR\sound.patch\"
  SetOutPath "$INSTDIR\sound.patch\"
  CreateDirectory "$INSTDIR\"
  File "..\soundpack\hoopy_circa_1997-1998\*.wav"SectionEnd

Section "OpenARC Runtimes" SecRuntimes
  SectionIn RO
  SetOutPath "$SYSDIR"
  SetOverwrite try
  File ..\contrib\ULupdate\plug_update.dll
  RegDLL $SYSDIR\plug_update.dll
  File ..\Includes\msvbvm60.dll
  RegDLL $SYSDIR\msvbvm60.dll
  File ..\Includes\cswsk32.ocx
  RegDLL $SYSDIR\cswsk32.ocx
  File ..\Includes\comdlg32.ocx
  RegDLL $SYSDIR\comdlg32.ocx
  File ..\Includes\mscomctl.ocx
  RegDLL $SYSDIR\mscomctl.ocx
  File ..\Includes\MSINET.OCX
  RegDLL $SYSDIR\MSINET.OCX
  File ..\Includes\mswinsck.ocx
  RegDLL $SYSDIR\mswinsck.ocx
  File ..\Includes\FlexUI.ocx
  RegDLL $SYSDIR\FlexUI.ocx
  File ..\Includes\RICHTX32.OCX
  RegDLL $SYSDIR\RICHTX32.OCX
  SetOverwrite ifnewer
  File ..\Includes\mfc42.dll
  File ..\Includes\msvcrt.dll
  File ..\Includes\stdole2.tlb
SectionEnd

  LangString DESC_SecOpenARC ${LANG_ENGLISH} "The OpenARC game files."
  LangString DESC_SecMaps ${LANG_ENGLISH} "A collection of 151 maps for OpenARC."
  LangString DESC_SecMapEditor ${LANG_ENGLISH} "The best map editor available."
  LangString DESC_SecHoopy ${LANG_ENGLISH} "Gives OpenARC the classic ARC Beta 45 in-game graphics, back from the HFront days."
  LangString DESC_SecRuntimes ${LANG_ENGLISH} "The OpenARC runtimes. (Required)"

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecOpenARC} $(DESC_SecOpenARC)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecMaps} $(DESC_SecMaps)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecMapEditor} $(DESC_SecMapEditor)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecHoopy} $(DESC_SecHoopy)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecRuntimes} $(DESC_SecRuntimes)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
;Uninstaller Section

Section "Uninstall"
  Delete  "$DESKTOP\OpenARC Client.lnk"
  Delete  "$DESKTOP\OpenARC Server.lnk"
  Delete "$SMPROGRAMS\OpenARC\*.lnk"
  RMDir /r "$SMPROGRAMS\OpenARC"
  Delete "$INSTDIR\Uninstall.exe"
  RMDir /r "$INSTDIR"
  DeleteRegKey HKCU "Software\Cobalt"
  DeleteRegKey HKCU "Software\OpenARC"
SectionEnd
