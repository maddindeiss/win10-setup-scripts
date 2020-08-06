Clear-Host

Write-Host "This will only work with PowerShell 7"

$profilePath = "$Home/Documents/Powershell/Microsoft.PowerShell_profile.ps1"
$profilePathTest = test-path $profilePath

Write-Host "Installing posh-git"

Install-Module posh-git -Scope CurrentUser
Install-Module oh-my-posh -Scope CurrentUser
Install-Module -Name PSReadLine -Scope CurrentUser -Force -SkipPublisherCheck

If ($profilePathTest -eq $True) {
    Write-Host "Profile is already created!"
    exit 0
}

Write-Host "Create Profile"
New-Item $profilePath -ItemType File -Force

Add-Content $profilePath "Import-Module posh-git"
Add-Content $profilePath "Import-Module oh-my-posh"
Add-Content $profilePath "Set-Theme Paradox"
