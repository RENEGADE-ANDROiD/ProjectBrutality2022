# Recompile ACS sources in this repo with ACC (e.g. bundled with SLADE or PB_ACC).
# Usage (from repo root):
#   powershell -NoProfile -File tools/compile_acs.ps1
#   powershell -NoProfile -File tools/compile_acs.ps1 -Source SRC\GloryChain.acs
#
# Optional environment:
#   PB_ACC         - full path to acc.exe
#   PB_ACC_INCLUDE - folder containing zcommon.acs (defaults to acc.exe directory)

param(
	[string] $Source = "SRC\GloryHUD.acs",
	[string] $Output = ""
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location -LiteralPath $repoRoot

function Find-AccExe {
	if ($env:PB_ACC -and (Test-Path -LiteralPath $env:PB_ACC)) {
		return (Resolve-Path -LiteralPath $env:PB_ACC).Path
	}
	foreach ($base in @(
			"${env:ProgramFiles}\SLADE3",
			"${env:ProgramFiles(x86)}\SLADE3",
			"${env:ProgramFiles}\SLADE",
			"${env:ProgramFiles(x86)}\SLADE",
			"${env:ProgramFiles}\Slade3",
			"${env:ProgramFiles(x86)}\Slade3"
		)) {
		if (-not $base) { continue }
		foreach ($rel in @("acc.exe", "ACC\acc.exe", "Tools\ACC\acc.exe", "tools\acc.exe")) {
			$p = Join-Path $base $rel
			if (Test-Path -LiteralPath $p) { return (Resolve-Path -LiteralPath $p).Path }
		}
	}
	return $null
}

$accExe = Find-AccExe
if (-not $accExe) {
	Write-Error @"
acc.exe not found. Install SLADE (bundles ACC) or set PB_ACC to the full path of acc.exe.
Example:
  setx PB_ACC "C:\Path\to\ACC\acc.exe"
"@
	exit 1
}

$includeDir = $env:PB_ACC_INCLUDE
if (-not $includeDir) {
	$includeDir = Split-Path -Parent $accExe
}
if (-not (Test-Path -LiteralPath (Join-Path $includeDir "zcommon.acs"))) {
	Write-Warning "zcommon.acs not found next to acc.exe at $includeDir - compile may fail. Set PB_ACC_INCLUDE if headers live elsewhere."
}

$srcPath = if ([System.IO.Path]::IsPathRooted($Source)) { $Source } else { Join-Path $repoRoot $Source }
if (-not (Test-Path -LiteralPath $srcPath)) {
	Write-Error "Source not found: $srcPath"
	exit 1
}

$srcName = [System.IO.Path]::GetFileName($srcPath)
if (-not $Output) {
	$base = [System.IO.Path]::GetFileNameWithoutExtension($srcName)
	if ($base -ieq "GloryChain") { $base = "GloryMelee" }
	$Output = Join-Path $repoRoot "ACS\$base.o"
}
elseif (-not [System.IO.Path]::IsPathRooted($Output)) {
	$Output = Join-Path $repoRoot $Output
}

Write-Host "ACC:    $accExe"
Write-Host "Include $includeDir"
Write-Host "Source: $srcPath"
Write-Host "Output: $Output"

& $accExe -i $includeDir $srcPath $Output
exit $LASTEXITCODE
