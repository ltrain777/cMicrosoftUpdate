# This script will invoke a DSC configuration
# This is a simple proof of concept

"`n`tPerforming DSC Configuration`n"

Enable-PSRemoting -Force

. .\Tests\WSUSConfig.ps1 -UseWUServer "True" -WSUSServerEnsure "Present" -WSUSServerUrl "http://127.0.0.1:8080" -WSUSModeEnsure "Present" -WSUSMode "Notify" `
                         -TargetGroupEnsure "Present" -TargetGroup "DMZPrivate" -WSUSNoAccessEnsure "Present" -WSUSNoAccess "False" `
                         -WSUSNoAutoRebootLoggedOnUserEnsure "Present" -WSUSNoAutoRebootLoggedOnUser "False" -WSUSNoAutoUpdateEnsure "Present" -WSUSNoAutoUpdate "False" `
                         -WSUSInstallDayEnsure "Present" -WSUSInstallDay "Monday"
 
$mofFile = ( TestWSUS ).FullName
$mofFile
$mofFile | Set-Content -Path .\Artifacts.txt
 
Start-DscConfiguration -Path .\TestWSUS -Wait -Force -verbose
