# This Module is for Windows Function like changing the Language

function Set-Language {
    param (
        [Parameter(Mandatory = $false, HelpMessage = "Set the Language and Format on Windows")]
        [ValidateSet("chDE", "enUS")]
        [string]$Language = "chDE",

        [Parameter(Mandatory = $false, HelpMessage = "Set the Language and Format on Windows")]
        [ValidateSet("Switzerland", "UnitedStates")]
        [string]$Region = "Switzerland",

        [Parameter(Mandatory = $false, HelpMessage = "Set the Language and Format on Windows")]
        [ValidateSet("Long dd/MM/yyyy", "Short dd/MM/yy", "USLong yyyy/MM/dd", "USShort yy/MM/dd")]
        $DateFormat = "Long dd/MM/yyyy"
    )

$DateFormatshort = "yyyy/MM/dd"
$DateFormatlong = "yyyy/MM/dd"
$DecimalSeparator = "."
$GeoId = 223, # Switzerland
$KeyboardLayout = "0409:00000807" # 0409 = Language en-US, 00000807 = Keyboard de-CH

#--------------------------------Additional Modules--------------------------------

Import-Module international

#------------------------------------Constants-------------------------------------

$RegPath = "HKCU:\Control Panel\International"

#---------------------------------Implementation-----------------------------------

# - Region
# Land oder Region
Write-Host "Changing Region..."
Set-WinHomeLocation -GeoId $GeoId

# Regionales Format
Write-Host "Changing Regional Formats..."
Set-Culture -CultureInfo $Language

# - Sprache
# Windows-Anzeigesprache
Write-Host "Changing Display Language..."
Set-WinUILanguageOverride -Language $Language

# Bevorzugte Sprache
Write-Host "Changing preferred Language"
$languageList = New-WinUserLanguageList $Language
$languageList[0].Handwriting = 0

# Keyboard Layout
Write-Host "Changing Keyboard Layout..."
$languageList[0].InputMethodTips.Clear()
$languageList[0].InputMethodTips.Add($KeyboardLayout)
Set-WinUserLanguageList $languagelist -Confirm:$false -Force

# Change Formats
Write-Host "Changing Format Settings..."
$formatKeys = @{
    sDecimal = $DecimalSeparator
    sShortDate = $DateFormatshort
    sLongDate = $DateFormatlong
}

$formatKeys.keys | ForEach-Object {
    Set-ItemProperty -Path $RegPath -Name $_ -Value $formatKeys[$_]
}

Write-Host "`nSuccessfully changed the language settings!"
    
}
function Set-Startmenu {
    param (
        $Device = ""
    )
    If($Device -eq "StandardPC"){
        #Script
    }
}
function Set- {
    param (
        OptionalParameters
    )
    
}