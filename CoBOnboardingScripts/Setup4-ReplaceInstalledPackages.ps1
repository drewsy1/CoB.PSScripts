$VerbosePreference = 2

# Establishes a list of packages for which to search and replace with Chocolatey versions.
$DetectedPackges = ( 
    @( 
        @{ "Name" = "IBM SPSS AMOS*"; "ChocoPackage" = "ibm-spss-amos-x86"; "ChocoPackage64" = "" },
        @{ "Name" = "IBM SPSS Statistics*"; "ChocoPackage" = "ibm-spss-statistics-x86"; "ChocoPackage64" = "ibm-spss-statistics-x64" },
        @{ "Name" = "LINDO*"; "ChocoPackage" = "lindo"; "ChocoPackage64" = "" },
        @{ "Name" = "Microsoft Project Professional 2013*"; "ChocoPackage" = "microsoft-project-professional-2013"; "ChocoPackage64" = "" },
        @{ "Name" = "Microsoft Project Professional 2016*"; "ChocoPackage" = "microsoft-project-professional-2016 --x86"; "ChocoPackage64" = "microsoft-project-professional-2016" },
        @{ "Name" = "Microsoft Visio Professional 2013*"; "ChocoPackage" = "microsoft-visio-professional-2013"; "ChocoPackage64" = "" },
        @{ "Name" = "Microsoft Visio Professional 2016*"; "ChocoPackage" = "microsoft-visio-professional-2016 --x86"; "ChocoPackage64" = "microsoft-visio-professional-2016" },
        @{ "Name" = "Microsoft Visual Studio Premium 2013*"; "ChocoPackage" = "microsoft-visualstudio-premium-2013"; "ChocoPackage64" = "" },
        @{ "Name" = "Microsoft Visual Studio Pro 2015*"; "ChocoPackage" = "microsoft-visualstudio-pro-2015"; "ChocoPackage64" = "" },
        @{ "Name" = "Research Insight*"; "ChocoPackage" = "research-insight"; "ChocoPackage64" = "" },
        @{ "Name" = "SAP*"; "ChocoPackage" = "sap-gui"; "ChocoPackage64" = "" },
        @{ "Name" = "SAS 9.*"; "ChocoPackage" = "sas-x86"; "ChocoPackage64" = "sas-x64" },
        @{ "Name" = "Sassafras K2 Client"; "ChocoPackage" = "sassafras-k2client"; "ChocoPackage64" = "" },
        @{ "Name" = "Tableau*"; "ChocoPackage" = "tableau-desktop"; "ChocoPackage64" = "" }
    ) | ForEach-Object {New-Object -TypeName PSCustomObject -Property $_ }
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
}