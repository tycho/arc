@echo off
echo #define PublicBuild > .\private\buildtype.h
del .\src\Private\modEncKeys.bas
echo Creating modEncKeys...
cd private
regina.exe ppwizard.rex @_OPENARC.ppw enckeys.t
copy /Y modEncKeys.bas ..\src\Private\
cd ..\src\Common
copy pvt\end-user.cls clsEncryption.cls
cd ..\..
echo Done.