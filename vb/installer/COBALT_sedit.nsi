  SetCompressor /SOLID LZMA
  !include "MUI.nsh"
  ;Name and file
  Name "OpenARC Map Editor"
  OutFile "..\pub\mapeditor_setup.exe"
  ;Default installation folder
  InstallDir "$PROGRAMFILES\OpenARC"
  ;Get installation folder from registry if available
  InstallDirRegKey HKCU "Software\Cobalt" ""
  !define MUI_ABORTWARNING
  !define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\pixel-install.ico"
  !define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\pixel-uninstall.ico"
  !define MUI_COMPONENTSPAGE_SMALLDESC

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
  ShowUninstDetails nevershow

Section "sedit v2" secSedit
  SectionIn RO
  CreateDirectory "$INSTDIR"
  SetOutPath "$INSTDIR"
  File "..\tools\sedit\custom.dat"
  File "..\tools\sedit\Gfx.dll"
  File "..\tools\sedit\sedit.exe"
  File "..\tools\sedit\SEDIT_LICENSE"
  CreateShortCut "$SMPROGRAMS\OpenARC\OpenARC Map Editor.lnk" "$INSTDIR\sedit.exe"
SectionEnd