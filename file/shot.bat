@echo off
title shot
msg * shot
setlocal DisableDelayedExpansion
for /f "Delims=" %%a in (id.txt) do set id=%%a
reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT
if %OS%==64BIT set /A save=64
if %OS%==32BIT set /A save=32
cls
goto loop
:loop
nircmd%save% savescreenshot "server\screenshot.png"
curl -X PUT --upload-file screenshot.png  https://%id%.ap.ngrok.io
set key=0
set click=0
set x=0
set y=0
if exist server\key.txt for /f "Delims=" %%b in (server\key.txt) do set key=%%b
if exist server\click.txt for /f "Delims=" %%x in (server\click.txt) do set click=%%x
if exist server\x.txt for /f "Delims=" %%d in (server\x.txt) do set x=%%d
if exist server\y.txt for /f "Delims=" %%e in (server\y.txt) do set y=%%e
if exist server\exit.txt taskkill /F /FI "WindowTitle eq  mouse" /T & taskkill /F /FI "WindowTitle eq  start_server" /T & taskkill /F /FI "WindowTitle eq  httpserver" /T & msg * disconnected & exit
start mouse.py %x% %y% %click% %key%
goto loop