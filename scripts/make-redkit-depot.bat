@echo off



call variables.cmd

::
::
::
:: copy the dependencies we want
set depname=mod_sharedutils_helpers
XCOPY "%modpath%\tw3-shared-utils\%depname%\" "%modpath%\deps\mods\%depname%\" /e /s /y

set depname=mod_sharedutils_glossary
XCOPY "%modpath%\tw3-shared-utils\%depname%\" "%modpath%\deps\mods\%depname%\" /e /s /y

set depname=mod_sharedutils_dialogChoices
XCOPY "%modpath%\tw3-shared-utils\%depname%\" "%modpath%\deps\mods\%depname%\" /e /s /y

set depname=mod_sharedutils_damagemodifiers
XCOPY "%modpath%\tw3-shared-utils\%depname%\" "%modpath%\deps\mods\%depname%\" /e /s /y

set depname=mod_sharedutils_oneliners
XCOPY "%modpath%\tw3-shared-utils\%depname%\" "%modpath%\deps\mods\%depname%\" /e /s /y

:: copy the vanilla scripts into the scripts
XCOPY "%modpath%\deps\content\content0\scripts\" "%modpath%\deps\scripts\" /e /s /y

::
::
::
:: copy the local scripts of each deps into the scripts
set depname=mod_sharedutils_helpers
XCOPY "%modpath%\tw3-shared-utils\%depname%\content\scripts\local\" "%modpath%\deps\scripts\local\" /e /s /y

set depname=mod_sharedutils_glossary
XCOPY "%modpath%\tw3-shared-utils\%depname%\content\scripts\local\" "%modpath%\deps\scripts\local\" /e /s /y

set depname=mod_sharedutils_dialogChoices
XCOPY "%modpath%\tw3-shared-utils\%depname%\content\scripts\local\" "%modpath%\deps\scripts\local\" /e /s /y

set depname=mod_sharedutils_damagemodifiers
XCOPY "%modpath%\tw3-shared-utils\%depname%\content\scripts\local\" "%modpath%\deps\scripts\local\" /e /s /y

set depname=mod_sharedutils_oneliners
XCOPY "%modpath%\tw3-shared-utils\%depname%\content\scripts\local\" "%modpath%\deps\scripts\local\" /e /s /y

:: copy the generated scripts into the depot
XCOPY "%modpath%\deps\scripts\" "%redkitDepotScripts%\" /e /s /y