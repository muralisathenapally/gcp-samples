## next_rotation_time = # A timestamp in RFC3339 UTC "Zulu" format, with nanosecond resolution and up to nine fractional digits. 
# Examples: "2014-10-02T15:01:23Z" and "2014-10-02T15:01:23.045123456Z".

## rotation_period    = # Must be in seconds and at least 3600s (1h) and at most 3153600000s (100 years). 
#If rotationPeriod is set, next_rotation_time must be set. 
#next_rotation_time will be advanced by this period when the service automatically sends rotation notifications.

## While creating secret for service account json key, secret id should be in "{sa name}-{json-key}" fromat

secret_details = {
  "my-secret" = {
    project_id       = "vm-test-nessus"
    setup_secret_manager = "yes"
    secret_id        = "test-secret-new"
    secret_accessors = ["serviceAccount:test-svc@vm-test-nessus.iam.gserviceaccount.com"]
    replication      = {}
    rotation_details = [
      {
        next_rotation_time = "2022-10-01T03:05:00Z"
        rotation_period    = "2592000s"
      }
    ]
  },
  "my-secret-1" = {
    project_id       = "vm-test-nessus"
    setup_secret_manager = "no"
    secret_id        = "test-secret-new-1"
    secret_accessors = ["serviceAccount:test-svc@vm-test-nessus.iam.gserviceaccount.com"]
    replication      = {}
    rotation_details = [
      {
        next_rotation_time = "2022-10-01T03:05:00Z"
        rotation_period    = "2592000s"
      }
    ]
  },
   "my-secret-3" = {
    project_id       = "vm-test-nessus"
    setup_secret_manager = "yes"
    secret_id        = "test-svc-json-key" ## should be {sa name}-{json-key}
    secret_accessors = ["serviceAccount:test-svc@vm-test-nessus.iam.gserviceaccount.com"]
    replication      = {}
    rotation_details = [
      {
        next_rotation_time = "2022-10-01T03:05:00Z"
        rotation_period    = "3700s"
      }
    ]
  }
}
