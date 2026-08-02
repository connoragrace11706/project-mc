<#
.SYNOPSIS
  Walks a footage tree and builds library/index.json - the map Claude reads
  instead of opening 500 GB of video.

.DESCRIPTION
  For every video file it records: path, source folder, size, duration,
  resolution, codec, frame rate, and the REAL capture date where the container
  carries one. Falls back to filesystem dates and says so, because a wrong
  shoot date is worse than an admitted unknown.

  Read-only. Never renames, moves, or deletes anything.

.EXAMPLE
  .\Build-FootageIndex.ps1 -FootageRoot C:\footage\raw

.EXAMPLE
  .\Build-FootageIndex.ps1 -FootageRoot C:\footage\raw -Quick
  Skips ffprobe. Seconds instead of minutes - use it to confirm the offload
  landed before committing to a full index.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$FootageRoot,

    [string]$OutFile = (Join-Path $PSScriptRoot '..\library\index.json'),

    [switch]$Quick
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $FootageRoot)) {
    throw "Footage root not found: $FootageRoot"
}

$FootageRoot = (Resolve-Path -LiteralPath $FootageRoot).ProviderPath.TrimEnd('\', '/')

if (-not $Quick) {
    $ffprobe = Get-Command ffprobe -ErrorAction SilentlyContinue
    if (-not $ffprobe) {
        throw "ffprobe not on PATH. Install Gyan.FFmpeg, then open a NEW terminal."
    }
}

$VIDEO_EXT = @('.mp4', '.mov', '.avi', '.mts', '.m4v', '.mkv', '.insv', '.lrv')

Write-Host "Scanning $FootageRoot ..." -ForegroundColor Cyan

# Attribute each file to its source by ENUMERATING each top-level folder
# separately, rather than slicing the root off the front of a full path.
#
# Why: Resolve-Path preserves 8.3 short names ("CGRACE~1") while Get-ChildItem
# returns long paths, so the two never line up and every card silently collapses
# into one bogus source. Mapped drives, junctions and casing differences do the
# same thing. Comparing a child against ITS OWN parent - both from the same
# enumeration - has no such mismatch. Verified failure mode, 2026-08-01.
$pairs = New-Object System.Collections.Generic.List[object]

foreach ($dir in @(Get-ChildItem -LiteralPath $FootageRoot -Directory -ErrorAction SilentlyContinue)) {
    $prefixLen = $dir.FullName.TrimEnd('\', '/').Length
    foreach ($f in @(Get-ChildItem -LiteralPath $dir.FullName -Recurse -File -ErrorAction SilentlyContinue |
                     Where-Object { $VIDEO_EXT -contains $_.Extension.ToLower() })) {
        $pairs.Add([pscustomobject]@{
            File   = $f
            Source = $dir.Name
            Rel    = Join-Path $dir.Name $f.FullName.Substring($prefixLen).TrimStart('\', '/')
        })
    }
}

# Loose files dropped straight in the root, outside any card folder.
foreach ($f in @(Get-ChildItem -LiteralPath $FootageRoot -File -ErrorAction SilentlyContinue |
                 Where-Object { $VIDEO_EXT -contains $_.Extension.ToLower() })) {
    $pairs.Add([pscustomobject]@{ File = $f; Source = '(root)'; Rel = $f.Name })
}

# NOT @($pairs) - on PowerShell 7 / .NET 10 the array-subexpression operator
# throws "Argument types do not match" when handed a List[object]. ToArray()
# is the portable form. Verified 2026-08-01.
$files = $pairs.ToArray()

if ($files.Count -eq 0) {
    Write-Warning "No video files found under $FootageRoot"
}

Write-Host "Found $($files.Count) video files." -ForegroundColor Cyan

$entries = New-Object System.Collections.Generic.List[object]
$i = 0
$failed = 0

foreach ($pair in $files) {
    $f      = $pair.File
    $source = $pair.Source
    $rel    = $pair.Rel
    $i++
    if ($files.Count -gt 0) {
        Write-Progress -Activity 'Indexing footage' `
            -Status "$i of $($files.Count) - $($f.Name)" `
            -PercentComplete (($i / $files.Count) * 100)
    }

    $entry = [ordered]@{
        path            = $f.FullName
        relative_path   = $rel
        source          = $source
        filename        = $f.Name
        size_mb         = [math]::Round($f.Length / 1MB, 1)
        fs_modified     = $f.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss')
        capture_date    = $null
        capture_source  = 'UNKNOWN'
        duration_sec    = $null
        width           = $null
        height          = $null
        codec           = $null
        fps             = $null
        notes           = ''
    }

    if (-not $Quick) {
        try {
            $json = & ffprobe -v quiet -print_format json -show_format -show_streams -- "$($f.FullName)" 2>$null
            if ($LASTEXITCODE -eq 0 -and $json) {
                $probe = $json | ConvertFrom-Json

                $v = $probe.streams | Where-Object { $_.codec_type -eq 'video' } | Select-Object -First 1
                if ($v) {
                    $entry.width  = $v.width
                    $entry.height = $v.height
                    $entry.codec  = $v.codec_name

                    # r_frame_rate arrives as "30000/1001" - evaluate it.
                    if ($v.r_frame_rate -and $v.r_frame_rate -match '^(\d+)/(\d+)$') {
                        $num = [double]$Matches[1]
                        $den = [double]$Matches[2]
                        if ($den -ne 0) { $entry.fps = [math]::Round($num / $den, 2) }
                    }
                }

                if ($probe.format.duration) {
                    $entry.duration_sec = [math]::Round([double]$probe.format.duration, 1)
                }

                # The real capture time, when the container carries one.
                $ct = $probe.format.tags.creation_time
                if (-not $ct -and $v) { $ct = $v.tags.creation_time }
                if ($ct) {
                    try {
                        $parsed = [datetime]::Parse($ct, [Globalization.CultureInfo]::InvariantCulture)
                        $entry.capture_date   = $parsed.ToString('yyyy-MM-dd HH:mm:ss')
                        $entry.capture_source = 'container metadata'
                    } catch {
                        $entry.notes = 'unparseable creation_time'
                    }
                }
            } else {
                $failed++
                $entry.notes = 'ffprobe failed - file may be corrupt or still copying'
            }
        } catch {
            $failed++
            $entry.notes = "ffprobe error: $($_.Exception.Message)"
        }
    }

    # Fall back to the filesystem date, but never silently pass it off as real.
    if (-not $entry.capture_date) {
        $entry.capture_date   = $f.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss')
        $entry.capture_source = 'filesystem date - UNRELIABLE, copying can reset it'
    }

    $entries.Add([pscustomobject]$entry)
}

Write-Progress -Activity 'Indexing footage' -Completed

# Per-source rollup. Project the values first - these are objects, and
# Measure-Object reads properties, so pull them out explicitly.
$bySource = @()
foreach ($g in ($entries | Group-Object source | Sort-Object Name)) {
    $durs  = @($g.Group | ForEach-Object { $_.duration_sec } | Where-Object { $_ -ne $null })
    $sizes = @($g.Group | ForEach-Object { $_.size_mb })
    $dates = @($g.Group | Where-Object { $_.capture_source -eq 'container metadata' } |
                          ForEach-Object { $_.capture_date } | Sort-Object)

    $bySource += [pscustomobject][ordered]@{
        source          = $g.Name
        clips           = $g.Count
        total_gb        = [math]::Round((($sizes | Measure-Object -Sum).Sum) / 1024, 2)
        total_minutes   = if ($durs.Count) { [math]::Round((($durs | Measure-Object -Sum).Sum) / 60, 1) } else { $null }
        earliest_real   = if ($dates.Count) { $dates[0] } else { 'UNKNOWN' }
        latest_real     = if ($dates.Count) { $dates[-1] } else { 'UNKNOWN' }
        reliable_dates  = "$($dates.Count) of $($g.Count)"
    }
}

$allSizes = @($entries | ForEach-Object { $_.size_mb })
$allDurs  = @($entries | ForEach-Object { $_.duration_sec } | Where-Object { $_ -ne $null })

$index = [ordered]@{
    generated       = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
    footage_root    = $FootageRoot
    machine         = $env:COMPUTERNAME
    quick_mode      = [bool]$Quick
    clip_count      = $entries.Count
    total_gb        = [math]::Round((($allSizes | Measure-Object -Sum).Sum) / 1024, 2)
    total_hours     = if ($allDurs.Count) { [math]::Round((($allDurs | Measure-Object -Sum).Sum) / 3600, 2) } else { $null }
    probe_failures  = $failed
    by_source       = $bySource
    clips           = $entries
}

$outDir = Split-Path -Parent $OutFile
if (-not (Test-Path -LiteralPath $outDir)) {
    New-Item -ItemType Directory -Path $outDir -Force | Out-Null
}

$index | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $OutFile -Encoding UTF8

Write-Host ""
Write-Host "=== INDEX BUILT ===" -ForegroundColor Green
Write-Host "  $($entries.Count) clips, $($index.total_gb) GB, $($index.total_hours) hours"
if ($failed -gt 0) {
    Write-Host "  $failed file(s) failed to probe - check 'notes' in the index" -ForegroundColor Yellow
}
Write-Host "  -> $OutFile"
Write-Host ""
$bySource | Format-Table -AutoSize
