# Configuration.md

## Purpose
This script configures a Windows 10/11 sandbox environment with specific settings and restrictions. The script includes functionality for installing certificates, enabling camera and microphone access, disabling PowerShell and CMD, and opening Microsoft Edge with a specific URL.

## Disclaimer
The sample scripts provided here are not supported under any Microsoft standard support program or service. All scripts are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample scripts and documentation remains with you. In no event shall Microsoft, its authors, or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages.

## Script Sections

### Install Certificate
```powershell
$params = @{
    Filepath = "C:\CertStore\<CERT-NAME>.cer"
    CertStoreLocation = "Cert:\LocalMachine\Root"
}
Import-Certificate @params
```
This section installs a specified certificate into the local machine's root certificate store. Replace `<CERT-NAME>` with the actual certificate name.

### Enable Camera and Microphone
```powershell
if (-not (Test-Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy")) {
    New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Force
}
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessCamera" -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessCamera_ForceAllowTheseApps" -PropertyType MultiString -Force
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessCamera_ForceDenyTheseApps" -PropertyType MultiString -Force
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessCamera_UserInControlOfTheseApps" -PropertyType MultiString -Force
```
This section configures the sandbox to allow apps access to the camera and microphone. It creates necessary registry keys and sets relevant policies.

### Disable Powershell and CMD
```powershell
$explorerKeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
if (-not (Test-Path $explorerKeyPath)) {
    New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies" -Name "Explorer" -Force
}

New-ItemProperty -Path $explorerKeyPath -Name "DisallowRun" -PropertyType DWORD -Value 1 -Force

$disallowRunKeyPath = "$explorerKeyPath\DisallowRun"
if (-not (Test-Path $disallowRunKeyPath)) {
    New-Item -Path $explorerKeyPath -Name "DisallowRun" -Force
}

$programsToBlock = @("powershell.exe", "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe", "cmd.exe")

$count = 1
foreach ($program in $programsToBlock) {
    New-ItemProperty -Path $disallowRunKeyPath -Name $count -PropertyType String -Value $program -Force
    $count++
}

Stop-Process -Name explorer -Force
Start-Process -WindowStyle hidden -Name "explorer.exe"
Set-ExecutionPolicy -ExecutionPolicy Restricted -Scope LocalMachine
```
This section disables PowerShell and CMD by setting registry policies that block their execution. It also restarts Windows Explorer to apply these changes immediately and sets the PowerShell execution policy to 'Restricted'.

### Open Microsoft Edge with a Specific URL
```powershell
Start-Process "msedge.exe" -Wait -WindowStyle Maximized -ArgumentList "https://www.microsoft.com"
```
This section opens Microsoft Edge in maximized window mode and navigates to a specified URL.

## Notes
- Ensure that the paths and parameters in the script are modified according to your specific requirements.
- The script needs to be executed with appropriate permissions to modify registry settings and install certificates.

---