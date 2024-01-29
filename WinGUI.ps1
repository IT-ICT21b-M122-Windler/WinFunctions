# Windows Functions Gui
# This script is to set Windows Functions from the Module .\WinFunctions.psm1

If($null -ne $SelectedListBoxItem){Remove-Variable -Name SelectedListBoxItem}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Windows Functions'
$form.Size = New-Object System.Drawing.Size(350, 300)
$form.StartPosition = 'CenterScreen'

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(78, 10)
$label.Size = New-Object System.Drawing.Size(280, 20)
$label.Text = 'Windows Functions'
$label.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold) # Adjust the font and size
$form.Controls.Add($label)

$label2 = New-Object System.Windows.Forms.Label
$label2.Location = New-Object System.Drawing.Point(68, 40)
$label2.Size = New-Object System.Drawing.Size(280, 20)
$label2.Text = 'Please select an Option:'
$label2.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold) # Adjust the font and size
$form.Controls.Add($label2)

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(240, 220)
$okButton.Size = New-Object System.Drawing.Size(75, 23)
$okButton.Text = 'Run'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(140, 220)
$cancelButton.Size = New-Object System.Drawing.Size(75, 23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(20, 60)
$listBox.Size = New-Object System.Drawing.Size(295, 20)
$listbox.Font = New-Object System.Drawing.Font("Calibri", 12, [System.Drawing.FontStyle]::Bold) # Adjust the font and size
$listBox.Height = 150

[void] $listBox.Items.Add('Set-Language')
[void] $listBox.Items.Add('Get-Startmenu')
[void] $listBox.Items.Add('Set-Startmenu')
[void] $listBox.Items.Add('Connect-Drive')
[void] $listBox.Items.Add('Set-NetAdapter')

$form.Controls.Add($listBox)

$form.Topmost = $true

$result = $form.ShowDialog()

Import-Module .\WinFunctions.psm1

if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    $SelectedListBoxItem = $listBox.SelectedItem
    $SelectedListBoxItem
}
if ($SelectedListBoxItem -eq 'Set-Language'){
    Start-Process powershell -ArgumentList "-file .\WinGUI_Set-Language.ps1"
}
if ($SelectedListBoxItem -eq 'Get-Startmenu'){
    Get-Startmenu
}
if ($SelectedListBoxItem -eq 'Set-Startmenu'){
    Set-Startmenu
}
if ($SelectedListBoxItem -eq 'Connect-Drive'){
    Connect-Drive
}
if ($SelectedListBoxItem -eq 'Set-NetAdapter'){
    Start-Process powershell -Verb runAs -ArgumentList "Import-Module $PSScriptRoot\WinFunctions.psm1; Set-NetworkAdapter"

}

Pause