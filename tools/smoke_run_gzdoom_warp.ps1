# Short in-map smoke: loads MAP01, runs up to $TimeoutSec, then kills process.
# Catches immediate VM abort / crash; a full GPU deadlock may still look like a timeout.
$ErrorActionPreference = 'Continue'
$TimeoutSec = 35
$dir = 'C:\Program Files (x86)\Steam\steamapps\common\Ultimate Doom\(Doom Mod Builds)'
$exe = Join-Path $dir 'gzdoom.exe'
$iwad = Join-Path $dir 'DOOM2.WAD'
$mod = Join-Path $dir '.TCs\ProjectBrutality2022.zip'
$logName = 'pb2022_smoke_warp.log'
$logPath = Join-Path $dir $logName

if (-not (Test-Path -LiteralPath $exe)) { throw "Missing engine: $exe" }
if (-not (Test-Path -LiteralPath $iwad)) { throw "Missing IWAD: $iwad" }
if (-not (Test-Path -LiteralPath $mod)) { throw "Missing mod: $mod" }

Remove-Item -LiteralPath $logPath -ErrorAction SilentlyContinue

$p = Start-Process -FilePath $exe -WorkingDirectory $dir -ArgumentList @(
	'-iwad', $iwad,
	'-file', $mod,
	'+warp', '1', '1',
	'+logfile', $logName
) -PassThru

$finished = $p.WaitForExit($TimeoutSec * 1000)
if (-not $finished) {
	Write-Host "WARP_SMOKE: no exit after ${TimeoutSec}s (killing - possible hang, stuck load, or open window)"
	Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue
}
else {
	Write-Host ("WARP_SMOKE: exit code {0}" -f $p.ExitCode)
}

if (Test-Path -LiteralPath $logPath) {
	Write-Host '--- warp log (filtered) ---'
	Select-String -LiteralPath $logPath -Pattern 'Execution could not continue|Script error|GScript error|VM abort|I_Error|Tried to execute|AddressSanitizer' -CaseSensitive:$false -ErrorAction SilentlyContinue |
		ForEach-Object { $_.Line } | Select-Object -First 30
}
