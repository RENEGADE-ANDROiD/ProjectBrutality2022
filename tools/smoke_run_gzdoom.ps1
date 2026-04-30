$ErrorActionPreference = 'Continue'
$dir = 'C:\Program Files (x86)\Steam\steamapps\common\Ultimate Doom\(Doom Mod Builds)'
$exe = Join-Path $dir 'gzdoom.exe'
$iwad = Join-Path $dir 'DOOM2.WAD'
$mod = Join-Path $dir '.TCs\ProjectBrutality2022.zip'
$logOut = Join-Path $dir 'pb2022_smoke_norun_out.log'
$logErr = Join-Path $dir 'pb2022_smoke_norun_err.log'
Remove-Item -LiteralPath $logOut,$logErr -ErrorAction SilentlyContinue

$proc = Start-Process -FilePath $exe -ArgumentList @(
	"-iwad", $iwad,
	"-file", $mod,
	"-norun"
) -Wait -PassThru -NoNewWindow -RedirectStandardOutput $logOut -RedirectStandardError $logErr

Write-Host "Exit code: $($proc.ExitCode)"
Write-Host '--- stderr (tail) ---'
if (Test-Path -LiteralPath $logErr) { Get-Content -LiteralPath $logErr -Tail 40 }
Write-Host '--- stdout (tail) ---'
if (Test-Path -LiteralPath $logOut) { Get-Content -LiteralPath $logOut -Tail 40 }
