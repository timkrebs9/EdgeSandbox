# Function to set registry key if it does not exist
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

# Disable Start Menu
Set-RegistryKey -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoStartMenuMFUprogramsList" -Value 1

# Set registry key for HubsSidebarEnabled
Set-RegistryKey -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "HubsSidebarEnabled" -Value 0

# Path to the OpenVPN installer
#$installerPath = "C:\sandbox\openvpn-install.msi"

# Path to the OpenVPN configuration file
#$configPath = "C:\sandbox\client.ovpn"

# Install OpenVPN client silently
#Start-Process msiexec.exe -Wait -ArgumentList '/I C:\sandbox\openvpn-install.msi /quiet'

# Ensure OpenVPN GUI is not running
#Stop-Process -Name OpenVPNConnect -ErrorAction SilentlyContinue

# Start OpenVPN with the specified config by simulating right-click and selecting "Start OpenVPN on this config file"
#$command = "cmd /c start `"" + $configPath + "`""
#Invoke-Expression $command

# Disable Task Manager
Set-RegistryKey -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "DisableTaskMgr" -Value 1

# Disable Command Prompt
Set-RegistryKey -Path "HKCU:\Software\Policies\Microsoft\Windows\System" -Name "DisableCMD" -Value 2

# Open Microsoft Edge with a specific URL (without kiosk mode)
Start-Process "msedge.exe" -ArgumentList "https://www.microsoft.com"
