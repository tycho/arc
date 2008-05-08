@echo off
cmd /c distclean.bat
echo Compiling...
"C:\Program Files\Microsoft Visual Studio\VB98\VB6.EXE" /make "src\OpenARC - Release.vbg"
"C:\Program Files\Microsoft Visual Studio\VB98\VB6.EXE" /make "src\OpenARC - Debug.vbg"
"C:\Program Files\Microsoft Visual Studio\VB98\VB6.EXE" /make "src\DEV_DEBUG_CobaltClient.vbp"
"C:\Program Files\Microsoft Visual Studio\VB98\VB6.EXE" /make "src\CobaltClient.vbp"
cd installer
cmd /c makeinstall.bat