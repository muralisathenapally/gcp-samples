
#!/usr/bin/env bash

set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_FILE="$ROOT/projects.txt"
OUTPUT="$ROOT/output"
LOG="$OUTPUT/discovery.log"

mkdir -p "$OUTPUT"

echo "=========================================="
echo "       GCP RESOURCE DISCOVERY"
echo "       VERBOSE MODE - LINUX"
echo "=========================================="

# Check gcloud
echo
echo "[INFO] Checking Google Cloud CLI..."

if ! command -v gcloud >/dev/null 2>&1; then
    echo "[ERROR] Google Cloud CLI not installed."
    exit 1
fi

echo "[SUCCESS] gcloud found: $(gcloud version | head -n 1)"

# Check authentication
echo
echo "[INFO] Checking authentication..."

ACCOUNT=$(gcloud auth list \
    --filter="status:ACTIVE" \
    --format="value(account)" 2>/dev/null)

if [[ -z "$ACCOUNT" ]]; then
    echo "[ERROR] No active Google Cloud account."
    echo "Run: gcloud auth login"
    exit 1
fi

echo "[SUCCESS] Authenticated as: $ACCOUNT"

# Check project file
echo
echo "[INFO] Checking projects.txt..."

if [[ ! -f "$PROJECT_FILE" ]]; then
    echo "[ERROR] projects.txt not found."
    exit 1
fi

# Load project IDs
PROJECTS=()

while IFS= read -r PROJECT || [[ -n "$PROJECT" ]]; do
    PROJECT="${PROJECT%$'\r'}"
    PROJECT="${PROJECT#"${PROJECT%%[![:space:]]*}"}"
    PROJECT="${PROJECT%"${PROJECT##*[![:space:]]}"}"

    [[ -z "$PROJECT" ]] && continue
    [[ "$PROJECT" == \#* ]] && continue

    PROJECTS+=("$PROJECT")

done < "$PROJECT_FILE"

TOTAL=${#PROJECTS[@]}

if [[ "$TOTAL" -eq 0 ]]; then
    echo "[ERROR] No project IDs found."
    exit 1
fi

echo "[SUCCESS] Total projects found: $TOTAL"

# Initialize logs and summary
echo "GCP Discovery Started: $(date)" > "$LOG"

echo "Project ID,API Enablement,Resources,Enabled Services,Status" \
    > "$OUTPUT/discovery_summary.csv"

# Process projects
CURRENT=0

for PROJECT in "${PROJECTS[@]}"; do

    CURRENT=$((CURRENT + 1))

    DIR="$OUTPUT/$PROJECT"

    mkdir -p "$DIR"

    API_STATUS="SUCCESS"
    RESOURCE_STATUS="SUCCESS"
    SERVICE_STATUS="SUCCESS"

    echo
    echo "=========================================="
    echo "[PROJECT $CURRENT/$TOTAL] $PROJECT"
    echo "=========================================="

    echo "[$(date)] Processing $PROJECT" >> "$LOG"

    # STEP 1: Enable API
    echo
    echo "[1/3] Enabling Cloud Asset Inventory API..."
    echo "[RUNNING] gcloud services enable cloudasset.googleapis.com"

    if gcloud services enable cloudasset.googleapis.com \
        --project="$PROJECT" \
        --quiet > "$DIR/api_enable.log" 2>&1; then

        echo "[SUCCESS] API enabled."
    else
        echo "[ERROR] API enablement failed."
        cat "$DIR/api_enable.log"
        API_STATUS="FAILED"
    fi

    # STEP 2: Resource discovery
    echo
    echo "[2/3] Discovering project resources..."
    echo "[RUNNING] Cloud Asset Inventory search"

    if gcloud asset search-all-resources \
        --scope="projects/$PROJECT" \
        --format=json \
        > "$DIR/resources.json" \
        2> "$DIR/resource_errors.log"; then

        RESOURCE_COUNT=$(
            grep -c '"assetType"' "$DIR/resources.json" || true
        )

        echo "[SUCCESS] Resource discovery completed."
        echo "[INFO] Approximate resources found: $RESOURCE_COUNT"

    else
        echo "[ERROR] Resource discovery failed."
        cat "$DIR/resource_errors.log"
        echo "[]" > "$DIR/resources.json"
        RESOURCE_STATUS="FAILED"
    fi

    # STEP 3: Enabled services
    echo
    echo "[3/3] Discovering enabled services..."
    echo "[RUNNING] gcloud services list"

    if gcloud services list \
        --enabled \
        --project="$PROJECT" \
        --format=json \
        > "$DIR/enabled_services.json" \
        2> "$DIR/service_errors.log"; then

        SERVICE_COUNT=$(
            grep -c '"config"' "$DIR/enabled_services.json" || true
        )

        echo "[SUCCESS] Service discovery completed."
        echo "[INFO] Approximate enabled APIs: $SERVICE_COUNT"

    else
        echo "[ERROR] Service discovery failed."
        cat "$DIR/service_errors.log"
        echo "[]" > "$DIR/enabled_services.json"
        SERVICE_STATUS="FAILED"
    fi

    # Final status
    if [[ "$API_STATUS" == "FAILED" ||
          "$RESOURCE_STATUS" == "FAILED" ||
          "$SERVICE_STATUS" == "FAILED" ]]; then
        STATUS="PARTIAL"
    else
        STATUS="SUCCESS"
    fi

    echo
    echo "[RESULT] Project: $PROJECT"
    echo "[RESULT] API: $API_STATUS"
    echo "[RESULT] Resources: $RESOURCE_STATUS"
    echo "[RESULT] Services: $SERVICE_STATUS"
    echo "[RESULT] Overall: $STATUS"

    echo "\"$PROJECT\",$API_STATUS,$RESOURCE_STATUS,$SERVICE_STATUS,$STATUS" \
        >> "$OUTPUT/discovery_summary.csv"

    echo "[$(date)] Completed $PROJECT - $STATUS" >> "$LOG"

done

echo
echo "=========================================="
echo "       DISCOVERY COMPLETED"
echo "=========================================="

echo "[INFO] Projects processed: $TOTAL"
echo "[INFO] Output directory: $OUTPUT"
echo "[INFO] Summary: $OUTPUT/discovery_summary.csv"
echo "[INFO] Log: $LOG"

echo "Completed: $(date)" >> "$LOG"
