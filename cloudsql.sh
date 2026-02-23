#!/bin/bash

INPUT_FILE="projects_list.txt"
OUTPUT_FILE="cloudsql_instances.csv"

# CSV Header
echo "project_id,instance_name,database_version" > "$OUTPUT_FILE"

while read -r PROJECT_ID || [ -n "$PROJECT_ID" ]
do
  echo "Checking project: $PROJECT_ID"

  gcloud sql instances list \
    --project="$PROJECT_ID" \
    --format="csv[no-heading](NAME, DATABASE_VERSION)" 2>/dev/null | \
  while IFS= read -r LINE
  do
    if [[ -n "$LINE" ]]; then
      echo "$PROJECT_ID,$LINE" >> "$OUTPUT_FILE"
    fi
  done

done < "$INPUT_FILE"

echo "Inventory completed. Output saved to $OUTPUT_FILE"
