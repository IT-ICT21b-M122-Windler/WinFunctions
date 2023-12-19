# Gib die Sprache und das Layout an (z.B. "Deutsch (Schweiz)" oder "English (United States)")
$KeyboardLanguage = "English (United States)"
$KeyboardLayout = "Deutsch (Schweiz)"


# Ermittle den passenden Culture-Code für das Land
$keyboardLanguageCultureCode = [System.Globalization.CultureInfo]::GetCultures([System.Globalization.CultureTypes]::AllCultures) |
    Where-Object { $_.EnglishName -eq $KeyboardLanguage -or $_.NativeName -eq $KeyboardLanguage } |
    Select-Object -ExpandProperty Name -First 1
$keyboardLayoutCultureCode = [System.Globalization.CultureInfo]::GetCultures([System.Globalization.CultureTypes]::AllCultures) |
    Where-Object { $_.EnglishName -eq $KeyboardLayout -or $_.NativeName -eq $KeyboardLayout } |
    Select-Object -ExpandProperty Name -First 1


# Überprüfe, ob ein KeyboardLanguage CultureCode gefunden wurde
if ($keyboardLanguageCultureCode) {
    $cultureInfo = New-Object System.Globalization.CultureInfo $keyboardLanguageCultureCode
    # Ermittle die KeyboardLanguageId
    $keyboardLanguageId = "0" + $cultureInfo.KeyboardLayoutId.ToString("X")

    # Zeige die KeyboardLanguageId an
    Write-Host "KeyboardLanguageId: $keyboardLanguageId"
} else {
    Write-Host "Kein Culture-Code für $KeyboardLanguage gefunde"
}

# Überprüfe, ob ein KeyboardLayout CultureCode gefunden wurde
if ($keyboardLayoutCultureCode) {
    $cultureInfo = New-Object System.Globalization.CultureInfo $keyboardLayoutCultureCode
    # Ermittle die KeyboardLayoutId
    $keyboardLayoutId = "0000" + $cultureInfo.KeyboardLayoutId.ToString("X")

    # Zeige die KeyboardLayoutId an
    Write-Host "KeyboardLayoutId: $keyboardLayoutId"
} else {
    Write-Host "Kein Culture-Code für $KeyboardLayout gefunde"
}
$imeCode = $keyboardLanguageId + ":" + $keyboardLayoutId
Write-Host "IME-Code: $imeCode"
#$imeCode = $regionInfo.GeoId.ToString("X4") + ":" + $keyboardLayoutId
#Write-Host "IME-Code: $imeCode"