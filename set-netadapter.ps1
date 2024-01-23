function set-netadapter {
    Param(
        [Parameter(Mandatory = $false, Position = 5, HelpMessage = "Show All Network Adapters")]
        [Switch]$showall
    )
    # Get network adapter List
    Write-Host "Get network adpater List"
    $NetAdapterList = Get-WMIObject Win32_NetworkAdapterConfiguration
    if ($showall){
        # All Network adapter including Bluetooth etc were shown.
        Write-Host "This are all network adapters"
        $NetAdapterListShowAll = Get-WMIObject Win32_NetworkAdapterConfiguration | Select-Object -Property Index, DHCPEnabled, IPAddress, Description | Format-Table
        $NetAdapterListShowAll
    } else {
        # Only Network adapters that dosen't include Wan, Kernel, Bluetooth and Virtual Adapter
        $NetAdapterListFiltered = Get-WMIObject Win32_NetworkAdapterConfiguration | Select-Object -Property Index, DHCPEnabled, IPAddress, Description | Where-Object { ($_.Description -notlike "*Wan*") -and ($_.Description -notlike "*Kernel*") -and ($_.Description -notlike "*Bluetooth*") -and ($_.Description -notlike "*Virtual Adapter*") } | Format-Table
        $NetAdapterListFiltered
    }

    #Select a Network Adapter (All Network can be selected also the not shown in the bevor shown list)
    $selectedadapter = Read-Host -Prompt "Select Adapter to change (Index)"

    #Show selected Networkadapter
    Write-Host "This is the selected adapter"
    $NetAdapterList[$selectedadapter] | Select-Object -Property Index, DHCPEnabled, IPAddress, Description | Format-Table

    # Confirm selection
    $Confirm = Read-Host -Prompt "Do you want to change this network adapter? Y/N"
    if ($Confirm -eq "Y") {
        Write-Host "confirmed"
    } else { exit }

    # Set the IP and Subent
    $selectedip = Read-Host -Prompt "Enter the IP to set, (leave it empty for DHCP)"
    if ($selectedip -eq ""){
        # Net Adapter is set to DHCP
        try {
            $NetAdapterList[$selectedadapter].EnableDHCP()
        }
        catch {
            <#Do this if a terminating exception happens#>
        }
        finally {
            # Please wait some time to be changed
            Write-Host "Please wait some time to be changed, then try to test your networkconnection"
        }
    } else {
        # Net Adapter will be configured Static
        $selectedsubnet = Read-Host -Prompt "Enter the Subnet to set, (leave it empty for 255.255.255.0 (24))"
        if ($selectedsubnet -eq "") {
            $selectedsubnet = "255.255.255.0"
        }
        # Net Adapter is set to Static
        try {
            $NetAdapterList[$selectedadapter].EnableStatic($selectedip, $selectedsubnet)
        }
        catch {
            <#Do this if a terminating exception happens#>
        }
        finally {
            # Please wait some time to be changed
            Write-Host "Please wait some time to be changed, then try to test your networkconnection"
        }
    }
}
set-netadapter -showall