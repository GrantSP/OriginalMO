echo "Compiling everything"
@echo off

set OLDDIR=%CD%

call stageconfig.bat

call "%VCDIR%\VC\vcvarsall.bat" x86
call "%QTDIR%\5.4\msvc2013_opengl\bin\qtenv2.bat" vsvars
rem stupid qtenv-script changes the current working directory...
cd /D %OLDDIR%\..\staging_prepare


set /p REBUILD="Rebuild? (y/n)" %=%

if /i {%REBUILD%}=={n} (goto :skipbuild)

rmdir /s /q ..\staging_prepare
mkdir ..\staging_prepare
qmake.exe ..\source\ModOrganizer.pro -r -spec win32-msvc2013 CONFIG+=release CONFIG-=debug
rem jom.exe
nmake

:skipbuild

set /p REBUILD="Fetch Translations? (y/n)" %=%
if /i {%REBUILD%}=={n} (goto :skipfetch)

rmdir /s /q ..\translations
mkdir ..\translations

cd ..\source
..\tools\tx -q pull -a --minimum-perc=20
for /r %%f in (*.ts) do copy %%f ..\translations
cd ..\translations
del *_en.ts
rem hack, the translation files for pycfg are named incorrectly
..\tools\BRC32.exe /PATTERN:pyniEdit* /REPLACECI:pyniEdit:pyCfg /execute
for %%f in (*.ts) do lrelease %%f

:skipfetch

chdir /d %OLDDIR%

rmdir /s /q ..\staging\ModOrganizer
mkdir ..\staging\ModOrganizer

for /F "tokens=1-3* delims=." %%a in ('cscript.exe //nologo filever.vbs ..\output\ModOrganizer.exe') do @set version=%%a_%%b_%%c

mkdir ..\pdbs\plugins_%version%

copy /y ..\output\ModOrganizer.pdb ..\pdbs\ModOrganizer_%version%.pdb
copy /y ..\output\hook.pdb ..\pdbs\hook_%version%.pdb
copy /y ..\output\uibase.pdb ..\pdbs\uibase_%version%.pdb
copy /y ..\output\plugins\*.pdb ..\pdbs\plugins_%version%

xcopy /y /I ..\output\ModOrganizer.exe ..\staging\ModOrganizer\
xcopy /y /I ..\output\helper.exe ..\staging\ModOrganizer\
xcopy /y /I ..\output\nxmhandler.exe ..\staging\ModOrganizer\
xcopy /y /I ..\output\uibase.dll ..\staging\ModOrganizer\
xcopy /y /I ..\output\hook.dll ..\staging\ModOrganizer\
xcopy /y /s /I ..\output\stylesheets ..\staging\ModOrganizer\stylesheets
xcopy /y /s /I ..\output\tutorials ..\staging\ModOrganizer\tutorials
xcopy /y /I ..\staging_trans\*.qm ..\staging\ModOrganizer\translations
del ..\staging\ModOrganizer\translations\*_en.qm
xcopy /y /I ..\output\plugins\*.dll ..\staging\ModOrganizer\plugins\
xcopy /y /I ..\output\plugins\*.py ..\staging\ModOrganizer\plugins\
xcopy /y /s /I /EXCLUDE:exclude.txt ..\output\plugins\data ..\staging\ModOrganizer\plugins\data
xcopy /y /s /I ..\output\NCC ..\staging\ModOrganizer\NCC
xcopy /y /s /I ..\output\loot ..\staging\ModOrganizer\loot
xcopy /y /I ..\output\dlls\archive.dll ..\staging\ModOrganizer\dlls\
xcopy /y /I ..\output\dlls\dlls.manifest ..\staging\ModOrganizer\dlls\
xcopy /y /s /I ..\translations\*.qm ..\staging\ModOrganizer\translations

cd ..\staging\ModOrganizer

windeployqt ModOrganizer.exe --no-translations --no-plugins --libdir dlls --release
windeployqt uibase.dll --no-translations --no-plugins --libdir dlls --release
for %%f in (plugins\*.dll) do windeployqt uibase.dll --no-translations --no-plugins --libdir dlls --release

rmdir /S /Q Qt
del dlls\vcredist_x86.exe

chdir /d %OLDDIR%

xcopy /y /s /I static_data\* ..\staging\ModOrganizer

pause

for /F "tokens=1-3* delims=." %%a in ('cscript.exe //nologo filever.vbs ..\output\ModOrganizer.exe') do echo %%a.%%b.%%c > ..\staging\version.txt
exit /B

exit /B