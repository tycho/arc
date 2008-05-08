@echo off
type etc\banner.txt
echo Cleaning files...
del /q current\*.exe
del /q current\*.pec2bac
del /q current\*.pdb
del /q current\*.OBJ
del /q current_pvt\*.exe
del /q current_pvt\*.pec2bac
del /q current_pvt\*.pdb
del /q current_pvt\*.OBJ
del /q /s *.vbw
del /q /s *.log
echo Clean!