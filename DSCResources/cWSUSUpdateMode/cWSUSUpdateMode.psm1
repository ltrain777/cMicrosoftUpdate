function Get-TargetResource {
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param (
		[parameter(Mandatory = $true)]
		[ValidateSet("Notify","DownloadOnly","DownloadAndInstall","Disable","AllowUserConfig")]
		[System.String]
		$Mode,

		[ValidateSet("Absent","Present")]
		[System.String]
		$Ensure
	)

    $returnValue = @{
		Ensure = "Absent"
	}

	Write-Verbose "Get the Windows Server Update Service update mode"

    $AUoption = (Get-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name AUOptions -ErrorAction SilentlyContinue).AUOptions

    Switch ($AUoption) {
        "2" {$ModeRef = "Notify"}
        "3" {$ModeRef = "DownloadOnly"}
        "4" {$ModeRef = "DownloadAndInstall"}
        "5" {$ModeRef = "AllowUserConfig"}
    }

    if((($Ensure -eq "Absent") -and $AUoption -ne $null) -or ($ModeRef -eq $Mode)){
        $returnValue.Ensure = "Present"
    }

	$returnValue

}


function Set-TargetResource {
	[CmdletBinding()]
	param (
		[parameter(Mandatory = $true)]
		[ValidateSet("Notify","DownloadOnly","DownloadAndInstall","Disable","AllowUserConfig")]
		[System.String]
		$Mode,

		[ValidateSet("Absent","Present")]
		[System.String]
		$Ensure
	)

    if ($Ensure -eq "Present") { 
	    Write-Verbose "Set the Windows Server Update Service update mode to $Mode"

        if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate")) {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate" -Force | Out-Null
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -Force | Out-Null
        }

        Switch ($Mode) {
            "Notify" {$AUoption = "2"}
            "DownloadOnly" {$AUoption = "3"}
            "DownloadAndInstall" {$AUoption = "4"}
            "AllowUserConfig" {$AUoption = "5"}
        }

        Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name AUOptions -Value $AUoption -type dword -Force
    }else{
        Write-Verbose "Remove the Windows Server Update Service update mode"
        Remove-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name AUOptions -force -EA SilentlyContinue
    }

}


function Test-TargetResource {
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param (
		[parameter(Mandatory = $true)]
		[ValidateSet("Notify","DownloadOnly","DownloadAndInstall","Disable","AllowUserConfig")]
		[System.String]
		$Mode,

		[ValidateSet("Absent","Present")]
		[System.String]
		$Ensure
	)

	Write-Verbose "Test if the Windows Server Update Service update mode is set to $Mode and $Ensure"

    $existingResource = Get-TargetResource @PSBoundParameters
    return $existingResource.Ensure -eq $Ensure
}


Export-ModuleMember -Function *-TargetResource

