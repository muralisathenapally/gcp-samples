resource "google_project_service" "binauthz" {
  project = var.project_id
  service = "binaryauthorization.googleapis.com"
}


resource "google_binary_authorization_attestor" "attestor" {
  project = var.project_id
  name    = var.attestor_name
  attestation_authority_note {
    note_reference = google_container_analysis_note.note.name
    public_keys {
      id = data.google_kms_crypto_key_version.version.id
      pkix_public_key {
        public_key_pem      = data.google_kms_crypto_key_version.version.public_key[0].pem
        signature_algorithm = data.google_kms_crypto_key_version.version.public_key[0].algorithm
      }
    }
  }
}

data "google_kms_crypto_key_version" "version" {
  crypto_key = google_kms_crypto_key.crypto-key.id
}

resource "google_container_analysis_note" "note" {
  project = var.project_id
  name    = "${var.attestor_name}-note"
  attestation_authority {
    hint {
      human_readable_name = "Attestor Note"
    }
  }
}

resource "google_kms_crypto_key" "crypto-key" {
  name     = "${var.attestor_name}-key"
  key_ring = google_kms_key_ring.keyring.id
  purpose  = "ASYMMETRIC_SIGN"

  version_template {
    algorithm = "RSA_SIGN_PKCS1_4096_SHA512"
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "google_kms_key_ring" "keyring" {
  project  = var.project_id
  name     = "${var.attestor_name}-key-ring"
  location = "global"
}



resource "google_binary_authorization_policy" "binauthz_policy" {
  project = var.project_id

  dynamic "admission_whitelist_patterns" {
    for_each = var.allowed_patterns
    content {
      name_pattern = admission_whitelist_patterns.value
    }
  }
  default_admission_rule {
    enforcement_mode        = "ENFORCED_BLOCK_AND_AUDIT_LOG"
    evaluation_mode         = "REQUIRE_ATTESTATION"
    require_attestations_by = [google_binary_authorization_attestor.attestor.name]
  }
}