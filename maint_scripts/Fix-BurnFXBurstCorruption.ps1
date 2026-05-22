$roots = @(
    (Join-Path $PSScriptRoot '..\actors'),
    (Join-Path $PSScriptRoot '..\zscript')
)
$pat = 'A_PB_BurnFX_Explosion(Heavy|VeryFast)Burst\(([^)]+)\)\s*0,\s*random\s*\([^)]+\)\s*,\s*2,\s*random\s*\([^)]+\)\s*\)'
$repl = 'A_PB_BurnFX_Explosion${1}Burst($2)'
$n = 0
foreach ($r in $roots) {
    Get-ChildItem -LiteralPath $r -Recurse -File -Include '*.dec','*.zc','*.zs' | ForEach-Object {
        $c = [System.IO.File]::ReadAllText($_.FullName)
        $n2 = ([regex]::Matches($c, $pat)).Count
        if ($n2 -gt 0) {
            $c2 = [regex]::Replace($c, $pat, $repl)
            [System.IO.File]::WriteAllText($_.FullName, $c2)
            $n += $n2
            Write-Host "$($_.Name): $n2"
        }
    }
}
Write-Host "Fixed $n corrupted burst lines."
