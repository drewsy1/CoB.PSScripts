$VerbosePreference = 2

$DetectedPackges = @(
    @{ "Name" = "IBM SPSS Statistics*"; "ChocoPackage" = "ibm-spss-statistics-x86"; "ChocoPackage64" = "ibm-spss-statistics-x64" }
    @{ "Name" = "IBM SPSS AMOS*"; "ChocoPackage" = "ibm-spss-amos-x86"; "ChocoPackage64" = "" }
    @{ "Name" = "Tableau*"; "ChocoPackage" = "tableau-desktop"; "ChocoPackage64" = "" }
    @{ "Name" = "Sassafras K2 Client"; "ChocoPackage" = "sassafras-k2client"; "ChocoPackage64" = "" }
    @{ "Name" = "SAS 9.*"; "ChocoPackage" = "sas-x86"; "ChocoPackage64" = "sas-x64" }
    @{ "Name" = "SAP*"; "ChocoPackage" = "sap-gui"; "ChocoPackage64" = "" }
) 

$DetectedPackges | ForEach-Object { 
    $CurrentPackage = $_
    $InstalledPackages = (Get-Package -Name $CurrentPackage.Name -ErrorAction SilentlyContinue)

    if ($InstalledPackages -gt 0)
    { 
        $InstalledPackages | ForEach-Object { 
            $InstalledPackage = $_
            $AvailablePackages = (Find-Package -Name $CurrentPackage.Name -ProviderName Chocolatey -Source CoBIT_Chocolatey -AllVersions)
            
            $VersionToBeInstalled = ""
            $ChocoPackageToBeInstalled = $CurrentPackage.ChocoPackage

            if (($InstalledPackage.Source -match 'C:\\Program Files \(x86\)') -and ($CurrentPackage.ChocoPackage64 -ne "")) {  $ChocoPackageToBeInstalled = $CurrentPackage.ChocoPackage64 }
            $AvailablePackages | ForEach-Object { 
                if ($InstalledPackage.Version -match ($_.Version -replace '^(\d+.\d+).*', '$1')) {  $VersionToBeInstalled = $_.Version }
            }
            

            if ($VersionToBeInstalled -ne "") {  
                & "choco install $ChocoPackageToBeInstalled --version=$VersionToBeInstalled -n"
                & "choco upgrade $ChocoPackageToBeInstalled"
            }
            else { 
                & ([xml]($InstalledPackage.SwidTagText)).SoftwareIdentity.Meta.UninstallString
                & "choco install $ChocoPackageToBeInstalled"
            }
        }
    }
}