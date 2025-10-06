# ============================================================================
# Supabase Database Setup Helper Script
# This script helps you prepare the SQL for your Supabase database
# ============================================================================

Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   Les Dauphins Portal - Supabase Database Setup               ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check if user has created test user
Write-Host "📋 Step 1: Create Test User" -ForegroundColor Yellow
Write-Host "   Have you created a test user in Supabase Authentication?" -ForegroundColor White
Write-Host "   1. Go to: https://supabase.com/dashboard/project/npadhtykvehljagyggye/auth/users" -ForegroundColor Gray
Write-Host "   2. Click 'Add user' → 'Create new user'" -ForegroundColor Gray
Write-Host "   3. Email: test@lesdauphins.ca" -ForegroundColor Gray
Write-Host "   4. Password: TestPassword123!" -ForegroundColor Gray
Write-Host "   5. ✅ Check 'Auto Confirm User'" -ForegroundColor Gray
Write-Host ""

$created = Read-Host "Have you created the test user? (y/n)"
if ($created -ne 'y') {
    Write-Host "❌ Please create the test user first, then run this script again." -ForegroundColor Red
    exit
}

# Step 2: Get User UID
Write-Host ""
Write-Host "📋 Step 2: Copy User UID" -ForegroundColor Yellow
Write-Host "   In Supabase Dashboard → Authentication → Users:" -ForegroundColor White
Write-Host "   Click on the test user and copy the User UID" -ForegroundColor White
Write-Host "   It looks like: fdc1d3ce-495b-4bc0-8cfa-b1e997f9a029" -ForegroundColor Gray
Write-Host ""

$userUid = Read-Host "Paste the User UID here"

# Validate UUID format
if ($userUid -notmatch '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$') {
    Write-Host "❌ Invalid User UID format. Please check and try again." -ForegroundColor Red
    exit
}

# Step 3: Generate custom SQL
Write-Host ""
Write-Host "📝 Step 3: Generating Custom SQL Script..." -ForegroundColor Yellow

$sqlContent = Get-Content "supabase_complete_setup.sql" -Raw
$sqlContent = $sqlContent -replace 'fdc1d3ce-495b-4bc0-8cfa-b1e997f9a029', $userUid
$sqlContent = $sqlContent -replace 'YOUR_AUTH_USER_ID', $userUid

$outputFile = "supabase_setup_READY.sql"
$sqlContent | Out-File -FilePath $outputFile -Encoding UTF8

Write-Host "✅ Custom SQL script generated: $outputFile" -ForegroundColor Green

# Step 4: Instructions to run
Write-Host ""
Write-Host "📋 Step 4: Run the SQL in Supabase" -ForegroundColor Yellow
Write-Host "   1. Go to: https://supabase.com/dashboard/project/npadhtykvehljagyggye/sql/new" -ForegroundColor White
Write-Host "   2. Open the file: $outputFile" -ForegroundColor White
Write-Host "   3. Copy ENTIRE contents and paste into SQL Editor" -ForegroundColor White
Write-Host "   4. Click 'Run' button (or Ctrl+Enter)" -ForegroundColor White
Write-Host "   5. Wait for success message" -ForegroundColor White
Write-Host ""

Write-Host "🎯 Quick Link: Opening SQL Editor in browser..." -ForegroundColor Cyan
Start-Process "https://supabase.com/dashboard/project/npadhtykvehljagyggye/sql/new"

Write-Host ""
Write-Host "📂 Opening the generated SQL file..." -ForegroundColor Cyan
Start-Process notepad.exe $outputFile

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "✨ Setup script prepared! Your User UID: $userUid" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Copy all content from: $outputFile" -ForegroundColor White
Write-Host "  2. Paste into Supabase SQL Editor (browser window opened)" -ForegroundColor White
Write-Host "  3. Click 'Run'" -ForegroundColor White
Write-Host "  4. Run: npm run dev" -ForegroundColor White
Write-Host "  5. Test login at: http://localhost:5173" -ForegroundColor White
Write-Host ""
