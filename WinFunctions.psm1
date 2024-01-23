# This Module is for Windows Function like changing the Language

Function Write-Log {
    [CmdletBinding()]
    Param(
    [Parameter(Mandatory=$True)]
    [String]$Message,

    [Parameter(Mandatory=$False)]
    [String]$File
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$($timestamp): $Message" | Out-File -FilePath $File -Append
}
# Check Admin
function Get-PowerShellIsAdmin {
    # Check if PowerShell is running as Administrator
    $Global:IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}# Check Admin
function Set-Language {
    param (
        #Sprache
        [Parameter(Mandatory = $false, HelpMessage = "Set the Language and Format on Windows (de-CH, en-US etc.)")]
        [string]$DisplayLanguage = "Invalid", #Ivalid do while loop

        [Parameter(Mandatory = $false, HelpMessage = "Set the Keyboard Language on Windows")]
        [string]$KeyboardLanguage = "Invalid", #Ivalid do while loop
        [Parameter(Mandatory = $false, HelpMessage = "Set the Keyboard Layout on Windows")]
        [string]$KeyboardLayout = "Invalid", #Ivalid do while loop

        #Region
        [Parameter(Mandatory = $false, HelpMessage = "Set the Region on Windows")]
        [string]$Region= "Invalid", #Ivalid do while loop
        [Parameter(Mandatory = $false, HelpMessage = "Set the Reginal Format on Windows (de-CH, en-US etc.)")]
        [string]$RegionalFormat = "Invalid", #Ivalid do while loop

        #Format
        [Parameter(Mandatory = $false, HelpMessage = "Set the Time Format on Windows")]
        [ValidateSet("Long dd/MM/yyyy", "Short dd/MM/yy", "USLong yyyy/MM/dd", "USShort yy/MM/dd")]
        $ShortDateFormat = "Invalid", #Ivalid do while loop
        [Parameter(Mandatory = $false, HelpMessage = "Set the Time Format on Windows")]
        [ValidateSet("Long dd/MM/yyyy", "Short dd/MM/yy", "USLong yyyy/MM/dd", "USShort yy/MM/dd")]
        $LongDateFormat = "Invalid", #Ivalid do while loop
        [Parameter(Mandatory = $false, HelpMessage = "Set the Time Format on Windows")]
        [ValidateSet(".", ",")]
        $DecimalSeperator = "Invalid" #Ivalid do while loop
        #etc nach Kundenwunsch...
    )

    # ---------------- Protokollierung ----------------
    $ActualDate = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    # Transkript file
    Start-Transcript -Path ".\$($ActualDate)set-Language-transcript.txt"
    # Log file
    $LogOutputpath =  ".\" + "$ActualDate" + "_function-set-language.log"

    # ---------------- Variablen und Module ----------------
    Import-Module international
    $RegPath = "HKCU:\Control Panel\International"
    Write-Log "Import-Module international" -File $LogOutputpath
    Write-Log "RegPath: $RegPath" -File $LogOutputpath

    # ---------------- Getting current Informations ----------------
    # Output - Your curent Language settings
    Write-Host "Your current Language and Format settings"
    Write-Host "Display Language: $(Get-WinUILanguageOverride.LanguageTag)"
    Write-Host "Keyboard Language: $(Get-WinUserLanguageList.LanguageTag)"
    Write-Host "Keyboard Layout: $(Get-WinUserLanguageList.InputMethodTips)"
    Write-Host "Region: $(Get-WinHomeLocation.GeoId)"
    Write-Host "Regional Format: $(Get-Culture.Name)"
    $intlSettings = Get-ItemProperty -Path "HKCU:\Control Panel\International"
    Write-Host "Time Format short: $($intlSettings.sShortDate)"
    Write-Host "Time Format long: $($intlSettings.sLongDate)"
    Write-Host "Decimal Separator: $($intlSettings.sDecimal)"
    # Log - Your curent Language settings
    Write-Log -Message "Your current Language and Format settings" -File $LogOutputpath
    Write-Log -Message "Display Language: $(Get-WinUILanguageOverride.LanguageTag)" -File $LogOutputpath
    Write-Log -Message "Keyboard Language: $(Get-WinUserLanguageList.LanguageTag)" -File $LogOutputpath
    Write-Log -Message "Keyboard Layout: $(Get-WinUserLanguageList.InputMethodTips)" -File $LogOutputpath
    Write-Log -Message "Region: $(Get-WinHomeLocation.GeoId)" -File $LogOutputpath
    Write-Log -Message "Regional Format: $(Get-Culture.Name)" -File $LogOutputpath
    Write-Log -Message "Time Format short: $($intlSettings.sShortDate)" -File $LogOutputpath
    Write-Log -Message "Time Format long: $($intlSettings.sLongDate)" -File $LogOutputpath
    Write-Log -Message "Decimal Separator: $($intlSettings.sDecimal)" -File $LogOutputpath
    
    # ---------------- Start, Getting Input ----------------
    Write-Host "Set the Language on Windows"
    Write-Log -Message "Set the Language on Windows" -File $LogOutputpath

    while ($DisplayLanguage -eq "Invalid"){
        $DisplayLanguage = Read-Host "Set the Language on Windows, Format: de-CH, en-US etc."
    }
    while ($KeyboardLanguage -eq "Invalid"){
        $KeyboardLanguage = Read-Host "Set Keyboard Language on Windows, Format: Deutsch (Schweiz) or English (United States)"
    }
    while ($KeyboardLayout -eq "Invalid"){
        $KeyboardLayout = Read-Host "Set Keyboard Layout on Windows, Format: Deutsch (Schweiz) or English (United States)"
    }
    while ($Region -eq "Invalid"){
        $Region = Read-Host "Set Region on Windows, Native Name or English Name"
    }
    while ($RegionalFormat -eq "Invalid"){
        $RegionalFormat = Read-Host "Set Regional Format on Windows, Format: de-CH, en-US etc."
    }
    while ($ShortDateFormat -eq "Invalid"){
        $ShortDateFormat = Read-Host "Set Short Date Format on Windows, Format: Short dd/MM/yy"
    }
    while ($LongDateFormat -eq "Invalid"){
        $LongDateFormat = Read-Host "Set Short Date Format on Windows, Format: Long dd/MM/yyyy"
    }
    while ($DecimalSeperator -eq "Invalid"){
        $DecimalSeperator = Read-Host "Set Decimal Seperator on Windows, Format: . or ,"
    }

    # ---------------- Find GeoID ----------------
    if ($Region -ne "") {
        $FindGeoID = "false"
        while ($FindGeoID -eq "false"){
            Write-Host "Searching GeoID..."
            Wrtite-log -Message "Searching GeoID..." -File $LogOutputpath
            # Zugriff auf die CultureInfo-Klasse des .NET Frameworks, um alle Kulturen zu erhalten
            $cultures = [System.Globalization.CultureInfo]::GetCultures([System.Globalization.CultureTypes]::AllCultures)
            foreach ($culture in $cultures) { # Durchsuche alle Kulturen, um die entsprechende zu finden
                try {
                    $RegionInfos = New-Object System.Globalization.RegionInfo($culture.Name)
                    if ($RegionInfos.EnglishName -eq $Land -or $RegionInfos.NativeName -eq $Land) {
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
                Write-Host "$($Region): GeoID ist $GeoID"
                Write-Log -Message "$($Region): GeoID ist $GeoID" -File $LogOutputpath
                $FindGeoID = "true"
            }
            else { # Falls kein Ländercode gefunden wurde, gib eine Fehlermeldung aus
                Write-Host "$($Land): Keine GeoID gefunden"
                Write-Log -Message "$($Land): Keine GeoID gefunden" -File $LogOutputpath
                $Land = Read-Host "Set Region on Windows, Native Name or English Name"
                $FindGeoID = "false"
            }
        }
    }
    # ---------------- Find Keyboard LCID ----------------
    if (($KeyboardLanguage -ne "") -or ($KeyboardLayout -ne "")) {
        $FindKeyboardLCID = "false"
        while ($FindKeyboardLCID -eq "false"){
            Write-Host "Searching Keyboard LCID/imeCode..."
            # Ermittle den passenden Culture-Code für die Sprache und das Layout
            $keyboardLanguageCultureCode = [System.Globalization.CultureInfo]::GetCultures([System.Globalization.CultureTypes]::AllCultures) | Where-Object { $_.EnglishName -eq $KeyboardLanguage -or $_.NativeName -eq $KeyboardLanguage } |
            Select-Object -ExpandProperty Name -First 1
            if ($keyboardLanguageCultureCode) { # Überprüfe, ob ein KeyboardLanguage CultureCode gefunden wurde
                $cultureInfo = New-Object System.Globalization.CultureInfo $keyboardLanguageCultureCode
                # Ermittle die KeyboardLanguageId und Zeige die KeyboardLanguageId an
                $keyboardLanguageId = "0" + $cultureInfo.KeyboardLayoutId.ToString("X")
                $FindKeyboardLanguageLCID = "true"
            }
            else {
                Write-Host "Kein LCID/imeCode für die Keyboard Sprache $KeyboardLanguage gefunde"
                $FindKeyboardLCID = "false"
                $KeyboardLanguage = Read-Host "Set Keyboard Language on Windows, Format: Deutsch (Schweiz) or English (United States)"
                $FindKeyboardLanguageLCID = "false"
            }
            $keyboardLayoutCultureCode = [System.Globalization.CultureInfo]::GetCultures([System.Globalization.CultureTypes]::AllCultures) | Where-Object { $_.EnglishName -eq $KeyboardLayout -or $_.NativeName -eq $KeyboardLayout } |
            Select-Object -ExpandProperty Name -First 1
            if ($keyboardLayoutCultureCode) { # Überprüfe, ob ein KeyboardLayout CultureCode gefunden wurde
                $cultureInfo = New-Object System.Globalization.CultureInfo $keyboardLayoutCultureCode
                # Ermittle die KeyboardLayoutId und Zeige die KeyboardLayoutId an
                $keyboardLayoutId = "0000" + $cultureInfo.KeyboardLayoutId.ToString("X")
                $FindKeyboardLayoutLCID = "true"
            }
            else {
                Write-Host "Kein LDIC/imeCode für das Keyborad Layout $KeyboardLayout gefunde"
                $KeyboardLayout = Read-Host "Set Keyboard Layout on Windows, Format: Deutsch (Schweiz) or English (United States)"
                $FindKeyboardLayoutLCID = "false"
            }
            if (($FindKeyboardLanguageLCID -eq "true") -and ($FindKeyboardLayoutLCID -eq "true")){
                $imeCode = $keyboardLanguageId + ":" + $keyboardLayoutId
                Write-Host "Found Keyboard LCID, imeCode is $imeCode"
                #$imeCode = $regionInfo.GeoId.ToString("X4") + ":" + $keyboardLayoutId
                $FindKeyboardLCID = "true"
            }
            else {
                $FindKeyboardLCID = "false"
            }
        }
    }

    # ---------------- Bestätigung ----------------
    # Ausgabe der gefundenen Informationen
    Write-Host "Your Input:"
    Write-Host "Language: $Language"
    Write-Host "Region: $GeoID ($Land, $($regionInfo.DisplayName))"
    Write-Host "Keyboard Language $KeyboardLanguage and Layout $KeyboardLayout : $imeCode"
    Write-Host "ShortDateFormat: $ShortDateFormat"
    Write-Host "LongDateFormat: $LongDateFormat"
    Write-Host "DecimalSeperator: $DecimalSeperator"

    # Ausgabe der gefundenen Informationen in eine Log-Datei
    Write-Log -Message "Your Input" -File $LogOutputpath
    Write-Log -Message "Language: $Language" -File $LogOutputpath
    Write-Log -Message "Region: $GeoID ($Land, $($regionInfo.DisplayName))" -File $LogOutputpath
    Write-Log -Message "Keyboard Language $KeyboardLanguage and Layout $KeyboardLayout : $imeCode" -File $LogOutputpath
    Write-Log -Message "ShortDateFormat: $ShortDateFormat" -File $LogOutputpath
    Write-Log -Message "LongDateFormat: $LongDateFormat" -File $LogOutputpath
    Write-Log -Message "DecimalSeperator: $DecimalSeperator" -File $LogOutputpath

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

    # ---------------- Implementierung ----------------
    # Region anpassen
    if ($GeoID -ne "") {
        Write-Host "Changing Region..."
        Set-WinHomeLocation -GeoId $GeoID
    }
    # Reionales Format anpassen
    if ($RegionalFormat -ne "") {
        Write-Host "Changing Regional Format..."
        Set-Culture -CultureInfo $RegionalFormat
    }
    
    if ($Language -ne "") {
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
    }
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

    # Stoppt die Protokollierung
    Stop-Transcript
}
function Get-Startmenu {
    param (
    )
    # ---------------- Protokollierung ----------------
    $ActualDate = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    # Transkript file
    Start-Transcript -Path ".\$($ActualDate)get-Startmenu-transcript.txt"
    # Log file
    $LogOutputpath =  ".\" + "$ActualDate" + "_function-get-startmenu.log"

    # ---------------- Getting OS Informations ----------------
    $os = Get-WmiObject -Class Win32_OperatingSystem
    # Extract build number and caption version text
    $build = [int]$os.BuildNumber
    $caption = $os.Caption
    # Windows 10 was initially released with build 10240
    $minBuildForWin10 = 10240
    # Windows 11 starts from build 22000 (approx)
    $minBuildForWin11 = 22000

    # ---------------- Start Implement ----------------
    if ($build -ge $minBuildForWin10 -and $build -lt $minBuildForWin11) {
    # Windows 10
            Write-Host "Running Script with Windows Version $caption, Build $build"
            Write-Log -Message "Running Script with Windows Version $caption, Build $build" -File $LogOutputpath
            Export-Startlayout -Path ".\Startmenu\layoutModification.xml"
    } else {
    # Windows Version not supported
        Write-Host "This script is intended for Windows 10. Your Windows version $caption, Build $build."
    }
    # Stoppt die Protokollierung
    Stop-Transcript
}
function Set-Startmenu {
    param (
    )
    # ---------------- Protokollierung ----------------
    $ActualDate = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    # Transkript file
    Start-Transcript -Path ".\$($ActualDate)set-Startmenu-transcript.txt"
    # Log file
    $LogOutputpath =  ".\" + "$ActualDate" + "_function-set-startmenu.log"

    # ---------------- Getting OS Informations ----------------
    Write-Host "Getting OS Informations"
    $os = Get-WmiObject -Class Win32_OperatingSystem
    # Extract build number and caption version text
    $build = [int]$os.BuildNumber
    $caption = $os.Caption
    # Windows 10 was initially released with build 10240
    $minBuildForWin10 = 10240
    # Windows 11 starts from build 22000 (approx)
    $minBuildForWin11 = 22000
    # ---------------- Start Implement ----------------
    if ($build -ge $minBuildForWin10 -and $build -lt $minBuildForWin11) {
        # Windows 10
        Write-Host "Your OS is Windows 10, you can use this script"
        Write-Log -Message "Your OS is Windows 10, you can use this script" -File $LogOutputpath
        Write-Host "Running Script with Windows Version $caption, Build $build"
        Write-Log -Message "Running Script with Windows Version $caption, Build $build" -File $LogOutputpath

        # Startmenu Layout
        Read-Host -Prompt "Do you want to change the set the Startmenu Layout with the file .\Startmenu\LayoutModification.xml? (y/n)"
        Write-Log -Message "Do you want to change the set the Startmenu Layout with the file .\Startmenu\LayoutModification.xml? (y/n)" -File $LogOutputpath
        if ($Confirm -eq "y") {
            Write-Host "Confirmed"
            Write-Log -Message "Confirmed" -File $LogOutputpath
            $StartmenuLayoutPath = ".\Startmenu\LayoutModification.xml"
            $StartmenuLayoutDestinationPath = "$($env:localappdata)\Microsoft\Windows\Shell\"

            Write-Host "Copy .\Startmenu]LayoutModification.xml to %localappdata%\Microsoft\Windows\Shell\"
            Write-Log -Message "Copy L.\Startmenu\ayoutModification.xml to %localappdata%\Microsoft\Windows\Shell\" -File $LogOutputpath
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
    } else {
    # Windows Version not supported
        Write-Host "This script is intended for Windows 10. Your Windows version $caption, Build $build."
        Write-Log -Message "This script is intended for Windows 10. Your Windows version $caption, Build $build." -File $LogOutputpath
        Write-Host "Startmenu Layout not changed"
        Write-Log -Message "Startmenu Layout not changed" -File $LogOutputpath
    }
    #Stoppt die Protokollierung
    Stop-Transcript
}
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
    Start-Transcript -Path ".\$($ActalDate)connect-Drive-transcript.txt"
    # Log file
    $LogOutputpath =  ".\" + "$ActualDate" + "_function-connect-drive.log"
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
}
function Set-NetAdapter {
    Param(
        [Parameter(Mandatory = $false, Position = 5, HelpMessage = "Show All Network Adapters")]
        [Switch]$Showall
    )
    # ---------------- Protokollierung ----------------
    $ActualDate = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    # Transkript file
    Start-Transcript -Path ".\$($ActualDate)_set-netadapter-transcript.txt"
    # Log file
    $LogOutputpath =  ".\" + "$ActualDate" + "_function-set-netadapter.log"

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
}