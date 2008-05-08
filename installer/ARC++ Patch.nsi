  SetCompressor /SOLID LZMA
  !include "MUI.nsh"
  !addplugindir "plugins"

  VIAddVersionKey "ProductName" "ARC++"
  VIAddVersionKey "Comments" ""
  VIAddVersionKey "CompanyName" "Uplink Laboratories"
  VIAddVersionKey "LegalTrademarks" ""
  VIAddVersionKey "LegalCopyright" "© 2007-2008 Uplink Laboratories"
  VIAddVersionKey "FileDescription" ""
  VIAddVersionKey "FileVersion" "0.4.2.0"
  VIProductVersion "0.4.2.0"

  Name "ARC++ Preview"
  OutFile "build\arc++_patch.exe"
  InstallDir "$PROGRAMFILES\ARC++"
  InstallDirRegKey HKCU "Software\ARC++" ""
  
  !define MUI_ABORTWARNING
  !define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\box-install.ico"
  !define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\box-uninstall.ico"
  !define MUI_COMPONENTSPAGE_SMALLDESC

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "nda.txt"
  !insertmacro MUI_PAGE_DIRECTORY
  ;!insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH


  !insertmacro MUI_LANGUAGE "English"
  SetFont "Tahoma" 8
  XPStyle on
  CRCCheck on
  WindowIcon on
  # BGGradient C2D6F2 5296F7
  # BrandingText "ARC++ PREVIEW"
  # InstType /NOCUSTOM
  # InstallColors 5296F7 C2D6F2
  InstallColors 00C100 008000
  InstProgressFlags smooth colored
  AutoCloseWindow true
  ShowInstDetails nevershow

Section "ARC++" SecARC
  SectionIn RO

  SetOutPath "$INSTDIR\"

  File "..\bin\ARC.exe"
  File "..\bin\ARC.pdb"
;  File "..\bin\*.dll"
;  File "..\bin\*.dat"
 
  CreateDirectory "$SMPROGRAMS\ARC++"
  CreateShortCut "$SMPROGRAMS\ARC++\ARC++ Client.lnk" "$INSTDIR\arc.exe"

SectionEnd
