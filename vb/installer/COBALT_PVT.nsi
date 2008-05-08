  !include FontReg.nsh
  !include FontName.nsh
  !define MUI_ICON "..\graphics\icons\red.ico"
  !define MUI_UNICON "..\graphics\icons\red.ico"
;  !define USECOBALT_R
  !include "MUI.nsh"
  SetCompressor LZMA
  ;Name and file
  Name "Cobalt"
  OutFile "..\pub\cobalt_internal_setup.exe"
  ;Default installation folder
  InstallDir "$PROGRAMFILES\Cobalt"
  ;Get installation folder from registry if available
  InstallDirRegKey HKCU "Software\Cobalt" ""
  !define MUI_ABORTWARNING

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

  !insertmacro MUI_LANGUAGE "English"
ShowInstDetails show 

Section "Cobalt" SecCobalt
  SectionIn RO
  CreateDirectory "$INSTDIR\maps"
  SetOutPath "$INSTDIR\maps"
  File "..\current\maps\cobalt_4c2k2.map"
  File "..\current\maps\cobalt_agn_stop.map"
  File "..\current\maps\cobalt_airport2.map"
  File "..\current\maps\cobalt_anticheatmib.map"
  File "..\current\maps\cobalt_anytown.map"
  File "..\current\maps\cobalt_apl98.map"
  File "..\current\maps\cobalt_apl99_1.map"
  File "..\current\maps\cobalt_apl_fortresswars.map"
  File "..\current\maps\cobalt_apl_go99.map"
  File "..\current\maps\cobalt_arcraces.map"
  File "..\current\maps\cobalt_area_51.map"
  File "..\current\maps\cobalt_asx_mini2.map"
  File "..\current\maps\cobalt_base_wars.map"
  File "..\current\maps\cobalt_basketball.map"
  File "..\current\maps\cobalt_battleground.map"
  File "..\current\maps\cobalt_battleground_flora.map"
  File "..\current\maps\cobalt_ba_dueling.map"
  File "..\current\maps\cobalt_beefinthemiddle.map"
  File "..\current\maps\cobalt_beefinthemiddle2.map"
  File "..\current\maps\cobalt_beefinthemiddle3.map"
  File "..\current\maps\cobalt_beefymiddle.map"
  File "..\current\maps\cobalt_beefymiddle2.map"
  File "..\current\maps\cobalt_bloody.map"
  File "..\current\maps\cobalt_bridgecombat.map"
  File "..\current\maps\cobalt_bridgeofdeath.map"
  File "..\current\maps\cobalt_bridgewar.map"
  File "..\current\maps\cobalt_bubblekombat.map"
  File "..\current\maps\cobalt_bubblekombat2.map"
  File "..\current\maps\cobalt_bunkerwarfare.map"
  File "..\current\maps\cobalt_buttons.map"
  File "..\current\maps\cobalt_cagerage.map"
  File "..\current\maps\cobalt_canadianbacon.map"
  File "..\current\maps\cobalt_canadianbeans.map"
  File "..\current\maps\cobalt_canthespam.map"
  File "..\current\maps\cobalt_canvsusa.map"
  File "..\current\maps\cobalt_castle.map"
  File "..\current\maps\cobalt_castles.map"
  File "..\current\maps\cobalt_castlesiege.map"
  File "..\current\maps\cobalt_castlewars.map"
  File "..\current\maps\cobalt_centerbridge.map"
  File "..\current\maps\cobalt_chaos.map"
  File "..\current\maps\cobalt_checkerboard.map"
  File "..\current\maps\cobalt_circleofwar.map"
  File "..\current\maps\cobalt_classic_map.map"
  File "..\current\maps\cobalt_colonystrike.map"
  File "..\current\maps\cobalt_colosseum.map"
  File "..\current\maps\cobalt_compound.map"
  File "..\current\maps\cobalt_corruptedneighborhood.map"
  File "..\current\maps\cobalt_crazywar.map"
  File "..\current\maps\cobalt_cyberhacker.map"
  File "..\current\maps\cobalt_deathomatic.map"
  File "..\current\maps\cobalt_dodgeball.map"
  File "..\current\maps\cobalt_dodgeball2.map"
  File "..\current\maps\cobalt_dueling.map"
  File "..\current\maps\cobalt_dueling2.map"
  File "..\current\maps\cobalt_fastwar.map"
  File "..\current\maps\cobalt_flagwar.map"
  File "..\current\maps\cobalt_flag_city.map"
  File "..\current\maps\cobalt_flip.map"
  File "..\current\maps\cobalt_flipworld.map"
  File "..\current\maps\cobalt_flow.map"
  File "..\current\maps\cobalt_fortress.map"
  File "..\current\maps\cobalt_fragruins.map"
  File "..\current\maps\cobalt_fragruins2.map"
  File "..\current\maps\cobalt_funzone.map"
  File "..\current\maps\cobalt_gauntlet25.map"
  File "..\current\maps\cobalt_glitch.map"
  File "..\current\maps\cobalt_goldenbattleground.map"
  File "..\current\maps\cobalt_goldenoldie.map"
  File "..\current\maps\cobalt_goldrush.map"
  File "..\current\maps\cobalt_halfomatic.map"
  File "..\current\maps\cobalt_jam.map"
  File "..\current\maps\cobalt_kashmir.map"
  File "..\current\maps\cobalt_laser_tag.map"
  File "..\current\maps\cobalt_lostisle.map"
  File "..\current\maps\cobalt_madwarse_v3.map"
  File "..\current\maps\cobalt_madwarse_v42.map"
  File "..\current\maps\cobalt_madwars_1.map"
  File "..\current\maps\cobalt_madwars_5.map"
  File "..\current\maps\cobalt_madwars_di.map"
  File "..\current\maps\cobalt_madwars_extreme.map"
  File "..\current\maps\cobalt_madwars_fusion.map"
  File "..\current\maps\cobalt_madwars_nn.map"
  File "..\current\maps\cobalt_mapoftenwv2.map"
  File "..\current\maps\cobalt_meatinthemiddle.map"
  File "..\current\maps\cobalt_meatwars.map"
  File "..\current\maps\cobalt_meat_jade.map"
  File "..\current\maps\cobalt_mibmeat.map"
  File "..\current\maps\cobalt_mibtraining.map"
  File "..\current\maps\cobalt_mibvsaliens.map"
  File "..\current\maps\cobalt_minibases.map"
  File "..\current\maps\cobalt_minibases14.map"
  File "..\current\maps\cobalt_miniduel.map"
  File "..\current\maps\cobalt_minifortress.map"
  File "..\current\maps\cobalt_mission.map"
  File "..\current\maps\cobalt_moon_wars.map"
  File "..\current\maps\cobalt_necromancy.map"
  File "..\current\maps\cobalt_newbieextermination.map"
  File "..\current\maps\cobalt_newyear2005.map"
  File "..\current\maps\cobalt_nibelheim.map"
  File "..\current\maps\cobalt_nolooseends.map"
  File "..\current\maps\cobalt_northsouth.map"
  File "..\current\maps\cobalt_otheroldie.map"
  File "..\current\maps\cobalt_overkill.map"
  File "..\current\maps\cobalt_o_land.map"
  File "..\current\maps\cobalt_pacman.map"
  File "..\current\maps\cobalt_paintball2.map"
  File "..\current\maps\cobalt_paintball3.map"
  File "..\current\maps\cobalt_paintballsuper.map"
  File "..\current\maps\cobalt_paintballx.map"
  File "..\current\maps\cobalt_paintballxl.map"
  File "..\current\maps\cobalt_perfect.map"
  File "..\current\maps\cobalt_pharout.map"
  File "..\current\maps\cobalt_platformwars.map"
  File "..\current\maps\cobalt_podtraining.map"
  File "..\current\maps\cobalt_pslide.map"
  File "..\current\maps\cobalt_pure_adrenaline.map"
  File "..\current\maps\cobalt_reboot.map"
  File "..\current\maps\cobalt_saratoga.map"
  File "..\current\maps\cobalt_sideswipe.map"
  File "..\current\maps\cobalt_smallwars10.map"
  File "..\current\maps\cobalt_smallwars12.map"
  File "..\current\maps\cobalt_smallwars14.map"
  File "..\current\maps\cobalt_sniper.map"
  File "..\current\maps\cobalt_sniperwars2.map"
  File "..\current\maps\cobalt_soccer.map"
  File "..\current\maps\cobalt_spaghetti.map"
  File "..\current\maps\cobalt_stakeout.map"
  File "..\current\maps\cobalt_star_trench.map"
  File "..\current\maps\cobalt_streetball3k.map"
  File "..\current\maps\cobalt_stretchwar.map"
  File "..\current\maps\cobalt_student_driver.map"
  File "..\current\maps\cobalt_teamfortress.map"
  File "..\current\maps\cobalt_teamwork.map"
  File "..\current\maps\cobalt_tugofwar.map"
  File "..\current\maps\cobalt_turnpike.map"
  File "..\current\maps\cobalt_ultimatewar.map"
  File "..\current\maps\cobalt_undead.map"
  File "..\current\maps\cobalt_warblow.map"
  File "..\current\maps\cobalt_warcastles.map"
  File "..\current\maps\cobalt_warfort.map"
  File "..\current\maps\cobalt_war_planets.map"
  File "..\current\maps\cobalt_waterslide.map"
  File "..\current\maps\cobalt_wolfden.map"
  File "..\current\maps\cobalt_ww1.map"
  File "..\current\maps\cobalt_ww3.5.map"
  File "..\current\maps\cobalt_ww3.map"
  File "..\current\maps\cobalt_ww4.map"
  File "..\current\maps\cobalt_zelda.map"
  File "..\current\maps\cobalt_zeldaquest.map"
  CreateDirectory "$INSTDIR\sound"
  SetOutPath "$INSTDIR\sound"
  File "..\current\sound\ARMORLO.WAV"
  File "..\current\sound\BASE.WAV"
  File "..\current\sound\BLUE.WAV"
  File "..\current\sound\bounce.wav"
  File "..\current\sound\BOUNHITS.WAV"
  File "..\current\sound\BOUNSHOT.WAV"
  File "..\current\sound\DROPFLAG.WAV"
  File "..\current\sound\engine.wav"
  File "..\current\sound\FLAGCAP.WAV"
  File "..\current\sound\FLAGRET.WAV"
  File "..\current\sound\flame.wav"
  File "..\current\sound\Gotpup.wav"
  File "..\current\sound\GOT_BOUN.WAV"
  File "..\current\sound\GOT_MISS.WAV"
  File "..\current\sound\GOT_MORT.WAV"
  File "..\current\sound\GREEN.WAV"
  File "..\current\sound\LASER.WAV"
  File "..\current\sound\LASRHITS.WAV"
  File "..\current\sound\LASRHITW.WAV"
  File "..\current\sound\LOSE.WAV"
  File "..\current\sound\mine.wav"
  File "..\current\sound\Missile.wav"
  File "..\current\sound\MORTHIT.WAV"
  File "..\current\sound\MORTLNCH.WAV"
  File "..\current\sound\NEUTRAL.WAV"
  File "..\current\sound\Rd_close.wav"
  File "..\current\sound\Rd_open.wav"
  File "..\current\sound\RED.WAV"
  File "..\current\sound\ROCKHITS.WAV"
  File "..\current\sound\ROCKHITW.WAV"
  File "..\current\sound\SHIPEXPL.WAV"
  File "..\current\sound\SPAWN.WAV"
  File "..\current\sound\SW_FLIP.WAV"
  File "..\current\sound\SW_SPEC.WAV"
  File "..\current\sound\SYSINIT.WAV"
  File "..\current\sound\TEAM.WAV"
  File "..\current\sound\TEAMWINS.WAV"
  File "..\current\sound\WARP.WAV"
  File "..\current\sound\WELCOME.WAV"
  File "..\current\sound\WIN.WAV"
  File "..\current\sound\YELLOW.WAV"
  CreateDirectory "$INSTDIR\"
  SetOutPath "$INSTDIR\"
  File "..\current\anims.dat"
  File "..\current_pvt\game.exe"
  File "..\current_pvt\game.pdb"
  File "..\current_pvt\aserver.exe"
  File "..\current_pvt\aserver.pdb"
  File "..\current\attribs.dat"
  File "..\current_pvt\cobalt.exe"
  File "..\current_pvt\cobalt.pdb"
  File "..\current\Cobalt.ini"
  File "..\current\extras.bmp"
  File "..\current\Farplane.bmp"
  File "..\current\rough.dat"
  File "..\current\Tiles.bmp"
  File "..\current\tuna.bmp"
  File "..\current\ZLIB.DLL"
  File "..\contrib\ulupdate\plug_update.dll"
  RegDLL "$INSTDIR\plug_update.dll"

  ;Store installation folder
  WriteRegStr HKCU "Software\Cobalt" "" $INSTDIR

  RmDir "$SMPROGRAMS\Cobalt Gaming Systems"
  CreateDirectory "$SMPROGRAMS\Cobalt"
  CreateShortCut "$SMPROGRAMS\Cobalt\Cobalt.lnk" "$INSTDIR\cobalt.exe"
  CreateDirectory "$SMPROGRAMS\Cobalt\Games"
  CreateDirectory "$SMPROGRAMS\Cobalt\Games\ARC\"
  CreateShortCut "$SMPROGRAMS\Cobalt\Games\ARC\ARC.lnk" "$INSTDIR\game.exe"
  CreateShortCut "$SMPROGRAMS\Cobalt\Games\ARC\ARC Server.lnk" "$INSTDIR\aserver.exe"

SectionEnd

Section "Cobalt Runtimes" SecRUNTIMES
  SectionIn RO
  SetOutPath "$SYSDIR"
  SetOverwrite try
  File ..\Includes\msvbvm60.dll
  RegDLL $SYSDIR\msvbvm60.dll
  File ..\Includes\cswsk32.ocx
  RegDLL $SYSDIR\cswsk32.ocx
  File ..\Includes\wbocx.ocx
  RegDLL $SYSDIR\wbocx.ocx
  File ..\Includes\comdlg32.ocx
  RegDLL $SYSDIR\comdlg32.ocx
  File ..\Includes\comctl32.ocx
  RegDLL $SYSDIR\comctl32.ocx
  File ..\Includes\mscomctl.ocx
  RegDLL $SYSDIR\mscomctl.ocx
  File ..\Includes\GroupBox.ocx
  RegDLL $SYSDIR\GroupBox.ocx
  File ..\Includes\comct232.ocx
  RegDLL $SYSDIR\comct232.ocx
  File ..\Includes\tabctl32.ocx
  RegDLL $SYSDIR\tabctl32.ocx
  File ..\Includes\msinet.ocx
  RegDLL $SYSDIR\msinet.ocx
  File ..\Includes\mswinsck.ocx
  RegDLL $SYSDIR\mswinsck.ocx
  File ..\Includes\stdole2.tlb
  SetOutPath "$FONTS"
  StrCpy $FONT_DIR $FONTS
  !insertmacro InstallTTFFont 'MASALBOL.TTF'
  !insertmacro InstallTTFFont 'MASALREG.TTF'
  !insertmacro InstallTTFFont 'MASONBOL.TTF'
  !insertmacro InstallTTFFont 'MASONREG.TTF'
  SendMessage ${HWND_BROADCAST} ${WM_FONTCHANGE} 0 0 /TIMEOUT=5000
SectionEnd