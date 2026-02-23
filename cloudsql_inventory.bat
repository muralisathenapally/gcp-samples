@echo off
setlocal enabledelayedexpansion

set INPUT_FILE=projects_list.txt
set OUTPUT_FILE=cloudsql_instances.csv

REM Add CSV Header
echo project_id,instance_name,database_version > %OUTPUT_FILE%

for /f "usebackq delims=" %%P in ("%INPUT_FILE%") do (
    echo Checking project: %%P

    for /f "usebackq delims=" %%L in (`
        gcloud sql instances list --project="%%P" --format="csv[no-heading](NAME, DATABASE_VERSION)" 2^>nul
    `) do (
        if not "%%L"=="" (
            echo %%P,%%L>>%OUTPUT_FILE%
        )
    )
)

echo Inventory completed. Output saved to %OUTPUT_FILE%
pause
