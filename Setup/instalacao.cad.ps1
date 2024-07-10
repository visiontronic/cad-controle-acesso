Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco upgrade chocolatey
choco install chocolateygui -y
choco install softether-vpn-client
choco install gsudo -y
choco install notepadplusplus -y
choco install ffmpeg -y
choco install googlechrome --ignore-checksums -y
choco install winrar -y
choco install vlc --x86 --force -y
choco install sysinternals -y
choco install firebird --version 2.5.9 -params '/SuperClassic' -y
choco install dotnetcore-sdk -y
choco install dotnet-sdk -y
choco install advanced-ip-scanner -y