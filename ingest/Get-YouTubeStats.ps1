<#
.SYNOPSIS
  Pulls public YouTube channel + recent video stats into a dated snapshot.

.DESCRIPTION
  Uses YouTube Data API v3 with a simple API key. Free, generous quota
  (10,000 units/day; this script costs roughly 5 units per run).

  WHAT THIS GETS:   views, likes, comments, subscriber count, per-video stats
  WHAT IT CANNOT:   watch time, average view duration, retention curves,
                    traffic sources, impressions, CTR.

  Those live behind the YouTube ANALYTICS API, which needs OAuth as the channel
  owner rather than a plain key. Retention and CTR are the two numbers that
  actually drive decisions, so until that's wired up, pull them by hand from
  YouTube Studio and I'll merge them in.

.PARAMETER ChannelId
  Channel ID (starts with "UC"). Defaults to the value in data/accounts.json.

.EXAMPLE
  .\Get-YouTubeStats.ps1
  .\Get-YouTubeStats.ps1 -ChannelId UCxxxxxxxxxxxxxxxxxxxxxx -MaxVideos 25
#>
[CmdletBinding()]
param(
    [string]$ChannelId,
    [int]$MaxVideos = 50,
    [string]$ApiKey
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

if (-not $ApiKey) { $ApiKey = Get-DotEnvValue 'YOUTUBE_API_KEY' }
if (-not $ApiKey) {
    throw "No YouTube API key. Add YOUTUBE_API_KEY=... to $root\.env (see .env.example)."
}

$accountsPath = Join-Path $root 'data\accounts.json'
if (-not $ChannelId -and (Test-Path $accountsPath)) {
    $ChannelId = (Get-Content $accountsPath -Raw | ConvertFrom-Json).accounts.youtube.channel_id
}
if (-not $ChannelId) {
    throw "No channel ID. Pass -ChannelId or set it in data\accounts.json."
}

$base = 'https://www.googleapis.com/youtube/v3'

# $Matches populates unmatched optional groups as empty strings, and
# [int64]'' throws. Absent stat fields (e.g. likeCount on a video with likes
# hidden) come back $null. Both need the same defensive cast.
function ConvertTo-Int64Safe {
    param($Value)
    if ($null -eq $Value -or "$Value".Trim() -eq '') { return [int64]0 }
    $parsed = [int64]0
    if ([int64]::TryParse("$Value", [ref]$parsed)) { return $parsed }
    return [int64]0
}

function Invoke-YT {
    param([string]$Endpoint, [hashtable]$Query)
    $Query['key'] = $ApiKey
    $qs = ($Query.GetEnumerator() | ForEach-Object {
        "$($_.Key)=$([uri]::EscapeDataString([string]$_.Value))"
    }) -join '&'
    try {
        Invoke-RestMethod -Uri "$base/$Endpoint`?$qs" -Method Get
    } catch {
        throw "YouTube API call to '$Endpoint' failed: $($_.Exception.Message)"
    }
}

# --- channel ----------------------------------------------------------------

Write-Host "Fetching channel $ChannelId ..."
$ch = Invoke-YT 'channels' @{ part = 'snippet,statistics,contentDetails'; id = $ChannelId }
if (-not $ch.items) { throw "No channel found for ID '$ChannelId'. Check it starts with 'UC'." }

$c = $ch.items[0]
$channel = [ordered]@{
    channel_id  = $c.id
    title       = $c.snippet.title
    handle      = $c.snippet.customUrl
    published   = $c.snippet.publishedAt
    subscribers = [int64]$c.statistics.subscriberCount
    total_views = [int64]$c.statistics.viewCount
    video_count = [int]$c.statistics.videoCount
    # subscriberCount is rounded to 3 significant figures by the API once you
    # pass 1,000 subs. Treat week-over-week deltas as approximate.
    subscribers_are_rounded = ([int64]$c.statistics.subscriberCount -ge 1000)
}

# --- recent videos ----------------------------------------------------------

$uploads = $c.contentDetails.relatedPlaylists.uploads
Write-Host "Fetching up to $MaxVideos recent videos ..."

$videoIds = @()
$pageToken = $null
do {
    $q = @{ part = 'contentDetails'; playlistId = $uploads; maxResults = 50 }
    if ($pageToken) { $q['pageToken'] = $pageToken }
    $page = Invoke-YT 'playlistItems' $q
    $videoIds += $page.items.contentDetails.videoId
    $pageToken = $page.nextPageToken
} while ($pageToken -and $videoIds.Count -lt $MaxVideos)

$videoIds = $videoIds | Select-Object -First $MaxVideos

$videos = @()
for ($i = 0; $i -lt $videoIds.Count; $i += 50) {
    $batch = $videoIds[$i..([Math]::Min($i + 49, $videoIds.Count - 1))]
    $resp = Invoke-YT 'videos' @{ part = 'snippet,statistics,contentDetails'; id = ($batch -join ',') }
    foreach ($v in $resp.items) {
        # ISO-8601 duration -> seconds. Shorts are <= 180s and behave nothing
        # like long-form, so keep them separable at review time.
        $dur = 0
        if ($v.contentDetails.duration -match 'P(?:(\d+)D)?T(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?') {
            $dur = (ConvertTo-Int64Safe $Matches[1]) * 86400 +
                   (ConvertTo-Int64Safe $Matches[2]) * 3600 +
                   (ConvertTo-Int64Safe $Matches[3]) * 60 +
                   (ConvertTo-Int64Safe $Matches[4])
        }
        $views    = ConvertTo-Int64Safe $v.statistics.viewCount
        $likes    = ConvertTo-Int64Safe $v.statistics.likeCount
        $comments = ConvertTo-Int64Safe $v.statistics.commentCount

        $videos += [ordered]@{
            video_id     = $v.id
            title        = $v.snippet.title
            published    = $v.snippet.publishedAt
            duration_sec = $dur
            is_short     = ($dur -le 180 -and $dur -gt 0)
            views        = $views
            likes        = $likes
            comments     = $comments
            # Engagement rate is the only quality signal available without
            # OAuth. It is a weak proxy for retention - do not over-read it.
            engagement_rate = if ($views -gt 0) {
                [math]::Round((($likes + $comments) / $views) * 100, 3)
            } else { 0 }
            retention_pct        = $null   # fill from YouTube Studio
            avg_view_duration_s  = $null   # fill from YouTube Studio
            impressions_ctr_pct  = $null   # fill from YouTube Studio
        }
    }
}

# --- write snapshot ---------------------------------------------------------

$stamp   = Get-Date -Format 'yyyy-MM-dd'
$outDir  = Join-Path $root "data\snapshots\$stamp"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null
$outFile = Join-Path $outDir 'youtube.json'

$snapshot = [ordered]@{
    platform    = 'youtube'
    pulled_at   = (Get-Date -Format 'o')
    source      = 'YouTube Data API v3 (public stats only)'
    missing     = @('retention_pct', 'avg_view_duration_s', 'impressions_ctr_pct')
    channel     = $channel
    videos      = $videos
}

$snapshot | ConvertTo-Json -Depth 6 | Out-File $outFile -Encoding utf8

Write-Host ""
Write-Host "Wrote $outFile" -ForegroundColor Green
Write-Host ("  {0}  |  {1:N0} subs  |  {2:N0} total views  |  {3} videos captured" -f `
    $channel.title, $channel.subscribers, $channel.total_views, $videos.Count)
Write-Host ""
Write-Host "Still needed from YouTube Studio (Analytics > Content): retention %, avg view duration, impressions CTR." -ForegroundColor Yellow
