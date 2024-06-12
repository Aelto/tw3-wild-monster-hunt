call variables.cmd

rmdir "%modpath%\release" /s /q
mkdir "%modpath%\release"

:: here we compile the cahirc scripts, then construct the final mods by combining
:: the vanilla edits of the mods and their local scripts:
call compile

set modname=modWildMonsterHunt
XCOPY "%modpath%\src\%modname%\" "%modpath%\release\mods\%modname%\" /e /s /y
rmdir "%modpath%\release\mods\%modname%\content\scripts\wmh\" /s /q
XCOPY "%modpath%\dist\%modname%\" "%modpath%\release\mods\%modname%\" /e /s /y

:: move the strings
set modname=modWildMonsterHunt
XCOPY "%modpath%\strings" "%modpath%\release\mods\%modName%\content\" /e /s /y

:: copy the sharedutils dependencies
set modname=mod_sharedutils_helpers
XCOPY "%modpath%\tw3-shared-utils\%modname%\" "%modpath%\release\mods\%modname%\" /e /s /y

:: don't need a menu at the moment
@REM mkdir "%modpath%\release\bin\config\r4game\user_config_matrix\pc\"
@REM copy "%modpath%\mod-menu.xml" "%modpath%\release\bin\config\r4game\user_config_matrix\pc\%modname%.xml" /y
