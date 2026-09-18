# Installs (or reinstalls) the ClearDesk agent on this PC from the public
# releases feed, without opening a browser.
#
#   powershell -ExecutionPolicy Bypass -File scripts\install-agent.ps1
#
# or, on a PC without a checkout, from the copy published in the releases repo:
#
#   irm https://raw.githubusercontent.com/Shubhamji038/ClearDesk-releases/main/install.ps1 | iex
#
# Run it as the EMPLOYEE'S OWN USER. The agent installs per-user (into
# %LOCALAPPDATA%\Programs), so it lands in whichever profile runs this — an
# elevated or SYSTEM shell would install it for the wrong account.
#
# The installer launches the agent when it finishes. The employee still has to
# enroll and sign in once, in the window that appears; this only replaces
# clicking through setup.exe by hand.
#
# Set CLEARDESK_VERSION (e.g. v0.2.0) to install a specific release instead of
# the newest one. It's an environment variable rather than a parameter so the
# script behaves the same when piped into `iex`, which can't take arguments.

$ErrorActionPreference = 'Stop'
$repo = 'Shubhamji038/ClearDesk-releases'

$api = if ($env:CLEARDESK_VERSION) {
  "https://api.github.com/repos/$repo/releases/tags/$($env:CLEARDESK_VERSION)"
} else {
  "https://api.github.com/repos/$repo/releases/latest"
}

Write-Host 'Looking up the current ClearDesk release...'
# GitHub's API rejects requests with no user agent.
$release = Invoke-RestMethod $api -Headers @{ 'User-Agent' = 'ClearDesk-installer' }
$asset = $release.assets | Where-Object { $_.name -like '*setup.exe' } | Select-Object -First 1
if (-not $asset) { throw "No installer attached to release $($release.tag_name)." }

$installer = Join-Path $env:TEMP $asset.name
Write-Host "Downloading $($asset.name) ($([math]::Round($asset.size / 1MB)) MB)..."
# Invoke-WebRequest's progress bar makes large downloads several times slower.
$previousProgress = $ProgressPreference
$ProgressPreference = 'SilentlyContinue'
try {
  Invoke-WebRequest $asset.browser_download_url -OutFile $installer
} finally {
  $ProgressPreference = $previousProgress
}

# Without this, Windows treats the file as downloaded-from-the-internet and
# SmartScreen can stop a silent install with a prompt nobody is there to answer.
Unblock-File $installer

Write-Host 'Installing (this takes a few seconds)...'
# /S is the NSIS silent switch: no wizard, no clicks.
$process = Start-Process $installer -ArgumentList '/S' -Wait -PassThru
if ($process.ExitCode -ne 0) { throw "Installer exited with code $($process.ExitCode)." }

Remove-Item $installer -ErrorAction SilentlyContinue
Write-Host "ClearDesk $($release.tag_name) installed. Sign in when the window appears."
