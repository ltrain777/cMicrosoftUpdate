function Get-TargetResource {
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param (
		[parameter(Mandatory = $true)]
		[System.Int32]
		$Frequency,

		[ValidateSet("Absent","Present")]
		[System.String]
		$Ensure
	)

    $returnValue = @{
		Ensure = "Absent"
	}

    Write-Verbose "Get the Windows Server Update Service Installation frequency"

    $Status = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU' -Name DetectionFrequencyEnabled -ErrorAction SilentlyContinue).DetectionFrequencyEnabled 
    $FrequencyReg = (Get-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name DetectionFrequency -ErrorAction SilentlyContinue).DetectionFrequency
    
    if($Status -eq $null -and $FrequencyReg -eq $null){ return $returnValue }
    
    if($Status -eq "1"){ 
        $Status = "True"
    }
    else {
        $Status = "False"
    }
    if((($Ensure -eq "Absent") -and ($Status -ne $null -or $FrequencyReg -ne $null)) -or ($FrequencyReg -eq $Frequency)) {
        $returnValue.Ensure = "Present"
    }

	$returnValue

}


function Set-TargetResource {
	[CmdletBinding()]
	param (
		[parameter(Mandatory = $true)]
		[System.Int32]
		$Frequency,

		[ValidateSet("Absent","Present")]
		[System.String]
		$Ensure
	)

    if ($Ensure -eq "Present") {

        if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU")) {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate" -Force | Out-Null
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -Force | Out-Null
        }

        Write-Verbose "Set & Enable the installation frequency to $Frequency in the Windows Server Update Service."
        Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name DetectionFrequencyEnabled -value 1 -type dword -Force
        Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name DetectionFrequency -Value $Frequency -type dword -Force

    }else {
        Write-Verbose "Remove the installation frequency in the Windows Server Update Service."
        Remove-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name DetectionFrequencyEnabled -Force -EA SilentlyContinue
        Remove-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name DetectionFrequency -Force -EA SilentlyContinue
    }

}


function Test-TargetResource {
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param (
		[parameter(Mandatory = $true)]
		[System.Int32]
		$Frequency,

		[ValidateSet("Absent","Present")]
		[System.String]
		$Ensure
	)

    Write-Verbose "Test if the installation frequency in the Windows Server Update Service is set to $Frequency and $Ensure."

    $existingResource = Get-TargetResource @PSBoundParameters
    return $existingResource.Ensure -eq $Ensure
}


Export-ModuleMember -Function *-TargetResource

