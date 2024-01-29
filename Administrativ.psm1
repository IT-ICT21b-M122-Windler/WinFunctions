# This Module is for Administrative Functions like Logging, 
# Check if PowerShell is running as Administrator and get the Windows Version

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
# Write Log, Write-Log -Message "Test" -File "C:\Temp\test.log"
function Get-PowerShellIsAdmin {
    # Check if PowerShell is running as Administrator
    $Global:IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
    $IsAdmin
}# Check Admin, Get-PowerShellIsAdmin
function Get-WinVersion {
    param(
        [Parameter(Mandatory=$false)]
        [string]$LogOutputpath
    )
    Write-Host "Getting OS Informations"
    Write-Log -Message "Getting OS Informations" -File $LogOutputpath
    $os = Get-WmiObject -Class Win32_OperatingSystem
    # Extract build number and caption version text
    $build = [int]$os.BuildNumber
    $caption = $os.Caption
    # Windows 10 was initially released with build 10240
    $minBuildForWin10 = 10240
    # Windows 11 starts from build 22000 (approx)
    $minBuildForWin11 = 22000

    if ($build -ge $minBuildForWin11) {
        $osVersion = "Windows 11"
    } elseif ($build -ge $minBuildForWin10) {
        $osVersion = "Windows 10"
    } else {
        $osVersion = "Windows 7/8/8.1"
    }
    Write-Host "OS Version: $osVersion"
    Write-Host "OS Build: $build"
    Write-Host "OS Caption: $caption"
    Write-Log -Message "OS Version: $osVersion" -File $LogOutputpath
    Write-Log -Message "OS Build: $build" -File $LogOutputpath
    Write-Log -Message "OS Caption: $caption" -File $LogOutputpath
    Write-Output $osVersion
}# Get Windows Version, Get-WinVersion