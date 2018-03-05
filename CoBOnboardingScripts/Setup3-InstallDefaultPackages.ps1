$VerbosePreference = 2

# Establishes a list of default packages for all computers during onboarding.
$DetectedPackges = (
    @(
        @{ "Name" = "7-Zip*"; "ChocoPackage" = "7zip"; "UninstallArgs" = "/s"; "ChocoPackage64" = ""; "Force" = $true },
        @{ "Name" = "Google Chrome*"; "ChocoPackage" = "googlechrome"; "ChocoPackage64" = ""; "Force" = $true },
        @{ "Name" = "Microsoft Office Professional Plus 2013*"; "ChocoPackage" = "microsoft-office-professional-plus-2013"; "ChocoPackage64" = ""; "Force" = $false },
        @{ "Name" = "Microsoft Office Professional Plus 2016*"; "ChocoPackage" = "microsoft-office-professional-plus-2016 --x86"; "ChocoPackage64" = "microsoft-office-professional-plus-2016"; "Force" = $true },
        @{ "Name" = "Mozilla Firefox*"; "ChocoPackage" = "firefox"; "ChocoPackage64" = ""; "Force" = $true }
    ) | ForEach-Object {New-Object -TypeName PSCustomObject -Property $_ }
)

# Detects existing non-Chocolatey installations of $DetectedPackges, removes them, and replaces them with their Chocolatey counterparts.
$DetectedPackges | ForEach-Object { 
    $CurrentPackage = $_
    $InstalledPackages = (Get-Package -Name $CurrentPackage.Name -ErrorAction SilentlyContinue)
    $ChocoPackageToBeInstalled = $CurrentPackage.ChocoPackage

    if ($InstalledPackages -gt 0)
    { 
        $InstalledPackages | ForEach-Object { 
            $InstalledPackage = $_
            $AvailablePackages = (Find-Package -Name $CurrentPackage.Name -ProviderName Chocolatey -Source CoBIT_Chocolatey -AllVersions)
            
            $VersionToBeInstalled = ""

            if (($InstalledPackage.Source -match 'C:\\Program Files \(x86\)') -and ($CurrentPackage.ChocoPackage64 -ne "")) {  $ChocoPackageToBeInstalled = $CurrentPackage.ChocoPackage64 }
            $AvailablePackages | ForEach-Object { 
                if ($InstalledPackage.Version -match ($_.Version -replace '^(\d+.\d+).*', '$1')) {  $VersionToBeInstalled = $_.Version }
            }
            

            if ($VersionToBeInstalled -ne "")
            {  
                & "choco install $ChocoPackageToBeInstalled --version=$VersionToBeInstalled -n"
                & "choco upgrade $ChocoPackageToBeInstalled"
            }
            else
            { 
                & ([xml]($InstalledPackage.SwidTagText)).SoftwareIdentity.Meta.UninstallString
                & "choco install $ChocoPackageToBeInstalled"
            }
        }
    }
    elseif ($CurrentPackage.Force) { & "choco install $ChocoPackageToBeInstalled" }
}