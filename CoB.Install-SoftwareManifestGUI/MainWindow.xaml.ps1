Remove-Module CoB.SoftwareManagement
Import-Module CoB.SoftwareManagement

[xml]$xaml = Get-Content -Path "$PSScriptRoot\MainWindow.xaml"
$xamlReader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($xamlReader)

$xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]")  | ForEach-Object { 
    New-Variable -Name $_.Name -Value $window.FindName($_.Name) -Force
}

function Convert-ArrayToSystemArray()
{
	param(
		[object[]]$InputObjects
	)

	$array = New-Object System.Collections.ArrayList
	$Script:procInfo = $InputObjects
	$array.AddRange($procInfo)
	return $array
}

$InstallQueue = New-Object System.Collections.ArrayList
$InstallCatalog = Convert-ArrayToSystemArray -InputObjects (CoB.SoftwareManagement\Get-CoBPak | Select Company,Name,Version,Architecture | sort -Property Company)

$listQueue.ItemsSource = $InstallQueue
$listCatalog.ItemsSource = $InstallCatalog


$window.ShowDialog()

$InstallQueue.Add($InstallCatalog[0])
$listQueue.