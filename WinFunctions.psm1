# This Module is for Windows Functions like changing the Language
# Administrative Functions, Write-Log, Get-PowerShellIsAdmin

# Check if PowerShell is running on Windows
if ([System.Environment]::OSVersion.Platform -eq "Win32NT") {
    Write-Host "This Powershell is running on Windows."
    Write-Host "Importing Module"
} else {
    Write-Host "This Powershell is not running on Windows."
    Write-Host "This script is intended for Windows 10."
    Write-Host "You can delete this script."
    Write-Host "With the command Remove-Module WinFunctions"
    exit
}# Check if PowerShell is running on Windows

# Import Module for Administrative Functions
Import-Module $PSScriptRoot\Administrativ.psm1

# Functions for Windows Functions
function Set-Language {
    param (
        [Parameter(Mandatory = $false, HelpMessage = "Change Language Custom")]
        [switch]$Custom, # To set all Language and Keyboard Parameters to Invalid
        [Parameter(Mandatory = $false, HelpMessage = "Change Format Custom")]
        [switch]$CustomFormat, # To set all Format Parameters to Invalid
        #Region
        [Parameter(Mandatory = $false, HelpMessage = "Set the Region on Windows")]
        [string]$Region= "Invalid", #Custom do while loop, Native Name or English Name
        [Parameter(Mandatory = $false, HelpMessage = "Set the Reginal Format on Windows (de-CH, en-US etc.)")]
        [string]$RegionalFormat = "Invalid", #Custom do while loop, de-CH, en-US etc.

        #Sprache
        [Parameter(Mandatory = $false, HelpMessage = "Set the Language Override Windows (de-CH, en-US etc.)")]
        [string]$DisplayLanguage = "Invalid", #Custom do while loop, de-CH, en-US etc.
        [Parameter(Mandatory = $false, HelpMessage = "Set the Prefered Language Windows (de-CH, en-US etc.)")]
        [string]$Language = "Invalid", #Custom do while loop, de-CH, en-US etc.

        [Parameter(Mandatory = $false, HelpMessage = "Set the Keyboard Language on Windows (de-CH, en-US etc.)")]
        [string]$KeyboardLanguage = "Invalid", #Custom do while loop, de-CH, en-US etc.
        [Parameter(Mandatory = $false, HelpMessage = "Set the Keyboard Layout on Windows (de-CH, en-US etc.)")]
        [string]$KeyboardLayout = "Invalid", #Custom do while loop, de-CH, en-US etc.

        #Format
        [Parameter(Mandatory = $false, HelpMessage = "Set the Time Format on Windows")]
        [ValidateSet("Long", "Short", "USLong", "USShort")]
        $ShortDate = "Invalid", #Custom do while loop, Long dd/MM/yyyy, Short dd/MM/yy, USLong yyyy/MM/dd, USShort yy/MM/dd
        [Parameter(Mandatory = $false, HelpMessage = "Set the Time Format on Windows")]
        [ValidateSet("Long", "Short", "USLong", "USShort")]
        $LongDate = "Invalid", #Custom do while loop, Long dd/MM/yyyy, Short dd/MM/yy, USLong yyyy/MM/dd, USShort yy/MM/dd
        [Parameter(Mandatory = $false, HelpMessage = "Set the Time Format on Windows")]
        [ValidateSet(".", ",", "Invalid", " ", "Custom")]
        $DecimalSeparator =  "Invalid" #Custom do while loop, . or ,
        #etc nach Kundenwunsch...
    )

    # ---------------- Protokollierung ----------------
    $ActualDate = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    # Transkript file
    Start-Transcript -Path "$PSScriptRoot\logging\transcripts\$($ActualDate)set-Language-transcript.txt"
    # Log file
    $LogOutputpath =  "$PSScriptRoot\logging\logs\function-set-language.log"

    # ---------------- Variablen und Module ----------------
    Import-Module international
    $RegPath = "HKCU:\Control Panel\International"
    Write-Log "Import-Module international" -File $LogOutputpath
    Write-Log "RegPath: $RegPath" -File $LogOutputpath

    # ---------------- Getting current Informations ----------------
    # Output - Your curent Language settings
    # Region
    Write-Host "Your current Language and Format settings"
    $CurrentRegion = Get-WinHomeLocation
    Write-Host "Region: $($CurrentRegion.HomeLocation) $($CurrentRegion.GeoID) " # Region
    Write-Host "Regional Format: $(Get-Culture)" # Regional Format
    # Language
    $CurrentDisplayLanguage = Get-WinUILanguageOverride # Display Language
    Write-Host "Display Language: $($CurrentDisplayLanguage.Name)" # Display Language
    $CurrentLanguage = Get-WinUserLanguageList # Language
    Write-Host "Current Language: $($CurrentLanguage[0].LanguageTag)" # Language
    Write-Host "Current Keyboard: $($CurrentLanguage[0].InputMethodTips)" # Keyboard Layout
    # Format
    $intlSettings = Get-ItemProperty -Path "HKCU:\Control Panel\International"
    Write-Host "Date Format short: $($intlSettings.sShortDate)"
    Write-Host "Date Format long: $($intlSettings.sLongDate)"
    Write-Host "Decimal Separator: $($intlSettings.sDecimal)"
    # Log - Your curent Language settings
    Write-Log -Message "Your current Language and Format settings" -File $LogOutputpath
    Write-Log -Message "Region: $(Get-WinHomeLocation)" -File $LogOutputpath
    Write-Log -Message "Regional Format: $(Get-Culture)" -File $LogOutputpath
    Write-Log -Message "Display Language: $($CurrentDisplayLanguage.Name)" -File $LogOutputpath
    Write-Log -Message "Current Language: $($CurrentLanguage[0].LanguageTag)" -File $LogOutputpath
    Write-Log -Message "Current Keyboard: $($CurrentLanguage[0].InputMethodTips)" -File $LogOutputpath
    Write-Log -Message "Date Format short: $($intlSettings.sShortDate)" -File $LogOutputpath
    Write-Log -Message "Date Format long: $($intlSettings.sLongDate)" -File $LogOutputpath
    Write-Log -Message "Decimal Separator: $($intlSettings.sDecimal)" -File $LogOutputpath

    # ---------------- Check Parameters ----------------
    Write-Host "Set the Language on Windows"
    Write-Log -Message "Set the Language on Windows" -File $LogOutputpath

    # Check if Custom is set
    if ($Custom) {
        $Region = "Custom"
        $RegionalFormat = "Custom"
        $DisplayLanguage = "Custom"
        $Language = "Custom"
        $KeyboardLanguage = "Custom"
        $KeyboardLayout = "Custom"
    }
    # Check if CustomFormat is set
    if ($CustomFormat) {
        $ShortDateFormat = "Custom"
        $LongDateFormat = "Custom"
        $DecimalSeparator = "Custom"
    }

    while ($Region -eq "Custom"){
        $Region = Read-Host "Set Region on Windows, Native Name or English Name"
    }
    while ($RegionalFormat -eq "Custom"){
        $RegionalFormat = Read-Host "Set Regional Format on Windows, Format: de-CH, en-US etc."
    }
    while ($DisplayLanguage -eq "Custom"){
        $DisplayLanguage = Read-Host "Set the Language Override Windows, Format: de-CH, en-US etc."
    }
    while ($Language -eq "Custom"){
        $Language = Read-Host "Set the Prefered Language on Windows, Format: de-CH, en-US etc."
    }
    while ($KeyboardLanguage -eq "Custom"){
        $KeyboardLanguage = Read-Host "Set Keyboard Language on Windows, Format: de-CH, en-US etc."
    }
    while ($KeyboardLayout -eq "Custom"){
        $KeyboardLayout = Read-Host "Set Keyboard Layout on Windows, Format: de-CH, en-US etc."
    }
    while ($ShortDate -eq "Custom"){
        $ShortDateFormat = Read-Host "Set Short Date Format on Windows, Format: Short dd/MM/yy"
    }
    while ($LongDate -eq "Custom"){
        $LongDateFormat = Read-Host "Set Short Date Format on Windows, Format: Long dd/MM/yyyy"
    }
    while ($DecimalSeparator -eq "Custom"){
        $DecimalSeparator = Read-Host "Set Decimal Seperator on Windows, Format: . or ,"
    }

    # ---------------- Find GeoID ----------------
    function FindGeoID {
        param (
            [string]$Region
        )
        $FoundGeoID = "false"
        while ($FoundGeoID -eq "false"){
            Write-Host "Searching GeoID..."
            Write-log -Message "Searching GeoID..." -File $LogOutputpath
            # Zugriff auf die CultureInfo-Klasse des .NET Frameworks, um alle Kulturen zu erhalten
            $cultures = [System.Globalization.CultureInfo]::GetCultures([System.Globalization.CultureTypes]::AllCultures)
            foreach ($culture in $cultures) { # Durchsuche alle Kulturen, um die entsprechende zu finden
                try {
                    $RegionInfos = New-Object System.Globalization.RegionInfo($culture.Name)
                    if ($RegionInfos.EnglishName -eq $Region -or $RegionInfos.NativeName -eq $Region) {
                        $landCode = $RegionInfos.TwoLetterISORegionName
                        break
                    }
                }
                catch {
                    continue # Ignoriere Fehler und fahre mit der nächsten Kultur fort
                }
            }
            if ($landCode) { # Überprüfe, ob ein Ländercode gefunden wurde
                # Erstelle ein RegionInfo-Objekt für den gefundenen Ländercode und speichere diesen in $GeoID
                $regionInfo = New-Object System.Globalization.RegionInfo $landCode
                $GeoID = $regionInfo.GeoId
                Write-Output $GeoID
                Write-Host "$($Region): GeoID ist $GeoID"
                Write-Log -Message "$($Region): GeoID ist $GeoID" -File $LogOutputpath
                $FoundGeoID = "true"
            } else { # Falls kein Ländercode gefunden wurde, gib eine Fehlermeldung aus
                Write-Host "$($Region): Keine GeoID gefunden"
                Write-Log -Message "$($Region): Keine GeoID gefunden" -File $LogOutputpath
                $Region = Read-Host "Set Region on Windows, Native Name or English Name"
                $FoundGeoID = "false"
            }
        }
    }
    if ($Region -ne "Invalid") {
        $GeoID = FindGeoID -Region $Region
    }
    # ---------------- Find Keyboard imeCode ----------------
    function FindKeyboardimeCode {
        param (
            [string]$KeyboardLanguage,
            [string]$KeyboardLayout
        )
        $FoundKeyboardimeCode = "false"
        while ($FoundKeyboardimeCode -eq "false"){
            Write-Host "Searching Keyboard LCID/imeCode..."
            Write-Log -Message "Searching Keyboard LCID/imeCode..." -File $LogOutputpath
            # Ermittle den passenden Culture-Code für die Sprache und das Layout
            $KeyboardLanguageObject = [System.Globalization.CultureInfo]::GetCultures([System.Globalization.CultureTypes]::AllCultures) | Where-Object { $_.Name -eq $KeyboardLanguage }
            $KeyboardLanguageObjectName = $KeyboardLanguageObject.Name
            if ($KeyboardLanguageObjectName) { # Überprüfe, ob ein KeyboardLanguage CultureCode gefunden wurde
                $keyboardLanguageId = "0" + $KeyboardLanguageObject.KeyboardLayoutId.ToString("X")
                $FoundKeyboardLanguageId = "true"
            } else {
                Write-Host "Kein imeCode für die Keyboard Sprache $KeyboardLanguage gefunden"
                $KeyboardLanguage = Read-Host "Set Keyboard Language on Windows, Format: de-CH, en-US etc."
                $FoundKeyboardLanguageId = "false"
            }
            $KeyboardLayoutObject = [System.Globalization.CultureInfo]::GetCultures([System.Globalization.CultureTypes]::AllCultures) | Where-Object { $_.Name -eq $KeyboardLayout }
            $KeyboardLayoutObjectName = $KeyboardLayoutObject.Name
            if ($KeyboardLayoutObjectName) { # Überprüfe, ob ein KeyboardLayout CultureCode gefunden wurde
                $keyboardLayoutId = "0000" + $KeyboardLayoutObject.KeyboardLayoutId.ToString("X")
                $FoundKeyboardLayoutId = "true"
            } else {
                Write-Host "Kein LDIC/imeCode für das Keyborad Layout $KeyboardLayout gefunden"
                $KeyboardLayout = Read-Host "Set Keyboard Layout on Windows, Format: de-CH, en-US etc."
                $FoundKeyboardLayoutId = "false"
            }
            if (($FoundKeyboardLanguageId -eq "true") -and ($FoundKeyboardLayoutId -eq "true")){
                $imeCode = $keyboardLanguageId + ":" + $keyboardLayoutId
                Write-Output $imeCode
                Write-Host "Found Keyboard imeCode: $imeCode"
                Write-Log -Message "Found Keyboard imeCode: $imeCode" -File $LogOutputpath
                $FoundKeyboardimeCode = "true"
            } else {
                $FoundKeyboardimeCode = "false"
            }
        }
    }
    if (($KeyboardLanguage -ne "Invalid") -or ($KeyboardLayout -ne "Invalid")) {
        $imeCode = FindKeyboardimeCode -KeyboardLanguage $KeyboardLanguage -KeyboardLayout $KeyboardLayout
    }

    # ---------------- Bestätigung ----------------
    # Ausgabe der gefundenen Informationen
    Write-Host "Your Input:"
    Write-Host "Region: $GeoID ($Region)"
    Write-Host "Regional Format: $RegionalFormat"
    Write-Host "Display Language: $DisplayLanguage"
    Write-Host "Language: $Language"
    Write-Host "Keyboard: $imeCode"
    Write-Host "ShortDateFormat: $ShortDateFormat"
    Write-Host "LongDateFormat: $LongDateFormat"
    Write-Host "DecimalSeparator: $DecimalSeparator"
    # Log - Your Input
    Write-Log -Message "Your Input" -File $LogOutputpath
    Write-Log -Message "Region: $GeoID ($Region)" -File $LogOutputpath
    Write-Log -Message "Regional Format: $RegionalFormat" -File $LogOutputpath
    Write-Log -Message "Display Language: $DisplayLanguage" -File $LogOutputpath
    Write-Log -Message "Language: $Language" -File $LogOutputpath
    Write-Log -Message "Keyboard: $imeCode" -File $LogOutputpath
    Write-Log -Message "ShortDateFormat: $ShortDate" -File $LogOutputpath
    Write-Log -Message "LongDateFormat: $LongDate" -File $LogOutputpath
    Write-Log -Message "DecimalSeparator: $DecimalSeparator" -File $LogOutputpath
    # Confirm
    $Confirm = Read-Host "Do you want to continue? (y/n)"
    if ($Confirm -eq "y") {
        Write-Host "Continue..."
        Write-Log -Message "Continue..." -File $LogOutputpath
    } else {
        Write-Host "Exit..."
        Write-Log -Message "Exit..." -File $LogOutputpath
        exit
    }

    # ---------------- Implementierung ----------------
    # Region anpassen
    if (($Region -ne "Invalid") -and ($GeoID -ne "")) {
        Write-Host "Changing Region..."
        Write-Log -Message "Changing Region..." -File $LogOutputpath
        Set-WinHomeLocation -GeoId $GeoID
    }
    # Reionales Format anpassen
    if ($RegionalFormat -ne "Invalid") {
        Write-Host "Changing Regional Format..."
        Write-Log -Message "Changing Regional Format..." -File $LogOutputpath
        Set-Culture -CultureInfo $RegionalFormat
    }
    # Anzeigesprache anpassen
    if ($DisplayLanguage -ne "Invalid") {
        # Prüfen ob die Sprache bereits installiert ist
        Write-Host "Checking if Language is installed..."
        Write-Log -Message "Checking if Language is installed..." -File $LogOutputpath

        $DisplayLanguageInstalled = Get-InstalledLanguage -Language $DisplayLanguage
        if ($DisplayLanguageInstalled -eq $null) {
            Write-Host "Display Language $DisplayLanguage is not installed"
            Write-Log -Message "Display Language $DisplayLanguage is not installed" -File $LogOutputpath
            Install-Language -Language $DisplayLanguage
        } else {
            Write-Host "Display Language $DisplayLanguage is installed"
            Write-Log -Message "Display Language $DisplayLanguage is installed" -File $LogOutputpath
        }
        # Anzeigesprache anpassen
        Write-Host "Changing Display Language..."
        Write-Log -Message "Changing Display Language..." -File $LogOutputpath
        Set-WinUILanguageOverride -Language $DisplayLanguage
    }
    # Sprache anpassen
    if ($Language -ne "Invalid") {
        # Prüfen ob die Sprache bereits installiert ist
        Write-Host "Checking if Language is installed..."
        Write-Log -Message "Checking if Language is installed..." -File $LogOutputpath

        $LanguageInstalled = Get-InstalledLanguage -Language $Language
        if ($LanguageInstalled -eq $null) {
            Write-Host "Language $Language is not installed"
            Write-Log -Message "Language $Language is not installed" -File $LogOutputpath
            Install-Language -Language $Language
        } else {
            Write-Host "Language $Language is installed"
            Write-Log -Message "Language $Language is installed" -File $LogOutputpath
        }
        # Bevorzugte Sprache anpassen
        Write-Host "Changing preferred Language..."
        $languageList = New-WinUserLanguageList $Language
        $languageList[0].Handwriting = 0
        Set-WinUserLanguageList $languagelist -Confirm:$false -Force
    }
    # Tastaturlayout anpassen
    if (($KeyboardLanguage -ne "Invalid") -and ($KeyboardLayout -ne "Invalid") -and ($imeCode -ne "")) {
        # Prüfen ob die Sprache bereits installiert ist
        Write-Host "Checking if Keyboard Language is installed..."
        Write-Log -Message "Checking if Keyboard Language is installed..." -File $LogOutputpath

        $KeyboardLanguageInstalled = Get-InstalledLanguage -Language $KeyboardLanguage
        if ($KeyboardLanguageInstalled -eq $null) {
            Write-Host "Keyboard Language $KeyboardLanguage is not installed"
            Write-Log -Message "Keyboard Language $KeyboardLanguage is not installed" -File $LogOutputpath
            Install-Language -Language $KeyboardLanguage
        } else {
            Write-Host "Keyboard Language $KeyboardLanguage is installed"
            Write-Log -Message "Keyboard Language $KeyboardLanguage is installed" -File $LogOutputpath
        }
        # Tastaturlayout anpassen
        Write-Host "Changing Keyboard Layout..."
        $languageList = Get-WinUserLanguageList
        $languageList[0].InputMethodTips.Clear()
        $languageList[0].InputMethodTips.Add($imeCode)
        Set-WinDefaultInputMethodOverride -InputTip $imeCode
        Set-WinUserLanguageList $languagelist -Confirm:$false -Force
    }
    # Format anpassen
    if (($ShortDate -ne "Invalid") -or ($LongDate -ne "Invalid") -or ($DecimalSeparator -ne "Invalid")) {
        if ($ShortDate -ne "Invalid") {
            $ShortDateFormat = $ShortDate.Replace("Long", "dd.MM.yyyy")
            $ShortDateFormat = $ShortDateFormat.Replace("Short", "dd.MM.yy")
            $ShortDateFormat = $ShortDateFormat.Replace("USLong", "yyyy/MM/dd")
            $ShortDateFormat = $ShortDateFormat.Replace("USShort", "yy/MM/dd")

            $formatKeys += @{
                sShortDate = $ShortDateFormat
            }
        }
        if ($LongDate -ne  "Invalid") {
            $LongDateFormat = $LongDate.Replace("Long", "dddd, dd. MMMM yyyy")
            $LongDateFormat = $LongDateFormat.Replace("Short", "dd.MM.yy")
            $LongDateFormat = $LongDateFormat.Replace("USLong", "dddd, MMMM dd, yyyy")
            $LongDateFormat = $LongDateFormat.Replace("USShort", "yy/MM/dd")

            $formatKeys += @{
                sLongDate = $LongDateFormat
            }
        }
        if ($DecimalSeparator -ne "Invalid") {
            $formatKeys += @{
                sDecimal = $DecimalSeparator
            }
        }
        # Format anpassen
        Write-Host "Changing Format Settings..."
        Write-Log -Message "Changing Format Settings..." -File $LogOutputpath
        $formatKeys.keys | ForEach-Object {
            Set-ItemProperty -Path $RegPath -Name $_ -Value $formatKeys[$_]
        }
    }
    Write-Host "`nSuccessfully changed the language settings!"
    Write-Log -Message "`nSuccessfully changed the language settings!" -File $LogOutputpath
    Write-Host "Please restart your computer to apply the changes."
    Write-Log -Message "Please restart your computer to apply the changes." -File $LogOutputpath
    # Stoppt die Protokollierung
    Write-Host "Stop Logging"
    Write-Log -Message "Stop Logging" -File $LogOutputpath
    Stop-Transcript

    $Restart = Read-Host "Do you want to restart your computer now? (y/n)"
    if ($Restart -eq "y") {
        Restart-Computer
    }
    else {
        Write-Host "Please restart your computer to apply the changes."
        Read-Host "Press any key to stop the script..."
    }
    
}# Set-Language, Change the Language and Format on Windows
function Get-Startmenu {
    param (
    )
    # ---------------- Protokollierung ----------------
    $ActualDate = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    # Transkript file
    Start-Transcript -Path "$PSScriptRoot\logging\transcripts\$($ActualDate)get-Startmenu-transcript.txt"
    # Log file
    $LogOutputpath =  "$PSScriptRoot\logging\logs\function-get-startmenu.log"

    # ---------------- Getting OS Informations ----------------
    $WinVersion = Get-WinVersion -LogOutputpath $LogOutputpath
    # ---------------- Start Implement ----------------
    if ($WinVersion -eq "Windows 10") {
    # Windows 10
            Write-Host "Running Script with Windows Version $caption, Build $build"
            Write-Log -Message "Running Script with Windows Version $caption, Build $build" -File $LogOutputpath
            if (Test-Path -Path "$PSScriptroot\Startmenu") {
                Write-Host "Startmenu Folder found in $PSScriptroot\Startmenu"
                Write-Log -Message "Startmenu Folder found in $PSScriptroot\Startmenu" -File $LogOutputpath
            } else {
                Write-Host "Startmenu Folder not found"
                Write-Log -Message "Startmenu Folder not found" -File $LogOutputpath
                New-Item -Path "$PSScriptRoot\" -Name "Startmenu" -ItemType "directory"
                Write-Host "Startmenu Folder created in $PSScriptRoot"
                Write-Log -Message "Startmenu Folder created in $PSScriptroot" -File $LogOutputpath
            }
            Export-Startlayout -Path "$PSScriptRoot\Startmenu\layoutModification.xml"
            Write-Host "Startmenu Layout exported to $PSScriptRoot\Startmenu\layoutModification.xml"
            Write-Log -Message "Startmenu Layout exported to $PSScriptRoot\Startmenu\layoutModification.xml" -File $LogOutputpath
    } else { # Windows Version not supported
        Write-Host "This script is intended for Windows 10. Your Windows version $caption, Build $build."
    }
    # Stoppt die Protokollierung
    Stop-Transcript
}# Get-Startmenu, Export the Startmenu Layout
function Set-Startmenu {
    param (
    )
    # ---------------- Protokollierung ----------------
    $ActualDate = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    # Transkript file
    Start-Transcript -Path "$PSScriptRoot\logging\transcripts\$($ActualDate)set-Startmenu-transcript.txt"
    # Log file
    $LogOutputpath =  "$PSScriptRoot\logging\logs\function-set-startmenu.log"

    # ---------------- Getting OS Informations ----------------
    $WinVersion = Get-WinVersion -LogOutputpath $LogOutputpath
    # ---------------- Start Implement ----------------
    if ($WinVersion -eq "Windows 10") {
        # Windows 10
        Write-Host "Your OS is Windows 10, you can use this script"
        Write-Log -Message "Your OS is Windows 10, you can use this script" -File $LogOutputpath
        Write-Host "Running Script with Windows Version $caption, Build $build"
        Write-Log -Message "Running Script with Windows Version $caption, Build $build" -File $LogOutputpath

        # Startmenu Layout
        $Confirm = Read-Host -Prompt "Do you want to change the set the Startmenu Layout`n with the file $PSScriptRoot\Startmenu\LayoutModification.xml? (y/n)"
        Write-Log -Message "Do you want to change the set the Startmenu Layout`n with the file $PSScriptRoot\Startmenu\LayoutModification.xml? (y/n)" -File $LogOutputpath
        if ($Confirm -eq "y") {
            Write-Host "Confirmed"
            Write-Log -Message "Confirmed" -File $LogOutputpath
            $StartmenuLayoutPath = "$PSScriptRoot\Startmenu\LayoutModification.xml"
            $StartmenuLayoutDestinationPath = "$($env:localappdata)\Microsoft\Windows\Shell\"

            Write-Host "Copy $PSScriptRoot\Startmenu]LayoutModification.xml to %localappdata%\Microsoft\Windows\Shell\"
            Write-Log -Message "Copy $PSScriptRoot\Startmenu\ayoutModification.xml to %localappdata%\Microsoft\Windows\Shell\" -File $LogOutputpath
            Copy-Item -Path $StartmenuLayoutPath -Destination $StartmenuLayoutDestinationPath
        
            Write-Host "Test StartTileGridRegestryPath"
            Write-Log -Message "Test StartTileGridRegestryPath" -File $LogOutputpath
            $TestStartTileGridRegestryPath = Test-Path -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\$de${*}$start.tilegrid$windows.data.curatedtilecollection.tilecollection'
            Write-Host "Path found, remove Item"
            Write-Log -Message "Path found, remove Item" -File $LogOutputpath
            if ($TestStartTileGridRegestryPath -eq $true) {
                try {
                    Remove-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\$de${*}$start.tilegrid$windows.data.curatedtilecollection.tilecollection' -Recurse
                    Write-Host "Item removed"
                    Write-Log -Message "Item removed" -File $LogOutputpath
                }
                catch { 
                    Write-Host "Error while removing Item"
                    Write-Log -Message "Error while removing Item" -File $LogOutputpath
                }
            }
            Stop-Process -Name explorer
        } else {
            Write-Host "Startmenu Layout not changed"
            Write-Log -Message "Startmenu Layout not changed" -File $LogOutputpath
        }
    } else { # Windows Version not supported
        Write-Host "This script is intended for Windows 10. Your Windows version $caption, Build $build."
        Write-Log -Message "This script is intended for Windows 10. Your Windows version $caption, Build $build." -File $LogOutputpath
        Write-Host "Startmenu Layout not changed"
        Write-Log -Message "Startmenu Layout not changed" -File $LogOutputpath
    }
    #Stoppt die Protokollierung
    Stop-Transcript
}# Set-Startmenu, Import the Startmenu Layout
<#function Set-Walpaper {
    param (
        OptionalParameters
    )
    
}#>
function Connect-Drive {
    param (
        [string]$DrivePath,
        [string]$DriveVariable,
        [string]$DriveName,
        [string]$DriveToDesktop,
        [string]$DriveToStartmenuFolder
    )
    # ---------------- Protokollierung ----------------
    $ActualDate = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    # Transkript file
    Start-Transcript -Path "$PSScriptRoot\logging\transcripts\$($ActualDate)connect-Drive-transcript.txt"
    # Log file
    $LogOutputpath =  "$PSScriptRoot\logging\logs\function-connect-drive.log"
    # ---------------- Getting current Informations ----------------
    $ConnectedDrives = Get-PSDrive -PSProvider FileSystem
    Write-Host "Your current connected Drives"
    Write-Host $ConnectedDrives
    Write-Log -Message "Your current connected Drives" -File $LogOutputpath
    Write-Log -Message $ConnectedDrives -File $LogOutputpath
    # Confirm
    $Confirm = Read-Host "Do you want to continue? (y/n)"
    if ($Confirm -eq "y") {
        Write-Host "Continue..."
        Write-Log -Message "Continue..." -File $LogOutputpath
    }
    else {
        Write-Host "Exit..."
        Write-Log -Message "Exit..." -File $LogOutputpath
        exit
    }
    # ---------------- Check Input ----------------
    if ($DrivePath -eq "") {
        Read-Host -Prompt "DrivePath is empty, please enter a valid Path"
        Write-Log -Message "DrivePath is empty, please enter a valid Path" -File $LogOutputpath
    }
    if ($DriveVariable -eq "") {
        Read-Host -Prompt "DriveVariable is empty, please enter a valid Variable"
        Write-Log -Message "DriveVariable is empty, please enter a valid Variable" -File $LogOutputpath
    }
    if ($DriveName -eq "") {
        Read-Host -Prompt "DriveName is empty, please enter a valid Name"
        Write-Log -Message "DriveName is empty, please enter a valid Name" -File $LogOutputpath
    }
    # ---------------- Start Implement ----------------
    # Connect Drive
    if ($DrivePath -ne "") {
        Write-Host "$HederLine Connect Drive $Drive $HeaderLine"
        Write-Log -Message "$HeaderLine Connect Drive $Drive $HeaderLine" -File $LogOutputpath
        New-SmbMapping -LocalPath "$($DriveVariable):" -RemotePath $DrivePath -Persistent $true

        # Create Desktop Shortcut
        if ($DriveToDesktop -eq "yes") {
            Write-Host "$HederLine Create Desktop Shortcut $DriveToDesktop $HeaderLine"
            Write-Log -Message "$HeaderLine Create Desktop Shortcut $DriveToDesktop $HeaderLine" -File $LogOutputpath
            $WshShell = New-Object -ComObject WScript.Shell
            $Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\$DriveName.lnk")
            $Shortcut.TargetPath = "$DriveVariable" + ":"
            $Shortcut.Save()
        }
        # Create Startmenu Shortcut
        if ($DriveToStartmenuFolder -eq "yes") {
            Write-Host "$HederLine Create Startmenu Shortcut $DriveToStartmenuFolder $HeaderLine"
            Write-Log -Message "$HeaderLine Create Startmenu Shortcut $DriveToStartmenuFolder $HeaderLine" -File $LogOutputpath
            $WshShell = New-Object -ComObject WScript.Shell
            $Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\$DriveName.lnk")
            $Shortcut.TargetPath = "$DriveVariable" + ":"
            $Shortcut.Save()
        }
    }
    # ---------------- Protokollierung ----------------
    # Stoppt die Protokollierung
    Stop-Transcript
}# Connect-Drive, Connect a Drive and create a Shortcut
function Set-NetworkAdapter {
    Param(
        [Parameter(Mandatory = $false, Position = 5, HelpMessage = "Show All Network Adapters")]
        [Switch]$Showall
    )
    # ---------------- Protokollierung ----------------
    $ActualDate = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    # Transkript file
    Start-Transcript -Path "$PSScriptRoot\logging\transcripts\$($ActualDate)_set-netadapter-transcript.txt"
    # Log file
    $LogOutputpath =  "$PSScriptRoot\logging\logs\function-set-netadapter.log"

    # Check if PowerShell is running as Administrator
    Write-Host "Check if PowerShell is running as Administrator"
    Write-Log -Message "Check if PowerShell is running as Administrator" -File $LogOutputpath
    Get-PowerShellIsAdmin

    # ---------------- Start Implement ----------------
    if ($IsAdmin) {
    # Get network adapter List
    Write-Host "Get network adpater List"
    Write-Log -Message "Get network adpater List" -File $LogOutputpath
    $NetAdapterList = Get-WMIObject Win32_NetworkAdapterConfiguration
    if ($Showall){
        # All Network adapter including Bluetooth etc were shown.
        Write-Host "This are all network adapters"
        Write-Log -Message "This are all network adapters" -File $LogOutputpath
        $NetAdapterListShowAll = Get-WMIObject Win32_NetworkAdapterConfiguration | Select-Object -Property Index, DHCPEnabled, IPAddress, Description | Format-Table
        $NetAdapterListShowAllString = $NetAdapterListShowAll | Out-String
        $NetAdapterListShowAll
        Write-Log -Message $NetAdapterListShowAllString -File $LogOutputpath
    } else {
        # Only Network adapters that dosen't include Wan, Kernel, Bluetooth and Virtual Adapter
        Write-Host "This are the etwork adapters that dosen't include Wan, Kernel, Bluetooth and Virtual Adapter"
        Write-Log -Message "This are the etwork adapters that dosen't include Wan, Kernel, Bluetooth and Virtual Adapter" -File $LogOutputpath
        $NetAdapterListFiltered = Get-WMIObject Win32_NetworkAdapterConfiguration | Select-Object -Property Index, DHCPEnabled, IPAddress, Description | Where-Object { ($_.Description -notlike "*Wan*") -and ($_.Description -notlike "*Kernel*") -and ($_.Description -notlike "*Bluetooth*") -and ($_.Description -notlike "*Virtual Adapter*") } | Format-Table
        $NetAdapterListFilteredString = $NetAdapterListFiltered | Out-String
        $NetAdapterListFiltered
        Write-Log -Message $NetAdapterListFilteredString -File $LogOutputpath
    }

    #Select a Network Adapter (All Network can be selected also the not shown in the bevor shown list)
    $selectedadapter = Read-Host -Prompt "Select Adapter to change (Index)"
    Write-Log -Message "Select Adapter to change (Index)" -File $LogOutputpath

    #Show selected Networkadapter
    Write-Host "This is the selected adapter"
    Write-Log -Message "This is the selected adapter" -File $LogOutputpath
    $NetAdapterList[$selectedadapter] | Select-Object -Property Index, DHCPEnabled, IPAddress, Description | Format-Table
    $NetAdapterListSelectedString = $NetAdapterList[$selectedadapter] | Out-String
    Write-Log -Message $NetAdapterListSelectedString -File $LogOutputpath

    # Confirm selection
    $Confirm = Read-Host -Prompt "Do you want to change this network adapter? (y/n)"
    if ($Confirm -eq "y") {
        Write-Host "confirmed"
        Write-Log -Message "confirmed" -File $LogOutputpath
    } else {
        Write-Host "Exit..."
        Write-Log -Message "Exit..." -File $LogOutputpath
        exit
    }

    # Set the IP and Subent
    $selectedip = Read-Host -Prompt "Enter the IP to set, (leave it empty for DHCP)"
    Write-Log -Message "Enter the IP to set, (leave it empty for DHCP)" -File $LogOutputpath
    if ($selectedip -eq ""){
        # Net Adapter is set to DHCP
        $NetAdapterList[$selectedadapter].EnableDHCP()
        Write-Host "Net Adapter is set to DHCP"
        Write-Log -Message "Net Adapter is set to DHCP" -File $LogOutputpath
    } else {
        # Net Adapter will be configured Static
        Write-Host "IP is set to $selectedip"
        Write-Log -Message "IP is set to $selectedip" -File $LogOutputpath
        $selectedsubnet = Read-Host -Prompt "Enter the Subnet to set, (leave it empty for 255.255.255.0 (24))"
        if ($selectedsubnet -eq "") {
            $selectedsubnet = "255.255.255.0"
        }
        Write-Host "Subnet is set to $selectedsubnet"
        Write-Log -Message "Subnet is set to $selectedsubnet" -File $LogOutputpath

        # Net Adapter is set to Static
        $NetAdapterList[$selectedadapter].EnableStatic($selectedip, $selectedsubnet)
        Write-Host "Net Adapter is set to Static (IP: $selectedip, Subnet: $selectedsubnet)"
        Write-Log -Message "Net Adapter is set to Static (IP: $selectedip, Subnet: $selectedsubnet)" -File $LogOutputpath
    }
    # Please wait some time to be changed
    Write-Host "Please wait some time to be changed, then try to test your networkconnection"
    Write-Log -Message "Please wait some time to be changed, then try to test your networkconnection" -File $LogOutputpath
    
    } else {
        Write-Host "This script must be run as Administrator"
        Write-Log -Message "This script must be run as Administrator" -File $LogOutputpath
    }
    # Stoppt die Protokollierung
    Stop-Transcript
}# Set-NetAdapter, Change the IP and Subnet of a Network Adapter