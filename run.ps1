$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$serverDir = Join-Path $root "server"
$clientDir = Join-Path $root "client"

try { node --version | Out-Null } catch { Write-Host "node not found"; exit 1 }
try { npm --version | Out-Null } catch { Write-Host "npm not found"; exit 1 }

Write-Host "installing deps..."
Push-Location $serverDir
npm install --silent
Pop-Location

Push-Location $clientDir
npm install --silent
Pop-Location

Write-Host "starting backend..."
$srv = Start-Process -FilePath "npm" -ArgumentList "run dev" -WorkingDirectory $serverDir -PassThru -NoNewWindow

Write-Host "starting frontend..."
$cli = Start-Process -FilePath "npm" -ArgumentList "run dev" -WorkingDirectory $clientDir -PassThru -NoNewWindow

Write-Host ""
Write-Host "backend  -> http://localhost:5000"
Write-Host "frontend -> http://localhost:5173"
Write-Host "ctrl+c to stop"

try {
    Wait-Process -Id $srv.Id, $cli.Id
} finally {
    if (!$srv.HasExited) { Stop-Process -Id $srv.Id -Force -ErrorAction SilentlyContinue }
    if (!$cli.HasExited) { Stop-Process -Id $cli.Id -Force -ErrorAction SilentlyContinue }
}
