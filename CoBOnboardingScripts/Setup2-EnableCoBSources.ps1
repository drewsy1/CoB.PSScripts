$VerbosePreference = 2

# Checks for presence of an existing CoBIT Chocolatey source and adds it if not present.
$sources = choco sources
if ($sources.Where( { $_ -match "cobit" }).Count -eq 0)
{ 
    Write-Verbose "CoBIT Chocolatey source not present, adding."
    & choco source add -n="cobit" -s="\\nas001.business.latech.edu\install\PackageManagement"
}
else { Write-Verbose "CoBIT Chocolatey source already added, skipping." }

# Checks for presence of NuGet and installs it if not present.
if ((Get-Package NuGet -ErrorAction SilentlyContinue ).Count -eq 0)
{
    Write-Verbose "NuGet not found, installing."
    Install-Package NuGet -Force -Verbose:$false | Out-Null
}
else { Write-Verbose "NuGet already installed, proceeding." }

# Sets PSGallery PackageSource as trusted.
Set-PackageSource -Trusted PSGallery -Verbose:$false | Out-Null

# Installs Chocolatey PackageManagement source; this is used only to search for package metadata, it DOES NOT INSTALL CHOCOLATEY PACKAGES CORRECTLY.
Install-PackageProvider Chocolatey -Force -Verbose:$false | Out-Null

# Adds CoBIT Chocolatey source to PackageManagement.
Register-PackageSource -Name CoBIT_Chocolatey -ProviderName Chocolatey -Location "\\nas001.business.latech.edu\install\PackageManagement" -Trusted | Out-Null

# Imports PowerShellGet module and registers the CoBIT PSRepository in PackageManagement.
Import-Module PowerShellGet -Verbose:$false | Out-Null
$repo = @{
    Name               = 'CoBIT'
    SourceLocation     = "\\nas001.business.latech.edu\support\PSRepository"
    PublishLocation    = "\\nas001.business.latech.edu\support\PSRepository"
    InstallationPolicy = 'Trusted'
}
Register-PSRepository @repo -Verbose:$false | Out-Null

# Installs all CoBIT PS modules.
Find-Module -Repository cobit -Verbose:$false | Install-Module -Verbose:$false | Out-Null