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

    Write-Host "Install those apps from the Microsoft Store:"
    foreach ($app in $Apps) {
        Write-Host "- ${app}"
    }
}

# choco install -y spotify
Write-Host 'Install apps'
Choco-Install -Apps `
    microsoft-windows-terminal, `
    discord, `
    enpass.install, `
    vscode, `
    brave

Remove-Item "$env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
Invoke-WebRequest https://raw.githubusercontent.com/jgsqware/dotfile-win/main/WindowsTerminal/settings.json -OutFile "$env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    

Store-Install -Apps `
    'Hey: https://www.microsoft.com/store/productId/9PF08LJW7GW2'

# Set Brave as default
Invoke-WebRequest https://raw.githubusercontent.com/jgsqware/dotfile-win/main/bin/SetDefaultBrowser.exe -OutFile $env:USERPROFILE\Downloads\SetDefaultBrowser.exe
$hive = & $env:USERPROFILE\Downloads\SetDefaultBrowser.exe | out-string -stream | select-string -Pattern '(HKCU) (Brave.*)'

powershell.exe -Command "$env:USERPROFILE\Downloads\SetDefaultBrowser.exe $hive"
Remove-Item $env:USERPROFILE\Downloads\SetDefaultBrowser.exe

# Configure TaskBar https://docs.microsoft.com/en-us/windows/configuration/configure-windows-10-taskbar

Invoke-WebRequest https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip -OutFile $env:USERPROFILE\Downloads\JetBrainsMono.zip

$source = '$env:USERPROFILE\Downloads\JetBrainsMono.zip'
$fontsFolder = '$env:USERPROFILE\Downloads\JetBrainsMono'

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
Remove-Item $env:USERPROFILE\Downloads\JetBrainsMono*


# WSL 2

wsl --set-default-version 2

Write-Host 'Install Ubuntu on WSL: https://www.microsoft.com/en-gb/p/ubuntu-2004-lts/9n6svws3rx71?activetab=pivot:overviewtab'
Write-Host 'Open a new Ubuntu shell and run'
Write-Host 'curl -L https://raw.githubusercontent.com/jgsqware/dotfile-win/main/ubuntu-wsl.sh | sh'

Read-Host 'Press ENTER to continue...'
