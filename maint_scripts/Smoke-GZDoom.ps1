#requires -Version 5.0
<#
.SYNOPSIS
  Launch GZDoom/UZDoom with this repo as -file and optional -norun (ZScript compile smoke).

.PARAMETER Norun
  Pass -norun to the engine so it exits after init (no gameplay window on supported builds).

.PARAMETER Developer
  Pass -developer for noisier startup.

.PARAMETER VerboseWarnings
  Pass +verbose for extra engine warnings.

.NOTES
  PB_SMOKE_ENGINE = full path to gzdoom.exe / uzdoom.exe
  PB_SMOKE_IWAD   = full path to DOOM2.WAD (or freedoom2.wad, etc.)
  DOOMWADDIR      = directory searched for IWAD names

  Also probes: ...\Ultimate Doom\(Doom Mod Builds)\ for gzdoom.exe / uzdoom.exe and IWADs (top folder + first-level subdirs).
#>
param(
	[switch]$Norun,
	[switch]$Developer,
	[switch]$VerboseWarnings
)

$ErrorActionPreference = 'Stop'
$ModRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$SmokeUltimateDoomModBuilds = "${env:ProgramFiles(x86)}\Steam\steamapps\common\Ultimate Doom\(Doom Mod Builds)"

function Find-ExeUnderUltimateDoomModBuilds([string]$leaf) {
	if (-not (Test-Path -LiteralPath $SmokeUltimateDoomModBuilds)) { return $null }
	$p = Join-Path $SmokeUltimateDoomModBuilds $leaf
	if (Test-Path -LiteralPath $p) { return $p }
	foreach ($d in Get-ChildItem -LiteralPath $SmokeUltimateDoomModBuilds -Directory -ErrorAction SilentlyContinue | Select-Object -First 40) {
		$p2 = Join-Path $d.FullName $leaf
		if (Test-Path -LiteralPath $p2) { return $p2 }
	}
	return $null
}

function Find-IwadUnderUltimateDoomModBuilds {
	if (-not (Test-Path -LiteralPath $SmokeUltimateDoomModBuilds)) { return $null }
	foreach ($n in @('DOOM2.WAD', 'doom2.wad', 'DOOM.WAD', 'doom.wad', 'freedoom2.wad', 'freedm.wad')) {
		$p = Join-Path $SmokeUltimateDoomModBuilds $n
		if (Test-Path -LiteralPath $p) { return $p }
		foreach ($d in Get-ChildItem -LiteralPath $SmokeUltimateDoomModBuilds -Directory -ErrorAction SilentlyContinue | Select-Object -First 40) {
			$p2 = Join-Path $d.FullName $n
			if (Test-Path -LiteralPath $p2) { return $p2 }
		}
	}
	return $null
}

function Find-Engine {
	if ($env:PB_SMOKE_ENGINE) {
		$p = $env:PB_SMOKE_ENGINE.Trim()
		if (Test-Path -LiteralPath $p) { return $p }
		Write-Warning "PB_SMOKE_ENGINE set but not found: $p"
	}
	foreach ($name in @('gzdoom', 'uzdoom')) {
		try {
			$c = Get-Command $name -ErrorAction Stop
			if ($c.Source -and (Test-Path -LiteralPath $c.Source)) { return $c.Source }
		} catch { }
	}
	foreach ($leaf in @('gzdoom.exe', 'uzdoom.exe')) {
		$found = Find-ExeUnderUltimateDoomModBuilds $leaf
		if ($found) { return $found }
	}
	$cands = @(
		"${env:ProgramFiles}\GZDoom\gzdoom.exe",
		"${env:ProgramFiles(x86)}\GZDoom\gzdoom.exe",
		"${env:ProgramFiles}\UZDoom\uzdoom.exe",
		"${env:ProgramFiles(x86)}\UZDoom\uzdoom.exe",
		"${env:LOCALAPPDATA}\Programs\GZDoom\gzdoom.exe"
	)
	foreach ($p in $cands) {
		if ($p -and (Test-Path -LiteralPath $p)) { return $p }
	}
	foreach ($leaf in @('gzdoom.exe', 'uzdoom.exe')) {
		foreach ($rp in @(
			'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\' + $leaf,
			'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\' + $leaf
		)) {
			try {
				$def = (Get-ItemProperty -LiteralPath $rp -ErrorAction Stop).'(default)'
				if ($def -and (Test-Path -LiteralPath $def)) { return $def }
			} catch { }
		}
	}
	return $null
}

function Find-Iwad {
	if ($env:PB_SMOKE_IWAD) {
		$p = $env:PB_SMOKE_IWAD.Trim()
		if (Test-Path -LiteralPath $p) { return $p }
		Write-Warning "PB_SMOKE_IWAD set but not found: $p"
	}
	if ($env:DOOMWADDIR) {
		$dir = $env:DOOMWADDIR.TrimEnd('\', '/')
		foreach ($n in @('DOOM2.WAD', 'doom2.wad', 'DOOM.WAD', 'doom.wad', 'freedoom2.wad', 'freedm.wad')) {
			$p = Join-Path $dir $n
			if (Test-Path -LiteralPath $p) { return $p }
		}
	}
	$roots = @(
		"${env:ProgramFiles(x86)}\Steam\steamapps\common",
		"${env:ProgramFiles}\Steam\steamapps\common",
		'D:\SteamLibrary\steamapps\common',
		'E:\SteamLibrary\steamapps\common'
	)
	foreach ($root in $roots) {
		if (-not (Test-Path -LiteralPath $root)) { continue }
		foreach ($rel in @(
			'Doom 2\base\DOOM2.WAD',
			'Ultimate Doom\base\DOOM2.WAD',
			'DOOM II\base\DOOM2.WAD',
			'FreeDM\freedm.wad',
			'Freedoom\Freedoom Phase 2\freedoom2.wad'
		)) {
			$p = Join-Path $root $rel
			if (Test-Path -LiteralPath $p) { return $p }
		}
	}
	$iwadMod = Find-IwadUnderUltimateDoomModBuilds
	if ($iwadMod) { return $iwadMod }
	return $null
}

function Should-SkipSmokeLine([string]$line) {
	if ([string]::IsNullOrWhiteSpace($line)) { return $true }
	if ($line -match '(?i)subtract' -and $line -match '(?i)keyconf') { return $true }
	if ($line -match '(?i)Unknown.*key.*subtract') { return $true }
	if ($line -match '(?i)subtract.*Unknown') { return $true }
	return $false
}

function Test-SmokeLogFatal([string]$logPath) {
	if (-not (Test-Path -LiteralPath $logPath)) { return @() }
	$fatal = @(
		'Parse error',
		'Script error',
		'Bad syntax',
		'Compilation failed',
		'Tried to define class',
		'Cannot load',
		'Vile corruption'
	)
	$hits = New-Object System.Collections.Generic.List[string]
	Get-Content -LiteralPath $logPath -ErrorAction Stop | ForEach-Object {
		$ln = $_
		if (Should-SkipSmokeLine $ln) { return }
		foreach ($pat in $fatal) {
			if ($ln -match [regex]::Escape($pat)) {
				$hits.Add($ln)
				break
			}
		}
	}
	return @($hits)
}

$eng = Find-Engine
$wad = Find-Iwad
if (-not $eng) {
	[Console]::Error.WriteLine('GZDoom/UZDoom not found. Install GZDoom or set PB_SMOKE_ENGINE to the full path of gzdoom.exe / uzdoom.exe.')
	exit 2
}
if (-not $wad) {
	[Console]::Error.WriteLine('IWAD not found. Install DOOM II (or Freedoom), set DOOMWADDIR, or set PB_SMOKE_IWAD to the full path of DOOM2.WAD.')
	exit 3
}

$ts = Get-Date -Format 'yyyyMMdd_HHmmss'
$logName = Join-Path $ModRoot "smoketest_$ts.log"

$argList = New-Object System.Collections.Generic.List[string]
$argList.Add('-iwad')
$argList.Add($wad)
$argList.Add('-file')
$argList.Add($ModRoot)
$argList.Add('+logfile')
$argList.Add($logName)
$argList.Add('-stdout')
if ($Norun) { $argList.Add('-norun') }
if ($Developer) { $argList.Add('-developer') }
if ($VerboseWarnings) { $argList.Add('+verbose') }

Write-Host "Engine: $eng"
Write-Host "IWAD:   $wad"
Write-Host "Log:    $logName"
Write-Host "Args:   $($argList -join ' ')"

$p = Start-Process -FilePath $eng -ArgumentList $argList.ToArray() -PassThru -Wait -NoNewWindow
$ec = $p.ExitCode
Write-Host "Exit code: $ec"
# UZDoom -norun often exits 1337 (compile/init success sentinel); do not fail CI on that alone.
if ($Norun -and $null -ne $ec -and [int]$ec -eq 1337) { $ec = 0 }

$warnLines = @()
if (Test-Path -LiteralPath $logName) {
	Get-Content -LiteralPath $logName -ErrorAction SilentlyContinue | ForEach-Object {
		if (Should-SkipSmokeLine $_) { return }
		if ($_ -match '(?i)\bwarning\b') { $warnLines += $_ }
	}
}

if ($warnLines.Count -gt 0) {
	Write-Host "`n--- Warnings (subtract/KEYCONF filtered) ---"
	$warnLines | Select-Object -First 80 | ForEach-Object { Write-Host $_ }
	if ($warnLines.Count -gt 80) { Write-Host "... ($($warnLines.Count) total warning lines)" }
}

$fatals = Test-SmokeLogFatal $logName
if ($fatals -and $fatals.Count -gt 0) {
	Write-Host "`n--- Fatal / error patterns in log ---"
	$fatals | Select-Object -First 40 | ForEach-Object { Write-Host $_ }
	exit 1
}

if ($null -ne $ec -and [int]$ec -ne 0) {
	Write-Warning "Engine exited with code $ec (non-zero). Review log: $logName"
	exit [int]$ec
}

exit 0
