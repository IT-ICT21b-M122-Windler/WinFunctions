    param (
        [Parameter(Mandatory = $false, HelpMessage = "Set the Language and Format on Windows")]
        [ValidateSet("chDE", "enUS")]
        [string]$Language = "chDE",

        [Parameter(Mandatory = $false, HelpMessage = "Set the Land on Windows")]
        [ValidateSet("ch", "us", "*")]
        [string]$Land = "de",

        [Parameter(Mandatory = $false, HelpMessage = "Set the Time Format on Windows")]
        [ValidateSet("Long dd/MM/yyyy", "Short dd/MM/yy", "USLong yyyy/MM/dd", "USShort yy/MM/dd")]
        $ShortDateFormat = "Long dd/MM/yyyy",

        [Parameter(Mandatory = $false, HelpMessage = "Set the Time Format on Windows")]
        [ValidateSet("Long HH/MM/ss", "Short HH/MM", "USLong yyyy/MM/dd", "USShort yy/MM/dd")]
        $LongDateFormat = "Long dd/MM/yyyy",

        [Parameter(Mandatory = $false, HelpMessage = "Set the Time Format on Windows")]
        [ValidateSet(".", ",")]
        $DecimalSeperator = "."

        #etc.

    )
# Zugriff auf die CultureInfo-Klasse des .NET Frameworks, um alle Kulturen zu erhalten
$cultures = [System.Globalization.CultureInfo]::GetCultures([System.Globalization.CultureTypes]::AllCultures)

# Durchsuche alle Kulturen, um die entsprechende zu finden
foreach ($culture in $cultures) {
    try {
        $RegionInfos = New-Object System.Globalization.RegionInfo($culture.Name)
        if ($RegionInfos.EnglishName -eq $Land -or $RegionInfos.NativeName -eq $Land) {
            $landCode = $RegionInfos.TwoLetterISORegionName
            break
        }
    } catch {
        # Ignoriere Fehler und fahre mit der nächsten Kultur fort
        continue
    }
}

# Überprüfe, ob ein Ländercode gefunden wurde
if ($landCode) {
    # Erstelle ein RegionInfo-Objekt für den gefundenen Ländercode
    $regionInfo = New-Object System.Globalization.RegionInfo $landCode

    # Gib die GeoID für das Land aus
    Write-Host "GeoID für $($regionInfo.DisplayName): $($regionInfo.GeoId)"
} else {
    Write-Host "Kein Ländercode für $Land gefunden"
}

$DecimalSeparator = "."
$GeoId = 223 # Switzerland
$KeyboardLayout = "0409:00000807" # 0409 = Language en-US, 00000807 = Keyboard de-CH

#--------------------------------Additional Modules--------------------------------

Import-Module international

#------------------------------------Constants-------------------------------------

$RegPath = "HKCU:\Control Panel\International"

#---------------------------------Implementation-----------------------------------

# - Land$Land
# Land oder Land$Land
Write-Host "Changing Land$Land..."
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
