# Detect the system architecture
$is64Bit = [Environment]::Is64BitOperatingSystem
$isArm = $false

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
    Write-Host "Detected architecture: $archName"
    Write-Host "Downloading from URL: $url"
    
    # Download the file
    Invoke-WebRequest -Uri $url -OutFile $destination -ErrorAction Stop
    Write-Host "Successfully downloaded file from $url to $destination"
}
catch {
    Write-Error "Failed to download the file: $_"
}
