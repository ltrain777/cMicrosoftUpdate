function Get-TargetResource {
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param (
		[parameter(Mandatory = $true)]
        [ValidateSet("True","False")]      
		[System.String]
		$Enable
	)
    
    Write-Verbose "Get the Windows Server Update Service Status"
    Try {
        if ((Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU' -Name UseWUServer -ErrorAction SilentlyContinue).UseWUServer -eq "1") {
             $state = "True" 
        }
        else { $state = "False" }
    }
    Catch {
        $state = "False"
    }	
	$returnValue = @{
		Enable = $State
	}

	$returnValue
}


function Set-TargetResource {
	[CmdletBinding()]
	param (
		[parameter(Mandatory = $true)]
        [ValidateSet("True","False")]
		[System.String]
		$Enable
	)

    Write-Verbose "Set the Windows Server Update Service Status to: $Enable"
	if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate" -Force | Out-Null
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -Force | Out-Null
    }
    
    Switch ($Enable) {
        'True' { $value = '1' } 
        'False' { $value = '0' }
    }

    Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name UseWUServer -value $value -Type dword -Force

}


function Test-TargetResource {
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param (
		[parameter(Mandatory = $true)]
        [ValidateSet("True","False")]
		[System.String]
		$Enable
	)

    Write-Verbose "Test if the Windows Server Update Service Status is set to: $Enable"
	Try {
        $State = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU' -Name UseWUServer -ErrorAction SilentlyContinue).UseWUServer
    }
    Catch {
        $State = "0"
    }

    Switch ($Enable) {
        'True' { 
            if ($State -eq "1") {
                $Return = $true
            }
            elseif ($state -eq "0") {
                $Return = $false
            }
        }
        'False' {
            if ($State -eq "1") {
                $Return = $false
            }
            elseif ($state -eq "0") {
                $Return = $true
            }
        }
    }
    $Return
}


Export-ModuleMember -Function *-TargetResource

