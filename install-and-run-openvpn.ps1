# =======================================================================================================================================================================
# Purpose : Testing/Development
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
<#
.SYNOPSIS
    Configures Windows and Edge policies and settings through the registry.

.DESCRIPTION
    This script sets various registry keys to configure policies for Windows and Microsoft Edge. It ensures that specific 
    sub-keys are created if they do not exist and sets policies to allow apps access to the camera, disable the Start Menu, 
    disable the Task Manager, and disable the Command Prompt. Additionally, it opens Microsoft Edge with a specific URL.

.VERSION
    1.0 (2024-07-02)

.NOTES
    Author: Tim Krebs
    Date: 2024-07-02
    Script Version: 1.0
#>

function Set-RegistryKey {
    param (
        [string]$Path,
        [string]$Name,
        [string]$Value,
        [string]$PropertyType = "DWORD"
    )

    if (-NOT (Test-Path $Path)) {
        New-Item -Path $Path -Force | Out-Null
    }
    New-ItemProperty -Path $Path -Name $Name -Value $Value -PropertyType $PropertyType -Force | Out-Null
}

# Ensure that the sub-key is created if it doesn't exist
if (-not (Test-Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy")) {
    New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Force
}

# Set the policy to allow apps access to the camera
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessCamera" -Value 1 -PropertyType DWord -Force

New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessCamera_ForceAllowTheseApps" -PropertyType MultiString -Force
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessCamera_ForceDenyTheseApps" -PropertyType MultiString -Force
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessCamera_UserInControlOfTheseApps" -PropertyType MultiString -Force


# Disable Start Menu
Set-RegistryKey -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoStartMenuMFUprogramsList" -Value 1

# Set registry key for HubsSidebarEnabled
Set-RegistryKey -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "HubsSidebarEnabled" -Value 0

# Disable Task Manager
Set-RegistryKey -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "DisableTaskMgr" -Value 1

# Disable Command Prompt
Set-RegistryKey -Path "HKCU:\Software\Policies\Microsoft\Windows\System" -Name "DisableCMD" -Value 2

# Open Microsoft Edge with a specific URL (without kiosk mode)
Start-Process "msedge.exe" -ArgumentList "https://www.microsoft.com"
