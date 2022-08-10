## next_rotation_time = # A timestamp in RFC3339 UTC "Zulu" format, with nanosecond resolution and up to nine fractional digits. 
# Examples: "2014-10-02T15:01:23Z" and "2014-10-02T15:01:23.045123456Z".

## rotation_period    = # Must be in seconds and at least 3600s (1h) and at most 3153600000s (100 years). 
#If rotationPeriod is set, next_rotation_time must be set. 
#next_rotation_time will be advanced by this period when the service automatically sends rotation notifications.

secret_details = {
  "my-secret" = {
    project_id       = "vm-test-nessus"
    secret_id        = "test-secret-new"
    secret           = "my-random-password-updated"
    secret_accessors = ["serviceAccount:test-svc@vm-test-nessus.iam.gserviceaccount.com"]
    replication      = {}
    rotation_details = [
      {
        next_rotation_time = "2022-08-11T09:00:00Z"
        rotation_period    = "2592000s"
      }
    ]
  }
}

