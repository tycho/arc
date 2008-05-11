@echo off
DEL /q /f /s /a *.pchi *.idb *.ilk *.obj *.ncb *.opt *.plg *.sbr *.bsc *.suo *.vcproj.*.user *.vbw *.exp *.aps
DEL /q /f /a source\memleak.txt bin\memleak.txt source\build_number.h bin\ARC.exe bin\ARC.pdb bin\ARC.lib bin\ARC.map bin\ARC.exp bin\UserAllocators.nlb bin\*.DP* contrib\crisscross\source\crisscross\build_number.h
IF EXIST obj DEL /s /q /f /a obj
IF EXIST obj RD /s /q obj
IF EXIST contrib\obj DEL /s /q /f /a contrib\obj
IF EXIST contrib\obj RD /s /q contrib\obj
IF EXIST contrib\CrissCross\bin DEL /s /q /f /a contrib\CrissCross\bin
IF EXIST contrib\CrissCross\bin RD /s /q contrib\CrissCross\bin
IF EXIST contrib\CrissCross\obj DEL /s /q /f /a contrib\CrissCross\obj
IF EXIST contrib\CrissCross\obj RD /s /q contrib\CrissCross\obj
IF EXIST source\VTune DEL /s /q /f /a source\VTune
IF EXIST source\VTune RD /s /q source\VTune
IF EXIST bin\crisscross_vs2005.vcproj DEL /s /q /f /a bin\crisscross_vs2005.vcproj
IF EXIST bin\crisscross_vs2003.vcproj DEL /s /q /f /a bin\crisscross_vs2003.vcproj
IF EXIST bin\crisscross_vs2005.vcproj RD /s /q bin\crisscross_vs2005.vcproj
IF EXIST bin\crisscross_vs2003.vcproj RD /s /q bin\crisscross_vs2003.vcproj
