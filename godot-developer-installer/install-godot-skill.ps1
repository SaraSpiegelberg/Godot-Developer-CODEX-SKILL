param(
    [string]$SkillName = "godot-developer",
    [string]$SourcePath = "",
    [string]$DestSkillsDir = ""
)

$ErrorActionPreference = "Stop"

function Resolve-SourcePath {
    param(
        [string]$ScriptDir,
        [string]$SkillName,
        [string]$ProvidedSourcePath
    )

    if ($ProvidedSourcePath) {
        return (Resolve-Path -LiteralPath $ProvidedSourcePath).Path
    }

    $candidates = @(
        (Join-Path $ScriptDir $SkillName),
        (Join-Path (Split-Path -Parent $ScriptDir) $SkillName)
    )

    foreach ($candidate in $candidates) {
        if (Test-Path -LiteralPath $candidate) {
            return (Resolve-Path -LiteralPath $candidate).Path
        }
    }

    throw "Could not find source folder for '$SkillName'. Put the skill folder next to this installer or pass -SourcePath."
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$resolvedSourcePath = Resolve-SourcePath -ScriptDir $scriptDir -SkillName $SkillName -ProvidedSourcePath $SourcePath
$sourceSkillFile = Join-Path $resolvedSourcePath "SKILL.md"

if (-not (Test-Path -LiteralPath $sourceSkillFile)) {
    throw "Source path '$resolvedSourcePath' does not look like a Codex skill (missing SKILL.md)."
}

if (-not $DestSkillsDir) {
    $codexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $env:USERPROFILE ".codex" }
    $DestSkillsDir = Join-Path $codexHome "skills"
} else {
    $codexHome = Split-Path -Parent $DestSkillsDir
}

New-Item -ItemType Directory -Path $DestSkillsDir -Force | Out-Null

$destinationSkillPath = Join-Path $DestSkillsDir $SkillName
$backupPath = ""

if (Test-Path -LiteralPath $destinationSkillPath) {
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $backupRoot = Join-Path $codexHome "skill-backups"
    New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
    $backupPath = Join-Path $backupRoot "$SkillName.backup-$timestamp"
    Move-Item -LiteralPath $destinationSkillPath -Destination $backupPath -Force
    Write-Host "Existing skill moved to backup: $backupPath"
}

try {
    Copy-Item -LiteralPath $resolvedSourcePath -Destination $destinationSkillPath -Recurse -Force
} catch {
    if ($backupPath -and (Test-Path -LiteralPath $backupPath) -and -not (Test-Path -LiteralPath $destinationSkillPath)) {
        Move-Item -LiteralPath $backupPath -Destination $destinationSkillPath -Force
    }
    throw
}

$installedSkillFile = Join-Path $destinationSkillPath "SKILL.md"
if (-not (Test-Path -LiteralPath $installedSkillFile)) {
    throw "Install failed: '$installedSkillFile' was not created."
}

Write-Host ""
Write-Host "Skill installed successfully:"
Write-Host "  Name: $SkillName"
Write-Host "  Source: $resolvedSourcePath"
Write-Host "  Destination: $destinationSkillPath"
Write-Host ""
Write-Host "Restart Codex to pick up new skills."
