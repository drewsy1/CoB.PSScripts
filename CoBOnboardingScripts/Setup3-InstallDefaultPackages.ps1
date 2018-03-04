$VerbosePreference = 2

$DefaultPackages = @(
    @{"Name"="Mozilla Firefox*"; "ChocoPackage"="firefox"; "UninstallArgs"="/s"},
    @{"Name"="Google Chrome*"; "ChocoPackage"="googlechrome"; "UninstallArgs"=""},
    @{"Name"="7-Zip*"; "ChocoPackage"="7zip"; "UninstallArgs"="/s"}
)

$DefaultPackages | ForEach-Object{
    $CurrentPackage = $_
    $InstalledPackages = (Get-Package $currentPackage.Name -ErrorAction SilentlyContinue)
    if($InstalledPackages.Count -gt 0){
        #if((($InstalledPackages.Version -replace '(^\d+\D)|\D*(\d+)\D*', '$1$2') -as [decimal]) -lt (((Find-Package -ProviderName Chocolatey -Name $CurrentPackage.ChocoPackage).Version -replace '(^\d+\D)|\D*(\d+)\D*', '$1$2'))){
            if($InstalledPackages.ProviderName.Contains("msi")){
                $InstalledPackages | Where-Object -Property "ProviderName" -Match "msi" | Uninstall-Package
            }
            elseif($CurrentPackage.UninstallArgs -ne ""){
                $InstalledPackages | Where-Object -Property "ProviderName" -Match "Programs" | ForEach-Object{ Start-Process -FilePath ((([xml]($_.SwidTagText)).SoftwareIdentity.Meta.UninstallString -replace '^"(.*)"$','$1')) -ArgumentList $CurrentPackage.UninstallArgs -Wait -NoNewWindow }
            }
            else{
                $InstalledPackages | Where-Object -Property "ProviderName" -Match "Programs" | ForEach-Object{ Start-Process -FilePath ((([xml]($_.SwidTagText)).SoftwareIdentity.Meta.UninstallString -replace '^"(.*)"$','$1')) -Wait -NoNewWindow }
            }
        #}
    }
    choco install $CurrentPackage.ChocoPackage -force
}
