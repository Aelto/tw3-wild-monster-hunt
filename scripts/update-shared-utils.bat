git submodule update --remote

:: generate the release folder for the sharedutils
cd ../tw3-shared-utils/scripts
call release.bat
cd ../../