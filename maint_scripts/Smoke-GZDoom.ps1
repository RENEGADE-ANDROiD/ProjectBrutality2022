# Smoke: compile ZScript via UZDoom/GZDoom -norun. Exit 0 on success (incl. UZDoom 1337 + -Norun).
param(
    [switch]$Norun,
    [switch]$Developer
)

$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$log = Join-Path $root ("smoketest_{0:yyyyMMdd_HHmmss}.log" -f (Get-Date))

function Find-Engine {
    if ($env:PB_SMOKE_ENGINE -and (Test-Path -LiteralPath $env:PB_SMOKE_ENGINE)) { return $env:PB_SMOKE_ENGINE }
    foreach ($n in @('uzdoom.exe', 'gzdoom.exe', 'gzdoom-gles.exe')) {
        $w = Get-Command $n -ErrorAction SilentlyContinue
        if ($w) { return $w.Source }
    }
    foreach ($p in @(
        "${env:ProgramFiles}\UZDoom\uzdoom.exe",
        "${env:ProgramFiles}\GZDoom\gzdoom.exe",
        "${env:ProgramFiles(x86)}\GZDoom\gzdoom.exe"
    )) {
        if (Test-Path -LiteralPath $p) { return $p }
    }
    return $null
}

function Find-Iwad {
    if ($env:PB_SMOKE_IWAD -and (Test-Path -LiteralPath $env:PB_SMOKE_IWAD)) { return $env:PB_SMOKE_IWAD }
    if ($env:DOOMWADDIR) {
        foreach ($n in @('DOOM2.WAD', 'doom2.wad', 'DOOM.WAD')) {
            $p = Join-Path $env:DOOMWADDIR $n
            if (Test-Path -LiteralPath $p) { return $p }
        }
    }
    foreach ($p in @(
        "${env:ProgramFiles(x86)}\Steam\steamapps\common\DOOM II\base\doom2.wad",
        "${env:ProgramFiles(x86)}\Steam\steamapps\common\Ultimate Doom\base\doom.wad"
    )) {
        if (Test-Path -LiteralPath $p) { return $p }
    }
    return $null
}

$engine = Find-Engine
$iwad = Find-Iwad
if (-not $engine) { Write-Error 'No gzdoom.exe / uzdoom.exe found. Set PB_SMOKE_ENGINE.' }
if (-not $iwad) { Write-Error 'No IWAD found. Set PB_SMOKE_IWAD or DOOMWADDIR.' }

$args = @("-iwad", $iwad, "-file", $root, "+logfile", $log)
if ($Norun) { $args += '-norun' }
if ($Developer) { $args += '-devparm' }

Write-Host "Engine: $engine"
Write-Host "IWAD:   $iwad"
Write-Host "Log:    $log"
& $engine @args
$code = $LASTEXITCODE
if ($Norun -and $code -eq 1337) { $code = 0 }

# Log may flush after process exit on Windows.
Start-Sleep -Seconds 10

if (Test-Path -LiteralPath $log) {
    $bad = Select-String -LiteralPath $log -Pattern 'Script error|Script warning|Error compiling|Execution could not continue|Unable to resolve|tried to read from address zero' -SimpleMatch:$false
    if ($bad) {
        $errs = $bad | Where-Object { $_.Line -match 'Script error|Error compiling|Execution could not continue|Unable to resolve|tried to read from address zero' }
        $warns = $bad | Where-Object { $_.Line -match 'Script warning' }
        if ($errs) {
            $errs | Select-Object -First 40 | ForEach-Object { Write-Host $_.Line }
            exit 1
        }
        if ($warns) {
            $warns | Select-Object -First 20 | ForEach-Object { Write-Host $_.Line }
            Write-Host "Smoke: $($warns.Count) script warning(s) - see log."
        }
    }
}
if ($code -ne 0) { exit $code }
Write-Host 'Smoke OK (no script errors in log).'
exit 0
