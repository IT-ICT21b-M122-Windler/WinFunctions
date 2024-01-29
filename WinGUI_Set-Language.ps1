# Windows Functions Gui
# This script is to set Windows Functions from the Module .\WinFunctions.psm1

If($null -ne $SelectedListBoxItem){Remove-Variable -Name SelectedListBoxItem}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Windows Functions'
$form.Size = New-Object System.Drawing.Size(400, 300)
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
$listBox.Size = New-Object System.Drawing.Size(345, 20)
$listbox.Font = New-Object System.Drawing.Font("Calibri", 12, [System.Drawing.FontStyle]::Bold) # Adjust the font and size
$listBox.Height = 150

[void] $listBox.Items.Add('Set-Language Custom') # Set-Language -Custom
[void] $listBox.Items.Add('Set-Language Swiss German') 
[void] $listBox.Items.Add('Set-Language German')
[void] $listBox.Items.Add('Set-Language English US')
[void] $listBox.Items.Add('Set-Language English UK')
[void] $listBox.Items.Add('Set-Language French')
[void] $listBox.Items.Add('Set-Language Custom Format')
[void] $listBox.Items.Add('Set-Language Custom and Custom Format')
[void] $listBox.Items.Add('Set-Language Format Short and .')
[void] $listBox.Items.Add('Set-Language Format Long and ,')

$form.Controls.Add($listBox)

$form.Topmost = $true

$result = $form.ShowDialog()

Import-Module .\WinFunctions.psm1

if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    $SelectedListBoxItem = $listBox.SelectedItem
    $SelectedListBoxItem
}
if ($SelectedListBoxItem -eq 'Set-Language Custom'){
    Set-Language -Custom
}
if ($SelectedListBoxItem -eq 'Set-Language Swiss German'){
    Set-Language -Region Schweiz -RegionalFormat de-CH -DisplayLanguage de-CH -Language de-CH -KeyboardLanguage de-CH -KeyboardLayout de-CH
}
if ($SelectedListBoxItem -eq 'Set-Language German'){
    Set-Language -Region Deutschland -RegionalFormat de-DE -DisplayLanguage de-DE -Language de-DE -KeyboardLanguage de-DE -KeyboardLayout de-DE
}
if ($SelectedListBoxItem -eq 'Set-Language English US'){
    Set-Language -Region UnitedStates -RegionalFormat en-US -DisplayLanguage en-US -Language en-US -KeyboardLanguage en-US -KeyboardLayout en-US
}
if ($SelectedListBoxItem -eq 'Set-Language English UK'){
    Set-Language -Region UnitedKingdom -RegionalFormat en-GB -DisplayLanguage en-GB -Language en-GB -KeyboardLanguage en-GB -KeyboardLayout en-GB
}
if ($SelectedListBoxItem -eq 'Set-Language French'){
    Set-Language -Region France -RegionalFormat fr-FR -DisplayLanguage fr-FR -Language fr-FR -KeyboardLanguage fr-FR -KeyboardLayout fr-FR
}
if ($SelectedListBoxItem -eq 'Set-Language Custom Format'){
    Set-Language -CustomFormat
}
if ($SelectedListBoxItem -eq 'Set-Language Custom and Custom Format'){
    Set-Language -Custom -CustomFormat
}
if ($SelectedListBoxItem -eq 'Set-Language Format Short and .'){
    Set-Language -ShortDate Short -LongDate Short -DecimalSeparator "."
}
if ($SelectedListBoxItem -eq 'Set-Language Format long and ,'){
    Set-Language -ShortDate Long -LongDate Long -DecimalSeparator "."
}
if ($SelectedListBoxItem -eq 'Set-Language Format Short / Long and .'){
    Set-Language -ShortDate Short -LongDate Long -DecimalSeparator "."
}

Pause