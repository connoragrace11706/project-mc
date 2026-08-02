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

# Camera-generated low-res companions. Both GoPro and Insta360 write one per
# clip, so counting them as footage double-counts every shot and inflates the
# hour total - and puts a 480p proxy in front of you as if it were the take.
# They stay IN the index (they are genuinely useful for reviewing on the
# laptop) but are tagged and excluded from every headline number.
$PROXY_EXT = @('.lrv')

function Get-PairKey {
    <#
      Reduces an original and its proxy to the same key so they can be paired.

        Insta360  VID_20240627_200909_00_002.insv
                  LRV_20240627_200909_01_002.lrv   -> insta:20240627_200909_002
        GoPro     GX010098.MP4
                  GL010098.LRV                     -> gopro:010098

      The middle field differs on purpose: Insta360 uses _00_ for the original
      and _01_ for the proxy, GoPro swaps the GX/GH prefix for GL. Returns
      $null for anything that does not match a known scheme, which is the
      honest answer - a guessed pairing is worse than an unpaired proxy.
    #>
    param([string]$BaseName)

    if ($BaseName -match '^(?:VID|LRV)_(\d{8}_\d{6})_\d{2}_(\d+)$') {
        return "insta:$($Matches[1])_$($Matches[2])"
    }
    if ($BaseName -match '^(?:GX|GH|GL|GS)(\d{2})(\d{4})$') {
        return "gopro:$($Matches[1])$($Matches[2])"
    }
    return $null
}

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

$proxyCount = @($files | Where-Object { $PROXY_EXT -contains $_.File.Extension.ToLower() }).Count
Write-Host "Found $($files.Count) video files ($($files.Count - $proxyCount) originals, $proxyCount camera proxies)." -ForegroundColor Cyan

# Map every ORIGINAL to its pair key first, so a proxy can find its parent
# regardless of enumeration order.
#
# Keys can collide: Insta360 writes a sub-megabyte recovery stub into MISC\
# with the SAME filename as the real 32 GB clip in Camera01\. Resolving that
# by enumeration order would be luck, and on a differently-ordered card the
# proxy would point at the stub. Largest file wins instead. Real collision,
# observed on the first card, 2026-08-02.
$originalByKey = @{}
foreach ($pair in $files) {
    if ($PROXY_EXT -contains $pair.File.Extension.ToLower()) { continue }
    $k = Get-PairKey ([System.IO.Path]::GetFileNameWithoutExtension($pair.File.Name))
    if (-not $k) { continue }
    if (-not $originalByKey.ContainsKey($k) -or
        $pair.File.Length -gt $originalByKey[$k].File.Length) {
        $originalByKey[$k] = $pair
    }
}

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
        role            = 'original'
        proxy_for       = $null
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

    if ($PROXY_EXT -contains $f.Extension.ToLower()) {
        $entry.role = 'proxy'
        $k = Get-PairKey ([System.IO.Path]::GetFileNameWithoutExtension($f.Name))
        if ($k -and $originalByKey.ContainsKey($k)) {
            $entry.proxy_for = $originalByKey[$k].Rel
        } else {
            $entry.notes = 'proxy with no matching original on this card'
        }
    }

    # Insta360 writes sub-megabyte .insv stubs into MISC\ for crash recovery.
    # They probe as video and would otherwise sit in the index looking like
    # real but suspiciously tiny clips. Flag rather than drop - a silent
    # exclusion is how you lose a genuinely short take. Seen 2026-08-02.
    if ($entry.role -eq 'original' -and $f.Length -lt 1MB) {
        $entry.notes = 'under 1 MB - likely a camera stub or recovery file, not footage'
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

# Every headline number below counts ORIGINALS ONLY. Camera proxies are one
# per clip, so including them would roughly double clip_count and inflate
# total_hours by the full runtime a second time.
$originals = @($entries | Where-Object { $_.role -eq 'original' })
$proxies   = @($entries | Where-Object { $_.role -eq 'proxy' })

# Per-source rollup. Project the values first - these are objects, and
# Measure-Object reads properties, so pull them out explicitly.
$bySource = @()
foreach ($g in ($originals | Group-Object source | Sort-Object Name)) {
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

$allSizes   = @($originals | ForEach-Object { $_.size_mb })
$allDurs    = @($originals | ForEach-Object { $_.duration_sec } | Where-Object { $_ -ne $null })
$proxySizes = @($proxies   | ForEach-Object { $_.size_mb })

$index = [ordered]@{
    generated       = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
    footage_root    = $FootageRoot
    machine         = $env:COMPUTERNAME
    quick_mode      = [bool]$Quick
    counts_exclude  = 'camera proxies (.lrv) - see proxy_count'
    clip_count      = $originals.Count
    total_gb        = [math]::Round((($allSizes | Measure-Object -Sum).Sum) / 1024, 2)
    total_hours     = if ($allDurs.Count) { [math]::Round((($allDurs | Measure-Object -Sum).Sum) / 3600, 2) } else { $null }
    proxy_count     = $proxies.Count
    proxy_gb        = [math]::Round((($proxySizes | Measure-Object -Sum).Sum) / 1024, 2)
    proxies_unpaired= @($proxies | Where-Object { -not $_.proxy_for }).Count
    file_count      = $entries.Count
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
Write-Host "  $($originals.Count) clips, $($index.total_gb) GB, $($index.total_hours) hours"
Write-Host "  + $($proxies.Count) camera proxies ($($index.proxy_gb) GB), excluded from the totals above"
if ($index.proxies_unpaired -gt 0) {
    Write-Host "  $($index.proxies_unpaired) proxy/proxies have NO matching original - a clip may be missing" -ForegroundColor Yellow
}
if ($failed -gt 0) {
    Write-Host "  $failed file(s) failed to probe - check 'notes' in the index" -ForegroundColor Yellow
}
Write-Host "  -> $OutFile"
Write-Host ""
$bySource | Format-Table -AutoSize
