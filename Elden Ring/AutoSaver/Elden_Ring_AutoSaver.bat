@echo off
rem Elden Ring: AutoSaver
rem 0.1
rem 2022/12/15

set game_folder="E:\Program Files (x86)\ELDEN RING\Game"
set process_name=eldenring.exe
set profile_folder="C:\Users\USER\AppData\Roaming\EldenRing\76561197960267366"
set backup_folder="C:\Users\USER\AppData\Roaming\EldenRing\76561197960267366\backup"

:: Main Menu
echo.
echo  Welcome to Elden Ring AutoSaver!
echo.
echo Select number to execute game with options:
echo.
echo  1 - Restore SaveFile.
echo  2 - Continue.
echo.
set /p answer=":> "
echo.
cls
echo.
if %answer%==1 (
    goto RecoveryBackup
) else if %answer%==2 (
    goto Continue
) else (
	goto Continue
)

:RecoveryBackup
Powershell.exe -ExecutionPolicy Unrestricted -Command "$recent_file = gci %backup_folder% | sort LastWriteTime | select -last 1; cpi %backup_folder%\$recent_file %profile_folder%\ER0000.sl2%"
cls
echo.

:Continue
cd %game_folder% && start %process_name%

:Main

:CheckTaskRunning
tasklist /fi "imagename eq %process_name%" | find "%process_name%" > nul 
IF %ERRORLEVEL% == 1 (
	color B
	echo.
	echo Active process %process_name% not found.
	timeout /t 10
	cls
	echo.
	goto CheckTaskRunning
	)

color F
set hrs=%time:~0,2%
set mns=%time:~3,2%
set scs=%time:~6,2%
set datetime=%date%-%hrs%%mns%%scs%
set datetime=%datetime: =%

echo.
cls
echo.

copy /Y "%profile_folder%\ER0000.sl2" "%backup_folder%\ER0000-%datetime%.sl2"

rem Powershell.exe -ExecutionPolicy Unrestricted -Command "Get-ChildItem -path %backup_folder% | where {$_.Lastwritetime -lt (date).addminutes(-10)} | remove-item -Recurse -Force"

Powershell.exe -ExecutionPolicy Unrestricted -Command "$files = Get-ChildItem -Path %backup_folder% | Sort-Object creationtime -Descending; $count = $files.count - 10; if ($files.Count -igt 10) {$DelFiles = $files | Select-Object -last $count; Remove-Item -Path $DelFiles.fullname}"

timeout /t 180
goto Main
