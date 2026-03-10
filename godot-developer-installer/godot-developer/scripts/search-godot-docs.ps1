param(
  [Parameter(Mandatory = $true)]
  [string]$Query,

  [string]$DocsRoot = '',

  [int]$MaxResults = 25
)

$scriptBase = $PSScriptRoot
if ([string]::IsNullOrWhiteSpace($scriptBase)) {
  $scriptBase = Split-Path -Parent $MyInvocation.MyCommand.Path
}

if ([string]::IsNullOrWhiteSpace($DocsRoot)) {
  $DocsRoot = Join-Path $scriptBase '..\..\godot-docs-html-master\_sources'
}

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $DocsRoot)) {
  Write-Error "Docs path not found: $DocsRoot"
}

$files = Get-ChildItem -Path $DocsRoot -Recurse -File -Filter '*.rst.txt'
$hits = $files | Select-String -Pattern $Query -SimpleMatch -CaseSensitive:$false

if (-not $hits) {
  Write-Output "No matches for '$Query' in $DocsRoot"
  exit 0
}

$hits |
  Select-Object -First $MaxResults |
  ForEach-Object {
    $relative = Resolve-Path -LiteralPath $_.Path -Relative
    "${relative}:$($_.LineNumber): $($_.Line.Trim())"
  }
