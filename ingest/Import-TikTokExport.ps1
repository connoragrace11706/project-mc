<#
.SYNOPSIS
  Folds a TikTok Studio CSV export into a dated snapshot.

.DESCRIPTION
  TikTok's Content Posting API needs a 2-4 week app audit and returns thinner
  data than the free dashboard export, so this pipeline is deliberately manual:

      tiktok.com/tiktokstudio/analytics -> Download data (Overview + Content)
      -> drop the zips/CSVs in data/manual/tiktok-YYYY-MM-DD/
      -> run this script

  WHAT THIS GETS:   per-video views/likes/comments/shares (all-time), plus a
                    daily timeseries of views/profile views/likes/comments/shares
  WHAT IT CANNOT:   follower count, watch time, completion rate, traffic source.
                    TikTok does not put those in the export. Follower count has
                    to be read off the profile by hand.

.PARAMETER Path
  Folder holding Content.csv / Overview.csv. Defaults to the newest
  data/manual/tiktok-* directory.

.EXAMPLE
  .\Import-TikTokExport.ps1
#>
[CmdletBinding()]
param(
    [string]$Path,
    [int]$Followers = 0
)

$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent

# --- locate the export -------------------------------------------------------

if (-not $Path) {
    $manual = Join-Path $root 'data\manual'
    if (-not (Test-Path $manual)) { throw "No data\manual directory. Nothing to import." }
    $candidate = Get-ChildItem $manual -Directory -Filter 'tiktok-*' |
                 Sort-Object Name -Descending | Select-Object -First 1
    if (-not $candidate) {
        throw "No data\manual\tiktok-* folder found. Unzip the TikTok export there first."
    }
    $Path = $candidate.FullName
}

$contentCsv  = Join-Path $Path 'Content.csv'
$overviewCsv = Join-Path $Path 'Overview.csv'
if (-not (Test-Path $contentCsv)) { throw "Missing Content.csv in $Path" }

Write-Host "Reading TikTok export from $Path ..."

# --- helpers -----------------------------------------------------------------

# Import-Csv hands back strings; blank cells become '' and [int64]'' throws.
function ConvertTo-Int64Safe {
    param($Value)
    if ($null -eq $Value -or "$Value".Trim() -eq '') { return [int64]0 }
    $clean = ("$Value" -replace '[,\s]', '')
    $parsed = [int64]0
    if ([int64]::TryParse($clean, [ref]$parsed)) { return $parsed }
    return [int64]0
}

# --- per-video content -------------------------------------------------------

$videos = @()
foreach ($row in (Import-Csv $contentCsv)) {
    $views    = ConvertTo-Int64Safe $row.'Total views'
    $likes    = ConvertTo-Int64Safe $row.'Total likes'
    $comments = ConvertTo-Int64Safe $row.'Total comments'
    $shares   = ConvertTo-Int64Safe $row.'Total shares'
    $title    = "$($row.'Video title')".Trim()

    # Hashtag count is worth keeping: the baseline suggests stuffing correlates
    # with a much lower like rate. Recorded so the claim can be tested, not
    # assumed.
    $tags = [regex]::Matches($title, '#\w+')

    $videos += [ordered]@{
        title        = $title
        url          = "$($row.'Video link')".Trim()
        post_date    = "$($row.'Post time')".Trim()
        views        = $views
        likes        = $likes
        comments     = $comments
        shares       = $shares
        hashtag_count = $tags.Count
        # Like rate is the only quality signal in the export. TikTok gives no
        # watch time or completion rate here - do not read this as retention.
        like_rate_pct = if ($views -gt 0) { [math]::Round(($likes / $views) * 100, 2) } else { 0 }
        engagement_rate_pct = if ($views -gt 0) {
            [math]::Round((($likes + $comments + $shares) / $views) * 100, 2)
        } else { 0 }
        subject      = $null   # 'car' | 'bike' | 'life' - tag by hand, drives O1
    }
}

# --- daily timeseries --------------------------------------------------------

$daily = @()
if (Test-Path $overviewCsv) {
    foreach ($row in (Import-Csv $overviewCsv)) {
        $daily += [ordered]@{
            date          = "$($row.Date)".Trim()
            views         = ConvertTo-Int64Safe $row.'Video Views'
            profile_views = ConvertTo-Int64Safe $row.'Profile Views'
            likes         = ConvertTo-Int64Safe $row.Likes
            comments      = ConvertTo-Int64Safe $row.Comments
            shares        = ConvertTo-Int64Safe $row.Shares
        }
    }
}

$activeDays = @($daily | Where-Object { $_.views -gt 0 }).Count
$deadDays   = @($daily | Where-Object { $_.views -le 4 }).Count

# Projected once, reused below. See the note on Measure-Object in $snapshot.
$viewCounts = @($videos | ForEach-Object { $_.views })

# --- write snapshot ----------------------------------------------------------

$stamp  = Get-Date -Format 'yyyy-MM-dd'
$outDir = Join-Path $root "data\snapshots\$stamp"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null
$outFile = Join-Path $outDir 'tiktok.json'

$snapshot = [ordered]@{
    platform  = 'tiktok'
    pulled_at = (Get-Date -Format 'o')
    source    = "TikTok Studio CSV export ($([System.IO.Path]::GetFileName($Path)))"
    missing   = @('followers', 'watch_time', 'completion_rate', 'traffic_source')
    account   = [ordered]@{
        handle    = 'project.mc.racing'
        followers = $(if ($Followers -gt 0) { $Followers } else { $null })
    }
    totals    = [ordered]@{
        videos_in_export = $videos.Count
        # Measure-Object reads PROPERTIES; these rows are ordered dictionaries,
        # where 'views' is a key. Project it out first or the result is empty.
        total_views      = ($viewCounts | Measure-Object -Sum).Sum
        median_views     = if ($videos.Count) {
                               ($viewCounts | Sort-Object)[[math]::Floor($videos.Count / 2)]
                           } else { 0 }
        best_views       = ($viewCounts | Measure-Object -Maximum).Maximum
        days_measured    = $daily.Count
        days_with_views  = $activeDays
        # "Dormant" is the headline finding, so make it a number rather than
        # something a human has to eyeball out of the timeseries.
        days_under_5_views = $deadDays
    }
    videos    = $videos
    daily     = $daily
}

$snapshot | ConvertTo-Json -Depth 6 | Out-File $outFile -Encoding utf8

Write-Host ""
Write-Host "Wrote $outFile" -ForegroundColor Green
Write-Host ("  {0} videos  |  {1:N0} total views  |  median {2:N0}  |  best {3:N0}" -f `
    $videos.Count, $snapshot.totals.total_views, $snapshot.totals.median_views, $snapshot.totals.best_views)
Write-Host ("  {0} of {1} measured days were under 5 views" -f $deadDays, $daily.Count)
Write-Host ""
Write-Host "Still needed by hand: follower count (not in the export). Re-run with -Followers N." -ForegroundColor Yellow
