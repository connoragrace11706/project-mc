<#
.SYNOPSIS
  Pulls Instagram account + per-media stats into a dated snapshot.

.DESCRIPTION
  Requires a Creator or Business account linked to a Facebook Page, and a
  long-lived token in .env. See SETUP.md step 2.

  Meta renames and deprecates insight metrics regularly, and availability
  differs by media type (reel vs image vs carousel) and by account. This script
  therefore requests metrics per media item inside a try/catch and records
  whatever comes back rather than assuming a fixed schema. A metric that fails
  is written as null and listed in the snapshot's `warnings` array - it is
  never silently dropped, because a missing metric that looks like a zero will
  quietly corrupt every review that follows.

  If you see version errors, bump -ApiVersion to the current Graph API version.

.EXAMPLE
  .\Get-InstagramStats.ps1
  .\Get-InstagramStats.ps1 -MaxMedia 25 -ApiVersion v23.0
#>
[CmdletBinding()]
param(
    [string]$IgUserId,
    [string]$AccessToken,
    [int]$MaxMedia = 30,
    [string]$ApiVersion = 'v23.0'
)

$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent

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

if (-not $AccessToken) { $AccessToken = Get-DotEnvValue 'IG_ACCESS_TOKEN' }
if (-not $IgUserId)    { $IgUserId    = Get-DotEnvValue 'IG_USER_ID' }

if (-not $AccessToken) { throw "No IG_ACCESS_TOKEN in $root\.env. See SETUP.md step 2." }
if (-not $IgUserId)    { throw "No IG_USER_ID in $root\.env. See SETUP.md step 2." }

$base     = "https://graph.facebook.com/$ApiVersion"
$warnings = @()

function Invoke-IG {
    param([string]$Path, [hashtable]$Query = @{})
    $Query['access_token'] = $AccessToken
    $qs = ($Query.GetEnumerator() | ForEach-Object {
        "$($_.Key)=$([uri]::EscapeDataString([string]$_.Value))"
    }) -join '&'
    Invoke-RestMethod -Uri "$base/$Path`?$qs" -Method Get
}

# --- account ----------------------------------------------------------------

Write-Host "Fetching account $IgUserId ..."
try {
    $acct = Invoke-IG $IgUserId @{ fields = 'username,followers_count,follows_count,media_count' }
} catch {
    throw @"
Instagram account fetch failed: $($_.Exception.Message)

Common causes:
  - Token expired (long-lived tokens last 60 days) -> regenerate in Graph API Explorer
  - Account is Personal, not Creator/Business -> switch it in the IG app
  - Missing scopes: instagram_basic, instagram_manage_insights
  - Graph API version '$ApiVersion' retired -> retry with a newer -ApiVersion
"@
}

$account = [ordered]@{
    ig_user_id  = $IgUserId
    username    = $acct.username
    followers   = $acct.followers_count
    following   = $acct.follows_count
    media_count = $acct.media_count
}

# --- media ------------------------------------------------------------------

Write-Host "Fetching up to $MaxMedia recent posts ..."
$mediaFields = 'id,caption,media_type,media_product_type,timestamp,permalink,like_count,comments_count'
$items = @()
$next  = $null

do {
    if ($next) {
        $page = Invoke-RestMethod -Uri $next -Method Get
    } else {
        $page = Invoke-IG "$IgUserId/media" @{ fields = $mediaFields; limit = 25 }
    }
    $items += $page.data
    $next = $page.paging.next
} while ($next -and $items.Count -lt $MaxMedia)

$items = $items | Select-Object -First $MaxMedia

# Metric availability differs by media product type. Ask for the plausible set
# and keep whatever the API actually returns.
$metricsFor = @{
    REELS   = 'reach,saved,shares,comments,likes,total_interactions,views'
    FEED    = 'reach,saved,shares,total_interactions,views'
    STORY   = 'reach,replies,navigation'
    DEFAULT = 'reach,saved,total_interactions'
}

$media = @()
foreach ($m in $items) {
    $key     = if ($m.media_product_type) { $m.media_product_type.ToUpper() } else { 'DEFAULT' }
    $metrics = if ($metricsFor.ContainsKey($key)) { $metricsFor[$key] } else { $metricsFor['DEFAULT'] }

    $insights = [ordered]@{}
    try {
        $resp = Invoke-IG "$($m.id)/insights" @{ metric = $metrics }
        foreach ($row in $resp.data) {
            $insights[$row.name] = $row.values[0].value
        }
    } catch {
        $warnings += "Insights unavailable for $($m.id) ($key): $($_.Exception.Message)"
    }

    $caption = if ($m.caption) { $m.caption } else { '' }
    $media += [ordered]@{
        id            = $m.id
        permalink     = $m.permalink
        posted        = $m.timestamp
        media_type    = $m.media_type
        product_type  = $m.media_product_type
        caption_first = ($caption -split "`n" | Select-Object -First 1)
        likes         = $m.like_count
        comments      = $m.comments_count
        insights      = $insights
        pillar        = $null   # tag by hand at review time: build/racing/money/life
    }
}

# --- write snapshot ---------------------------------------------------------

$stamp  = Get-Date -Format 'yyyy-MM-dd'
$outDir = Join-Path $root "data\snapshots\$stamp"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null
$outFile = Join-Path $outDir 'instagram.json'

[ordered]@{
    platform    = 'instagram'
    pulled_at   = (Get-Date -Format 'o')
    api_version = $ApiVersion
    account     = $account
    media       = $media
    warnings    = $warnings
} | ConvertTo-Json -Depth 8 | Out-File $outFile -Encoding utf8

Write-Host ""
Write-Host "Wrote $outFile" -ForegroundColor Green
Write-Host ("  @{0}  |  {1:N0} followers  |  {2} posts captured" -f `
    $account.username, $account.followers, $media.Count)

if ($warnings.Count) {
    Write-Host ""
    Write-Host "$($warnings.Count) warning(s) - some insights were unavailable:" -ForegroundColor Yellow
    $warnings | Select-Object -First 5 | ForEach-Object { Write-Host "  $_" -ForegroundColor DarkYellow }
}
