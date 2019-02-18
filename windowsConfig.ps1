<# 
	Department:	ETC STC
	Name:		Chan.Shijia
	Date:		2018/11/21
	Language:	Powershell script
	Test env:	Windows 2012, Windows 2016
	command:	execute by Powershell
	
#>

function Setup_ip_static_default()
{
    Remove-NetIPAddress -Confirm:$false
    Clear-Host   #clean screen

    #Get-NetAdapter | Sort-Object -Property Name

    $ifIndex = Get-NetAdapter | Where-Object ifIndex | Select-Object -ExpandProperty ifIndex
    $IPtail = 10
    #[int]$IPtail = Read-Host "`n Please Enter The IP Number(ex:192.168.1.xx)"

        for($n=0;$ifIndex.Length -gt $n;$n++){
            New-NetIPAddress -IPAddress 192.168.1.$IPtail -PrefixLength 24 -InterfaceIndex $ifIndex[$n] | 
            Select-Object InterfaceAlias,IPaddress,PrefixLength -skip 1 #Select-Object IPAddress,InterfaceIndex,InterfaceAlias,PrefixLength -skip 1
            #Get-NetAdapter -InterfaceIndex $ifIndex[$n] | Select-Object Name , InterfaceDescription , ifIndex
            $IPtail = $IPtail + 10
        }

    Read-Host "`n The above IP has been set up,press enter to continue... "
}

function Setup_ip_static()
{
    Remove-NetIPAddress -Confirm:$false
    Clear-Host   #clean screen

    #Get-NetAdapter | Sort-Object -Property Name

    $ifIndex = Get-NetAdapter | Where-Object ifIndex | Select-Object -ExpandProperty ifIndex
    $IPtail = 10
    [int]$IPtail = Read-Host "`n Please Enter The IP Number(ex:192.168.1.xx)"

        for($n=0;$ifIndex.Length -gt $n;$n++){
            New-NetIPAddress -IPAddress 192.168.1.$IPtail -PrefixLength 24 -InterfaceIndex $ifIndex[$n] | 
            Select-Object InterfaceAlias,IPaddress,PrefixLength -skip 1 #Select-Object IPAddress,InterfaceIndex,InterfaceAlias,PrefixLength -skip 1
            #Get-NetAdapter -InterfaceIndex $ifIndex[$n] | Select-Object Name , InterfaceDescription , ifIndex
            $IPtail = $IPtail + 10
        }

    Read-Host "`n The above IP has been set up,press enter to continue... "
}

function Clean_all_disk()
{
    Clear-Host
    Write-Host "SUT Disk list"
	Get-disk | Sort-Object -Property Number
	Write-Host "`nPlease confirm that all partition data are save or you don't what to keep."
	$max_disk_number = 0
	[int]$max_disk_number = Read-Host "Please Enter The largest Disk Number"
	$confirm = Read-Host "`nDisk will be delete, Do you want to contiun?[Y]Yes or [N]No"

		if( $confirm -eq "Y"){
			$double_confirm = Read-Host "[Final comfirm]Disk 1 to $a will be delete, Do you want to contiun?[Y]Yes or [N]No"
			if($double_confirm -eq "Y"){
				Write-Host "`nClear Disk now, Please Wait."
				for($index=1;$max_disk_number -ge $index;$index++){Write-Host "Clear Disk $b" ; Clear-Disk -number $index -RemoveData -RemoveOEM -Confirm:$false}
					Write-Host "Done."
					Write-Host "`nInitialize Disk now, Please Wait."
				for($index=1 ; $max_disk_number -ge $index;$index++){Write-Host "Initial Disk $b" ; Initialize-Disk -Number $index}
					Write-Host "Done."
			}
		}
    Read-Host "`nAll Disk has been cleaned,press enter to continue... "
}

function Setup_ip_dhcp()
{
    Set-netIPinterface -DHCP Enabled

    Clear-Host
    Read-Host "`nAll Disk Cleaned,press enter to continue... "
}

function disable_firewall()
{
    Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

    Read-Host "`nFirewall has closed,press enter to continue... "
}

function display_turn_on()
{
    #$powerPlan = Get-WmiObject -Namespace root\cimv2\power -Class Win32_PowerPlan -Filter "ElementName = 'High Performance'"
    #$powerPlan.Activate()

    powercfg -change -monitor-timeout-ac 0

    Read-Host "`nDisplay will never turn off,press enter to continue... "
}
<#
function Clean_all_disk_Wayne()
{
    Write-Host "SUT Disk list"
	Get-disk | Sort-Object -Property Number -Descending | Select-Object Number
	Write-Host "Please confirm that all partition data are save or you don't what to keep."
	$a = 0
	[int]$a = Read-Host "Please Enter The largest Disk Number"
	$c = Read-Host "Disk will be delete, Do you want to contiun?[Y]Yes or [N]No"

		if( $c -eq "Y"){
			$d = Read-Host "[Final comfirm]Disk 1 to $a will be delete, Do you want to contiun?[Y]Yes or [N]No"
			if($d -eq "Y"){
				Write-Host "Clear Disk now, Please Wait."
				for($b=1;$a -ge $b;$b++){Write-Host "Clear Disk $b" ; Clear-Disk -number $b -RemoveData -RemoveOEM -Confirm:$false}
					Write-Host "Done."
					Write-Host "Initialize Disk now, Please Wait."
				for($b=1 ; $a -ge $b ; $b++){Write-Host "Initial Disk $b" ; Initialize-Disk -Number $b}
					Write-Host "Done."
			}
		}
}
#>

do
{
    Clear-Host
    Write-Host "-----------------------------------------------"
    Write-Host "| 1.Setup all network interface to static IP  |"
    Write-Host "-----------------------------------------------"
    Write-Host "| 2.Setup all network interface to DHCP       |"
    Write-Host "-----------------------------------------------"
    Write-Host "| 3.Disable Firewall                          |"
    Write-Host "-----------------------------------------------"
    Write-Host "| 4.Setup display always turn on              |"
    Write-Host "-----------------------------------------------"
    Write-Host "| 5.Clean all disk except OS                  |"
    Write-Host "-----------------------------------------------"
    Write-Host "| If want to exit,press 'q'                   |"
    Write-Host "-----------------------------------------------"
    $menu = Read-Host "`n key the number and press enter"
    

    switch($menu)
    {
        # Auto mode
        0 {
        Setup_ip_static_default
        disable_firewall
        display_turn_on
        }
        # 1.Setup all network interface to static IP
        1 {Setup_ip_static}

        # 2.Setup all network interface to DHCP
        2 {Setup_ip_dhcp}

        # 3.Disable Firewall
        3 {disable_firewall}

        # 4.Setup display always turn on
        4 {display_turn_on}

        # 5.Clean all disk except OS
        5 {Clean_all_disk}

        # exit program
        q {write-Host " Quit...";Start-Sleep -s 2}

        default {Clear-Host;write-Host " Please enter '1'~'5'or'q'";}


    }
}while($menu -ne 'q')