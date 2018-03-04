Set-ExecutionPolicy Bypass -Force
$VerbosePreference = 2

<# if((Get-WmiObject Win32_ComputerSystem).Domain -match '^WORKGROUP$')
{
    Write-Verbose "Computer not added to ad3.latech.edu domain, adding."
    add-computer –domainname ad3.latech.edu -Credential "ad3.latech.edu\" -restart –confirm 
}
else{ Write-Verbose "$env:COMPUTERNAME already added to ad3.latech.edu domain, proceeding." }

if(!(Get-LocalUser Administrator).Enabled)
{
    Write-Verbose "Administrator account not enabled, enabling."
    Set-LocalUser Administrator -Password "Contemn*Delivery"
    Enable-LocalUser Administrator
}
else{ Write-Verbose "Administrator account enabled, proceeding." } #>

if($env:ChocolateyInstall -eq $null)
{ 
    Write-Verbose "Chocolatey not installed, upgrading."
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 
}
else{ Write-Verbose "Chocolatey installed, proceeding." }

& choco feature enable -n allowGlobalConfirmation

if([decimal]::Parse("$($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor)") -le 5)
{ 
    Write-Verbose "PowerShell Version $($PSVersionTable.PSVersion.ToString()) < 5, upgrading PowerShell."
    & "choco" install powershell --force
    Restart-Computer -Confirm
}
else{ Write-Verbose "PowerShell Version $($PSVersionTable.PSVersion.ToString()) $([char]0x2265) 5, proceeding." }

$sources = choco sources
if($sources.Where({$_ -match "cobit"}).Count -eq 0){ 
    Write-Verbose "CoBIT Chocolatey source not present, adding."
    & choco source add -n="cobit" -s="\\nas001.business.latech.edu\install\PackageManagement"
}
else{Write-Verbose "CoBIT Chocolatey source already added, skipping."}

<#if((Get-PSSessionConfiguration -Name "Microsoft.Powershell").SecurityDescriptorSddl -ne 'O:NSG:BAD:P(A;;GA;;;BA)(A;;GA;;;IU)(A;;GA;;;RM)S:P(AU;FA;GA;;;WD)(AU;SA;GXGW;;;WD)')
{
    Write-Verbose "Microsoft.PowerShell PSSession security descriptor incorrect,"
    Set-PSSessionConfiguration -Name "Microsoft.Powershell" -SecurityDescriptorSddl 'O:NSG:BAD:P(A;;GA;;;BA)(A;;GA;;;IU)(A;;GA;;;RM)S:P(AU;FA;GA;;;WD)(AU;SA;GXGW;;;WD)'
}#>

if((Get-Package NuGet -ErrorAction SilentlyContinue ).Count -eq 0)
{
    Write-Verbose "NuGet not found, installing."
    Install-Package NuGet -Force -Verbose:$false | Out-Null
}
else{Write-Verbose "NuGet already installed, proceeding."}

Set-PackageSource -Trusted PSGallery -Verbose:$false | Out-Null
Install-PackageProvider Chocolatey -Force -Verbose:$false | Out-Null
Register-PackageSource -Name CoBIT_Chocolatey -ProviderName Chocolatey -Location "\\nas001.business.latech.edu\install\PackageManagement" -Trusted | Out-Null

Import-Module PowerShellGet -Verbose:$false | Out-Null
$repo = @{
    Name = 'CoBIT'
    SourceLocation = "\\nas001.business.latech.edu\support\PSRepository"
    PublishLocation = "\\nas001.business.latech.edu\support\PSRepository"
    InstallationPolicy = 'Trusted'
}
Register-PSRepository @repo -Verbose:$false | Out-Null

Find-Module -Repository cobit -Verbose:$false | Install-Module -Verbose:$false | Out-Null

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

$DetectedPackges = @(
    @{"Name"="IBM SPSS Statistics*";"ChocoPackage"="ibm-spss-statistics"; "Arguments"="--x86 --version=24.0.0.0"; "UninstallArguments"=""}
    @{"Name"="IBM SPSS AMOS*";"ChocoPackage"="ibm-spss-amos"; "Arguments"="--x86 --version=24.0.0.0"; "UninstallArguments"=""}
    @{"Name"="Tableau*";"ChocoPackage"="tableau-desktop"; "Arguments"=""; "UninstallArguments"="/uninstall /quiet"}
    #@{"Name"="Sassafras K2 Client";"ChocoPackage"="sassafras-k2client"; "Arguments"=""; "UninstallArguments"=""}
    @{"Name"="SAS 9.*";"ChocoPackage"="sas"; "Arguments"=""; "UninstallArguments"="‐quiet ‐uninstallall"}
    #@{"Name"="SAP*";"ChocoPackage"="sap-gui"; "Arguments"=""; "UninstallArguments"=""}
) 

$DetectedPackges | ForEach-Object {
    $CurrentPackage = $_
    $InstalledPackages = (Get-Package -Name $currentPackage.Name -ErrorAction SilentlyContinue)
    if($InstalledPackages.Count -gt 0){
        $InstalledPackages | ForEach-Object{
            $currentInstalledPackage = $_
            if($InstalledPackages.ProviderName.Contains("msi")){
                $InstalledPackages | Where-Object -Property "ProviderName" -Match "msi" | Uninstall-Package
            }
            else{
                [string]$ArgumentList = ""
                $BuiltinArgs = (([xml]($currentInstalledPackage.SwidTagText)).SoftwareIdentity.Meta.UninstallString -replace '^".*"\s(.*)','$1')

                if($CurrentPackage.UninstallArguments -ne ""){ $ArgumentList = $CurrentPackage.UninstallArguments }
                elseif($BuiltinArgs -ne $null){ $ArgumentList = $BuiltinArgs }
                else { $ArgumentList = "/s" }
                
                $currentInstalledPackage | Where-Object -Property "ProviderName" -Match "Programs" | ForEach-Object{ "Start-Process -FilePath $(([xml]($currentInstalledPackage.SwidTagText)).SoftwareIdentity.Meta.UninstallString -replace '^"(.*)".*','$1') -ArgumentList $ArgumentList -Wait -NoNewWindow" }
                $currentInstalledPackage | Where-Object -Property "ProviderName" -Match "Programs" | ForEach-Object{ Start-Process -FilePath (([xml]($currentInstalledPackage.SwidTagText)).SoftwareIdentity.Meta.UninstallString -replace '^"(.*)".*','$1') -ArgumentList $ArgumentList -Wait -NoNewWindow }
            }
        }
        Start-Process "choco" -ArgumentList "install $($CurrentPackage.ChocoPackage) $($CurrentPackage.Arguments)" -Wait -NoNewWindow
    }
}

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

pause