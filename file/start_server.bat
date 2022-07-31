@echo off
title start_server
cd server
start /min cmd /k "python SimpleHTTPServer.py"
ngrok http 80 --log=stdout > ngrok.log