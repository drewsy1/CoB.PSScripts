call Setup1.InstallChocolateyUpdatePS.bat
powershell -File "Setup2-EnableCoBSources.ps1"
powershell -File "Setup3-InstallDefaultPackages.ps1"
powershell -File "Setup4-ReplaceInstalledPackages.ps1"
powershell -File "Setup5-RemoveExcessLanguagePacks.ps1"