@echo off
cls
::file
::if not exist username.txt cd .. & start /wait setup.bat & cd file
::setlocal DisableDelayedExpansion
set vbsusername=%~1
set partnerid=%~2
::for /f "Delims=" %%b in (id.txt) do set partnerid=%%b
::setlocal DisableDelayedExpansion
::for /f "Delims=" %%a in (username.txt) do set username=%%a

cd server
echo dim result, oShell > first_set.vbs
echo Set oShell = WScript.CreateObject("WScript.Shell") >> first_set.vbs
echo result = msgbox("do you want to connect to %vbsusername%", 4 , "Select yes or no") >> first_set.vbs
echo If result=6 then >> first_set.vbs
echo msgbox "Yes selected" >> first_set.vbs
echo oShell.Run "cmd /c echo 1 > choose.txt", , True >> first_set.vbs
echo oShell.Run "cd ..", , True >> first_set.vbs
echo oShell.Run "start /min shot.bat", , True >> first_set.vbs
echo else >> first_set.vbs
echo msgbox "No selected" >> first_set.vbs
echo oShell.Run "taskkill /F /FI ""WindowTitle eq  start_server"" /T", , True >> first_set.vbs
echo oShell.Run "taskkill /F /FI ""WindowTitle eq  httpserver"" /T", , True >> first_set.vbs
echo oShell.Run "cmd /c echo 0 > choose.txt", , True >> first_set.vbs
echo end if >> first_set.vbs

::first_set in server choose.txt in server
cd server
curl -X PUT --upload-file first_set.vbs https://%partnerid%.ap.ngrok.io
exit