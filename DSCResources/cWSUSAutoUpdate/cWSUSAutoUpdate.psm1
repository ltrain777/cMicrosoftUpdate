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

    Write-Verbose "Get the Windows Server Update Service Autoupdate status"

    $Status = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU' -Name NoAutoUpdate -ErrorAction SilentlyContinue).NoAutoUpdate 
    
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

        if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU")) {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate" -Force | Out-Null
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -Force | Out-Null
        }

        if ($Enable -eq "False") {
            $value = 1
            Write-Verbose "Disable the Windows Server Update Service Autoupdate"
        }
        else {
            $value = 0
            Write-Verbose "Enable the Windows Server Update Service Autoupdate"
        }

	    Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name NoAutoUpdate -value $value -type dword
    }else{
        Write-Verbose "Remove the Windows Server Update Service No Auto Update setting"
        Remove-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name NoAutoUpdate -force -EA SilentlyContinue
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
    
    Write-Verbose "Test if the Windows Server Update Service Autoupdate Enable is set to: $Enable and $Ensure"
	$existingResource = Get-TargetResource @PSBoundParameters
    return $existingResource.Ensure -eq $Ensure
}


Export-ModuleMember -Function *-TargetResource

