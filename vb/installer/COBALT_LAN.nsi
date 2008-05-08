  SetCompressor /SOLID LZMA
  !include "MUI.nsh"
  !addplugindir "plugins"

  VIAddVersionKey "ProductName" "OpenARC LAN"
  VIAddVersionKey "Comments" ""
  VIAddVersionKey "CompanyName" "Cobalt Gaming Systems"
  VIAddVersionKey "LegalTrademarks" ""
  VIAddVersionKey "LegalCopyright" "© 2005 Uplink Laboratories"
  VIAddVersionKey "FileDescription" ""
  VIAddVersionKey "FileVersion" "0.2.0.23"
  VIProductVersion "0.2.0.23"

  Name "OpenARC LAN v0.2"
  OutFile "..\pub\lan_setup.exe"
  ;Default installation folder
  InstallDir "$PROGRAMFILES\OpenARCLAN"
  ;Get installation folder from registry if available
  InstallDirRegKey HKCU "Software\OpenARCLAN" ""
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
  BrandingText "OpenARC LAN v0.2"
  # InstType /NOCUSTOM
  # InstallColors 5296F7 C2D6F2
  InstallColors 00C100 008000
  InstProgressFlags smooth colored
  AutoCloseWindow true
  ShowInstDetails nevershow
  ShowUninstDetails nevershow

Section "OpenARC LAN" SecOpenARC
  SectionIn RO
  CreateDirectory "$INSTDIR\"
  SetOutPath "$INSTDIR\"
  Delete "$INSTDIR\arc.exe"
  Delete "$INSTDIR\arc.pdb"
  Delete "$INSTDIR\server.exe"
  Delete "$INSTDIR\server.pdb"
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

  WriteRegStr HKCU "Software\OpenARCLAN" "" $INSTDIR
  RmDir "$SMPROGRAMS\Cobalt Gaming Systems"
  CreateDirectory "$SMPROGRAMS\OpenARC"
  Version::IsWindowsXP
  ; get result
   Pop $TempResult
  ; check result
  StrCmp $TempResult "1" ItIsWindowsXP IsIsNotWindowsXP
  ItIsWindowsXP:
  ;32-bit PNG icons!
  CreateShortCut "$SMPROGRAMS\OpenARC\OpenARC LAN Client.lnk" "$INSTDIR\arc.exe" "" "$INSTDIR\green_png.ico"
  CreateShortCut "$SMPROGRAMS\OpenARC\OpenARC LAN Server.lnk" "$INSTDIR\server.exe" "" "$INSTDIR\red_png.ico"
  Goto Go2
  IsIsNotWindowsXP:
  ;Crap 16-bit icons from hell.
  CreateShortCut "$SMPROGRAMS\OpenARC\OpenARC LAN Client.lnk" "$INSTDIR\arc.exe"
  CreateShortCut "$SMPROGRAMS\OpenARC\OpenARC LAN Server.lnk" "$INSTDIR\server.exe"
  Goto Go2
  Go2:

  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall_LAN.exe"
  CreateShortCut "$SMPROGRAMS\OpenARC\Uninstall OpenARC LAN.lnk" "$INSTDIR\uninstall.exe"

SectionEnd

Section "Maps" SecMaps
  SetOverWrite ifnewer
  CreateDirectory "$INSTDIR\maps"
  SetOutPath "$INSTDIR\maps"
  File "..\current\maps\*.map"
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
  LangString DESC_SecMaps ${LANG_ENGLISH} "The full 150+ map collection."
  LangString DESC_SecRuntimes ${LANG_ENGLISH} "Visual Basic 6.0 SP6 runtimes. (Required)"

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecOpenARC} $(DESC_SecOpenARC)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecMaps} $(DESC_SecMaps)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecRuntimes} $(DESC_SecRuntimes)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
;Uninstaller Section

Section "Uninstall"
  Delete "$SMPROGRAMS\OpenARC\*LAN*.lnk"
  Delete "$INSTDIR\Uninstall_LAN.exe"
  RMDir /r "$INSTDIR"
  DeleteRegKey HKCU "Software\OpenARCLAN"
SectionEnd
