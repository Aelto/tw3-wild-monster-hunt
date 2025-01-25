@echo off

:: copies the release into the redkit workspace

call variables.cmd
call release.bat

rmdir "%modPath%\redkit\wild_monster_hunt\workspace\scripts\local\wss" /s /q

echo Copying release into redkit workspace
XCOPY "%modPath%\release\mods\%modName%\content\scripts" "%modPath%\redkit\wild_monster_hunt\workspace\scripts\local\wss\" /e /s /y

if "%1"=="-game" (
XCOPY "%modPath%\redkit\wild_monster_hunt\workspace\scripts\local\wss" "%gamePath%\mods\modwild_monster_hunt\content\scripts\local\wss\" /e /s /y
XCOPY "%modPath%\redkit\wild_monster_hunt\workspace\scripts\local\wmhredkit" "%gamePath%\mods\modwild_monster_hunt\content\scripts\local\wmhredkit\" /e /s /y
)