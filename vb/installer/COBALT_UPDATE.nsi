  SetCompressor LZMA
  !include "MUI.nsh"
  Name "OpenARC Update"
  OutFile "..\pub\openarc_update.exe"
  InstallDir "$PROGRAMFILES\OpenARC"
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

Section "OpenARC" SecCobalt
  SectionIn RO
  CreateDirectory "$INSTDIR\"
  SetOutPath "$INSTDIR\"
  Delete "$INSTDIR\arc.pdb"
  Delete "$INSTDIR\aserver.pdb"
  Delete "$INSTDIR\cobalt.pdb"
  File "..\current\Cobalt.exe"
  File "..\current\game.exe"
  File "..\current\openaserver.exe"
SectionEnd