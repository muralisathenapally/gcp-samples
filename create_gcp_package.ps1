
$ErrorActionPreference = "Stop"

$root = Join-Path $PWD "GCP-Architecture-Discovery"
$zip = Join-Path $PWD "GCP-Architecture-Discovery.zip"

New-Item -ItemType Directory -Force -Path $root | Out-Null
New-Item -ItemType Directory -Force -Path "$root\output" | Out-Null

# 1. Project list
@"
# Client Name | GCP Project ID
Client1 | client1-prod-123
Client2 | client2-prod-456
Client3 | client3-prod-789
"@ | Set-Content "$root\projects.txt" -Encoding UTF8

# 2. Python discovery script
@'
import csv
import json
import re
import subprocess
from pathlib import Path
from collections import Counter, defaultdict
from datetime import datetime, timezone

BASE = Path(__file__).resolve().parent
OUTPUT = BASE / "output"


def run_gcloud(args):
    result = subprocess.run(
        ["gcloud"] + args,
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace"
    )

    if result.returncode != 0:
        raise RuntimeError(result.stderr.strip())

    return json.loads(result.stdout or "[]")


def safe_name(value):
    return re.sub(r"[^a-zA-Z0-9_-]", "_", value)


def read_projects():
    projects = []

    with open(BASE / "projects.txt", encoding="utf-8-sig") as f:
        for line in f:
            line = line.strip()

            if not line or line.startswith("#"):
                continue

            if "|" in line:
                client, project = line.split("|", 1)
                client = client.strip()
                project = project.strip()
            else:
                client = line
                project = line

            if client and project:
                projects.append((client, project))

    return projects


def discover(project):
    resources = run_gcloud([
        "asset", "search-all-resources",
        f"--scope=projects/{project}",
        "--format=json"
    ])

    services = run_gcloud([
        "services", "list",
        "--enabled",
        f"--project={project}",
        "--format=json"
    ])

    return resources, services


def category(asset_type):
    value = asset_type.lower()

    categories = {
        "Networking": ["network", "subnetwork", "firewall",
                       "forwardingrule", "backendservice",
                       "router", "address"],
        "Compute": ["compute.googleapis.com/instance",
                    "instancegroup", "disk"],
        "Containers": ["container.googleapis.com"],
        "Databases": ["sqladmin", "spanner", "firestore",
                      "bigtable"],
        "Storage": ["storage.googleapis.com"],
        "Serverless": ["run.googleapis.com",
                       "cloudfunctions.googleapis.com",
                       "appengine"],
        "Messaging": ["pubsub", "eventarc"],
        "Analytics": ["bigquery", "dataflow", "dataproc"]
    }

    for name, keywords in categories.items():
        if any(keyword in value for keyword in keywords):
            return name

    return "Other"


def make_mermaid(project, resources, output_file):
    groups = defaultdict(list)

    for item in resources:
        asset_type = item.get("assetType", "Unknown")
        name = item.get("displayName") or item.get("name", "Unknown")
        groups[category(asset_type)].append((name, asset_type))

    lines = [
        "flowchart TB",
        f'P["GCP Project: {project}"]'
    ]

    for group_number, (group, items) in enumerate(sorted(groups.items())):
        group_id = f"group{group_number}"

        lines.append(f'P --> {group_id}')
        lines.append(f'  subgraph {group_id}["{group}"]')

        for index, (name, asset_type) in enumerate(items):
            node = f"n{group_number}_{index}"

            # Escape characters that can interfere with Mermaid labels.
            label = str(name).replace('"', "'")
            label = label.replace("<", "&lt;").replace(">", "&gt;")
            label = label.replace("\n", " ")

            lines.append(f'    {node}["{label}"]')

        lines.append("  end")

    if not resources:
        lines.append('P --> EMPTY["No resources discovered"]')

    output_file.write_text(
        "\n".join(lines),
        encoding="utf-8"
    )


def save_csv(path, resources):
    fields = [
        "name", "assetType", "displayName",
        "location", "state", "createTime", "updateTime"
    ]

    with open(path, "w", newline="", encoding="utf-8-sig") as f:
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()

        for item in resources:
            writer.writerow({
                field: item.get(field, "")
                for field in fields
            })


def process(client, project):
    print(f"\nProcessing {client}: {project}")

    folder = OUTPUT / safe_name(client)
    folder.mkdir(parents=True, exist_ok=True)

    errors = []
    resources = []
    services = []

    try:
        resources, services = discover(project)
        print(f"Resources found: {len(resources)}")
        print(f"Enabled APIs: {len(services)}")
    except Exception as error:
        errors.append(str(error))
        print(f"Discovery error: {error}")

    inventory = {
        "client": client,
        "project_id": project,
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "resource_count": len(resources),
        "resources": resources
    }

    with open(folder / "inventory.json", "w", encoding="utf-8") as f:
        json.dump(inventory, f, indent=2)

    with open(folder / "enabled_services.json", "w", encoding="utf-8") as f:
        json.dump(services, f, indent=2)

    save_csv(folder / "inventory.csv", resources)

    counts = Counter(
        item.get("assetType", "Unknown")
        for item in resources
    )

    with open(folder / "resource_summary.csv",
              "w", newline="", encoding="utf-8-sig") as f:
        writer = csv.writer(f)
        writer.writerow(["Resource Type", "Count"])

        for name, count in sorted(counts.items()):
            writer.writerow([name, count])

    make_mermaid(
        project,
        resources,
        folder / "architecture.mmd"
    )

    (folder / "discovery_errors.txt").write_text(
        "\n".join(errors) if errors else "No errors",
        encoding="utf-8"
    )

    return {
        "client": client,
        "project_id": project,
        "resources": len(resources),
        "enabled_apis": len(services),
        "status": "SUCCESS" if not errors else "FAILED",
        "error": "; ".join(errors)
    }


def main():
    OUTPUT.mkdir(exist_ok=True)

    projects = read_projects()

    if not projects:
        print("Please add project IDs to projects.txt")
        return

    results = []

    for client, project in projects:
        try:
            results.append(process(client, project))
        except Exception as error:
            print(f"Failed: {error}")
            results.append({
                "client": client,
                "project_id": project,
                "resources": 0,
                "enabled_apis": 0,
                "status": "FAILED",
                "error": str(error)
            })

    with open(OUTPUT / "batch_summary.csv",
              "w", newline="", encoding="utf-8-sig") as f:
        writer = csv.DictWriter(
            f,
            fieldnames=[
                "client", "project_id", "resources",
                "enabled_apis", "status", "error"
            ]
        )
        writer.writeheader()
        writer.writerows(results)

    print("\n===================================")
    print("GCP DISCOVERY COMPLETED")
    print(f"Projects processed: {len(results)}")
    print(f"Output: {OUTPUT}")
    print("===================================")


if __name__ == "__main__":
    main()
'@ | Set-Content "$root\gcp_discovery.py" -Encoding UTF8

# 3. Windows execution file
@'
@echo off
title GCP Architecture Discovery
cd /d "%~dp0"

echo Starting GCP Architecture Discovery...
echo.

where gcloud >nul 2>&1
if errorlevel 1 (
    echo ERROR: Google Cloud CLI is not installed.
    pause
    exit /b 1
)

where python >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed.
    pause
    exit /b 1
)

gcloud auth list
echo.

python gcp_discovery.py

echo.
echo Check the output folder for results.
pause
'@ | Set-Content "$root\run_discovery.bat" -Encoding UTF8

# 4. Instructions
@'
GCP ARCHITECTURE DISCOVERY
==========================

REQUIREMENTS
------------
1. Windows 10 or Windows 11
2. Python 3.9 or later
3. Google Cloud CLI

INSTALLATION
------------
1. Install Python:
   https://www.python.org/downloads/

2. Install Google Cloud CLI:
   https://cloud.google.com/sdk/docs/install

3. Open Command Prompt.

4. Authenticate:
   gcloud auth login

5. Verify that you can access your client projects.

6. Open projects.txt and replace the sample project IDs.

PROJECT FILE FORMAT
-------------------
Client1 | client1-prod-123
Client2 | client2-prod-456

You can add as many projects as needed.

REQUIRED PERMISSIONS
--------------------
Cloud Asset Viewer
Service Usage Viewer

The Cloud Asset Inventory API must be enabled
in the project performing the discovery.

EXECUTION
---------
Double-click run_discovery.bat.

Alternatively:
python gcp_discovery.py

OUTPUT
------
Each client receives:

inventory.json
    Complete discovered resource metadata.

inventory.csv
    Resource-level inventory.

enabled_services.json
    Enabled GCP APIs.

resource_summary.csv
    Resource count by type.

architecture.mmd
    Mermaid architecture diagram.

discovery_errors.txt
    Errors encountered during discovery.

batch_summary.csv
    Overall batch execution summary.

VIEW MERMAID DIAGRAMS
---------------------
1. Open https://mermaid.live/
2. Open the client's architecture.mmd file.
3. Copy its contents into the Mermaid editor.
4. View and export as PNG or SVG.

IMPORTANT
---------
The diagram groups discovered resources by category.
It does not claim application-level connections.
Further service-specific discovery is needed to establish
actual network and application dependencies.
'@ | Set-Content "$root\README.txt" -Encoding UTF8

# 5. Create ZIP
if (Test-Path $zip) {
    Remove-Item $zip -Force
}

Compress-Archive -Path "$root\*" -DestinationPath $zip -Force

Write-Host ""
Write-Host "=========================================="
Write-Host "PACKAGE CREATED SUCCESSFULLY"
Write-Host "Folder: $root"
Write-Host "ZIP:    $zip"
Write-Host "=========================================="
