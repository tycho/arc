  SetCompressor /SOLID LZMA
  !include "MUI.nsh"
  !addplugindir "plugins"

  VIAddVersionKey "ProductName" "OpenARC"
  VIAddVersionKey "Comments" ""
  VIAddVersionKey "CompanyName" "Cobalt Gaming Systems"
  VIAddVersionKey "LegalTrademarks" ""
  VIAddVersionKey "LegalCopyright" "© 2005 Uplink Laboratories"
  VIAddVersionKey "FileDescription" ""
  VIAddVersionKey "FileVersion" "0.2.0.17"
  VIProductVersion "0.2.0.17"

  Name "OpenARC v0.2"
  OutFile "..\pub\core_setup.exe"
  ;Default installation folder
  InstallDir "$PROGRAMFILES\OpenARC"
  ;Get installation folder from registry if available
  InstallDirRegKey HKCU "Software\Cobalt" ""
  !define MUI_ABORTWARNING
  !define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\box-install.ico"
  !define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\box-uninstall.ico"
  !define MUI_COMPONENTSPAGE_SMALLDESC

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

  var TempResult

  !insertmacro MUI_LANGUAGE "English"
  SetFont "Tahoma" 8
  XPStyle on
  CRCCheck on
  WindowIcon on
  # BGGradient C2D6F2 5296F7
  BrandingText "OpenARC v0.2"
  # InstType /NOCUSTOM
  # InstallColors 5296F7 C2D6F2
  InstallColors 00C100 008000
  InstProgressFlags smooth colored
  AutoCloseWindow true
  ShowInstDetails nevershow
  ShowUninstDetails nevershow

Section "OpenARC" SecOpenARC
  SectionIn RO
  CreateDirectory "$INSTDIR\"
  SetOutPath "$INSTDIR\"
  Delete "$INSTDIR\game.exe"
  Delete "$INSTDIR\game.pdb"
  Delete "$INSTDIR\cobalt.exe"
  Delete "$INSTDIR\cobalt.pdb"
  Delete "$INSTDIR\openaserver.exe"
  Delete "$INSTDIR\openaserver.pdb"
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

Section "Visual Basic 6.0 Runtimes" SecRUNTIMES
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
  File ..\Includes\comctl32.ocx
  RegDLL $SYSDIR\comctl32.ocx
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

  LangString DESC_SecOpenARC ${LANG_ENGLISH} "The OpenARC game files. (Required)"
  LangString DESC_SecRuntimes ${LANG_ENGLISH} "Visual Basic 6.0 SP6 runtimes. (Required)"

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecOpenARC} $(DESC_SecOpenARC)
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
