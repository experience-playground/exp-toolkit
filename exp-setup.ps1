# exp-toolkit Windows bootstrap
# Installs WSL if needed, then sets up exp-toolkit inside WSL

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "exp-toolkit Windows Setup" -ForegroundColor Cyan
Write-Host "=========================" -ForegroundColor Cyan
Write-Host ""

# Check if running as administrator (needed for WSL install)
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# Check if WSL is installed
$wslInstalled = $false
try {
    $wslVersion = wsl --status 2>&1
    if ($LASTEXITCODE -eq 0) {
        $wslInstalled = $true
    }
} catch {
    $wslInstalled = $false
}

if (-not $wslInstalled) {
    Write-Host "WSL is not installed. Installing..." -ForegroundColor Yellow

    if (-not $isAdmin) {
        Write-Host ""
        Write-Host "ERROR: WSL installation requires administrator privileges." -ForegroundColor Red
        Write-Host "Please re-run this script as Administrator:" -ForegroundColor Red
        Write-Host "  Right-click PowerShell -> Run as Administrator" -ForegroundColor White
        Write-Host "  Then run: irm https://raw.githubusercontent.com/experience-playground/exp-toolkit/master/exp-setup.ps1 | iex" -ForegroundColor White
        exit 1
    }

    Write-Host "Installing WSL with Ubuntu (this may take a few minutes)..." -ForegroundColor Yellow
    wsl --install -d Ubuntu
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: WSL installation failed." -ForegroundColor Red
        Write-Host "You may need to restart your computer and run this script again." -ForegroundColor Red
        exit 1
    }

    Write-Host ""
    Write-Host "WSL installed successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "IMPORTANT: You may need to restart your computer to complete WSL setup." -ForegroundColor Yellow
    Write-Host "After restarting:" -ForegroundColor Yellow
    Write-Host "  1. Open PowerShell" -ForegroundColor White
    Write-Host "  2. Run this script again to finish exp-toolkit setup" -ForegroundColor White
    Write-Host ""
    Read-Host "Press Enter to continue (or restart now if prompted)"
}

# Verify WSL is ready by running a simple command
Write-Host "Checking WSL is ready..." -ForegroundColor Yellow
try {
    $result = wsl bash -c "echo ok" 2>&1
    if ($result -ne "ok") {
        Write-Host "WSL is installed but not fully set up yet." -ForegroundColor Yellow
        Write-Host "Please open 'Ubuntu' from the Start menu to complete first-time setup," -ForegroundColor Yellow
        Write-Host "then run this script again." -ForegroundColor Yellow
        exit 1
    }
} catch {
    Write-Host "WSL is installed but not responding." -ForegroundColor Yellow
    Write-Host "Please open 'Ubuntu' from the Start menu to complete first-time setup," -ForegroundColor Yellow
    Write-Host "then run this script again." -ForegroundColor Yellow
    exit 1
}

Write-Host "WSL is ready." -ForegroundColor Green

# Check if git is available in WSL
$gitCheck = wsl bash -c "type -p git" 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "Installing git inside WSL..." -ForegroundColor Yellow
    wsl bash -c "sudo apt-get update && sudo apt-get install -y git"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Failed to install git in WSL." -ForegroundColor Red
        exit 1
    }
}

# Check if exp-toolkit is already installed
$expExists = wsl bash -c "test -d ~/.exp && echo yes || echo no" 2>&1
if ($expExists.Trim() -eq "yes") {
    Write-Host "exp-toolkit is already installed in WSL. Updating..." -ForegroundColor Yellow
    wsl bash -c "cd ~/.exp && git pull"
} else {
    Write-Host "Cloning exp-toolkit into WSL..." -ForegroundColor Yellow
    wsl bash -c "git clone https://github.com/experience-playground/exp-toolkit.git ~/.exp"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Failed to clone exp-toolkit." -ForegroundColor Red
        exit 1
    }
}

# Run the bash setup inside WSL
Write-Host "Running exp-toolkit setup inside WSL..." -ForegroundColor Yellow
wsl bash -c "~/.exp/exp-setup.sh"

Write-Host ""
Write-Host "================================================" -ForegroundColor Green
Write-Host " exp-toolkit installed successfully!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host ""
Write-Host "To use exp-toolkit:" -ForegroundColor Cyan
Write-Host ""
Write-Host "  1. Open a WSL terminal:" -ForegroundColor White
Write-Host "     - Type 'wsl' in PowerShell or Command Prompt" -ForegroundColor Gray
Write-Host "     - Or open 'Ubuntu' from the Start menu" -ForegroundColor Gray
Write-Host "     - Or use Windows Terminal and select the Ubuntu tab" -ForegroundColor Gray
Write-Host ""
Write-Host "  2. Run exp commands:" -ForegroundColor White
Write-Host "     exp list              # See available tools" -ForegroundColor Gray
Write-Host "     exp nodejs install    # Install Node.js via NVM" -ForegroundColor Gray
Write-Host "     exp java install      # Install Java via SDKMAN" -ForegroundColor Gray
Write-Host "     exp claude install    # Install Claude Desktop/Code" -ForegroundColor Gray
Write-Host ""
