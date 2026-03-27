# ─────────────────────────────────────────────────────────
# run.ps1 — Start the Real-time Notes App (Windows)
# ─────────────────────────────────────────────────────────

$ErrorActionPreference = "Stop"

$RootDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ServerDir = Join-Path $RootDir "server"
$ClientDir = Join-Path $RootDir "client"

Write-Host ""
Write-Host "═══════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "   📝 Real-time Notes App — Starting...   " -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# ── Check prerequisites ──────────────────────────────────
try { node --version | Out-Null } catch {
    Write-Host "✗ Node.js is not installed. Install from https://nodejs.org" -ForegroundColor Red
    exit 1
}

try { npm --version | Out-Null } catch {
    Write-Host "✗ npm is not installed." -ForegroundColor Red
    exit 1
}

Write-Host "✓ Prerequisites OK" -ForegroundColor Green
Write-Host ""

# ── Install dependencies ─────────────────────────────────
Write-Host "→ Installing server dependencies..." -ForegroundColor Cyan
Push-Location $ServerDir
npm install --silent
Pop-Location

Write-Host "→ Installing client dependencies..." -ForegroundColor Cyan
Push-Location $ClientDir
npm install --silent
Pop-Location

Write-Host "✓ Dependencies installed" -ForegroundColor Green
Write-Host ""

# ── Start servers ────────────────────────────────────────
Write-Host "→ Starting backend on http://localhost:5000" -ForegroundColor Cyan
$ServerProcess = Start-Process -FilePath "npm" -ArgumentList "run dev" -WorkingDirectory $ServerDir -PassThru -NoNewWindow

Write-Host "→ Starting frontend on http://localhost:5173" -ForegroundColor Cyan
$ClientProcess = Start-Process -FilePath "npm" -ArgumentList "run dev" -WorkingDirectory $ClientDir -PassThru -NoNewWindow

Write-Host ""
Write-Host "═══════════════════════════════════════════" -ForegroundColor Green
Write-Host "   ✓ App is running!                      " -ForegroundColor Green
Write-Host "   Frontend: http://localhost:5173         " -ForegroundColor Green
Write-Host "   Backend:  http://localhost:5000         " -ForegroundColor Green
Write-Host "   Press Ctrl+C to stop both servers      " -ForegroundColor Green
Write-Host "═══════════════════════════════════════════" -ForegroundColor Green
Write-Host ""

# ── Wait and cleanup ─────────────────────────────────────
try {
    Write-Host "Press Ctrl+C to stop..." -ForegroundColor DarkGray
    Wait-Process -Id $ServerProcess.Id, $ClientProcess.Id
} finally {
    Write-Host ""
    Write-Host "Shutting down..." -ForegroundColor Cyan

    if (!$ServerProcess.HasExited) { Stop-Process -Id $ServerProcess.Id -Force -ErrorAction SilentlyContinue }
    if (!$ClientProcess.HasExited) { Stop-Process -Id $ClientProcess.Id -Force -ErrorAction SilentlyContinue }

    # Kill any orphaned node processes on the ports
    Get-NetTCPConnection -LocalPort 5000 -ErrorAction SilentlyContinue | ForEach-Object { Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue }
    Get-NetTCPConnection -LocalPort 5173 -ErrorAction SilentlyContinue | ForEach-Object { Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue }

    Write-Host "✓ Stopped" -ForegroundColor Green
}
