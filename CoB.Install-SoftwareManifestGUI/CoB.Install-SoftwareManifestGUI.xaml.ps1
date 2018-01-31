[xml]$xaml = Get-Content -Path "$PSScriptRoot\CoB.Install-SoftwareManifestGUI.xaml"
$xamlReader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($xamlReader)

$xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]")  | ForEach-Object { 
    New-Variable -Name $_.Name -Value $window.FindName($_.Name) -Force
}

$window.ShowDialog() | Out-Null