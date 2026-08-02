<#
.SYNOPSIS
  Offloads an SD card / phone / drive into the footage archive, hash-verifying
  every file, and writes a manifest proving it landed intact.

.DESCRIPTION
  This is the script that stands between years of build footage and losing it.
  It is built around one rule:

      NOTHING IS EVER DELETED FROM THE SOURCE.

  Not by a flag, not by a prompt, not on success. Wiping a card is a human
  decision made AFTER the copy is verified AND the off-site backup has run.
  A script that can erase the only copy is a script that eventually will.

  How it verifies: the source is read once, hashed with SHA256 as the bytes
  stream through to disk, and then the DESTINATION file is read back and
  hashed independently. A file only counts as imported when those two hashes
  match. That catches a truncated copy, a bad cable, a dying card, and silent
  corruption - none of which a "copy completed" dialog will tell you about.

  Timestamps are preserved deliberately. Build-FootageIndex.ps1 falls back to
  filesystem dates when a clip carries no container metadata, and a plain copy
  resets them to now, which would silently turn "shot in 2023" into today.

  Safe to re-run. Already-verified files are skipped, so an interrupted import
  resumes instead of starting over.

.PARAMETER Source
  Drive or folder to import from, e.g. E:\ or E:\DCIM.

.PARAMETER Destination
  Archive root. Defaults to C:\footage\raw. A subfolder named -Label is
  created under it.

.PARAMETER Label
  Name for this card/phone, used as the subfolder. Defaults to the volume
  label plus today's date. Keep it meaningful - it is how you will find this
  footage in two years.

.PARAMETER Measure
  Survey the source and stop. No copying. Reports size, file counts, extension
  breakdown, and whether it actually fits. RUN THIS FIRST.

.PARAMETER VerifyOnly
  Re-verify a previous import against its manifest. Copies nothing.

.EXAMPLE
  .\Import-Footage.ps1 -Source E:\ -Measure
  Always start here. Nothing is written.

.EXAMPLE
  .\Import-Footage.ps1 -Source E:\ -Label "card-01-sandisk64"

.EXAMPLE
  .\Import-Footage.ps1 -Source E:\ -Label "card-01-sandisk64" -VerifyOnly
  Proves the archive copy is still bit-identical.

.NOTES
  PHONES: Android/iPhone connect over MTP, which Windows exposes as a shell
  namespace and NOT as a filesystem. This script cannot read MTP directly, and
  neither can any hash tool - so a phone transfer cannot be verified at the
  source end. Either pull the microSD and read it in a card reader (verifiable,
  preferred), or copy from the phone with Explorer into a staging folder and
  then run this script against that folder. The second path verifies the
  staging-to-archive hop but NOT the phone-to-staging hop. Say so out loud
  rather than pretending the whole chain is checked.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Source,

    [string]$Destination = 'C:\footage\raw',

    [string]$Label,

    [switch]$Measure,

    [switch]$VerifyOnly
)

$ErrorActionPreference = 'Stop'

# Windows/camera bookkeeping. Never worth archiving.
$SKIP_DIRS  = @('System Volume Information', '$RECYCLE.BIN', '.Trashes',
                '.Spotlight-V100', '.fseventsd', 'FOUND.000')
$SKIP_FILES = @('Thumbs.db', 'desktop.ini', '.DS_Store')

# --- preflight ---------------------------------------------------------------

if (-not (Test-Path -LiteralPath $Source)) {
    throw "Source not found: $Source`nIs the card actually mounted? A phone on MTP will not appear as a drive - see the NOTES in this script's help."
}

$srcRoot = (Get-Item -LiteralPath $Source).FullName.TrimEnd('\')

if (-not $Label) {
    $vol = $null
    try {
        $q = (Get-Item -LiteralPath $Source).PSDrive
        if ($q) { $vol = (Get-Volume -DriveLetter $q.Name -ErrorAction SilentlyContinue).FileSystemLabel }
    } catch { }
    if (-not $vol) { $vol = Split-Path $srcRoot -Leaf }
    if (-not $vol) { $vol = 'source' }
    $Label = ('{0}-{1}' -f ($vol -replace '[^\w\-]', '_'), (Get-Date).ToString('yyyy-MM-dd'))
}

$cardDir      = Join-Path $Destination $Label
$manifestPath = Join-Path $cardDir '.import-manifest.json'

Write-Host ""
Write-Host "  source : $srcRoot"
Write-Host "  label  : $Label"
Write-Host "  dest   : $cardDir"
Write-Host ""

# --- survey ------------------------------------------------------------------

Write-Host "Surveying source ..." -ForegroundColor Cyan

$all = @(Get-ChildItem -LiteralPath $srcRoot -Recurse -File -Force -ErrorAction SilentlyContinue |
         Where-Object {
             $keep = $true
             foreach ($d in $SKIP_DIRS)  { if ($_.FullName -like "*\$d\*") { $keep = $false } }
             foreach ($f in $SKIP_FILES) { if ($_.Name -eq $f)             { $keep = $false } }
             $keep
         })

if ($all.Count -eq 0) {
    Write-Warning "No files found under $srcRoot"
    return
}

$totalBytes = ($all | Measure-Object Length -Sum).Sum
$totalGb    = [math]::Round($totalBytes / 1GB, 2)

Write-Host "  $($all.Count) files, $totalGb GB"
Write-Host ""

# Extension breakdown - tells you at a glance whether this is footage or junk.
$byExt = $all | Group-Object { $_.Extension.ToLower() } |
         Sort-Object { ($_.Group | Measure-Object Length -Sum).Sum } -Descending |
         Select-Object -First 12 @{n='ext';e={ if ($_.Name) { $_.Name } else { '(none)' } }},
                                 @{n='files';e={$_.Count}},
                                 @{n='GB';e={ [math]::Round((($_.Group | Measure-Object Length -Sum).Sum)/1GB,2) }}
$byExt | Format-Table -AutoSize | Out-String | Write-Host

# --- capacity ----------------------------------------------------------------

$destRootPath = Split-Path $cardDir -Qualifier
if (-not $destRootPath) { $destRootPath = 'C:' }
$freeBytes = (Get-PSDrive ($destRootPath.TrimEnd(':')) -ErrorAction SilentlyContinue).Free
$freeGb    = [math]::Round($freeBytes / 1GB, 2)

# 2% headroom. Filling a volume to the last byte is its own failure mode.
$needBytes = $totalBytes * 1.02
$fits      = $freeBytes -gt $needBytes

Write-Host ("  free on {0}  : {1} GB" -f $destRootPath, $freeGb)
Write-Host ("  this import : {0} GB" -f $totalGb)
Write-Host ("  after import: {0} GB free" -f [math]::Round(($freeBytes - $totalBytes)/1GB, 2))
Write-Host ""

if (-not $fits) {
    Write-Host "=== WILL NOT FIT ===" -ForegroundColor Red
    Write-Host "  Need ~$([math]::Round($needBytes/1GB,2)) GB including headroom, have $freeGb GB."
    Write-Host "  Free space or add a drive before importing. Do NOT start a copy"
    Write-Host "  that cannot finish - a half-archive that looks complete is worse"
    Write-Host "  than no archive."
    Write-Host ""
    if (-not $Measure) { throw "Insufficient free space on $destRootPath." }
}

if ($Measure) {
    Write-Host "=== MEASURE ONLY - nothing was written ===" -ForegroundColor Green
    if ($fits) { Write-Host "  Fits. Re-run without -Measure to import." -ForegroundColor Green }
    Write-Host ""
    Write-Host "  Remember this is ONE card. Measure every card and phone before" -ForegroundColor DarkGray
    Write-Host "  starting, so you find out about capacity now and not at 90%." -ForegroundColor DarkGray
    return
}

# --- load prior manifest (resume) --------------------------------------------

$done = @{}
if (Test-Path -LiteralPath $manifestPath) {
    try {
        $prior = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
        foreach ($e in $prior.files) {
            if ($e.status -eq 'verified') { $done[$e.relative_path] = $e.sha256 }
        }
        Write-Host "Resuming: $($done.Count) file(s) already verified in a previous run." -ForegroundColor Cyan
        Write-Host ""
    } catch {
        Write-Warning "Existing manifest unreadable, re-verifying everything: $($_.Exception.Message)"
    }
}

if (-not (Test-Path -LiteralPath $cardDir)) {
    New-Item -ItemType Directory -Path $cardDir -Force | Out-Null
}

# --- copy + verify -----------------------------------------------------------

function Copy-AndHash {
    <#
      Streams source -> destination once, hashing as it goes, so a 500 GB import
      reads the source a single time instead of once to copy and again to hash.
    #>
    param([string]$From, [string]$To)

    $sha = [System.Security.Cryptography.SHA256]::Create()
    $in  = $null
    $out = $null
    try {
        $in  = [System.IO.File]::OpenRead($From)
        $out = [System.IO.File]::Create($To)
        $buf = New-Object byte[] 4194304
        while ($true) {
            $n = $in.Read($buf, 0, $buf.Length)
            if ($n -le 0) { break }
            $out.Write($buf, 0, $n)
            [void]$sha.TransformBlock($buf, 0, $n, $null, 0)
        }
        [void]$sha.TransformFinalBlock((New-Object byte[] 0), 0, 0)
        return ($sha.Hash | ForEach-Object { $_.ToString('x2') }) -join ''
    } finally {
        if ($in)  { $in.Dispose() }
        if ($out) { $out.Dispose() }
        $sha.Dispose()
    }
}

$results = New-Object System.Collections.Generic.List[object]
$copied = 0; $skipped = 0; $failed = 0; $verified = 0
$i = 0

foreach ($f in $all) {
    $i++
    $rel  = $f.FullName.Substring($srcRoot.Length).TrimStart('\', '/')
    $dest = Join-Path $cardDir $rel

    Write-Progress -Activity "Importing $Label" `
        -Status "$i of $($all.Count) - $($f.Name)" `
        -PercentComplete (($i / $all.Count) * 100)

    $entry = [ordered]@{
        relative_path = $rel
        source_path   = $f.FullName
        size_bytes    = $f.Length
        modified      = $f.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss')
        sha256        = $null
        status        = 'pending'
        note          = ''
    }

    # Already verified in an earlier run and still on disk at the right size.
    #
    # NEVER take this shortcut in -VerifyOnly. The whole point of a verify pass
    # is to re-read the bytes; trusting the manifest would make it report
    # "verified" on a file that has since rotted or been altered, since bit rot
    # and a one-byte edit both leave the size unchanged. Caught in testing
    # 2026-08-02: a deliberately corrupted file passed VerifyOnly before this
    # guard existed.
    if (-not $VerifyOnly -and $done.ContainsKey($rel) -and (Test-Path -LiteralPath $dest)) {
        $existing = Get-Item -LiteralPath $dest
        if ($existing.Length -eq $f.Length) {
            $entry.sha256 = $done[$rel]
            $entry.status = 'verified'
            $entry.note   = 'skipped - verified previously'
            $results.Add([pscustomobject]$entry)
            $skipped++
            continue
        }
    }

    try {
        $destParent = Split-Path -Parent $dest
        if (-not (Test-Path -LiteralPath $destParent)) {
            New-Item -ItemType Directory -Path $destParent -Force | Out-Null
        }

        if ($VerifyOnly) {
            if (-not (Test-Path -LiteralPath $dest)) {
                $entry.status = 'MISSING'
                $entry.note   = 'no copy in the archive'
                $failed++
                $results.Add([pscustomobject]$entry); continue
            }
            $srcHash = (Get-FileHash -LiteralPath $f.FullName -Algorithm SHA256).Hash.ToLower()
        } else {
            $srcHash = Copy-AndHash -From $f.FullName -To $dest

            # The indexer trusts these when a clip carries no container date.
            # A plain copy would reset them to now and quietly relabel the
            # shoot date as today.
            $d = Get-Item -LiteralPath $dest
            $d.LastWriteTime  = $f.LastWriteTime
            $d.CreationTime   = $f.CreationTime
        }

        $dstHash = (Get-FileHash -LiteralPath $dest -Algorithm SHA256).Hash.ToLower()
        $entry.sha256 = $srcHash

        if ($srcHash -eq $dstHash) {
            $entry.status = 'verified'
            if ($VerifyOnly) { $verified++ } else { $copied++ }
        } else {
            $entry.status = 'HASH MISMATCH'
            $entry.note   = "source $srcHash / dest $dstHash"
            $failed++
        }
    } catch {
        $entry.status = 'ERROR'
        $entry.note   = $_.Exception.Message
        $failed++
    }

    $results.Add([pscustomobject]$entry)

    # Checkpoint, so an interrupted 500 GB import resumes instead of restarting.
    if (($i % 25) -eq 0) {
        $partial = [ordered]@{
            label = $Label; source = $srcRoot; destination = $cardDir
            generated = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
            complete = $false; files = $results.ToArray()
        }
        $partial | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $manifestPath -Encoding UTF8
    }
}

Write-Progress -Activity "Importing $Label" -Completed

# --- manifest ----------------------------------------------------------------

$manifest = [ordered]@{
    label            = $Label
    source           = $srcRoot
    destination      = $cardDir
    machine          = $env:COMPUTERNAME
    generated        = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
    mode             = if ($VerifyOnly) { 'verify' } else { 'import' }
    complete         = $true
    file_count       = $results.Count
    total_bytes      = $totalBytes
    total_gb         = $totalGb
    copied           = $copied
    verified_existing= $verified
    skipped          = $skipped
    failed           = $failed
    files            = $results.ToArray()
}
$manifest | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $manifestPath -Encoding UTF8

# --- report ------------------------------------------------------------------

Write-Host ""
if ($failed -eq 0) {
    Write-Host "=== $(if ($VerifyOnly) { 'VERIFY PASSED' } else { 'IMPORT VERIFIED' }) ===" -ForegroundColor Green
} else {
    Write-Host "=== $failed FILE(S) FAILED ===" -ForegroundColor Red
}
Write-Host "  copied            : $copied"
if ($VerifyOnly) { Write-Host "  verified          : $verified" }
Write-Host "  skipped (already) : $skipped"
Write-Host "  failed            : $failed"
Write-Host "  manifest          : $manifestPath"

if ($failed -gt 0) {
    Write-Host ""
    Write-Host "  Failures - do not trust this import:" -ForegroundColor Red
    $results | Where-Object { $_.status -ne 'verified' } |
        Select-Object relative_path, status, note -First 20 |
        Format-Table -AutoSize | Out-String | Write-Host
}

Write-Host ""
Write-Host "  NOTHING was deleted from the source, by design." -ForegroundColor Yellow
Write-Host "  Before wiping this card, BOTH must be true:" -ForegroundColor Yellow
Write-Host "    1. this import reports 0 failures" -ForegroundColor Yellow
Write-Host "    2. Backup-Footage.ps1 has pushed it to B2 and -Verify passed" -ForegroundColor Yellow
Write-Host "  One verified copy on one disk is still one copy." -ForegroundColor Yellow
Write-Host ""

if ($failed -gt 0) { exit 1 }
