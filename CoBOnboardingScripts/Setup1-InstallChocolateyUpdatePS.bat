@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
choco feature enable -n allowGlobalConfirmation
powershell -Command "& {Set-ExecutionPolicy Unrestricted -Force}" -Verb RunAs -NoNewWindow
powershell -Command "& {Get-Service wuauserv | Stop-Service; Remove-Item C:\Windows\SoftwareDistribution -Recurse; Get-Service wuauserv | Start-Service }" -Verb RunAs -NoNewWindow
choco install powershell