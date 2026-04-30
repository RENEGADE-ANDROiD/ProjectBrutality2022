$dir = 'C:\Program Files (x86)\Steam\steamapps\common\Ultimate Doom\(Doom Mod Builds)'
$logPath = Join-Path $dir 'pb2022_smoke_full.log'
Remove-Item -LiteralPath $logPath -ErrorAction SilentlyContinue

$pinfo = New-Object System.Diagnostics.ProcessStartInfo
$pinfo.FileName = 'cmd.exe'
$pinfo.WorkingDirectory = $dir
$pinfo.Arguments = '/c gzdoom.exe -iwad DOOM2.WAD -file .TCs\ProjectBrutality2022.zip -norun 1>"' + $logPath + '" 2>&1'
$pinfo.UseShellExecute = $false
$p = New-Object System.Diagnostics.Process
$p.StartInfo = $pinfo
[void]$p.Start()
$finished = $p.WaitForExit(240000)
if (-not $finished) {
	$p.Kill()
	Write-Host 'TIMEOUT after 240s'
}
else {
	Write-Host ('Exit code: {0}' -f $p.ExitCode)
}

$txt = if (Test-Path -LiteralPath $logPath) { Get-Content -LiteralPath $logPath -Raw } else { '' }
$bad = @(
	'Execution could not continue',
	'Script error',
	'GScript error',
	'Sprite names must be exactly',
	'unable to find texture in font definition'
)
$found = @()
foreach ($b in $bad) { if ($txt -match [regex]::Escape($b)) { $found += $b } }

if ($found.Count -gt 0) {
	Write-Host 'FAIL patterns in log:'
	$found | ForEach-Object { Write-Host "  $_" }
}
elseif ($txt -match 'script parsing took') {
	Write-Host 'PASS: reached script parsing completion line'
}
else {
	Write-Host 'UNCLEAR: log tail:'
	if (Test-Path -LiteralPath $logPath) { Get-Content -LiteralPath $logPath -Tail 30 }
}
