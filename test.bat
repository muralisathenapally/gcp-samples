@echo off
for /f %%p in ('gcloud projects list --format="value(projectId)"') do (
    echo Checking %%p
    gcloud compute instances list --project=%%p | findstr "IP_ADDRESS"
)
