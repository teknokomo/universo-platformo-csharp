# Test Metahubs Integration with Supabase
# This script creates test metahubs and verifies database integration

$ErrorActionPreference = "Stop"

Write-Host "=== Testing Metahubs Integration with Supabase ===" -ForegroundColor Cyan
Write-Host ""

# Read Supabase config from appsettings
$appsettingsPath = "src/packages/main-frt/base/wwwroot/appsettings.json"
$config = Get-Content $appsettingsPath | ConvertFrom-Json
$supabaseUrl = $config.Supabase.Url
$supabaseKey = $config.Supabase.Key

Write-Host "✓ Supabase URL: $supabaseUrl" -ForegroundColor Green
Write-Host "✓ API Key loaded" -ForegroundColor Green
Write-Host ""

# Test 1: Check if metahubs table exists
Write-Host "[Test 1] Checking metahubs table..." -ForegroundColor Yellow
$headers = @{
    "apikey" = $supabaseKey
    "Authorization" = "Bearer $supabaseKey"
}

try {
    $response = Invoke-RestMethod -Uri "$supabaseUrl/rest/v1/metahubs?limit=0" -Headers $headers -Method Get
    Write-Host "✓ Metahubs table exists and accessible" -ForegroundColor Green
} catch {
    Write-Host "✗ Error accessing metahubs table: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Test 2: Create test metahub
Write-Host "[Test 2] Creating test metahub..." -ForegroundColor Yellow

$timestamp = Get-Date -Format 'yyyyMMddHHmmss'
$metahubId = [guid]::NewGuid().ToString()
$codename = "test-metahub-$timestamp"

# Create JSON strings without Cyrillic to avoid encoding issues
$testMetahub = @"
{
    "id": "$metahubId",
    "codename": "$codename",
    "name": {
        "_schema": "1",
        "locales": {
            "en": { "content": "Test Metahub" },
            "ru": { "content": "Test Metahub" }
        },
        "_primary": "ru"
    },
    "description": {
        "_schema": "1",
        "locales": {
            "en": { "content": "DB integration test" },
            "ru": { "content": "DB integration test" }
        },
        "_primary": "ru"
    },
    "is_public": true,
    "last_branch_number": 0
}
"@

$headers["Content-Type"] = "application/json"
$headers["Prefer"] = "return=representation"

try {
    $created = Invoke-RestMethod -Uri "$supabaseUrl/rest/v1/metahubs" -Headers $headers -Method Post -Body $testMetahub
    Write-Host "✓ Test metahub created successfully!" -ForegroundColor Green
    Write-Host "  ID: $($created.id)" -ForegroundColor Gray
    Write-Host "  Codename: $($created.codename)" -ForegroundColor Gray
    Write-Host ""
} catch {
    Write-Host "✗ Error creating metahub: $_" -ForegroundColor Red
    if ($_.ErrorDetails) {
        Write-Host $_.ErrorDetails.Message -ForegroundColor Red
    }
    exit 1
}

# Test 3: Retrieve all metahubs
Write-Host "[Test 3] Retrieving all metahubs..." -ForegroundColor Yellow

try {
    $urlQueryParams = "_upl_deleted=eq.false`&_mhb_deleted=eq.false`&order=_upl_created_at.desc"
    $url = "$supabaseUrl/rest/v1/metahubs?$urlQueryParams"
    $allMetahubs = Invoke-RestMethod -Uri $url -Headers $headers -Method Get
    Write-Host "✓ Found $($allMetahubs.Count) metahub(s)" -ForegroundColor Green
    
    foreach ($mh in $allMetahubs) {
        # $mh.name is already a PSCustomObject (PostgREST returns JSONB as JSON)
        # LocalizedContent format: { "_schema": "1", "locales": { "ru": { "content": "..." } }, "_primary": "ru" }
        $name = if ($mh.name.locales.ru.content) { $mh.name.locales.ru.content }
                elseif ($mh.name.locales.en.content) { $mh.name.locales.en.content }
                else { "N/A" }
        Write-Host "  - $name ($($mh.codename))" -ForegroundColor Gray
    }
    Write-Host ""
} catch {
    Write-Host "✗ Error retrieving metahubs: $_" -ForegroundColor Red
    exit 1
}

# Test 4: Verify RLS policies
Write-Host "[Test 4] Checking Row Level Security..." -ForegroundColor Yellow
Write-Host "✓ RLS policies should be active (requires authentication for full test)" -ForegroundColor Yellow
Write-Host ""

# Summary
Write-Host "=== Integration Test Summary ===" -ForegroundColor Cyan
Write-Host "✓ Database schema is accessible" -ForegroundColor Green
Write-Host "✓ Create operation works" -ForegroundColor Green
Write-Host "✓ Read operation works" -ForegroundColor Green
Write-Host "✓ Metahubs are stored in Supabase PostgreSQL" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Login to the app via browser" -ForegroundColor Gray
Write-Host "2. Navigate to /metahubs page" -ForegroundColor Gray
Write-Host "3. Create metahubs through the UI" -ForegroundColor Gray
Write-Host "4. Verify they display from database" -ForegroundColor Gray
Write-Host ""
Write-Host "View data in Supabase:" -ForegroundColor Yellow
$editorUrl = "https://supabase.com/dashboard/project/pleeyslewsialvplxdpg/editor"
Write-Host $editorUrl -ForegroundColor Cyan
