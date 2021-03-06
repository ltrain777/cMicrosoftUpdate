function Get-TargetResource {
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param (
		[parameter(Mandatory = $true)]
		[ValidateSet("False","True")]
		[System.String]
		$Enable,

		[ValidateSet("Absent","Present")]
		[System.String]
		$Ensure
	)

    $returnValue = @{
		Ensure = "Absent"
	}

    Write-Verbose "Get the status of Windows Server Update Service Windows Update Access."
	$Status = (Get-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate" -name DisableWindowsUpdateAccess -ErrorAction SilentlyContinue).DisableWindowsUpdateAccess 
    
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
		[ValidateSet("False","True")]
		[System.String]
		$Enable,

		[ValidateSet("Absent","Present")]
		[System.String]
		$Ensure
	)

    if($Ensure -eq "Present"){

        if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate")) {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate" -Force | Out-Null
        }

        if ($Enable -eq 'True') {
            Write-Verbose "Disable the access to Windows Server Update Service Windows Update Access."
            $value = '1' 
        }
        else {
            Write-Verbose "Enable the access to Windows Server Update Service Windows Update Access."
            $value = '0'
        }
    
	    Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate" -name DisableWindowsUpdateAccess -Value $value -type dword
    }else{
        Write-Verbose "Remove the Windows Server Update Service Update Access"
        Remove-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate" -name DisableWindowsUpdateAccess -force -EA SilentlyContinue
    }


}


function Test-TargetResource {
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param (
		[parameter(Mandatory = $true)]
		[ValidateSet("False","True")]
		[System.String]
		$Enable,

		[ValidateSet("Absent","Present")]
		[System.String]
		$Ensure
	)

    Write-Verbose "Test if no access to Windows Server Update Service Windows Update Access is set to: $Enable and $Ensure"

	$existingResource = Get-TargetResource @PSBoundParameters
    return $existingResource.Ensure -eq $Ensure
}


Export-ModuleMember -Function *-TargetResource

