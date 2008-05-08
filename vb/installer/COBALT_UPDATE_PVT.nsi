  !include "MUI.nsh"
  SetCompressor /SOLID LZMA
  ;Name and file
  Name "Cobalt Update"
  OutFile "..\pub\cobalt_private_update.exe"
  ;Default installation folder
  InstallDir "$PROGRAMFILES\Cobalt"
  ;Get installation folder from registry if available
  InstallDirRegKey HKCU "Software\Cobalt" ""
  !define MUI_ABORTWARNING
  !define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\box-install.ico"
  !define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\box-uninstall.ico"
  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH
  !insertmacro MUI_LANGUAGE "English"
  ChangeUI all "${NSISDIR}\Contrib\UIs\sdbarker_tiny.exe"
  SetFont "Tahoma" 8
  XPStyle on
  CRCCheck on
  WindowIcon on
  # BGGradient C2D6F2 5296F7
  BrandingText "Cobalt Gaming Systems"
  # InstType /NOCUSTOM
  # InstallColors 5296F7 C2D6F2
  InstallColors C10000 800000
  InstProgressFlags smooth colored
  AutoCloseWindow false
  ShowInstDetails nevershow

Section "Cobalt" SecCobalt
  SectionIn RO
;  SetDetailsPrint textonly
;  DetailPrint "Closing running ARC-related programs..."
;  KillProcDLL::KillProc "openaserver.exe"
;  KillProcDLL::KillProc "game.exe"
  SetOutPath "$SYSDIR"
  File "..\Includes\cswsk32.ocx"
  RegDLL "$SYSDIR\cswsk32.ocx"
  CreateDirectory "$INSTDIR\"
  SetOutPath "$INSTDIR\"
  File "..\current_pvt\game.exe"
  File "..\current_pvt\game.pdb"
  File "..\current_pvt\openaserver.exe"
  File "..\current_pvt\openaserver.pdb"
  Quit
SectionEnd