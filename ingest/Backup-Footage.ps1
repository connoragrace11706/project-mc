<#
.SYNOPSIS
  Off-site backup of the footage archive to Backblaze B2 via rclone.

.DESCRIPTION
  Years of an irreplaceable build currently live on SD cards and three phones.
  This is the script that makes a second copy exist.

  DESIGN RULE, and the reason this is `copy` and never `sync`:
  `rclone sync` makes the destination MATCH the source, which means deleting
  remote files whose local copy has gone. For an archive that is the exact
  disaster we are insuring against - one bad local delete, one failed drive
  mid-scan, and the sync faithfully destroys the only other copy. `copy` only
  ever adds. It is slower to notice renames and it leaves orphans behind, and
  both of those are cheap next to losing the archive.

  Credentials are read from .env and passed to rclone through environment
  variables, so they never appear on a command line, in a log, or in
  rclone.conf. See .env.example for the three values needed.

.PARAMETER FootageRoot
  Local folder to back up. No default on purpose - passing it explicitly is a
  small tax that prevents backing up the wrong tree.

.PARAMETER DryRun
  Show what would transfer without transferring. Run this first, every time.

.PARAMETER Verify
  Compare local against remote by hash instead of copying. B2 stores SHA1 and
  rclone hashes locally, so this costs no download and no egress.

.PARAMETER Immutable
  Fail if a file already in the bucket has changed locally. Raw footage should
  never change, so a hit here means corruption, a partial copy, or ransomware.
  Worth turning on once the first full upload has completed.

.EXAMPLE
  .\Backup-Footage.ps1 -FootageRoot C:\footage\raw -DryRun
  Always start here.

.EXAMPLE
  .\Backup-Footage.ps1 -FootageRoot C:\footage\raw

.EXAMPLE
  .\Backup-Footage.ps1 -FootageRoot C:\footage\raw -Verify
  Proves the remote copy matches. Run after any big upload.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$FootageRoot,

    [string]$Prefix = 'footage',

    [switch]$DryRun,
    [switch]$Verify,
    [switch]$Immutable,

    [string]$BwLimit,

    [int]$Transfers = 8
)

$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent

# --- config -----------------------------------------------------------------

function Get-DotEnvValue {
    param([string]$Key)
    $envFile = Join-Path $root '.env'
    if (-not (Test-Path $envFile)) { return $null }
    foreach ($line in (Get-Content $envFile)) {
        if ($line -match "^\s*$([regex]::Escape($Key))\s*=\s*(.+?)\s*$") {
            return $Matches[1].Trim('"').Trim("'")
        }
    }
    return $null
}

if (-not (Get-Command rclone -ErrorAction SilentlyContinue)) {
    throw "rclone not on PATH. winget install Rclone.Rclone, then open a NEW terminal."
}

if (-not (Test-Path -LiteralPath $FootageRoot)) {
    throw "Footage root not found: $FootageRoot`nNothing has been offloaded to this machine yet."
}
$FootageRoot = (Resolve-Path -LiteralPath $FootageRoot).ProviderPath.TrimEnd('\', '/')

$accountId = Get-DotEnvValue 'B2_ACCOUNT_ID'
$appKey    = Get-DotEnvValue 'B2_APPLICATION_KEY'
$bucket    = Get-DotEnvValue 'B2_BUCKET'

$missing = @()
if (-not $accountId) { $missing += 'B2_ACCOUNT_ID' }
if (-not $appKey)    { $missing += 'B2_APPLICATION_KEY' }
if (-not $bucket)    { $missing += 'B2_BUCKET' }
if ($missing.Count) {
    throw "Missing in $root\.env : $($missing -join ', ')`nSee SETUP.md section 6 for where these come from."
}

# rclone reads remote config from RCLONE_CONFIG_<UPPERCASE NAME>_<FIELD>.
# This is why no rclone.conf is needed and why the key never hits a command
# line - PowerShell child processes inherit these, and rclone logs neither.
$remote = 'b2archive'
$env:RCLONE_CONFIG_B2ARCHIVE_TYPE    = 'b2'
$env:RCLONE_CONFIG_B2ARCHIVE_ACCOUNT = $accountId
$env:RCLONE_CONFIG_B2ARCHIVE_KEY     = $appKey

$dest = "${remote}:$bucket/$Prefix"

# --- logging ----------------------------------------------------------------

$logDir = Join-Path $root 'library\backup-logs'
if (-not (Test-Path -LiteralPath $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}
$stamp   = (Get-Date).ToString('yyyy-MM-dd_HHmmss')
$mode    = if ($Verify) { 'verify' } elseif ($DryRun) { 'dryrun' } else { 'copy' }
$logFile = Join-Path $logDir "$stamp-$mode.log"

# --- local survey -----------------------------------------------------------

Write-Host "Surveying $FootageRoot ..." -ForegroundColor Cyan
$localFiles = @(Get-ChildItem -LiteralPath $FootageRoot -Recurse -File -ErrorAction SilentlyContinue)
$localBytes = ($localFiles | Measure-Object Length -Sum).Sum
if (-not $localBytes) { $localBytes = 0 }
$localGb = [math]::Round($localBytes / 1GB, 2)

Write-Host ""
Write-Host "  source : $FootageRoot"
Write-Host "  dest   : b2://$bucket/$Prefix"
Write-Host "  local  : $($localFiles.Count) files, $localGb GB"
Write-Host "  mode   : $mode"
Write-Host "  log    : $logFile"
Write-Host ""

if ($localFiles.Count -eq 0) {
    Write-Warning "Source is empty. Nothing to back up - offload the cards first."
    return
}

# ~$6/TB/month, so the running cost is worth stating before it is incurred.
$monthly = [math]::Round(($localBytes / 1TB) * 6, 2)
Write-Host ("  est. B2 storage cost: ~`$$monthly/month at this size") -ForegroundColor DarkGray
Write-Host ""

# --- build the rclone invocation --------------------------------------------

$verb = if ($Verify) { 'check' } else { 'copy' }

$rcloneArgs = @(
    $verb
    $FootageRoot
    $dest
    '--log-file',  $logFile
    '--log-level', 'INFO'
    '--stats',     '30s'
    '--stats-one-line'
    '--transfers', "$Transfers"
    '--checkers',  '16'
    '--fast-list'
    # Windows and camera junk. Never worth paying to store.
    '--exclude', 'Thumbs.db'
    '--exclude', 'desktop.ini'
    '--exclude', '.DS_Store'
    '--exclude', '**/.Trashes/**'
    '--exclude', '*.tmp'
)

if ($Verify)    { $rcloneArgs += '--one-way' }
if ($DryRun)    { $rcloneArgs += '--dry-run' }
if ($Immutable) { $rcloneArgs += '--immutable' }
if ($BwLimit)   { $rcloneArgs += @('--bwlimit', $BwLimit) }

# Progress goes to the console; the detailed record goes to the log file.
if (-not $Verify) { $rcloneArgs += '--progress' }

Write-Host "Running: rclone $verb ..." -ForegroundColor Cyan
Write-Host ""

& rclone @rcloneArgs
$code = $LASTEXITCODE

Write-Host ""
if ($code -eq 0) {
    if ($Verify) {
        Write-Host "=== VERIFY PASSED ===" -ForegroundColor Green
        Write-Host "  Every local file has a hash-identical copy in B2."
    } elseif ($DryRun) {
        Write-Host "=== DRY RUN COMPLETE ===" -ForegroundColor Green
        Write-Host "  Nothing was transferred. Re-run without -DryRun to do it for real."
    } else {
        Write-Host "=== BACKUP COMPLETE ===" -ForegroundColor Green
        Write-Host "  Now prove it: .\Backup-Footage.ps1 -FootageRoot `"$FootageRoot`" -Verify"
    }
} else {
    Write-Host "=== rclone exited $code ===" -ForegroundColor Red
    Write-Host "  Full detail: $logFile"
    if ($Verify) {
        Write-Host "  A non-zero exit here means files DIFFER or are MISSING remotely." -ForegroundColor Yellow
    }
}
Write-Host "  -> $logFile"

exit $code
