{
  Windows Version Information
  
  Plugin DLL for NSIS 2 (Nullsoft Scriptable Install System Version version 2)
  Copyright (C) 2004 Denis (DNG) Gorbunov (software-development@gorbunov.ru)

  Uses with delphi unit nsis.pas by Bernhard Mayer

  Tested in Delphi 7.0

Created 3 sep 2004, version 0.1 -
	First public release

Modified 25 sep 2004, version 0.2 - 	
	Implementation IntToStr-function
	because IntToStr-function from Delphi-standard SysUtils-unit to cause difficulties 
	(SysUtils-unit required to many other Delpi-units 
	and size of DLL-binary enlarge + 24 kilobytes, if DLL-binary uncompressed).
	3 steps (implementation IntToStr,
	using special compact runtime
	and using UPX exe-packer) lead to (or bring to?) 6 kilobytes DLL-binary
	(packed dll version 0.1 with standard runtime was 23 kilobytes)

Usage:

  1. Build "version.dll" from this source
  2.
    Variant A:
       Copy "version.dll" to "Plugins" sub-directory of your NSIS installation
       (for example "C:\Program Files\NSIS2\Plugins\")

    Variant B:
       If your NSIS script file is "C:\MyDistribs\MyAppDistrib\myapp.nsi" then
       copy "version.dll" to "Plugins" sub-directory
       (for example "C:\MyDistribs\MyAppDirtrib\Plugins\")
       and append string
       !addplugindir "plugins"
       to your NSIS script file.

  3. In your NSIS script file write (detect Windows XP example):

  ; variable declaration
  var Result
  ...
  ; call function from this plugin dll
  Version::IsWindowsXP
  ; get function result
  Pop $Result
  ; check result - it is "1" (if Windows XP) or "0" (if not Windows XP)
  StrCmp $Result "1" Label_ItIsWindowsXP Label_ItIsNotWindowsXP
  ...
  Label_ItIsWindowsXP:
  ; if Windows XP detected then
  ...
  Label_ItIsNotWindowsXP:
  ; if Windows XP not detected then
  ...

  4. or instead of "Version::IsWindowsXP" write (detect other Windows OS):
  Version::IsWindows31,
  Version::IsWindows95,
  Version::IsWindows98,
  Version::IsWindowsME,
  Version::IsWindowsNT351,
  Version::IsWindowsNT40,
  Version::IsWindows2000,
  Version::IsWindowsXP,
  or Version::IsWindows2003

  5. or instead of "Version::IsWindowsXP" write (detect Windows OS platform classes):
  Version::IsWindowsPlatformNT
  or Version::IsWindowsPlatform9x

  ; Platform "NT" is Windows NT 3.51, Windows NT 4.0, Windows 2000,
  ; Windows XP, or Windows 2003

  ; Platform "9x" is Windows 95, Windows 98, Windows ME

  6. or instead of "Version::IsWindowsXP" write (detect "good" Windows OS):
  Version::IsWindows98orLater

  ; "Good" Windows OS is Windows 98, Windows ME, Windows 2000, Windows XP, Windows 2003
  ; No "good" Windows OS is Windows 3.1, Windows NT 3.51, Windows NT 4.0, Windows 95

  7.  In your NSIS script file write:
  ; variable declaration
  var MajorVersion
  var MinorVersion
  var BuildNumber
  var PlatformID
  var CSDVersion  
  ...
  ; call function from this plugin dll
  Version::GetWindowsVersion
  ; get function result
  Pop $MajorVersion
  Pop $MinorVersion
  Pop $BuildNumber
  Pop $PlatformID
  Pop $CSDVersion
  ; show result
  MessageBox MB_OK "$PlatformID-platform, version $MajorVersion.$MinorVersion, build $BuildNumber, $CSDVersion"

  ; Platform ID is "NT", "9x", "Win32s" or "Unknown"
  ; Platform "NT" is Windows NT 3.51, Windows NT 4.0, Windows 2000,
  ; Windows XP, Windows 2003
  ; Platform "9x" is Windows 95, Windows 98, Windows ME
  ; Platform "Win32s" is Win32s on Windows 3.1

  ; CSD Version is name of latest Service Pack installed on the OS.
  ; If no Service Pack has been installed, the string is empty.
  ; For Windows 95, Windows 98, and Windows ME CSD Version is
  ; additional version information. For example,
  ; " C" indicates Windows 95 OSR2 and " A" indicates Windows 98 Second Edition.

  ; i.e
  ; for Windows XP Service Pack 1:
  ; Major Version is "5"
  ; Minor Version is "1"
  ; Build Number is
  ; Platform ID is "NT"
  ; Messager box show "NT-platform, version 5.1, build 2600, Service Pack 1"

  ; i.e  
  ; for Windows 98 Second Edition:
  ; Major Version is "4"
  ; Minor Version is "10"
  ; Build Number is "2222"
  ; Platform ID is "9x"
  ; Messager box show "9x-platform, version 4.10, build 2222, A"
}

{$DEBUGINFO OFF}

library Version;

uses
  nsis, Windows;

var
  VerInfo: TOSVersionInfo;

{ It is replacement IntToStr-function from Delphi-standard SysUtils-unit }
{ Because SysUtils-unit required too many other Delphi-units }
{ and enlarge size of this DLL +24 kilobytes }

function IntToStr(Value: Integer): String;
var
	CurVal: Integer;
	Res   : String;
        Digit : Byte;
	sDigit: Char;
begin
	Res   := '';

	CurVal:= Value;

	while CurVal <> 0 do
	begin
		Digit := CurVal mod 10;
		CurVal:= CurVal div 10;
		sDigit:= Char(Digit+Ord('0'));
		Res   := sDigit + Res;
	end;

	Result:= Res;
end;

procedure IsWindows95(const hwndParent: HWND; const string_size: integer; const variables: PChar; const stacktop: pointer); cdecl;
begin
  // set up global variables
  Init(hwndParent, string_size, variables, stacktop);

  if (VerInfo.dwPlatformId = VER_PLATFORM_WIN32_WINDOWS) and (VerInfo.dwMajorVersion = 4) and (VerInfo.dwMinorVersion = 0) then
    PushString('1')
  else
    PushString('0');
end;

procedure IsWindowsNT351(const hwndParent: HWND; const string_size: integer; const variables: PChar; const stacktop: pointer); cdecl;
begin
  // set up global variables
  Init(hwndParent, string_size, variables, stacktop);

  if (VerInfo.dwPlatformId = VER_PLATFORM_WIN32_NT) and (VerInfo.dwMajorVersion = 3) and (VerInfo.dwMinorVersion = 51) then
    PushString('1')
  else
    PushString('0');
end;

procedure IsWindowsNT40(const hwndParent: HWND; const string_size: integer; const variables: PChar; const stacktop: pointer); cdecl;
begin
  // set up global variables
  Init(hwndParent, string_size, variables, stacktop);

  if (VerInfo.dwPlatformId = VER_PLATFORM_WIN32_NT) and (VerInfo.dwMajorVersion = 4) and (VerInfo.dwMinorVersion = 0) then
    PushString('1')
  else
    PushString('0');
end;

procedure IsWindowsPlatformNT(const hwndParent: HWND; const string_size: integer; const variables: PChar; const stacktop: pointer); cdecl;
begin
  // set up global variables
  Init(hwndParent, string_size, variables, stacktop);

  if (VerInfo.dwPlatformId = VER_PLATFORM_WIN32_NT) then
    PushString('1')
  else
    PushString('0');
end;

procedure IsWindowsPlatform9x(const hwndParent: HWND; const string_size: integer; const variables: PChar; const stacktop: pointer); cdecl;
begin
  // set up global variables
  Init(hwndParent, string_size, variables, stacktop);

  if (VerInfo.dwPlatformId = VER_PLATFORM_WIN32_WINDOWS) then
    PushString('1')
  else
    PushString('0');
end;

procedure IsWindows98orLater(const hwndParent: HWND; const string_size: integer; const variables: PChar; const stacktop: pointer); cdecl;
begin
  // set up global variables
  Init(hwndParent, string_size, variables, stacktop);

  if ((VerInfo.dwMajorVersion = 4) and (VerInfo.dwMinorVersion >= 10)) or
     (VerInfo.dwMajorVersion >= 4) then
    PushString('1')
  else
    PushString('0');
end;

procedure IsWindows98(const hwndParent: HWND; const string_size: integer; const variables: PChar; const stacktop: pointer); cdecl;
begin
  // set up global variables
  Init(hwndParent, string_size, variables, stacktop);

  if (VerInfo.dwPlatformId = VER_PLATFORM_WIN32_WINDOWS) and (VerInfo.dwMajorVersion = 4) and (VerInfo.dwMinorVersion = 10) then
    PushString('1')
  else
    PushString('0');
end;

procedure IsWindows2000(const hwndParent: HWND; const string_size: integer; const variables: PChar; const stacktop: pointer); cdecl;
begin
  // set up global variables
  Init(hwndParent, string_size, variables, stacktop);

  if (VerInfo.dwPlatformId = VER_PLATFORM_WIN32_NT) and (VerInfo.dwMajorVersion = 5) and (VerInfo.dwMinorVersion = 0) then
    PushString('1')
  else
    PushString('0');
end;

procedure IsWindowsME(const hwndParent: HWND; const string_size: integer; const variables: PChar; const stacktop: pointer); cdecl;
begin
  // set up global variables
  Init(hwndParent, string_size, variables, stacktop);

  if (VerInfo.dwPlatformId = VER_PLATFORM_WIN32_WINDOWS) and (VerInfo.dwMajorVersion = 4) and (VerInfo.dwMinorVersion = 90) then
    PushString('1')
  else
    PushString('0');
end;

procedure IsWindowsXP(const hwndParent: HWND; const string_size: integer; const variables: PChar; const stacktop: pointer); cdecl;
begin
  // set up global variables
  Init(hwndParent, string_size, variables, stacktop);

  if (VerInfo.dwPlatformId = VER_PLATFORM_WIN32_NT) and (VerInfo.dwMajorVersion = 5) and (VerInfo.dwMinorVersion = 1) then
    PushString('1')
  else
    PushString('0');
end;

procedure IsWindows2003(const hwndParent: HWND; const string_size: integer; const variables: PChar; const stacktop: pointer); cdecl;
begin
  // set up global variables
  Init(hwndParent, string_size, variables, stacktop);

  if (VerInfo.dwPlatformId = VER_PLATFORM_WIN32_NT) and (VerInfo.dwMajorVersion = 5) and (VerInfo.dwMinorVersion = 2) then
    PushString('1')
  else
    PushString('0');
end;

procedure IsWindows31(const hwndParent: HWND; const string_size: integer; const variables: PChar; const stacktop: pointer); cdecl;
begin
  // set up global variables
  Init(hwndParent, string_size, variables, stacktop);

  if VerInfo.dwPlatformId = VER_PLATFORM_WIN32s then
    PushString('1')
  else
    PushString('0');
end;

procedure GetWindowsVersion(const hwndParent: HWND; const string_size: integer; const variables: PChar; const stacktop: pointer); cdecl;
begin
  // set up global variables
  Init(hwndParent, string_size, variables, stacktop);

  PushString(VerInfo.szCSDVersion);

  case VerInfo.dwPlatformId of
    VER_PLATFORM_WIN32s:
      PushString('Win32s');
    VER_PLATFORM_WIN32_WINDOWS:
      PushString('9x');
    VER_PLATFORM_WIN32_NT:
      PushString('NT');
    else
      PushString('Unknown');
  end;

  PushString(IntToStr(VerInfo.dwBuildNumber));
  PushString(IntToStr(VerInfo.dwMinorVersion));
  PushString(IntToStr(VerInfo.dwMajorVersion));

end;

exports
  GetWindowsVersion,
  IsWindows31,
  IsWindows95, IsWindows98, IsWindowsME,
  IsWindowsNT351, IsWindowsNT40,
  IsWindows2000, IsWindowsXP, IsWindows2003,
  IsWindowsPlatformNT, IsWindowsPlatform9x,
  IsWindows98orLater;

begin
  FillChar(VerInfo, SizeOf(VerInfo), 0);
  VerInfo.dwOSVersionInfoSize:= SizeOf(VerInfo);
  GetVersionEx(VerInfo);
  if VerInfo.dwPlatformId = VER_PLATFORM_WIN32_WINDOWS then
    VerInfo.dwBuildNumber:= VerInfo.dwBuildNumber and $FFFF;
end.
