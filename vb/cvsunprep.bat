@echo off
echo #define PrivateBuild > .\private\buildtype.h
del .\src\Private\modEncKeys.bas
echo Creating modEncKeys...
cd private
regina.exe ppwizard.rex @_OPENARC.ppw enckeys.t
copy /Y modEncKeys.bas ..\src\Private\
cd ..\src\Common
copy pvt\private.cls clsEncryption.cls
cd ..\..
echo Done.