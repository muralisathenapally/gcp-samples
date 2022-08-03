secret_details = {
  "my-secret" = {
    project_id       = "vm-test-nessus"
    secret_id        = "test-secret"
    secret           = "my-random-password-updated"
    secret_accessors = ["serviceAccount:test-svc@vm-test-nessus.iam.gserviceaccount.com"]
    replication      = {}
  },
  "my-secret-2" = {
    project_id       = "vm-test-nessus"
    secret_id        = "new-test-secret"
    secret           = "my-random-password-2"
    secret_accessors = ["serviceAccount:test-svc@vm-test-nessus.iam.gserviceaccount.com"]
    replication = {
      "us-east1" = {
        kms_key_name = "projects/vm-test-nessus/locations/us-east1/keyRings/secret-manager-cmek/cryptoKeys/my-cmek-key"
      }
    }
  }
}

