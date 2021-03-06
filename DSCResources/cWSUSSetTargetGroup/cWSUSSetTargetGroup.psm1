function Get-TargetResource {
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param (
		[parameter(Mandatory = $true)]
		[System.String]
		$TargetGroup,

		[ValidateSet("Absent","Present")]
		[System.String]
		$Ensure
	)

    $returnValue = @{
		Ensure = "Absent"
	}

    $Status = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate' -Name TargetGroupEnabled -ErrorAction SilentlyContinue).TargetGroupEnabled 
    $TargetGroupReg = (Get-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate" -name TargetGroup -ErrorAction SilentlyContinue).TargetGroup
    
    if($Status -eq $null -and $TargetGroupReg -eq $null){ return $returnValue }
    
    if($Status -eq "1"){ 
        $Status = "True"
    }
    else {
        $Status = "False"
    }
    if((($Ensure -eq "Absent") -and ($Status -ne $null -or $TargetGroupReg -ne $null)) -or ($TargetGroupReg -eq $TargetGroup)) {
        $returnValue.Ensure = "Present"
    }

	$returnValue
}


function Set-TargetResource {
	[CmdletBinding()]
	param (
		[parameter(Mandatory = $true)]
		[System.String]
		$TargetGroup,

		[ValidateSet("Absent","Present")]
		[System.String]
		$Ensure
	)

    if ($Ensure -eq "Present") {

        if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate")) {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate" -Force | Out-Null
        }

        Write-Verbose "Set the Windows Server Update Service Target group to: $TargetGroup"
        Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate" -name TargetGroupEnabled -value 1 -type dword -force
        Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate" -name TargetGroup -value $TargetGroup -type String -force
    }else {
        Write-Verbose "Remove the Windows Server Update Service Target group"
        Remove-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate" -name TargetGroupEnabled -force
        Remove-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate" -name TargetGroup -force
    }
    
    
   
}


function Test-TargetResource {
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param (
		[parameter(Mandatory = $true)]
		[System.String]
		$TargetGroup,

		[ValidateSet("Absent","Present")]
		[System.String]
		$Ensure
	)
    
    Write-Verbose "Test if the Windows Server Update Service Target group is set to: $TargetGroup and $Ensure"
    $existingResource = Get-TargetResource @PSBoundParameters
    return $existingResource.Ensure -eq $Ensure

}

Export-ModuleMember -Function *-TargetResource

