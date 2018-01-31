Import-Module CoB.SoftwareManagement

[xml]$xaml = Get-Content -Path "$PSScriptRoot\MainWindow.xaml"
$xamlReader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($xamlReader)

$xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]")  | ForEach-Object { 
    New-Variable -Name $_.Name -Value $window.FindName($_.Name) -Force
}

function Set-DataGridContents
{

}
$array = New-Object System.Collections.ArrayList
$Script:procInfo = CoB.SoftwareManagement\Get-CoBPak | Select Company,Name,Version,Architecture | sort -Property Company
$array.AddRange($procInfo)
$listCatalog.ItemsSource = $array

$window.ShowDialog()