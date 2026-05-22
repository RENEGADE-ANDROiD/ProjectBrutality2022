# Extract ACTOR <Weapon> : PB_Weapon from DECORATE into class <Weapon> : PB_WeaponBase .zs
# Run Fix-ZScriptWeaponZs.ps1 on outputs after.

param(
    [Parameter(Mandatory = $true)][string]$DecPath,
    [Parameter(Mandatory = $true)][string]$ClassName,
    [Parameter(Mandatory = $true)][string]$ZsPath
)

function Get-BraceCountsForLine {
    param([string]$line)
    $t = $line
    if ($t.Trim().StartsWith('/*')) { return @{ Open = 0; Close = 0 } }
    $idx = $t.IndexOf('//')
    if ($idx -ge 0) { $t = $t.Substring(0, $idx) }
    return @{
        Open  = ([regex]::Matches($t, '\{')).Count
        Close = ([regex]::Matches($t, '\}')).Count
    }
}

function Get-BraceBlockEnd {
    param([string[]]$Lines, [int]$OpenLineIdx)
    $depth = 0
    for ($i = $OpenLineIdx; $i -lt $Lines.Count; $i++) {
        $bc = Get-BraceCountsForLine $Lines[$i]
        $depth += $bc.Open - $bc.Close
        if ($depth -lt 0) { return -1 }
        if ($depth -eq 0 -and $i -gt $OpenLineIdx) { return $i }
    }
    return -1
}

function Convert-DefaultLine {
    param([string]$line)
    $t = $line.Trim()
    if ($t.Length -eq 0) { return $null }
    if ($t -match '^\s*//') { return $line }
    if ($t -match '^//\$') { return "`t`t" + ($line -replace '^\s*//\$', '//') }
    if ($t -match '^Game\s+Doom') { return "`t`t// Game Doom (DECORATE only)" }
    if ($t -match '^SpawnID\b') { return "`t`t// SpawnID (DECORATE editor only)" }
    if ($t -match '^Weapon\.BobStyle\s+InverseSmooth') { return "`t`tWeapon.BobStyle `"InverseSmooth`";" }
    if ($t -match '^Weapon\.SisterWeapon\s+(\w+)') {
        $cls = $Matches[1]
        if ($cls -notmatch '^"') { return "`t`tWeapon.SisterWeapon `"$cls`";" }
    }
    if ($t -match '^Replaces\s+') { return "`t`t// $($t)" }
    if ($t -match '^Inventory\.althudicon') {
        return ($line -ireplace 'Inventory\.althudicon', 'Inventory.AltHUDIcon')
    }
    if ($t -match '[;{}]$') { return $line }
    return $line.TrimEnd() + ';'
}

function Convert-StateLine {
    param([string]$line)
    $t = $line.Trim()
    if ($t.Length -eq 0) { return $line }
    if ($t -match '^[A-Za-z_][A-Za-z0-9_]*:\s*$') {
        return "`t`t" + $t
    }
    $out = $line
    if ($out -match '^\s+(\d+[A-Za-z][A-Za-z0-9]*)\s') {
        $out = $out -replace '^\s+(\d+[A-Za-z][A-Za-z0-9]*)', "`t`t`"`$1`""
    }
    if ($t -match '^(Goto|Loop|Wait|Stop)\b' -and $t -notmatch ';$') {
        return $out.TrimEnd() + ';'
    }
    if ($t.Length -gt 0 -and $t -notmatch '[;{}]$' -and $t -notmatch '^\s*//') {
        return $out.TrimEnd() + ';'
    }
    return $out
}

$decFull = (Resolve-Path -LiteralPath $DecPath).Path
$lines = Get-Content -LiteralPath $decFull -Encoding UTF8
$actorPat = "^\s*ACTOR\s+$([regex]::Escape($ClassName))\s*:\s*PB_Weapon\b"
$start = -1
for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match $actorPat) { $start = $i; break }
}
if ($start -lt 0) { Write-Error "ACTOR $ClassName : PB_Weapon not found in $DecPath"; exit 1 }

$openBrace = -1
for ($i = $start; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match '\{') { $openBrace = $i; break }
}
$end = Get-BraceBlockEnd $lines $openBrace
if ($end -lt 0) { Write-Error "Unbalanced braces in $ClassName"; exit 1 }

$body = $lines[($openBrace + 1)..($end - 1)]
$before = if ($start -gt 0) { $lines[0..($start - 1)] } else { @() }
$after = if ($end + 1 -lt $lines.Count) { $lines[($end + 1)..($lines.Count - 1)] } else { @() }

$statesIdx = -1
$statesInlineBrace = $false
for ($i = 0; $i -lt $body.Count; $i++) {
    if ($body[$i] -match '^\s*States\s*$') { $statesIdx = $i; break }
    if ($body[$i] -match '^\s*States\s*\{\s*$') { $statesIdx = $i; $statesInlineBrace = $true; break }
}
$propLines = if ($statesIdx -ge 0) { $body[0..($statesIdx - 1)] } else { $body }
$stateLines = @()
if ($statesIdx -ge 0) {
    if ($statesInlineBrace) {
        # Inline "States {" often closes on the actor's last line ("Goto Ready3 }}") which is
        # outside $body (body ends at $end - 1). Include the actor close line for brace matching only.
        $stateScan = $body
        if ($end -ge 0 -and $end -lt $lines.Count) { $stateScan = $body + @($lines[$end]) }
        $sEnd = -1
        $sDepth = 0
        for ($k = $statesIdx; $k -lt $stateScan.Count; $k++) {
            $bc = Get-BraceCountsForLine $stateScan[$k]
            $sDepth += $bc.Open - $bc.Close
            if ($sDepth -le 0 -and $k -gt $statesIdx) { $sEnd = $k; break }
        }
        if ($sEnd -gt $statesIdx) {
            $stateLines = $stateScan[($statesIdx + 1)..($sEnd - 1)]
        }
    } else {
        $s = $statesIdx + 1
        while ($s -lt $body.Count -and $body[$s] -notmatch '\{') { $s++ }
        if ($s -lt $body.Count) {
            $sEnd = Get-BraceBlockEnd $body $s
            if ($sEnd -gt $s) { $stateLines = $body[($s + 1)..($sEnd - 1)] }
        }
    }
}

$zs = New-Object System.Collections.Generic.List[string]
[void]$zs.Add("// $ClassName - ZScript port (DECORATE PB_Weapon retired).")
[void]$zs.Add('')
[void]$zs.Add("class $ClassName : PB_WeaponBase")
[void]$zs.Add('{')
[void]$zs.Add('	default')
[void]$zs.Add('	{')
foreach ($line in $propLines) {
    $c = Convert-DefaultLine $line
    if ($null -ne $c) { [void]$zs.Add($c) }
}
[void]$zs.Add('	}')
[void]$zs.Add('	states')
[void]$zs.Add('	{')
foreach ($line in $stateLines) {
    [void]$zs.Add((Convert-StateLine $line))
}
[void]$zs.Add('	}')
[void]$zs.Add('}')

$zsDir = Split-Path -Parent $ZsPath
if ($zsDir -and -not (Test-Path -LiteralPath $zsDir)) {
    New-Item -ItemType Directory -Path $zsDir -Force | Out-Null
}
[System.IO.File]::WriteAllLines($ZsPath, $zs.ToArray(), [System.Text.UTF8Encoding]::new($false))

$stub = New-Object System.Collections.Generic.List[string]
[void]$stub.Add("// $ClassName weapon states: $ZsPath")
foreach ($l in $before) { [void]$stub.Add($l) }
foreach ($l in $after) { [void]$stub.Add($l) }
[System.IO.File]::WriteAllLines($decFull, $stub.ToArray(), [System.Text.UTF8Encoding]::new($false))

Write-Host "Wrote $ZsPath"
