
#!/bin/bash

# Set your GCP Organization ID
ORG_ID="YOUR_ORG_ID"

# Output CSV file
OUTPUT_FILE="enabled_services_all_projects.csv"

# CSV header
echo '"Project ID","Project Name","Service Name"' > "$OUTPUT_FILE"

echo "Fetching projects from organization: $ORG_ID"

# Get all projects under the organization
gcloud projects list \
    --filter="parent.id=$ORG_ID" \
    --format="value(projectId,name)" |
while read -r PROJECT_ID PROJECT_NAME; do

    echo "Checking project: $PROJECT_ID"

    # Get enabled services for the project
    SERVICES=$(gcloud services list \
        --enabled \
        --project="$PROJECT_ID" \
        --format="value(config.name)" 2>/dev/null)

    if [ -z "$SERVICES" ]; then
        echo "No enabled services found or unable to access project: $PROJECT_ID"
        continue
    fi

    # Write services to CSV
    while IFS= read -r SERVICE; do
        [ -z "$SERVICE" ] && continue

        echo "\"$PROJECT_ID\",\"$PROJECT_NAME\",\"$SERVICE\"" >> "$OUTPUT_FILE"

    done <<< "$SERVICES"

done

echo ""
echo "Completed!"
echo "Results saved to: $OUTPUT_FILE"
