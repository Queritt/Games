@echo off
rem Elden Ring: AutoSaver
rem 0.12
rem 2023/03/15

set game_folder="E:\Software\ELDEN.RING.Deluxe.Edition.Steam.Rip-InsaneRamZes\ELDEN RING\Game"
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

for /f %%i in ('forfiles /p %profile_folder% /m *.sl2 /c "cmd /c echo @ftime"') do @set "current_file=%%i"
for /f %%i in ('dir %backup_folder% /b/a-d/od/t:c') do set "backup_file_name=%%i"
for /f %%i in ('forfiles /p %backup_folder% /m %backup_file_name% /c "cmd /c echo @ftime"') do @set "backup_file=%%i"

if not %current_file%==%backup_file% copy /Y "%profile_folder%\ER0000.sl2" "%backup_folder%\ER0000-%datetime%.sl2"

rem Powershell.exe -ExecutionPolicy Unrestricted -Command "Get-ChildItem -path %backup_folder% | where {$_.Lastwritetime -lt (date).addminutes(-10)} | remove-item -Recurse -Force"

Powershell.exe -ExecutionPolicy Unrestricted -Command "$files = Get-ChildItem -Path %backup_folder% | Sort-Object creationtime -Descending; $count = $files.count - 30; if ($files.Count -igt 30) {$DelFiles = $files | Select-Object -last $count; Remove-Item -Path $DelFiles.fullname}"

rem timeout /t 180
timeout /t 60
goto Main
