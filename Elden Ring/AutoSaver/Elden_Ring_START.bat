@echo off
:: Elden Ring: Start
:: 0.1
:: 2022/12/15

:: BatchGotAdmin (Run as Admin code starts)
REM --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
echo Requesting administrative privileges...
goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B
:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
pushd "%CD%"
CD /D "%~dp0"
:: BatchGotAdmin (Run as Admin code ends)
:: Your codes should start from the following line

for /F "tokens=1,2* delims= " %%A in ('tasklist /v /fi "IMAGENAME eq cmd.exe"') do (echo:%%C|findstr "Elden_Ring_AutoSaver" >Nul && set "pid=%%B") 1>NUL 
taskkill /PID %pid% /F /T 2>NUL
taskkill /IM "eldenring.exe" /F 2>NUL
start "Elden_Ring_AutoSaver" "Elden_Ring_AutoSaver.bat"
