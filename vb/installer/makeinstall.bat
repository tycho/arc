@echo off
type ..\etc\banner.txt
"C:\Program Files\NSIS\makensis.exe" "COBALT_FULL.nsi"
"C:\Program Files\NSIS\makensis.exe" "COBALT_core.nsi"
"C:\Program Files\NSIS\makensis.exe" "COBALT_hoopypatch.nsi"
"C:\Program Files\NSIS\makensis.exe" "COBALT_maps.nsi"
"C:\Program Files\NSIS\makensis.exe" "COBALT_sedit.nsi"