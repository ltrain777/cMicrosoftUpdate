Param(
    
        [String]$UseWUServer = "",
        
        [String]$WSUSServerUrl,
        
        [ValidateSet("Absent","Present","")]
        [String]$WSUSServerEnsure = "",
        
        [String]$TargetGroup,

        [ValidateSet("Absent","Present","")]
        [String]$TargetGroupEnsure = "",
        
        [ValidateSet("Notify","DownloadOnly","DownloadAndInstall","Disable","AllowUserConfig","")]
        [String]$WSUSMode = "",

        [ValidateSet("Absent","Present","")]
        [String]$WSUSModeEnsure = "",

        [String]$WSUSNoAccess,

        [ValidateSet("Absent","Present","")]
        [String]$WSUSNoAccessEnsure = "",

        [String]$WSUSNoAutoRebootLoggedOnUser,

        [ValidateSet("Absent","Present","")]
        [String]$WSUSNoAutoRebootLoggedOnUserEnsure = "",

        [String]$WSUSNoAutoUpdate,

        [ValidateSet("Absent","Present","")]
        [String]$WSUSNoAutoUpdateEnsure = "",

        [String]$WSUSInstallDay,

        [ValidateSet("Absent","Present","")]
        [String]$WSUSInstallDayEnsure = ""

)

Import-Module $PSScriptRoot\WSUSConfigDSC.psm1

cd

 
TestWSUS -UseWUServer $UseWUServer -WSUSServerEnsure $WSUSServerEnsure -WSUSServerUrl $WSUSServerUrl -TargetGroupEnsure $TargetGroupEnsure -TargetGroup $TargetGroup `
        -WSUSModeEnsure $WSUSModeEnsure -WSUSMode $WSUSMode -WSUSNoAccessEnsure $WSUSNoAccessEnsure -WSUSNoAccess $WSUSNoAccess `
        -WSUSNoAutoRebootLoggedOnUserEnsure $WSUSNoAutoRebootLoggedOnUserEnsure -WSUSNoAutoRebootLoggedOnUser $WSUSNoAutoRebootLoggedOnUser `
        -WSUSNoAutoUpdateEnsure $WSUSNoAutoUpdateEnsure -WSUSNoAutoUpdate $WSUSNoAutoUpdate -WSUSInstallDayEnsure $WSUSInstallDayEnsure -WSUSInstallDay $WSUSInstallDay


#TestWSUS -WSUSServerEnsure "Absent" -WSUSServerUrl "http://127.0.0.1:8080"


Start-DscConfiguration -Path .\TestWSUS -Wait -Force -Verbose
