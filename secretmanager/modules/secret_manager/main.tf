locals {
  topic_id = (var.setup_secret_manager == "no" ? "projects/${var.project_id}/topics/${var.project_id}-notification-topic" : google_pubsub_topic.topic[0].id)
}

data "google_project" "project" {
  project_id = var.project_id
}

resource "google_project_service" "project_sa" {
  project = data.google_project.project.project_id
  service = "secretmanager.googleapis.com"
}
resource "google_project_service_identity" "sm_sa" {
  depends_on = [google_project_service.project_sa]
  provider   = google-beta
  project    = data.google_project.project.project_id
  service    = "secretmanager.googleapis.com"
}

resource "google_project_iam_member" "sm_sa_pubsub_publisher" {
  project = data.google_project.project.project_id
  role    = "roles/pubsub.publisher"
  member  = google_project_service_identity.sm_sa.member
}

resource "google_pubsub_topic" "topic" {
  count   = var.setup_secret_manager == "yes" ? 1 : 0
  name    = "${var.project_id}-notification-topic"
  project = var.project_id
}

# Create a slot for the secret in Secret Manager
resource "google_secret_manager_secret" "secret" {
  depends_on = [google_project_iam_member.sm_sa_pubsub_publisher, google_project_service_identity.sm_sa]
  project    = var.project_id
  secret_id  = var.secret_id
  labels     = var.labels
  topics {
    name = local.topic_id
  }

  dynamic "rotation" {
    for_each = var.rotation_details
    content {
      next_rotation_time = rotation.value["next_rotation_time"]
      rotation_period    = rotation.value["rotation_period"]
    }
  }

  replication {
    dynamic "user_managed" {
      for_each = length(var.replication) > 0 ? [1] : []
      content {
        dynamic "replicas" {
          for_each = var.replication
          content {
            location = replicas.key
            dynamic "customer_managed_encryption" {
              for_each = toset(compact([replicas.value != null ? lookup(replicas.value, "kms_key_name") : null]))
              content {
                kms_key_name = customer_managed_encryption.value
              }
            }
          }
        }
      }
    }
    auto {}
  }
  lifecycle { ignore_changes = [rotation] }
}

resource "google_secret_manager_secret_iam_member" "secret" {
  for_each  = toset(var.accessors)
  project   = var.project_id
  secret_id = google_secret_manager_secret.secret.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = each.value
}


