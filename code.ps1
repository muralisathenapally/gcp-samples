<#
.SYNOPSIS
    Lists GCP projects for specified Lab and Prod organizations and exports them to separate files.
.DESCRIPTION
    This script prompts for or uses predefined Organization IDs, queries GCP for all active 
    projects under each organization, and saves the output to Lab_Projects.txt and Prod_Projects.txt.
#>

# Define your Organization IDs (replace these placeholders with your actual GCP Organization IDs)
$LabOrgId  = "YOUR_LAB_ORG_ID"
$ProdOrgId = "YOUR_PROD_ORG_ID"

# Function to fetch and export projects for a given organization
function Get-GcpOrgProjects {
    param (
        [Parameter(Mandatory=$true)]
        [string]$OrgId,
        [Parameter(Mandatory=$true)]
        [string]$OutputFile
    )

    Write-Host "Fetching projects for Organization ID: $OrgId..." -ForegroundColor Cyan

    try {
        # Query GCP Resource Manager for projects under the organization
        # Formatting output to show Project ID, Name, and State
        $projectsJson = gcloud asset search-all-resources `
            --scope="organizations/$OrgId" `
            --asset-types="cloudresourcemanager.googleapis.com/Project" `
            --format="json"

        if (-not $projectsJson) {
            Write-Warning "No projects found or unable to access organization $OrgId."
            return
        }

        $projects = $projectsJson | ConvertFrom-Json

        # Extract relevant details and format nicely
        $projectList = foreach ($p in $projects) {
            [PSCustomObject]@{
                ProjectId   = $p.additionalAttributes.projectId
                ProjectName = $p.displayName
                State       = $p.state
            }
        }

        # Export to file
        $projectList | Format-Table -AutoSize | Out-String | Set-Content -Path $OutputFile
        Write-Host "Successfully exported projects to: $OutputFile" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to retrieve projects for Org ID $OrgId. Error: $_"
    }
}

# Run for Lab Organization
Get-GcpOrgProjects -OrgId $LabOrgId -OutputFile "Lab_Projects.txt"

# Run for Prod Organization
Get-GcpOrgProjects -OrgId $ProdOrgId -OutputFile "Prod_Projects.txt"

Write-Host "Process completed!" -ForegroundColor Yellow