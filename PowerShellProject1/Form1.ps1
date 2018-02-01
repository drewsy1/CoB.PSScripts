$splitContainer2_Panel2_Paint = {

}

$listView1_SelectedIndexChanged = {

}

function Get-InstallCatalog()
{
	$array = New-Object System.Collections.ArrayList
	$Script:procInfo = (CoB.SoftwareManagement\Get-CoBPak | Select Company,Name,Version,Architecture | sort -Property Company)
	$array.AddRange($procInfo)
	$dataGridView1.DataSource=$array
	$MainForm.Refresh()
}

$OnLoadForm_UpdateGrid= { Get-InstallCatalog } 

. (Join-Path $PSScriptRoot 'Form1.designer.ps1')
$MainForm.add_Load($OnLoadForm_UpdateGrid)
$MainForm.ShowDialog()