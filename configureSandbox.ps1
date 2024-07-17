# Install certificate
$params = @{
    Filepath = "C:\CertStore\<CERT-NAME>.cer"
    CertStoreLocation = "Cert:\LocalMachine\Root"
}
Import-Certificate @params

# Ensure that the sub-key is created if it doesn't exist
if (-not (Test-Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy")) {
    New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Force
}
# Set the policy to allow apps access to the camera
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessCamera" -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessCamera_ForceAllowTheseApps" -PropertyType MultiString -Force
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessCamera_ForceDenyTheseApps" -PropertyType MultiString -Force
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessCamera_UserInControlOfTheseApps" -PropertyType MultiString -Force

# Open Microsoft Edge with a specific URL (without kiosk mode)
Start-Process "msedge.exe" -Wait -WindowStyle Maximized -ArgumentList "https://www.microsoft.com"