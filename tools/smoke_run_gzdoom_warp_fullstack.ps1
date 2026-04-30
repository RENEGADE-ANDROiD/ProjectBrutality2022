# Approximate your load order: DOOM2 + id24res + widescreen + ag-rc4 + Universals + PB2022 (no titlemap).
$ErrorActionPreference = 'Continue'
$TimeoutSec = 50
$dir = 'C:\Program Files (x86)\Steam\steamapps\common\Ultimate Doom\(Doom Mod Builds)'
$doomRoot = 'C:\Program Files (x86)\Steam\steamapps\common\Ultimate Doom'
$exe = Join-Path $dir 'gzdoom.exe'
$iwad = Join-Path $dir 'DOOM2.WAD'
$id24 = Join-Path $doomRoot 'rerelease\id24res.wad'
$gfx = Join-Path $dir 'game_widescreen_gfx.pk3'
$mapWad = Join-Path $dir '.MAPs\ag-rc4.wad'
$modUni = Join-Path $dir '.ADDONSs\PB3-Universals.zip'
$modTc = Join-Path $dir '.TCs\ProjectBrutality2022.zip'
$logName = 'pb2022_smoke_warp_fullstack.log'
$logPath = Join-Path $dir $logName

foreach ($req in @($exe, $iwad, $id24, $gfx, $mapWad, $modUni, $modTc)) {
	if (-not (Test-Path -LiteralPath $req)) { throw "Missing: $req" }
}

Remove-Item -LiteralPath $logPath -ErrorAction SilentlyContinue

$p = Start-Process -FilePath $exe -WorkingDirectory $dir -ArgumentList @(
	'-iwad', $iwad,
	'-file', $id24, $gfx, $mapWad, $modUni, $modTc,
	'+warp', '1', '1',
	'+logfile', $logName
) -PassThru

$finished = $p.WaitForExit($TimeoutSec * 1000)
if (-not $finished) {
	Write-Host "FULLSTACK_SMOKE: no exit after ${TimeoutSec}s (killing)"
	Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue
}
else {
	Write-Host ("FULLSTACK_SMOKE: exit code {0}" -f $p.ExitCode)
}

if (Test-Path -LiteralPath $logPath) {
	Write-Host '--- log (filtered) ---'
	Select-String -LiteralPath $logPath -Pattern 'Execution could not continue|Script error|GScript error|VM abort|I_Error|MAP01|Creating' -CaseSensitive:$false -ErrorAction SilentlyContinue |
		ForEach-Object { $_.Line } | Select-Object -First 40
}
