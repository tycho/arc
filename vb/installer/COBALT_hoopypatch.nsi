  SetCompressor /SOLID LZMA
  !include "MUI.nsh"
  ;Name and file
  Name "Hoopy Graphics Patch"
  OutFile "..\pub\hoopypatch_setup.exe"
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
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

  !insertmacro MUI_LANGUAGE "English"
  ChangeUI all "${NSISDIR}\Contrib\UIs\sdbarker_tiny.exe"
  SetFont "Tahoma" 8
  Caption "Hoopy Entertainment Graphics Patch"
  XPStyle on
  CRCCheck on
  WindowIcon on
  # BGGradient C2D6F2 5296F7
  BrandingText "Cobalt Gaming Systems"
  # InstType /NOCUSTOM
  # InstallColors 5296F7 C2D6F2
  InstallColors 0000C1 000080
  InstProgressFlags smooth colored
  AutoCloseWindow false
  ShowInstDetails nevershow
  ShowUninstDetails nevershow

Section "Hoopy Theme" SecCobalt
  SectionIn RO
  SetOverWrite ifnewer
  CreateDirectory "$INSTDIR\graphics.patch\"
  SetOutPath "$INSTDIR\graphics.patch\"
  File "..\tunapack\Farplane.bmp"
  File "..\tunapack\Tuna.bmp"
  CreateDirectory "$INSTDIR\sound.patch\"
  SetOutPath "$INSTDIR\sound.patch\"
  CreateDirectory "$INSTDIR\"
  File "..\soundpack\hoopy_circa_1997-1998\bounce.wav"
  File "..\soundpack\hoopy_circa_1997-1998\bounshot.wav"
  File "..\soundpack\hoopy_circa_1997-1998\dropflag.wav"
  File "..\soundpack\hoopy_circa_1997-1998\flagcap.wav"
  File "..\soundpack\hoopy_circa_1997-1998\gotpup.wav"
  File "..\soundpack\hoopy_circa_1997-1998\got_boun.wav"
  File "..\soundpack\hoopy_circa_1997-1998\got_miss.wav"
  File "..\soundpack\hoopy_circa_1997-1998\got_mort.wav"
  File "..\soundpack\hoopy_circa_1997-1998\laser.wav"
  File "..\soundpack\hoopy_circa_1997-1998\lasrhits.wav"
  File "..\soundpack\hoopy_circa_1997-1998\lasrhitw.wav"
  File "..\soundpack\hoopy_circa_1997-1998\missile.wav"
  File "..\soundpack\hoopy_circa_1997-1998\mortlnch.wav"
  File "..\soundpack\hoopy_circa_1997-1998\rockhits.wav"
  File "..\soundpack\hoopy_circa_1997-1998\rockhitw.wav"
  File "..\soundpack\hoopy_circa_1997-1998\shipexpl.wav"
  File "..\soundpack\hoopy_circa_1997-1998\spawn.wav"
SectionEnd