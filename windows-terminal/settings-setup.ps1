Write-Host "Copy Windows-Terminal settings.json"

Copy-Item settings.json (Join-Path (Get-ChildItem -Path $env:userprofile\AppData\Local\Packages -Filter "Microsoft.WindowsTerminal_*" -Directory).Fullname "LocalState") -Force
