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
	
    Write-Verbose "Get the Windows Server Update Service Elevate Non Admins is Enabled"

    $Status = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate' -Name ElevateNonAdmins -ErrorAction SilentlyContinue).ElevateNonAdmins 
    
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

    Write-Verbose "Set the Windows Server Update Service Elevate Non Admins is Enabled to: $Enable"

	if($Ensure -eq "Present"){

        if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate")) {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate" -Force | Out-Null
        }

        if ($Enable -eq "True") {
            Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate" -name ElevateNonAdmins -Value 1 -type dword -Force
        }
        else {
            Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate" -name ElevateNonAdmins -Value 0 -type dword -Force
        }
    }else{
        Write-Verbose "Remove the Windows Server Update Service Elevate Non Admins setting"
        Remove-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate" -name ElevateNonAdmins -force -EA SilentlyContinue
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

	Write-Verbose "Test if the Windows Server Update Service Elevate Non Admins is set to: $Enable and $Ensure"

    $existingResource = Get-TargetResource @PSBoundParameters
    return $existingResource.Ensure -eq $Ensure
}


Export-ModuleMember -Function *-TargetResource

