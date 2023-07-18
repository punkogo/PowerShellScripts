# Check if the script is running with administrative privileges
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "Please run this script with administrative privileges."
    Exit
}

# Check if the PSWindowsUpdate module is installed
$module = Get-Module -Name PSWindowsUpdate -ListAvailable
if (-not $module) {
    # Install the PSWindowsUpdate module
    Write-Host "Installing the PSWindowsUpdate module..."
    Install-Module -Name PSWindowsUpdate -Force -Confirm:$false
}

# Import the PSWindowsUpdate module
Import-Module -Name PSWindowsUpdate -Force

# Check for updates
Write-Host "Checking for updates..."
$updates = Get-WindowsUpdate -MicrosoftUpdate

if ($updates.Count -eq 0) {
    Write-Host "No updates available."
    Exit
}

# Install updates
Write-Host "Installing updates..."
Install-WindowsUpdate -AcceptAll -AutoReboot

# Check if any updates failed
$failedUpdates = $updates | Where-Object { $_.ResultCode -ne "0" }
if ($failedUpdates.Count -gt 0) {
    Write-Host "Failed to install some updates:"
    $failedUpdates | ForEach-Object {
        Write-Host $_.Title
    }
} else {
    Write-Host "All updates installed successfully."
}

#To Run the following ps1 script please run 
#