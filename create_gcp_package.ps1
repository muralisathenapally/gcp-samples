
param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectId
)

$ErrorActionPreference = "Stop"

$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$OutputDir = "gcp-inventory-$ProjectId-$Timestamp"

New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null

$OutputFile = Join-Path $OutputDir "all_assets.json"

Write-Host "Starting Cloud Asset Inventory..."
Write-Host "Project: $ProjectId"

# Execute Cloud Asset Inventory
gcloud asset list `
    "--scope=project=$ProjectId" `
    "--content-type=RESOURCE" `
    "--format=json" `
    1> $OutputFile `
    2> (Join-Path $OutputDir "error.log")

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Cloud Asset Inventory failed."

    Get-Content (Join-Path $OutputDir "error.log")
    exit 1
}

Write-Host "Inventory exported successfully."
Write-Host "File: $OutputFile"

# Count discovered resources
$Assets = @(Get-Content $OutputFile -Raw | ConvertFrom-Json)

Write-Host "Total resources: $($Assets.Count)"

# Display resource types
$Assets |
    Group-Object assetType |
    Sort-Object Name |
    Select-Object @{N="Asset Type";E={$_.Name}},
                  @{N="Count";E={$_.Count}} |
    Format-Table -AutoSize

