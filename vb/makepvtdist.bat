@echo off
cls
type etc\banner.txt
echo Cleaning files...
del /q current\*.exe
del /q current\*.pdb
del /q current\*.OBJ
del /q current_pvt\*.exe
del /q current_pvt\*.pdb
del /q current_pvt\*.OBJ
del /q pub\*.exe
del /q /s *.vbw
del /q /s *.log
echo Clean!
echo #define PrivateBuild > .\private\buildtype.h
del .\src\Private\modEncKeys.bas
echo Creating modEncKeys...
cd private
regina.exe ppwizard.rex @_OPENARC.ppw enckeys.t
copy /Y modEncKeys.bas ..\src\Private\
cd ..\src\Common
copy pvt\end-user.cls clsEncryption.cls
cd ..\..
echo Done.
del "pub\OpenARC Private Source.rar"
etc\rar a -m5 -r -s "pub\OpenARC Private Source.rar" contrib current current_pvt doc etc graphics includes installer private serverworkdir soundpack src tools tunapack *.bat