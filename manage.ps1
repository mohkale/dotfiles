# dotfiles installation script for the windows platform
# This just installs a quick and dirty unixy environment and then
# defers to dotty to proceed through the remaining installation.
param([string]$bots="")

function Check-Command($name) {
    return [bool](Get-Command -Name $name -ErrorAction SilentlyContinue)
}

$chocoExists = Check-Command -name "choco"

if (!$chocoExists) {
    Write-Output "install: chocolatey isn't installed, installing"
    $installScript = "https://chocolatey.org/install.ps1"
    $dest = "$([System.IO.Path]::GetTempPath())/choco.ps1"

    Invoke-WebRequest -Uri $installScript -OutFile "$dest"
    Set-ExecutionPolicy Bypass -Scope Process
    . "$dest"
}

# check whether we have a bash like shell installed, and if not install
# git bash for windows as a lightweight bash interpreter. You'll probably
# want to remove this after installation
if (Check-Command "bash") {
    Write-Output "install: you already seem to have a bash installed"
} else {
    if (!(Check-Command "git")) {
        Write-Output "install: bash not found, trying to install git-bash"
        choco install --yes git
        if ($?) {
            Write-Output "install: succesfully installed git-bash"
            Write-Output "install: you may want to uninstall git-bash after dotfile setup"
        } else {
            Write-Output "install: failed to install git-bash, ejecting"
            exit 1
        }
    }
}

RefreshEnv
$bashPath = "$(Split-Path $(Split-Path $(Get-Command git).Source))/bin/bash"
Start-Process -FilePath $bashPath -ArgumentList "-c `"./manage -l DEBUG install -b '$bots'; echo `"Initial install complete, press enter to continue:`" read`""
