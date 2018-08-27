<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER LocalFolder

    .PARAMETER ServerFolder

    .EXAMPLE

    .INPUTS

    .OUTPUTS
#>
param(
    [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)][string]$LocalFolder,
    [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)][string]$ServerFolder
)

# Get System.IO.FileSystemInfo objects for local/server folders, throw error if path of either is not able to be resolved.
try
{
    $LocalFolderObject = Get-Item $LocalFolder
    $ServerFolderObject = Get-Item $ServerFolder
}
catch {throw $_}

# Write resolved local/server folder paths to verbose
Write-Verbose "LocalFolder = $($LocalFolderObject.FullName)"
Write-Verbose "ServerFolder = $($ServerFolderObject.FullName)"

. ".\Join-Object.ps1"

# Perform a join on local/server folder objects
$JoinParams = @{
    Left              = (Get-ChildItem $LocalFolderObject -Recurse)
    Right             = (Get-ChildItem $ServerFolderObject -Recurse)
    LeftJoinProperty  = "Name"
    RightJoinProperty = "Name"
    Type              = "AllInBoth"
    Prefix            = "ServerVersion_"
    Verbose           = $false
}

# Push $LocalFolder to current location
#Push-Location $LocalFolder -Verbose

function Compare-FileWriteTimes
{
    param(
        $FileName,
        $Left,
        $Right
    )

    Write-Verbose "Compare-FileWriteTimes: $($FileName):  Left = $Left"
    Write-Verbose "Compare-FileWriteTimes: $($FileName): Right = $Right"

    if ($Left -and !$Right) { $symbol = "Left (New)" } # Right file doesn't exist, copy L→R
    elseif (!$Left -and $Right) { $symbol = "Right (New)" } # Left file doesn't exist, copy R→L
    elseif ($Left -gt $Right) { $symbol = "Left (Overwrite)" } # Left file is newer than right, copy L→R
    elseif ($Left -lt $Right) { $symbol = "Right (Overwrite)" } # Right file is newer than left, copy R→L
    elseif ($Left -eq $Right) { $symbol = "Unchanged" } # Both files are equal, do nothing
    else { $symbol = "?" } # Other case, consider this an error

    return $symbol # Return result string of comparison
}

Join-Object @JoinParams | 
Select-Object -Property `
    @{Name="LeftFile"; Expression={Get-Item $_.FullName}},
    @{Name="LeftWriteTime"; Expression={$_.LastWriteTime}},
    @{Name= "WhichVersion"; Expression= { Compare-FileWriteTimes -FileName $_.FullName -Left "$($_.LastWriteTime)" -Right "$($_.ServerVersion_LastWriteTime)" }},
    @{Name="RightWriteTime"; Expression={$_.ServerVersion_LastWriteTime}},
    @{Name="RightFile"; Expression={Get-Item $_.ServerVersion_FullName}},
    @{Name="LeftDirectory"; Expression={$LocalFolderObject}},
    @{Name="RightDirectory"; Expression={$ServerFolderObject}}

#Pop-Location