Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope currentuser

Clear-Host

# Check for Winget
if ($null -eq (Get-Command "winget" -ErrorAction SilentlyContinue)) 
{ 
   Write-Host "Unable to find winget. Please install via Windows Store"
}

# Configure WinGet
Write-Output "Configuring winget"

#winget config path from: https://github.com/microsoft/winget-cli/blob/master/doc/Settings.md#file-location
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json";
$settingsJson = 
@"
    {
        "installBehavior": {
            "preferences": {
                "scope": "user"
            },
            "portablePackageUserRoot": "C:/Users/marti/Apps/Packages",
            "defaultInstallRoot": "C:/Users/marti/Apps/Packages",
            "portablePackageMachineRoot": "C:/Users/marti/Apps/Packages"
        },
    }
"@;
$settingsJson | Out-File $settingsPath -Encoding utf8

# Install apps
Write-Output "Installing Apps"
$apps = @(
    @{name = "Microsoft.PowerToys" }, 
    @{name = "Slack"; source = "msstore" },
    @{name = "Microsoft Teams"; source = "msstore" },
    @{name = "Enpass Password Manager"; source = "msstore" },
    @{name = "AgileBits.1Password" },
    @{name = "bitwarden"; source = "msstore" },
    @{name = "OpenWhisperSystems.Signal" },
    @{name = "Notion.Notion" },
    @{name = "Toggl Track"; source = "msstore" },
    @{name = "VideoLAN.VLC" },
    @{name = "7zip.7zip" },
    @{name = "Valve.Steam" },
    @{name = "Telegram.TelegramDesktop" },
    @{name = "Spotify"; source = "msstore" },
    @{name = "Microsoft.VisualStudioCode" },
    @{name = "JetBrains.Toolbox" },
    @{name = "Microsoft.PowerShell" },  
    @{name = "Windows Terminal"; source = "msstore" },  
    @{name = "Docker.DockerDesktop" },
    @{name = "Microsoft.DotNet.SDK.7" },
    @{name = "OpenJS.NodeJS" },
    @{name = "Axosoft.GitKraken" },
    @{name = "Git.Git" },
    @{name = "JanDeDobbeleer.OhMyPosh" },
    @{name = "Synology.DriveClient" }
);

Foreach ($app in $apps) {
    $listApp = winget list --exact -q $app.name
    if (![String]::Join("", $listApp).Contains($app.name)) {
        Write-host "Installing:" $app.name
        if ($app.source -ne $null) {
            winget install --silent $app.name --source $app.source
        }
        else {
            winget install --exact --silent $app.name 
        }
    }
    else {
        Write-host "Skipping Install of " $app.name
    }
}
