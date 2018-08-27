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
    [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)][System.IO.FileSystemInfo]$LeftFile,
    [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]$LeftWriteTime,
    [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)][string]$WhichVersion,
    [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]$RightWriteTime,
    [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)][System.IO.FileSystemInfo]$RightFile,
    [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)][System.IO.FileSystemInfo]$LeftDirectory,
    [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)][System.IO.FileSystemInfo]$RightDirectory,
    [switch]$WhatIf
)

process{
    [string]$Destination = $null
    
    switch ($WhichVersion -replace '^(\w+)\s.*','$1')
    {
        'Left' {
            $Source = $LeftFile
            if($RightFile){ $Destination = $RightFile.FullName}
            else{
                Push-Location $LeftDirectory
                $RelativePath = (Resolve-Path -Relative $LeftFile) -replace '^\.\\',''
                $Destination = Join-Path $RightDirectory.FullName $RelativePath
                Pop-Location
            }
        }
        'Right' {
            $Source = $RightFile
            if($LeftFile){ $Destination = $LeftFile.FullName}
            else{
                Push-Location $RightDirectory
                $RelativePath = (Resolve-Path -Relative $RightFile) -replace '^\.\\',''
                $Destination = Join-Path $LeftDirectory.FullName $RelativePath
                Pop-Location
            }
        }
    }

    if($WhichVersion -match '^(?:Left|Right)'){ Copy-Item -Path $Source -Destination $Destination -WhatIf:$WhatIf }
}