function Get-TargetResource {
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param (
		[parameter(Mandatory = $true)]
		[ValidateSet("True","False")]
		[System.String]
        $Enable,

		[ValidateSet("Absent","Present")]
		[System.String]
		$Ensure
	)

    $returnValue = @{
		Ensure = "Absent"
	}

	Write-Verbose "Get the value of Windows Server Update Service No automatic reboot with logged on users"

    $Status = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU' -Name NoAutoRebootWithLoggedOnUsers -ErrorAction SilentlyContinue).NoAutoRebootWithLoggedOnUsers 
    
    if($Status -eq $null){ return $returnValue }
    
    if($Status -eq "1"){ 
        $Status = "True"
    }
    else {
        $Status = "False"
    }
    if((($Ensure -eq "Absent") -and $Status -ne $null) -or ($Status -eq $Enable)){
        $returnValue.Ensure = "Present"
    }

	$returnValue
}


function Set-TargetResource {
	[CmdletBinding()]
	param (
		[parameter(Mandatory = $true)]
		[ValidateSet("True","False")]
		[System.String]
        $Enable,

		[ValidateSet("Absent","Present")]
		[System.String]
		$Ensure
	)
    
    if($Ensure -eq "Present"){

        if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU")) {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate" -Force | Out-Null
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -Force | Out-Null
        }

        Write-Verbose "Set the value of Windows Server Update Service No automatic reboot with logged on users to $Enable"
	    if ($Enable -eq "False") {
            Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name NoAutoRebootWithLoggedOnUsers -Value 1 -type dword -Force
        }
        else {
            Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name NoAutoRebootWithLoggedOnUsers -Value 0 -type dword -Force
        }
    }else{
        Write-Verbose "Remove the Windows Server Update Service No Auto Reboot for Logged On Users"
        Remove-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name NoAutoRebootWithLoggedOnUsers -force -EA SilentlyContinue
    }
}


function Test-TargetResource {
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param (
		[parameter(Mandatory = $true)]
		[ValidateSet("True","False")]
		[System.String]
        $Enable,

		[ValidateSet("Absent","Present")]
		[System.String]
		$Ensure
	)

	Write-Verbose "Test if the value of Windows Server Update Service - No automatic reboot with logged on users is: $Enable and $Ensure"
	
    $existingResource = Get-TargetResource @PSBoundParameters
    return $existingResource.Ensure -eq $Ensure
}


Export-ModuleMember -Function *-TargetResource

