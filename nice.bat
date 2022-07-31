@echo off
title nice
cls
cd file
setlocal DisableDelayedExpansion
if not exist username.txt cd .. & start /wait setup.bat & cd file
if exist server\exit.txt Del server\exit.txt
for /f "Delims=" %%a in (username.txt) do set username=%%a
:start
echo 1.connect to partner
echo 2.wait for connect
echo 3.disconnect
set /p choose=
if %choose% == 1 goto connect
if %choose% == 2 goto wait
if %choose% == 3 goto disconnect
goto start
:connect
cls
::pc1
echo your username: %username%
set /p partnerusername=partner username(ascii only): 
set /p partnerid=partner id: 
echo %partnerid% > id.txt
SETLOCAL ENABLEDELAYEDEXPANSION
set vbsusername=!username: =-!
start /min /wait first.bat %vbsusername% %partnerid%
setlocal
goto choose
:choose
echo waiting to respond...
:: check choose.txt
set linkdownload=https://%partnerid%.ap.ngrok.io/choose.txt
set filedownload=.\server\choose.txt
for /f "tokens=4-5 delims=. " %%i in ('ver') do set version=%%i.%%j
if "%version%" == "6.1" powershell -Command "(New-Object Net.WebClient).DownloadFile('%linkdownload%', '%filedownload%')" || goto choose
if "%version%" == "10.0" powershell -Command "Invoke-WebRequest %linkdownload% -OutFile %filedownload%" || goto choose
pause
setlocal DisableDelayedExpansion
for /f "Delims=" %%c in (server\choose.txt) do set choose=%%c
if %choose% == 1 start screen.py %partnerid% & set /A count=0 & set linkdownload=https://%partnerid%.ap.ngrok.io/screenshot.png & set filedownload=.\server\screenshot.png & set linkdownload2=https://%partnerid%.ap.ngrok.io/exit.txt & set filedownload2=.\server\exit.txt & goto after_done
if %choose% == 0 msg * your partner do not accept & pause & goto start
:after_done
cls
:: check screenshot.png
if "%version%" == "6.1" powershell -Command "(New-Object Net.WebClient).DownloadFile('%linkdownload%', '%filedownload%')"
if "%version%" == "10.0" powershell -Command "Invoke-WebRequest %linkdownload% -OutFile %filedownload%"
:: check exit.txt
if "%version%" == "6.1" powershell -Command "(New-Object Net.WebClient).DownloadFile('%linkdownload2%', '%filedownload2%')" || goto after_done
if "%version%" == "10.0" powershell -Command "Invoke-WebRequest %linkdownload2% -OutFile %filedownload2%" || goto after_done
msg * server is closed
pause
goto start

:wait
cls
::pc2
start /min start_server.bat
echo starting...
timeout 1 > nul
setlocal EnableExtensions DisableDelayedExpansion
if not exist "server\ngrok.log" msg * error & exit /b 2
for /F delims^=^ eol^= %%I in ('%SystemRoot%\System32\findstr.exe /R "url=https://..*\.ap\.ngrok\.io" "server\ngrok.log"') do (
    set "Data=%%I"
    setlocal EnableDelayedExpansion
    set "Data=!Data:*https://=!"
    set "Data=!Data:.ap.ngrok.io=|!"
    for /F "delims=|" %%J in ("!Data!") do (
        endlocal
        set "HostName=%%J"
    )
)
echo your username: %username%
echo your id: %HostName%
echo %HostName% > id.txt
goto find_first
:find_first
echo loading...
if exist server\first_set.vbs (start /min /wait server\first_set.vbs) else (goto find_first)
goto start
:disconnect
taskkill /F /FI "WindowTitle eq  mouse" /T
taskkill /F /FI "WindowTitle eq  shot" /T
echo > server\exit.txt
curl -X PUT --upload-file exit.txt  https://%HostName%.ap.ngrok.io
taskkill /F /FI "WindowTitle eq  start_server" /T
taskkill /F /FI "WindowTitle eq  httpserver" /T
msg * disconnected
goto start