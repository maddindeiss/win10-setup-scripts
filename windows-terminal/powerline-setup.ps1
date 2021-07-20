Clear-Host

Write-Host "This will only work with PowerShell 7"

$profilePath = "$Home/Documents/Powershell/Microsoft.PowerShell_profile.ps1"
$profilePathTest = test-path $profilePath

Write-Host "Installing posh-git"

Install-Module posh-git -Scope CurrentUser
Install-Module oh-my-posh -Scope CurrentUser
Install-Module -Name PSReadLine -Scope CurrentUser -Force -SkipPublisherCheck -AllowPrerelease
Install-Module -Name Terminal-Icons -Repository PSGallery

If ($profilePathTest -eq $True) {
    Write-Host "Profile is already created!"
    exit 0
}

Write-Host "Create Profile"
New-Item $profilePath -ItemType File -Force

Add-Content $profilePath "Import-Module posh-git"
Add-Content $profilePath "Import-Module oh-my-posh"
Add-Content $profilePath "Import-Module PSReadLine"
Add-Content $profilePath "Import-Module -Name Terminal-Icons"
Add-Content $profilePath "Set-PoshPrompt -Theme Paradox"

Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows
