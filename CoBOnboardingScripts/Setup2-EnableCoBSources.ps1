$VerbosePreference = 2

$sources = choco sources
if($sources.Where({$_ -match "cobit"}).Count -eq 0){ 
    Write-Verbose "CoBIT Chocolatey source not present, adding."
    & choco source add -n="cobit" -s="\\nas001.business.latech.edu\install\PackageManagement"
}
else{Write-Verbose "CoBIT Chocolatey source already added, skipping."}

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