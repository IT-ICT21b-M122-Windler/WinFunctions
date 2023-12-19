# This Module is for Windows Function like changing the Language

function Set-Language {
    param (
        [Parameter(Mandatory = $false, HelpMessage = "Set the Language and Format on Windows (ch-DE, en-US etc.)")]
        [string]$Language = " ",
        [Parameter(Mandatory = $false, HelpMessage = "Set the Region on Windows")]
        [string]$Land = " ",

        [Parameter(Mandatory = $false, HelpMessage = "Set the Keyboard Language on Windows")]
        [string]$KeyboardLanguage = " ",
        [Parameter(Mandatory = $false, HelpMessage = "Set the Keyboard Layout on Windows")]
        [string]$KeyboardLayout = " ",

        [Parameter(Mandatory = $false, HelpMessage = "Set the Time Format on Windows")]
        [ValidateSet("Long dd/MM/yyyy", "Short dd/MM/yy", "USLong yyyy/MM/dd", "USShort yy/MM/dd")]
        $ShortDateFormat = " ",
        [Parameter(Mandatory = $false, HelpMessage = "Set the Time Format on Windows")]
        [ValidateSet("Long dd/MM/yyyy", "Short dd/MM/yy", "USLong yyyy/MM/dd", "USShort yy/MM/dd")]
        $LongDateFormat = " ",

        [Parameter(Mandatory = $false, HelpMessage = "Set the Time Format on Windows")]
        [ValidateSet(".", ",")]
        $DecimalSeperator = " "

        #etc.

    )
    while ($Language -eq " "){
        $Language = Read-Host "Set Language on Windows, Format: ch-DE"
    }
    while ($Land -eq " "){
        $Land = Read-Host "Set Region on Windows, Format: Schweiz or Switzerland"
    }
    while ($KeyboardLanguage -eq " "){
        $KeyboardLanguage = Read-Host "Set Keyboard Language on Windows, Format: Deutsch (Schweiz) or English (United States)"
    }
    while ($KeyboardLayout -eq " "){
        $KeyboardLayout = Read-Host "Set Keyboard Layout on Windows, Format: Deutsch (Schweiz) or English (United States)"
    }
    while ($ShortDateFormat -eq " "){
        $ShortDateFormat = Read-Host "Set Short Date Format on Windows, Format: Short dd/MM/yy"
    }
    while ($LongDateFormat -eq " "){
        $LongDateFormat = Read-Host "Set Short Date Format on Windows, Format: Long dd/MM/yyyy"
    }
    while ($DecimalSeperator -eq " "){
        $DecimalSeperator = Read-Host "Set Decimal Seperator on Windows, Format: . or ,"
    }

    # ---------------- Find GeoID ----------------
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
        }
        catch {
            # Ignoriere Fehler und fahre mit der nächsten Kultur fort
            continue
        }
    }

    # Überprüfe, ob ein Ländercode gefunden wurde
    if ($landCode) {
        # Erstelle ein RegionInfo-Objekt für den gefundenen Ländercode und dpeichere diesen in $GeoID
        $regionInfo = New-Object System.Globalization.RegionInfo $landCode
        $GeoID = $regionInfo.GeoId
    }
    else {
        Write-Host "Kein Ländercode für $Land gefunden"
    }
    # ---------------- Find Keyboard LCID ----------------
    # Ermittle den passenden Culture-Code für die Sprache und das Layout
    $keyboardLanguageCultureCode = [System.Globalization.CultureInfo]::GetCultures([System.Globalization.CultureTypes]::AllCultures) |
    Where-Object { $_.EnglishName -eq $KeyboardLanguage -or $_.NativeName -eq $KeyboardLanguage } |
    Select-Object -ExpandProperty Name -First 1
    $keyboardLayoutCultureCode = [System.Globalization.CultureInfo]::GetCultures([System.Globalization.CultureTypes]::AllCultures) |
    Where-Object { $_.EnglishName -eq $KeyboardLayout -or $_.NativeName -eq $KeyboardLayout } |
    Select-Object -ExpandProperty Name -First 1
    # Überprüfe, ob ein KeyboardLanguage CultureCode gefunden wurde
    if ($keyboardLanguageCultureCode) {
        $cultureInfo = New-Object System.Globalization.CultureInfo $keyboardLanguageCultureCode
        # Ermittle die KeyboardLanguageId und Zeige die KeyboardLanguageId an
        $keyboardLanguageId = "0" + $cultureInfo.KeyboardLayoutId.ToString("X")
    }
    else {
        Write-Host "Kein Culture-Code für $KeyboardLanguage gefunde"
    }
    # Überprüfe, ob ein KeyboardLayout CultureCode gefunden wurde
    if ($keyboardLayoutCultureCode) {
        $cultureInfo = New-Object System.Globalization.CultureInfo $keyboardLayoutCultureCode
        # Ermittle die KeyboardLayoutId und Zeige die KeyboardLayoutId an
        $keyboardLayoutId = "0000" + $cultureInfo.KeyboardLayoutId.ToString("X")
    }
    else {
        Write-Host "Kein Culture-Code für $KeyboardLayout gefunde"
    }
    $imeCode = $keyboardLanguageId + ":" + $keyboardLayoutId
    #$imeCode = $regionInfo.GeoId.ToString("X4") + ":" + $keyboardLayoutId

    # ---------------- Bestätigung ----------------
    # Ausgabe der gefundenen Informationen
    Write-Host "Your Input:"
    Write-Host "Language: $Language, `nRegion: $GeoID ($Land, $($regionInfo.DisplayName)), `nKeyboard Language $KeyboardLanguage and Layout $KeyboardLayout : $imeCode `nShortDateFormat: $ShortDateFormat, `nLongDateFormat: $LongDateFormat, `nDecimalSeperator: $DecimalSeperator"
    
    # ---------------- Variablen und Module ----------------
    Import-Module international
    $RegPath = "HKCU:\Control Panel\International"

    # ---------------- Implementierung ----------------
    # Region anpassen
    Write-Host "Changing Region..."
    Set-WinHomeLocation -GeoId $GeoId
    #Reionales Format anpassen
    Write-Host "Changing Regional Formats..."
    Set-Culture -CultureInfo $Language
    # Anzeigesprache anpassen
    Write-Host "Changing Display Language..."
    Set-WinUILanguageOverride -Language $Language
    # Bevorzugte Sprache anpassen
    Write-Host "Changing preferred Language..."
    $languageList = New-WinUserLanguageList $Language
    $languageList[0].Handwriting = 0
    # Tastaturlayout anpassen
    Write-Host "Changing Keyboard Layout..."
    $languageList[0].InputMethodTips.Clear()
    $languageList[0].InputMethodTips.Add($imeCode)
    Set-WinUserLanguageList $languagelist -Confirm:$false -Force
    # Format anpassen
    Write-Host "Changing Format Settings..."
    $formatKeys = @{
        sDecimal = $DecimalSeperator
        sShortDate = $ShortDateFormat
        sLongDate = $LongDateFormat
    }
    $formatKeys.keys | ForEach-Object {
        Set-ItemProperty -Path $RegPath -Name $_ -Value $formatKeys[$_]
    }
    Write-Host "`nSuccessfully changed the language settings!"
}
function Set-Taskbar {
    param (
        $Device = ""
    )
    If($Device -eq "StandardPC"){
        #Script
    }
}
function Set-Desktop {
    param (
        $Device = ""
    )
    If($Device -eq "StandardPC"){
        #Script
    }
}
function Set-Wallpaper {
    param (
        $Device = ""
    )
    If($Device -eq "StandardPC"){
        #Script
    }
}
function Set-Startmenu {
    param (
        $Device = ""
    )
    If($Device -eq "StandardPC"){
        #Script
    }
}
