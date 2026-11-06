
param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectId
)

$ErrorActionPreference = "Continue"

$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$OutputDir = "gcp-inventory-$ProjectId-$Timestamp"

$DiscoveryDir = Join-Path $OutputDir "discovery"
$EnrichmentDir = Join-Path $OutputDir "enrichment"
$LogsDir = Join-Path $OutputDir "logs"

New-Item -ItemType Directory -Force -Path $DiscoveryDir, $EnrichmentDir, $LogsDir | Out-Null

$LogFile = Join-Path $LogsDir "discovery.log"

function Write-Log {
    param([string]$Message)

    $Line = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') $Message"
    Write-Host $Line
    Add-Content -Path $LogFile -Value $Line
}

function Invoke-Gcloud {
    param(
        [string]$Name,
        [string[]]$Arguments,
        [string]$Directory = $EnrichmentDir
    )

    $OutputFile = Join-Path $Directory "$Name.json"
    $ErrorFile = Join-Path $LogsDir "$Name.err"

    Write-Log "Collecting $Name"

    $Arguments += "--format=json"

    $Result = & gcloud @Arguments 2> $ErrorFile

    if ($LASTEXITCODE -eq 0) {
        $Result | Set-Content -Path $OutputFile -Encoding utf8
        Write-Log "SUCCESS: $Name"
    }
    else {
        Write-Log "WARNING: Failed to collect $Name"

        "[]" | Set-Content -Path $OutputFile -Encoding utf8
    }
}

# Verify gcloud
if (-not (Get-Command gcloud -ErrorAction SilentlyContinue)) {
    Write-Error "Google Cloud CLI is not installed."
    exit 1
}

Write-Log "Starting GCP resource discovery"
Write-Log "Project: $ProjectId"

# 1. Project information
Invoke-Gcloud "project" @("projects", "describe", $ProjectId) $DiscoveryDir

Invoke-Gcloud "enabled_apis" @(
    "services", "list",
    "--enabled",
    "--project=$ProjectId"
) $DiscoveryDir

Invoke-Gcloud "project_iam_policy" @(
    "projects", "get-iam-policy", $ProjectId
) $DiscoveryDir

# 2. Cloud Asset Inventory
Invoke-Gcloud "all_assets" @(
    "asset", "list",
    "--scope=projects/$ProjectId",
    "--content-type=resource"
) $DiscoveryDir

# Generate resource index and summary
$AssetFile = Join-Path $DiscoveryDir "all_assets.json"

try {
    $Assets = Get-Content $AssetFile -Raw | ConvertFrom-Json

    $Index = $Assets | ForEach-Object {
        [PSCustomObject]@{
            Name       = $_.name
            AssetType  = $_.assetType
            Location   = $_.resource.location
            Ancestors  = $_.ancestors
        }
    }

    $Index | ConvertTo-Json -Depth 100 |
        Set-Content (Join-Path $DiscoveryDir "resource_index.json") -Encoding utf8

    $Summary = $Assets |
        Group-Object assetType |
        ForEach-Object {
            [PSCustomObject]@{
                AssetType = $_.Name
                Count     = $_.Count
            }
        }

    $Summary | ConvertTo-Json -Depth 10 |
        Set-Content (Join-Path $DiscoveryDir "resource_summary.json") -Encoding utf8

}
catch {
    Write-Log "WARNING: Could not process asset inventory"
}

# 3. Compute Engine
Invoke-Gcloud "compute_instances" @("compute", "instances", "list", "--project=$ProjectId")
Invoke-Gcloud "compute_disks" @("compute", "disks", "list", "--project=$ProjectId")
Invoke-Gcloud "compute_zones" @("compute", "zones", "list", "--project=$ProjectId")

# 4. Networking
Invoke-Gcloud "vpc_networks" @("compute", "networks", "list", "--project=$ProjectId")
Invoke-Gcloud "subnets" @("compute", "networks", "subnets", "list", "--project=$ProjectId")
Invoke-Gcloud "firewall_rules" @("compute", "firewall-rules", "list", "--project=$ProjectId")
Invoke-Gcloud "routes" @("compute", "routes", "list", "--project=$ProjectId")
Invoke-Gcloud "routers" @("compute", "routers", "list", "--project=$ProjectId")
Invoke-Gcloud "forwarding_rules" @("compute", "forwarding-rules", "list", "--project=$ProjectId")
Invoke-Gcloud "backend_services" @("compute", "backend-services", "list", "--project=$ProjectId")
Invoke-Gcloud "health_checks" @("compute", "health-checks", "list", "--project=$ProjectId")
Invoke-Gcloud "vpn_tunnels" @("compute", "vpn-tunnels", "list", "--project=$ProjectId")

# 5. GKE
Invoke-Gcloud "gke_clusters" @("container", "clusters", "list", "--project=$ProjectId")

# 6. Cloud Run regions and services
Invoke-Gcloud "cloud_run_regions" @("run", "regions", "list")

$RegionsFile = Join-Path $EnrichmentDir "cloud_run_regions.json"

try {
    $Regions = Get-Content $RegionsFile -Raw | ConvertFrom-Json

    foreach ($Region in $Regions) {
        $Location = $Region.locationId

        if ($Location) {
            Invoke-Gcloud "cloud_run_$Location" @(
                "run", "services", "list",
                "--project=$ProjectId",
                "--region=$Location",
                "--platform=managed"
            )
        }
    }
}
catch {
    Write-Log "WARNING: Cloud Run region discovery failed"
}

# 7. Cloud Functions Gen2
Invoke-Gcloud "cloud_functions" @(
    "functions", "list",
    "--project=$ProjectId",
    "--gen2",
    "--regions=-"
)

# 8. Databases
Invoke-Gcloud "cloud_sql_instances" @("sql", "instances", "list", "--project=$ProjectId")
Invoke-Gcloud "bigquery_datasets" @("alpha", "bq", "ls", "--project_id=$ProjectId") 

# 9. Storage
Invoke-Gcloud "storage_buckets" @("storage", "buckets", "list", "--project=$ProjectId")
Invoke-Gcloud "filestore_instances" @("filestore", "instances", "list", "--project=$ProjectId")

# 10. Messaging
Invoke-Gcloud "pubsub_topics" @("pubsub", "topics", "list", "--project=$ProjectId")
Invoke-Gcloud "pubsub_subscriptions" @("pubsub", "subscriptions", "list", "--project=$ProjectId")
Invoke-Gcloud "scheduler_jobs" @("scheduler", "jobs", "list", "--project=$ProjectId", "--location=-")

# 11. Artifact Registry
Invoke-Gcloud "artifact_repositories" @(
    "artifacts", "repositories", "list",
    "--project=$ProjectId",
    "--location=all"
)

# 12. IAM and Security
Invoke-Gcloud "service_accounts" @("iam", "service-accounts", "list", "--project=$ProjectId")
Invoke-Gcloud "secret_manager_secrets" @("secrets", "list", "--project=$ProjectId")
Invoke-Gcloud "kms_locations" @("kms", "locations", "list")

# 13. Monitoring
Invoke-Gcloud "alert_policies" @("monitoring", "policies", "list", "--project=$ProjectId")
Invoke-Gcloud "notification_channels" @("monitoring", "channels", "list", "--project=$ProjectId")

Write-Log "========================================"
Write-Log "DISCOVERY COMPLETED"
Write-Log "Project: $ProjectId"
Write-Log "Output: $OutputDir"
Write-Log "========================================"
