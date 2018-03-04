& Get-Service wuauserv | Stop-Service
& Remove-Item C:\Windows\SoftwareDistribution -Recurse
& Get-Service wuauserv | Start-Service