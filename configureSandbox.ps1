# =======================================================================================================================================================================
# Purpose : Sandbox configuration script for Windows 10/11
#
# DISCLAIMER: The sample scripts provided here are not supported under any Microsoft standard support program or service. 
# All scripts are provided AS IS without warranty of any kind.
# Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. 
# The entire risk arising out of the use or performance of the sample scripts and documentation remains with you. 
# In no event shall Microsoft, its authors, or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever 
# (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) 
# arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages. 
# 
# ======================================================================================================================================================================

##############################################################
# Install certificate
##############################################################
$params = @{
    Filepath = "C:\CertStore\<CERT-NAME>.cer"
    CertStoreLocation = "Cert:\LocalMachine\Root"
}
Import-Certificate @params

##############################################################
# Enable Camera and Microphone
##############################################################
# Ensure that the sub-key is created if it doesn't exist
if (-not (Test-Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy")) {
    New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Force
}
# Set the policy to allow apps access to the camera
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessCamera" -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessCamera_ForceAllowTheseApps" -PropertyType MultiString -Force
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessCamera_ForceDenyTheseApps" -PropertyType MultiString -Force
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessCamera_UserInControlOfTheseApps" -PropertyType MultiString -Force

####################################
# Configure Proxy 
####################################
# Set Proxy settings in HKLM for all users

$proxyServer = "proxy.example.com:8080"
$proxyOverride = "*.local;192.168.*"

New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "ProxyEnable" -Value 1 -PropertyType DWORD -Force # Set Proxy Enable
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "ProxyServer" -Value $proxyServer -PropertyType String -Force # Set Proxy Server
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "ProxyOverride" -Value $proxyOverride -PropertyType String -Force # Set Proxy Override
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "ProxySettingsPerUser" -Value 0 -PropertyType DWORD -Force # Notify system about proxy settings change


##############################################################
# Disable Powershell
##############################################################
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

# Restart Explorer to apply changes immediately
Stop-Process -Name explorer -Force
Start-Process -WindowStyle hidden -Name "explorer.exe"
Set-ExecutionPolicy -ExecutionPolicy Restricted -Scope LocalMachine

##############################################################
# Open Microsoft Edge with a specific URL (without kiosk mode)
##############################################################
Start-Process "msedge.exe" -Wait -WindowStyle Maximized -ArgumentList "https://www.microsoft.com"
