# Microsoft Developer Studio Project File - Name="ARC" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Application" 0x0101

CFG=ARC - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "ARC.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "ARC.mak" CFG="ARC - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "ARC - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "ARC - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
MTL=midl.exe
RSC=rc.exe

!IF  "$(CFG)" == "ARC - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "..\..\bin"
# PROP Intermediate_Dir "..\..\obj\Release\ARC"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /YX /FD /c
# ADD CPP /nologo /MT /W3 /GR /GX /O2 /I "." /I "..\..\contrib\unrar" /I "..\..\contrib\SDL\include" /I "..\..\contrib\SDL_image" /I "..\..\contrib\SDL_mixer" /I "..\..\contrib\CrissCross\source" /I "..\..\contrib\zlib" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /Yu"universal_include.h" /FD /c
# ADD BASE MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x409 /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /machine:I386
# ADD LINK32 msvcprt.lib /nologo /subsystem:windows /machine:I386 /libpath:"../../contrib/bin/8.0/"
# SUBTRACT LINK32 /debug

!ELSEIF  "$(CFG)" == "ARC - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "..\..\bin"
# PROP Intermediate_Dir "..\..\obj\Debug\ARC"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /YX /FD /GZ /c
# ADD CPP /nologo /MTd /W3 /Gm /Gi- /vd1 /GR /GX /ZI /Od /I "." /I "..\..\contrib\unrar" /I "..\..\contrib\SDL\include" /I "..\..\contrib\SDL_image" /I "..\..\contrib\SDL_mixer" /I "..\..\contrib\CrissCross\source" /I "..\..\contrib\zlib" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /FR /Yu"universal_include.h" /FD /c
# ADD BASE MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x409 /d "_DEBUG"
# ADD RSC /l 0x409 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /debug /machine:I386 /pdbtype:sept
# ADD LINK32 /nologo /subsystem:windows /debug /machine:I386 /nodefaultlib:"libcmt" /libpath:"../../contrib/bin/8.0/"

!ENDIF 

# Begin Target

# Name "ARC - Win32 Release"
# Name "ARC - Win32 Debug"
# Begin Group "App"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\..\source\App\app.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\App\app.h
# End Source File
# Begin Source File

SOURCE=..\..\source\App\binary_stream_readers.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\App\binary_stream_readers.h
# End Source File
# Begin Source File

SOURCE=..\..\source\App\databuffer.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\App\databuffer.h
# End Source File
# Begin Source File

SOURCE=..\..\source\App\debug_utils.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\App\debug_utils.h
# End Source File
# Begin Source File

SOURCE=..\..\source\App\file_utils.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\App\file_utils.h
# End Source File
# Begin Source File

SOURCE=..\..\source\App\preferences.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\App\preferences.h
# End Source File
# Begin Source File

SOURCE=..\..\source\App\resource.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\App\resource.h
# End Source File
# Begin Source File

SOURCE=..\..\source\App\string_utils.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\App\string_utils.h
# End Source File
# Begin Source File

SOURCE=..\..\source\App\text_stream_readers.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\App\text_stream_readers.h
# End Source File
# End Group
# Begin Group "Game"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\..\source\Game\bounce.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Game\bounce.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Game\collide.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Game\collide.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Game\game.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Game\game.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Game\grenade.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Game\grenade.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Game\grenade_explosion.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Game\grenade_explosion.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Game\grenade_smoke.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Game\grenade_smoke.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Game\laser.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Game\laser.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Game\missile.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Game\missile.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Game\missile_smoke.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Game\missile_smoke.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Game\player.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Game\player.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Game\shrapnel.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Game\shrapnel.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Game\spark.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Game\spark.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Game\weapon.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Game\weapon.h
# End Source File
# End Group
# Begin Group "Graphics"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\..\source\Graphics\graphics.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Graphics\graphics.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Graphics\graphics_opengl.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Graphics\graphics_opengl.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Graphics\graphics_sdl.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Graphics\graphics_sdl.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Graphics\surface.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Graphics\surface.h
# End Source File
# End Group
# Begin Group "Interface"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\..\source\Interface\bouncing_window.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Interface\bouncing_window.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Interface\button.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Interface\button.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Interface\chat_overlay.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Interface\chat_overlay.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Interface\error_window.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Interface\error_window.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Interface\inputwidget.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Interface\inputwidget.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Interface\interface.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Interface\interface.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Interface\laser_zap.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Interface\laser_zap.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Interface\loading_window.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Interface\loading_window.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Interface\quit_window.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Interface\quit_window.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Interface\ship.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Interface\ship.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Interface\ship_explosion.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Interface\ship_explosion.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Interface\sidebar.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Interface\sidebar.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Interface\text.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Interface\text.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Interface\text_input.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Interface\text_input.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Interface\widget.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Interface\widget.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Interface\window.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Interface\window.h
# End Source File
# End Group
# Begin Group "Network"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\..\source\Network\connection.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Network\connection.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Network\net.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Network\net.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Network\net_crisscross.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Network\net_crisscross.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Network\net_raknet.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Network\net_raknet.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Network\packet.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Network\packet.h
# End Source File
# End Group
# Begin Group "Resources"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\..\source\Resources\green_bmp.ico
# End Source File
# Begin Source File

SOURCE=..\..\source\resources.rc

!IF  "$(CFG)" == "ARC - Win32 Release"

# PROP Ignore_Default_Tool 1

!ELSEIF  "$(CFG)" == "ARC - Win32 Debug"

!ENDIF 

# End Source File
# End Group
# Begin Group "Sound"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\..\source\Sound\soundsystem.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Sound\soundsystem.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Sound\soundsystem_openal.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Sound\soundsystem_openal.h
# End Source File
# Begin Source File

SOURCE=..\..\source\Sound\soundsystem_sdlmixer.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\Sound\soundsystem_sdlmixer.h
# End Source File
# End Group
# Begin Group "World"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\..\source\World\map.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\World\map.h
# End Source File
# End Group
# Begin Source File

SOURCE=..\..\source\arc.cpp
# End Source File
# Begin Source File

SOURCE=..\..\source\resource.h
# End Source File
# Begin Source File

SOURCE=..\..\source\universal_include.cpp
# ADD CPP /Yc"universal_include.h"
# End Source File
# Begin Source File

SOURCE=..\..\source\universal_include.h

!IF  "$(CFG)" == "ARC - Win32 Release"

# Begin Custom Build - Generating build number...
ProjDir=.
InputPath=..\..\source\universal_include.h

"build_number.h" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	$(ProjDir)\GenerateBuildNumber.exe $(ProjDir)\.

# End Custom Build

!ELSEIF  "$(CFG)" == "ARC - Win32 Debug"

# PROP Ignore_Default_Tool 1
# Begin Custom Build - Generating build number...
ProjDir=.
InputPath=..\..\source\universal_include.h

"build_number.h" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	$(ProjDir)\GenerateBuildNumber.exe $(ProjDir)\.

# End Custom Build

!ENDIF 

# End Source File
# End Target
# End Project