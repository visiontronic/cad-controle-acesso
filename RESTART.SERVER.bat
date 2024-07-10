@echo off
c:
cd c:\cad
taskkill /f /im CADServer.exe /t
cls
taskkill /f /im phpcad.exe /t
cls
ping 127.0.0.1 -n 3 > nul
sudo C:\CAD\CADServer.exe -S -DEBUG