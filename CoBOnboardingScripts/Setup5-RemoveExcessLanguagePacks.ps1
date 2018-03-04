$LangPacks = DISM.exe /Online /Get-Intl /English |
    Select-String -SimpleMatch 'Installed language(s)'|
        ForEach-Object {
            if($_ -match ':\s*(.*)'){
                if($Matches[1] -ne "en-US"){$Matches[1]}
            }
    }
$LangPacks = ($LangPacks | Where-Object {$_ -ne "en_US"})
$LangPackString = $LangPacks -join " "
Start-Process lpksetup -ArgumentList "/u $LangPackString /r"