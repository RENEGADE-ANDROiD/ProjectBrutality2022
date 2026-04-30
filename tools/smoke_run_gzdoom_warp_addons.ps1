# Same as smoke_run_gzdoom_warp.ps1 but also loads PB3-Universals.zip (matches many user logs).
$ErrorActionPreference = 'Continue'
$TimeoutSec = 45
$dir = 'C:\Program Files (x86)\Steam\steamapps\common\Ultimate Doom\(Doom Mod Builds)'
$exe = Join-Path $dir 'gzdoom.exe'
$iwad = Join-Path $dir 'DOOM2.WAD'
$modTc = Join-Path $dir '.TCs\ProjectBrutality2022.zip'
$modUni = Join-Path $dir '.ADDONSs\PB3-Universals.zip'
$logName = 'pb2022_smoke_warp_addons.log'
$logPath = Join-Path $dir $logName

foreach ($req in @($exe, $iwad, $modTc, $modUni)) {
	if (-not (Test-Path -LiteralPath $req)) { throw "Missing: $req" }
}

Remove-Item -LiteralPath $logPath -ErrorAction SilentlyContinue

$p = Start-Process -FilePath $exe -WorkingDirectory $dir -ArgumentList @(
	'-iwad', $iwad,
	'-file', $modTc, $modUni,
	'+warp', '1', '1',
	'+logfile', $logName
) -PassThru

$finished = $p.WaitForExit($TimeoutSec * 1000)
if (-not $finished) {
	Write-Host "WARP_ADDONS_SMOKE: no exit after ${TimeoutSec}s (killing)"
	Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue
}
else {
	Write-Host ("WARP_ADDONS_SMOKE: exit code {0}" -f $p.ExitCode)
}

if (Test-Path -LiteralPath $logPath) {
	Write-Host '--- warp+log (filtered) ---'
	Select-String -LiteralPath $logPath -Pattern 'Execution could not continue|Script error|GScript error|VM abort|I_Error|Tried to execute|AddressSanitizer' -CaseSensitive:$false -ErrorAction SilentlyContinue |
		ForEach-Object { $_.Line } | Select-Object -First 35
}
