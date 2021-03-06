function Get-TargetResource {
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param (
		[parameter(Mandatory = $true)]
		[System.Int32]
		$Time,

		[ValidateSet("Absent","Present")]
		[System.String]
		$Ensure
	)

    $returnValue = @{
		Ensure = "Absent"
	}

    Write-Verbose "Get the Windows Server Update Service Installation time"

    $InstallTime = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU' -Name ScheduledInstallTime -ErrorAction SilentlyContinue).ScheduledInstallTime 
    
    if(($InstallTime -ne $null) -and ($Ensure -eq "Absent" -or $InstallTime -eq $Time)){ $returnValue.Ensure = "Present" }
    
    $returnValue
}


function Set-TargetResource {
	[CmdletBinding()]
	param (
		[parameter(Mandatory = $true)]
		[System.Int32]
		$Time,

		[ValidateSet("Absent","Present")]
		[System.String]
		$Ensure
	)

    if($Ensure -eq "Present"){

        if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU")) {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate" -Force | Out-Null
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -Force | Out-Null
        }

        Write-Verbose "Set the Windows Server Update Service Installation time to: $time"
        Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name ScheduledInstallTime -Value $Time -type dword -Force
        
    }else {
        Write-Verbose "Remove the Windows Server Update Service Installation time"
        Remove-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name ScheduledInstallTime -Force -EA SilentlyContinue
    }

}


function Test-TargetResource {
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param (
		[parameter(Mandatory = $true)]
		[System.Int32]
		$Time,

		[ValidateSet("Absent","Present")]
		[System.String]
		$Ensure
	)

    Write-Verbose "Test if the Windows Server Update Service Install Time is set to $Time and $Ensure"
    
    $existingResource = Get-TargetResource @PSBoundParameters
    return $existingResource.Ensure -eq $Ensure
}


Export-ModuleMember -Function *-TargetResource

