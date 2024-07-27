call variables.cmd

rmdir "%modpath%\release" /s /q
mkdir "%modpath%\release"

:: here we compile the cahirc scripts, then construct the final mods by combining
:: the vanilla edits of the mods and their local scripts:
call compile

set depname=modWildMonsterHunt
XCOPY "%modpath%\src\%depname%\" "%modpath%\release\mods\%depname%\" /e /s /y
rmdir "%modpath%\release\mods\%depname%\content\scripts\local\wmh\" /s /q
XCOPY "%modpath%\dist\%depname%\" "%modpath%\release\mods\%depname%\" /e /s /y

:: move the strings
set depname=modWildMonsterHunt
XCOPY "%modpath%\strings" "%modpath%\release\mods\%depname%\content\" /e /s /y

@REM :: copy the sharedutils dependencies
@REM set depname=mod_sharedutils_helpers
@REM XCOPY "%modpath%\tw3-shared-utils\%depname%\" "%modpath%\release\mods\%depname%\" /e /s /y

@REM set depname=mod_sharedutils_glossary
@REM XCOPY "%modpath%\tw3-shared-utils\%depname%\" "%modpath%\release\mods\%depname%\" /e /s /y

@REM set depname=mod_sharedutils_dialogChoices
@REM XCOPY "%modpath%\tw3-shared-utils\%depname%\" "%modpath%\release\mods\%depname%\" /e /s /y

@REM set depname=mod_sharedutils_damagemodifiers
@REM XCOPY "%modpath%\tw3-shared-utils\%depname%\" "%modpath%\release\mods\%depname%\" /e /s /y

@REM set depname=mod_sharedutils_oneliners
@REM XCOPY "%modpath%\tw3-shared-utils\%depname%\" "%modpath%\release\mods\%depname%\" /e /s /y

:: don't need a menu at the moment
@REM mkdir "%modpath%\release\bin\config\r4game\user_config_matrix\pc\"
@REM copy "%modpath%\mod-menu.xml" "%modpath%\release\bin\config\r4game\user_config_matrix\pc\%modname%.xml" /y
