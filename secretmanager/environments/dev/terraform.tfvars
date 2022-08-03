secret_details = {
  "my-secret" = {
    project_id       = "vm-test-nessus"
    secret_id        = "test-secret"
    secret           = "my-random-password-updated"
    secret_accessors = ["serviceAccount:test-svc@vm-test-nessus.iam.gserviceaccount.com"]
    replication      = {}
  }
}

