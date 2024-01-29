# Windows Set-Language ausführscript
# This script is to set Windows Language from the Module .\WinFunctions.psm1

Import-Module .\WinFunctions.psm1
Set-Language -Region Schweiz -RegionalFormat de-CH -DisplayLanguage de-CH -Language de-CH -KeyboardLanguage de-CH -KeyboardLayout de-CH

Pause