@echo off
title setup
cls
cd file
echo you need to install python
set /p name=username(ascii only): 
echo %name% > username.txt
cls
cd server
echo add authtoken
set /p code=
ngrok config add-authtoken %code%
echo done
pause
exit