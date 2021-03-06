function Get-TargetResource {
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param (
		[parameter(Mandatory = $true)]
		[ValidateSet("EveryDay","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday")]
		[System.String]
		$Day,

		[ValidateSet("Absent","Present")]
		[System.String]
		$Ensure
	)

    $returnValue = @{
		Ensure = "Absent"
	}

	Write-Verbose "Get the Windows Server Update Service Installation day"
    
    $InstallDayFlag = (Get-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name ScheduledInstallDay -EA SilentlyContinue).ScheduledInstallDay
    
    Switch ($InstallDayFlag) {
            "0"      {$InstallDay = "EveryDay"}
            "1"      {$InstallDay = "Sunday"}
            "2"      {$InstallDay = "Monday"}
            "3"      {$InstallDay = "Thuesday"}
            "4"      {$InstallDay = "Wednesday"}
            "5"      {$InstallDay = "Thursday"}
            "6"      {$InstallDay = "Friday"}
            "7"      {$InstallDay = "Saturday"}
    }

    if((($Ensure -eq "Absent") -and $InstallDayFlag -ne $null) -or ($InstallDay -eq $Day)){ 
        $returnValue.Ensure = "Present" 
    }
    
    $ReturnValue
}


function Set-TargetResource {
	[CmdletBinding()]
	param (
		[parameter(Mandatory = $true)]
		[ValidateSet("EveryDay","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday")]
		[System.String]
		$Day,

		[ValidateSet("Absent","Present")]
		[System.String]
		$Ensure
	)

     if ($Ensure -eq "Present") { 
        Write-Verbose "Set the Windows Server Update Service Installation day to $Day"
        
        Switch ($Day) {
            "EveryDay"      {$InstallDayFlag = 0}
            "Sunday"        {$InstallDayFlag = 1}
            "Monday"        {$InstallDayFlag = 2}
            "Thuesday"      {$InstallDayFlag = 3}
            "Wednesday"     {$InstallDayFlag = 4}
            "Thursday"      {$InstallDayFlag = 5}
            "Friday"        {$InstallDayFlag = 6}
            "Saturday"      {$InstallDayFlag = 7}
        }

        Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name ScheduledInstallDay -Value $InstallDayFlag -type dword -force
     }
     else { 
        Write-Verbose "Unset the Windows Server Update Service Installation day"
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name ScheduledInstallDay -Force
     }

	 

}


function Test-TargetResource {
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param (
		[parameter(Mandatory = $true)]
		[ValidateSet("EveryDay","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday")]
		[System.String]
		$Day,

		[ValidateSet("Absent","Present")]
		[System.String]
		$Ensure
	)
    
    $existingResource = Get-TargetResource @PSBoundParameters
    return $existingResource.Ensure -eq $Ensure
}


Export-ModuleMember -Function *-TargetResource

