@echo off
@title Iniciando Demonstracao
@echo - Antes de inciar os programas verifique se os dispositivos
@echo - estao conectados na placa de rede cabeada do notebook
@echo - e que o IP dela esta fixo em 192.168.137.1
@echo - 
pause
cls
taskkill /f /im CADServer.exe /t
cls
taskkill /f /im phpcad.exe /t
cls
taskkill /f /im CAD.exe /t
cls
taskkill /f /im CADWebCam.exe /t
cls
taskkill /f /im CADFaceCam.exe /t
cls
c:
cd c:\cad
@echo Aguarde ...
@echo Iniciando controlador dos dispositivos
ping 127.0.0.1 -n 3 > NUL
start CADServer.exe -S -DEBUG
@echo Iniciando CAD Portaria
ping 127.0.0.1 -n 6 > NUL
start CAD.exe
@echo Finalizado!
ping 127.0.0.1 -n 3 > NUL
