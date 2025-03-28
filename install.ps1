# Losetta Install Script for Windows
# This script detects the system architecture and downloads the appropriate version of Alice.
# Usage: iwr "https://alice.wsoft.ws/install.ps1" | iex

# Detect the system architecture
$is64Bit = [Environment]::Is64BitOperatingSystem
$isArm = $false

Write-Host "* Losetta Installer *"

# Check if we're running on ARM architecture
try {
    # Import the required assembly for RuntimeInformation
    Add-Type -TypeDefinition @"
    using System.Runtime.InteropServices;
    public class ArchitectureInfo {
        public static System.Runtime.InteropServices.Architecture GetArchitecture() {
            return RuntimeInformation.ProcessArchitecture;
        }
    }
"@
    $architecture = [ArchitectureInfo]::GetArchitecture()
    $isArm = $architecture -eq "Arm" -or $architecture -eq "Arm64"
} 
catch {
    # Fallback method if the above doesn't work
    $processorArchitecture = $env:PROCESSOR_ARCHITECTURE
    if ($processorArchitecture -like "*ARM*") {
        $isArm = $true
    }
}

# Determine the URL based on architecture
if ($isArm) {
    if ($is64Bit) {
        $url = "https://download.wsoft.ws/WS00150/alice.exe"  # ARM64
        $archName = "ARM64"
    } else {
        $url = "https://download.wsoft.ws/WS00151/alice.exe"    # ARM
        $archName = "ARM"
    }
} else {
    if ($is64Bit) {
        $url = "https://download.wsoft.ws/WS00148/alice.exe"  # AMD64
        $archName = "AMD64"
    } else {
        $url = "https://download.wsoft.ws/WS00149/alice.exe"    # x86
        $archName = "x86"
    }
}

# Destination path
$destination = Join-Path -Path $env:USERPROFILE -ChildPath "alice.exe"

try {
    Write-Host "Losetta for Windows ($archName) will install"
    Write-Host "from: $url"
    Write-Host "to: $destination"
    
    # Download the file
    Invoke-WebRequest -Uri $url -OutFile $destination -ErrorAction Stop
    Write-Host "Successfully downloaded file from $url to $destination"

    Write-Host "Downloading script..."
    Start-Process -FilePath $destination -ArgumentList "install --args https://alice.wsoft.ws/icebuild.ice icebuild" -Wait -NoNewWindow
    Write-Host "Installation completed successfully."
}
catch {
    Write-Error "Failed to download the file: $_"
}
