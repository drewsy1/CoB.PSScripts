[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$MainForm = New-Object -TypeName System.Windows.Forms.Form
[System.Windows.Forms.StatusStrip]$statusStrip1 = $null
[System.Windows.Forms.MenuStrip]$menuStrip1 = $null
[System.Windows.Forms.ToolStripMenuItem]$fileToolStripMenuItem = $null
[System.Windows.Forms.SplitContainer]$splitContainer1 = $null
[System.Windows.Forms.SplitContainer]$splitContainer2 = $null
[System.Windows.Forms.SplitContainer]$splitContainer3 = $null
[System.Windows.Forms.DataGridView]$dataGridView1 = $null
[System.Windows.Forms.Button]$button1 = $null
function InitializeComponent
{
$statusStrip1 = (New-Object -TypeName System.Windows.Forms.StatusStrip)
$menuStrip1 = (New-Object -TypeName System.Windows.Forms.MenuStrip)
$fileToolStripMenuItem = (New-Object -TypeName System.Windows.Forms.ToolStripMenuItem)
$splitContainer1 = (New-Object -TypeName System.Windows.Forms.SplitContainer)
$splitContainer2 = (New-Object -TypeName System.Windows.Forms.SplitContainer)
$splitContainer3 = (New-Object -TypeName System.Windows.Forms.SplitContainer)
$dataGridView1 = (New-Object -TypeName System.Windows.Forms.DataGridView)
$menuStrip1.SuspendLayout()
([System.ComponentModel.ISupportInitialize]$splitContainer1).BeginInit()
$splitContainer1.Panel1.SuspendLayout()
$splitContainer1.SuspendLayout()
([System.ComponentModel.ISupportInitialize]$splitContainer2).BeginInit()
$splitContainer2.Panel1.SuspendLayout()
$splitContainer2.SuspendLayout()
([System.ComponentModel.ISupportInitialize]$splitContainer3).BeginInit()
$splitContainer3.Panel1.SuspendLayout()
$splitContainer3.SuspendLayout()
([System.ComponentModel.ISupportInitialize]$dataGridView1).BeginInit()
$MainForm.SuspendLayout()
#
#statusStrip1
#
$statusStrip1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]0,[System.Int32]542))
$statusStrip1.Name = [string]'statusStrip1'
$statusStrip1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]823,[System.Int32]22))
$statusStrip1.TabIndex = [System.Int32]0
$statusStrip1.Text = [string]'statusStrip1'
#
#menuStrip1
#
$menuStrip1.Items.AddRange([System.Windows.Forms.ToolStripItem[]]@($fileToolStripMenuItem))
$menuStrip1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]0,[System.Int32]0))
$menuStrip1.Name = [string]'menuStrip1'
$menuStrip1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]823,[System.Int32]24))
$menuStrip1.TabIndex = [System.Int32]1
$menuStrip1.Text = [string]'menuStrip1'
#
#fileToolStripMenuItem
#
$fileToolStripMenuItem.Name = [string]'fileToolStripMenuItem'
$fileToolStripMenuItem.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]37,[System.Int32]20))
$fileToolStripMenuItem.Text = [string]'File'
#
#splitContainer1
#
$splitContainer1.Dock = [System.Windows.Forms.DockStyle]::Fill
$splitContainer1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]0,[System.Int32]24))
$splitContainer1.Name = [string]'splitContainer1'
#
#splitContainer1.Panel1
#
$splitContainer1.Panel1.Controls.Add($splitContainer2)
$splitContainer1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]823,[System.Int32]518))
$splitContainer1.SplitterDistance = [System.Int32]274
$splitContainer1.TabIndex = [System.Int32]2
#
#splitContainer2
#
$splitContainer2.Dock = [System.Windows.Forms.DockStyle]::Fill
$splitContainer2.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]0,[System.Int32]0))
$splitContainer2.Name = [string]'splitContainer2'
$splitContainer2.Orientation = [System.Windows.Forms.Orientation]::Horizontal
#
#splitContainer2.Panel1
#
$splitContainer2.Panel1.Controls.Add($splitContainer3)
#
#splitContainer2.Panel2
#
$splitContainer2.Panel2.add_Paint($splitContainer2_Panel2_Paint)
$splitContainer2.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]274,[System.Int32]518))
$splitContainer2.SplitterDistance = [System.Int32]271
$splitContainer2.TabIndex = [System.Int32]0
#
#splitContainer3
#
$splitContainer3.Dock = [System.Windows.Forms.DockStyle]::Fill
$splitContainer3.IsSplitterFixed = $true
$splitContainer3.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]0,[System.Int32]0))
$splitContainer3.Name = [string]'splitContainer3'
$splitContainer3.Orientation = [System.Windows.Forms.Orientation]::Horizontal
#
#splitContainer3.Panel1
#
$splitContainer3.Panel1.Controls.Add($dataGridView1)
$splitContainer3.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]274,[System.Int32]271))
$splitContainer3.SplitterDistance = [System.Int32]200
$splitContainer3.TabIndex = [System.Int32]0
#
#dataGridView1
#
$dataGridView1.ColumnHeadersHeightSizeMode = [System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode]::AutoSize
$dataGridView1.Dock = [System.Windows.Forms.DockStyle]::Fill
$dataGridView1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]0,[System.Int32]0))
$dataGridView1.Name = [string]'dataGridView1'
$dataGridView1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]274,[System.Int32]200))
$dataGridView1.TabIndex = [System.Int32]0
#
#MainForm
#
$MainForm.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]823,[System.Int32]564))
$MainForm.Controls.Add($splitContainer1)
$MainForm.Controls.Add($statusStrip1)
$MainForm.Controls.Add($menuStrip1)
$MainForm.MainMenuStrip = $menuStrip1
$MainForm.Name = [string]'MainForm'
$MainForm.add_Load($listView1_SelectedIndexChanged)
$menuStrip1.ResumeLayout($false)
$menuStrip1.PerformLayout()
$splitContainer1.Panel1.ResumeLayout($false)
([System.ComponentModel.ISupportInitialize]$splitContainer1).EndInit()
$splitContainer1.ResumeLayout($false)
$splitContainer2.Panel1.ResumeLayout($false)
([System.ComponentModel.ISupportInitialize]$splitContainer2).EndInit()
$splitContainer2.ResumeLayout($false)
$splitContainer3.Panel1.ResumeLayout($false)
([System.ComponentModel.ISupportInitialize]$splitContainer3).EndInit()
$splitContainer3.ResumeLayout($false)
([System.ComponentModel.ISupportInitialize]$dataGridView1).EndInit()
$MainForm.ResumeLayout($false)
$MainForm.PerformLayout()
Add-Member -InputObject $MainForm -Name base -Value $base -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name statusStrip1 -Value $statusStrip1 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name menuStrip1 -Value $menuStrip1 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name fileToolStripMenuItem -Value $fileToolStripMenuItem -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name splitContainer1 -Value $splitContainer1 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name splitContainer2 -Value $splitContainer2 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name splitContainer3 -Value $splitContainer3 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name dataGridView1 -Value $dataGridView1 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name button1 -Value $button1 -MemberType NoteProperty
}
. InitializeComponent
