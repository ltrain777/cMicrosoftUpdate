Configuration TestWSUS {

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


    Import-DscResource -modulename cMicrosoftUpdate
 
    Node localhost {
        
        if(![String]::IsNullOrEmpty($UseWUServer)){
            cWSUSEnable WSUSEnable {
                Enable = $UseWUServer
            }
        }
        
        if(![String]::IsNullOrEmpty($WSUSServerEnsure)){
            cWSUSSetServer WSUSServer {
                Url = $WSUSServerUrl
                Ensure = $WSUSServerEnsure
            }
        }
 
        if(![String]::IsNullOrEmpty($TargetGroupEnsure)){
            cWSUSSetTargetGroup TargetGroupDMZ {
                TargetGroup = $TargetGroup
                Ensure = $TargetGroupEnsure
            }
        }
 
        if(![String]::IsNullOrEmpty($WSUSModeEnsure)){
            cWSUSUpdateMode WSUSMode {
                Mode = $WSUSMode
                Ensure = $WSUSModeEnsure
            }
        }
      
        if(![String]::IsNullOrEmpty($WSUSNoAccessEnsure)){
            cWSUSWindowsUpdateAccess WSUSNoAccess {
                Enable = $WSUSNoAccess
                Ensure = $WSUSNoAccessEnsure
            }
        }

        if(![String]::IsNullOrEmpty($WSUSNoAutoRebootLoggedOnUserEnsure)){
            cWSUSAutoRebootWithLoggedOnUsers WSUSNoAutoRebootLoggedOnUser {
                Enable = $WSUSNoAutoRebootLoggedOnUser
                Ensure = $WSUSNoAutoRebootLoggedOnUserEnsure
            }
        }

        if(![String]::IsNullOrEmpty($WSUSNoAutoUpdateEnsure)){
            cWSUSAutoUpdate WSUSNoAutoUpdate {
                Enable = $WSUSNoAutoUpdate
                Ensure = $WSUSNoAutoUpdateEnsure
            }
        }

        if(![String]::IsNullOrEmpty($WSUSInstallDayEnsure)){
            cWSUSInstallDay WSUSInstallDay {
                Day = $WSUSInstallDay
                Ensure = $WSUSInstallDayEnsure
            }
        }
        
    }
}

