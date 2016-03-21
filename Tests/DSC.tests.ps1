if(!(Test-Path "$ProjectRoot\Artifacts")){
    New-Item "$ProjectRoot\Artifacts" -ItemType Directory
}

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\WSUSConfig.ps1" -UseWUServer "True" -WSUSServerEnsure "Present" -WSUSServerUrl "http://127.0.0.1:8080" -WSUSModeEnsure "Present" -WSUSMode "Notify" `
                         -TargetGroupEnsure "Present" -TargetGroup "DMZPrivate" -WSUSNoAccessEnsure "Present" -WSUSNoAccess "False" `
                         -WSUSNoAutoRebootLoggedOnUserEnsure "Present" -WSUSNoAutoRebootLoggedOnUser "False" -WSUSNoAutoUpdateEnsure "Present" -WSUSNoAutoUpdate "False" `
                         -WSUSInstallDayEnsure "Present" -WSUSInstallDay "Monday"

Copy-Item "$ProjectRoot\TestWSUS\localhost.mof" "$ProjectRoot\Artifacts\Test1.mof" -Force

Describe "Validate your Default WSUS Configuration" {
    
    $Global = Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate
    $Configuration = Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU
 
    It "Automatic updates enabled with WSUS Server" {
        $Configuration.UseWUServer | Should be "1"
    }
 
    It "WSUS Server setted to http://127.0.0.1:8080" {
        $Global.WUServer | Should be "http://127.0.0.1:8080"
    }

    It "WSUS Status Server setted to http://127.0.0.1:8080" {
        $Global.WUStatusServer | Should be "http://127.0.0.1:8080"
    }
    
    It "AU Options should be set to notify" {
        $Configuration.AUOptions | Should be "2"
    }
 
    It "Target group is set to DMZ Private" {
        $Global.TargetGroup | Should be "DMZPrivate"
    }
 
    It "Target Group Enabled" {
        $Global.TargetGroupEnabled | Should be "1"
    }   
 
    It "User can access windows updates site" {
        $Global.DisableWindowsUpdateAccess  | Should be "0"
    }

    It "Disable Auto Reboot for Logged on Users" {
        $Configuration.NoAutoRebootWithLoggedOnUsers  | Should be "1"
    }

    It "Disable Auto Update" {
        $Configuration.NoAutoUpdate  | Should be "1"
    }

    It "Scheduled install day should be Monday" {
        $Configuration.ScheduledInstallDay  | Should be "2"
    }
    
}

. "$here\WSUSConfig.ps1" -UseWUServer "False" -WSUSServerEnsure "Absent" -WSUSServerUrl "http://127.0.0.1:8080" -WSUSModeEnsure "Absent" -WSUSMode "Notify" `
                         -TargetGroupEnsure "Absent" -TargetGroup "DMZPrivate" -WSUSNoAccessEnsure "Absent" -WSUSNoAccess "False" `
                         -WSUSNoAutoRebootLoggedOnUserEnsure "Absent" -WSUSNoAutoRebootLoggedOnUser "False" -WSUSNoAutoUpdateEnsure "Absent" -WSUSNoAutoUpdate "False" `
                         -WSUSInstallDayEnsure "Absent" -WSUSInstallDay "Monday"

Copy-Item "$ProjectRoot\TestWSUS\localhost.mof" "$ProjectRoot\Artifacts\Test2.mof" -Force

Describe "Validate your Default Absent WSUS Configuration" {
    
    $Global = Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate
    $Configuration = Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU
 
    It "Automatic updates enabled with WSUS Server" {
        $Configuration.UseWUServer | Should be "0"
    }
 
    It "WSUS Server removed" {
        $Global.WUServer | Should BeNullOrEmpty
    }

    It "WSUS Status Server removed" {
        $Global.WUStatusServer | Should BeNullOrEmpty
    }
    
    It "AU Options should be removed" {
        $Configuration.AUOptions | Should BeNullOrEmpty
    }
 
    It "Target group should be removed" {
        $Global.TargetGroup | Should BeNullOrEmpty
    }
 
    It "Target Group Enabled removed" {
        $Global.TargetGroupEnabled | Should BeNullOrEmpty
    }   
 
    It "User can access windows updates site should be removed" {
        $Global.DisableWindowsUpdateAccess  | Should BeNullOrEmpty
    }

    It "Disable Auto Reboot for Logged on Users should be removed" {
        $Configuration.NoAutoRebootWithLoggedOnUsers  | Should BeNullOrEmpty
    }

    It "Disable Auto Update should be removed" {
        $Configuration.NoAutoUpdate  | Should BeNullOrEmpty
    }

    It "Scheduled install day should be removed" {
        $Configuration.ScheduledInstallDay  | Should BeNullOrEmpty
    }
    
}


. "$here\WSUSConfig.ps1" -UseWUServer "True"

Copy-Item "$ProjectRoot\TestWSUS\localhost.mof" "$ProjectRoot\Artifacts\Test3.mof" -Force

Describe "Validate UseWUServer module Configuration" {
    
    $Global = Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate
    $Configuration = Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU
 
    It "Automatic updates enabled with WSUS Server" {
        $Configuration.UseWUServer | Should be "1"
    }
 
    It "WSUS Server removed" {
        $Global.WUServer | Should BeNullOrEmpty
    }

    It "WSUS Status Server removed" {
        $Global.WUStatusServer | Should BeNullOrEmpty
    }
    
    It "AU Options should be removed" {
        $Configuration.AUOptions | Should BeNullOrEmpty
    }
 
    It "Target group should be removed" {
        $Global.TargetGroup | Should BeNullOrEmpty
    }
 
    It "Target Group Enabled removed" {
        $Global.TargetGroupEnabled | Should BeNullOrEmpty
    }   
 
    It "User can access windows updates site should be removed" {
        $Global.DisableWindowsUpdateAccess  | Should BeNullOrEmpty
    }

    It "Disable Auto Reboot for Logged on Users should be removed" {
        $Configuration.NoAutoRebootWithLoggedOnUsers  | Should BeNullOrEmpty
    }

    It "Disable Auto Update should be removed" {
        $Configuration.NoAutoUpdate  | Should BeNullOrEmpty
    }

    It "Scheduled install day should be removed" {
        $Configuration.ScheduledInstallDay  | Should BeNullOrEmpty
    }
    
}

. "$here\WSUSConfig.ps1" -WSUSServerEnsure "Present" -WSUSServerUrl "https://127.0.0.1:8081" 

Copy-Item "$ProjectRoot\TestWSUS\localhost.mof" "$ProjectRoot\Artifacts\Test4.mof" -Force

Describe "Validate WSUSServer Present Configuration" {
    
    $Global = Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate
    $Configuration = Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU
 
    It "Automatic updates enabled with WSUS Server" {
        $Configuration.UseWUServer | Should be "1"
    }
 
    It "WSUS Server setted to https://127.0.0.1:8081" {
        $Global.WUServer | Should be "https://127.0.0.1:8081"
    }

    It "WSUS Status Server setted to https://127.0.0.1:8081" {
        $Global.WUStatusServer | Should be "https://127.0.0.1:8081"
    }
    
    It "AU Options should be removed" {
        $Configuration.AUOptions | Should BeNullOrEmpty
    }
 
    It "Target group should be removed" {
        $Global.TargetGroup | Should BeNullOrEmpty
    }
 
    It "Target Group Enabled removed" {
        $Global.TargetGroupEnabled | Should BeNullOrEmpty
    }
 
    It "User can access windows updates site should be removed" {
        $Global.DisableWindowsUpdateAccess  | Should BeNullOrEmpty
    }

    It "Disable Auto Reboot for Logged on Users should be removed" {
        $Configuration.NoAutoRebootWithLoggedOnUsers  | Should BeNullOrEmpty
    }

    It "Disable Auto Update should be removed" {
        $Configuration.NoAutoUpdate  | Should BeNullOrEmpty
    }

    It "Scheduled install day should be removed" {
        $Configuration.ScheduledInstallDay  | Should BeNullOrEmpty
    }
    
}

. "$here\WSUSConfig.ps1" -TargetGroupEnsure "Present" -TargetGroup "DMZPrivate1" 

Copy-Item "$ProjectRoot\TestWSUS\localhost.mof" "$ProjectRoot\Artifacts\Test5.mof" -Force

Describe "Validate WSUSServer Present Configuration" {
    
    $Global = Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate
    $Configuration = Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU
 
    It "Automatic updates enabled with WSUS Server" {
        $Configuration.UseWUServer | Should be "1"
    }
 
    It "WSUS Server setted to https://127.0.0.1:8081" {
        $Global.WUServer | Should be "https://127.0.0.1:8081"
    }

    It "WSUS Status Server setted to https://127.0.0.1:8081" {
        $Global.WUStatusServer | Should be "https://127.0.0.1:8081"
    }
    
    It "AU Options should be removed" {
        $Configuration.AUOptions | Should BeNullOrEmpty
    }
 
    It "Target group is set to DMZ Private" {
        $Global.TargetGroup | Should be "DMZPrivate1"
    }
 
    It "Target Group Enabled" {
        $Global.TargetGroupEnabled | Should be "1"
    }
 
    It "User can access windows updates site should be removed" {
        $Global.DisableWindowsUpdateAccess  | Should BeNullOrEmpty
    }

    It "Disable Auto Reboot for Logged on Users should be removed" {
        $Configuration.NoAutoRebootWithLoggedOnUsers  | Should BeNullOrEmpty
    }

    It "Disable Auto Update should be removed" {
        $Configuration.NoAutoUpdate  | Should BeNullOrEmpty
    }

    It "Scheduled install day should be removed" {
        $Configuration.ScheduledInstallDay  | Should BeNullOrEmpty
    }
    
}