function Choco-Install {
    [CmdletBinding()]
    param (
        [string[]]$Apps
    )

    choco install -y $Apps
}

function Store-Install {
    [CmdletBinding()]
    param (
        [string[]]$Apps
    )

    Write-Host ">> Install those apps from the Microsoft Store:"
    foreach ($app in $Apps) {
        Write-Host "- ${app}" -ForegroundColor Green
    }
}

function Module-Install {
    [CmdletBinding()]
    param (
        [string[]]$Apps
    )

    Write-Host ">> Install those Modules"
    foreach ($app in $Apps) {
        Install-Module -AllowClobber -Confirm:$False -Force -Scope CurrentUser $app
    }
}

Set-PSRepository PSGallery -InstallationPolicy Trusted

Write-Host '>> Install apps'
Choco-Install -Apps `
    7zip, `
    authy-desktop, `
    autohotkey, `
    brave, `
    chocolatey, `
    chocolatey-core.extension, `
    chocolatey-dotnetfx.extension, `
    chocolatey-misc-helpers.extension, `
    chocolatey-windowsupdate.extension, `
    discord, `
    DotNet4.5.2, `
    dotnet4.7, `
    dotnetcore3-desktop-runtime, `
    dotnetfx, `
    ffmpeg, `
    FiraCode, `
    Firefox, `
    foxitreader, `
    fzf, `
    git, `
    KB2919355, `
    KB2919442, `
    KB2999226, `
    KB3033929, `
    KB3035131, `
    microsoft-teams, `
    microsoft-windows-terminal, `
    netfx-4.6.2, `
    powertoys, `
    slack, `
    vcredist140, `
    vcredist2015, `
    vscode



Write-Host '>> Configure Terminal'
Write-Host 'Update config with content of https://raw.githubusercontent.com/jgsqware/dotfile-win/main/WindowsTerminal/settings.json'
Read-Host 'Press ENTER to continue...'

Write-Host '>> Set Brave as default browser'
# Set Brave as default
Invoke-WebRequest https://raw.githubusercontent.com/jgsqware/dotfile-win/main/bin/SetDefaultBrowser.exe -OutFile C:\Users\jgsqware\Downloads\SetDefaultBrowser.exe
$hive = & C:\Users\jgsqware\Downloads\SetDefaultBrowser.exe | out-string -stream | select-string -Pattern '(HKCU) (Brave.*)'

powershell.exe -Command "C:\Users\jgsqware\Downloads\SetDefaultBrowser.exe $hive"
Remove-Item C:\Users\jgsqware\Downloads\SetDefaultBrowser.exe

# Configure TaskBar https://docs.microsoft.com/en-us/windows/configuration/configure-windows-10-taskbar

Write-Host '>> Install Fonts'
Invoke-WebRequest https://github.com/ThatWeirdAndrew/caskaydia-cove/releases/download/v2102.25/CaskaydiaCove.zip -OutFile C:\Users\jgsqware\Downloads\CaskaydiaCove.zip

$source = "C:\Users\jgsqware\Downloads\CaskaydiaCove.zip"
$fontsFolder = "C:\Users\jgsqware\Downloads\CaskaydiaCove"

Expand-Archive -Path $source -DestinationPath $fontsFolder

foreach ($font in Get-ChildItem -Path $fontsFolder -File) {
    $dest = "C:\Windows\Fonts\$font"
    if (Test-Path -Path $dest) {
        "Font $font already installed."
    }
    else {
        $font | Copy-Item -Destination $dest
    }
}
Remove-Item -recurse $env:USERPROFILE\Downloads\CaskaydiaCove*

Store-Install -Apps `
    'Hey: https://www.microsoft.com/store/productId/9PF08LJW7GW2' `
    'Krisp: https://account.krisp.ai/sign-up' `
    'EOS Webcam Utility: https://fr.canon.be/cameras/eos-webcam-utility/' `
    'Docker Desktop: https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe'

Read-Host 'Press ENTER to continue...'

# Latest Powershell
Write-Host '>> Setup Powershell 7.1.4'
$msiFilePath="C:\Users\jgsqware\Downloads\PowerShell-7.1.4-win-x64.msi"
Invoke-WebRequest https://github.com/PowerShell/PowerShell/releases/download/v7.1.4/PowerShell-7.1.4-win-x64.msi -OutFile $msiFilePath

$arguments = "/i `"$msiFilePath`" /quiet ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ENABLE_PSREMOTING=1 REGISTER_MANIFEST=1"
Start-Process msiexec.exe -ArgumentList $arguments -Wait
Remove-Item -recurse C:\Users\jgsqware\Downloads\PowerShell-7.1.4-win-x64.msi

Module-Install -Apps `
    oh-my-posh `
    PSFzf `
    Get-ChildItemColor



# WSL 2
Write-Host '>> Setup WSL 2'
$msiFilePath="C:\Users\jgsqware\Downloads\wsl_update_x64.msi"
Invoke-WebRequest https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi -OutFile $msiFilePath

$arguments = "/i `"$msiFilePath`""
Start-Process msiexec.exe -ArgumentList $arguments -Wait
Remove-Item -recurse C:\Users\jgsqware\Downloads\wsl_update_x64.msi

wsl --set-default-version 2

Write-Host 'Install Ubuntu on WSL:'
Write-Host '  https://www.microsoft.com/en-gb/p/ubuntu-2004-lts/9n6svws3rx71?activetab=pivot:overviewtab' -ForegroundColor Blue
Write-Host 'Open a new Ubuntu shell and run'
Write-Host '  curl -L https://raw.githubusercontent.com/jgsqware/dotfile-win/main/ubuntu-wsl.sh | sh' -ForegroundColor Blue

Read-Host 'Press ENTER to continue...'


Write-Host "
Set-PoshPrompt -Theme material
Remove-PSReadlineKeyHandler 'Ctrl-r'
Import-Module PSFzf
Import-Module Get-ChildItemColor
"
