#
# Script.ps1
#
$test = (CoB.SoftwareManagement\Get-CoBPak | Select Company,Name,Version,Architecture | sort -Property Company))