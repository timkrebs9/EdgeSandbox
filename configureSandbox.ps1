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

# Disable Powershell
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

# Open Microsoft Edge with a specific URL (without kiosk mode)
Start-Process "msedge.exe" -Wait -WindowStyle Maximized -ArgumentList "https://www.microsoft.com"