@echo off

call variables.cmd
call release.bat

rmdir "%gamePath%\mods\%modName%" /s /q
XCOPY "%modPath%\release\mods" "%gamePath%\mods" /e /s /y

copy "%modPath%\mod-menu.xml" "%gamePath%\bin\config\r4game\user_config_matrix\pc\%modname%.xml" /y

if "%1"=="-dlc" (
  echo "copying DLC"
  rmdir "%gamePath%\dlc\dlc%modName%" /s /q
  xcopy "%modPath%\release\dlc" "%gamepath%\dlc" /e /s /y
)
