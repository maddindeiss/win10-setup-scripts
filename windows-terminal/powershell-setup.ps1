Clear-Host

Write-Host "This will only work with PowerShell 7"

$profilePath = "$Home/Documents/Powershell/Microsoft.PowerShell_profile.ps1"
$profilePathTest = test-path $profilePath


if (Get-Module -ListAvailable -Name posh-git) {
    Write-Host "Updating posh-git"
    Update-Module -Name posh-git -Scope CurrentUser -Force
} 
else {
    Write-Host "Installing posh-git"
    Install-Module -Name posh-git -Scope CurrentUser -Force
}


if (Get-Module -ListAvailable -Name PowerShellGet) {
    Write-Host "Updating PowerShellGet"
    Update-Module -Name PowerShellGet -Scope CurrentUser
} 
else {
    Write-Host "Installing PowerShellGet"
    Install-Module -Name PowerShellGet -Force 
}

Write-Host "Installing oh-my-posh"
Install-Module -Name oh-my-posh -Scope CurrentUser -Force


if (Get-Module -ListAvailable -Name PSReadLine) {
    Write-Host ""
    Write-Host "PSReadLine is already installed. To update check to documentation:"
    Write-Host "https://github.com/PowerShell/PSReadLine#upgrading"
    Write-Host ""
    Write-Host "Close all Powershell windows and run in the CMD.exe:"
    Write-Host 'pwsh.exe -noprofile -command "Install-Module PSReadLine -Force -SkipPublisherCheck -AllowPrerelease"'
    Write-Host ""
} 
else {
    Write-Host "Installing PSReadLine"
    Install-Module -Name PSReadLine -AllowPrerelease -SkipPublisherCheck -Force
}

Write-Host "Installing Terminal-Icons"
Install-Module -Name Terminal-Icons -Repository PSGallery -Scope CurrentUser



#Install Font
Write-Host "Installing Nerd-Font Caskaydia Cove (Cascadia Code)"
$name = "CaskaydiaCoveRegularNerdFontCompleteMonoWindowsCompatible.otf"
curl.exe -fLo $($name) https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/CascadiaCode/Regular/complete/Caskaydia%20Cove%20Regular%20Nerd%20Font%20Complete%20Windows%20Compatible.otf

$Install = $true  # $false to uninstall (or 1 / 0)
$FontsFolder = (New-Object -ComObject Shell.Application).Namespace(0x14)   # Must use Namespace part or will not install properly
$filename = (Get-ChildItem $name).Name
$filepath = (Get-ChildItem $name).FullName
$target = "C:\Windows\Fonts\$($filename)"

If ((-not(Test-Path $target -PathType Container)) -and ($Install -eq $true)) { $FontsFolder.CopyHere($filepath, 16) }   # Following action performs the install, requires user to click on yes


# Setup Powershell profile
$title    = 'Powershell Profile'
$question = 'Are you sure you want to override your powershell profile?'
$choices  = '&Yes', '&No'

$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
if ($decision -eq 0) {
    Write-Host "Override Powershell profile"
    New-Item $profilePath -ItemType File -Force
    
    Add-Content $profilePath "Import-Module posh-git"
    Add-Content $profilePath "Import-Module oh-my-posh"
    Add-Content $profilePath "Import-Module PSReadLine"
    Add-Content $profilePath "Import-Module Terminal-Icons"
    Add-Content $profilePath "Set-PoshPrompt -Theme Paradox"
    
    Add-Content $profilePath "Set-PSReadLineOption -HistorySearchCursorMovesToEnd"
    Add-Content $profilePath "Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward"
    Add-Content $profilePath "Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward"
    
    Add-Content $profilePath "Set-PSReadLineOption -PredictionSource History"
    Add-Content $profilePath "Set-PSReadLineOption -PredictionViewStyle ListView"
    Add-Content $profilePath "Set-PSReadLineOption -EditMode Windows"

} else {
    Write-Host "Profile is already created! Skipped overriding profile."
}
